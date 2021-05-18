<?php

namespace app\cms\controller;

use app\common\lib\IAuth;
use app\common\lib\Upload;
use app\common\model\Xmozxx;
use app\common\model\XnavMenus;
use app\common\model\Xadmins;
use Exception;
use think\Controller;
use think\db\exception\DataNotFoundException;
use think\db\exception\ModelNotFoundException;
use think\exception\DbException;
use think\Request;
use think\response\View;

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
        if (!$this->cmsAID || !IAuth::ckPasswordNoChangedCurrLogged($this->cmsAID)) {
            $action = trim(strtolower(request()->action()));
            if ($action == 'index'){
                //TODO 后台入口路径 处理方法！
                $this->redirect('cms/login/index');
            }else{
                showMsg(0,'You are offline,please logon again!');
            }
        }else{
            $this->menuModel = new XnavMenus();
            $this->adminModel = new Xadmins();
        }
    }

    /**
     * 后台首页
     * @param Request $request
     * @return View|void
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
            showMsg(0,'Sorry,您的请求不合法！');
        }
    }

    /**
     * 首页显示 可自定义呗
     * @return View
     * @throws DataNotFoundException
     * @throws ModelNotFoundException
     * @throws DbException
     */
    public function home()
    {
        $xIndexModel = new Xmozxx();
        $currLogList = $xIndexModel->getDevLogList(1);
        $devLogList = $xIndexModel->getDevLogList(null);


        return view('home',['devLogList' => $devLogList,'currLogList' => $currLogList]);
    }

    /**
     * 展示管理员个人信息 可自行修改
     * @param Request $request
     * @param $id
     * @return View|void
     */
    public function admin(Request $request, $id)
    {
        if ($request->isGet()) {
            if (intval($this->cmsAID) === intval($id)){
                $adminData = $this->adminModel->getAdminData($id);
                return view('admin', ['admin' => $adminData,]);
            }else{
                showMsg(0,'Sorry, 您无权修改其他用户信息！');
            }
        } else {
            //当前用户对个人账号的修改
            $input = $request->post();
            $opRes = $this->adminModel->editCurrAdmin($id, $input, $this->cmsAID);
            showMsg($opRes['tag'], $opRes['message']);
        }
    }

    /**
     * 后台 图片上传 接口
     * @param Request $request
     * @throws Exception
     */
    public function upload_img_file(Request $request){
        if ($request->isPost()) {
            //判断是哪种上传方式 七牛云
            if (config('qiniu.QN_USE') == 'OPEN'){
                $opRes = Upload::qiNiuSingleFile();
            }else{
                $opRes = Upload::singleFile($request);
            }
            showMsg($opRes['status'], $opRes['message'],$opRes['data']);
        }else{
            showMsg(0, "Sorry,请求不合法！");
        }
    }
}