/**
 * ajax 获取并加载每页的数据
 * @param toUrl
 * @param postData
 * @constructor
 */
function ToAjaxOpForPageSpecInfos(toUrl,postData) {
    $.post(
        toUrl,
        postData,
        function (result) {
            if(result.status == 1){
                var str_html = '';
                $.each(result.data,function (i,e) {
                    str_html +=
                        "<tr class=\"tr-normal-"+e.spec_id+"\">\n" +
                        "                <td>"+e.spec_id+"</td>\n" +
                        "                <td class='spec_name'>"+e.spec_name+"</td>\n" +
                        "                <td>"+e.cat_name +"</td>\n" +
                        "                <td class='mark_msg'>"+e.mark_msg +"</td>\n" +
                        "                <td>"+e.list_order +"</td>\n" +
                        "                <td>\n" +
                        "                    <div class=\"layui-btn-group\">\n" +
                        "                        <button class=\"layui-btn layui-btn-sm layui-btn-normal\" title=\"编辑属性\"\n" +
                        "                                onclick=\"editForOpenPopups('✎ 产品属性修改','"+e.spec_id+"', '70%', '66%')\">\n" +
                        "                            <i class=\"layui-icon\">&#xe642;</i>\n" +
                        "                        </button>\n" +
                        "                        <button class=\"layui-btn layui-btn-sm layui-btn-danger\" title=\"删除\"\n" +
                        "                                onclick=\"delPostRecord('"+e.spec_id+"')\">\n" +
                        "                            <i class=\"layui-icon\">&#xe640;</i>\n" +
                        "                        </button>\n" +
                        "<button class=\"layui-btn layui-btn-sm layui-btn-warm\" title=\"规格数据\"\n" +
                        "                        onclick=\"opSpecInfo('"+e.spec_id+"')\">\n" +
                        "                    <i class=\"layui-icon\">&#xe63c;</i>\n" +
                        "                </button>\n" +
                        "                <button class=\"layui-btn layui-btn-sm\" title=\"添加规格\"\n" +
                        "                        onclick=\"addSpecInfo('"+e.spec_id+"','✚ 规格添加')\">\n" +
                        "                    <i class=\"layui-icon\">&#xe654;</i>\n" +
                        "                </button>"+
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

/**
 * 分页显示 属性规格详情数据
 * @param toUrl
 * @param postData
 * @constructor
 */
function ToAjaxOpForPageSpecDetails(toUrl,postData) {
    $.post(
        toUrl,
        postData,
        function (result) {
            if(result.status == 1){
                var str_html = '';
                $.each(result.data,function (i,e) {
                    str_html +=
                        "<tr class=\"tr-normal-"+e.spec_id+"\">\n" +
                        "            <td>"+e.spec_id+"</td>\n" +
                        "            <td>\n" +
                        "                <input class=\"layui-input spec_name\"\n" +
                        "                       value=\""+e.spec_name+"\"/>\n" +
                        "                <input type=\"hidden\" name=\"spec_id\" class=\"id\" value=\""+e.spec_id+"\">\n" +
                        "            </td>\n" +
                        "        <td>\n" +
                        "            <input name=\"list_order\"\n" +
                        "                   placeholder=\"请填写备注...\"\n" +
                        "                   value=\""+e.mark_msg+"\" class=\"layui-input mark_msg\"/>\n" +
                        "        </td>\n" +
                        "            <td>\n" +
                        "                <input name=\"list_order\"\n" +
                        "                       value=\""+e.list_order+"\" class=\"layui-input list_order\"/>\n" +
                        "            </td>\n" +
                        "            <td>\n" +
                        "                <div class='layui-btn-group'>" +
                        "                <button class=\"layui-btn layui-btn-sm layui-btn-danger\" type=\"button\" title=\"删除\"\n" +
                        "                        onclick=\"delSpecInfo('"+e.spec_id+"')\">\n" +
                        "                    <i class=\"layui-icon\">&#xe640;</i>\n" +
                        "                </button>\n" +
                        "                <button class=\"layui-btn layui-btn-sm layui-btn-warm\" type=\"button\"  title=\"更新\"\n" +
                        "                        onclick=\"updateThemeGoods('"+e.spec_id+"')\">\n" +
                        "                    <i class=\"layui-icon\">&#xe669;</i>\n" +
                        "                </button>\n" +
                        "                </div>" +
                        "            </td>\n" +
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