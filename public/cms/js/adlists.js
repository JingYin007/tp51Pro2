

layui.use(['upload','laydate'], function () {
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
});

layui.use(['form'], function () {
    var form = layui.form;
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
function ToAjaxOpForPageAdvertisement(toUrl,postData) {
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
                        "                <td>"+e.ad_name+"</td>\n" +
                        "                <td><img src='"+e.original_img+"'></td>\n" +
                        "                <td class=\"td-ad_tag\">"+e.ad_tag +"</td>\n" +
                        "                <td>"+e.ad_url +"</td>\n" +
                        "                <td>"+e.start_time+"<hr/>"+ e.end_time +"</td>\n" +
                        "                <td>"+e.type_tip +"</td>\n" +
                        "                <td><input type=\"checkbox\" class=\"switch_checked\" lay-filter=\"switchActID\"\n" +
                        "switch_act_id=\""+e.id+"\" lay-skin=\"switch\""+e.status_checked+" lay-text=\"显示|隐藏\">"+
                        "                </td>\n" +
                        "                <td>"+e.list_order +"</td>\n" +
                        "                <td>\n" +
                        "                    <div class=\"layui-btn-group\">\n" +
                        "                        <button class=\"layui-btn layui-btn-sm\" title='编辑广告' \n" +
                        "                                onclick=\"editForOpenPopups('✎ 广告修改','"+e.id+"','55%', '65%')\">\n" +
                        "                            <i class=\"layui-icon\">&#xe642;</i>\n" +
                        "                        </button>\n" +
                        "                        <button class=\"layui-btn layui-btn-sm\" title='删除广告' \n" +
                        "                                onclick=\"delPostRecord('"+e.id+"')\">\n" +
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