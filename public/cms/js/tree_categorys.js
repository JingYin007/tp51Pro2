/**
 * 初始化 树形组件-产品分类数据显示
 * @param toUrl
 * @param toUrl2
 * @param toSelGoodsIDTag
 */
function initViewTreeCategorys(toUrl,toUrl2,toSelGoodsIDTag) {
    $.post(
        toUrl,
        function (result) {
            if (result.status > 0) {
                var data = result.data;
                //console.log(result.data);
                layui.use(['tree'], function () {
                    var tree = layui.tree;
                    tree.render({
                        elem: '#tree-sel-category'
                        ,data: data
                        ,onlyIconControl: true  //是否仅允许节点左侧图标控制展开收缩
                        ,accordion: true
                        // ,showLine: false  //是否开启连接线
                        ,id: 'demoId' //定义索引
                        ,click: function(obj){
                            $(toSelGoodsIDTag).html("<option value=\"\">直接选择或搜索选择</option>");
                            var seledCatID = obj.data.id;
                            var form = layui.form;
                            //TODO 此时进行ajax的服务器访问，如果返回数据正常，则进行后面代码的调用
                            $.post(
                                toUrl2,
                                {seledCatID: seledCatID},
                                function (result) {
                                    if (result.status > 0) {
                                        var replaceHtml = "";
                                        $.each(result.data, function (i, e) {
                                            replaceHtml += " <option title=" + e.goods_name + " value=\"" + e.goods_id + "\">" + e.goods_name + "</option>"
                                        });
                                        $(toSelGoodsIDTag).append(replaceHtml);
                                        form.render();
                                    } else {
                                        //失败
                                        form.render();
                                        layer.msg(result.message);
                                    }
                                }, "JSON");

                            //可以重载所有基础参数
                            tree.reload('demoId', {
                                //新的参数
                            });
                        }
                    });
                });
            } else {
                layer.msg(result.message);
            }
        }, "JSON");
}
layui.use(['form'], function () {
    var form = layui.form;
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

    form.on('select(toSelThemeGoodsID)', function (data) {
        var selIndex = $(".sel-index").val();
        if(selIndex == ''){
            layer.msg("注意，请先定位序号！");
        }else {
            var indexGID = data.elem.selectedIndex;
            var goodsID = data.value;
            var goodsName = data.elem[indexGID].title;
            $(".seled-goods_id-"+selIndex).val(goodsName);

            var strHtml = "<input class=\"layui-input seled-goods_id-"+selIndex+"\"\n" +
                "                       value=\""+goodsName+"\" disabled=\"disabled\"/>\n" +
                "                <input type=\"hidden\" name=\"goods["+selIndex+"][goods_id]\" value=\""+goodsID+"\"/> ";

            $(".td-goods_id-"+selIndex).html(strHtml);
            form.render();
        }
    });
    /**
     * toSelAddThemeGoodsID 下拉列表触发事件
     */
    form.on('select(toSelAddThemeGoodsID)', function (data) {
        var indexGID = data.elem.selectedIndex;
        var goodsID = data.value;
        var goodsName = data.elem[indexGID].title;
        $(".view-goods_name").val(goodsName);
        $(".goods_id").val(goodsID);
        form.render();
    });
});

