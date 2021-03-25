<?php

namespace app\common\model;

use app\common\validate\Xcategory;
use think\Db;
use \think\Model;


class Xcategorys extends BaseModel
{
    // 设置当前模型对应的完整数据表名称
    protected $autoWriteTimestamp = 'datetime';
    protected $validate;

    public function __construct($data = [])
    {
        parent::__construct($data);
        $this->validate = new Xcategory();
    }

    /**
     * 后台获取产品分类数据列表
     * @param $curr_page
     * @param int $limit
     * @param null $search
     * @param string $catType 分类级别 F:顶级  S:二级
     * @return array
     */
    public function getCmsCategoryForPage($curr_page, $limit = 1, $search = null, $catType = "S")
    {
        $where[] = ['status', '=', 1];
        if ($catType == "F") {
            $where[] = ['parent_id', '=', 0];
            $where[] = ['level', '=', 1];
        } elseif ($catType == "S") {
            $where[] = ['parent_id', '>', 0];
            $where[] = ['level', '=', 2];
        }else{
            $where[] = ['level', '=', 3];
        }

        if ($search){
            $where[] = ['cat_name', 'like', '%' . $search . '%'];
        }
        $res = $this
            ->field('cat_id,cat_name,parent_id,is_show,status,icon,list_order')
            ->where($where)
            ->order(['list_order' => 'asc', 'cat_id' => 'desc'])
            ->limit($limit * ($curr_page - 1), $limit)
            ->select();
        foreach ($res as $key => $v) {
            if ($v['is_show'] == 0) {
                $res[$key]['status_checked'] = "";
            } else {
                $res[$key]['status_checked'] = "checked";
            }
            $parent = $this->getCmsCategoryByID($v['parent_id']);
            $res[$key]['parent_name'] = isset($parent['cat_name']) ? $parent['cat_name'] : '根级分类';

            if (isset($v['icon']) && !empty($v['icon'])){
                $img_url = imgToServerView($v['icon']);
                $str_cat_icon = "<img src='$img_url' class='layui-circle'>";
            }else{
                $str_cat_icon = "——";
            }
            $res[$key]['tip_cat_icon'] = $str_cat_icon;
        }
        return isset($res) ? $res->toArray() : [];
    }

    /**
     * 后台获取产品分类总数
     * @param null $search
     * @param string $catType
     * @return float|string
     */
    public function getCmsCategoryCount($search = null, $catType = "S")
    {
        $where[] = ['status', '=', 1];
        if ($catType == "F") {
            $where[] = ['parent_id', '=', 0];
            $where[] = ['level', '=', 1];
        } elseif ($catType == "S") {
            $where[] = ['parent_id', '>', 0];
            $where[] = ['level', '=', 2];
        }else{
            $where[] = ['level', '=', 3];
        }
        if ($search){
            $where[] = ['cat_name', 'like', '%' . $search . '%'];
        }
        return $this->where($where)->count(1);
    }

    /**
     * 进行新分类的添加操作
     * @param $data
     * @return array
     */

    public function addCategory($data = [])
    {
        $level = isset($data['level'])? intval($data['level']):1;
        $str_parent_id = "parent_id_".$level;
        $addData = [
            'cat_name' => isset($data['cat_name'])?$data['cat_name']:'',
            'parent_id' => isset($data[$str_parent_id])?$data[$str_parent_id]:null,
            'is_show' => isset($data['is_show'])?$data['is_show']:1,
            'icon' => isset($data['icon'])?$data['icon']:'',
            'level' => isset($data['level'])?$data['level']:1,
            'list_order' => isset($data['list_order'])?$data['list_order']:0,
        ];
       $validateRes = $this->validate($this->validate, $addData);
        if ($validateRes['tag']) {
            $tag = $this->insert($addData);
            $validateRes['tag'] = $tag;
            $validateRes['message'] = $tag ? '分类添加成功' : 'Sorry，分类添加失败';
            if ($tag){
                $this->updateCategorySelectListForJsonFile();
            }
        }
        return $validateRes;
    }


