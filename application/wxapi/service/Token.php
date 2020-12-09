<?php


namespace app\wxapi\service;

use \think\facade\Request;

class Token
{
    protected $wxAppID;
    protected $wxAppSecret;
    public function __construct()
    {
        $this->wxAppID = config('wx_mini.APP_ID');
        $this->wxAppSecret = config('wx_mini.APP_SECRET');
    }

    /**
     * 获取服务器生成的 Token 令牌
     * @param string $js_code
     * @return array 得到的 Token,形如：341c1c447cbf26f9f74c67f115a186a6
     */
    public function getServerToken($js_code = ''){
        $opStatus = 0;
        if ($js_code){
            //sprintf() 函数把格式化的字符串写入一个变量中
            $wxLoginUrl = sprintf(config('wx_mini.LOGIN_URL'), $this->wxAppID,$this->wxAppSecret,$js_code);
            $result = curl_get($wxLoginUrl);
            $wxResult = json_decode($result,true);

            if(empty($wxResult)){
                $message = "获取 session_key 及 openID 时异常";
            }else{
                $loginFail = array_key_exists('errcode',$wxResult);
                if ($loginFail){
                    $message = $wxResult['errmsg'];
                }else{
                    $opStatus = 1;
                    $message = $this->grantToken($wxResult);
                }
            }
        }else{
            $message = "登录凭证 code 缺失!";
        }

        return ['status' => $opStatus,'message' => $message];
    }

    /**
     * 验证服务端 Token 的存在与否
     * 存储的 Token对应的值，形如： {"session_key":"DY0KejcMrnSx7mBr9Uq8DA==","openid":"osFYM9KiXxgFnPV547MrWYO_i7sI","user_id":1225}
     * @param $token
     * @return array
     */
    public static function verifyServerToken($token){
        $status = 0;
        if (!$token){
            $message = 'Token不允许为空';
        }else{
            $exist = cache($token);
            $message = $exist ? "Token 有效": "Token 失效";
            $status = $exist ? 1 : 0;
        }

        return ['status' => $status,'message' => $message];
    }

    /**
     * 获取当前登录用户的 ID
     * 多数的业务操作是需要这个的，比如：用户地址、订单、浏览记录
     * 不需要的业务，比如首页 banner 图片、分类数据、商品排行榜等...
     * @return int
     */
    public static function getCurrentUserID(){
        $user_ID = self::getCurrentTokenVar('user_id');
        return intval($user_ID);
    }

    /**
     * 获取当前用户的 openid(微信小程序区分标准值。vs unionid)
     * 一般只有跟小程序特定语境才需要
     * 比如：下单时所必需
     * @return array|string
     */
    public static function getCurrentOpenID(){
        $open_ID = self::getCurrentTokenVar('openid');
        return $open_ID ? $open_ID:'';
    }

    /*---------------------- 以上为：常用的封装方法，下面的基本是处理方法--------------------------*/

    /**
     * 合法授予 Token 值
     * 生成令牌，缓存数据,把令牌返回到客户端
     * @param $wxResult
     * @return string|void
     */
    public function grantToken($wxResult){
        //拿到 openid
        $openid = $wxResult['openid'];

        //TODO 数据库里检查 openid 是否存在，如果不存在则新添一条记录
        $userID = 1225; //此处为测试用户ID
        $token = $this->saveTokenToCache($wxResult,$userID);
        return $token;
    }

    /**
     * 保存 Token 到缓存
     * @param $cachedValue
     * @param $userID 数据库中已有的或者新生成的用户ID
     * @return string|void
     */
    public function saveTokenToCache($cachedValue,$userID){
        $cachedValue['user_id'] = $userID;
        $value = json_encode($cachedValue);
        $expire_in = config('wx_mini.TOKEN_EXPIRE_IN');  //缓存过期时间

        $key = self::generateToken();
        $request = cache($key,$value,$expire_in);
        if(!$request){return showMsg(0,'服务器缓存异常');}
        return $key;
    }

    /**
     * 生成 Token 令牌
     * @return string
     */
    public static function generateToken(){
        // 32个字符组成一组随机字符串
        $randChars = getRandCharByLength(32);
        //用三组字符串，进行md5加密
        $timestamp = $_SERVER['REQUEST_TIME_FLOAT'];
        $salt = config('wx_mini.TOKEN_SALT');

        return strrev(md5($randChars.$timestamp.$salt));
    }

    /**
     * 根据 key 获取当前 Token 中的变量
     * @param string $key
     * @return mixed|string|void
     */
    public static function getCurrentTokenVar($key = ''){
        $headerToken = Request::header('token');
        $tokenVars = cache($headerToken);

        $opStatus = 0;
        if (!$tokenVars){
            $message = "token 中无数据！";
        }else{
            if (!is_array($tokenVars)){
                $tokenVars = json_decode($tokenVars,true);
            }
            if (array_key_exists($key,$tokenVars)){
                $opStatus = 1;
                $message = $tokenVars[$key];
            }else{
                $message = "Sorry,此 Token 变量不存在！";
            }
        }
        if ($opStatus){
            return $message;
        }else{
            return showMsg(0,$message);
        }
    }

}