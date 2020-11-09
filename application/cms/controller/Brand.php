<?php

namespace app\cms\Controller;

use app\common\controller\CmsBase;
use app\common\model\Xbrands;
use app\common\model\Xcategorys;
use think\Request;

class Brand extends CmsBase
{
    protected $model;

    public function __construct()
    {
        parent::__construct();
        $this->model = new Xbrands();
        $this->page_limit = 10;
    }

    /**
     * 获取品牌列表数据
     * @param Request $request
     * @return \think\response\View|void
     */
    public function index(Request $request)
    {
        $curr_page = $request->post('curr_page', 1);
        $search = $request->param('str_search');
        $catID = $request->param("catID",0);
        if ($request->isGet()) {
            $categoryList = (new Xcategorys())->getCmsToSelCategoryList();
            $list = $this->model->getCmsBrandForPage($curr_page, $this->page_limit, $search, $catID);
            $record_num = $this->model->getCmsBrandCount($search, $catID);
            $data = [
                'categoryList' => $categoryList,
                'list' => $list,
                'search' => $search,
                'catID' => $catID,
                'record_num' => $record_num,
                'page_limit' => $this->page_limit,
            ];
            return view('index', $data);
        } else {
            $list = $this->model->getCmsBrandForPage($curr_page, $this->page_limit, $search, $catID);
            return showMsg(1, 'success', $list);
        }
    }

    /**
     * 添加品牌
     * @param Request $request
     * @return \think\response\View|void
     */
    public function add(Request $request)
    {
        if ($request->isPost()) {
            $input = $request->post();
            $opRes = $this->model->addCmsBrand($input);
            return showMsg($opRes['tag'], $opRes['message']);
        } else {
            $categoryList = (new Xcategorys())->getCmsToSelCategoryList();
            $data = ['categoryList' => $categoryList];
            return view('add', $data);
        }
    }

    /**
     * 更新品牌数据
     * @param Request $request
     * @param $id 品牌ID
     * @return \think\response\View|void
     */
    public function edit(Request $request, $id)
    {
        if ($request->isPost()) {
            $opRes = $this->model->updateCmsBrandData($request->post(),$id);
            return showMsg($opRes['tag'], $opRes['message']);
        } else {
            $brand = $this->model->getCmsBrandByID($id);
            $categoryList = (new Xcategorys())->getCmsToSelCategoryList();
            $data =
                [
                    'brand' => $brand,
                    'categoryList' => $categoryList
                ];
            return view('edit', $data);
        }
    }
}
