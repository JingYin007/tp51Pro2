layui.use(['upload','form'], function () {
    var form = layui.form;
    form.on('select(sel_type)', function(data){
        var sel_type = data.value;
        $(".div-config-type").hide();
        $(".div-config-typeFor-"+sel_type).show();
    });
    form.on('radio(SelType)', function(){
        $(".form-search").submit();
    });
    form.render();//细节！这个好像要渲染一下！
});
layui.use(['form', 'layer'], function () {
    var form = layui.form;
    form.on('switch(switchConfigID)', function (data) {
        //开关是否开启，true或者false
        var checked = data.elem.checked;
        var okStatus = 0;
        if (checked) {okStatus = 1}
        //获取所需属性值
        var switch_config_id = data.elem.attributes['switch_config_id'].nodeValue;
        //TODO 此时进行ajax的服务器访问，如果返回数据正常，则进行后面代码的调用
        var toUrl = $(".switch_url").val();
        $.post(
            toUrl,
            {config_id: switch_config_id, okStatus: okStatus},
            function (result) {
                if (result.status > 0) {
                    data.elem.checked = checked;
                } else {
                    data.elem.checked = !checked;
                }
                form.render();
                layer.msg(result.message);
            }, "JSON");
    });
});
/**
 * ajax 获取并加载每页的数据
 * @param toUrl
 * @param postData
 * @constructor
 */
function ToAjaxOpForPageConfigs(toUrl,postData) {
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
                        "                <td class=\"title\">"+e.title+"</td>\n" +
                        "                <td>"+e.tag+"</td>\n" +
                        "                <td class='td-value'>"+e.value_tip +"</td>\n" +
                        "                <td><span class=\"span-FF9233\">"+e.tip+"</span></td>\n" +
                        "                <td>"+e.add_time+"</td>\n" +
                        "                <td>"+e.list_order +"</td>\n" +
                        "                <td>\n" +
                        "                    <div class=\"layui-btn-group\">\n" +
                        "                        <button class=\"layui-btn layui-btn-sm\" title='编辑' \n" +
                        "                                onclick=\"editForOpenPopups('✎ 配置修改','"+e.id+"','43%','76%')\">\n" +
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
                layui.form.render();//细节！这个好像要渲染一下！
            }else{
                //失败
                layer.msg(result.message);
            }
        },"JSON");
}