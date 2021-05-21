<?php

namespace app\cms\controller;

use app\common\controller\CmsBase;
use app\common\model\XadminRoles;
use app\common\model\Xadmins;
use app\common\model\XnavMenus;
use think\Request;
use think\response\View;

/**
 * 后台管理员
 * Class Admin
 * @package app\cms\Controller
 */
class Admin extends CmsBase
{
    protected $model;
    protected $ar_model;
    protected $menuModel;

    public function __construct()
    {
        parent::__construct();
        $this->model = new Xadmins();
        $this->ar_model = new XadminRoles();
        $this->menuModel = new XnavMenus();
    }

    /**
     * 管理员数据列表
     * @param Request $request
     * @return View|void
     */
    public function index(Request $request)
    {
        $search = $request->param('str_search');
        $curr_page = $request->param('curr_page', 1);
        if ($request->isPost()) {
            $list = $this->model->getAdminsForPage($curr_page, $this->page_limit,$search);
            showMsg(1, 'success', $list);
        } else {
            $list = $this->model->getAdminsForPage($curr_page, $this->page_limit,$search);
            $record_num = $this->model->getAdminsCount($search);
            return view('index',
                [
                    'admins' => $list,
                    'search' => $search,
                    'record_num' => $record_num,
                    'page_limit' => $this->page_limit,
                ]);
        }
    }

    /**
     * 添加新用户
     * @param Request $request
     * @return View|void
     */
    public function addAdmin(Request $request)
    {
        if ($request->isPost()) {
            $input = $request->post();
            $opRes = $tag = $this->model->addAdmin($input);
            showMsg($opRes['tag'], $opRes['message']);
        } else {
            $adminRoles = $this->ar_model->getNormalRoles();
            return view('add_admin', [
                'adminRoles' => $adminRoles
            ]);
        }
    }

    /**
     * @param Request $request
     * @param $id 标识 ID
     * @return View|void
     */
    public function editAdmin(Request $request, $id)
    {
        if ($request->isPost()) {
            $input = $request->param();
            $opRes = $this->model->editAdmin($id, $input);
            showMsg($opRes['tag'], $opRes['message']);
        } else {
            $adminData = $this->model->getAdminData($id);
            $adminRoles = $this->ar_model->getNormalRoles();
            return view('edit_admin', [
                'admin' => $adminData,
                'adminRoles' => $adminRoles
            ]);
        }
    }


    /*TODO -------------------------------------角色管理------------------------------*/

    /**
     * 读取角色列表
     * @return View
     */
    public function role(Request $request)
    {
        $adminRoles = $this->ar_model->getAllRoleList();
        if ($request->isGet()){
            //$adminRoles = [];
            return view('role_react', ['roles' => $adminRoles]);
        }else{
            showMsg(1,'roleList',$adminRoles);
        }
    }

    /**
     * 角色添加功能
     * @param Request $request
     * @return View|void
     */
    public function addRole(Request $request)
    {
        if ($request->isPost()) {
            $input = $request->post();
            $opRes = $this->ar_model->addRole($input);
            showMsg($opRes['tag'], $opRes['message']);
        } else {
            //TODO 获取所有可以分配的权限菜单
            //$viewMenus = $this->menuModel->getAllNavMenus();
            $roleMenu = $this->ar_model->getCurrRoleMenuList();
            return view('add_role', [
                'menus' => $roleMenu,
            ]);
        }
    }

    /**
     * 更新 角色数据
     * @param Request $request
     * @param $id
     * @return View
     */
    public function editRole(Request $request, $id): View
    {
        $roleData = $this->ar_model->getRoleInfo($id);
        if ($request->isPost()) {
            $input = $request->param();
            $opRes = $this->ar_model->editRole($id, $input);
            showMsg($opRes['tag'], $opRes['message']);
        } else {
            //TODO 获取所有可以分配的权限菜单
            $roleMenu = $this->ar_model->getCurrRoleMenuList($id);
            return view('edit_role', [
                'role' => $roleData,
                'roleMenu' => $roleMenu
            ]);
        }
    }
}
