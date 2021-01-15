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

        $tag = $this->testMysql();
        //var_dump($tag);
        //echo 'Test';
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
        var_dump($okStr);
        return $okStr;
    }

    function xxx($index = 0){
        if ($index == 1||$index == 2){
            return 1;
        }else{
            return $this->xxx($index-1)+$this->xxx($index-2);
        }
    }

    private function insertSort2($arr){
        $len = count($arr);
        if ($len <= 1) {return $arr;}
        //先默认$array[0]，已经有序，是有序表
        for($i = 1;$i < $len;$i++){
            if ($arr[$i] < $arr[$i-1]){
                $insertVal = $arr[$i]; //$insertVal是准备插入的数
                //$j 有序表中准备比较的数的下标
                //$j-- 将下标往前挪，准备与前一个进行比较
                for ($j = $i-1;$j >= 0 && $insertVal < $arr[$j];$j--){
                    $arr[$j+1]= $arr[$j];//将数组往后挪
                }
                $arr[$j + 1] = $insertVal;
            }
        }
        return $arr;
    }
    // 冒泡排序
    private function buble_sore($arr){
        $len = count($arr);
        if ($len < 2){return $arr;}
        for ($i = 0; $i < $len ;$i++){
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

//        try{
//            $redis = new Redis();
//            $iphone = "15122786683";
//            $redis->set(config('redis_mz.prefix').$iphone,'这是咋了!!',config('redis_mz.expire'));
//
//            $ss = $redis->get(config('redis_mz.prefix').$iphone);
//            //var_dump($ss);
//
            $redis2 = new \Redis();
            $redis2->connect('127.0.0.1',6379);

            //$redis2->sAdd('123','1003','1013','1022','1001');
           // $redis2->sAdd('125','1007','1003','1022','1001');
            $redis2->sInterStore('xxxx','123','125');

            $redis2->sMembers('xxxx');
            var_dump($redis2->sMembers('xxxx'));


//            $redis2->sAdd('set-mz',rand(1,6));
//
//
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
//            //$redis2->lPush('lists', 'Z');
//            //$redis2->lPush('lists', 'z');
//            // 向队列右侧加入元素
//
//            // 从左侧出队一个元素（获取并删除）
//            //$x = $redis2->lPop('lists');
//            //echo $x . PHP_EOL;
//            // 从右侧出队一个元素（获取并删除）
//            //$z = $redis2->rPop('lists');
//            //echo $z . PHP_EOL;
//
//            //$length = $redis2->lLen('lists');
//            //$lists = $redis2->lRange('lists', 0, $length - 1);
//            //dump($lists);


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
//        }catch (\RedisException $exception){
//            echo $exception->getMessage();
//        }

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