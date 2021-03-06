<?php

namespace app\cms\controller;

use app\common\controller\CmsBase;
use app\common\lib\IAuth;
use app\common\model\Xadmins;
use app\common\model\XnavMenus;
use app\common\model\XsysConf;
use think\Controller;
use think\db\exception\DataNotFoundException;
use think\db\exception\ModelNotFoundException;
use think\exception\DbException;
use think\facade\Hook;
use think\Request;
use think\response\View;

/**
 * 登录管理类
 * Class Login
 * @package app\cms\Controller
 */
class Login extends Controller
{
    protected $adminModel;
    protected $navMenuModel;

    public function __construct()
    {
        parent::__construct();
        $this->adminModel = new Xadmins();
        $this->navMenuModel = new XnavMenus();
    }

    /**
     * 登录页
     * @return View
     */
    public function index()
    {
        list($cmsAID) = IAuth::getAdminIDCurrLogged();

        if ($cmsAID && IAuth::ckPasswordNoChangedCurrLogged($cmsAID)) {
            $this->redirect('cms/index/index');
        } else {
            return view('index');
        }
    }

    /**
     * 登出账号
     */
    public function logout()
    {
        Hook::listen('cms_op',"退出了系统");
        IAuth::logoutAdminCurrLogged();
        $this->redirect('cms/login/index');
    }

    /**
     * ajax 进行管理员的登录操作
     * @param Request $request
     * @throws DataNotFoundException
     * @throws ModelNotFoundException
     * @throws DbException
     */
    public function ajaxLogin(Request $request)
    {
        if ($request->isPost()) {
            $input = $request->post();
            $sysConf = new XsysConf();
            if ($sysConf->checkCmsIpAuth()){
                $tagRes = $this->adminModel->checkAdminLogin($input);
                Hook::listen('cms_op',"登录了系统");
            }else{
                $tagRes = ['tag'=>0,'message'=>'Sorry,Your IP is abnormal, please contact the administrator!'];
            }
            showMsg($tagRes['tag'], $tagRes['message']);
        } else {
            showMsg(0, 'sorry,您的请求不合法！');
        }
    }

    /**
     * ajax 检查登录状态
     * @param Request $request
     */
    public function ajaxCheckLoginStatus(Request $request)
    {
        if ($request->isPost()) {
            list($cmsAID) = IAuth::getAdminIDCurrLogged();
            $nav_menu_id = $request->param('nav_menu_id');
            //TODO 判断当前菜单是否属于他的权限内
            if ($cmsAID && IAuth::ckPasswordNoChangedCurrLogged($cmsAID) && $this->navMenuModel->checkNavMenuMan($nav_menu_id, $cmsAID)) {
                showMsg(1, '正在登录状态');
            } else {
                showMsg(0, '未在登录状态');
            }
        } else {
            showMsg(0, 'sorry,您的请求不合法！');
        }
    }
}
