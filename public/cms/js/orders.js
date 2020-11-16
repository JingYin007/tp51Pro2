layui.use(['upload','form'], function () {
    var form = layui.form;
    form.on('select()', function(){
        $(".form-search").submit();
    });
    form.render();//细节！这个好像要渲染一下！
});

/**
 * ajax 获取并加载每页的数据
 * @param toUrl
 * @param postData
 * @constructor
 */
function ToAjaxOpForPageOrders(toUrl,postData) {
    $.post(
        toUrl,
        postData,
        function (result) {
            if(result.status == 1){
                var str_html = '';
                $.each(result.data,function (i,e) {
                    str_html +=
                        "<tr class=\"tr-normal-"+e.id+"\">\n" +
                        "        <td><span class=\"span-order_sn\">"+e.order_sn+"</span></td>\n" +
                        "        <td>\n" +
                        "            <img class=\"layui-circle img-user_avatar\" src=\""+e.user_avatar+"\"><br>\n" +
                        "            <span class=\"span-nick_name\">【"+e.nick_name+"】</span>\n" +
                        "        </td>\n" +
                        "        <td onclick=\"viewShoppingList('"+e.id+"')\">\n" +
                        "            <span class=\"span-goods_amount_total\">￥"+e.goods_amount_total+"</span>\n" +
                        "        </td>\n" +
                        "        <td><span class=\"span-goods_num_total\">"+e.goods_num_total+" 件</span></td>\n" +
                        "        <td><span class='layui-badge layui-bg-green' title='优惠额度'>￥"+e.reduce_amount+"</span></td>\n" +
                        "        <td><span class='layui-badge layui-bg-gray' title='运费总额'>￥"+e.logistics_fee+"</span></td>\n" +
                        "        <td>\n" +
                        "            <button type=\"button\" title='实际支付'\n" +
                        "                    class=\"layui-btn layui-btn-sm layui-btn-radius layui-btn-danger\">￥"+e.pay_amount+"</button>\n" +
                        "        </td>\n" +
                        "        <td>\n" +
                        "            <span class=\"span-pay_channel\">【"+e.pay_channel+"】</span><br>\n" +
                        "            <span class=\"span-pay_time\"><i class=\"layui-icon\">&#xe60e;</i> "+e.pay_time+"</span>\n" +
                        "        </td>\n" +
                        "        <td>\n" +
                        "            <button class=\"layui-btn layui-btn-sm layui-btn-warm\" title=\"商品清单\"\n" +
                        "                    onclick=\"viewShoppingList('"+e.id+"')\">\n" +
                        "                <i class=\"layui-icon\">&#xe66a;</i> 清单\n" +
                        "            </button>\n" +
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

/**
 * 分页获取订单详情数据
 * @param toUrl
 * @param postData
 * @constructor
 */
function ToAjaxOpForPageOrderDetails(toUrl,postData) {
    $.post(
        toUrl,
        postData,
        function (result) {
            if(result.status == 1){
                var str_html = '';
                $.each(result.data,function (i,e) {
                    str_html +=
                        "<tr class=\"tr-normal-"+e.id+"\">\n" +
                        "        <td><span class=\"span-order_sn\">"+e.order_sn+"</span></td>\n" +
                        "        <td><img class=\"img-goods_thumbnail\" src=\""+e.goods_thumbnail+"\"></td>\n" +
                        "        <td>\n" +
                        "            <span class=\"span-goods_name\">"+e.goods_name+"</span>\n" +e.tip_sku_spec_msg+
                        "        </td>\n" +
                        "        <td>\n" +
                        "            <span class=\"span-goods_price\">￥"+e.goods_price+"</span>\n" +
                        "        </td>\n" +
                        "        <td>\n" +
                        "            <button type=\"button\"\n" +
                        "                    class=\"layui-btn layui-btn-primary layui-btn-sm\">\n" +
                        "                "+e.goods_num+" 件\n" +
                        "            </button>\n" +
                        "        </td>\n" +
                        "        <td>\n" +
                        "            <span class=\"span-consignee\">"+e.consignee+"</span><br>\n" +
                        "            <span class=\"span-mobile\">"+e.mobile+"</span><br>\n" +
                        "            <span class=\"span-address\">"+e.address+"</span><br>\n" +
                        "        </td>\n" +
                        "        <td class=\"td-courier_info\">\n" + e.tip_courier_msg+
                        "            <i class=\"layui-icon\" title=\"添加物流单号\" onclick=\"addCourierNum('"+e.id+"')\">&#xe608;</i>\n" +
                        "            <i class=\"layui-icon\" title=\"查看物流信息\" onclick=\"lookLogistics('"+e.id+"')\">&#xe715;</i>\n" +
                        "        </td>\n" +
                        "        <td>\n" +
                        "            <span class=\"span-pay_channel\">【"+e.pay_channel+"】</span><br>\n" + e.tip_pay_msg+"<br>\n" +
                        "            <span class=\"span-pay_time\">\n" +
                        "                <i class=\"layui-icon\">&#xe60e;</i> "+e.pay_time+"\n" +
                        "            </span>\n" +
                        "        </td>\n" +
                        "        <td>"+e.tip_status_msg+"</td>\n" +
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