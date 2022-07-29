<?php
// +----------------------------------------------------------------------
// | ThinkPHP [ WE CAN DO IT JUST THINK ]
// +----------------------------------------------------------------------
// | Copyright (c) 2006~2018 http://thinkphp.cn All rights reserved.
// +----------------------------------------------------------------------
// | Licensed ( http://www.apache.org/licenses/LICENSE-2.0 )
// +----------------------------------------------------------------------
// | Author: liu21st <liu21st@gmail.com>
// +----------------------------------------------------------------------
/**
 * 前台页面  仅作简单展示
 */
Route::get('/','index/index/index');
Route::get('article/:id','index/index/article');
Route::get('/index/review','index/index/review');
Route::get('/index/contact','index/index/contact');
Route::get('/index/test','index/index/test');

/**
 * 后台 CMS配置
 */
Route::rule('cmsx','cms/index/index');
Route::get('cms/index/index','cms/index/index');
Route::get('cms/home','cms/index/home');

Route::get('cms/chat/index/:to_id','cms/chat/index');
Route::any('cms/chat/lists','cms/chat/lists');
Route::post('cms/chat/save_message','cms/chat/save_message');
Route::post('cms/chat/load','cms/chat/load');
Route::post('cms/chat/changeNoRead','cms/chat/changeNoRead');
Route::post('cms/chat/ajax_get_noReadCount','cms/chat/ajax_get_noReadCount');
Route::post('cms/chat/ajax_get_user_list','cms/chat/ajax_get_user_list');

Route::any('cms/index/admin/:id','cms/index/admin');

//日志管理
Route::any('cms/serverLog/log_index','cms/serverLog/log_index');

//后台导航菜单管理
Route::any('cms/menu/index','cms/navMenu/index');
Route::any('cms/menu/add','cms/navMenu/add');
Route::any('cms/menu/edit/:id','cms/navMenu/edit');
Route::any('cms/menu/auth/:id','cms/navMenu/auth');
Route::any('cms/menu/updateAuth/:id','cms/navMenu/updateAuth');


//今日赠言管理
Route::any('cms/todayWord/index','cms/todayWord/index');
Route::any('cms/todayWord/add','cms/todayWord/add');
Route::any('cms/todayWord/edit/:id','cms/todayWord/edit');


//文章管理
Route::any('cms/article/index','cms/article/index');
Route::any('cms/article/add','cms/article/add');
Route::any('cms/article/edit/:id','cms/article/edit');
Route::post('cms/article/ajaxForRecommend','cms/article/ajaxForRecommend');
Route::get('cms/article/viewLogs/:id','cms/article/viewLogs');


//配置信息管理
Route::any('cms/config/index','cms/config/index');
Route::any('cms/config/add','cms/config/add');
Route::any('cms/config/edit/:id','cms/config/edit');
Route::post('cms/config/ajaxUpdateSwitchValue','cms/config/ajaxUpdateSwitchValue');


//系统信息配置
Route::any('cms/sysConf/auth','cms/sysConf/auth');
Route::any('cms/sysConf/opfile','cms/sysConf/opfile');
Route::any('cms/sysConf/ipWhite','cms/sysConf/ipWhite');


//管理员
Route::any('cms/admin/index','cms/admin/index');
Route::any('cms/admin/addAdmin','cms/admin/addAdmin');
Route::any('cms/admin/editAdmin/:id', 'cms/admin/editAdmin');


//角色管理
Route::any('cms/admin/role','cms/admin/role');
Route::any('cms/admin/addRole','cms/admin/addRole');
Route::any('cms/admin/editRole/:id', 'cms/admin/editRole');


//后台登录管理
Route::get('cms/login/index','cms/login/index');
Route::any('cms/login/logout','cms/login/logout');
Route::post('cms/login/ajaxLogin','cms/login/ajaxLogin');
Route::post('cms/login/ajaxCheckLoginStatus','cms/login/ajaxCheckLoginStatus');


