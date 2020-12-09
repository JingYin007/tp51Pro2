<?php
/**
 * 微信小程序 配置信息
 */

return [

    // 个人测试小程序
    'APP_ID' => 'wx680ed9137317644f',
    'APP_SECRET' => '01de707b2b666e0370a616e691e5e602',

    // 微信使用 code 换取用户 openid 及 session_key 的 url 地址
    'LOGIN_URL' => "https://api.weixin.qq.com/sns/jscode2session?".
        "appid=%s&secret=%s&js_code=%s&grant_type=authorization_code",

    // 微信获取 access_token 的 url 地址
    'ACCESS_TOKEN_URL' => "https://api.weixin.qq.com/cgi-bin/token?" .
        "grant_type=client_credential&appid=%s&secret=%s",

    //token 失效时间
    'TOKEN_EXPIRE_IN' => 7200,
    //token 加盐
    'TOKEN_SALT' => 'moTzxx0707x##sT',
];