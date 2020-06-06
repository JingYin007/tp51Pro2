<?php
/**
 * Created by PhpStorm.
 * User: moTzxx
 * Date: 2019/8/7
 * Time: 11:11
 */
return [
    'FTP_USE'=>'CLOSE', //是否启用ftp上传功能
    //TODO 本地测试一般不需要图片服务器 null，
    // 默认“/”,如果使用图片服务器，例：'http://img.xxxx.com/public/'
    'IMG_SERVER_PATH'=>'',
    'IMG_SAVE_PATH'=>'/public/upload/',// FTP服务器中的图片存储路径

    'SERVER'=>'1xx.xx.x.xxx', //IP 如果满足内网IP条件，可大大提高传输效率
    'USER_NAME'=>'fexxwx8',//ftp帐户
    'PASSWORD'=>'1xxxxx',//ftp密码
    'PORT'=>'21',//ftp端口,默认为21
    'PASV' => true,//是否开启被动模式,true开启,默认不开启
    'SSL' => false,//ssl连接,默认不开启
    'TIME_OUT' => 60,//超时时间,默认60,单位 s
];