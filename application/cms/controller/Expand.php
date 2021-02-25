<?php
/**
 * Created by PhpStorm.
 * User: moTzxx
 * Date: 2019/4/26
 * Time: 10:10
 */

namespace app\cms\controller;


use app\common\controller\CmsBase;
use app\common\lib\SpreadsheetService;
use app\common\model\Xmozxx;
use Godruoyi\Snowflake\Snowflake;
use PhpOffice\PhpSpreadsheet\Exception;
use think\cache\driver\Redis;
use think\Db;
use think\db\exception\DataNotFoundException;
use think\db\exception\ModelNotFoundException;
use think\exception\DbException;
use think\Request;
use think\response\View;
/**
 * 学习拓展类
 * Class Users
 * @package app\cms\Controller
 */
class Expand extends CmsBase
{
    protected $model;

    public function __construct()
    {
        parent::__construct();
        $this->model = new Xmozxx();
    }


    public function test(){

        //$tag = $this->testMysql();
        //echo 'Test';
        $arr = pathinfo("/wwsaswroot/include/page.class.php");
        $str = substr($arr['basename'],strrpos($arr['basename'],'.'));
        var_dump($arr);
        var_dump(strrpos($arr['basename'],'.'));
        var_dump($str);
    }

    function testMysql(){
        $randID = rand(100,200);
        $tag = Db::name('xtest_logs')
            ->where('open_id',$randID)->count('id');
        if ($tag){
            return 0;
        }else{
            $tag = Db::name('xtest_logs')
                ->insert(['open_id'=>$randID,'add_time'=>time()]);
            return $tag;
        }
    }
    /**
     * 算法入口
     */
    public function suanFa(){
        $snowflake = new Snowflake();
        //$id = $snowflake->id();

//        $this->str_rev('azzzxcvbn');
//
//        $arr = [11,21,27,3,20,18,24,12,9,32];
//        $ss = $this->insertSort2($arr);
//        var_dump($ss);
//
//        $arrx = [1,1];
//        for ($i = 2; $i<30;$i++){
//            $arrx[$i] = $arrx[$i-1]+$arrx[$i-2];
//        }
        //var_dump($arrx);

//
//        $xxxVal = $this->xxx(30);
//        var_dump($xxxVal);
//
//        $merArr = $this->array_mer([12,2],[44,3],[9,3]);
//        var_dump($merArr);
    }

    /**
     * 自定义实现 array_merge()功能
     * @return array
     */
    private function array_mer(){
        $newArr = [];
        $arrs = func_get_args();
        foreach ($arrs as $arr){
            if (is_array($arr)){
                foreach ($arr as $val){
                  $newArr[] = $val;
                }
            }
        }
        return $newArr;
    }
    /**
     * 不使用内置函数，实现 strrev()的效果
     * @param string $str
     * @return string
     */
    private function str_rev($str = ''){
        //TODO 获取字符串长度
        for ($i=0;true;$i++){
            if (!isset($str[$i])){
                break;
            }
        }
        $okStr = '';
        for ($j=$i-1;$j>=0;$j--){
            $okStr .= $str[$j];
        }
        return $okStr;
    }

