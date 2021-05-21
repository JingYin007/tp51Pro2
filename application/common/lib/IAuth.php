<?php
/**
 * Created by PhpStorm.
 * User: moTzxx
 * Date: 2020/5/20
 * Time: 10:59
 */

namespace app\common\lib;
use app\common\model\Xadmins;
use think\Db;
use think\facade\Session;
use think\Request;

/**
 * 相关授权操作类
 * Class IAuth
 * @package app\api\controller
 */
class IAuth
{
    /**
     * 获取系统配置项
     * @param string $confTag
     * @return string
     */
    public static function AUTH_CONF($confTag = ''): string
    {
        return config("sys_auth.".$confTag);
    }

    /**
     * 设置后台管理员登录密码加密
     * @param string $password 明文
     * @return string
     */
    public static function setAdminUsrPassword($password = ''): string
    {
        $pws_pre_halt = self::AUTH_CONF('PWD_PRE_HALT');
        $md5_hash = strrev(md5($password.$pws_pre_halt));
        return password_hash($md5_hash,PASSWORD_DEFAULT );
    }

    /**
     * 检查后台管理员的登录密码是否合法
     * @param string $password
     * @param string $password_hash
     * @return bool
     */
    public static function checkAdminUsrPassword($password = '',$password_hash = ''): bool
    {
        $pws_pre_halt = self::AUTH_CONF('PWD_PRE_HALT');
        $md5_hash = strrev(md5($password.$pws_pre_halt));
        return password_verify ($md5_hash, $password_hash);
    }

    /**
     * 管理员登录成功后的信息 加密保存
     * @param int $op_id 管理员 ID
     * @param string $op_password 管理员密码
     */
    public static function setSessionAdminCurrLogged($op_id = 0,$op_password = '')
    {
        if ($op_id){
            $cmsRes = [
                'op_id' => $op_id,
                'op_password' => $op_password,
                'time_stamp' => time(),
                'op_ip' => (new Request())->ip()];
            $jsonRes = json_encode($cmsRes);
            //进行加密 并保存到Session中
            $cms_encrypt = self::encrypt($jsonRes,self::AUTH_CONF('AES_KEY'));
            Session::set(self::AUTH_CONF('SESSION_CMS_TAG'), $cms_encrypt,self::AUTH_CONF('SESSION_CMS_SCOPE'));
        }
    }
    /**
     * 获取当前登录状态下的管理员 ID信息
     * @return int
     */
    public static function getAdminIDCurrLogged(): int
    {
        $cmsRes = self::getDecryCmsRes();

        $time_stamp = $cmsRes['time_stamp'] ?? 0;
        //检查 登录 Session 的有效时间
        if ($time_stamp + config('session.expire') > time()){
            $cmsAID = $cmsRes['op_id'] ?? 0;
        }
        return isset($cmsAID)?intval($cmsAID):0;
    }

    /**
     * 检查密码是否变化
     * @param int $cmsAID 用户 ID
     * @return bool true:无变化；false: 有变化
     */
    public static function ckPasswordNoChangedCurrLogged($cmsAID = 0): bool
    {
        $cmsRes = self::getDecryCmsRes();
        $op_password = $cmsRes['op_password'] ?? '';
        $curr_password = (new Xadmins())->getPasswordByID($cmsAID);
        return $op_password === $curr_password;
    }

    /**
     * 获取 加密数据的 原始数组形式
     * @return array
     */
    public static function getDecryCmsRes(): array
    {
        if (Session::has(self::AUTH_CONF('SESSION_CMS_TAG'),self::AUTH_CONF('SESSION_CMS_SCOPE'))
            && Session::get(self::AUTH_CONF('SESSION_CMS_TAG'),self::AUTH_CONF('SESSION_CMS_SCOPE'))){

            $cms_encrypt = Session::get(self::AUTH_CONF('SESSION_CMS_TAG'),self::AUTH_CONF('SESSION_CMS_SCOPE'));
            $cms_decrypt = self::decrypt($cms_encrypt,self::AUTH_CONF('AES_KEY'));

            $cmsRes = json_decode($cms_decrypt,1);
        }
        return $cmsRes ?? [];
    }
    /**
     * 管理员账号退出操作
     */
    public static function logoutAdminCurrLogged(){
        if (Session::has(self::AUTH_CONF('SESSION_CMS_TAG'),self::AUTH_CONF('SESSION_CMS_SCOPE'))) {
            Session::delete(self::AUTH_CONF('SESSION_CMS_TAG'),self::AUTH_CONF('SESSION_CMS_SCOPE'));
        }
    }

    /*-------------------------分界线------------------下面是核心处理方法-------------------*/
    /**
     * 加密
     * @param String $input 加密的字符串
     * @param String $aes_key   解密的key
     * @return string
     */
    public static  function encrypt($input = '',$aes_key = ''): string
    {
        $data = openssl_encrypt(
                            $input,
                            'AES-256-CBC',
                            $aes_key,
                            OPENSSL_RAW_DATA,
                            self::AUTH_CONF('AES_IV'));
        return base64_encode($data);
    }

    /**
     * 解密
     * @param String $sStr 解密的字符串
     * @param String $aes_key   解密的key
     * @return String
     */
    public static function decrypt($sStr,$aes_key): string
    {
        return openssl_decrypt(
                        base64_decode($sStr),
                        'AES-256-CBC',
                        $aes_key,
                        OPENSSL_RAW_DATA,
                        self::AUTH_CONF('AES_IV'));
    }


}