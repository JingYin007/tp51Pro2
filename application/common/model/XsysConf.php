<?php
/**
 * Created by PhpStorm.
 * User: moTzxx
 * Date: 2020/5/28
 * Time: 14:34
 */

namespace app\common\model;


use app\common\lib\IAuth;
use think\Db;
use think\facade\Request;
use think\Model;

/**
 * 系统配置操作类
 * Class XsysConf
 * @package app\common\model
 */
class XsysConf extends Model
{
    /**
     * 更新登录认证配置数据
     * @param string $authTag
     * @param string $authVal
     * @return array
     */
    public function updateAuthConf($authTag = '',$authVal = ''){
        $opTag = false;
        if ($authVal == '' or empty($authVal)){
            $opMessage = "配置数据不能为空";
        }else{
            if ($authTag == 'AES_IV' && strlen($authVal)!==16){
                $opMessage = "AES 偏移量不是16位！";
            }else{
                $opTag = set_cms_config([$authTag],[$authVal],'sys_auth');
                if ($opTag && $authTag == "PWD_PRE_HALT"){
                    //进行默认管理员的设置
                    Db::name('xadmins')->where('id',1)
                        ->update([
                            'user_name' => 'moTzxx@admin',
                            'password'  =>  IAuth::setAdminUsrPassword('admin',$authVal),
                            'status'    => 1,
                            'role_id' => 1,
                        ]);
                }
                $opMessage = $opTag?"更新成功":"Sorry，请稍后重试！";
            }
        }
        return ['tag' => $opTag,'message' => $opMessage];
    }

    /**
     * @param string $ftpTag
     * @param string $ftpVal
     * @return array
     */
    public function updateFtpConf($ftpTag = '',$ftpVal = ''){
        if ($ftpTag == "FTP_USE"){
            $ftpVal = $ftpVal?'OPEN':'CLOSE';
        }
        $opTag = set_cms_config([$ftpTag],[$ftpVal],'ftp');
        $opMessage = $opTag?"更新成功":"Sorry，请稍后重试！";
        return ['tag' => $opTag,'message' => $opMessage];
    }

    /**
     * 获取正常状态下的 ip
     * @return array|\PDOStatement|string|\think\Collection
     */
    public function getIpWhites(){
        $res = Db::name('xipWhites')
            ->field('ip,floor(rand()*6) rand')
            ->where('status',1)
            ->select();
        return isset($res)? $res:[];
    }

    /**
     * ajax 更新IP白名单数据
     * @param array $req
     * @return array
     */
    public function ajaxUpdateIpData($req = []){
        $opTag = isset($req['tag'])?$req['tag']:'S';
        switch ($opTag){
            case 'S'://进行服务开启、关闭
                $val = $req['val']?'OPEN':'CLOSE';
                $opRes = $this->updateAuthConf('IP_WHITE',$val);
                break;
            case 'A'://添加IP地址
                $val = $req['val']?trim($req['val']):'';
                $opRes = $this->addIpWhite($val);
                break;
            case 'D'://删除IP地址
                $val = $req['val']?trim($req['val']):'';
                $opRes = $this->delIpWhite($val);
                break;
            default:
                $opRes = [];
                break;
        }
        return $opRes;
    }

    /**
     * 删除 IP
     * @param string $ipVal
     * @return array
     */
    public function delIpWhite($ipVal = ''){
        if ($ipVal){
            $tag = Db::name('xipWhites')->where('ip',$ipVal)->update(['status'=>-1]);
            $message = $tag?'删除成功':"删除失败";
        }else{
            $tag = 0;
            $message = "获取IP信息失败！";
        }
        return ['tag'=>$tag,'message' => $message];
    }
    /**
     * 添加 IP 地址
     * @param string $ipVal
     * @return array
     */
    public function addIpWhite($ipVal = ''){
        $tag = 0;
        if (!$ipVal){
            $message = '请输入IP地址！';
        }else{
            $ipVal = trim($ipVal);
            if (filter_var($ipVal,FILTER_VALIDATE_IP)){
                $count = Db::name('xipWhites')->where('ip',$ipVal)->field('status')->find();
                if ($count){
                    if ($count['status'] == 1){
                        $message = "Sorry，该IP地址已存在！";
                    }else{
                        $tag = Db::name('xipWhites')->where('ip',$ipVal)->update(['status'=>1]);
                    }
                }else{
                    $tag = Db::name('xipWhites')->insertGetId(['ip'=>$ipVal]);
                }
                $message = isset($message)?$message:"IP 添加成功";
            }else{
                $message = "Sorry，IP地址不规范！";
            }
        }
        return ['tag' => $tag?1:0,'message' => $message];
    }

    /**
     * 检查是否在白名单中
     * @param string $ipVal
     * @return bool
     */
    public function checkIpAuth($ipVal = ''){
        $ipStatus =  Db::name('xipWhites')->where('ip',$ipVal)->value('status');
        return $ipStatus==1?true:false;
    }
    /**
     * 检查IP白名单开启状态下是否有权限
     * @return bool
     */
    public function checkCmsIpAuth(){
        $authTag = true;
        $IP_WHITE = config('sys_auth.IP_WHITE');
        if ($IP_WHITE == 'OPEN'){
            //TODO 当前IP 是否在白名单中
            $ipMark = Request::ip();
            $checkTag = (new XsysConf())->checkIpAuth($ipMark);
            if ($checkTag){
                $authTag = true;
            }else{
                $authTag = false;
            }
        }
        return $authTag;
    }
}