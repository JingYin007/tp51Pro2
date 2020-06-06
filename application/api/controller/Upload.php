<?php

namespace app\api\controller;

use app\common\lib\FtpServer;
use think\Request;

class Upload
{
    /**
     * 图片上传
     * @param Request $request
     * @return \think\response\Json
     */
    public function img_file(Request $request){
        $opRes = [];
        if ($request->Method()== 'POST') {
            //判断是哪种上传方式 七牛云
            if (config('qiniu.QN_USE') == 'OPEN'){
                $opRes = \app\common\lib\Upload::qiNiuSingleFile();
            }else{
                $opRes = \app\common\lib\Upload::singleFile($request);
            }
        }else{
            $opRes['message'] = "Sorry,请求不合法！";
        }
        return showMsg($opRes['status'], $opRes['message'],$opRes['data']);
    }
}
