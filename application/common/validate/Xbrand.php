<?php


namespace app\common\validate;
use \think\Validate;
class Xbrand extends Validate
{
    protected $rule = [
        'brand_name'         =>  'require|max:100',
        //'brand_icon'       =>  'require',
        'cat_id'        =>      'require|gt:0',
        '__token__'     =>  'require|token',
    ];
    protected $message  =   [
        'brand_name.max'     =>  '品牌名不能超过100个字符',
        'brand_name.require' =>   '品牌名不能为空',
        //'brand_icon'     =>  '品牌图标不能为空',
        'cat_id'       =>  '分类不能为空',
        '__token__'     =>  'Token非法操作或失效',
    ];

    protected $scene = [
        'default'  =>  ['brand_name','cat_id'],
        'token'    =>  ['__token__'],
    ];
}


