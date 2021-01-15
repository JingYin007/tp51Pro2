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
 * @param int $status 状态
 * @param string $message 提示信息
 * @param array $data 返回数据
 * @return void
 */
function showMsg($status = 1,$message = '',$data = array()){
    $result = array(
        'status' => $status,
        'message' =>$message,
        'data' =>$data
    );
    return exit(json_encode($result,JSON_UNESCAPED_UNICODE));
}

/**
 * 修改 CMS管理系统的配置函数
 * @return bool 返回状态
 * @param array $pat 配置前缀
 * @param array $rep 数据变量
 * @param string $confFileName 配置文件的名称
 * @return bool
 */
function set_cms_config($pat =[], $rep =[],$confFileName = 'sys_auth')
{
    /**
     * 原理就是 打开config配置文件 然后使用正则查找替换 然后在保存文件.
     * 传递的参数为2个数组 前面的为配置 后面的为数值.  正则的匹配为单引号  如果你的是分号 请自行修改为分号
     *  $pat[0] = 参数前缀;  例:   default_return_type
        $rep[0] = 要替换的内容;    例:  json
     */
    if (is_array($pat) and is_array($rep)) {
        for ($i = 0; $i < count($pat); $i++) {
            $pats[$i] = '/\'' . $pat[$i] . '\'(.*?),/';
            $reps[$i] = "'". $pat[$i]. "'". "=>" . "'".$rep[$i] ."',";
        }
        $file_url = "../config/$confFileName.php";
        $string = file_get_contents($file_url); //加载配置文件
        $re_string = preg_replace($pats, $reps, $string); // 正则查找然后替换
        file_put_contents($file_url, $re_string); // 写入配置文件
        return true;
    } else {
        return false;
    }
}
/**
 * 处理显示图片服务器地址,可进行图片服务器地址的处理
 * @param string $imgUrl 数据库中的图片存储路径
 * @return string
 */
function imgToServerView($imgUrl = '')
{
    if (startsWithStr($imgUrl,'http')){
        $imgServerUrl = $imgUrl;
    }else{
        if ($imgUrl){
            $imgServerPath = config('ftp.IMG_SERVER_PATH');
            if ($imgServerPath === '/'){
                //当前包含协议的域名
                $main = request()->doMain();
                $imgServerPath = $main.'/';
            }
            $imgServerUrl = $imgServerPath . $imgUrl;
        }else{
            $imgServerUrl = "";
        }
    }
    return $imgServerUrl;
}

/**
 * 处理显示图片经 Base64编码后的数据
 * @param string $imgUrl 数据库中的图片存储路径
 * @return string
 */
function imgBase64ToServerView($imgUrl = ''){
    $img_file = imgToServerView($imgUrl);
    if (@file_get_contents($img_file)){
        $img_info = getimagesize($img_file);
        $return = "data:{$img_info['mime']};base64," . base64_encode(file_get_contents($img_file));
    }else{
        $return = '';
    }

    return $return;
}

/**
 * 对富文本信息中的数据
 * 匹配出所有的 <img> 标签的 src属性
 * @param string $contentStr 富文本字符串
 * @return array
 *
 */
function getPatternMatchImages($contentStr = ""){
    $imgSrcArr = [];
    //首先将富文本字符串中的 img 标签进行匹配
    $pattern_imgTag = '/<img\b.*?(?:\>|\/>)/i';
    preg_match_all($pattern_imgTag,$contentStr,$matchIMG);
    if (isset($matchIMG[0])){
        foreach ($matchIMG[0] as $key => $imgTag){
            //进一步提取 img标签中的 src属性信息
            $pattern_src = '/\bsrc\b\s*=\s*[\'\"]?([^\'\"]*)[\'\"]?/i';
            preg_match_all($pattern_src,$imgTag,$matchSrc);
            if (isset($matchSrc[1])){
                foreach ($matchSrc[1] as $src){
                    //将匹配到的src信息压入数组
                    $imgSrcArr[] = $src;
                }
            }
        }
    }
    //$pattern= '/<img\b.+\bsrc\b\s*=\s*[\'\"]([^\'\"]*)[\'\"]/iU';
    return $imgSrcArr;
}
/**
 * ue编辑器通过FTP上传图片（$str代表从表单接收到的content字符串）
 * 返回处理后的content字符串
 * @param $str
 * @return mixed
 */
