<?php
/**
 * Created by PhpStorm.
 * User: moTzxx
 * Date: 2018/10/25
 * Time: 16:21
 */

namespace app\common\model;


use think\Model;

class BaseModel extends Model
{

    /**
     * 最新补充，为了添加 令牌验证功能，防止CSRF攻击
     * $tokenData 所要验证的 __Token__ 数据组
     * @param $validate 此为传入的 Validate类
     * @param array $checkData 所要验证的数据组(不包含 __TOKEN__)
     * @param string $scene 验证场景 默认default包含添加和更新，可自行扩展
     * @return array
     */
    public function validate($validate, $checkData = [], $scene = 'default')
    {
        $checkFlag = false;
        if (!$validate->scene($scene)->check($checkData)) {
            $errMsg = $validate->getError();
            $message = $errMsg ? $errMsg : '验证失败';
        } else {
            $tokenData = ['__token__' => input('__token__') ? input('__token__'): ''];

            if (!$validate->scene('token')->check($tokenData)) {
                $errMsg = $validate->getError();
                $message = $errMsg ? $errMsg : '验证失败';
            } else {
                $checkFlag = true;
                $message = '验证通过';
            }
        }
        return ['tag' => $checkFlag, 'message' => $message];
    }
}