<?php
/**
 * Created by PhpStorm.
 * User: moTzxx
 * Date: 2019/4/26
 * Time: 10:10
 */

namespace app\cms\controller;


use app\common\controller\CmsBase;
use app\common\model\Xusers;
use think\Request;
use think\response\View;

/**
 * 用户管理类
 * Class Users
 * @package app\cms\Controller
 */
class Users extends CmsBase
{
    protected $model;

    public function __construct()
    {
        parent::__construct();
        $this->model = new Xusers();
    }

    /**
     * 用户列表数据
     * @param Request $request
     * @return View|void
     */
    public function index(Request $request){
        $curr_page = $request->param('curr_page', 1);
        $search = $request->param('str_search',null);
        $user_type = $request->param('user_type',0);
        if ($request->isPost()) {
            $list = $this->model->getCmsUsersForPage($curr_page, $this->page_limit, $search,$user_type);
            showMsg(1, 'success', $list);
        } else {
            $users = $this->model->getCmsUsersForPage($curr_page, $this->page_limit, $search,$user_type);
            $record_num = $this->model->getCmsUsersCount($search,$user_type);
            $data = [
                'users' => $users,
                'search' => $search,
                'user_type' => $user_type,
                'record_num' => $record_num,
                'page_limit' => $this->page_limit,
            ];
            return view('index', $data);
        }
    }

    /**
     * ajax 更新用户状态
     * @param Request $request
     */
    public function ajaxUpdateUserStatus(Request $request){
        if ($request->isPost()) {
            $user_id = $request->post('user_id', 0);
            $user_status = $request->post('user_status',0);
            $opRes = $this->model->updateUserStatus($user_id, $user_status);
            showMsg($opRes['status'], $opRes['message']);
        } else {
            showMsg(0, 'sorry，请求不合法');
        }
    }
}