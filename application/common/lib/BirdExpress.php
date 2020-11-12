<?php
/**
 * Created by PhpStorm.
 * User: moTzxx
 * Date: 2020/11/11
 * Time: 12:21
 */
namespace app\common\lib;

/**
 * 快递鸟API 整理集成类
 * TODO 主要用于快递信息的即时查询操作
 * Class BirdExpress
 * @package app\api\Controller
 */
class BirdExpress
{
    private $EBusinessID;  //电商ID
    private $AppKey;        //电商加密私钥，快递鸟提供，注意保管，不要泄漏
    private $ReqURL;        //请求url

    public function __construct()
    {
        /**
         * 进行配置信息的替换
         */
        $this->EBusinessID = config('bird_express.E_BUSINESS_ID');
        $this->AppKey = config('bird_express.APP_KEY');
        $this->ReqURL = config('bird_express.REQUEST_URL');
        //header("Content-Type: text/html; charset=gb2312");
    }

    /**
     * 此处只是测试链接
     * 正常业务逻辑需要获取 Get/Post 所传来的数据
     * 然后进行对 getOrderTracesByJson() 方法的调用即可
     * @return result
     */
    public function look()
    {
        $ShipperCode = "ZTO";
        $LogisticCode = "640041334612";

        //TODO 调用查询物流轨迹 这里我得到了一个数组
        $expressMsg = $this->getOrderTracesByJson($ShipperCode, $LogisticCode, 1);
        //var_dump($expressMsg);
        return $expressMsg;
    }

    /**
     * 核心方法
     * Json方式 查询订单物流轨迹
     * @param string $ShipperCode 快递公司编码
     * @param string $LogisticCode 物流单号
     * @param int $arrayFlag 是否进行数组转化标志 默认0：否  1：转化
     * 参考规则举例：
     * $requestData = "{'OrderCode':'','ShipperCode':'ZTO','LogisticCode':'640041334612'}";
     * @return result 包含即时物流信息的 Json数据
     */
    public function getOrderTracesByJson($ShipperCode = "", $LogisticCode = "", $arrayFlag = 0, $CustomerName = '')
    {
        /**
         * ShipperCode 为 JD，必填，对应京东的青龙配送编码，也叫商家编码，
         * 格式：数字 ＋字母＋数字，9 位数字加一个字母，共 10 位，举例：001K123450；
         * 若是ShipperCode 为 SF(顺丰)，对应填写收件人或者寄件人的手机号后四位数字
         * ShipperCode 为其他快递时，不填
         */
        $requestData = "{   
                            'OrderCode':'',
                            'ShipperCode':'$ShipperCode',
                            'CustomerName':'$CustomerName',
                            'LogisticCode':'$LogisticCode'
                        }";
        $postData = array(
            'EBusinessID' => $this->EBusinessID,
            'RequestType' => '8001',//接口指令：1002，付费后：8001
            'RequestData' => urlencode($requestData),
            'DataType' => '2',
        );
        $postData['DataSign'] = $this->encrypt($requestData, $this->AppKey);
        $result = $this->sendPost($this->ReqURL, $postData);
        //var_dump($result);
        //根据公司业务处理返回的信息......
        if ($arrayFlag) {
            $result = json_decode($result, true);
            //TODO 方便物流信息的倒序展示，进行数组反转
            $result['Traces'] = isset($result['Traces']) ? array_reverse($result['Traces']) : null;
        }
        return $result;
    }

    /**
     *  post提交数据
     * @param  string $url 请求Url
     * @param  array $datas 提交的数据
     * @return url 响应返回的 html
     */
    public function sendPost($url, $datas)
    {
        $temps = array();
        foreach ($datas as $key => $value) {
            $temps[] = sprintf('%s=%s', $key, $value);
        }
        $post_data = implode('&', $temps);
        $url_info = parse_url($url);
        if (empty($url_info['port'])) {
            $url_info['port'] = 80;
        }
        $httpheader = "POST " . $url_info['path'] . " HTTP/1.0\r\n";
        $httpheader .= "Host:" . $url_info['host'] . "\r\n";
        $httpheader .= "Content-Type:application/x-www-form-urlencoded\r\n";
        $httpheader .= "Content-Length:" . strlen($post_data) . "\r\n";
        $httpheader .= "Connection:close\r\n\r\n";
        $httpheader .= $post_data;
        $fd = fsockopen($url_info['host'], $url_info['port']);
        fwrite($fd, $httpheader);
        $gets = "";
        $headerFlag = true;
        while (!feof($fd)) {
            if (($header = @fgets($fd)) && ($header == "\r\n" || $header == "\n")) {
                break;
            }
        }
        while (!feof($fd)) {
            $gets .= fread($fd, 128);
        }
        fclose($fd);
        return $gets;
    }

    /**
     * 电商Sign签名生成
     * @param $data 内容
     * @param $appkey Appkey
     * @return DataSign签名
     */
    public function encrypt($data, $appkey)
    {
        return urlencode(base64_encode(md5($data . $appkey)));
    }
}
