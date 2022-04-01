<?php

namespace app\common\lib;


use Qiniu\Auth;
use Qiniu\Config;
use Qiniu\Storage\BucketManager;
use Qiniu\Storage\UploadManager;

/**
 * 文件操作类
 * Class Upload
 * @package app\common\lib
 */
class Upload
{
    /**
     * 单一文件的上传操作
     * @param $request
     * @return array
     */
    public static function singleFile($request)
    {
        $data = [];
        $status = 0;
        $file = $request->file('file');
        // 移动到框架应用根目录/upload/ 目录下
        $info = $file->move('upload');
        if ($info){
            //把反斜杠(\)替换成斜杠(/) 因为在windows下上传路是反斜杠径
            $getSaveName = str_replace("\\", "/", $info->getSaveName());

            $local_file_path = 'upload/' . $getSaveName;
            $server_file_path = config('ftp.IMG_SAVE_PATH'). $getSaveName;
            $ftpTag = self::ftpImageToServer($local_file_path,$server_file_path);

            if ($ftpTag) {
                $status = 1;
                $data['url'] = $local_file_path;
                $data['full_url'] = config('ftp.IMG_SERVER_PATH').$local_file_path;

                $message = '文件上传成功';
            } else {
                $message = "FTP 上传失败，请稍后再试";
            }
        }else{
            $message = "文件上传失败 ".$file->getError();
        }
        return ['status' => $status,'message'=>$message,'data'=>$data];
    }
    /**
     * ftp 图片文件上传服务器操作
     * @param $local_file 本地文件源地址
     * @param $server_file 服务器目的地址
     * @return bool
     */
    public static function ftpImageToServer($local_file, $server_file)
    {
        //是否启用FTP
        $FTP_USE = config('ftp.FTP_USE');
        if ($FTP_USE == "CLOSE"){
            return true;
        }else{
            $ftpConf = config('ftp.');
            $ftp = new FtpServer();
            $info = $ftp->start($ftpConf);
            if ($info) {
                //上传文件
                if ($ftp->put($server_file, $local_file)) {
                    //echo "上传成功";
                    $ftp->close();
                    //删除本地图片
                    //$this->deleteServerImgCommon($local_file);
                    return true;
                } else {
                    $ftp->close();
                    return false;
                }
            }
        }
    }
    /**
     * 删除本地文件，Linux上比较适用
     * @param $filename
     * @return bool
     */
    public function deleteServerImgCommon($filename)
    {
        if (file_exists($filename)) { //检查图片文件是否存在
            $result = @unlink($filename);
            return true;
        } else {
            return false;
        }
    }

    /**
     * 七牛云 上传单一文件
     * @return array
     * @throws \Exception
     */
    public static function qiNiuSingleFile(){
        $data = [];
        // 要上传文件的临时文件
        $file = $_FILES['file']['tmp_name'];
        if (empty($file)){
            $opTag = false;
            $message = "您提交的图片数据不合法";
        }else{
            //拿到上传文件的格式
            $pathinfo = pathinfo($_FILES['file']['name']);
            //获取图片后缀名
            $ext = $pathinfo['extension'];
            $config = config('qiniu.');
            //构建一个鉴权对象
            $auth = new Auth($config['AK'],$config['SK']);
            //生成上传的token
            $token = $auth->uploadToken($config['BUCKET']);

            //上传到七牛云后 保存的文件名
            $saveFileName = date("YmdHis").substr(md5($file),0,6).rand(0000,9999).".".$ext;
            //初始化UploadManager类
            $uploadMgr = new UploadManager();
            $opRes = $uploadMgr->putFile($token,$saveFileName,$file);
            if ($opRes[1] != null){
                $opTag = false;
                $message = "Sorry,七牛云上传失败!";
            }else{
                $opTag = true;
                $message = '七牛云文件上传成功！';
                $data['url'] = $config['IMAGE_URL']. $saveFileName;
                $data['full_url'] = $config['IMAGE_URL']. $saveFileName;
            }
        }
        return ['status' => $opTag,'message' => $message,'data' => $data];
    }

    /**
     * 七牛云 删除单一文件操作
     * @param $delFileName
     * @return bool
     */
    public static function delQiNiuSingleFile($delFileName)
    {
        // 判断是否是图片
        $isImage = preg_match('/.*(\.png|\.jpg|\.jpeg|\.gif)$/', $delFileName);
        if(!$isImage){
            return false;
        }else{
            //七牛云账号配置信息
            $conf = config('qiniu.');
            // 构建鉴权对象
            $auth = new Auth($conf['AK'],$conf['SK']);
            // 配置
            $config = new Config();
            // 管理资源
            $bucketManager = new BucketManager($auth, $config);
            // 删除文件操作
            $opRes = $bucketManager->delete($conf['BUCKET'], $delFileName);
            if (is_null($opRes)) {
                // 删除操作成功
                return true;
            }else{
                return false;
            }
        }
    }

    /**
     * 服务端文件，上传到七牛云服务器
     * @param string $file_name 文件名称（无扩展名后缀）
     * @param string $file_from_path 服务端所需上传文件的绝对地址 参考： app()->getRootPath().'public'.$word_file_url;
     * @param string $file_to_path  七牛云服务器中，要存储的目录 例：'task_words/'.$task_idstr??'';
     * @param string $ext_name 文件扩展名： txt 、docx
     * @return mixed|string
     * @throws \Exception
     */
    public static function qiNiuForServerSingleFile($file_name = '',$file_from_path = '',$file_to_path = '',$ext_name = 'txt'){
        $config = config('qiniu.');
        //构建一个鉴权对象
        $auth = new Auth($config['AK'],$config['SK']);
        //生成上传的token
        $token = $auth->uploadToken($config['BUCKET']);
        // 构建 UploadManager 对象
        $uploadMgr = new UploadManager();
        // 上传文件到七牛
        if (empty($file_name)){
            $file_name = md5(uniqid(microtime(true),true));
        }

        if (empty($file_to_path)){}

        $qiNiu_saveFileName = $file_to_path.'/'.$file_name.'.'.$ext_name;


        $opRes = $uploadMgr->putFile($token, $qiNiu_saveFileName, $file_from_path);
        if ($opRes[1] !== null) {
            $opTag = false;
            $message = '上传七牛云,失败';
        } else {
            $opTag = true;
            $message = '上传七牛云,成功';
            //删除临时服务器 文件
            unlink($file_from_path);
            $data['url'] = $config['IMAGE_URL']. $qiNiu_saveFileName;
        }
        return ['status' => $opTag,'message' => $message,'data' => $data??[]];
    }
}
