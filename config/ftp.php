<?php
/**
 * Created by PhpStorm.
 * User: moTzxx
 * Date: 2019/8/7
 * Time: 11:11
 */
return [
    'server' => '10.xxx.xxx.xx', //IP 如果满足内网IP条件，可大大提高传输效率
    'username' => 'xxxx',//ftp帐户
    'password' => 'xxxxxxxx',//ftp密码
    'port' => '21',//ftp端口,默认为21
    'pasv' => true,//是否开启被动模式,true开启,默认不开启
    'ssl' => false,//ssl连接,默认不开启
    'time_out' => 60,//超时时间,默认60,单位 s
];