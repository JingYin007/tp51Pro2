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

    /**
     * 快递100 物流信息获取 API
     * 测试代码已完成，后期可使用
     * @param string $strCom 物流代码
     * @param string $strNum    物流单号
     * @param string $strPhone  收、寄件人的电话号码（手机和固定电话均可，只能填写一个，顺丰单号必填，其他快递公司选填。如座机号码有分机号，分机号无需上传。）
     * @return array
     */
    public function getOrderTracesByKd100Json(
        $strCom = 'shunfeng', $strNum = 'SF1306899205932', $strPhone = 'phone')
    {
        //参数设置
        $key = 'CTjhulIU7xxxx';    //客户授权key
        $customer = 'B714D3D08F29CFxxxxxxxxxxxxxxxxxxxx';    //查询公司编号
        $param = array(
            'com' => $strCom,             //快递公司编码
            'num' => $strNum,     //快递单号
            'phone' => $strPhone,                //手机号
            'from' => '',                 //出发地城市
            'to' => '',                   //目的地城市
            'resultv2' => '1'             //开启行政区域解析
        );

        //请求参数
        $post_data = array();
        $post_data["customer"] = $customer;
        $post_data["param"] = json_encode($param);
        $sign = md5($post_data["param"] . $key . $post_data["customer"]);
        $post_data["sign"] = strtoupper($sign);

        $url = 'http://poll.kuaidi100.com/poll/query.do';    //实时查询请求地址
        $params = "";
        foreach ($post_data as $k => $v) {
            $params .= "$k=" . urlencode($v) . "&";  //默认UTF-8编码格式
        }
        $post_data = substr($params, 0, -1);

        //发送post请求
        $ch = curl_init();
        curl_setopt($ch, CURLOPT_POST, 1);
        curl_setopt($ch, CURLOPT_HEADER, 0);
        curl_setopt($ch, CURLOPT_URL, $url);
        curl_setopt($ch, CURLOPT_POSTFIELDS, $post_data);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
        $result = curl_exec($ch);

        $data = str_replace("\"", '"', $result);
        //TODO 物流信息都在 $data 中，根据自己的需求进行提取
        $data = json_decode($data, true);

        if (isset($data['status']) && $data['status'] == '200') {
            $xxxData = $data['data'];
            foreach ($xxxData as $key => $val) {
                $xxxData[$key]['AcceptTime'] = $val['time'];
                $xxxData[$key]['AcceptStation'] = $val['context'];
            }
            $opResult['Traces'] = $xxxData;
        } else {
            $opResult['Traces'] = null;
        }
        //var_dump($opResult);
        return $opResult;
    }
}
