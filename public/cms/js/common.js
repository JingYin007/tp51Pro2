/**
 * 公用 table 分页模块
 */
layui.use(['laypage', 'layer'], function () {
    var lay_page = layui.laypage;
    var tbodyTag = $(".table-tbody-normal");
    var page_limit = tbodyTag.attr('page_limit');
    var record_num = tbodyTag.attr('record_num');
    var page_url = tbodyTag.attr('page_url');
    var ajax_page_fun = eval(tbodyTag.attr('ajax_page_fun'));
    lay_page.render({
        elem: 'demo2-1'
        , limit: page_limit
        , count: record_num
        , layout: ['count', 'prev', 'page', 'next', 'refresh', 'skip']
        , jump: function (obj, first) {
            //obj包含了当前分页的所有参数 首次不执行
            if (!first) {
                $(".curr_page").val(obj.curr);
                var postData = $(".form-search").serialize();
                ajax_page_fun(page_url, postData);
            }
        }
        , theme: '#FF5722'
    });
});


layui.use('upload', function () {
    var upload = layui.upload;
    //普通图片上传
    upload.render({
        elem: '.btn_upload_img'
        , type: 'images'
        , exts: 'jpg|png|gif' //设置一些后缀，用于演示前端验证和后端的验证
        //,auto:false //选择图片后是否直接上传
        //,accept:'images' //上传文件类型
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
            if (res.status == 1) {
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
 * 通用化 添加/更新数据操作
 * @param obj
 */
function opFormPostRecord(obj) {
    var toUrl = $(obj).attr('op_url');
    var postData = $(".form-op-normal").serialize();
    ToPostPopupsDeal(toUrl, postData);
}

/**
 * 打开添加 操作窗口
 * @param obj
 */
function addForOpenPopups(obj,title,width,height) {
    var op_url = $(obj).attr('op_url');
    ToOpenPopups(op_url, title, width, height);
}

/**
 * 打开编辑 操作窗口
 * @param title
 * @param id
 * @param width
 * @param height
 */
function editForOpenPopups(title,id,width,height) {
    var op_url = $(".op_url").val();
    op_url = op_url.replace('opid', id);
    ToOpenPopups(op_url, title, width, height);
}
// 日志查看窗口
function viewLogOpenPopups(title,id) {
    var op_url = $(".log_url").val();
    op_url = op_url.replace('opid', id);
    ToOpenPopups(op_url, title, '30%', '92%');
}
/**
 * 删除记录操作
 * @param obj
 * @param id
 */
function delPostRecord(id) {
    var toUrl = $(".op_url").val();
    toUrl = toUrl.replace('opid', id);
    ToDelItem(id, toUrl, '.tr-normal-' + id);
}
// 除去页面所显示的记录 传递 div
function ToRemoveDiv(tag) {
    $(tag).remove();
}


/**
 * 对导航菜单的 ajax请求处理
 * @param toUrl
 * @param postData
 * @constructor
 */
function ToPostPopupsDeal(toUrl,postData) {
    $.post(
        toUrl,
        postData,
        function (result) {
            dialog.tip(result.message);
            if(result.status == 1){
                setTimeout(function(){
                    var index = parent.layer.getFrameIndex(window.name); //先得到当前 iframe层的索引
                    parent.layer.close(index); //再执行关闭
                },2000);
            }else{
                //失败
                //layer.msg(result.message);
            }
        },"JSON");
}
/**
 * 删除记录
 * @param id 记录ID
 * @param toUrl 请求 URL
 * @constructor
 */
function ToDelItem(id,toUrl,remove_class) {
    var tag_token = $(".tag_token").val();
    var postData = {'id':id,'tag':'del','_token':tag_token};
    layer.msg('确定要删除此条记录吗？', {
        time: 0 //不自动关闭
        ,btn: ['确定', '离开']
        ,shade:0.61,
        shadeClose:true,
        anim:4,
        moveOut: true
        ,yes: function(index){
            afterDelItem(toUrl,postData,remove_class);
        }
    });
}
function afterDelItem(toUrl,postData,remove_class) {
    $.post(
        toUrl,
        postData,
        function (result) {
            dialog.tip(result.message);
            if(result.status == 1){
                ToRemoveDiv(remove_class);
            }else{
                //失败
                layer.msg(result.message);
            }
        },"JSON");
}