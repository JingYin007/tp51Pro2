<?php
/**
 * Created by PhpStorm.
 * User: moTzxx
 * Date: 2019/7/25
 * Time: 18:34
 */

namespace app\cms\controller;

use app\common\controller\CmsBase;
use app\common\model\Xconfigs;
use think\Request;

/**
 * 配置项管理类
 * Class Config
 * @package app\cms\Controller
 */
class Config extends CmsBase
{
    protected $confModel;
    public function __construct()
    {
        parent::__construct();
        $this->confModel = new Xconfigs();
    }

    /**
     * 数据列表页
     * @param Request $request
     * @return \think\response\View
     */
    public function index(Request $request){
        $search = $request->param('str_search');
        $input_type = $request->param("input_type","text");
        $curr_page = $request->param('curr_page',1);
        if ($request->isPost()){
            $list = $this->confModel->getConfigsForPage($curr_page,$this->page_limit,$search,$input_type);
            return showMsg(1,'success',$list);
        }else{
            $configs = $this->confModel->getConfigsForPage($curr_page, $this->page_limit, $search,$input_type);
            $record_num = $this->confModel->getConfigsCount($search, $input_type);
            $arrCount = $this->confModel->getEachTypeData();
            $data = [
                'configs' => $configs,
                'search' => $search,
                'input_type' => $input_type,
                'arrCount' => $arrCount,
                'record_num' => $record_num,
                'page_limit' => $this->page_limit,
            ];
            return view('index',$data);
        }
    }

    /**
     * 进行配置项的添加
     * @param Request $request
     * @return \think\response\View|void
     */
    public function add(Request $request){
        if ($request->isPost()) {
            $input = $request->post();
            $opRes = $this->confModel->addConfig($input);
            return showMsg($opRes['tag'], $opRes['message']);
        } else {
            return view('add');
        }
    }

    /**
     * 编辑配置项数据
     * @param Request $request
     * @param $id ID
     * @return \think\response\View|void
     */
    public function edit(Request $request,$id){
        if($id == 0) $id = $request->param('id');
        if ($request->isPost()){
            //TODO 修改对应的配置
            $input = $request->post();
            $opRes = $this->confModel->editConfig($id,$input);
            return showMsg($opRes['tag'],$opRes['message']);
        }else{
            $confData = $this->confModel->getConfigByID($id);
            return view('edit',['confData'   => $confData,]);
        }
    }

    /**
     * 动态更新开关状态
     * @param Request $request
     */
    public function ajaxUpdateSwitchValue(Request $request){
        $opRes = $this->confModel
            ->updateSwitchValue($request->post('config_id'), $request->post('okStatus'));
        return showMsg($opRes['tag'], $opRes['message']);
    }
}