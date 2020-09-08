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
        $where = [['status', '=', 0], ['cat_id', '<>', 0]];
        if ($catType == "F") {
            $where[] = ['parent_id', '=', 0];
            $where[] = ['level', '=', 1];
        } elseif ($catType == "S") {
            $where[] = ['parent_id', '>', 0];
            $where[] = ['level', '=', 2];
        }else{
            $where[] = ['level', '=', 3];
        }
        $res = $this
            ->field('cat_id,cat_name,parent_id,is_show,status,icon,list_order')
            ->where($where)
            ->whereLike('cat_name', '%' . $search . '%')
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
            $res[$key]['icon'] = imgToServerView($v['icon']);
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
        $where = [['status', '=', 0], ['cat_id', '<>', 0]];
        if ($catType == "F") {
            $where[] = ['parent_id', '=', 0];
            $where[] = ['level', '=', 1];
        } elseif ($catType == "S") {
            $where[] = ['parent_id', '>', 0];
            $where[] = ['level', '=', 2];
        }else{
            $where[] = ['level', '=', 3];
        }
        $count = $this
            ->field('cat_id')
            ->where($where)
            ->whereLike('cat_name', '%' . $search . '%')
            ->count();
        return $count;
    }

    /**
     * 进行新分类的添加操作
     * @param $data
     * @return array
     */

    public function addCategory($data)
    {
        $level = isset($data['level'])?$data['level']:1;
        $str_parent_id = "parent_id_".$level;
        $addData = [
            'cat_name' => isset($data['cat_name'])?$data['cat_name']:'',
            'parent_id' => isset($data[$str_parent_id])?$data[$str_parent_id]:0,
            'is_show' => isset($data['is_show'])?$data['is_show']:1,
            'icon' => isset($data['icon'])?$data['icon']:'',
            'level' => isset($data['level'])?$data['level']:1,
            'list_order' => isset($data['list_order'])?$data['list_order']:0,
        ];
        $tokenData = ['__token__' => isset($data['__token__']) ? $data['__token__'] : '',];
        $validateRes = $this->validate($this->validate, $addData, $tokenData);
        if ($validateRes['tag']) {
            $tag = $this->insert($addData);
            $validateRes['tag'] = $tag;
            $validateRes['message'] = $tag ? '添加成功' : '添加失败';
            if ($tag){
                $this->goToUpdateCategoryJsonData();
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
            Db::name('xcategorys')
                ->where('cat_id', $id)
                ->update(['status' => -1]);
            $validateRes = ['tag' => 1, 'message' => '删除成功'];
        } else {
            $level = isset($input['level'])?$input['level']:1;
            $str_parent_id = "parent_id_".$level;
            $saveData = [
                'cat_name' => isset($input['cat_name'])?$input['cat_name']:'',
                'parent_id' => isset($input[$str_parent_id])?$input[$str_parent_id]:0,
                'is_show' => isset($input['is_show'])?$input['is_show']:1,
                'icon' => isset($input['icon'])?$input['icon']:'',
                'level' => isset($input['level'])?$input['level']:1,
                'list_order' => isset($input['list_order'])?$input['list_order']:0,
            ];
            $tokenData = ['__token__' => isset($input['__token__']) ? $input['__token__'] : '',];
            $validateRes = $this->validate($this->validate, $saveData, $tokenData);
            if ($validateRes['tag']) {
                $saveTag = $this
                    ->where('cat_id', $id)
                    ->update($saveData);
                $validateRes['tag'] = $saveTag;
                $validateRes['message'] = $saveTag ? '修改成功' : '数据无变动';
                if ($saveTag){
                    $this->goToUpdateCategoryJsonData();
                }
            }
        }
        return $validateRes;
    }

    /**
     *  //TODO 进行json 数据的保存
     */
    public function goToUpdateCategoryJsonData(){
        $jsonData = [[
            "title" => "请点击选择",
            "id" => 0,
            "children" => $this->getCmsToSelCategoryList()
        ]];
        file_put_contents("./cms/file/categoryList.json",json_encode($jsonData));
    }

    /**
     * 此处可用于无限级分类
     * zhi 弃用 2019-03-14
     * @param $data
     * @param int $parent_id
     * @param int $level
     * @return array
     */
    public function digui($data, $parent_id = 0, $level = 0)
    {
        static $arr = array();
        foreach ($data as $k => $v) {
            if (($v['cat_id'] != 0) && ($v['parent_id'] == $parent_id)) {
                $v['level'] = $level;
                $arr[] = $v;
                $this->digui($data, $v['cat_id'], $level + 1);
            }
        }
        return $arr;
    }
    /**
     * 获取所有的产品分类（除顶级分类外）
     * @param int $tag 1：顶级分类  2：二级分类
     * @param int $parent_id
     * @return array
     */
    public function getNewCmsCategoryList($tag = 1,$parent_id = 1)
    {
        $map[] = ['level', '=', $tag];
        if ($tag == 1) {
            $map[] = ['parent_id', '=', 0];
        } else {
            $map[] = ['parent_id', '=', $parent_id];
        }
        $map[] = ['status', '=', 0];
        $res = $this
            ->field('cat_id,cat_name,parent_id')
            ->where($map)
            ->order(["list_order"=>"asc","cat_id"=>'asc'])
            ->select();
        foreach ($res as $key => $value){
            $first_id = $value['cat_id'];
            $secThemes = $this->getNewCmsCategoryList(2,$first_id);
            foreach ($secThemes as $key2 => $value2){
                $thirdThemes = $this->getNewCmsCategoryList(3,$value2['cat_id']);
                $secThemes[$key2]['child'] = $thirdThemes;
            }
            $res[$key]['child'] = $secThemes;
        }
        return isset($res) ? $res->toArray() : [];
    }

    /**
     * @param int $tag
     * @param int $parent_id
     * @return array
     */
    public function get2ndAnd3rdCategoryList($tag = 2,$parent_id = 1)
    {
        $map[] = ['level', '=', $tag];
        if ($tag != 2) {
            $map[] = ['parent_id', '=', $parent_id];
        }
        $map[] = ['status', '=', 0];
        $res = $this
            ->field('cat_id,cat_name,parent_id')
            ->where($map)
            ->order(["list_order"=>"asc","cat_id"=>'asc'])
            ->select();
        foreach ($res as $key => $value){
            $thirdThemes = $this->get2ndAnd3rdCategoryList(3,$value['cat_id']);
            $res[$key]['child'] = $thirdThemes;
        }
        return isset($res) ? $res->toArray() : [];
    }
    /**
     * 集成待选商品分类数据
     * @param int $tag
     * @param int $parent_id
     * @return array
     */
    public function getCmsToSelCategoryList($tag = 1,$parent_id = 1)
    {
        $map[] = ['level', '=', $tag];
        if ($tag == 1) {
            $map[] = ['parent_id', '=', 0];
        } else {
            $map[] = ['parent_id', '=', $parent_id];
        }
        $map[] = ['status', '=', 0];
        $res = $this
            ->field('cat_id id,cat_name title,parent_id')
            ->where($map)
            ->order(["list_order"=>"asc","cat_id"=>'asc'])
            ->select();
        foreach ($res as $key => $value){
            $first_id = $value['id'];
            $secThemes = $this->getCmsToSelCategoryList(2,$first_id);
            foreach ($secThemes as $key2 => $value2){
                $thirdThemes = $this->getCmsToSelCategoryList(3,$value2['id']);
                $secThemes[$key2]['children'] = $thirdThemes;
            }
            $res[$key]['children'] = $secThemes;
        }
        return isset($res) ? $res->toArray() : [];
    }

    /**
     * 修改首页显示的状态
     * @param int $cat_id
     * @param int $okStatus
     * @return array
     */
    public function updateForShow($cat_id = 0, $okStatus = 0)
    {
        $message = "Success";
        $cat_id = isset($cat_id) ? intval($cat_id) : 0;
        $saveTag = $this
            ->where('cat_id', $cat_id)
            ->update(['is_show' => $okStatus]);
        if (!$saveTag) {
            $message = "状态更改失败";
        }
        return ['tag' => $saveTag, 'message' => $message];
    }
}

