<?php


namespace app\common\model;


use app\common\lib\SpreadsheetService;
use PDOStatement;
use think\Collection;
use think\Db;
use think\db\exception\DataNotFoundException;
use think\db\exception\ModelNotFoundException;
use think\exception\DbException;

class Xmozxx
{
    /**
     * 获取开发日志
     * @param null $currTag 1：为最新日志  null:所有的日志
     * @return array|PDOStatement|string|Collection|\think\model\Collection
     * @throws DataNotFoundException
     * @throws ModelNotFoundException
     * @throws DbException
     */
    public function getDevLogList($currTag = null){
        $count_date = Db::name('xproDevLogs')
            ->field("date_format(log_time,'%Y-%m-%d') date")
            ->group('date')
            ->count('id');

        $limit = $currTag ? "0,3" : "3,$count_date";

        $res = Db::name('xproDevLogs')
            ->field("date_format(log_time,'%Y-%m-%d') date,min(id) min_id")
            ->group('date')
            ->order(['date'=>'desc','min_id'=>'desc'])
            ->limit($limit)
            ->select();

        foreach ($res as $key => $value){
            $date = $value['date'];
            $logItem = Db::name('xproDevLogs')
                ->field("log_content,date_format(log_time,'%Y-%m-%d') date")
                ->where("log_time",'like',$date."%")
                ->order(['date'=>'desc','id'=>'desc'])
                ->select();
            $res[$key]['content'] = $logItem;
        }
        return isset($res)?$res:[];
    }

    /**
     * 获取测试 Excel 数据表中的数据
     * @return array|PDOStatement|string|Collection|\think\model\Collection
     * @throws DataNotFoundException
     * @throws DbException
     * @throws ModelNotFoundException
     */
    public function getExcelTestData(){
        $loginList = Db::name('xop_excel')
            ->field('goods_name,thumbnail,place,reference_price,status')
            ->select();

        foreach ($loginList as &$vo){
            $status = $vo['status'] ;
            //-1：删除 0：待上架 1：已上架 2：预售
            switch ($status){
                case -1:
                    $vo['status'] = "删除";
                    break;
                case 0:
                    $vo['status'] = "待上架";
                    break;
                case 1:
                    $vo['status'] = "已上架";
                    break;
                case 2:
                    $vo['status'] = "预售";
                    break;
            }
        }
        return $loginList;
    }

    /**
     * 导入 excel 表中的数据
     * @param $file_real_path
     * @return array
     */
    public function importExcelData($file_real_path){
        $opRes = (new SpreadsheetService())->readExcelFileToArray($file_real_path,"A2");
        //TODO 根据返回来到数据数组，进行数据向数据库的插入或其他操作 ...
        if (isset($opRes['data'])){
            $resultArr = [];
            foreach ($opRes['data'] as $key => $value) {
                $resultArr[$key]['goods_name'] = isset($value[0])?$value[0]:'';
                $resultArr[$key]['thumbnail'] = isset($value[1])?$value[1]:'';
                $resultArr[$key]['place'] = isset($value[2])?$value[2]:'';
                $resultArr[$key]['reference_price'] = isset($value[3])?$value[3]:'';
                $resultArr[$key]['updated_at'] = date("Y-m-d H:i:s",time());
            }
            /**
             * TODO 此时进行数据表记录的遍历插入操作即可
             * 因为数据量较大，建议使用批量插入的方式,以我的业务需求，代码举例如下：
             */
            Db::name('xop_excel')->data($resultArr)->limit(10)->insertAll();
            unset($resultArr);
        }
        return ['status' => $opRes['status'],'message'=>$opRes['message']];
    }

    /**
     * 一个使用 Redis（Hash） 记录购物车操作信息的定义方法
     * @param string $opTag     操作标识,分为 ：'add'/'list'/'del'
     * @param int $userID       用户ID
     * @param int $goodsSkuID   商品SKU_ID
     * @param int $goodsNum     商品数量
     * @param string $sku_ids   商品SKU_ID组合，一般用于下订单逻辑，以逗号隔开
     * @return array|bool|int
     */
    public function cartOpRedis($opTag = 'add',$userID = 0,$goodsSkuID = 0,$goodsNum = 1,$sku_ids = '' ){
        $redis = new \Redis();
        $redis->connect('127.0.0.1',6379);
        $cartName = 'mall-cart-'.$userID;
        switch ($opTag){
            case 'add':
                //数量增加
            case 'sub':
                //数量减少
                //此处为 添加购物车操作逻辑
                $cartData = $this->updateCartRedis($redis,$opTag,$cartName,$goodsSkuID,$goodsNum);
                try {
                    if ($cartData['num'] > 0){
                        $res = $redis->hSet($cartName,$goodsSkuID,json_encode($cartData,JSON_UNESCAPED_UNICODE));
                    }else{
                        $res = [];
                    }
                }catch (\Exception $e){
                    return false;
                }
                break;
            case 'list':
                //获取 Redis 中存储的购物车数据
                //注意：商品的价格一般不存储，取用时，查询数据库对应即时数据，避免争执
                if ($sku_ids){
                    //如果当前指定了 SKU_ID,比如下单前的商品选择
                    $arrSkuIDs = explode(',',$sku_ids);
                    $cartList = $redis->hMGet($cartName,$arrSkuIDs);
                    if (in_array(false,array_values($cartList))){
                        return [];
                    }
                }else{
                    $cartList = $redis->hGetAll($cartName);
                }
                $cartResult = [];
                foreach ($cartList as $key => $v){
                    //TODO 此处做数据处理，举例如下：
                    $v = json_decode($v,true);
                    $v['sku_id'] = $key;
                    $v['price'] = 22.50;
                    $cartResult[] = $v;
                }
                if (!empty($cartResult)){
                    //TODO 进行数据按照操作时间先后排序
                    $cartResult = arrSortByKey($cartResult,'create_time');
                }
                $res = $cartResult ? $cartResult : [];
                break;
            case 'del':
                //购物车数据删除操作
                $res = $redis->hDel($cartName,$goodsSkuID);
                break;
            default:
                $res = false;
                break;
        }
        $redis->close();
        return $res;
    }

    /**
     * 购物车 add/sub 处理操作
     * @param null $redis
     * @param string $opTag
     * @param string $cartName
     * @param int $goodsSkuID
     * @param int $goodsNum
     * @return array
     */
    public function updateCartRedis($redis = null,$opTag = 'add',$cartName = '',$goodsSkuID = 0,$goodsNum = 1){

        $cartData = [
            'title' => '百斯特商品',
            'num' => $goodsNum,
            'image' => '/upload/xxx.png',
            'create_time' => time()
        ];
        $cartGet = $redis->hGet($cartName,$goodsSkuID);
        //注意商品数量的变化
        if ($cartGet){
            $cartArr = json_decode($cartGet,true);
            if ($opTag === 'add'){
                $cartData['num'] = intval($cartArr['num']+$goodsNum);
            }else{
                //$opTag == 'sub'
                $opNum = $cartArr['num']-$goodsNum;
                $opNum = ($opNum > 0 ) ? $opNum : 0;
                $cartData['num'] = $opNum;
                if ($opNum == 0){
                    $redis->hDel($cartName,$goodsSkuID);
                    $cartData = [];
                }
            }
        }else{
            if ($opTag === 'sub'){
                $cartData = [];
            }
        }
        return isset($cartData) ? $cartData:[];
    }
}