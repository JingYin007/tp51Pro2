<?php

namespace app\cms\behavior;

use app\common\lib\BaseException;
use app\common\lib\IAuth;
use app\common\model\XcmsOpLogs;
use think\facade\Request;
use think\facade\Response;

/**
 * 行为日志
 * Class CmsOp
 * @package app\cms\behavior
 */
class CmsLogger
{
    /**
     * @param string $params
     * @throws BaseException
     */
    public function run($params = ''){

        if (empty($params)){
            throw new BaseException(['msg' => '日志信息不能为空']);
        }

        if (is_array($params)){
            list('admin_id' => $admin_id, 'admin_name' => $admin_name, 'msg' => $message) = $params;
        }else{
            list($admin_id,$admin_name) = IAuth::getAdminIDCurrLogged();
            $message = $params;
        }

        $LogData = [
            'message'   => $message,
            'admin_id'  => $admin_id,
            'admin_name'    => $admin_name,
            'status_code'   => Response::getCode(),
            'method'    => Request::method(),
            'path'      => '/' . Request::path(),
        ];
        (new XcmsOpLogs())::create($LogData);
    }
}