/**
 * 网站业务
 */
//分类管理
Route::any('cms/category/index','cms/category/index');
Route::any('cms/category/add','cms/category/add');
Route::any('cms/category/edit/:id','cms/category/edit');
Route::post('cms/category/ajaxForShow','cms/category/ajaxForShow');

Route::any('cms/brand/index','cms/brand/index');
Route::any('cms/brand/add','cms/brand/add');
Route::any('cms/brand/edit/:id','cms/brand/edit');


//商品管理
Route::any('cms/goods/index','cms/goods/index');
Route::any('cms/goods/add','cms/goods/add');
Route::any('cms/goods/edit/:id','cms/goods/edit');
Route::post('cms/goods/ajaxPutaway','cms/goods/ajaxPutaway');
Route::get('cms/goods/viewLogs/:id','cms/goods/viewLogs');

Route::post('cms/goods/ajaxGetNormalCatList','cms/goods/ajaxGetNormalCatList');
Route::post('cms/goods/ajaxGetBrandAndSpecInfoFstByCat','cms/goods/ajaxGetBrandAndSpecInfoFstByCat');
Route::post('cms/goods/ajaxGetSpecInfoBySpecFst','cms/goods/ajaxGetSpecInfoBySpecFst');


//属性管理
Route::any('cms/specInfo/index','cms/specInfo/index');
Route::any('cms/specInfo/add','cms/specInfo/add');
Route::any('cms/specInfo/edit/:id','cms/specInfo/edit');
Route::any('cms/specInfo/details','cms/specInfo/details');


//活动管理
Route::any('cms/activity/index','cms/activity/index');
Route::any('cms/activity/add','cms/activity/add');
Route::any('cms/activity/edit/:id','cms/activity/edit');
Route::post('cms/activity/ajaxForShow','cms/activity/ajaxForShow');
Route::post('cms/activity/ajaxGetGoodsByCat','cms/activity/ajaxGetGoodsByCat');
//广告管理
Route::any('cms/adList/index','cms/adList/index');
Route::any('cms/adList/add','cms/adList/add');
Route::any('cms/adList/edit/:id','cms/adList/edit');
Route::post('cms/adList/ajaxForShow','cms/adList/ajaxForShow');

//用户管理
Route::any('cms/users/index','cms/users/index');
Route::post('cms/users/ajaxUpdateUserStatus','cms/users/ajaxUpdateUserStatus');

// 订单管理
Route::any('cms/order/index','cms/order/index');
Route::any('cms/order/details','cms/order/details');
Route::post('cms/order/ajaxGetShoppingList','cms/order/ajaxGetShoppingList');
Route::any('cms/order/opCourierSn','cms/order/opCourierSn');
Route::any('cms/order/lookLogistics/:op_id','cms/order/lookLogistics');

//统计分析
Route::any('cms/analyze/hotSale','cms/analyze/hotSale');
Route::any('cms/analyze/timeSale','cms/analyze/timeSale');


//拓展学习管理
Route::any('cms/expand/react','cms/expand/react');
Route::any('cms/expand/test','cms/expand/test');
Route::any('cms/expand/opExcel','cms/expand/opExcel');
Route::any('cms/expand/shtmlx','cms/expand/shtmlx');
Route::any('cms/expand/redisTest','cms/expand/redisTest');
/**
 * 工具类
 */
Route::post('cms/upload_img_file','cms/index/upload_img_file');
Route::any('api/upload/test','api/upload/test');


/**
 * 微信小程序 登录及验证设计接口
 */
Route::any('wxapi/WxBase/getAuthToken','wxapi/WxBase/getAuthToken');
Route::post('wxapi/WxBase/verifyToken','wxapi/WxBase/verifyToken');
// 小程序测试接口
Route::any('wxapi/WxBase/getArticleInfo','wxapi/WxBase/getArticleInfo');
Route::any('wxapi/WxBase/address','wxapi/WxBase/address');






