layui.use(['form','upload'], function () {
    const form = layui.form;
    form.on('select(GoodsToSelCatID)', function (data) {
        goToToSelCatID(url_ajaxGetBrandAndSpecInfoFstByCat,data.value,form,'click');
    });
    //点击获取子级属性信息
    form.on('select(toSelSpecFst)', function (data) {
        reactHookToSelSpecFst(data,form,url_ajaxGetSpecInfoBySpecFst);
    });

    const upload = layui.upload;
    //多图片上传
    upload.render({
        elem: '#btn_multiple_upload_img'
        ,url: image_upload_url //改成您自己的上传接口
        ,multiple: true
        ,before: function(obj){
            //预读本地文件示例，不支持ie8
            obj.preview(function(index, file, result){
                $('#upload_image_list').append('<img style="height: 66px;margin-left: 7px" src="'+ result +'" title="单击删除" onclick="delMultipleImgs(this)" class="layui-upload-img">');
            });
        }
        ,done: function(res){
            //上传完毕
            if (res.status == 1) {
                let last_url = $(".upload_image_url").val();
                let upload_image_url = "";
                if(last_url){
                    upload_image_url = last_url+","+res.data.url;
                }else {
                    upload_image_url = res.data.url;
                }
                $(".upload_image_url").val(upload_image_url);
            }else {
                dialog.tip(res.message);
            }
        }
    });
    //sku 商品单一图片上传
    upload.render({
        elem: '.btn_sku_upload_img'
        , type: 'images'
        , exts: 'jpg|png|gif|jpeg' //设置一些后缀，用于演示前端验证和后端的验证
        ,accept:'images' //上传文件类型
        , url: image_upload_url
        , before: function (obj) {
            //预读本地文件示例，不支持ie8
            const sku_index = this.sku_index;
            obj.preview(function (index, file, result) {
                $('.sku-img-upload-preview-'+sku_index).attr('src', result); //图片链接（base64）
            });
        }
        , done: function (res) {
            //如果上传成功
            if (res.status == 1) {
                const sku_index = this.sku_index;
                $('.input-sku-img-'+sku_index).val(res.data.url);
            }
            dialog.tip(res.message);
        }
        , error: function () {
            //演示失败状态，并实现重传
            return layer.msg('上传失败,请重新上传');
        }
    });
});
/**
 * 多图清除按钮点击事件
 */
$("#btn_image_clear").click(function () {
    $('#upload_image_list').html("");
    $(".upload_image_url").val('');
});

/**
 * 多图上传的单击删除操作
 * @param this_img
 */
function delMultipleImgs(this_img) {
    //获取下标
    const subscript = $("#upload_image_list img").index(this_img);
    let multiple_images = $('.upload_image_url').val().split(",");
    //删除图片
    this_img.remove();
    //删除数组
    multiple_images.splice(subscript, 1);
    $('.upload_image_url').val(multiple_images);
}


/**
 * 当sku库存量变化时，对应总库存进行更新
 */
function onblur_sku_stock() {
    let input_goods_stock = 0;
    $('.input-sku-stock').each(function () {
        input_goods_stock += Number($(this).val());
    });
    $(".input-goods_stock").val(input_goods_stock);
}

/**
 * 根据所选择商品的分类 展示对应的品牌和属性列表
 * @param toUrl
 * @param catSelID 所选分类ID
 * @param form
 * @param initTag 'init'：触发事件时的操作；'click'：初始化加载
 */
function goToToSelCatID(toUrl,catSelID,form,initTag) {
    //初始化 商品选择下拉列表
    $("#toSelSpecFst").html("<option value=\"\">直接选择或搜索</option>");
    $.post(
        toUrl,
        {catSelID: catSelID},
        function (result) {
            if (result.status > 0) {
                let replaceSpecHtml = "";
                let replaceBrandHtml = "";
                if(result.data.specList.length > 0){
                    $.each(result.data.specList, function (i, e) {
                        replaceSpecHtml +=
                            " <option title='" + e.spec_name +
                            "' value=\"" + e.spec_id + "\">" + e.spec_name + e.mark_msg + "</option>"
                    });
                }
                if ((initTag == 'click') && (result.data.brandList.length > 0)){
                    $("#toSelBrand").html("<option value=\"\">直接选择或搜索</option>");
                    $.each(result.data.brandList, function (i, e) {
                        replaceBrandHtml += " <option title='" + e.brand_name
                            + "' value=\"" + e.id + "\">" + e.brand_name + "</option>"
                    });
                    $("#toSelBrand").append(replaceBrandHtml);
                }
                $("#toSelSpecFst").append(replaceSpecHtml);
            } else {
                //失败
                layer.msg(result.message);
            }
            form.render();
        }, "JSON");
}




/**
 * React Hook 钩子数据渲染
 */
