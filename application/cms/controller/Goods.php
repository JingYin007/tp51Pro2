<?php

namespace app\cms\Controller;

use app\common\controller\CmsBase;
use app\common\model\Xbrands;
use app\common\model\Xcategorys;
use app\common\model\Xgoods;
use app\common\model\XspecInfos;
use app\common\model\Xsuppliers;
use think\Request;

class Goods extends CmsBase
{
    protected $model;
    protected $categoryModel;
    protected $brandModel;
    public function __construct()
    {
        parent::__construct();
        $this->model = new Xgoods();
        $this->categoryModel = new Xcategorys();
    }

    /**
     * 获取商品列表数据
     * @param Request $request
     * @return \think\response\View
     */
    public function index(Request $request)
    {
        $curr_page = $request->param('curr_page', 1);
        $SelStatus = $request->param("SelStatus", "Up");
        $CatType = $request->param("CatType", "0");
        $SelBrand = $request->param("SelBrand", null);
        $search = $request->param('str_search');
        $OrderType = $request->param("OrderType", "D");
        if ($request->isGet()){
            //获取所有的商品二级三級分类
            $categoryList = $this->categoryModel->getCategorySelectListFromJsonFile();
            $brandList = (new Xbrands())->getSelectableList();
            $goods = $this->model->getCmsGoodsForPage($curr_page, $this->page_limit, $search, $SelStatus, $CatType, $OrderType);
            $record_num = $this->model->getCmsGoodsCount($search, $SelStatus, $CatType);
            $data = [
                'goods' => $goods,
                'search' => $search,
                'SelStatus' => $SelStatus,
                'SelBrand' => $SelBrand,
                'CatType' => $CatType,
                'OrderType' => $OrderType,
                'categoryList' => $categoryList,
                'brandList' => $brandList,
                'record_num' => $record_num,
                'page_limit' => $this->page_limit,
            ];
            return view('index', $data);
        }else{
            $list = $this->model->getCmsGoodsForPage($curr_page, $this->page_limit, $search, $SelStatus, $CatType, $OrderType);
            return showMsg(1, 'success', $list);
        }

    }

    /**
     * 添加商品
     * @param Request $request
     * @return \think\response\View|void
     */
    public function add(Request $request)
    {
        if ($request->isPost()) {
            $input = $request->post();
            $opRes = $this->model->addGoods($input);
            return showMsg($opRes['tag'], $opRes['message']);
        } else {
            $categoryList = $this->categoryModel->getCategorySelectListFromJsonFile();
            return view('add', ['categoryList' => $categoryList,]);
        }
    }

    /**
     * 更新商品数据
     * @param Request $request
     * @param $id 商品ID
     * @return \think\response\View|void
     */
    public function edit(Request $request, $id)
    {
        if ($request->isPost()) {
            $opRes = $this->model->updateCmsGoodsData($request->post(),$id);
            return showMsg($opRes['tag'], $opRes['message']);
        } else {
            $goodsMsg = $this->model->getCmsGoodsByID($id);
            $categoryList = $this->categoryModel->getCategorySelectListFromJsonFile();
            $data =
                [
                    'good' => $goodsMsg,
                    'categoryList' => $categoryList,
                ];
            return view('edit', $data);
        }
    }

    /**
     * ajax 更改上下架状态
     * @param Request $request
     */
    public function ajaxPutaway(Request $request)
    {
        $opRes = $this->model
            ->updatePutaway($request->post('goods_id'), $request->post('okStatus'));
        return showMsg($opRes['tag'], $opRes['message']);
    }

    /**
     * 操作日志列表
     * @param $id
     * @return \think\response\View
     */
    public function viewLogs($id){
        $logs = getCmsOpViewLogs($id,'GOODS');
        return view('view_logs',['logs' => $logs]);
    }

    /**
     * ajax 根据商品分类查询 品牌和父级属性
     * @param Request $request
     */
    public function ajaxGetBrandAndSpecInfoFstByCat(Request $request)
    {
        $seledCatID = $request->post("seledCatID");
        $specList = (new XspecInfos())->getSpecInfoFstByCat($seledCatID);
        $brandList = (new Xbrands())->getSelectableList($seledCatID);
        $status = 1;
        $message = "success";
        if (!$specList && !$brandList) {
            $status = 0;
            $message = "未查到品牌和父级属性数据";
        }
        return showMsg($status, $message, ['specList'=>$specList,'brandList'=>$brandList]);
    }
}
