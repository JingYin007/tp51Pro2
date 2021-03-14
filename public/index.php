<?php
// +----------------------------------------------------------------------
// | ThinkPHP [ WE CAN DO IT JUST THINK ]
// +----------------------------------------------------------------------
// | Copyright (c) 2006-2016 http://thinkphp.cn All rights reserved.
// +----------------------------------------------------------------------
// | Licensed ( http://www.apache.org/licenses/LICENSE-2.0 )
// +----------------------------------------------------------------------
// | Author: liu21st <liu21st@gmail.com>
// +----------------------------------------------------------------------
#    ┏┓   ┏┓
#   ┏┛┻━━━┛┻┓
#   ┃       ┃
#   ┃   ━   ┃
#   ┃ ┳┛ ┗┳ ┃
#   ┃       ┃
#   ┃   ┻   ┃
#   ┃       ┃
#   ┗━┓   ┏━┛Codes are far away from bugs with the animal protecting
#     ┃   ┃    神兽保佑,代码无bug
#     ┃   ┃
#     ┃   ┗━━━┓
#     ┃         ┣┓
#     ┃          ┏┛
#     ┗┓┓┏━┳┓┏┛
#      ┃┫┫ ┃┫┫
#      ┗┻┛ ┗┻┛
// [ 应用入口文件 ]
namespace think;
//phpinfo();
// 加载基础文件
require __DIR__ . '/../thinkphp/base.php';

// 支持事先使用静态方法设置Request对象和Config对象

// 执行应用并响应
Container::get('app')
    ->bind('index')
    ->run()
    ->send();

//阅读源码 提供技能 加嘞个油！