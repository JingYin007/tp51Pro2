<?php

namespace app\common\model;

use app\common\validate\Xbrand;


class Xbrands extends BaseModel
{
    // 设置当前模型对应的完整数据表名称
    protected $autoWriteTimestamp = 'datetime';
    protected $validate;

    public function __construct($data = [])
    {
        parent::__construct($data);
        $this->validate = new Xbrand();
    }

    /**
     * 后台获取产品品牌数据列表
     * @param $curr_page
     * @param int $limit
     * @param null $search
     * @param string $catID 分类
     * @return array
     */
    public function getCmsBrandForPage($curr_page, $limit = 1, $search = null, $catID = null)
    {
        $where = [['b.status', '>', -1]];
        if ($catID){$where[] = ['b.cat_id','=',$catID];}
        if ($search){
            $where[] = ['brand_name', 'like', '%' . $search . '%'];
        }
        $res = $this
            ->field('b.*,c.cat_name')
            ->alias('b')
            ->join('xcategorys c','c.cat_id = b.cat_id')
            ->where($where)
            ->order(['list_order' => 'asc', 'id' => 'desc'])
            ->limit($limit * ($curr_page - 1), $limit)
            ->select();
        foreach ($res as $key => $v) {
            if (isset($v['brand_icon']) && !empty($v['brand_icon'])){
                $img_url = imgToServerView($v['brand_icon']);
                $str_brand_icon = "<img src='$img_url'>";
            }else{
                $str_brand_icon = "——";
            }
            $res[$key]['tip_brand_icon'] = $str_brand_icon;
        }
        return isset($res) ? $res->toArray() : [];
    }

    /**
     * 后台获取品牌总数
     * @param null $search
     * @param string $catID
     * @return float|string
     */
    public function getCmsBrandCount($search = null, $catID = null)
    {
        $where = [['b.status', '>', -1]];
        if ($catID){$where[] = ['b.cat_id','=',$catID];}
        if ($search){
            $where[] = ['brand_name', 'like', '%' . $search . '%'];
        }
        return $this
            ->alias('b')
            ->join('xcategorys c','c.cat_id = b.cat_id')
            ->where($where)
            ->count('b.id');
    }

    /**
     * 进行新品牌添加操作
     * @param $data
     * @return array
     */

    public function addCmsBrand($data)
    {
        $addData = [
            'brand_name' => isset($data['brand_name'])?$data['brand_name']:'',
            'brand_icon' => isset($data['brand_icon'])?$data['brand_icon']:'',
            'cat_id' => isset($data['cat_id'])?$data['cat_id']:null,
            'list_order' => isset($data['list_order'])?$data['list_order']:0,
            'updated_at' => date('Y-m-d H:i:s',time())
        ];
        $validateRes = $this->validate($this->validate, $addData);
        if ($validateRes['tag']) {
            $tag = $this->insert($addData);
            $validateRes['tag'] = $tag;
            $validateRes['message'] = $tag ? '品牌添加成功' : 'Sorry，品牌添加失败';
        }
        return $validateRes;
    }


    /**
     * 根据ID 获取品牌内容
     * @param $id
     * @return array
     */
    public function getCmsBrandByID($id)
    {
        $res = $this
            ->field('id,brand_name,brand_icon,cat_id,list_order,status')
            ->where('id', $id)
            ->find();
        if (isset($res['brand_icon']) && !empty($res['brand_icon'])){
            $icon_full = imgToServerView($res['brand_icon']);
        }else{
            $icon_full = "";
        }
        $res['brand_icon_full'] = $icon_full;
        return isset($res)?$res:[];
    }

    /**
     * 更新品牌
     * @param $input
     * @param int $id
     * @return array
     */
    public function updateCmsBrandData($input,$id = 0)
    {
        $opTag = isset($input['tag']) ? $input['tag'] : 'edit';
        if ($opTag == 'del') {
            $delTag = $this->where('id', $id)->update(['status' => -1]);
            $validateRes = ['tag' => $delTag, 'message' => $delTag ? '品牌删除成功':'Sorry，品牌删除失败！'];
        } else {
            $saveData = [
                'brand_name' => isset($input['brand_name'])?$input['brand_name']:'',
                'brand_icon' => isset($input['brand_icon'])?$input['brand_icon']:'',
                'cat_id' => isset($input['cat_id'])?$input['cat_id']:null,
                'list_order' => isset($input['list_order'])?$input['list_order']:0,
            ];
            $validateRes = $this->validate($this->validate, $saveData);
            if ($validateRes['tag']) {
                $saveTag = $this->where('id', $id)->update($saveData);
                $validateRes['tag'] = $saveTag;
                $validateRes['message'] = $saveTag ? '数据更新成功' : 'Sorry，数据无变动';
            }
        }
        return $validateRes;
    }

    /**
     * 获取可供选择的品牌列表数据
     * @param int $catSelID
     * @return array|array[]|\array[][]
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     */
    public function getSelectableList($catSelID = 0){
        $where = [['status','=',1]];
        if ($catSelID){$where[] = ['cat_id','=',intval($catSelID)];}
        $list = $this
            ->field('id,brand_name')
            ->where($where)
            ->order(['list_order' => 'asc','id' => 'asc'])
            ->select();
        return isset($list)? $list->toArray(): [];
    }

}

