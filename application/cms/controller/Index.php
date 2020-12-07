<?php

namespace app\cms\controller;

use app\common\lib\IAuth;
use app\common\model\Xmozxx;
use app\common\model\XnavMenus;
use app\common\model\Xadmins;
use think\Controller;
use think\Request;

/**
 * Created by PhpStorm.
 * User: moTzxx
 * Date: 2018/1/23
 * Time: 15:54
 */
class Index extends Controller
{
    protected $menuModel;
    protected $adminModel;
    protected $cmsAID;

    /**
     * 构造函数
     * Index constructor.
     */
    public function __construct()
    {
        parent::__construct();
        $this->cmsAID = IAuth::getAdminIDCurrLogged();
        if (!$this->cmsAID) {
            $action = trim(strtolower(request()->action()));
            if ($action == 'index'){
                //TODO 后台入口路径 处理方法！
                $this->redirect('cms/login/index');
            }else{
                return showMsg(0,'You are offline,please logon again!');
            }
        }else{
            $this->menuModel = new XnavMenus();
            $this->adminModel = new Xadmins();
        }
    }

    /**
     * 后台首页
     * @param Request $request
     * @return \think\response\View|void
     */
    public function index(Request $request)
    {
        //获取 登录的管理员有效期ID
        if($request->isGet()) {
                $menuList = $this->menuModel->getNavMenusShow($this->cmsAID);
                $adminInfo = $this->adminModel->getAdminData($this->cmsAID);
                $data = [
                    'menus' => $menuList,
                    'admin' => $adminInfo,
                    'web_socket_url' => config('workerman.WEB_SOCKET_URL')
                ];
                return view('index', $data);
        }else{
            return showMsg(0,'Sorry,您的请求不合法！');
        }
    }

    /**
     * 首页显示 可自定义呗
     * @return \think\response\View
     */
    public function home()
    {
        $xIndexModel = new Xmozxx();
        $devLogList = $xIndexModel->getDevLogList(null);
        $currLogList = $xIndexModel->getDevLogList(1);

        return view('home',['devLogList' => $devLogList,'currLogList' => $currLogList]);
    }

    /**
     * 展示管理员个人信息 可自行修改
     * @param Request $request
     * @param $id
     * @return \think\response\View|void
     */
    public function admin(Request $request, $id)
    {
        if ($request->isGet()) {
            if (intval($this->cmsAID) === intval($id)){
                $adminData = $this->adminModel->getAdminData($id);
                return view('admin', ['admin' => $adminData,]);
            }else{
                return showMsg(0,'Sorry, 您无权修改其他用户信息！');
            }
        } else {
            //当前用户对个人账号的修改
            $input = $request->post();
            $opRes = $this->adminModel->editCurrAdmin($id, $input, $this->cmsAID);
            return showMsg($opRes['tag'], $opRes['message']);
        }
    }
}