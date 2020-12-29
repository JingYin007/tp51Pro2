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
        $snowflake = new Snowflake();
        //$id = $snowflake->id();

        echo 'Test';
    }

    public function redisTest(){

        try{
            $redis = new Redis();
            $iphone = "15117972683";
            $redis->set(config('redis_mz.prefix').$iphone,'这是咋了!!',config('redis_mz.expire'));

            $ss = $redis->get(config('redis_mz.prefix').$iphone);
            //var_dump($ss);

            $redis2 = new \Redis();
            $redis2->connect('127.0.0.1',6379);
            $redis2->sAdd('set-mz',rand(1,6));


            $lockTag = 'lockTag';
            $lockVal = 'HAHHHA';
            if ($redis2->set($lockTag,$lockVal,['nx','ex'=> 30])){
                //$redis2->setex($lockTag,22,'');
                //$redis2->expire($lockTag,20);
                //执行业务
                //echo $lockTag.'--- oK'.PHP_EOL;
                //处理完成后
                if($redis2->get($lockTag) == $lockVal){
                    //此时还存在
                    //$redis2->del($lockTag);
                    //echo 'del--oK'.PHP_EOL;
                }
            }else{
                //echo $lockTag.'--- Fail'.PHP_EOL;
            }

            // 向队列左侧加入元素
            //$redis2->lPush('lists', 'Z');
            //$redis2->lPush('lists', 'z');
            // 向队列右侧加入元素

            // 从左侧出队一个元素（获取并删除）
            //$x = $redis2->lPop('lists');
            //echo $x . PHP_EOL;
            // 从右侧出队一个元素（获取并删除）
            //$z = $redis2->rPop('lists');
            //echo $z . PHP_EOL;

            //$length = $redis2->lLen('lists');
            //$lists = $redis2->lRange('lists', 0, $length - 1);
            //dump($lists);


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


            $userID = 225;
            $goodsSkuID = 6;
            $goodsNum = 5;
            $cartName = 'mall-cart-'.$userID;
            //$tag = (new Xmozxx())->cartOpRedis('add',$userID,$goodsSkuID,$goodsNum);
            //var_dump($tag);


            $cartList = (new Xmozxx())->cartOpRedis('list',$userID,null,null,'12,13');
            var_dump($cartList);
            $count = $redis2->hLen($cartName);
            var_dump($count);


        }catch (\RedisException $exception){
            echo $exception->getMessage();
        }
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