function reactHookToSelSpecFst(data,form,toUrl) {
    const specFstID = data.value;
    const indexGID = data.elem.selectedIndex;
    const specFstName = data.elem[indexGID].title;

    ReactDOM.render(
        <SpecInfoDivShow toUrl={toUrl} initSpecFstID={specFstID?specFstID:0} initSpecFstName={specFstName?specFstName:''}/>,
        document.getElementById("div-specInfo-show")
    )
    //form.render('select');
}

/**
 * SKUInfo 组件设计
 */
function SpecInfoDivShow({toUrl,initSpecFstID,initSpecFstName}){

    const [specInfoArr,setSpecInfoArr] = React.useState([]);
    const [str_attr_info,setStrAttrInfo] = React.useState('[]');
    const [skuInfoArr,setSkuInfoArr] = React.useState([]);

    React.useEffect(()=>{
        // TODO async/await让异步代码看起来,表现更象同步代码;
        async function queryData(){
            let result = await axios.post(toUrl,{selSpecFstID: initSpecFstID});
            return result.data.data;
        }
        const pastSpecInfoArr = [...specInfoArr];
        //TODO 判断是否已经在内了
        if (isExitSpecID(initSpecFstID,pastSpecInfoArr)){
            dialog.tip('您已选择该属性!')
        }else {
            queryData().then(data => {opSpecInoArr(data);});
        }
    },[initSpecFstID])

    React.useEffect(()=>{
        updateStrAttrInfo();
        // 更新渲染
        layui.form.render('checkbox')
    },[specInfoArr])

    React.useEffect(()=>{
        goToMakeSaleSkuInfo();
        $(".attr_info").val(str_attr_info);
    },[str_attr_info])

    // 更新 商品属性信息字符串
    function updateStrAttrInfo(){
        //数组深复制
        let specInfoArrCopy = JSON.parse( JSON.stringify( specInfoArr ) );

        for(let i = 0; i < specInfoArrCopy.length; i++){
            let spliceFlag = true;
            for(let j = 0; j < specInfoArrCopy[i]['spec_info'].length; j++){
                const use_tag = specInfoArrCopy[i]['spec_info'][j]['use_tag'];
                if (use_tag == 0){
                    specInfoArrCopy[i]['spec_info'].splice(j, 1);
                    j = j-1;
                }else {
                    delete specInfoArrCopy[i]['spec_info'][j].use_tag;
                    spliceFlag = false;
                }
            }
            if (spliceFlag){specInfoArrCopy.splice(i,1);i=i-1}
        }

        const newStrAttrInfo = JSON.stringify(specInfoArrCopy);
        setStrAttrInfo(newStrAttrInfo);
        //console.log('str_attr_info',newStrAttrInfo)
    }
    /**
     * 判斷当前 SKU 属性是否已存在
     */
    function isExitSpecID(spec_id,opSpecInfoArr){
        for(let i = 0; i < opSpecInfoArr.length; i++){
            if(initSpecFstID === opSpecInfoArr[i]['spec_id']){
                return true;
            }
        }
        return false;
    }
    // 操作属性组数据
    function opSpecInoArr(newInfo){
        let pastSpecInfoArr = [...specInfoArr];
        //TODO 判断是否已经在内了
        if (isExitSpecID(initSpecFstID,pastSpecInfoArr)){
            return false;
        }else {
            if (initSpecFstID >0 ){
                const currSpecSel = {
                    "spec_id" : initSpecFstID,
                    "spec_name" : initSpecFstName,
                    "spec_info" : newInfo
                };
                pastSpecInfoArr.push(currSpecSel);
                setSpecInfoArr(pastSpecInfoArr);
            }else {
                return false;
            }
        }
    }
    // 点击删除 属性名称
    function delSpecInfoValue(e){
        const spec_id = e.currentTarget.getAttribute("data-spec_id");
        let pastSpecInfoArr = [...specInfoArr];
        for (let i = 0; i < pastSpecInfoArr.length; i++) {
            if (pastSpecInfoArr[i]["spec_id"] == spec_id) {
                pastSpecInfoArr.splice(i, 1);
                i=i-1;
            }
        }
        setSpecInfoArr(pastSpecInfoArr);
    }
    // 点击选中或取消 属性数据
    function handleClickSpecSingle(e){
        const currentTarget = e.currentTarget;
        let spec_checked = currentTarget.getElementsByClassName("layui-form-checked").length;
        let spec_id = currentTarget.getAttribute("data-spec_id");
        let pastSpecInfoArr = [...specInfoArr];
        //TODO 如果为选中状态
        for (let i = 0; i < pastSpecInfoArr.length; i++) {
            for (let j = 0; j < pastSpecInfoArr[i]['spec_info'].length; j++){
                if (spec_id == pastSpecInfoArr[i]['spec_info'][j]['spec_id']){
                    pastSpecInfoArr[i]['spec_info'][j]["use_tag"] = spec_checked;
                }
            }
        }
        setSpecInfoArr(pastSpecInfoArr);
    }
    // 生成 SKU 规格数组数据
    function goToMakeSaleSkuInfo(){
        const pastStrAttrInfo = JSON.parse(str_attr_info);
        let mLen = pastStrAttrInfo.length;
        let skuResArr = opSkuInfoArr(pastStrAttrInfo,mLen-1);
        setSkuInfoArr(skuResArr);
    }

    /**
     * 整理获取 sku 销售规格信息，初始化 规格表格
     * @param pastSpecInfoArr
     * @param last_len
     * @returns {[]}
     */
    function opSkuInfoArr (pastSpecInfoArr,last_len) {
        let skuResArr = [];
        if (last_len < 0){
            return skuResArr;
        }else if (last_len == 0){
            pastSpecInfoArr[last_len]['spec_info'].forEach(function (m) {
                let opArr = [];
                opArr["spec_id"] = m["spec_id"];
                opArr["spec_name"] = m["spec_name"];
                skuResArr.push(opArr);
            });
        }else {
            let everArr = opSkuInfoArr(pastSpecInfoArr,last_len-1);
            everArr.forEach(function (m) {
                pastSpecInfoArr[last_len]['spec_info'].forEach(function (n) {
                    let opArr = [];
                    opArr["spec_id"] = m["spec_id"] + "-" + n["spec_id"];
                    opArr["spec_name"] = m["spec_name"] + "," + n["spec_name"];
                    skuResArr.push(opArr);
                });
            });
        }
        return skuResArr;
    }

    return (
        <blockquote className="layui-elem-quote layui-quote-nm block-goods-sku">
            {specInfoArr.length > 0?
                <React.Fragment>
                    <button type="button"
                            className="layui-btn layui-btn-normal">规格选择：</button>
                    <table className="layui-table" lay-size="sm">
                        <colgroup />
                        <thead>
                        <tr className="tr-specInfo-key">
                            <th>属性名称</th>
                            <th>属性赋值</th>
                        </tr>
                        </thead>
                        <tbody className="tbody-specInfo-value">
                        {specInfoArr.map( (spec)=>{
                            return (
                                <tr key={spec.spec_id} className={'tr-specInfo-value-'+spec.spec_id}>
                                    <td>
                                        <label className="layui-form-label label-specInfo"
                                               data-spec_id={spec.spec_id} onClick={delSpecInfoValue}
                                               title="单击删除">{spec.spec_name}&nbsp;
                                            <span className="layui-badge layui-bg-gray span-del-specInfo">x</span>
                                        </label>
                                    </td>
                                    <td>
                                        {spec.spec_info.map((vo)=>(
                                            <React.Fragment key={vo.spec_id}>
                                                        <span data-spec_id={vo.spec_id} data-spec_name={vo.spec_name}
                                                              onClick={handleClickSpecSingle}>
                                                            <input className="cb-specSingle" type="checkbox" title={vo.spec_name}/>
                                                        </span>
                                            </React.Fragment>
                                        ))}
                                    </td>
                                </tr>
                            )
                        })}
                        </tbody>
                    </table>
                </React.Fragment>
                :''}
            { skuInfoArr.length > 0 ?
                <React.Fragment>
                    <button type="button" className="layui-btn layui-btn-danger">规格详情：</button>
                    <SkuTableShow skuInfoArr={skuInfoArr}/>
                </React.Fragment>
                :''}
        </blockquote>
    )
}

