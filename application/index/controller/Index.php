<?php
namespace app\index\controller;

use app\common\lib\IAuth;
use app\common\model\Xarticles;
use app\common\model\XtodayWords;
use think\response\View;

class Index
{
    private $articleModel;
    private $todayWordModel;

    public function __construct()
    {
        $this->articleModel = new Xarticles();
        $this->todayWordModel = new XtodayWords();
    }

    /**
     * PC 端首页
     * @return View
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
     * @return View
     */
    public function article($id)
    {
        $articleInfo = $this->articleModel->getInfoByID(intval($id));
        if ($articleInfo){
            $data = [
                'name'=>'MoTzxx',
                'article'=>$articleInfo,
                'seo_conf' => [
                    'seo_title'=>$articleInfo['seo_title'],
                    'seo_keywords'=>$articleInfo['seo_keywords'],
                    'seo_description'=>$articleInfo['seo_description']]
            ];
            return view('article',$data);
        }else{
            return showMsg(1,'当前文章不存在！');
        }
    }


}
