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


        $this->testSearch();

        //echo 'TEST';
        //$tag = $this->testMysql();
        //$this->testSQL();
        //var_dump($tag);

    }
    public function testSearch(){
        $xsService = new XunsearchService();
        try {
            $message = $xsService::search('我找原味的瓜子和爆款蓝牙', 'goods_sku', true);
        } catch (\XSException $e) {
            $message = $e->getMessage();
        }
        echo '<br>';
        var_dump($message);
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