function SkuTableShow({skuInfoArr}){

    return (
        <table className="layui-table table-specInfo" lay-size="sm">
            <colgroup>
                <col width="25%"/><col width="30%"/>
                <col width="10%"/><col width="10%"/>
                <col width="10%"/><col width="10%"/>
            </colgroup>
            <thead>
            <tr className="tr-specInfo-key tr-specInfo-msg">
                <th>规格名称</th>
                <th>规格配图</th>
                <th>售价</th>
                <th>库存量</th>
                <th>已售量</th>
                <th>状态</th>
            </tr>
            </thead>
            <tbody className="tbody-specInfo-msg">
            {skuInfoArr.map((sku,index) =>{
                return <SkuItemShow key={index} img_index={index} sku_index={sku.spec_id} skuItem={sku}/>
            })}
            </tbody>
        </table>
    )
}
/**
 * 组件 SKU-Item 的定义
 */
function SkuItemShow({sku_index,skuItem,img_index}){
    const [skuSellingPrice,setSkuSellingPrice] = React.useState([]);
    const [skuStock,setSkuStock] = React.useState([]);
    const [skuSoldNum,setSkuSoldNum] = React.useState([]);

    React.useEffect(()=>{
        setSkuSellingPrice([]);
        setSkuStock([]);
        setSkuSoldNum([]);
        updateSkuUploadTag();
    },[skuItem])

    /**
     * sku 详情监听操作，便于数据的变化及绑定
     * @param e
     */
    function handleChangeSkuValue(e){
        let sku_index = e.target.getAttribute("data-index");
        let sku_type = e.target.getAttribute("data-sku_type");
        let val = e.target.value;
        let opArr = [];
        switch (sku_type){
            case 'skuSellingPrice':
                opArr = [...skuSellingPrice];
                opArr[sku_index] = (val=='')?0:val;
                setSkuSellingPrice(opArr);
                break;
            case 'skuStock':
                opArr = [...skuStock];
                opArr[sku_index] = (val=='')?0:val;
                setSkuStock(opArr);
                onblur_sku_stock();
                break;
            case 'skuSoldNum':
                opArr = [...skuSoldNum];
                opArr[sku_index] = (val=='')?0:val;
                setSkuSoldNum(opArr);
                break;
            default:
                break;
        }
    }

    /**
     * 动态更新渲染 LayUi 的 upload 组件
     * 注意： 是在上传控件加载时就要调用，不然一切白搭！
     */
    function updateSkuUploadTag(){
        //console.log('updateSkuUploadTag');
        layui.form.render('select');

        layui.use(['upload'], function() {
            let upload = layui.upload;
            $(".btn_sku_upload_img").off('click')
            $(".btn_sku_upload_img").off('change')
            $(".btn_sku_upload_img").data('haveEvents', false);

            upload.render({
                elem: '.btn_sku_upload_img'
                , type: 'images'
                , exts: 'jpg|png|gif|jpeg' //设置一些后缀，用于演示前端验证和后端的验证
                , accept:'images' //上传文件类型
                , url: image_upload_url // 上传图片的 API 路径
                , before: function (obj) {
                    let sku_index = this.sku_index;
                    obj.preview(function (index, file, result) {
                        $('.sku-img-upload-preview-'+ sku_index).attr('src', result); //图片链接（base64）
                    });
                }
                , done: function (res) {
                    //如果上传成功
                    if (res.status == 1) {$('.input-sku-img-'+this.sku_index).val(res.data.url);}
                    dialog.tip(res.message);
                }
                , error: function () {
                    //演示失败状态，并实现重传
                    return layer.msg('上传失败,请重新上传');
                }
            });
        });
    }


    return (
        <tr>
            <td>
                <span className="span-spec_name">{skuItem.spec_name}</span>
                <input type="hidden" readOnly name={"sku_arr["+sku_index+"][spec_id]"} value={skuItem.spec_id}/>
                <input type="hidden" readOnly name={'sku_arr['+sku_index+'][spec_name]'} value={skuItem.spec_name} />
            </td>
            <td>
                <div className="layui-upload layui-input-inline div-sku_upload">
                    <button type="button"
                            className={"layui-btn layui-btn-danger layui-btn-sm btn_sku_upload_img"}
                            lay-data={"{sku_index: "+(img_index)+"}"} >
                        <i className="icon-sku_upload layui-icon">&#xe67c;</i>
                    </button>
                </div>
                <div className="layui-upload-list">
                    <img className={"layui-upload-img sku-img-upload-preview-"+(img_index)+
                    " img-upload-preview-medium img-upload-view"} src=""/>
                    <input type="hidden" readOnly className={"input-sku-img-"+img_index} name={"sku_arr["+sku_index+"][sku_img]"}/>
                </div>
            </td>
            <td>
                <input type="number" name={"sku_arr["+sku_index+"][selling_price]"}
                       onChange = {handleChangeSkuValue} data-index={sku_index}
                       data-sku_type="skuSellingPrice"
                       value={skuSellingPrice[sku_index]==undefined?'0.00':skuSellingPrice[sku_index]} className="layui-input input-selling_price"/>
            </td>
            <td>
                <input type="number" name={"sku_arr["+sku_index+"][stock]"}
                       onChange = {handleChangeSkuValue} data-index={sku_index}
                       data-sku_type="skuStock"
                       value={skuStock[sku_index]==undefined?0:skuStock[sku_index]} className="layui-input input-sku-stock"/>
            </td>
            <td>
                <input type="number" name={"sku_arr["+sku_index+"][sold_num]"}
                       onChange = {handleChangeSkuValue} data-index={sku_index}
                       data-sku_type="skuSoldNum"
                       value={skuSoldNum[sku_index]==undefined?0:skuSoldNum[sku_index]} className="layui-input input-sold_num"/>
            </td>
            <td className="option-sku_status-1">
                <select defaultValue={1} name={"sku_arr["+sku_index+"][sku_status]"} >
                    <option value="1">上架</option>
                    <option value="0">下架</option>
                    <option value="-1">删除</option>
                </select>
            </td>
        </tr>
    )
}



