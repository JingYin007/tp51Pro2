<?php
/**
 * Created by PhpStorm.
 * User: moTzxx
 * Date: 2020/11/11
 * Time: 10:31
 */

namespace app\cms\controller;

use app\common\controller\CmsBase;
use app\common\lib\BirdExpress;
use app\common\model\Xorders;
use think\Request;

/**
 * 订单管理类
 * Class Analyze
 * @package app\cms\controller
 */
class Order extends CmsBase
{

    protected $orderModel;
    public function __construct()
    {
        parent::__construct();
        $this->orderModel = new Xorders();
    }

    public function index(Request $request){
        $curr_page = $request->param('curr_page', 1);
        $search = $request->param('str_search',null);
        if ($request->isPost()) {
            $list = $this->orderModel->getPayOrdersForPage($curr_page, $this->page_limit, $search);
            showMsg(1, 'success', $list);
        } else {
            $users = $this->orderModel->getPayOrdersForPage($curr_page, $this->page_limit, $search);
            $record_num = $this->orderModel->getPayOrdersCount($search);
            $data = [
                'users' => $users,
                'search' => $search,
                'record_num' => $record_num,
                'page_limit' => $this->page_limit,
            ];
            return view('index', $data);
        }
    }

    public function details(Request $request){
        $curr_page = $request->param('curr_page', 1);
        $search = $request->param('str_search',null);
        $orderStatus = $request->param('orderStatus',null);
        if ($request->isPost()) {
            $list = $this->orderModel->getOrderDetailsForPage($curr_page, $this->page_limit, $search,$orderStatus);
            showMsg(1, 'success', $list);
        } else {
            $detailList = $this->orderModel->getOrderDetailsForPage($curr_page, $this->page_limit, $search,$orderStatus);
            $record_num = $this->orderModel->getOrderDetailsCount($search,$orderStatus);
            $data = [
                'detailList' => $detailList,
                'orderStatus' => $orderStatus,
                'search' => $search,
                'record_num' => $record_num,
                'page_limit' => $this->page_limit,
            ];
            return view('details', $data);
        }
    }

    /**
     * ajax 获取购物清单
     * @param Request $request
     */
    public function ajaxGetShoppingList(Request $request)
    {
        if ($request->isPost()) {
            $order_id = $request->post('order_id');
            $opRes = $this->orderModel->getShoppingList($order_id);
            showMsg(1, 'shoppingList', $opRes);
        } else {
            showMsg(0, '请求不合法');
        }
    }

    /**
     * 更新订单详情的物流信息
     * @param Request $request
     * @param $id
     * @return \think\response\View|void
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     */
    public function opCourierSn(Request $request,$id){
        if ($request->isPost()) {
            $opRes = $this->orderModel->updateCourierInfo($request->post());
            showMsg($opRes['status'], $opRes['message']);
        } else {
            $courierInfo = $this->orderModel->getCourierInfoByODID($id);
            $birdExpList = $this->orderModel->getBirdExpressList();
            return view('op_courier_sn',
                [
                    'opID' => $id,
                    'courierInfo' => $courierInfo,
                    'birdExpList' => $birdExpList]);
        }
    }

    /**
     * 物流信息的查询操作
     * 正常业务逻辑需要获取 Get/Post 所传来的数据
     * 然后进行对 getOrderTracesByJson() 方法的调用即可
     * @param $op_id 物流订单ID
     * @return \think\response\View
     */
    public function lookLogistics($op_id)
    {
        $expressMsg = $courier_num = null;
        $LogisticsMsg = $this->orderModel->getLogisticsMsgFromOrderGoods($op_id);
        if ($LogisticsMsg) {
            $ShipperCode = $LogisticsMsg['code'];
            $courier_num = $LogisticsMsg['courier_sn'];
            $express = new BirdExpress();
            //TODO 调用查询物流轨迹 这里我得到了一个数组
            $customer_name = $LogisticsMsg['customer_name'];
            $expressMsg = $express->getOrderTracesByJson($ShipperCode, $courier_num, 1,$customer_name);
        }
        return view('look_logistics', [
            'expressMsg' => $expressMsg,
            'shipperName' => empty($LogisticsMsg) ? "暂无信息" : $LogisticsMsg['name'],
            'logisticCode' => $courier_num ? $courier_num : "暂无匹配",
        ]);
    }
}