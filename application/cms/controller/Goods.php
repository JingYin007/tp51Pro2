<?php

namespace app\cms\Controller;

use app\common\controller\CmsBase;
use app\common\model\Xbrands;
use app\common\model\Xcategorys;
use app\common\model\Xgoods;
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
        $search = $request->param('str_search');
        $OrderType = $request->param("OrderType", "D");
        if ($request->isGet()){
            //获取所有的商品二级三級分类
            $categoryList = $this->categoryModel->getCmsToSelCategoryList();
            $goods = $this->model->getCmsGoodsForPage($curr_page, $this->page_limit, $search, $SelStatus, $CatType, $OrderType);
            $record_num = $this->model->getCmsGoodsCount($search, $SelStatus, $CatType);
            $data = [
                'goods' => $goods,
                'search' => $search,
                'SelStatus' => $SelStatus,
                'CatType' => $CatType,
                'OrderType' => $OrderType,
                'categoryList' => $categoryList,
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
            $categoryList = $this->categoryModel->getCmsToSelCategoryList();
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
            $categoryList = $this->categoryModel->getCmsToSelCategoryList();
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
     * ajax 根据分类获取参加活动的商品
     * @param Request $request
     */
    public function ajaxGetCatGoodsForActivity(Request $request)
    {
        $seledCatID = $request->post("seledCatID");
        $goodsList = $this->model->getCatGoodsForActivity($seledCatID);
        $status = 1;
        $message = "success";
        if (!$goodsList) {
            $status = 0;
            $message = "未查到商品数据";
        }
        return showMsg($status, $message, $goodsList);
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
}
