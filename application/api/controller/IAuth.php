<?php
/**
 * Created by PhpStorm.
 * User: moTzxx
 * Date: 2020/5/20
 * Time: 10:59
 */

namespace app\api\controller;
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
     * 初始化配置信息
     * 根据注释，进行配置，提高系统安全性
     * @var string
     */
    protected static $key = '12*()_3XXmoTzxx078734224';//自定义-注意保证24位字符串
    protected static $set_pwd_pre_halt = '_#*moTzxx#mEx77BHGFSEDF'; //密码加密前缀
    protected static $session_cms_tag = 'cmsMoTzxxAID';//后台登录信息存储标记
    protected static $session_cms_scope = 'tp51Pro';// 后台登录信息存储 作用域


    /**
     * 设置后台管理员登录密码加密
     * @param string $password
     * @return string
     */
    public static function setAdminUsrPassword($password = ''){
        $res = md5(base64_encode($password).self::$set_pwd_pre_halt);
        return $res;
    }

    /**
     * 管理员登录成功后的信息 加密保存
     * @param int $op_id
     */
    public static function setSessionAdminCurrLogged($op_id = 0)
    {
        if ($op_id){
            $cmsRes = [
                'op_id' => $op_id,
                'time_stamp' => time(),
                'op_ip' => (new Request())->ip()];
            $jsonRes = json_encode($cmsRes);
            //进行加密 并保存到Session中
            $cms_encrypt = self::encrypt($jsonRes);
            Session::set(self::$session_cms_tag, $cms_encrypt,self::$session_cms_scope);
        }
    }
    /**
     * 获取当前登录状态下的管理员 ID信息
     * @return int
     */
    public static function getAdminIDCurrLogged(){
        $cmsRes = self::getDecryCmsRes();

        $time_stamp = isset($cmsRes['time_stamp'])?$cmsRes['time_stamp']:0;
        //检查 登录Session 的有效时间
        if ($time_stamp + config('session.expire') > time()){
            $cmsAID = isset($cmsRes['op_id'])?$cmsRes['op_id']:0;
        }
        return isset($cmsAID)?intval($cmsAID):0;
    }

    /**
     * 获取 加密数据的 原始数组形式
     * @return array|mixed
     */
    public static function getDecryCmsRes(){
        if (Session::has(self::$session_cms_tag,self::$session_cms_scope)
            && Session::get(self::$session_cms_tag,self::$session_cms_scope)){
            $cms_encrypt = Session::get(self::$session_cms_tag,self::$session_cms_scope);
            $cms_decrypt = self::decrypt($cms_encrypt);
            $cmsRes = json_decode($cms_decrypt,1);
        }
        return isset($cmsRes)?$cmsRes:[];
    }
    /**
     * 管理员账号退出操作
     */
    public static function logoutAdminCurrLogged(){
        if (Session::has(self::$session_cms_tag,self::$session_cms_scope)) {
            Session::delete(self::$session_cms_tag,self::$session_cms_scope);
        }
    }

    /*-------------------------分界线------------------下面是核心处理方法-------------------*/
    /**
     * 加密
     * @param String input 加密的字符串
     * @param String key   解密的key
     * @return HexString
     */
    public static  function encrypt($input = '') {
        $size = mcrypt_get_block_size(MCRYPT_RIJNDAEL_128, MCRYPT_MODE_ECB);
        $input = self::pkcs5_pad($input, $size);
        $td = mcrypt_module_open(MCRYPT_RIJNDAEL_128, '', MCRYPT_MODE_ECB, '');
        $iv = mcrypt_create_iv(mcrypt_enc_get_iv_size($td), MCRYPT_RAND);
        mcrypt_generic_init($td, self::$key, $iv);

        $data = mcrypt_generic($td, $input);
        mcrypt_generic_deinit($td);
        mcrypt_module_close($td);
        $data = base64_encode($data);
        return $data;
    }
    /**
     * 填充方式 pkcs5
     * @param String text 		 原始字符串
     * @param String blocksize   加密长度
     * @return String
     */
    public static function pkcs5_pad($text, $blocksize) {
        $pad = $blocksize - (strlen($text) % $blocksize);
        return $text . str_repeat(chr($pad), $pad);
    }

    /**
     * 解密
     * @param String input 解密的字符串
     * @param String key   解密的key
     * @return String
     */
    public static function decrypt($sStr) {
        $decrypted= mcrypt_decrypt(MCRYPT_RIJNDAEL_128,self::$key,base64_decode($sStr), MCRYPT_MODE_ECB);
        $dec_s = strlen($decrypted);
        $padding = ord($decrypted[$dec_s-1]);
        $decrypted = substr($decrypted, 0, -$padding);

        return $decrypted;
    }
}