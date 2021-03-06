<?php

namespace app\common\model;

use app\common\validate\XnavMenu;
use think\Db;
use \think\Model;

/**
 * Created by PhpStorm.
 * User: moTzxx
 * Date: 2018/1/11
 * Time: 16:45
 */
class XnavMenus extends BaseModel
{
    protected $validate;

    public function __construct($data = [])
    {
        parent::__construct($data);
        $this->validate = new XnavMenu();
    }

    /**
     * 获取所有可显示的 菜单
     * @param int $parent_id 父级ID,如果是 0，则为主菜单（一级菜单）
     * @param int $type 菜单类型  0：导航菜单；1：权限菜单
     * @return array
     */
    public function getAllVisibleMenus($parent_id = 0,$type = null): array
    {
        $where = [
            ['parent_id', '=', $parent_id],['status', '=', 1]
        ];
        if (isset($type)){
            $where[] = ['type','=',$type];
        }

        $menuRes = $this
            ->field('id,parent_id,name,icon,action,type')
            ->where($where)
            ->order('list_order', 'asc')
            ->select();
        foreach ($menuRes as $key => $value){
            $menuRes[$key]['icon'] = imgToServerView($value['icon']);
            $menuRes[$key]['sel'] = 0;
        }
        return isset($menuRes)? $menuRes->toArray() : [];
    }

    /**
     * 获取所有正常状态的菜单列表
     * @return array
     */
    public function getAllNavMenus(): array
    {
        $res = $this->getAllVisibleMenus(0,0);
        foreach ($res as $key => $value) {
            $parent_id = $value['id'];
            $res[$key]['child'] = $this->getAllVisibleMenus($parent_id,0);
        }
        return $res ?? [];
    }

    /**
     * 处理展示 各角色权限分配菜单数据
     * @param array $rootMenus
     * @param array $roleMenuList
     * @return array
     */
    public function dealForRoleShowMenus($rootMenus = [], $roleMenuList = []): array
    {
        $rootMenus = $rootMenus?:$this->getAllVisibleMenus();

        foreach ($rootMenus as $key => $value) {

            $menu_type = intval($value['type']??0);
            $menu_id = intval($value['id']??0);

            $rootMenus[$key]['sel'] = (in_array($menu_id.'', $roleMenuList,true)?1:0);

                //此为非权限菜单,可能有子级菜单
                if ($menu_type == 0){
                    $childRes = $this->getAllVisibleMenus($menu_id);
                    if (!$childRes){
                        $rootMenus[$key]['child'] = [];
                        continue;
                    }else{
                        $childDealRes = $this->dealForRoleShowMenus($childRes, $roleMenuList);
                        $rootMenus[$key]['child'] = $childDealRes;
                    }
                }
        }
        return $rootMenus;
    }

    /**
     * 检查当前的菜单是否在 该管理员的权限内
     * @param int $nav_id 菜单ID
     * @param int $cmsAID 管理员用户ID
     * @return bool
     */
    public function checkNavMenuMan($nav_id = 0, $cmsAID = 0): bool
    {
        $str = $this->getAdminMenus($cmsAID);
        $navMenus = explode('|', $str);
        return in_array($nav_id.'', $navMenus,true);
    }

    /**
     * 获取当前管理员权限下的 导航菜单
     * @param int $cmsAID
     * @return array|null
     */
    public function getNavMenusShow($cmsAID = 0): ?array
    {
        if (!$cmsAID) {
            return null;
        } else {
            $str = $this->getAdminMenus($cmsAID);

            $roleMenuList = explode('|', $str);

            $res = $this->dealForAdminShowMenus(null, $roleMenuList);
            return is_array($res) ? $res: null;
        }
    }

    /**
     * 根据管理员 获取其权限下的 菜单组合
     * @param int $id
     */
    public function getAdminMenus($id = 1)
    {
        $nav_menu_ids = Db('xadmins')
            ->alias('a')
            ->join('xadmin_roles ar', 'ar.id = a.role_id')
            ->where('a.id', $id)
            ->value('nav_menu_ids');
        return $nav_menu_ids??'';
    }

    /**
     * 处理管理员 权限所要展示的菜单项
     * @param array $rootMenus
     * @param array $roleMenuList
     * @return array
     */
    public function dealForAdminShowMenus($rootMenus = [], $roleMenuList =[]): array
    {
        $rootMenus = $rootMenus?:$this->getAllVisibleMenus(0,0);

        foreach ($rootMenus as $key => $value) {
            $parent_menu_id = intval($value['parent_id']);
            $menu_id = intval($value['id']??0);

            if (!in_array($menu_id.'', $roleMenuList,true)) {
                unset($rootMenus[$key]);
            } else {
                //此为一级菜单，需继续 读取其子集菜单
                if ($parent_menu_id == 0){
                    $childRes = $this->getAllVisibleMenus($menu_id,0);
                    $childDealRes = $this->dealForAdminShowMenus($childRes, $roleMenuList);
                    $rootMenus[$key]['child'] = $childDealRes;
                }else{
                    continue;
                }
            }
        }
        return $rootMenus??[];
    }

    /**
     * 获取全部可修改状态的 导航菜单数据
     * @param int $id 导航菜单 ID 标识
     */
    public function getNavMenuByID($id = 0): array
    {
        $res = $this
            ->field('id,name,action,icon,status,parent_id,list_order,type')
            ->where('id', $id)
            ->find();
        return isset($res)?$res->toArray():[];
    }

