<?php
namespace app\index\controller;

use app\common\controller\Base;
use app\common\lib\XunsearchService;
use app\common\model\Xarticles;
use app\common\model\XtodayWords;
use think\Db;
use think\response\View;

class Index extends Base
{
    private $articleModel;
    private $todayWordModel;

    public function __construct()
    {
        parent::__construct();
        $this->articleModel = new Xarticles();
        $this->todayWordModel = new XtodayWords();
    }

    /**
     * PC 端首页 D:\mySoft\cygwin64
     * @return View D:\mySoft\cygwin64\cydown
     */
    public function index()
    {
        $todayWordsData = $this->todayWordModel->getTodayWord();
        $articleList = $this->articleModel->getArticleList();
        $recommendList = $this->articleModel->getRecommendList();
        $photos = $this->articleModel->getPhotos();

        $data = [
            'name'=>'MoTzxx',
            'list' => $articleList,
            'todayWord'=>$todayWordsData,
            'recommendList' => $recommendList,
            'photos' => $photos
        ];
        return view('index',$data);
    }

    /**
     * 文章列表页
     * @return View
     */
    public function review(){

        $articleList = $this->articleModel->getArticleList();
        $data = [
            'name'=>'MoTzxx',
            'List'=>$articleList,
        ];
        return view('review',$data);
    }
    public function contact(){

        return view('contact');
    }

    /**
     * 文章详情页
     * @param $id 文章ID
     * @return View|void
     */
    public function article($id)
    {
        $articleInfo = $this->articleModel->getInfoByID(intval($id));
        if ($articleInfo){
            $data = [
                'name' => 'MoTzxx',
                'article' => $articleInfo,
                'seo_conf' => [
                    'seo_title' => $articleInfo['seo_title'],
                    'seo_keywords' => $articleInfo['seo_keywords'],
                    'seo_description' => $articleInfo['seo_description']]
            ];
            return $this->staticFetch(0,'',$data);
            return view('article',$data);
        }else{
            return showMsg(1,'当前文章不存在！');
        }
    }

    public function test(){

        return 1;

        $tag = $this->testFastSale();
        var_dump($tag);
        //echo 'TEST';
        //$tag = $this->testMysql();
        //$this->testSQL();
        //var_dump($tag);

    }

   public function testFastSale(){
       $redis2 = new \Redis();
       $redis2->connect('192.168.80.224',6379);

       $killNumSet = 100;
       //初始化设置秒杀商品数量
       //$redis2->set('kill_num',$killNumSet);

       //模拟发起请求的用户ID
       $userID = rand(1111,2222);

       $killNum = $redis2->get('kill_num');
       if ($killNum > 0){
           //TODO 此时，还有商品可进行抢购
           if ($redis2->sIsMember('kill_user_que',$userID)){
               //TODO 此时说明用户已经抢到了
               $message = 'Sorry，一个账号只能抢一件！';
           }else{
               $countCanBuyer = $redis2->sCard('kill_user_que');
               if ($countCanBuyer >= $killNumSet){
                   $message = 'Sorry，当前排队已满员！';
               }else{
                   $redis2->watch('kill_num','kill_user','kill_user_que');
                   $redis2->multi(); //开启事务
                   $redis2->sAdd('kill_user_que',$userID); //加入集合
                   $redis2->decr('kill_num'); //商品数量减一
                   $redis2->rPush('kill_user',$userID);//将用户有序的压入队列
                   $redis2->exec(); //执行事务
                   $message = "恭喜，抢购成功！";
               }
           }
       }else{
           $message = "Sorry，商品已售完！";
       }
       return $message;
   }

    public function testMysql(){
        $randID = rand(300,400);
        $exitTag = Db::name('xtest_logs')
            ->where('open_id',"$randID")->count('id');
        if ($exitTag){
            return 0;
        }else{
            $op_id = Db::name('xtest_logs')
                ->insertGetId(['open_id'=>"$randID",'add_time'=>time()]);
            try{
                //TODO 查询数据库里是否存在这个新加入的 记录
                $count = Db::name('xtest_logs')
                    ->where('id',intval($op_id))
                    ->count('id');
                //判断是否存在 $op_id 的记录，都更新到 name 字段
                $msg = ($count>0) ? $op_id: "--$count--";
            }catch (\Exception $e){
                $msg = substr($e->getMessage(),0,300);
            }
            Db::name('xtest_logs')
                ->where('id',$op_id)
                ->update(['name' => $msg]);
            return 1;
        }
    }

    function testSQL($id = 0){
        $randID = rand(0,10000000);
        $op_id = Db::name('xtest_logs')
            ->insertGetId(['open_id'=>"$randID",'add_time'=>time()]);

    }
}