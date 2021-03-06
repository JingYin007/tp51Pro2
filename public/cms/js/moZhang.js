/*自定义js事件 by:moTzxx*/

$(document).ready(function () {
    /**
     * 左侧导航栏 显示与隐藏的设置
     */
    $(".layui-header .span-cms-bg-icon-menu").click(function () {
        const leftView = $(".layui-bg-black");
        const hidden = leftView.is(':hidden');
        const layui_body = $(".layui-layout-admin .layui-body");
        const layui_footer = $(".layui-layout-admin .layui-footer");
        leftView.animate({width: 'toggle'});
        if(hidden){
            //如果当前 左侧导航栏是隐藏状态
            slide_leftView(layui_body,1);
            slide_leftView(layui_footer,1);
        }else {
            //如果当前 左侧导航栏是显示状态
            slide_leftView(layui_body,0);
            slide_leftView(layui_footer,0);
        }
    });

    /**
     * 导航菜单栏 触发事件
     */
    $(".layui-side-scroll .a-to-Url").click(function () {
        const action = $(this).attr('action');
        const nav_menu_id = $(this).attr('nav_menu_id');
        //TODO 此处进行判断当前用户是否有权限进入
        const checkUrl = $("#check_login").attr('url');
        const loginUrl = $("#check_login").attr('login');
        const tag_token = $("#check_login").attr('tag_token');
        $.post(
            checkUrl,
            {'_token':tag_token,'nav_menu_id':nav_menu_id},
            function (result) {
                if(result.status === 1){
                    $(".layui-body .iframe-body").attr('src',action);
                }else{
                    //失败
                    window.location.href = loginUrl;
                }
            },"JSON");
    });
    /**
     * 锁屏点击事件
     */
    $("#LockScreen").on("click",function(){
        window.sessionStorage.setItem("lockCMS",true);
        lockPage();
    });

    // 解锁
    $("body").on("click","#unlock",function(){
        if($(this).siblings(".admin-header-lock-input").val() == ''){
            layer.msg("请输入解锁密码！");
            $(this).siblings(".admin-header-lock-input").focus();
        }else{
            if($(this).siblings(".admin-header-lock-input").val() == "123456"){
                window.sessionStorage.setItem("lockCMS",false);
                $(this).siblings(".admin-header-lock-input").val('');
                layer.closeAll("page");
            }else{
                layer.msg("密码错误，请重新输入！");
                $(this).siblings(".admin-header-lock-input").val('').focus();
            }
        }
    });
    $(document).on('keydown', function() {
        if(event.keyCode == 13) {
            $("#unlock").click();
        }
    });

    // 全屏切换
    $("#FullScreen").click(function () {
        const fullscreenElement =
            document.fullscreenElement ||
            document.mozFullScreenElement ||
            document.webkitFullscreenElement;

        if (fullscreenElement == null) {
            entryFullScreen();
            $("#FullScreen .span-tip").html('退出全屏');
            $(".span-cms-bg-icon-fullscreen").hide();
            $(".span-cms-bg-icon-fullscreen-exit").show();
        } else {
            exitFullScreen();
            $("#FullScreen .span-tip").html('全屏');
            $(".span-cms-bg-icon-fullscreen").show();
            $(".span-cms-bg-icon-fullscreen-exit").hide();
        }
    });

    $(".mul-to-Url").click(function () {
        const all_nav = $('.layui-nav-child').parent();
        all_nav.removeClass('layui-nav-itemed');
        $(this).parent().parent().parent().addClass('layui-nav-itemed');
    });
    $(".single-to-Url").click(function () {
        const all_nav = $('.layui-nav-item');
        all_nav.removeClass('layui-nav-itemed');
    });


    $(".form-opAdmins .input-pwd-re").blur(function () {
        const pwd = $(".form-opAdmins .input-pwd").val();
        const pwd_re = $(".form-opAdmins .input-pwd-re").val();
        let tip = '';
        if ( pwd!=='' && (pwd === pwd_re)){
            $(".span-dot").addClass('layui-bg-orange');
            tip = '两次密码输入一致！';
        }else {
            $(".span-dot").removeClass('layui-bg-green');
            tip = '两次密码输入不一致！'
        }
        $(".form-opAdmins .tip-pwd").html(tip);
    });


});
window.onload = function(){
    //要初始化的东西 TODO 我就奇怪为啥有的代码在$(document).function()中就不行！！！
    // 判断是否显示锁屏
    if(window.sessionStorage.getItem("lockCMS") == "true"){
        lockPage();
    }
};
/*------------------------------------------------------------------------------------------------------*/
//锁屏
function lockPage(){
    layer.open({
        title : false,
        type : 1,
        content : '	<div class="admin-header-lock" id="lock-box">'+
        '<div class="admin-header-lock-img"><img src="../cms/images/user.png"/></div>'+
        '<div class="admin-header-lock-name" id="lockUserName">I am just a passenger</div>'+
        '<div class="input_btn">'+
        '<input type="password" class="admin-header-lock-input layui-input" autocomplete="off" placeholder="请输入密码解锁.." name="lockPwd" id="lockPwd" />'+
        '<button class="layui-btn" id="unlock">解锁</button>'+
        '</div>'+
        '<p>请输入“123456”，否则不会解锁成功哦！！！</p>'+
        '</div>',
        closeBtn : 0,
        shade : 0.9
    })
    $(".admin-header-lock-input").focus();
}
/**
 * 控制左侧导航栏 显示/隐藏
 * @param viewTag 对应标签
 * @param tag 1：显示  0：隐藏
 */
function slide_leftView(viewTag,tag) {
    if (tag){
        viewTag.animate({left:parseInt(viewTag.css('left'),200) === 200 ? + viewTag.outerWidth() : 200});
    }else {
        viewTag.animate({left:parseInt(viewTag.css('left'),10) === 0 ? - viewTag.outerWidth() : 0});
    }
}


// 进入全屏：
function entryFullScreen() {
    const docE = document.documentElement;
    if (docE.requestFullScreen) {
        docE.requestFullScreen();
    } else if (docE.mozRequestFullScreen) {
        docE.mozRequestFullScreen();
    } else if (docE.webkitRequestFullScreen) {
        docE.webkitRequestFullScreen();
    }
}

// 退出全屏
function exitFullScreen() {
    const docE = document;
    if (docE.exitFullscreen) {
        docE.exitFullscreen();
    } else if (docE.mozCancelFullScreen) {
        docE.mozCancelFullScreen();
    } else if (docE.webkitCancelFullScreen) {
        docE.webkitCancelFullScreen();
    }
}
/*----------------------------------------------------------------------------------------------------*/
/**
 * 导航菜单处理函数 包括 "添加"、"修改"
 * @param op_url URL 地址
 * @param title 弹框标题
 * @param width 宽度
 * @param height 高度
 * @constructor
 */
function ToOpenPopups(op_url,title,width,height) {
    const widthTag = width ? width : '70%';
    const heightTag = height ? height : '65%';
    const openPopup = layer.open({
        type: 2,
        shade: 0.61,
        shadeClose: true,
        anim: 4,
        moveOut: true,
        title: title,
        maxmin: true, //开启最大化最小化按钮
        area: [widthTag, heightTag],
        content: op_url, //可以出现滚动条
        //content: [op_url, 'no'], //如果你不想让iframe出现滚动条
    });
    layer.style(openPopup, {
        background: '#EEEEEE',
    });
}