    /**
     * 获取 符合条件的 菜单数量
     * @param null $search
     * @param string $navType
     */
    public function getNavMenusCount($search = null,$navType = "F"): int
    {
        $where = [['id', '>', '0'], ["status", '=', 1], ["type", '=', 0]];
        if ($navType == "F"){
            $where[] = ['parent_id','=',0];
        }else{
            $where[] = ['parent_id','>',0];
        }
        if ($search){
            $where[] = ['name', 'like', '%' . $search . '%'];
        }
        return intval($this->where($where)->count('id'));
    }

    /**
     * 分页获取 菜单数据
     * @param $curr_page
     * @param $limit
     * @param null $search
     * @param string $navType
     * @return array
     */
    public function getNavMenusForPage($curr_page, $limit, $search = null,$navType = "F"): array
    {
        $where = [['id', '>', '0'], ["status", '=', 1], ["type", '=', 0]];
        if ($navType == "F"){
            $where[] = ['parent_id','=',0];
        }else{
            $where[] = ['parent_id','>',0];
        }
        if ($search){
            $where[] = ['name', 'like', '%' . $search . '%'];
        }
        $res = $this
            ->field('id,parent_id,name,icon,action,status,list_order,created_at')
            ->where($where)
            ->order(['parent_id' => 'desc','list_order' => 'asc', 'created_at' => 'desc'])
            ->limit($limit * ($curr_page - 1), $limit)
            ->select();
        foreach ($res as $key => $v) {
            $parentData = $this->getNavMenuByID($v['parent_id']);
            if ($v['status'] == 1) {
                $res[$key]['status_tip'] = "<span class=\"layui-badge layui-bg-blue\">正常</span>";
            } else {
                $res[$key]['status_tip'] = "<span class=\"layui-badge layui-bg-cyan\">删除</span>";
            }
            $res[$key]['parent_name'] = $v['parent_id'] == 0 ? "根级菜单" : $parentData['name'];
            $res[$key]['icon'] = imgToServerView($v['icon']);
        }
        return isset($res)?$res->toArray():[];
    }

    /**
     * 添加菜单数据
     * @param $data
     * @param int $parent_id
     * @param int $authTag 是否为权限菜单
     * @return array
     */
    public function addNavMenu($data, $parent_id = 0,$authTag = 0): array
    {
        if (!$parent_id){
            $navType = $data['navType'] ?? "F";
            $strNavType = "parent_id_".$navType;
            $parent_id = $data[$strNavType] ?? 0;
        }
        $addData = [
            'name' => $data['name'] ?? '',
            'parent_id' => $parent_id ? $parent_id : 0,
            'action' => empty($data['action']) ?'/': $data['action'],
            'icon' => $data['icon'] ?? '/',
            'created_at' => date("Y-m-d H:i:s", time()),
            'list_order' => isset($data['list_order']) ? intval($data['list_order']) : 0,
            'status' => $data['status'] ?? 1,
            'type' => $authTag
        ];
        $validateRes = $this->validate($this->validate, $addData);
        if ($validateRes['tag']) {
            $tag = $this->insert($addData);
            $validateRes['tag'] = $tag;
            $validateRes['message'] = $tag ? '菜单添加成功' : '添加失败';
        }
        return $validateRes;
    }

    /**
     * 更新菜单数据
     * @param $id
     * @param $data
     * @return array
     */
    public function editNavMenu($id, $data): array
    {
       $opTag = $data['tag'] ?? 'edit';
        $tag = 0;
        if ($opTag == 'del') {
            $tag = $this
                ->where('id', $id)
                ->update(['status' => -1]);
            $validateRes['message'] = $tag ? '数据删除成功' : '已删除';
        } else {
            $navType = $data['navType'] ?? "F";
            $strNavType = "parent_id_".$navType;
            $parent_id = $data[$strNavType] ?? 0;

            $saveData = [
                'name' => $data['name'] ?? '',
                'icon' => $data['icon'] ?? '',
                'list_order' => intval($data['list_order']),
                'parent_id' => intval($parent_id),
                'action' => empty($data['action']) ?'/': $data['action'],
                'status' => intval($data['status']),
            ];
            $validateRes = $this->validate($this->validate, $saveData);
            if ($validateRes['tag']) {
                $tag = $this
                    ->where('id', $id)
                    ->update($saveData);
                $validateRes['message'] = $tag ? '菜单修改成功' : '数据无变动';
            }

        }
        $validateRes['tag'] = $tag;
        return $validateRes;
    }

    /**
     * 更新 权限菜单数据
     * @param $id
     * @param $data
     * @return array
     */
    public function editNavMenuForAuth($id, $data): array
    {
        $opTag = $data['op_tag'] ?? 1;
        $opVal = $data['op_val']??'';
        if ($opTag == 1) {
            $tag = $this->where('id', $id)->update(['name' => $opVal]);
        } else {
            $tag = $this->where('id', $id)->update(['action' => $opVal]);
        }
        $opStatus = $tag?1:0;
        $opMessage = $tag ? '更新成功' : '更新失败';
        return [$opStatus,$opMessage];
    }

    /**
     * 获取子集导航菜单
     * @param int $parentID
     * @return array
     */
    public function getAuthChildNavMenus($parentID = 0): array
    {
        $res = $this
            ->field('name,action,id')
            ->where([["parent_id", '=', $parentID], ['type', '=', 1], ['status', '=', 1]])
            ->order('id','desc')
            ->select();
        return isset($res)?$res->toArray():[];
    }
}