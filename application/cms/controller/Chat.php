<?php
/**
 * Created by PhpStorm.
 * User: moTzxx
 * Date: 2020/10/18
 * Time: 15:49
 */

namespace app\cms\controller;


use app\common\lib\IAuth;
use app\common\model\Xchats;
use think\Request;

class Chat
{
    protected $cmsAID;
    protected $chatModel;
    protected $web_socket_url;
    public function __construct()
    {
        $this->chatModel = new Xchats();
        $this->cmsAID = IAuth::getAdminIDCurrLogged();
        if (!$this->cmsAID) {
            return redirect('cms/login/index');
        }
        $this->web_socket_url = config('workerman.WEB_SOCKET_URL');
    }

    public function lists(Request $request){
        $from_id = $this->cmsAID;
        $chatList = $this->chatModel->getChatList($from_id);
        if ($request->isGet()){
            return view('lists', [
                'from_id' => $from_id,
                'chatList' => $chatList,
                'web_socket_url' => $this->web_socket_url]);
        }else{return showMsg(1,'get_list',$chatList);}
    }

    /**
     * 聊天消息入口
     * @param int $to_id
     * @return \think\response\View
     */
    public function index($to_id = 0){
        $from_id = $this->cmsAID;
        $toName = $this->chatModel->getAdminName($to_id);

        return view('index',[
            'from_id' => $from_id,
            'to_id' => $to_id,
            'toName' => $toName,
            'web_socket_url' => $this->web_socket_url]);
    }

    /**
     * 进行聊天数据的保存
     * @param Request $request
     */
    public function save_message(Request $request){
        if ($request->isPost()){
            $message = $request->post();
            $opRes = $this->chatModel->saveMessage($message);
            return showMsg($opRes['status'],$opRes['message']);
        }else{
            return showMsg(0,'请求不合法！');
        }
    }

    /**
     * 聊天记录初始化
     * @param Request $request
     */
    public function load(Request $request){
        if ($request->isPost()){
            $opRes = $this->chatModel->loadMessage($request->post());
            return showMsg(1,'load',$opRes);
        }else{
            return showMsg(0,'请求不合法！');
        }
    }

    public function changeNoRead(Request $request){
        if ($request->isPost()){
            $this->chatModel->changeNoRead($request->post());
            return showMsg(1,'changeNoRead');
        }else{
            return showMsg(0,'请求不合法！');
        }
    }

    public function ajax_get_noReadCount(Request $request){
        if ($request->isPost()){
            $count = $this->chatModel->getNoReadCount($this->cmsAID);
            return showMsg(1,'getNoReadCount',['noReadCount' => $count]);
        }else{
            return showMsg(0,'请求不合法！');
        }
    }

    public function ajax_get_user_list(Request $request){
        if ($request->isPost()){
            $userList = $this->chatModel->getUserList($this->cmsAID);
            return showMsg(1,'getUserList',$userList);
        }else{
            return showMsg(0,'请求不合法！');
        }
    }
}