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
                        "                <td>"+e.id+"</td>\n" +
                        "                <td class='from'>《"+e.from+"》</td>\n" +
                        "                <td class=\"icon\"><img class='layui-circle' src='"+e.picture+"'></td>\n" +
                        "                <td class='word'>"+e.word+"</td>\n" +
                        "                <td>"+e.updated_at +"</td>\n" +
                        "                <td>" +e.status_tip +"</td>\n" +
                        "                <td>\n" +
                        "                    <div class=\"layui-btn-group\">\n" +
                        "                        <button class=\"layui-btn layui-btn-sm\" title='编辑' \n" +
                        "                                onclick=\"editForOpenPopups('✌ 今日赠言修改','"+e.id+"','40%')\">\n" +
                        "                            <i class=\"layui-icon\">&#xe642;</i>\n" +
                        "                        </button>\n" +
                        "                        <button class=\"layui-btn layui-btn-sm\" title='删除' \n" +
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