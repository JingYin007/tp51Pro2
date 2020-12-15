<?php
/**
 * Created by PhpStorm.
 * User: moTzxx
 * Date: 2018/10/25
 * Time: 9:55
 */
namespace app\common\validate;
use \think\Validate;
class Xarticle extends Validate
{
    protected $rule = [
        'title'         =>  'require|max:100',
        'picture'       =>  'require',
        'abstract'      =>  'require',
        'content'       =>  'require',
        '__token__'     =>  'require|token',
    ];
    protected $message  =   [
        'title.max'     =>  '标题不能超过100个字符',
        'title.require' =>   '标题不能为空',
        'picture'       =>  '文章配图不能为空',
        'abstract'      =>  '摘要不能为空',
        'content'       =>  '文章内容不能为空',
        '__token__'     =>  'Token非法操作或失效',
    ];

    protected $scene = [
        'default'  =>  ['title','picture','abstract','content'],
        'token'    =>  ['__token__'],
    ];
}