
layui.use(['form', 'layer'], function () {
    var form = layui.form;
    form.on('switch(switchArticleID)', function (data) {
        //开关是否开启，true或者false
        var checked = data.elem.checked;
        var okStatus = 0;
        if (checked) {
            okStatus = 1
        }
        //获取所需属性值
        var switch_article_id = data.elem.attributes['switch_article_id'].nodeValue;
        //TODO 此时进行ajax的服务器访问，如果返回数据正常，则进行后面代码的调用
        var toUrl = $(".switch_url").val();
        $.post(
            toUrl,
            {article_id: switch_article_id, okStatus: okStatus},
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
function ToAjaxOpForPageArticles(toUrl,postData) {
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
                        "                <td class=\"title\">《"+e.title+"》</td>\n" +
                        "                <td class=\"td-article\"><img src='"+e.picture+"'></td>\n" +
                        "                <td><p class=\"p-article-abstract\">"+e.abstract+"</p></td>\n" +
                        "                <td><span class='span-updated_at'>"+e.updated_at +"</span></td>\n" +
                        "                <td>"+e.list_order +"</td>\n" +
                        "                <td><input type=\"checkbox\" class=\"switch_checked\" lay-filter=\"switchArticleID\"\n" +
                        "switch_article_id=\""+e.id+"\" lay-skin=\"switch\""+e.status_checked+" lay-text=\"推荐|NO\">"+
                        "                </td>\n" +
                        "                <td>" +e.status_tip +"</td>\n" +
                        "                <td>\n" +
                        "                    <div class=\"layui-btn-group\">\n" +
                        "                        <button class=\"layui-btn layui-btn-sm layui-btn-normal\" title='编辑文章' \n" +
                        "                                onclick=\"editForOpenPopups('✎ 文章编辑','"+e.id+"','','76%')\">\n" +
                        "                            <i class=\"layui-icon\">&#xe642;</i>\n" +
                        "                        </button>\n" +
                        "                        <button class=\"layui-btn layui-btn-sm layui-btn-danger\" title='删除文章' \n" +
                        "                                onclick=\"delPostRecord('"+e.id+"')\">\n" +
                        "                            <i class=\"layui-icon\">&#xe640;</i>\n" +
                        "                        </button>\n" +
                        "<button class=\"layui-btn layui-btn-sm layui-btn-warm\" title=\"操作记录\"\n" +
                        "                        onclick=\"viewLogOpenPopups('☁ 操作日志','"+e.id+"')\">\n" +
                        "                    <i class=\"layui-icon\">&#xe60e;</i>\n" +
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