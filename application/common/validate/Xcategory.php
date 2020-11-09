<?php


namespace app\common\validate;
use \think\Validate;
class Xcategory extends Validate
{
    protected $rule = [
        'cat_name'         =>  'require|max:100',
        'parent_id'     => 'require',
        'list_order'    =>  'require|number',
        '__token__'     =>  'require|token',
    ];
    protected $message  =   [
        'cat_name.max'     =>  '标题不能超过100个字符',
        'cat_name.require' =>   '标题不能为空',
        'parent_id'     =>  '请选择父级分类',
        'list_order'    =>  '排序权重为整数',
        '__token__'     =>  'Token非法操作或失效',
    ];

    protected $scene = [
        'default'  =>  ['cat_name','parent_id','list_order'],
        'token'    =>  ['__token__'],
    ];
}


