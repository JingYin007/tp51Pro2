<?php
/**
 * Created by PhpStorm.
 * User: moTzxx
 * Date: 2020/5/27
 * Time: 16:29
 */

namespace app\cms\controller;


use app\common\controller\CmsBase;
use app\common\model\XsysConf;
use think\Request;

class SysConf extends CmsBase
{
    private $model;
    public function __construct()
    {
        parent::__construct();
        $this->model = new XsysConf();
    }

    /**
     * 登录认证
     * @param Request $request
     * @return \think\response\View|void
     */
    public function auth(Request $request){
        if ($request->isPost()){
            $auth_tag = $request->post('auth_tag',null);
            $auth_val = $request->post('auth_val',null);
            $opRes = $this->model->updateAuthConf($auth_tag,$auth_val);
            return showMsg($opRes['tag'], $opRes['message']);
        }else{
            $authConf = config('sys_auth.');
            return view('auth',['authConf' => $authConf]);
        }
    }
    public function ftp(Request $request){
        if ($request->isPost()){
            return showMsg(0,'请求不合法！');
        }else{
            $authConf = config('auth.');

            return view('auth');
        }
    }
    public function ip(Request $request){
        if ($request->isPost()){
            return showMsg(0,'请求不合法！');
        }else{
            $authConf = config('auth.');

            return view('auth');
        }
    }
}