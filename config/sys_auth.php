<?php
/**
 * 系统+认证 配置文件
 * 初始化配置信息
 * 根据注释，进行配置，提高系统安全性
 *
 * Created by PhpStorm.
 * User: moTzxx
 * Date: 2020/5/27
 * Time: 14:45
 */
return [
    'FTP_USE' => false, //是否启用ftp上传功能，true时，请对应修改配置文件 “ftp.php”
    'IP_WHITE' => false,//是否启用IP白名单，true时 ...

    'AES_KEY' => '_7+()HU&&@^#@%8dd73sK',//自定义AES秘钥
    'AES_IV'  =>    '170MT07**(&^#@6E',//自定义16位 AES偏移量
    'PWD_PRE_HALT' => '_#*moTzxx#mEx77BHGFSEDF',//密码加密前缀
    'SESSION_CMS_TAG' => 'cmsMoTzxxAID',//后台登录信息存储标记
    'SESSION_CMS_SCOPE' => 'tp51Pro',// 后台登录信息存储 作用域
    'TEST_AI'=>'nihjiao', //哈哈如果
];