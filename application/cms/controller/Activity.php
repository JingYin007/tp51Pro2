<?php

namespace app\cms\controller;

use app\common\controller\CmsBase;
use app\common\model\Xactivitys;
use app\common\model\Xcategorys;
use app\common\model\Xgoods;
use think\Request;
use think\response\View;

class Activity extends CmsBase
{
    private $actModel;
    private $categoryModel;

    public function __construct()
    {
        parent::__construct();
        $this->actModel = new Xactivitys();
        $this->categoryModel = new Xcategorys();
    }

    /**
     * 活动数据列表页
     * @param Request $request
     * @return View|void
     */
    public function index(Request $request){
        $search = $request->param('str_search');
        $OrderType = $request->param("OrderType", "W");
        $actType = $request->param("actType", null);
        $curr_page = $request->param('curr_page',1);
        if ($request->isGet()){
            $record_num = $this->actModel->getActsCount($search,$actType);
            $list = $this->actModel->getActsForPage(1,$this->page_limit,$search,$OrderType,$actType);
            return view('index',
                [
                    'acts' => $list,
                    'search' => $search,
                    'OrderType' => $OrderType,
                    'actType' => $actType,
                    'record_num' => $record_num,
                    'page_limit' => $this->page_limit,
                ]);
        }else{
            $list = $this->actModel->getActsForPage($curr_page,$this->page_limit,$search,$OrderType,$actType);
            return showMsg(1,'success',$list);
        }
    }
    /**
     * 增加标题 功能
     * @param Request $request
     * @return View|void
     */
    public function add(Request $request){
        if ($request->isPost()){
            $input = $request->post();
            $opRes = $this->actModel->addActivity($input);
            return showMsg($opRes['tag'],$opRes['message']);
        }else{
            $categoryList = (new Xcategorys())->getCategorySelectListFromJsonFile();
            return view('add',['categoryList' => $categoryList]);
        }
    }

    /**
     * 编辑数据
     * @param Request $request
     * @param $id 活动 ID
     * @return View|void
     */
    public function edit(Request $request,$id){
        $actData = $this->actModel->getActByID($id);
        $actGoods = $this->actModel->getActGoods($id);
        if ($request->isPost()){
            //TODO 修改对应的菜单
            $input = $request->post();
            $opRes = $this->actModel->editActivity($id,$input);
            return showMsg($opRes['tag'],$opRes['message']);
        }else{
            $categoryList = (new Xcategorys())->getCategorySelectListFromJsonFile();
            return view('edit',[
                'actData'   => $actData,
                'actGoods'  =>$actGoods,
                'categoryList' => $categoryList
            ]);
        }
    }

    /**
     * ajax 根据分类获取 商品
     * @param Request $request
     */
    public function ajaxGetGoodsByCat(Request $request)
    {
        $seledCatID = $request->post("seledCatID");
        $goodsList = (new Xgoods())->getCatGoodsForActivity($seledCatID);
        $status = 1;
        $message = "success";
        if (!$goodsList) {
            $status = 0;
            $message = "未查到商品数据";
        }
        return showMsg($status, $message, $goodsList);
    }
    /**
     * ajax 更改首页显示状态
     * @param Request $request
     */
    public function ajaxForShow(Request $request){
        $opRes = $this->actModel->updateForShow( $request->post('act_id'),$request->post('okStatus'));
        return showMsg($opRes['tag'],$opRes['message']);
    }
}
