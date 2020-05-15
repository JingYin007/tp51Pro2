<?php
// +----------------------------------------------------------------------
// | ThinkPHP [ WE CAN DO IT JUST THINK ]
// +----------------------------------------------------------------------
// | Copyright (c) 2006-2016 http://thinkphp.cn All rights reserved.
// +----------------------------------------------------------------------
// | Licensed ( http://www.apache.org/licenses/LICENSE-2.0 )
// +----------------------------------------------------------------------
// | Author: 流年 <liu21st@gmail.com>
// +----------------------------------------------------------------------

// 应用公共文件
/**
 * 公用的方法  返回json数据，进行信息的提示
 * @param $status 状态
 * @param string $message 提示信息
 * @param array $data 返回数据
 */
function showMsg($status,$message = '',$data = array()){
    $result = array(
        'status' => $status,
        'message' =>$message,
        'data' =>$data
    );
    exit(json_encode($result));
}
/**
 * 进行图片数据的上传，写入表 xupload_imgs
 * @param string $slide_show
 * @param int $tag_id
 * @param int $type 0：商品轮播图  1：订单评论图片
 */
function uploadSlideShow($slide_show = '',$tag_id = 0,$type = 0){
    $arrSlideShow = explode(",",$slide_show);
    foreach ($arrSlideShow as $value){
        if ($value){
            $addData = [
                'tag_id' => $tag_id,
                'type'  => $type,
                'picture' => $value,
                'add_time' => date('Y-m-d H:i:s', time()),

            ];
            Db('xupload_imgs')
                ->insert($addData);
        }
    }
}

/**
 * 处理显示图片服务器地址,可进行图片服务器地址的处理
 * @param $imgUrl
 * @return string
 */
function imgToServerView($imgUrl)
{
    $imgServerUrl = config('app.IMG_SERVER_PUBLIC') . $imgUrl;
    return $imgServerUrl;
}
/**
 * ue编辑器通过FTP上传图片（$str代表从表单接收到的content字符串）
 * 返回处理后的content字符串
 * @param $str
 * @return mixed
 */
function ftpImageToServerUE($str)
{
    $imgServerPublic = config('app.IMG_SERVER_PUBLIC');
    $pattern = "/<[img|IMG].*?src=[\'|\"](.*?(?:[\.gif|\.jpg|\.png|\.jpeg|\.mp4]))[\'|\"].*?[\/]?>/";
    preg_match_all($pattern, $str, $match);
    foreach ($match[1] as $k => $v) {
        //此时 $subDealStr 为以“upload/”开头的图片路径
        $subDealStr = substr($v, 1);
        $remotefile = '/public' . $v;
        if (startsWithStr($subDealStr, "upload")) {
            //进行FTP 图片上传操作
            $ftp = new \app\api\controller\Upload();
            $ftp->ftpImageToServer($subDealStr, $remotefile);
            //ftp_upload($remotefile, $subDealStr);
        }
    }
    return str_replace("src=\"/upload", "src=\"$imgServerPublic/upload", $str);
}
/**
 * 判断是否以某个字符串开头
 * @param $str
 * @param $char
 * @return bool
 */
function startsWithStr($str, $char)
{
    return (bool)preg_match('/^' . $char . '/', $str);
}

/**
 * 设置后台管理员密码加密方式
 * @param string $input
 * @param int $tag 0：加密操作  1：解密操作
 * @return string
 */
function cmsAdminToLoginForPassword($input = '',$tag = 0){
    $pre_halt = '_#*moTzxx#mEx77BHGFSEDF';
    $makedStr = md5(base64_encode($input).$pre_halt);
    return $makedStr;
}

/**
 * 获取当前登录管理员ID
 * @return mixed
 */
function getCmsCurrentAdminID(){
    $cmsAID = \think\facade\Cookie::get('cmsMoTzxxAID');
    return isset($cmsAID)?intval($cmsAID):0;
}

/**
 * 操作日志 添加记录
 * @param int $opStatus 操作标记位 ，非零则进行日志的记录
 * @param string $opTag 所记录业务日志确定的标签
 *               当前定义 ———— "ARTICLE": 文章操作业务；"TODAY":今日赠言业务；"GOODS":商品操作业务
 * @param int $op_id 所操作的目标记录ID
 * @param string $op_msg 记录操作信息
 * @return bool|int|string
 */
function insertCmsOpLogs($opStatus = 0,$opTag = '',
                                $op_id = 0,$op_msg = ''){
    if (!$opStatus){
        return false;
    }else{
        $opData = [
            'op_id' => $op_id,
            'tag' => $opTag,
            'admin_id' => getCmsCurrentAdminID(),
            'add_time' => date('Y-m-d H:i:s',time()),
            'op_msg' => $op_msg
        ];
        if ($opTag){
            $opStatus = \think\Db::name('xcmsLogs')
                ->insert($opData);
        }else{
            return false;
        }
        return $opStatus;
    }
}

/**
 * 获取操作日志
 * @param int $video_id
 * @param string $opTag  所记录业务日志确定的标签
 *               当前定义 ———— "ARTICLE": 文章操作业务；"TODAY":今日赠言业务；"GOODS":商品操作业务
 * @return array|PDOStatement|string|\think\Collection
 */
function getCmsOpViewLogs($video_id = 0,$opTag = ''){
    $logs = \think\Db::name('xcmsLogs l')
        ->field('l.*,a.user_name')
        ->join('xadmins a','a.id = l.admin_id')
        ->where([['tag','=',$opTag],['op_id','=',$video_id]])
        ->order('id','desc')
        ->select();
    return isset($logs)?$logs:[];
}