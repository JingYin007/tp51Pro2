<?php

namespace app\cms\Controller;

use app\common\controller\CmsBase;
use app\common\model\Xactivitys;
use app\common\model\Xcategorys;
use think\Request;

class Activity extends CmsBase
{
    private $actModel;
    private $categoryModel;

    //定义每页的记录数
    private $page_limit;
    public function __construct()
    {
        parent::__construct();
        $this->actModel = new Xactivitys();
        $this->categoryModel = new Xcategorys();
        $this->page_limit = config('app.CMS_PAGE_SIZE');
    }

    /**
     * 活动数据列表页
     * @param Request $request
     * @return \think\response\View
     */
    public function index(Request $request){
        $search = $request->param('str_search');
        $OrderType = $request->param("OrderType", "A");
        $curr_page = $request->param('curr_page',1);
        if ($request->isGet()){
            $record_num = $this->actModel->getActsCount($search);
            $list = $this->actModel->getActsForPage(1,$this->page_limit,$search,$OrderType);
            return view('index',
                [
                    'acts' => $list,
                    'search' => $search,
                    'OrderType' => $OrderType,
                    'record_num' => $record_num,
                    'page_limit' => $this->page_limit,
                ]);
        }else{
            $list = $this->actModel->getActsForPage($curr_page,$this->page_limit,$search,$OrderType);
            return showMsg(1,'success',$list);
        }
    }
    /**
     * 增加标题 功能
     * @param Request $request
     * @return \think\response\View|void
     */
    public function add(Request $request){
        if ($request->isPost()){
            $input = $request->post();
            $opRes = $this->actModel->addActivity($input);
            return showMsg($opRes['tag'],$opRes['message']);
        }else{
            return view('add');
        }
    }

    /**
     * 编辑数据
     * @param Request $request
     * @param $id 活动 ID
     * @return \think\response\View|void
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
            return view('edit',[
                'actData'   => $actData,
                'actGoods'  =>$actGoods
            ]);
        }
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
