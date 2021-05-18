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
use think\App;
use think\Controller;
use think\Request;
use think\response\View;

class Chat extends Controller
{
    protected $cmsAID;
    protected $chatModel;
    protected $web_socket_url;

    public function __construct()
    {
        parent::__construct();
        $this->cmsAID = IAuth::getAdminIDCurrLogged();
        if (!$this->cmsAID) {
            echo "Sorry，您已离线！";die;
        }else{
            $this->chatModel = new Xchats();
            $this->web_socket_url = config('workerman.WEB_SOCKET_URL');
        }
    }

    /**
     * 聊天列表
     * @param Request $request
     * @return View|void
     */
    public function lists(Request $request){
        $curr_id = $this->cmsAID;
        $chatList = $this->chatModel->getChatList($curr_id,$request->post('online_list'));
        if ($request->isGet()){
            return view('lists', [
                'from_id' => $curr_id,
                'chatList' => $chatList,
                'web_socket_url' => $this->web_socket_url]);
        }else{
            showMsg(1,'get_list',$chatList);
        }
    }

    /**
     * 聊天消息入口
     * @param Request $request
     * @param int $to_id
     * @return void|view
     */
    public function index(Request $request,$to_id = 0){
        if ($request->isGet()){
            $from_id = $this->cmsAID;
            if ($from_id){
                $toName = $this->chatModel->getAdminName($to_id);
                return view('index',[
                    'from_id' => $from_id,
                    'to_id' => $to_id,
                    'toName' => $toName,
                    'web_socket_url' => $this->web_socket_url]);
            }else{
                return  showMsg(0,'Sorry,您已下线！');
            }
        }else{
            return  showMsg(0,'Sorry,请求不合法！');
        }

    }

    /**
     * 进行聊天数据的保存
     * @param Request $request
     */
    public function save_message(Request $request){
        if ($request->isPost()){
            $message = $request->post();
            $opRes = $this->chatModel->saveMessage($message);
            showMsg($opRes['status'],$opRes['message']);
        }else{
            showMsg(0,'请求不合法！');
        }
    }

    /**
     * 聊天记录初始化
     * @param Request $request
     */
    public function load(Request $request){
        if ($request->isPost()){
            $opRes = $this->chatModel->loadMessage($request->post());
            showMsg(1,'load',$opRes);
        }else{
            showMsg(0,'请求不合法！');
        }
    }

    public function changeNoRead(Request $request){
        if ($request->isPost()){
            $this->chatModel->changeNoRead($request->post());
            showMsg(1,'changeNoRead');
        }else{
            showMsg(0,'请求不合法！');
        }
    }

    public function ajax_get_noReadCount(Request $request){
        if ($request->isPost()){
            $count = $this->chatModel->getNoReadCount($this->cmsAID);
            showMsg(1,'getNoReadCount',['noReadCount' => $count]);
        }else{
            showMsg(0,'请求不合法！');
        }
    }

    public function ajax_get_user_list(Request $request){
        if ($request->isPost()){
            $userList = $this->chatModel->getUserList($this->cmsAID);
            showMsg(1,'getUserList',$userList);
        }else{
            showMsg(0,'请求不合法！');
        }
    }
}