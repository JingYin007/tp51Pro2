<?php

namespace app\cms\controller;

use app\common\controller\CmsBase;
use app\common\model\XtodayWords;
use think\Request;
use think\response\View;

/**
 * 今日赠言类
 * Class TodayWord
 * @package app\cms\Controller
 */
class TodayWord extends CmsBase
{
    protected $model;

    public function __construct()
    {
        parent::__construct();
        $this->model = new XtodayWords();
    }

    /**
     * 今日赠言 列表首页
     * @param Request $request
     * @return View|void
     */
    public function index(Request $request)
    {
        $search = $request->param('str_search');
        $curr_page = $request->param('curr_page', 1);
        if ($request->isPost()) {
            //TODO ajax 获取新一页的赠言数据
            $list = $this->model->getTodayWordsForPage($curr_page, $this->page_limit,$search);
            showMsg(1, 'success', $list);
        } else {
            $list = $this->model->getTodayWordsForPage($curr_page, $this->page_limit, $search);
            $record_num = $this->model->getTodayWordsCount($search);
            return view('index',
                [
                    'todayWords' => $list,
                    'search' => $search,
                    'record_num' => $record_num,
                    'page_limit' => $this->page_limit,
                ]);
        }
    }

    /**
     * 增加新赠言
     * @param Request $request
     * @return View|void
     */
    public function add(Request $request)
    {
        if ($request->isPost()) {
            $input = $request->post();
            $opRes = $this->model->addTodayWord($input);
            showMsg($opRes['tag'], $opRes['message']);
        } else {
            return view('add');
        }
    }

    /**
     * 编辑新赠言
     * @param Request $request
     * @param $id 赠言ID
     * @return View|void
     */
    public function edit(Request $request, $id)
    {
        $opID = intval($id);
        if ($request->isPost()) {
            //TODO 修改对应的菜单
            $input = $request->post();
            $opRes = $this->model->editTodayWord($opID, $input);
            showMsg($opRes['tag'], $opRes['message']);
        } else {
            $todayWordData = $this->model->getTodayWord($opID);
            return view('edit', [
                'todayWordData' => $todayWordData
            ]);
        }
    }
}
