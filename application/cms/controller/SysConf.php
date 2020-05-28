<?php
/**
 * Created by PhpStorm.
 * User: moTzxx
 * Date: 2020/5/27
 * Time: 16:29
 */

namespace app\cms\controller;


use app\common\controller\CmsBase;
use think\Request;

class SysConf extends CmsBase
{
    public function __construct()
    {
        parent::__construct();
    }

    /**
     * 登录认证
     * @param Request $request
     * @return \think\response\View|void
     */
    public function auth(Request $request){
        if ($request->isPost()){
            return showMsg(0,'请求不合法！');
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