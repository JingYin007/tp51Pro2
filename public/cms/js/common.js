/**
 * 公用 table 分页模块
 */
layui.use(['laypage', 'layer'], function () {
    const lay_page = layui.laypage;
    const tbodyTag = $(".table-tbody-normal");
    const page_limit = tbodyTag.attr('page_limit');
    const record_num = tbodyTag.attr('record_num');
    const page_url = tbodyTag.attr('page_url');
    const ajax_page_fun = eval(tbodyTag.attr('ajax_page_fun'));
    lay_page.render({
        elem: 'demo2-1'
        , limit: page_limit
        , count: record_num
        , layout: ['count', 'prev', 'page', 'next', 'refresh', 'skip']
        , jump: function (obj, first) {
            //obj包含了当前分页的所有参数 首次不执行
            if (!first) {
                $(".curr_page").val(obj.curr);
                const postData = $(".form-search").serialize();
                ajax_page_fun(page_url, postData);
            }
        }
        , theme: '#FF5722'
    });
});

/**
 * 图片资源上传
 */
layui.use('upload', function () {
    const upload = layui.upload;
    //普通图片上传
    upload.render({
        elem: '.btn_upload_img'
        , type: 'images'
        , exts: 'jpg|png|gif|jpeg' //设置一些后缀，用于演示前端验证和后端的验证
        , accept:'images' //上传文件类型
        , url: image_upload_url
        , before: function (obj) {
            //预读本地文件示例，不支持ie8
            obj.preview(function (index, file, result) {
                $('.upload_img_preview').attr('src', result); //图片链接（base64）
            });
        }
        , done: function (res) {
            dialog.tip(res.message);
            //如果上传成功
            if (res.status === 1) {
                $('.upload_img_url').val(res.data.url);
            }
        }
        , error: function () {
            //演示失败状态，并实现重传
            return layer.msg('上传失败,请重新上传');
        }
    });
});

/**
 * 多图片切换查看的操作
 * 此处添加五个 够用了 ...
 */
layui.use('layer', function() {
    const layer = layui.layer;
    layer.photos({
        photos: '.photos-view-mz',//img的父级
        anim: 0 //0-6的选择，指定弹出图片动画类型，默认随机（请注意，3.0之前的版本用shift参数）
    });
    layer.photos({
        photos: '.photos-view-mz-2',//img的父级
        anim: 0 //0-6的选择，指定弹出图片动画类型，默认随机（请注意，3.0之前的版本用shift参数）
    });
    layer.photos({
        photos: '.photos-view-mz-3',//img的父级
        anim: 0 //0-6的选择，指定弹出图片动画类型，默认随机（请注意，3.0之前的版本用shift参数）
    });
    layer.photos({
        photos: '.photos-view-mz-4',//img的父级
        anim: 0 //0-6的选择，指定弹出图片动画类型，默认随机（请注意，3.0之前的版本用shift参数）
    });
    layer.photos({
        photos: '.photos-view-mz-5',//img的父级
        anim: 0 //0-6的选择，指定弹出图片动画类型，默认随机（请注意，3.0之前的版本用shift参数）
    });
});

/**
 * 通用化 添加/更新数据操作
 * @param obj
 * @param jumpUrl 跳转链接可不传
 */
function opFormPostRecord(obj,jumpUrl) {
    const toUrl = $(obj).attr('op_url');
    const postData = $(".form-op-normal").serialize();
    new ToPostPopupsDeal(obj,toUrl, postData,jumpUrl);
}

/**
 * 打开添加 操作窗口
 * @param obj
 * @param title
 * @param width
 * @param height
 */
function addForOpenPopups(obj,title,width,height) {
    const op_url = $(obj).attr('op_url');
    new ToOpenPopups(op_url, title, width, height);
}

/**
 * 打开编辑 操作窗口
 * @param title
 * @param id
 * @param width
 * @param height
 */
