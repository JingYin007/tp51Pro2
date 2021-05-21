<?php

namespace app\common\model;

use app\common\lib\IAuth;
use app\common\validate\Xadmin;
use think\Db;
use think\db\exception\DataNotFoundException;
use think\db\exception\ModelNotFoundException;
use think\exception\DbException;

class Xadmins extends BaseModel
{
    protected $validate;

    public function __construct($data = [])
    {
        parent::__construct($data);
        $this->validate = new Xadmin();
    }

    /**
     * 分页获取管理员数据
     * @param $curr_page
     * @param $limit
     * @param null $search
     * @return array
     */
    public function getAdminsForPage($curr_page, $limit,$search = null)
    {
        $where[] = ["a.status",'<>',-1];
        if ($search){
            $where[] = ['a.user_name|a.content', 'like', '%' . $search . '%'];
        }
        $res = $this
            ->alias('a')
            ->field('a.*,ar.user_name role_name')
            ->join('xadmin_roles ar', 'a.role_id = ar.id')
            ->order('a.id', 'desc')
            ->where($where)
            ->limit($limit * ($curr_page - 1), $limit)
            ->select();
        foreach ($res as $key => $v) {
            if ($v['status'] == 1) {
                $statusTip = '正常';
                $statusColor = 'blue';
            } else {
                $statusTip = '无效';
                $statusColor = 'cyan';
            }
            $roleTag = $v['role_id'] % 5;
            $role_name = $v['role_name'];
            switch ($roleTag) {
                case 0:
                    $roleColor = 'orange';
                    break;
                case 1:
                    $roleColor = 'green';
                    break;
                case 3:
                    $roleColor = 'cyan';
                    break;
                default:
                    $roleColor = 'blue';
                    break;
            }
            $res[$key]['role_tip'] = "<span class=\"layui-badge-dot layui-bg-$roleColor\"></span>&nbsp;$role_name";
            $res[$key]['status_tip'] = "<span class=\"layui-badge layui-bg-$statusColor\">$statusTip</span>";
            $res[$key]['picture'] = imgToServerView($res[$key]['picture']);
        }
        return isset($res)?$res->toArray():[];
    }

    /**
     * 获取后台可显示管理员用户的数目
     * @param null $search
     * @return float|string
     */
    public function getAdminsCount($search = null)
    {

        $where[] = ["a.status",'<>',-1];
        if ($search){
            $where[] = ['a.user_name|a.content', 'like', '%' . $search . '%'];
        }
        return $this
            ->alias('a')
            ->join('xadmin_roles ar', 'a.role_id = ar.id')
            ->where($where)
            ->count('a.id');
    }

