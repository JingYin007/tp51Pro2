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
use think\Model;

class XsysConf extends Model
{
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
}