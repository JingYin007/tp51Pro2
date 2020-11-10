<?php
/**
 * Created by PhpStorm.
 * User: moTzxx
 * Date: 2018/10/25
 * Time: 9:55
 */

namespace app\common\validate;

use \think\Validate;

class Xgood extends Validate
{
    protected $rule = [
        'goods_name' => 'require|max:60',
        'list_order' => 'require|number',
        'cat_id' => 'require|number|>=:1',
        'brand_id' => 'require|number|>=:1',
        'selling_price' => 'require|float|>:0',
        'market_price' => 'require|float|>:0',
        'thumbnail' => 'require|min:6',
        'sketch' => 'require|max:80',
        'stock' => 'require|number',
        'details' => 'require',
        '__token__' => 'require|token',
    ];
    protected $message = [
        'goods_name.max' => '商品名称不能超过60个字符',
        'goods_name.require' => '商品名称不能为空',
        'list_order' => '排序权重为整数',
        'stock' => '库存为整数',
        'selling_price' => '请填写商品售价',
        'market_price' => '请填写市场价',
        'thumbnail' => '缩略图不能为空',
        'sketch.max' => '简述不能超过80个字符',
        'sketch.require' => '简述不能为空',
        'cat_id' => '分类不能为空',
        'brand_id' => '请选择品牌',
        'details' => '商品详情不能为空',
        '__token__' => 'Token非法操作或失效',
    ];

    protected $scene = [
        'default' => ['goods_name', 'list_order',
            'details', 'stock', 'cat_id','brand_id',
            'market_price', 'selling_price', 'thumbnail','sketch'],
        'token' => ['__token__'],
    ];
}