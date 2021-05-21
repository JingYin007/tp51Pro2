<?php

namespace app\cms\controller;

use app\common\controller\CmsBase;
use app\common\model\XnavMenus;
use think\facade\Session;
use think\Request;
use think\response\View;

/**
 * 菜单导航类
 * Class NavMenu
 * @package app\cms\Controller
 */
class NavMenu extends CmsBase
{
    protected $menuModel;

    public function __construct()
    {
        parent::__construct();
        $this->menuModel = new XnavMenus();
    }

    /**
     * 菜单导航列表页
     * @param Request $request
     * @return View
     */
    public function index(Request $request): View
    {
        $curr_page = $request->param('curr_page', 1);
        $search = $request->param('str_search');
        $navType = $request->param("navType","F");
        if ($request->isPost()) {
            $list = $this->menuModel->getNavMenusForPage($curr_page, $this->page_limit, $search,$navType);
            showMsg(1, 'success', $list);
        } else {
            $record_num = $this->menuModel->getNavMenusCount($search,$navType);
            $list = $this->menuModel->getNavMenusForPage($curr_page, $this->page_limit, $search,$navType);
            return view('index',
                [
                    'menus' => $list,
                    'search' => $search,
                    'record_num' => $record_num,
                    'page_limit' => $this->page_limit,
                    'navType' => $navType
                ]);
        }
    }

    /**
     * 增加新导航标题 功能
     * @param Request $request
     * @return View
     */
    public function add(Request $request)
    {

        if ($request->isPost()) {
            $input = $request->param();
            $opRes = $this->menuModel->addNavMenu($input);
            showMsg($opRes['tag'], $opRes['message']);
        } else {
            $rootMenus = $this->menuModel->getAllVisibleMenus();
            return view('add', [
                'rootMenus' => $rootMenus,
            ]);
        }
    }

    /**
     * 赋予权限
     * @param Request $request
     * @param $id int 菜单ID
     * @return View
     */
    public function auth(Request $request, int $id): View
    {

        if ($request->isPost()) {
            $input = $request->param();
            $opRes = $this->menuModel->addNavMenu($input, $id,1);
            showMsg($opRes['tag'], $opRes['message']);
        } else {
            $authMenus = $this->menuModel->getAuthChildNavMenus($id);
            return view('auth', [
                'authMenus' => $authMenus,
                'parent_id' => $id
            ]);
        }
    }

    /**
     * 编辑导航菜单数据
     * @param Request $request
     * @param $id int 菜单ID
     * @return View
     */
    public function edit(Request $request, int $id): View
    {
        if ($request->isPost()) {
            //TODO 修改对应的菜单
            $input = $request->post();
            $opRes = $this->menuModel->editNavMenu($id, $input);
            showMsg($opRes['tag'], $opRes['message']);
        } else {
            $menuData = $this->menuModel->getNavMenuByID($id);
            $rootMenus = $this->menuModel->getAllVisibleMenus();
            return view('edit', [
                'rootMenus' => $rootMenus,
                'menuData' => $menuData
            ]);
        }
    }

    /**
     * 更新权限信息
     * @param Request $request
     * @param int $id
     */
    public function updateAuth(Request $request, int $id)
    {
        if ($request->isPost()) {
            //TODO 修改对应的菜单
            $input = $request->post();
            list($status,$message) = $this->menuModel->editNavMenuForAuth($id, $input);
            showMsg($status, $message);
        } else {
           showMsg(0,'请求不合法！');
        }
    }


}