    /**
     * 根据分类ID 获取分类内容
     * @param $id
     * @return array
     */
    public function getCmsCategoryByID($id)
    {
        $res = $this
            ->field('*')
            ->where('cat_id', $id)
            ->find();
        if ($res){
            if (isset($res['icon']) && !empty($res['icon'])){
                $icon_full = imgToServerView($res['icon']);
            }else{
                $icon_full = "";
            }
            $res['icon_full'] = $icon_full;
        }
        return isset($res)?$res:[];
    }

    /**
     * 更新分类
     * @param $input
     * @param int $id
     * @return array
     */
    public function updateCmsCategoryData($input,$id=0)
    {
        $opTag = isset($input['tag']) ? $input['tag'] : 'edit';
        if ($opTag == 'del') {
            $delTag = Db::name('xcategorys')->where('cat_id', $id)->update(['status' => -1]);
            $validateRes = ['tag' => $delTag, 'message' => $delTag?'数据删除成功':'Sorry，数据删除失败！'];
        } else {
            $level = isset($input['level'])? intval($input['level']) : 1;
            $str_parent_id = "parent_id_".$level;
            $saveData = [
                'cat_name' => isset($input['cat_name'])?$input['cat_name']:'',
                'parent_id' => isset($input[$str_parent_id])?$input[$str_parent_id]:null,
                'is_show' => isset($input['is_show'])?$input['is_show']:1,
                'icon' => isset($input['icon'])?$input['icon']:'',
                'level' => isset($input['level'])?$input['level']:1,
                'list_order' => isset($input['list_order'])?$input['list_order']:0,
            ];
            $validateRes = $this->validate($this->validate, $saveData);
            if ($validateRes['tag']) {
                $saveTag = $this
                    ->where('cat_id', $id)
                    ->update($saveData);
                $validateRes['tag'] = $saveTag;
                $validateRes['message'] = $saveTag ? '数据更新成功' : 'Sorry，数据无变动';
                if ($saveTag){
                    $this->updateCategorySelectListForJsonFile();
                }
            }
        }
        return $validateRes;
    }

    /**
     * 此处可用于无限级分类
     * zhi 弃用 2019-03-14
     * @param $data
     * @param int $parent_id
     * @param int $level
     * @return array
     */
    public function diGui($data, $parent_id = 0, $level = 0)
    {
        static $arr = array();
        foreach ($data as $k => $v) {
            if (($v['cat_id'] != 0) && ($v['parent_id'] == $parent_id)) {
                $v['level'] = $level;
                $arr[] = $v;
                $this->diGui($data, $v['cat_id'], $level + 1);
            }
        }
        return $arr;
    }

    /**
     * 集成 待选商品分类数据
     * @param int $level
     * @param int $parent_id
     * @return array
     */
    public function getCmsToSelCategoryList($level = 1,$parent_id = 0)
    {
        $map = [['level', '=', $level],['status', '=', 1]];
        $map[] = ['parent_id', '=', $parent_id];

        $res = $this
            ->field('cat_id,cat_name')
            ->where($map)
            ->order(["list_order"=>"asc","cat_id"=>'asc'])
            ->select();

        foreach ($res as $key => $value){
            $childRes = $this->getCmsToSelCategoryList(intval($level+1),intval($value['cat_id']));
            $res[$key]['children'] = $childRes;
        }
        return isset($res) ? $res->toArray() : [];
    }

    /**
     * 将更新后的 分类数据，保存到 json 文件中
     */
    public function updateCategorySelectListForJsonFile(){
        $jsonData = $this->getCmsToSelCategoryList();
        file_put_contents("./cms/file/categorySelectList.json",json_encode($jsonData,JSON_UNESCAPED_UNICODE));
    }
    /**
     * 获取 可选分类的 json文件数据
     * @return mixed
     */
    public function getCategorySelectListFromJsonFile(){
        $jsonData = json_decode(file_get_contents("./cms/file/categorySelectList.json"),true);
        return $jsonData;
    }

    /**
     * 修改首页显示的状态
     * @param int $cat_id
     * @param int $okStatus
     * @return array
     */
    public function updateForShow($cat_id = 0, $okStatus = 0)
    {
        $cat_id = isset($cat_id) ? intval($cat_id) : 0;
        $saveTag = $this->where('cat_id', $cat_id)->update(['is_show' => $okStatus]);
        $message = $saveTag? "开关操作成功":"Sorry，开关更新失败！";
        return ['tag' => $saveTag, 'message' => $message];
    }
}

