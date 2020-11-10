<?php

namespace app\common\model;

use app\common\validate\Xbrand;
use think\Db;


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
        $where = [['b.status', '<>', -1]];
        if ($catID){$where[] = ['b.cat_id','=',$catID];}
        $res = $this
            ->field('b.*,c.cat_name')
            ->alias('b')
            ->join('xcategorys c','c.cat_id = b.cat_id')
            ->where($where)
            ->whereLike('brand_name', '%' . $search . '%')
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
        $count = $this
            ->field('b.id')
            ->alias('b')
            ->join('xcategorys c','c.cat_id = b.cat_id')
            ->where($where)
            ->whereLike('brand_name', '%' . $search . '%')
            ->count('id');
        return $count;
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
        $tokenData = ['__token__' => isset($data['__token__']) ? $data['__token__'] : '',];
        $validateRes = $this->validate($this->validate, $addData, $tokenData);
        if ($validateRes['tag']) {
            $tag = $this->insert($addData);
            $validateRes['tag'] = $tag;
            $validateRes['message'] = $tag ? '添加成功' : '添加失败';
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
            ->field('*')
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
    public function updateCmsBrandData($input,$id=0)
    {
        $opTag = isset($input['tag']) ? $input['tag'] : 'edit';
        if ($opTag == 'del') {
            $this->where('id', $id)
                ->update(['status' => -1]);
            $validateRes = ['tag' => 1, 'message' => '数据删除成功'];
        } else {
            $saveData = [
                'brand_name' => isset($input['brand_name'])?$input['brand_name']:'',
                'brand_icon' => isset($input['brand_icon'])?$input['brand_icon']:'',
                'cat_id' => isset($input['cat_id'])?$input['cat_id']:null,
                'list_order' => isset($input['list_order'])?$input['list_order']:0,
                'updated_at' => date('Y-m-d H:i:s',time())
            ];
            $tokenData = ['__token__' => isset($input['__token__']) ? $input['__token__'] : '',];
            $validateRes = $this->validate($this->validate, $saveData, $tokenData);
            if ($validateRes['tag']) {
                $saveTag = $this
                    ->where('id', $id)
                    ->update($saveData);
                $validateRes['tag'] = $saveTag;
                $validateRes['message'] = $saveTag ? '数据更新成功' : '数据无变动';

            }
        }
        return $validateRes;
    }

    /**
     * 获取可供选择的品牌列表数据
     * @return array|array[]|\array[][]
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     */
    public function getSelectableList($seledCatID = null){
        $where = [['status','=',1]];
        if ($seledCatID){$where[] = ['cat_id','=',$seledCatID];}
        $list = $this
            ->field('id,brand_name')
            ->where($where)
            ->order(['list_order' => 'asc','id' => 'asc'])
            ->select();
        return isset($list)? $list->toArray(): [];
    }

}

