/**
 * 图标清除操作
 */
$(".btn-clear-icon").click(function (){
    $(".upload_img_preview").attr('src','');
    $(".upload_img_url").val('');
});

layui.use(['form'], function () {
    const form = layui.form;
    form.on('radio(levelM)', function(data){
        const level = data.value;//被点击的radio的value值
        $(".sel-parent-msg").hide();
        $(".sel-parent-msg-"+level).show();
    });
    form.on('radio(CatType)', function(){
        $(".form-op-search").submit();
    });
    form.on('select()', function(){
        $(".form-op-search").submit();
    });

    form.on('switch(switchCatID)', function (data) {
        //开关是否开启，true或者false
        const checked = data.elem.checked;
        let okStatus = 0;
        if (checked) {okStatus = 1}
        //获取所需属性值
        const switch_cat_id = data.elem.attributes['switch_cat_id'].nodeValue;
        //TODO 此时进行ajax的服务器访问，如果返回数据正常，则进行后面代码的调用
        const toUrl = $(".switch_url").val();
        $.post(
            toUrl,
            {cat_id: switch_cat_id, okStatus: okStatus},
            function (result) {
                if (result.status > 0) {
                    data.elem.checked = checked;
                    dialog.tip_success(result.message);
                } else {
                    data.elem.checked = !checked;
                    dialog.tip_error(result.message);
                }
                form.render();
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
                        "                <td class=\"icon\">"+e.tip_cat_icon+"</td>\n" +
                        "                <td><span class=\"span-parent_name\">【"+e.parent_name+"】</span></td>\n" +
                        "                <td><span class=\"span-list_order\">"+e.list_order+"</span></td>\n" +
                        "                <td><input type=\"checkbox\" class=\"switch_checked\" lay-filter=\"switchCatID\"\n" +
                        "switch_cat_id=\""+e.cat_id+"\" lay-skin=\"switch\""+e.status_checked+" lay-text=\"显示|隐藏\">"+
                        "                </td>\n" +
                        "                <td>\n" +
                        "                    <div class=\"layui-btn-group\">\n" +
                        "                        <button class=\"layui-btn layui-btn-sm layui-btn-normal\" title='编辑分类' \n" +
                        "                                onclick=\"editForOpenPopups('✎ 产品分类修改','"+e.cat_id+"','44%', '62%')\">\n" +
                        "                            <i class=\"layui-icon\">&#xe642;</i>\n" +
                        "                        </button>\n" +
                        "                        <button class=\"layui-btn layui-btn-sm layui-btn-danger\" title='删除分类' \n" +
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
function ToAjaxOpForPageBrands(toUrl,postData) {
    $.post(
        toUrl,
        postData,
        function (result) {
            if(result.status == 1){
                var str_html = '';
                $.each(result.data,function (i,e) {
                    str_html +=
                        "    <tr class=\"tr-normal-"+e.id+"\">\n" +
                        "        <td class=\"title\">"+e.brand_name+"</td>\n" +
                        "        <td class=\"icon\">"+e.tip_brand_icon+"</td>\n" +
                        "        <td><span class=\"span-cat_name\">【"+e.cat_name+"】</span></td>\n" +
                        "        <td><span class=\"span-list_order\">"+e.list_order+"</span></td>\n" +
                        "        <td>\n" +
                        "            <div class=\"layui-btn-group\">\n" +
                        "                <button class=\"layui-btn layui-btn-sm layui-btn-normal\" title=\"编辑品牌\"\n" +
                        "                        onclick=\"editForOpenPopups('✎ 品牌修改','"+e.id+"','41%', '52%')\">\n" +
                        "                    <i class=\"layui-icon\">&#xe642;</i>\n" +
                        "                </button>\n" +
                        "                <button class=\"layui-btn layui-btn-sm layui-btn-danger\" title=\"删除品牌\"\n" +
                        "                        onclick=\"delPostRecord('"+e.id+"')\">\n" +
                        "                    <i class=\"layui-icon\">&#xe640;</i>\n" +
                        "                </button>\n" +
                        "            </div>\n" +
                        "        </td>\n" +
                        "    </tr>";
                });
                $(".table-tbody-normal").html(str_html);
                layui.form.render();//细节！这个好像要渲染一下！
            }else{
                //失败
                layer.msg(result.message);
            }
        },"JSON");
}