<?php
/**
 * Created by PhpStorm.
 * User: moTzxx
 * Date: 2019/1/10
 * Time: 18:20
 */

namespace app\wxapi\controller;


use app\common\model\Xarticles;
use app\wxapi\service\Token;
use think\Request;

/**
 * 微信小程序 操作主类
 * Class WxBase
 * @package app\wxapi\controller
 */
class WxBase
{

    public function __construct()
    {
        header("Access-Control-Allow-Origin: *");
    }

    /**
     * 登录凭证校验 —— 确定身份令牌
     * @param Request $request
     * @param string $code 通过 wx.login 接口获得临时登录凭证 code
     * @return void
     */
    public function getAuthToken(Request $request,$code = ''){
        if ($request->isPost()){
            $opRes = (new Token())->getServerToken($code);
            return showMsg($opRes['status'],$opRes['message']);
        }else{
            return showMsg(0,'请求不合法！');
        }
    }

    /**
     * 验证 Token 令牌是否存在
     * @param Request $request
     * @param string $token
     */
    public function verifyToken(Request $request,$token = ''){
        if ($request->isPost()){
            $verifyRes = (new Token())->verifyServerToken($token);
            return showMsg($verifyRes['status'],$verifyRes['message']);
        }else{
            return showMsg(0,'请求不合法！');
        }
    }



    /**
     * 测试接口
     * 简单的一个，获取当前用户的地址信息的接口
     */
    public function address(){
        $accessToken = (new Token())->getAccessToken();
        $userID = Token::getCurrentUserID();
        return showMsg(1,'address',['user_id'=> $userID]);
    }

    /**
     * 测试接口
     * 根据文章ID 获取其内容数据
     * @param Request $request
     */
    public function getArticleInfo(Request $request)
    {
        $article_id = 1;
        $articleInfo = (new Xarticles())->getInfoByID(intval($article_id));
        return showMsg(1, 'getArticleInfo', $articleInfo);
    }
}