layui.use(['form','laydate'], function () {
    var form = layui.form;
    var laydate = layui.laydate;
    laydate.render({
        elem: '#startTime',
        type: 'datetime',
        trigger: 'click'
    });
    laydate.render({
        elem: '#endTime',
        type: 'datetime',
        trigger: 'click'
    });
    form.on('select(toSelCatID)', function (data) {
        $("#toSelGoodsID").html("<option value=\"\">直接选择或搜索选择</option>");
        var seledCatID = data.value;
        //TODO 此时进行ajax的服务器访问，如果返回数据正常，则进行后面代码的调用
        $.post(
            toUrl,
            {seledCatID: seledCatID},
            function (result) {
                if (result.status > 0) {
                    var replaceHtml = "";
                    $.each(result.data, function (i, e) {
                        replaceHtml += " <option title=" + e.goods_name + " value=\"" + e.goods_id + "\">" + e.goods_name + "</option>"
                    });
                    $("#toSelGoodsID").append(replaceHtml);
                    form.render();
                } else {
                    layer.msg(result.message);
                    form.render();
                }
            }, "JSON");
    });

    /**
     * toSelGoodsID 下拉列表触发事件
     */
    form.on('select(toSelGoodsID)', function (data) {
        var indexGID = data.elem.selectedIndex;
        var goodsID = data.value;
        var goodsName = data.elem[indexGID].title;
        var appendStr = "<input type=\"checkbox\" name=\"aGoods[]\" value=\"" + goodsID + "\" lay-skin=\"primary\"\n" +
            "                   title=\"" + goodsName + "\" checked=\"\">";
        $(".div-actGoods").append(appendStr);
        form.render();
    });

    form.on('switch(switchActID)', function (data) {
        //开关是否开启，true或者false
        var checked = data.elem.checked;
        var okStatus = 0;
        if (checked) {
            okStatus = 1
        }
        //获取所需属性值
        var switch_act_id = data.elem.attributes['switch_act_id'].nodeValue;
        //TODO 此时进行ajax的服务器访问，如果返回数据正常，则进行后面代码的调用
        var toUrl = $(".switch_url").val();
        $.post(
            toUrl,
            {act_id: switch_act_id, okStatus: okStatus},
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
function ToAjaxOpForPageActivitys(toUrl, postData) {
    $.post(
        toUrl,
        postData,
        function (result) {
            if (result.status == 1) {
                var str_html = '';
                $.each(result.data, function (i, e) {
                    str_html +=
                        "<tr class=\"tr-act-" + e.id + "\">\n" +
                        "                <td>" + e.id + "</td>\n" +
                        "                <td>" + e.title + "</td>\n" +
                        "                <td class=\"td-activity\"><img src=\"" + e.act_img + "\"></td>\n" +
                        "                <td class=\"td-act_tag\">" + e.act_tag + "</td>\n" +
                        "                <td>" + e.type_tip + "</td>\n" +
                        "                <td>" + e.start_time + "<hr/>" + e.end_time + "</td>\n" +
                        "                <td><input type=\"checkbox\" class=\"switch_checked\" lay-filter=\"switchActID\"\n" +
                        "switch_act_id=\"" + e.id + "\" lay-skin=\"switch\"" + e.status_checked + " lay-text=\"显示|隐藏\">" +
                        "                </td>\n" +
                        "                <td>" + e.list_order + "</td>\n" +
                        "                <td>\n" +
                        "                    <div class=\"layui-btn-group\">\n" +
                        "                        <button class=\"layui-btn layui-btn-sm\" title='编辑活动' \n" +
                        "                                onclick=\"editForOpenPopups('✎ 活动修改','" + e.id + "','80%', '90%')\">\n" +
                        "                            <i class=\"layui-icon\">&#xe642;</i>\n" +
                        "                        </button>\n" +
                        "                        <button class=\"layui-btn layui-btn-sm layui-btn-danger\" title='删除活动' \n" +
                        "                                onclick=\"delPostRecord('" + e.id + "')\">\n" +
                        "                            <i class=\"layui-icon\">&#xe640;</i>\n" +
                        "                        </button>\n" +
                        "                    </div>\n" +
                        "                </td>\n" +
                        "            </tr>";
                });
                $(".table-tbody-normal").html(str_html);
                layui.form.render();//细节！这个好像要渲染一下！
            } else {
                //失败
                layer.msg(result.message);
            }
        }, "JSON");
}