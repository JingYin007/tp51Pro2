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
use think\response\View;

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
     * @return View|void
     */
    public function auth(Request $request){
        if ($request->isPost()){
            $opRes = $this->model->updateAuthConf($request->post());
            showMsg($opRes['tag'], $opRes['message']);
        }else{
            $authConf = config('sys_auth.');
            return view('auth',['authConf' => $authConf]);
        }
    }

    /**
     * 文件上传 操作指示
     * @param Request $request
     * @return View|void
     */
    public function opfile(Request $request){
        if ($request->isPost()){
            $conf_tag = $request->post('conf_tag',null);
            $op_tag = $request->post('op_tag',null);
            $op_val = $request->post('op_val',null);
            $opRes = $this->model->updateOpFileConf($conf_tag,$op_tag,$op_val);
            showMsg($opRes['tag'],$opRes['message']);
        }else{
            $ftpConf = config('ftp.');
            $qnConf = config('qiniu.');
            $use_sel = $this->model->getOpFileUseSel();
            return view('opfile',['ftpConf'=>$ftpConf,'qnConf'=>$qnConf,'SEL'=>$use_sel]);
        }
    }

    /**
     * IP白名单
     * @param Request $request
     * @return View|void
     */
    public function ipWhite(Request $request){
        if ($request->isPost()){
            $opRes = $this->model->ajaxUpdateIpData($request->post());
            showMsg($opRes['tag'],$opRes['message']);
        }else{
            $IP_WHITE = config('sys_auth.IP_WHITE');
            $ipWhites = $this->model->getIpWhites();
            return view('ip',['IP_WHITE' => $IP_WHITE,'ipWhites' =>$ipWhites]);
        }
    }

}