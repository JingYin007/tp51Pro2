<?php
/**
 * Created by PhpStorm.
 * User: moTzxx
 * Date: 2019/8/7
 * Time: 11:11
 */
return [
    'FTP_USE' => false, //是否启用ftp上传功能
    //TODO 本地测试一般不需要图片服务器 null，
    //如果使用了图片服务器，需要进行对应更改，例：'http://img.xxxx.com/public'
    'IMG_SERVER_PUBLIC' => '',

    'SERVER' => '10.xxx.xxx.xx', //IP 如果满足内网IP条件，可大大提高传输效率
    'USER_NAME' => 'xxxx',//ftp帐户
    'PASSWORD' => 'xxxxxxxx',//ftp密码
    'PORT' => '21',//ftp端口,默认为21
    'PASV' => true,//是否开启被动模式,true开启,默认不开启
    'SSL' => false,//ssl连接,默认不开启
    'TIME_OUT' => 60,//超时时间,默认60,单位 s
];