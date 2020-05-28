<?php

namespace app\cms\controller;

use app\common\controller\CmsBase;
use app\common\model\Xarticles;
use think\Request;

/**
 * 文章管理类
 * Class Article
 * @package app\cms\Controller
 */
class Article extends CmsBase
{
    protected $model;

    public function __construct()
    {
        parent::__construct();
        $this->model = new Xarticles();
    }

    /**
     * 获取文章列表数据
     * @param Request $request
     * @return \think\response\View
     */
    public function index(Request $request)
    {
        $curr_page = $request->param('curr_page', 1);
        $search = $request->param('str_search');
        if ($request->isPost()) {
            $list = $this->model->getCmsArticlesForPage($curr_page, $this->page_limit, $search);
            return showMsg(1, 'success', $list);
        } else {
            $articles = $this->model->getCmsArticlesForPage($curr_page, $this->page_limit, $search);
            $record_num = $this->model->getCmsArticlesCount($search);
            $data = [
                'articles' => $articles,
                'search' => $search,
                'record_num' => $record_num,
                'page_limit' => $this->page_limit,
            ];
            return view('index', $data);
        }
    }

    /**
     * 添加文章
     * @param Request $request
     * @return \think\response\View|void
     */
    public function add(Request $request)
    {
        if ($request->isPost()) {
            $input = $request->param();
            $opRes = $this->model->addArticle($input);
            return showMsg($opRes['tag'], $opRes['message']);
        } else {
            return view('add');
        }
    }

    /**
     * 更新文章数据
     * @param Request $request
     * @param $id 文章ID
     * @return \think\response\View|void
     */
    public function edit(Request $request, $id)
    {
        if ($request->isPost()) {
            $opRes = $this->model->updateCmsArticleData($request->post(),$id);
            return showMsg($opRes['tag'], $opRes['message']);
        } else {
            $article = $this->model->getCmsArticleByID($id);
            $comments = [];
            $data =
                [
                    'article' => $article,
                    'comments' => $comments,
                ];
            return view('edit', $data);
        }
    }

    /**
     * ajax 更改文章推荐标记
     * @param Request $request
     */
    public function ajaxForRecommend(Request $request)
    {
        $opRes = $this->model->updateForRecommend($request->post('article_id'), $request->post('okStatus'));
        return showMsg($opRes['tag'], $opRes['message']);
    }

    /**
     * 文章操作日志列表
     * @param $id
     * @return \think\response\View
     */
    public function viewLogs($id){
        $logs = getCmsOpViewLogs($id,'ARTICLE');
        return view('view_logs',['logs' => $logs]);
    }
}
