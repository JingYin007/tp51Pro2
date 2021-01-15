<?php
namespace app\index\controller;

use app\common\controller\Base;
use app\common\model\Xmozxx;
use think\Controller;
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
        echo 'TEST';
        $tag = $this->testMysql();
         var_dump($tag);

    }
    function testMysql(){
        $randID = rand(300,400);
        $tag = Db::name('xtest_logs')
            ->where('open_id',$randID)->count('id');
        if ($tag){
            return 0;
        }else{
            $tag = Db::name('xtest_logs')
                ->insertGetId(['open_id'=>$randID,'add_time'=>time()]);
            $this->testPXC($tag);
            return $tag;
        }
    }

    function testPXC($id = 0){
        $tag = Db::name('xtest_logs')
            ->where('id',$id)->count('id');
        if ($tag){
            Db::name('xtest_logs')
                ->where('id',$id)
                ->update(['name' => $id]);
        }
        return $tag;
    }
}
