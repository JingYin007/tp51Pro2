<?php
/**
 * Created by PhpStorm.
 * User: moTzxx
 * Date: 2019/12/5
 * Time: 15:31
 */

namespace app\cms\controller;


use app\common\controller\CmsBase;
use app\common\model\Xgoods;
use app\common\model\Xorders;
use app\common\model\Xstores;
use think\Request;

/**
 * 统计分析类
 * Class Analyze
 * @package app\cms\controller
 */
class Analyze extends CmsBase
{

    protected $orderModel;
    public function __construct()
    {
        parent::__construct();
        $this->orderModel = new Xorders();
    }

    /**
     * 热销商品饼状图
     * @param Request $request
     * @return \think\response\View|void
     */
    public function hotSale(Request $request){
        $today = date('Y-m-d');
        $tomorrow = date('Y-m-d', strtotime('+1 day'));
        $default_date = "$today - $tomorrow";
        //TODO 初始化，设定一个时间而已！！！
        $default_date = "2020-11-01 - 2020-12-12";
        $date_sel = $request->param('date_sel', $default_date);
        if ($request->isPost()) {
            $arrDate = explode(" - ", $date_sel);
            $resData = $this->orderModel->getHotSaleData($arrDate[0], $arrDate[1]);
            return showMsg(1, 'success', $resData);
        } else {
            return view('hot_sale', ['date_sel' => $date_sel]);
        }
    }

    /**
     * 24小时销售折线图
     * @param Request $request
     * @return \think\response\View|void
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     */
    public function timeSale(Request $request){
        //ajax 获取数据
        $today = date('Y-m-d');
        $default_date = $today;

        //TODO 初始化，设定一个时间而已 ！
        $default_date = "2020-11-11";
        $date_sel = $request->param('date_sel', $default_date);
        if ($request->isPost()) {
            $resData = $this->orderModel->getTimeSaleData($date_sel);
            return showMsg(1, 'success', $resData);
        } else {
            return view('time_sale', ['date_sel' => $date_sel]);
        }
    }
}