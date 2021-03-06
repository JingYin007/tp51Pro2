<?php

namespace app\common\model;

use app\common\controller\Base;
use app\common\validate\XadminRole;
use think\Model;

class XadminRoles extends BaseModel
{
    protected $validate;

    public function __construct($data = [])
    {
        parent::__construct($data);
        $this->validate = new XadminRole();
    }

    /**
     * 获取正常角色列表
     * @return array|array[]|\array[][]|\array[][][]
     */
    public function getNormalRoles()
    {
        $res = $this
            ->where('status', 1)
            ->select();
        return isset($res) ? $res->toArray():[];
    }

    /*
     * 获取所有的角色列表
     */
    public function getAllRoleList(): array
    {
        $res = $this
            ->field('id,user_name,updated_at,list_order,status')
            ->where([['status','>',-1]])
            ->order(['list_order'=>'asc'])
            ->select();
        foreach ($res as $key => $v) {
            if ($v['status'] == 1) {
                $res[$key]['status_tip'] = "<span class=\"layui-badge layui-bg-blue\">正常</span>";
            } else {
                $res[$key]['status_tip'] = "<span class=\"layui-badge layui-bg-cyan\">失效</span>";
            }
        }
        return isset($res) ? $res->toArray(): [];
    }

    /**
     * 添加新角色
     * @param $input
     * @return array
     */
    public function addRole($input)
    {
        $user_name = $input['user_name'] ?? '';
        $checkSameTag = $this->chkSameUserName($user_name);
        if ($checkSameTag) {
            $validateRes['tag'] = 0;
            $validateRes['message'] = '此昵称已被占用，请换一个！';
        } else {
            $addData = [
                'user_name' => $user_name,
                'nav_menu_ids' => $input['nav_menu_ids'] ? $input['nav_menu_ids'] : '',
                'updated_at' => date("Y-m-d H:i:s", time()),
                'list_order' => intval($input['list_order'])?intval($input['list_order']):9,
                'status' => intval($input['status']),
            ];
            $validateRes = $this->validate($this->validate, $addData);
            if ($validateRes['tag']) {
                $tag = $this->insert($addData);
                $validateRes['tag'] = $tag;
                $validateRes['message'] = $tag ? '角色添加成功' : '角色添加失败';
            }
        }
        return $validateRes;
    }

    /**
     * 修改角色数据
     * @param $id
     * @param $input
     * @return void|static
     */
    public function editRole($id, $input)
    {
        $opTag = $input['tag'] ?? 'edit';
        if ($opTag == 'del') {
            $tag = $this->where('id', $id)->update(['status' => -1]);
            $validateRes['tag'] = $tag;
            $validateRes['message'] = $tag ? '角色删除成功' : 'Sorry,角色删除失败！';
        } else {
            $sameTag = $this->chkSameUserName($input['user_name'], $id);
            if ($sameTag) {
                $validateRes['tag'] = 0;
                $validateRes['message'] = '此昵称已被占用，请换一个！';
            } else {
                $saveData = [
                    'user_name' => $input['user_name'],
                    'status' => $input['status'],
                    'nav_menu_ids' => $input['nav_menu_ids'],
                    'list_order' => intval($input['list_order']),
                ];
                $validateRes = $this->validate($this->validate, $saveData);
                if ($validateRes['tag']) {
                    $tag = $this->where('id', $id)->update($saveData);
                    $validateRes['tag'] = 1;
                    $validateRes['message'] = $tag ? '角色修改成功' : '数据无变动，数据更新失败';
                }
            }
        }
        return $validateRes;
    }

    /**
     * 判断当前数据库中是否有重名的管理员
     * @param $user_name
     * @param int $id
     * @return mixed
     */
    public function chkSameUserName($user_name, $id = 0)
    {
        return $this
            ->field('user_name')
            ->where('user_name', $user_name)
            ->where('id', '<>', $id)
            ->count();
    }

    /**
     * 获取不同角色对应的数据
     * @param $id
     */
    public function getRoleInfo($id): array
    {
        $list =  $this
            ->field('id,user_name,status,list_order,nav_menu_ids')
            ->where('id', $id)
            ->find();
        return $list?$list->toArray():[];
    }

    /**
     * 获取当前角色的 菜单/权限信息
     * @param int $role_id
     * @return array
     */
    public function getCurrRoleMenuList($role_id = 0): array
    {
        $nav_menu_ids = $this->where('id',$role_id)->value('nav_menu_ids');
        $roleMenuList = explode('|',$nav_menu_ids);

        $currRoleMenu = (new XnavMenus())->dealForRoleShowMenus(null,$roleMenuList);
        //var_dump($currRoleMenu);
        return $currRoleMenu??[];
    }

}
