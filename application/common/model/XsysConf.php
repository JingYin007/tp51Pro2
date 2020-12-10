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
use think\facade\Validate;
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
     * @param array $postData
     * @return array
     * @throws \think\Exception
     * @throws \think\exception\PDOException
     */
    public function updateAuthConf($postData = []){
        $opTag = false;
        $rule = [
            'PWD_PRE_HALT'  => 'require|min:16|max:24',
            'AES_KEY'   => 'require|min:20|max:30',
            'AES_IV' => 'require|length:16',
            'SESSION_CMS_TAG'  => 'require|min:12|max:30',
            'SESSION_CMS_SCOPE'   => 'require|min:6|max:20',
        ];

        $msg = [
            'PWD_PRE_HALT' => '加密前缀建议16-24个字符',
            'AES_KEY'     => 'AES秘钥建议20-30个字符',
            'AES_IV'   => 'AES_IV 偏移量要求16个字符',
            'SESSION_CMS_TAG'  => 'SESSION存储键要求12-30个字符',
            'SESSION_CMS_SCOPE'        => 'SESSION作用域要求6-20个字符',
        ];
        $validate   = Validate::make($rule,$msg);
        $result = $validate->check($postData);

        if(!$result) {
            $opMessage = $validate->getError();
        }else{
            $arrAuthTag = $arrAuthVal = null;
            foreach ($postData as $key => $value) {
                $arrAuthTag[] = $key;
                $arrAuthVal[] = $value;
            }
            $opTag = set_cms_config($arrAuthTag,$arrAuthVal,'sys_auth');
            if ($opTag){
                //进行默认管理员的设置
                Db::name('xadmins')->where('id',1)
                    ->update([
                        'user_name' => 'moTzxx@admin',
                        'password'  =>  IAuth::setAdminUsrPassword('admin'),
                        'status'    => 1,
                        'role_id' => 1,
                    ]);
            }
            $opMessage = $opTag?"更新成功":"Sorry，请稍后重试！";

        }
        return ['tag' => $opTag,'message' => $opMessage];
    }

    /**
     * 获取文件操作选取方式
     * @return string
     */
    public function getOpFileUseSel(){
        $sel = "L";
        $ftpUse = config('ftp.FTP_USE');
        if ($ftpUse == "OPEN") {
            $sel='FTP';
        }else{
            $qnUse = config('qiniu.QN_USE');
            if ($qnUse == "OPEN") $sel="QN";
        }
       return $sel;
    }
    /**
     * 更新文件操作选取方式
     * @param string $conf_tag
     * @param string $opTag
     * @param string $opVal
     * @return array
     */
    public function updateOpFileConf($conf_tag='',$opTag = '',$opVal = ''){

        if ($opTag == 'USE_SEL'){
            switch ($opVal){
                case 'L':
                    $opStatus1 = set_cms_config(['FTP_USE'],['CLOSE'],'ftp');
                    $opStatus2 = set_cms_config(['QN_USE'],['CLOSE'],'qiniu');
                    break;
                case 'FTP':
                    $opStatus1 = set_cms_config(['FTP_USE'],['OPEN'],'ftp');
                    $opStatus2 = set_cms_config(['QN_USE'],['CLOSE'],'qiniu');
                    break;
                case 'QN':
                    $opStatus1 = set_cms_config(['FTP_USE'],['CLOSE'],'ftp');
                    $opStatus2 = set_cms_config(['QN_USE'],['OPEN'],'qiniu');
                    break;
                default:
                    $opStatus1=$opStatus2=0;
                    break;
            }
            $opStatus = $opStatus1&&$opStatus2;
        }else{
            switch ($conf_tag){
                case 'ftp':
                    $opStatus = set_cms_config([$opTag],[$opVal],'ftp');
                    break;
                case 'qn':
                    $opStatus = set_cms_config([$opTag],[$opVal],'qiniu');
                    break;
                default:
                    $opStatus = 0;
                    break;
            }
        }
        $opMessage = $opStatus?"配置更新成功":"Sorry，请稍后重试！";
        return ['tag' => $opStatus,'message' => $opMessage];
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
                $opRes = $this->setIpWhite($val);
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
     * 设置IP白名单操作
     * @param $authVal
     * @return array
     */
    public function setIpWhite($authVal){
        $opTag = set_cms_config(['IP_WHITE'],[$authVal],'sys_auth');
        $opMessage = $opTag?"更新成功":"Sorry，请稍后重试！";
        return ['tag' => $opTag,'message' => $opMessage];
    }
    /**
     * 删除 IP
     * @param string $ipVal
     * @return array
     */
    public function delIpWhite($ipVal = ''){
        if ($ipVal){
            $tag = Db::name('xipWhites')->where('ip',$ipVal)->update(['status'=>-1]);
            $message = $tag?'数据删除成功':"删除失败";
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