<?php

namespace app\api\controller;

use think\Request;

class Upload
{
    /**
     * 单一图片的上传操作
     * @param Request $request
     */
    public function img_file(Request $request)
    {
        $status = 0;
        $data = [];
        if ($request->Method()== 'POST') {
            $file = $request->file('file');
            // 移动到框架应用根目录/upload/ 目录下
            $info = $file->move('upload');
            if ($info){
                //把反斜杠(\)替换成斜杠(/) 因为在windows下上传路是反斜杠径
                $getSaveName=str_replace("\\","/",$info->getSaveName());
                $fileUrl = '/upload/'.$getSaveName;
                $status = 1;
                $data['url'] = $fileUrl;
                $message = '上传成功';
            }else{
                $message = "上传失败 ".$file->getError();
            }
        } else {
            $message = "参数错误";
        }
        return showMsg($status, $message,$data);
    }
    /**
     * ftp 图片文件上传服务器操作
     * @param $local_file 本地文件源地址
     * @param $remote_file 服务器目的地址
     * @param bool $opFlag 服务器目的地址
     * @return bool
     */
    public function ftpImageToServer($local_file, $remote_file,$opFlag = false)
    {
        if (!$opFlag){
            return true;
        }else{
            $CODE_RUN = config('app.CODE_RUN');
            if ($CODE_RUN == "OFF_LINE"){
                return true;
            }else{
                $ftpConf = config('ftp.');
                $ftp = new FtpServer();
                $info = $ftp->start($ftpConf);
                if ($info) {
                    //上传文件
                    if ($ftp->put($remote_file, $local_file)) {
                        //echo "上传成功";
                        $ftp->close();
                        //删除本地图片
                        //$this->deleteServerImgCommon($localfile);
                        return true;
                    } else {
                        $ftp->close();
                        return false;
                    }
                }
            }
        }
    }
}
