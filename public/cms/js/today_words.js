/**
 * 多图上传按钮 监听事件
 */
layui.use(['upload'], function () {
    var upload = layui.upload;
    upload.render({
        elem: '#btn_multiple_upload_img'
        ,url: image_upload_url //改成您自己的上传接口
        ,multiple: true
        ,before: function(obj){
            //预读本地文件示例，不支持ie8
            obj.preview(function(index, file, result){
                $('#upload_image_list').append('<img style="height: 66px;margin-left: 7px" src="'+ result +'" title="单击删除" onclick="delMultipleImgs(this)" class="layui-upload-img">');
            });
        }
        ,done: function(res){
            //上传完毕
            if (res.status == 1) {
                var last_url = $(".upload_image_url").val();
                var upload_image_url = "";
                if(last_url){
                    upload_image_url = last_url+","+res.data.url;
                }else {
                    upload_image_url = res.data.url;
                }
                $(".upload_image_url").val(upload_image_url);
            }else {
                dialog.tip(res.message);
            }
        }
    });

});
/**
 * 多图清除按钮点击事件
 */
$("#btn_image_clear").click(function () {
    $('#upload_image_list').html("");
    $(".upload_image_url").val('');
});

/**
 * 多图上传的单击删除操作
 * @param this_img
 */
function delMultipleImgs(this_img) {
    //获取下标
    var subscript = $("#upload_image_list img").index(this_img);
    multiple_images = $('.upload_image_url').val().split(",");
    //删除图片
    this_img.remove();
    //删除数组
    multiple_images.splice(subscript, 1);
    $('.upload_image_url').val(multiple_images);
};


/**
 * ajax 获取并加载每页的数据
 * @param toUrl
 * @param postData
 * @constructor
 */
function ToAjaxOpForPageTodayWords(toUrl,postData) {
    $.post(
        toUrl,
        postData,
        function (result) {
            if(result.status == 1){
                var str_html = '';
                $.each(result.data,function (i,e) {
                    str_html +=
                        "<tr class=\"tr-normal-"+e.id+"\">\n" +
                        "                <td class='from'>《"+e.from+"》</td>\n" +
                        "                <td class=\"icon\"><img class='layui-circle' src='"+e.picture+"'></td>\n" +
                        "                <td class='word'>"+e.image_list_view+"<br>"+e.word+"</td>\n" +
                        "                <td><span class='span-updated_at'>"+e.updated_at +"</span></td>\n" +
                        "                <td>" +e.status_tip +"</td>\n" +
                        "                <td>\n" +
                        "                    <div class=\"layui-btn-group\">\n" +
                        "                        <button class=\"layui-btn layui-btn-sm layui-btn-normal\" title='编辑' \n" +
                        "                                onclick=\"editForOpenPopups('✌ 今日赠言修改','"+e.id+"','40%')\">\n" +
                        "                            <i class=\"layui-icon\">&#xe642;</i>\n" +
                        "                        </button>\n" +
                        "                        <button class=\"layui-btn layui-btn-sm layui-btn-danger\" title='删除' \n" +
                        "                                onclick=\"delPostRecord('"+e.id+"')\">\n" +
                        "                            <i class=\"layui-icon\">&#xe640;</i>\n" +
                        "                        </button>\n" +
                        "                    </div>\n" +
                        "                </td>\n" +
                        "            </tr>";
                });
                $(".table-tbody-normal").html(str_html);
            }else{
                //失败
                layer.msg(result.message);
            }
        },"JSON");
}