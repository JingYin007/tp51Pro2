layui.use(['upload','form'], function () {
    var form = layui.form;
    form.on('radio(navType)', function(data){
        var level = data.value;//被点击的radio的value值
        $(".sel-parent-msg").hide();
        $(".sel-parent-msg-"+level).show();
    });
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
                        "                <td>"+e.id+"</td>\n" +
                        "                <td class='title'>"+e.name+"</td>\n" +
                        "                <td class=\"icon\"><img class='layui-circle' src='"+e.icon+"'></td>\n" +
                        "                <td>"+e.action+"</td>\n" +
                        "                <td class='parent'>"+e.parent_name+"</td>\n" +
                        "                <td>"+e.list_order+"</td>\n" +
                        "                <td>"+e.created_at+"</td>\n" +
                        "                <td>"+e.status_tip +"</td>\n" +
                        "                <td>\n" +
                        "                    <div class=\"layui-btn-group\">\n" +
                        "                        <button class=\"layui-btn layui-btn-sm\" title='编辑菜单' \n" +
                        "                                onclick=\"editForOpenPopups('✎ 菜单信息修改','"+e.id+"', '75%', '68%')\">\n" +
                        "                            <i class=\"layui-icon\">&#xe642;</i>\n" +
                        "                        </button>\n" +
                        "                        <button class=\"layui-btn layui-btn-sm\" title='删除菜单' \n" +
                        "                                onclick=\"delPostRecord('"+e.id+"')\">\n" +
                        "                            <i class=\"layui-icon\">&#xe640;</i>\n" +
                        "                        </button>\n";

                        if(parentID>0){
                        str_html+=
                            "                        <button class=\"layui-btn layui-btn-sm\" title='权限列表' \n" +
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