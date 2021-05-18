<?php

namespace app\cms\Controller;

use app\common\controller\CmsBase;
use app\common\model\Xcategorys;
use think\Request;
use think\response\View;

class Category extends CmsBase
{
    protected $model;

    public function __construct()
    {
        parent::__construct();
        $this->model = new Xcategorys();
    }

    /**
     * 获取分类列表数据
     * @param Request $request
     * @return View|void
     */
    public function index(Request $request)
    {
        $curr_page = $request->post('curr_page', 1);
        $search = $request->param('str_search');
        $catType = $request->param("CatType","F");
        if ($request->isGet()) {
            $list = $this->model->getCmsCategoryForPage($curr_page, $this->page_limit, $search, $catType);
            $record_num = $this->model->getCmsCategoryCount($search, $catType);
            $data = [
                'list' => $list,
                'search' => $search,
                'cat_type' => $catType,
                'record_num' => $record_num,
                'page_limit' => $this->page_limit,
            ];
            return view('index', $data);
        } else {
            $list = $this->model->getCmsCategoryForPage($curr_page, $this->page_limit, $search, $catType);
            showMsg(1, 'success', $list);
        }
    }

    /**
     * 添加产品分类
     * @param Request $request
     * @return View|void
     */
    public function add(Request $request)
    {
        if ($request->isPost()) {
            $input = $request->post();
            $opRes = $this->model->addCategory($input);
            showMsg($opRes['tag'], $opRes['message']);
        } else {
            $cat_list = $this->model->getCategorySelectListFromJsonFile();
            $data = [
                'cat_list' => $cat_list
            ];
            return view('add', $data);
        }
    }

    /**
     * 更新分类数据
     * @param Request $request
     * @param $id 分类ID
     * @return View|void
     */
    public function edit(Request $request, $id)
    {
        if ($request->isPost()) {
            $opRes = $this->model->updateCmsCategoryData($request->post(),$id);
            showMsg($opRes['tag'], $opRes['message']);
        } else {
            $cat = $this->model->getCmsCategoryByID($id);
            $cat_list = $this->model->getCategorySelectListFromJsonFile();
            $data =
                [
                    'cat' => $cat,
                    'cat_list' => $cat_list
                ];
            return view('edit', $data);
        }
    }

    /**
     * ajax 更改首页显示状态
     * @param Request $request
     */
    public function ajaxForShow(Request $request)
    {
        $opRes = $this->model->updateForShow($request->post('cat_id'), $request->post('okStatus'));
        showMsg($opRes['tag'], $opRes['message']);
    }
}
