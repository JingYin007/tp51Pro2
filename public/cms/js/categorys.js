
layui.use(['upload','form'], function () {
    var form = layui.form;
    form.on('radio(levelM)', function(data){
        var level = data.value;//被点击的radio的value值
        $(".sel-parent-msg").hide();
        $(".sel-parent-msg-"+level).show();
    });
    var upload = layui.upload;
    var tag_token = $(".tag_token").val();
    //普通图片上传
    var uploadInst = upload.render({
        elem: '.btn_upload'
        , type: 'images'
        , exts: 'jpg|png|gif' //设置一些后缀，用于演示前端验证和后端的验证
        //,auto:false //选择图片后是否直接上传
        //,accept:'images' //上传文件类型
        , url: image_upload_url
        , data: {'_token': tag_token}
        , before: function (obj) {
            var key = this.key;
            //预读本地文件示例，不支持ie8
            obj.preview(function (index, file, result) {
                if(key == 1){
                    $('.img-upload-icon').attr('src', result); //图片链接（base64）
                }else {
                    $('.img-upload-show-img').attr('src', result); //图片链接（base64）
                }
            });
        }
        , done: function (res) {
            dialog.tip(res.message);
            //如果上传成功
            if (res.status == 1) {
                var key = this.key;
                if(key == 1){
                    $('.upload-icon').val(res.data.url);
                }else {
                    $('.upload-show-img').val(res.data.url);
                }
            }
        }
        , error: function () {
            //演示失败状态，并实现重传
            return layer.msg('上传失败,请重新上传');
        }
    });

});


layui.use(['form'], function () {
    var form = layui.form;
    form.on('switch(switchCatID)', function (data) {
        //开关是否开启，true或者false
        var checked = data.elem.checked;
        var okStatus = 0;
        if (checked) {
            okStatus = 1
        }
        //获取所需属性值
        var switch_cat_id = data.elem.attributes['switch_cat_id'].nodeValue;
        //TODO 此时进行ajax的服务器访问，如果返回数据正常，则进行后面代码的调用
        var toUrl = $(".switch_url").val();
        $.post(
            toUrl,
            {cat_id: switch_cat_id, okStatus: okStatus},
            function (result) {
                if (result.status > 0) {
                    data.elem.checked = checked;
                    form.render();
                } else {
                    //失败
                    data.elem.checked = !checked;
                    form.render();
                    layer.msg(result.message);
                }
            }, "JSON");
    });
});

/**
 * ajax 获取并加载每页的数据
 * @param toUrl
 * @param postData
 * @constructor
 */
function ToAjaxOpForPageCategorys(toUrl,postData) {
    $.post(
        toUrl,
        postData,
        function (result) {
            if(result.status == 1){
                var str_html = '';
                $.each(result.data,function (i,e) {
                    str_html +=
                        "<tr class=\"tr-normal-"+e.cat_id+"\">\n" +
                        "                <td>"+e.cat_id+"</td>\n" +
                        "                <td>"+e.cat_name+"</td>\n" +
                        "                <td class=\"icon\"><img class='layui-circle' src='"+e.icon+"'></td>\n" +
                        "                <td>"+e.parent_name +"</td>\n" +
                        "                <td>"+e.list_order +"</td>\n" +
                        "                <td><input type=\"checkbox\" class=\"switch_checked\" lay-filter=\"switchCatID\"\n" +
                        "switch_cat_id=\""+e.cat_id+"\" lay-skin=\"switch\""+e.status_checked+" lay-text=\"显示|隐藏\">"+
                        "                </td>\n" +
                        "                <td>\n" +
                        "                    <div class=\"layui-btn-group\">\n" +
                        "                        <button class=\"layui-btn layui-btn-sm\" title='编辑分类' \n" +
                        "                                onclick=\"editForOpenPopups('✎ 产品分类修改','"+e.cat_id+"','51%', '82%')\">\n" +
                        "                            <i class=\"layui-icon\">&#xe642;</i>\n" +
                        "                        </button>\n" +
                        "                        <button class=\"layui-btn layui-btn-sm\" title='删除分类' \n" +
                        "                                onclick=\"delPostRecord('"+e.cat_id+"')\">\n" +
                        "                            <i class=\"layui-icon\">&#xe640;</i>\n" +
                        "                        </button>\n" +
                        "                    </div>\n" +
                        "                </td>\n" +
                        "            </tr>";
                });
                $(".table-tbody-normal").html(str_html);
                layui.form.render();//细节！这个好像要渲染一下！
            }else{
                //失败
                layer.msg(result.message);
            }
        },"JSON");
}