function ftpImageToServerUE($str)
{
    $imgServerPath = config('ftp.IMG_SERVER_PATH');
    $pattern = "/<[img|IMG].*?src=[\'|\"](.*?(?:[\.gif|\.jpg|\.png|\.jpeg|\.mp4]))[\'|\"].*?[\/]?>/";
    preg_match_all($pattern, $str, $match);
    foreach ($match[1] as $k => $local_file) {
        //此时 $local_file 为以“upload/”开头的图片路径
        $local_file = substr($local_file, 1);
        if (startsWithStr($local_file, "upload")) {
            //进行FTP 图片上传操作
            $ftp = new \app\common\lib\Upload();
            $server_file = '/public/' . $local_file;
            $ftp->ftpImageToServer($local_file, $server_file);
        }
    }
    return str_replace("src=\"/upload/", "src=\"$imgServerPath"."upload/", $str);
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
            'admin_id' => \app\common\lib\IAuth::getAdminIDCurrLogged(),
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

/**
 * 删除本地文件，Linux 上比较适用
 * 有时不能生效，需要注意释放文件变量的内存，例：unset($info)
 * @param string $file_real_path 一般来说为 绝对路径
 * @return bool
 */
function deleteServerFile($file_real_path = "")
{
    //检查文件是否存在
    if (file_exists($file_real_path)) {
        @unlink($file_real_path);
        return true;
    } else {
        return false;
    }
}
//----------------小技能-----公共方法----------------------
/**
 * 对二维数组进行指定 KEY 键的排序操作
 * @param array $result 所操作目标数组
 * @param string $key   键
 * @param int $sort     排序方式
 * @return array|mixed
 */
function arrSortByKey($result = [],$key = '',$sort = SORT_DESC){
    if (empty($result) || !$key){
        return [];
    }else{
        array_multisort(array_column($result,$key),$sort,$result);
        return  $result;
    }
}

//----------------微信小程序-----公共方法-----------------------------------------------------------------
/**
 * @param $url
 * @param int $httpCode
 * @return bool|string
 */
function curl_get($url,&$httpCode = 0){
    $ch = curl_init();
    curl_setopt($ch,CURLOPT_URL,$url);
    curl_setopt($ch,CURLOPT_RETURNTRANSFER,1);

    //不做证书校验，部署在linux环境下请改位true
    curl_setopt($ch,CURLOPT_SSL_VERIFYPEER,false);
    curl_setopt($ch,CURLOPT_CONNECTTIMEOUT,10);
    $file_contents = curl_exec($ch);
    $httpCode = curl_getinfo($ch,CURLINFO_HTTP_CODE);
    curl_close($ch);
    return $file_contents;
}

function curl_post($url,array $params = array()){
    $data_string = json_encode($params);
    $ch = curl_init();
    curl_setopt($ch,CURLOPT_URL,$url);
    curl_setopt($ch,CURLOPT_HEADER,0);
    curl_setopt($ch,CURLOPT_RETURNTRANSFER,1);
    curl_setopt($ch,CURLOPT_CONNECTTIMEOUT,10);
    curl_setopt($ch,CURLOPT_POST,1);
    curl_setopt($ch,CURLOPT_SSL_VERIFYPEER,false);
    curl_setopt($ch,CURLOPT_POSTFIELDS,$data_string);
    curl_setopt($ch,CURLOPT_HTTPHEADER,
        array(
            'Content-Type: application/json'
        )
    );
    $data = curl_exec($ch);
    curl_close($ch);
    return ($data);
}

/**
 * 随机获取一定数量的字符
 * @param $length
 * @return string|null
 */
function getRandCharByLength($length){
    $str = null;
    $strPol = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz";
    $max = strlen($strPol)-1;

    for ($i=0;$i<$length;$i++){
        $str .= $strPol[rand(0,$max)];
    }
    return $str;
}
//---END-----------------------------------------------------------------------------------