    function xxx($index = 0){
        if ($index == 1||$index == 2){
            return 1;
        }else{
            return $this->xxx($index-1)+$this->xxx($index-2);
        }
    }
    public function quick_sort($arr) {
        $length = count($arr);
        //先判断是否需要继续进行 递归出口:数组长度为1，直接返回数组
        if(!is_array($arr)||$length <= 1) {return $arr;}
        //选择第一个元素作为基准
        $baseValue = $arr[0];
        //遍历除了标尺外的所有元素，按照大小关系放入两个数组内
        //初始化两个数组
        $leftArr = array();  //小于基准的
        $rightArr = array();  //大于基准的
        //使用for循环进行遍历，把选定的基准当做比较的对象
        for($i = 1; $i<$length; $i++) {
            if( $arr[$i] < $baseValue) {
                //放入左边数组
                $leftArr[] = $arr[$i];
            } else {
                //放入右边数组
                $rightArr[] = $arr[$i];
            }
        }
        //再分别对左边和右边的数组进行相同的排序处理方式递归调用这个函数
        $leftArr = $this->quick_sort($leftArr);
        $rightArr = $this->quick_sort($rightArr);
        //合并 左边 标尺 右边， 注意：array($baseValue),关联着重复数据
        return array_merge($leftArr, array($baseValue), $rightArr);
    }
    private function insertSort($arr){
        $len = count($arr);
        if ($len <= 1) {return $arr;}
        //先默认$array[0]，已经有序，是有序表
        for($i = 1;$i < $len;$i++){
            if ( $arr[$i-1] > $arr[$i]){
                $insertVal = $arr[$i]; //$insertVal是准备插入的数
                $insertIndex = $i - 1; //有序表中准备比较的数的下标
                while($insertIndex >= 0 && $insertVal < $arr[$insertIndex]){
                    $arr[$insertIndex + 1] = $arr[$insertIndex]; //将数组往后挪
                    $insertIndex--; //将下标往前挪，准备与前一个进行比较
                }
                if($insertIndex + 1 !== $i){
                    $arr[$insertIndex + 1] = $insertVal;
                }
            }
        }
        return $arr;
    }
    // 冒泡排序
    private function bubble_sort($arr){
        $len = count($arr);
        if ($len <= 1){return $arr;}
        for ($i = 0; $i < $len-1 ;$i++){
            for ($j = 0; $j < $len-$i-1;$j++){
                if ($arr[$j] > $arr[$j+1]){
                    $temp = $arr[$j];
                    $arr[$j] = $arr[$j+1];
                    $arr[$j+1] = $temp;
                }
            }
        }
        return $arr;
    }
    public function redisTest(){
        
        return view('redis_test');

        try{
//            $redis = new Redis();
//            $iphone = "15122786683";
//            $redis->set(config('redis_mz.prefix').$iphone,'这是咋了!!',config('redis_mz.expire'));
//            $ss = $redis->get(config('redis_mz.prefix').$iphone);

            $redis2 = new \Redis();
            $redis2->connect('192.168.80.224',6379);

//            $redis2->sAdd('123','1003','1013','1022','1001');
//            $redis2->sAdd('125','1007','1003','1022','1001');
//            $redis2->sInterStore('xxxx','123','125');
//            $redis2->sMembers('xxxx');

/*----------------------- 秒杀测试 ------------------------------------*/
            //初始化设置商品数量
            $redis2->set('kill_num',50);
            //剩余商品数
            $killNum = $redis2->get('kill_num');
            if ($killNum > 0){
                $redis2->watch('kill_num','kill_user');
                $redis2->multi();
                $redis2->decr('kill_num');
                $userID = rand(1111,9999);
                $redis2->rPush('kill_user',$userID);
                $redis2->exec();
            }else{
                return false;
            }
/*--------------------------------------------------------------------------*/

//            $redis2->sAdd('set-mz',rand(1,6));
//            $lockTag = 'lockTag';
//            $lockVal = 'HAHHHA';
//            if ($redis2->set($lockTag,$lockVal,['nx','ex'=> 30])){
//                //$redis2->setex($lockTag,22,'');
//                //$redis2->expire($lockTag,20);
//                //执行业务
//                //echo $lockTag.'--- oK'.PHP_EOL;
//                //处理完成后
//                if($redis2->get($lockTag) == $lockVal){
//                    //此时还存在
//                    //$redis2->del($lockTag);
//                    //echo 'del--oK'.PHP_EOL;
//                }
//            }else{
//                //echo $lockTag.'--- Fail'.PHP_EOL;
//            }
//
//            // 向队列左侧加入元素
//            $redis2->lPush('lists', 'Z');
//            $redis2->lPush('lists', 'z');
//             //向队列右侧加入元素
//
//             //从左侧出队一个元素（获取并删除）
//            $x = $redis2->lPop('lists');
//            echo $x . PHP_EOL;
//             //从右侧出队一个元素（获取并删除）
//            $z = $redis2->rPop('lists');
//            echo $z . PHP_EOL;
//
//            $length = $redis2->lLen('lists');
//
//            $lists = $redis2->lRange('lists', 0, $length - 1);
//            dump($lists);


//            $redis2->zAdd('lb',23,'mark');
//            $redis2->zAdd('lb',32,'Niya');
//            $redis2->zAdd('lb',55,'Wuli');
//            $redis2->zAdd('lb',32,'Moqi');
//            $redis2->zAdd('lb',63,'Niya');

//            $score = $redis2->zScore('lb','Wuli');
//            var_dump($score);
//            $rank = $redis2->zRevRank('lb','mark');
//            var_dump($rank);
//            $range = $redis2->zRangeByScore('lb',0,2,array('withscores' => TRUE));
//            //$range = $redis2->zRevRange('lb',0,2,true);
//            var_dump($range);

//
//            $userID = 225;
//            $goodsSkuID = 6;
//            $goodsNum = 5;
//            $cartName = 'mall-cart-'.$userID;
//            //$tag = (new Xorders())->cartOpRedis('add',$userID,$goodsSkuID,$goodsNum);
//            //var_dump($tag);
//
//
//            //$cartList = (new Xorders())->cartOpRedis('list',$userID,null,null,'12,13');
//            //var_dump($cartList);
//            $count = $redis2->hLen($cartName);
//            //var_dump($count);
//
//
        }catch (\RedisException $exception){
            echo $exception->getMessage();
        }


        return view('redis_test');
    }
    /**
     * Excel 文件操作接口
     * @param Request $request
     * @return View|void
     * @throws Exception
     * @throws \PhpOffice\PhpSpreadsheet\Writer\Exception
     */
    public function opExcel(Request $request){
        if ($request->isGet()){
            try {
                $loginList = (new Xmozxx())->getExcelTestData();
                return view('op_excel',['loginList' => $loginList]);
            } catch (DataNotFoundException $e) {
                $message = $e->getMessage();
            } catch (ModelNotFoundException $e) {
                $message = $e->getMessage();
            } catch (DbException $e) {
                $message = $e->getMessage();
            }

            return showMsg(0,$message);
        }else{
            $opTag = $request->post('op_tag','up');

            if ($opTag == 'down'){
                $header = ['商品名称','缩略图','产地','售价','状态'];
                $opData = (new Xmozxx())->getExcelTestData();
                //此时去下载 Excel文件
                (new SpreadsheetService())->outputDataToExcelFile($header,$opData,"哎呦喂-数据表");
            }else{
                $file = $request->file('file');
                $info = $file->move('upload');
                if ($info){
                    //绝对路径，把反斜杠(\)替换成斜杠(/) 因为在 windows下上传路是反斜杠径
                    $file_real_path = str_replace("\\", "/", $info->getRealPath());
                    unset($info); //释放内存,也可使用 $info = null;(写在这里最好，后面总是不执行！！)
                    $opRes = (new Xmozxx())->importExcelData($file_real_path);
                    //TODO 操作完成后，删除文件
                    deleteServerFile($file_real_path);
                }else{
                    $opRes['status'] = 0;
                    $opRes['message'] = "文件上传失败 ".$file->getError();
                }
                return showMsg($opRes['status'],$opRes['message']);
            }
        }
    }


    /**
     * React 学习页
     * @param Request $request
     * @return View|void
     */
    public function react(Request $request){
        if ($request->isPost()) {
            return showMsg(1, 'success', []);
        } else {
            // 也可展示 react_hook 页面
            return view('react');
        }
    }

    public function shtmlx(){

        var_dump(__FILE__);
        return $this->fetch();
    }
}