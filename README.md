# ☁ 前言

> **【重要】**：
> - 如果你先前已经下载了源码，后期发现存在些许问题时
> 请及时反馈给我，以便及时更新；
> 或者回来参考我更新的内容，尤其是 `“使用指导”` 部分，或许这时我已经自测并做了补充信息哦.

```b
框架版本： ThinkPHP5.2.12
后台入口： xxxxx.com/cmsx;
```
- 最新更新：

```php
2019-11-25
 	> 整体项目优化
	> 集中处理了页面显示样式
	> 整合公用 CSS、JS 代码
	> 设计商品管理功能、优化 SKU编辑
	> 完善代码注释，优化数据库,更新 .sql文件
```

> 推荐一款正在优化中CMS管理系统 —— [**Lin-CMS**](http://doc.cms.7yue.pro/)

## ①. 闲话闲说
```b
- 近期使用 LayUI 的过程中；
- 越发觉得对方的设计理念符合我的审美，主要是后台开发者使用简单；
- 而另一方面；
- 想到作为一名 PHPer 却一直没有一套属于自己的后台管理系统；
- 所以决定花费一些时间；
- 在借鉴官方文档和其他开发者设计思路的前提下，打造一个属于自己的后台管理系统 ...
```
## ②. 提示信息

> 系统设计：后端基于`PHP`语言设计，前端基于 `Layui` 模块化框架
- 参考案例：[***发现 LayUI 年度最佳案例***](http://fly.layui.com/case/2017/)

```b
> 补充时间：[2018-11-21 19:36]
> 项目开发中，难免会用到一些比较流行的 PHP开发框架， 所以在此提供 ThinkPHP5.1 框架下整理的系统代码
> 近期抽出时间，正在优化 ThinkPHP5  这个框架的代码，可用，也希望多给指点，进行后期的优化升级
> 后期的更新优化记录，会补充到后面的附录中 ...
```
![](https://img-blog.csdnimg.cn/20191126092549452.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3UwMTE0MTU3ODI=,size_16,color_FFFFFF,t_70)

# ☁ 一 主要功能
> 毕竟一个人瞎折腾，能力有限，暂且展示已完成的主要功能，欢迎指摘以及技术指导，道友参上！

## ①. 菜单管理

> 菜单的链接即为定义的路由

- 根据鄙人设计思路：一般若是根级目录下有二级目录时，此根级目录的链接不生效，不然无法正确引导其他页面
![](https://img-blog.csdnimg.cn/20191126092738733.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3UwMTE0MTU3ODI=,size_16,color_FFFFFF,t_70)

- ***说明信息***
```b
> 主要注意的是其中的 "action"  的填写，可以参考已有的数据，这是对应于路由文件中的写法
```
## ②. 管理员列表

> 后期如果添加更多的信息，可自行扩展，此处是主要的属性信息
![](https://img-blog.csdnimg.cn/20191126092930510.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3UwMTE0MTU3ODI=,size_16,color_FFFFFF,t_70)
- ***说明信息***
```b
> 对于密码的加密，一般每个开发者都有自己的想法，我的加密比较简单 md5+base64，可自行复杂性优化
> 封装处理方法为：cmsAdminToLoginForPassword() 
> 修改数据的时候，注意，如果不想改动密码，是无需进行填写的！
```

## ③. 角色管理

> 此功能主要是为了给管理员分配不同的权限

- 即打开的导航菜单更有不同，以避免权力的滥用，这部分的 `js` 代码写的最耗费时间
![](https://img-blog.csdnimg.cn/20191126093159804.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3UwMTE0MTU3ODI=,size_16,color_FFFFFF,t_70)

## ④. 角色管理

> 此处，最近参考 `ThinkPHP` 之前框架对权限的设计，进行了补充优化
![](https://img-blog.csdnimg.cn/20191126093809534.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3UwMTE0MTU3ODI=,size_16,color_FFFFFF,t_70)
- ***说明信息***
```b
> 1.对于权限控制功能，隐藏的比较深; 要求只对二级菜单后 做权限控制，以区分不同角色的分级管理
> 2.跟菜单的添加操作一样，填错了直接后面删除即可，感觉这样更少了麻烦
> 3.注意，新补充的方法链接如果不做权限的添加，那很可能无法访问哦！
```
## ⑤. 文章管理

> 这是常规的后台信息管理功能，其次还有个`“今日赠言”`，也是大同小异
![](https://img-blog.csdnimg.cn/2019112609395817.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3UwMTE0MTU3ODI=,size_16,color_FFFFFF,t_70)
- 此处较为亮点的功能即为 `layer文件上传`、`UEditor富文本编辑器` 的使用

> [***Laravel+Layer 图片上传功能整理***](http://blog.csdn.net/u011415782/article/details/78961365)

# ☄ 二 使用指导
>对于项目的安装配置,毕竟是两种不同的框架设计，所以在使用上，需要 `“因材施教”`，在此进行分别指导说明

- ## 第一步. 执行下面的命令，加载 `ThinkPHP` 框架核心代码
```b
composer install
```
![](https://img-blog.csdnimg.cn/20181126191857684.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3UwMTE0MTU3ODI=,size_16,color_FFFFFF,t_70)
- 此时，请确认一下文件 `\vendor\topthink\think-captcha\src\helper.php` 中的 `captcha_img（）` 方法，并进行覆写如下：
```php
function captcha_img($id = '')
{
    $js_src = "this.src='".captcha_src()."'";
    return '<img src="' . captcha_src($id) . '" title="点击更新验证码" alt="点击更新验证码" onclick="'.$js_src.'" />';
    //return '<img src="' . captcha_src($id) . '" alt="captcha" />';
}
```
> 此处操作，保证登录验证码的正常使用，可参看文章 :【[ ***`ThinkPHP5.0+ 验证码功能实现`***](https://blog.csdn.net/u011415782/article/details/77367280)】

- ## 第二步. 获取数据库数据

> 为了操作方便，建议打开 `MySql `管理工具，直接运行所提供的  `"database/tp5_pro.sql"`  数据库文件
![](https://img-blog.csdnimg.cn/20191126094349789.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3UwMTE0MTU3ODI=,size_16,color_FFFFFF,t_70)
- ***说明信息***
```b
> 其次就是到 config/database.php 文件中，配置正确的数据库连接信息
  这是鄙人的默认数据，后期可自行修改优化.
> 注意前面的 运行 composer 命令;
  强烈建议学习新版本的框架，要学会使用composer哦
```
> 无聊的话，也可以试看一下之前写的一篇 `Composer` 简单使用 ——   [Composer de涉水初探](https://blog.csdn.net/u011415782/article/details/77198390)

- ## 第三步. 修改开源框架 `Ueditor` 的配置项

>  可参考之前的文章 —— 【[***Laravel 框架集成 UEditor 编辑器的方法***](http://blog.csdn.net/u011415782/article/details/78909750)】 ,为保证项目的正常使用，示例图如下：
![](https://img-blog.csdnimg.cn/20181128122623711.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3UwMTE0MTU3ODI=,size_16,color_FFFFFF,t_70)
- ***说明信息***
```b
> 为了图片的正常显示，建议修改 "public/ueditor-mz/php/config.json" 文件
> 当然，如果将参数 “imageUrlPrefix” 什么都不填写；
> 同一域名下自然是可以访问到静态图片的；
> 但是，如果向外提供数据，就无法获取图片资源；
> 比如我进行小程序设计时（不在一个域），接口数据中无法捕获图片资源，自然就无法正确使用
> 另外，如果涉及到不同的资源服务器，更要考虑到 FTP上传，可要好好优化咯.
```
## Ⅲ. 浏览器访问
> 对于配置完成后的访问，一般都是需要自行配置虚拟域名的哦

- 以我的操作为例，在自己的集成环境 `PhpStudy` 服务中:
```b
> 配置的虚拟域名为 tp51Pro.com ;
> 选用的服务器为 apache ;
> PHP版本：5.6+ （请选择高版本，以避免不支持的情况）
```
> 如果使用的是 `Nginx` 做服务器，需要进行 `URL 重写` 的设置，可参考文章 :【[ThinkPHP5.1 配置Nginx/Apache下的 URL重写](https://blog.csdn.net/u011415782/article/details/84032671)】

-  则入口网址为：
```b
> 前台 ： tp51pro.com/
> 后台 ：
	    tp51pro.com/cmsx (推荐)
	    tp51pro.com/cms/login/index.html
	    
	    登录数据  ——  [用户名]:moTzxx@admin  [密码]:admin 
```

- 前台登录效果，仅为参考，毕竟主要的任务时进行后台管理的实现嘛
![](https://img-blog.csdnimg.cn/20181121203401368.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3UwMTE0MTU3ODI=,size_16,color_FFFFFF,t_70)
- 后台首页进入效果：
![](https://img-blog.csdnimg.cn/20191126094630661.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3UwMTE0MTU3ODI=,size_16,color_FFFFFF,t_70)
# ➹ 三 行为比较

> 其实，对应的 `Laravel5.5` 框架初步编写的后台管理系统早已支持使用，后期优化完善后再做上传比较

- ***【提示】：***
```b
> 可以注意到: 当下流行的 ThinkPHP5.1 和 Laravel5.5 有着极为接近的设计理念;
   甚至同样的代码，仅仅稍作修改即能通用;
   例如：
>  1. 注册路由方式类同
>  2. 模型的对象化使用极为相似，但是两者间的几个关键词要注意；
   	  比如 ThinkPHP5.1使用 field、order、find、select、alias等；
   	  而 Laravel5.5 使用 select、orderBy、get、first 等
>  3. model 类 命名的方式不一样，注意 "s"，比如表格 articles ,前者 model 命名为 Articles，后者却为 Article
>  4. 对于数据表的字段命名
	  注意到一点：其中的 "created_at/updated_at" 不能生效，
	  是因为框架默认的自动时间戳配置不同
>  5. 页面跳转方式要注意下，同时前者可以 __construct() 初始化判断 Session 数据，而后者不可
>  6. 等等等 ...
```

#  ✎ 附录
## ①. GitHub 源码下载
- [ ***`moTzxx-CMS-ThinkPHP5.1.2`***](https://github.com/JingYin007/tp51Pro2.git)

## ②. 好说歹说
```b
- 首先，此项目的设计参考了很多网上资源，所以即便有任何的谬赞之处也不好居功
  尤其使用了好多自己中意的图片
  比如 —— 吾皇巴扎黑，阿里巴巴矢量图标库

- 其次，自己主要是为了方便使用
  下载使用的朋友，后期可根据自己的需求进行功能扩展

- 最后的最后，在接下来的时间里，我还会根据自己的经验进行项目优化
  在此开放提供源码也希望能得到有兴趣的伙伴给与中肯的意见
  欢迎指摘，谢谢...
```
## ③. 功能扩展日志
- `2018/12/03` 补充添加了 **登录验证码** 的功能 
> 方法请参考： [***ThinkPHP5 验证码功能实现***](https://blog.csdn.net/u011415782/article/details/77367280),请自行补充`验证码点击刷新`功能的代码！