    /**
     * 根据ID 获取管理员数据
     * @param int $id
     * @return array
     */
    public function getAdminData($id = 0): array
    {
        $res = $this
            ->alias('a')
            ->field('a.id,a.user_name,a.picture,a.role_id,a.created_at,
                     a.status,a.content,ar.user_name role_name')
            ->join('xadmin_roles ar', 'ar.id = a.role_id')
            ->where('a.id', $id)
            ->find();
        if ($res){
            $res['full_picture'] = imgToServerView($res['picture']);
        }
        return isset($res)?$res->toArray():[];
    }

    /**
     * 添加后台管理员
     * @param $input
     * @return int|void|array
     */
    public function addAdmin($input)
    {
        $user_name = isset($input['user_name']) ? $input['user_name'] : '';
        $sameTag = $this->chkSameUserName($user_name);
        if ($sameTag) {
            $validateRes['tag'] = 0;
            $validateRes['message'] = '此昵称已被占用，请换一个！';
        } else {
            $addData = [
                'user_name' => $user_name,
                'picture' => isset($input['picture']) ? $input['picture'] : '',
                'password' => isset($input['password']) ? $input['password'] : '',
                're_password' => isset($input['re_password']) ? $input['re_password'] : '',
                'created_at' => date("Y-m-d H:i:s", time()),
                'role_id' => isset($input['role_id'])?intval($input['role_id']):0,
                'status' => isset($input['status'])?intval($input['status']):0,
                'content' => isset($input['content'])?$input['content']:'',
            ];
            $validateRes = $this->validate($this->validate, $addData);
            if ($validateRes['tag']) {
                $addData['password'] = IAuth::setAdminUsrPassword($input['password']);
                $tag = $this->allowField(true)->save($addData);
                $validateRes['tag'] = $tag;
                $validateRes['message'] = $tag ? '管理员添加成功' : '添加失败';
            }
        }
        return $validateRes;

    }

    /**
     * 当前在线管理员 对个人信息的修改
     * @param $id
     * @param $input
     * @param $cmsAID
     * @return array
     */
    public function editCurrAdmin($id, $input, $cmsAID)
    {
        $tag = 0;
        $saveData = [
            'user_name' => isset($input['user_name'])?$input['user_name']:null,
            'picture' => isset($input['picture'])?$input['picture']:'',
            'content' => isset($input['content'])?$input['content']:'',
        ];
        $validateRes = $this->validate($this->validate, $saveData, 'cms_admin');
        if ($validateRes['tag']) {
            if ($cmsAID && ($cmsAID != $id)) {
                $message = "您没有权限进行修改";
            } else {
                if ($input['password']) {
                    //TODO 如果输入了新密码
                    if ($input['password'] !== $input['re_password']){
                        $message = "两次输入的密码不一样";
                    }else{
                        $saveData['password'] = IAuth::setAdminUsrPassword($input['password']);
                        $tag = $this
                            ->where('id', $id)
                            ->update($saveData);
                        $message = $tag ? '信息修改成功' : '数据无变动，数据更新失败';
                    }
                }else{
                    $tag = $this
                        ->where('id', $id)
                        ->update($saveData);
                    $message = $tag ? '信息修改成功' : '数据无变动，数据更新失败';
                }
            }
        }else{
            $message = $validateRes['message'];
        }
        return ['tag' => $tag,'message' => $message];
    }

    /**
     * 根据ID 修改管理员数据
     * @param $id
     * @param $input
     * @return array
     */
    public function editAdmin($id, $input): array
    {
        $opTag = $input['tag'] ?? 'edit';
        if ($opTag == 'del') {
            $tag = $this
                ->where('id', $id)
                ->update(['status' => -1]);
            $validateRes['tag'] = $tag;
            $validateRes['message'] = $tag ? '管理员删除成功' : 'Sorry,管理员删除失败！';
        } else {
            $sameTag = $this->chkSameUserName($input['user_name'], $id);
            if ($sameTag) {
                $validateRes['tag'] = 0;
                $validateRes['message'] = '此昵称已被占用，请换一个！';
            } else {
                $saveData = [
                    'user_name' => $input['user_name'] ?? '',
                    'picture' => $input['picture'] ?? '',
                    'role_id' => isset($input['role_id'])?intval($input['role_id']):0,
                    'status' => isset($input['status'])?intval($input['status']):0,
                    'content' => $input['content'],
                ];
                if ($input['password']) {
                    //TODO 如果输入了新密码
                    $saveData['password'] = $input['password'];
                    $saveData['re_password'] = $input['re_password'];
                    $validateRes = $this->validate($this->validate, $saveData);
                } else {
                    $validateRes = $this->validate($this->validate, $saveData, 'edit_admin_no_pwd');
                }

                if ($validateRes['tag']) {
                    $password_hash = IAuth::setAdminUsrPassword($input['password']);
                    $saveData['password'] = $password_hash;
                    $tag = $this->allowField(true)->save($saveData, ['id' => $id]);
                    $validateRes['tag'] = $tag;
                    $validateRes['message'] = $tag ? '管理员修改成功' : '数据无变动或修改失败';
                }
            }
        }
        $validateRes['tag'] = intval($validateRes['tag']);
        return $validateRes;
    }

    /**
     * 判断当前数据库中是否有重名的管理员
     * @param string $user_name
     * @param int $id
     * @return Xadmins
     */
    public function chkSameUserName($user_name = '', $id = 0)
    {
        return $this
            ->field('user_name')
            ->where('user_name', $user_name)
            ->where('id', '<>', $id)
            ->count();
    }

    /**
     * 获取当前管理员权限下的 导航菜单
     * @param int $admin_id
     */
    public function getAdminNavMenus($admin_id = 1)
    {
        return $this
            ->alias('a')
            ->join('xadmin_roles ar', 'ar.id = a.role_id')
            ->where([['a.id', '=', $admin_id], ['a.status', '=', 1]])
            ->value('nav_menu_ids');
    }

    /**
     * 管理员登录 反馈
     * @param $input
     * @return array
     */
    public function checkAdminLogin($input)
    {
        $flag = false;
        $message = null;
        $userName = $input['user_name'] ?? '';
        $pwd = $input['password'] ?? '';
        $verifyCode = $input['login_verifyCode'] ?? '';
        //TODO 首先判断验证码是否可用
        if (!captcha_check($verifyCode)) {
            $message = "验证码填写有误或已过期";
        } else {
            $res = $this
                ->field('password,id op_id')
                ->where('user_name', $userName)
                ->where('status', 1)
                ->find();
            if ($res) {
                if (IAuth::checkAdminUsrPassword($pwd,$res->password)) {
                    $flag = $res->op_id;
                    IAuth::setSessionAdminCurrLogged($res->op_id,$res->password);
                } else {
                    $message = "登录失败，请检查您的密码";
                }
            } else {
                $message = "该用户名失效或不存在";
            }
        }
        return [
            'tag' => $flag,
            'message' => $message ? $message : '登录成功'
        ];
    }

    /**
     * 检查 管理员是否对此 URL 有管理权限
     * @param int $adminID
     * @param string $authUrl
     * @return bool
     */
    public function checkAdminAuth($adminID = 0, $authUrl = ''): bool
    {
        $checkTag = false;
        $nav_menu_ids = $this->getAdminNavMenus($adminID);
        if (is_string($nav_menu_ids)) {
            $arrMenus = explode("|", $nav_menu_ids);
            $currNavID = $this->getNavIDByAuthUrl($authUrl).'';
            if (in_array($currNavID,$arrMenus,true)){
                $checkTag = true;
            }
        }
        return $checkTag;
    }

    /**
     * 忽略 因操作系统不同对链接字符串大小写的敏感
     * @param int $menu_id
     * @param string $authUrl
     * @return bool
     */
    public function checkAuthUrlForMenuID($menu_id = 0, $authUrl =''): bool
    {
        $checkTag = false;
        $menuAction = Db::name('xnav_menus')
            ->where([["id", '=', $menu_id], ['status', '=', 1]])
            ->value('action');
        if ("/" . strtolower($menuAction) == strtolower($authUrl)) {
            $checkTag = true;
        }
        return $checkTag;
    }

    /**
     * 获取当前链接的 菜单ID
     * mysql ，默认查询是不区分大消息的
     * @param string $authUrl
     * @return int
     */
    public function getNavIDByAuthUrl($authUrl = ''): int
    {
        $authUrl = substr($authUrl,1);

        $navID = Db::name('xnav_menus')
            ->where([["action",'=', $authUrl], ['status','=', 1]])
            ->value('id');
        return $navID ? intval($navID):0;
    }
    /**
     * 获取登录密码
     * @param int $adminID
     * @return mixed
     */
    public function getPasswordByID($adminID = 0){
        return $this->where('id',$adminID)->value('password');
    }
}
