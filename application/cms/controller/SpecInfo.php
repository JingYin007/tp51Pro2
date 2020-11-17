<?php

namespace app\cms\Controller;

use app\common\controller\CmsBase;
use app\common\model\Xcategorys;
use app\common\model\XspecInfos;
use think\Request;
use think\Db;

class SpecInfo extends CmsBase
{
    protected $model;
    protected $categoryModel;

    public function __construct()
    {
        parent::__construct();
        $this->model = new XspecInfos();
        $this->categoryModel = new Xcategorys();
    }

    /**
     * 获取属性列表数据
     * @param Request $request
     * @return \think\response\View
     */
    public function index(Request $request)
    {
        $curr_page = $request->param('curr_page', 1);
        $search = $request->param('str_search');
        $catID = $request->param("catID",null);
        if ($request->isGet()){
            $categoryList = $this->categoryModel->getCmsToSelCategoryList();
            $list = $this->model->getCmsSpecInfoForPage($curr_page, $this->page_limit, $search, $catID);
            $record_num = $this->model->getCmsSpecInfoCount($search, $catID);
            $data = [
                'list' => $list,
                'search' => $search,
                'catID' => $catID,
                'categoryList' => $categoryList,
                'record_num' => $record_num,
                'page_limit' => $this->page_limit,
            ];
            return view('index', $data);
        }else{
            $list = $this->model->getCmsSpecInfoForPage($curr_page, $this->page_limit, $search, intval($catID));
            return showMsg(1, 'success', $list);
        }
    }

    /**
     * 添加属性分类
     * @param Request $request
     * @return \think\response\View|void
     */
    public function add(Request $request)
    {
        $spec_id = $request->param('id',0);
        if ($request->isPost()) {
            $input = $request->post();
            $opRes = $this->model->addSpecInfo($input);
            return showMsg($opRes['tag'], $opRes['message']);
        } else {
            $categoryList = $this->categoryModel->getCmsToSelCategoryList();
            $data = [
                'categoryList' => $categoryList,
                'spec_id' => $spec_id
            ];
            $pageView = $spec_id ? "val_add": "spec_add";
            return view($pageView, $data);
        }
    }

    /**
     * 更新属性数据
     * @param Request $request
     * @param $id 属性 ID
     * @return \think\response\View|void
     */
    public function edit(Request $request, $id)
    {
        if ($request->isPost()) {
            $level = $request->post('level',1);
            $opRes = $this->model->updateCmsSpecInfoData($id,$request->post(),$level);
            return showMsg($opRes['tag'], $opRes['message']);
        } else {
            $categoryList = $this->categoryModel->getCmsToSelCategoryList();
            $specInfo = $this->model->getCmsSpecInfoByID($id);
            $data =
                [
                    'categoryList' => $categoryList,
                    'specInfo' => $specInfo
                ];
            return view('edit', $data);
        }
    }

    /**
     * ajax 根据商品分类查询 父级属性
     * @param Request $request
     */
    public function ajaxGetSpecInfoBySpecFst(Request $request)
    {
        $seledSpecFstID = $request->post("seledSpecFstID");
        $specInfoList = $this->model->getSpecInfoBySpecFst(intval($seledSpecFstID));
        $status = 1;
        $message = "success";
        if (!$specInfoList) {
            $status = 0;
            $message = "未查到子级属性数据";
        }
        return showMsg($status, $message, $specInfoList);
    }

    /**
     * 获取详情
     * @param Request $request
     * @return \think\response\View|void
     */
    public function details(Request $request){
        $spec_id = $request->param('id',0);
        $curr_page = $request->param('curr_page', 1);
        $search = $request->param('str_search',null);
        $this->page_limit = 5;
        if ($request->isGet()){
            $details = $this->model->getSpecDetailsBySpecIDForPage($curr_page,$this->page_limit,$search,$spec_id);
            $record_num = $this->model->getSpecDetailsBySpecIDCount($search,$spec_id);
            return view('details',[
                'details' => $details,
                'id' => $spec_id,
                'record_num' => $record_num,
                'page_limit' => $this->page_limit,
                'search' => $search
            ]);
        }else{
            $details = $this->model->getSpecDetailsBySpecIDForPage($curr_page,$this->page_limit,$search,$spec_id);
            return showMsg(1,'success',$details);
        }
    }
}
