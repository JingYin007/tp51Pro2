layui.use(['upload','form'], function () {
    var form = layui.form;
    form.on('radio(navType)', function(data){
        var level = data.value;//被点击的radio的value值
        $(".sel-parent-msg").hide();
        $(".sel-parent-msg-"+level).show();
    });
    form.on('radio(navTypeSearch)', function(){
        $(".form-op-search").submit();
    });

    form.render();//细节！这个好像要渲染一下！
});
/**
 * ajax 获取并加载每页的数据
 * @param toUrl
 * @param postData
 * @constructor
 */
function ToAjaxOpForNavMenusPage(toUrl,postData) {
    $.post(
        toUrl,
        postData,
        function (result) {
            if(result.status == 1){
                var str_html = '';
                $.each(result.data,function (i,e) {
                    var parentID = e.parent_id;
                    str_html +=
                        "<tr class=\"tr-normal-"+e.id+"\">\n" +
                        "                <td class='title'>"+e.name+"</td>\n" +
                        "                <td class=\"icon\"><img class='layui-circle' src='"+e.icon+"'></td>\n" +
                        "                <td><span class='span-action'>"+e.action+"</span></td>\n" +
                        "                <td class='parent'>"+e.parent_name+"</td>\n" +
                        "                <td><span class='span-list_order'>"+e.list_order+"</span></td>\n" +
                        "                <td><span class='span-created_at'>"+e.created_at+"</span></td>\n" +
                        "                <td>"+e.status_tip +"</td>\n" +
                        "                <td>\n" +
                        "                    <div class=\"layui-btn-group\">\n" +
                        "                        <button class=\"layui-btn layui-btn-sm layui-btn-normal\" title='编辑菜单' \n" +
                        "                                onclick=\"editForOpenPopups('✎ 菜单信息修改','"+e.id+"', '56%', '68%')\">\n" +
                        "                            <i class=\"layui-icon\">&#xe642;</i>\n" +
                        "                        </button>\n" +
                        "                        <button class=\"layui-btn layui-btn-sm layui-btn-danger\" title='删除菜单' \n" +
                        "                                onclick=\"delPostRecord('"+e.id+"')\">\n" +
                        "                            <i class=\"layui-icon\">&#xe640;</i>\n" +
                        "                        </button>\n";

                        if(parentID>0){
                        str_html+=
                            "                        <button class=\"layui-btn layui-btn-sm layui-btn-warm\" title='权限列表' \n" +
                            "                                onclick=\"authNavMenu('"+e.id+"')\">\n" +
                            "                            <i class=\"layui-icon\">&#xe628;</i>\n" +
                            "                        </button>\n";
                        }
                        str_html+=
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