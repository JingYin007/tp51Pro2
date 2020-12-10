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
    'IP_WHITE'=>'CLOSE',//是否启用IP白名单 ...

    'AES_KEY'=>'$MT30#@+D_@k*1!($@O%?',//自定义AES秘钥
    'AES_IV'=>'$m(^1&0_=:"Ts|\@',//自定义16位 AES偏移量
    'PWD_PRE_HALT'=>'YF3)_X*&$#@{(i_+d<>;^s',//密码加密前缀
    'SESSION_CMS_TAG'=>'cmsMoTzxxAID',//后台登录信息存储标记
    'SESSION_CMS_SCOPE'=>'MTXxPro',// 后台登录信息存储 作用域
    'TEST_AI'=>'nihjiao', //哈哈如果
];