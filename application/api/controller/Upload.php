<?php

namespace app\api\controller;

use app\common\lib\FtpServer;
use think\Request;

class Upload
{
    /**
     * 单一图片的上传操作
     * @param Request $request
     */
    public function img_file(Request $request)
    {
        $res = \app\common\lib\Upload::singleFile($request);
        return showMsg($res['status'], $res['message'],$res['data']);
    }
    /**
     * 七牛云图片上传
     * @param Request $request
     * @return \think\response\Json
     */
    public function uploadQiNiu(Request $request){
        $status = 0;
        $data = [];
        if ($request->Method()== 'POST') {
            $opRes = \app\common\lib\Upload::qiNiuSingleFile();
            if ($opRes['status']){
                $status = 1;
                $data['url'] = config('qiniu.image_url').$opRes['message'];
                $message = '上传成功';
            }else{
                $message = $opRes['message'];
            }
        }else{
            $message = "Sorry,请求不合法！";
        }
        return showMsg($status, $message,$data);

    }
}