function editForOpenPopups(title,id,width,height) {
    let op_url = $(".op_url").val();
    op_url = op_url.replace('opid', id);
    new ToOpenPopups(op_url, title, width, height);
}

/**
 * 打开日志 查看窗口
 * @param title
 * @param id
 */
function viewLogOpenPopups(title,id) {
    let op_url = $(".log_url").val();
    op_url = op_url.replace('opid', id);
    new ToOpenPopups(op_url, title, '320px', '86%');
}
/**
 * 删除记录操作
 * @param id
 */
function delPostRecord(id) {
    let toUrl = $(".op_url").val();
    toUrl = toUrl.replace('opid', id);
    new ToDelItem(id, toUrl, '.tr-normal-' + id);
}
// 除去页面所显示的记录 传递 div
function ToRemoveDiv(tag) {
    $(tag).remove();
}

/**
 * 对导航菜单的 ajax请求处理
 * @param obj
 * @param toUrl
 * @param postData
 * @param jumpUrl 跳转链接可不传
 * @constructor
 */
function ToPostPopupsDeal(obj,toUrl,postData,jumpUrl) {
    $(obj).addClass('layui-btn-disabled');
    $(obj).attr("disabled",true);

    $.post(
        toUrl,
        postData,
        function (result) {
            if(result.status === 1){
                dialog.tip_success(result.message);
                setTimeout(function(){
                    const index = parent.layer.getFrameIndex(window.name); //先得到当前 iframe层的索引
                    parent.layer.close(index); //再执行关闭
                    if (jumpUrl){
                        location.href = jumpUrl;
                    }else {
                        parent.location.reload();
                    }
                },2000);
            }else{
                dialog.tip_error(result.message);
            }
            $(obj).removeClass('layui-btn-disabled');
            $(obj).attr("disabled",false);
        },"JSON");
}
/**
 * 删除记录
 * @param id 记录ID
 * @param toUrl 请求 URL
 * @param remove_class
 * @constructor
 */
function ToDelItem(id,toUrl,remove_class) {
    const tag_token = $(".tag_token").val();
    const postData = {'id': id, 'tag': 'del', '_token': tag_token};
    layer.msg('确定要删除此记录吗？', {
        time: 0 //不自动关闭
        ,btn: ['确定', '离开']
        ,shade:0.61,
        shadeClose:true,
        anim:4,
        moveOut: true
        ,yes: function(){
            afterDelItem(toUrl,postData,remove_class);
        }
    });
}

/**
 * 删除元素 请求
 * @param toUrl
 * @param postData
 * @param remove_class
 */
function afterDelItem(toUrl,postData,remove_class) {
    $.post(
        toUrl,
        postData,
        function (result) {
            if(result.status === 1){
                dialog.tip_success(result.message);
                ToRemoveDiv(remove_class);
            }else{
                dialog.tip_error(result.message);
            }
        },"JSON");
}

/**
 * 设计一个 通用公告层
 * @param title
 * @param content 可以是 html，样式自行使用css设计
 * @param postUrl
 * @param postData
 * @constructor
 */
function ToOpenNoticePopups(title,content,postUrl,postData,jumpUrl){
    const content_new =
        '<div style="padding: 20px 30px; line-height: 22px; ' +
        'background-color: #393D49; color: #fff; font-weight: 300;">' +
        '<p style="font-weight: bold;font-size: larger;text-align:center;">'+title+'</p>'
        + content+
        '</div>';

    layer.open({
        type: 1
        ,title: false //不显示标题栏
        ,closeBtn: false
        ,area: '300px;'
        ,shade: 0.4
        ,shadeClose: true
        ,anim:4
        ,resize: false
        ,btn: ['确定', '取消']
        ,btnAlign: 'c'
        ,moveType: 1 //拖拽模式，0或者1
        ,content: content_new
        ,yes: function(index){
            layer.close(index);
            ToPostPopupsDeal('',postUrl, postData);
        }
    });
}