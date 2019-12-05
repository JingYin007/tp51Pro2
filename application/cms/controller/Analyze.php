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
use think\Request;

/**
 * 统计分析类
 * Class Analyze
 * @package app\cms\controller
 */
class Analyze extends CmsBase
{

    protected $goodsModel;
    public function __construct()
    {
        parent::__construct();
        $this->goodsModel = new Xgoods();
    }

    /**
     * 商品售价区间饼状图
     * @param Request $request
     * @return \think\response\View|void
     */
    public function goodsPricePie(Request $request){
        if ($request->isPost()){
            $resData = $this->goodsModel->getGoodsPriceData();
            return showMsg(1, 'success', $resData);
        }else{
            return view('price_pie');
        }
    }
}