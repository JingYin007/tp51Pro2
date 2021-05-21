<?php
/**
 * Created by PhpStorm.
 * User: moTzxx
 * Date: 2018/11/23
 * Time: 11:23
 */

namespace app\common\controller;

use app\common\lib\IAuth;
use app\common\model\Xadmins;
use app\common\model\XsysConf;
use think\db\exception\DataNotFoundException;
use think\db\exception\ModelNotFoundException;
use think\exception\DbException;

/**
 * 此类主要用于后台控制类的初始化操作
 * Class CmsBase
 * @package app\common\controller
 */
class CmsBase extends Base
{
    //定义每页的记录数
    public $page_limit;
    /**
     * 初始化处理数据
     * Base constructor.
     */
    public function __construct()
    {
        parent::__construct();
        $this->page_limit = config('app.CMS_PAGE_SIZE');
        $this->initAuth();
    }

    /**
     * 进行权限控制
     */
    public function initAuth()
    {
        $authFlag = false;
        $cmsAID = IAuth::getAdminIDCurrLogged();
        if (!$cmsAID) {
            $message = "You are offline,please logon again！";
        } else {
            //TODO 检查密码是否更改

            if (!IAuth::ckPasswordNoChangedCurrLogged($cmsAID)){
                $message = "Your password has changed,please logon again！";
            }else{
                $sysConf = new XsysConf();
                if ($sysConf->checkCmsIpAuth()){
                    //TODO 判断当前用户是否具有此操作权限
                    try {
                        $authFlag = $this->checkCmsAdminAuth($cmsAID);
                        $message = $authFlag ? "权限正常" : "Sorry,You don't have permission!";
                    } catch (DataNotFoundException | DbException $e) {
                        $message = $e->getMessage();
                    }
                }else{
                    $message = "Sorry,Your IP is abnormal, please contact the administrator!";
                }
            }
        }
        if (!$authFlag) {showMsg(intval($authFlag), $message);}
    }

    /**
     * 检查权限
     * @param int $adminID
     * @return bool
     */
    public function checkCmsAdminAuth($adminID = 0): bool
    {
        $action = trim(strtolower(request()->action()));
        $request_url = trim(strtolower($_SERVER["REQUEST_URI"]));
        $authUrl = explode($action, $request_url)[0] . $action;
        //对待检测的URL 忽略大小写
        return (new Xadmins())->checkAdminAuth($adminID, $authUrl);
    }

}