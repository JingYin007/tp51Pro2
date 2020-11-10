<?php

namespace app\common\model;

use app\common\validate\XspecInfo;
use think\Db;
use \think\Model;


class XspecInfos extends BaseModel
{
    // 设置当前模型对应的完整数据表名称
    protected $autoWriteTimestamp = 'datetime';
    protected $validate;

    public function __construct($data = [])
    {
        parent::__construct($data);
        $this->validate = new XspecInfo();
    }

    /**
     * @param $curr_page
     * @param int $limit
     * @param null $search
     * @param null $catID
     * @param null $specID
     * @return array|\PDOStatement|string|\think\Collection
     */
    public function getCmsSpecInfoForPage($curr_page, $limit = 1, $search = null, $catID  = null,$specID = null)
    {
        $where = [['s1.status', '=', 1], ['s1.parent_id', '=', 0]];
        if ($catID){$where[] =  ['s1.cat_id', '=', isset($catID)?$catID:null];}
        if ($specID){$where[] =  ['s1.spec_id', '=', isset($specID)?$specID:null];}
        $res = $this
            ->alias("s1")
            ->field('s1.*,c.cat_name')
            ->join('xcategorys c','c.cat_id = s1.cat_id')
            ->where($where)
            ->whereLike('s1.spec_name|s1.mark_msg', '%' . $search . '%')
            ->order(['s1.list_order' => 'asc', 's1.spec_id' => 'desc'])
            ->limit($limit * ($curr_page - 1), $limit)
            ->select();
        foreach ($res as $key => $value){
            $msg = $value['mark_msg'];
            $res[$key]['mark_msg'] = empty($msg)?'——':$msg;
        }
        return isset($res)?$res->toArray():[];
    }

    /**
     * 后台获取产品属性总数
     * @param null $search
     * @param int $catID
     * @return float|string
     */
    public function getCmsSpecInfoCount($search = null, $catID = null,$specID = null)
    {
        $where = [['s1.status', '=', 1], ['s1.parent_id', '=', 0]];
        if ($catID){$where[] =  ['s1.cat_id', '=', isset($catID)?$catID:null];}
        if ($specID){$where[] =  ['s1.spec_id', '=', isset($specID)?$specID:null];}
        $count = $this
            ->alias("s1")
            ->field('s1.spec_id')
            ->join('xcategorys c','c.cat_id = s1.cat_id')
            ->where($where)
            ->whereLike('s1.spec_name|s1.mark_msg', '%' . $search . '%')
            ->count();
        return $count;
    }

    /**
     * 进行添加操作
     * @param $data
     * @return array
     */
    public function addSpecInfo($data)
    {
        $addData = [
            'spec_name' => isset($data['spec_name']) ? $data['spec_name'] : '',
            'cat_id' => isset($data['toSelCatID'])?intval($data['toSelCatID']):0,
            'parent_id' => isset($data['id'])?intval($data['id']):0,
            'list_order' => intval($data['list_order']),
            'mark_msg' => isset($data['mark_msg']) ? $data['mark_msg'] : '',
        ];

        $tokenData = ['__token__' => isset($data['__token__']) ? $data['__token__'] : '',];
        $validateRes = $this->validate($this->validate, $addData, $tokenData);
        if ($validateRes['tag']) {
            $tag = $this->insert($addData);
            $validateRes['tag'] = $tag;
            $validateRes['message'] = $tag ? '数据添加成功' : '数据添加失败';
        }
        return $validateRes;
    }


    /**
     * 根据属性ID 获取属性内容
     * @param $id
     * @return array
     */
    public function getCmsSpecInfoByID($id)
    {
        $res = $this
            ->field('*')
            ->where('spec_id', $id)
            ->find();
        return isset($res)?$res->toArray():[];
    }

    /**
     * 更新属性信息
     * @param int $id
     * @param $input
     * @param int $level
     * @return array
     */
    public function updateCmsSpecInfoData($id = 0,$input,$level = 1)
    {
        $opTag = isset($input['tag']) ? $input['tag'] : 'edit';
        if ($opTag == 'del') {
            $this
                ->where('spec_id', $id)
                ->update(['status' => -1]);
            $validateRes = ['tag' => 1, 'message' => '数据删除成功'];
        } else {
            $tokenData = ['__token__' => isset($input['__token__']) ? $input['__token__'] : '',];
            if ($level == 1){
                $saveData = [
                    'spec_name' => isset($input['spec_name']) ? $input['spec_name'] : '',
                    'cat_id' => intval($input['toSelCatID']),
                    'list_order' => intval($input['list_order']),
                    'mark_msg' => isset($input['mark_msg']) ? $input['mark_msg'] : '',
                ];
                $validateRes = $this->validate($this->validate, $saveData, $tokenData);
            }else{
                $saveData = [
                    'spec_name' => isset($input['spec_name']) ? $input['spec_name'] : '',
                    'list_order' => intval($input['list_order']),
                    'mark_msg' => isset($input['mark_msg']) ? $input['mark_msg'] : '',
                ];
                $validateRes = ['tag' => 1, 'message' => '数据更新成功'];
            }

            if ($validateRes['tag']) {
                $saveTag = $this
                    ->where('spec_id', $id)
                    ->update($saveData);
                $validateRes['tag'] = $saveTag;
                $validateRes['message'] = $saveTag ? '数据更新成功' : '数据无变动';
            }
        }
        return $validateRes;
    }

    /**
     * 根据商品分类ID 获取父级属性
     * @param int $seledCatID
     * @return array
     */
    public function getSpecInfoFstByCat($seledCatID = 0)
    {
        $specList = $this
            ->field("spec_id,spec_name,mark_msg")
            ->where([
                ['parent_id', '=', 0],
                ['cat_id', '=', intval($seledCatID)],
                ['status','<>',-1]])
            ->select();
        foreach ($specList as $key => $value) {
            if ($value && $value['mark_msg']) {
                $specList[$key]['mark_msg'] = "【" . $value['mark_msg'] . "】";
            }
        }
        return $specList ? $specList->toArray() : [];
    }

    /**
     * 根据父级属性值获取次级信息
     * @param int $specFstID
     * @return array
     */
    public function getSpecInfoBySpecFst($specFstID = 0)
    {
        $where = [['s1.status', '=', 1],
            ['s1.parent_id', '=', $specFstID],
            ['s1.parent_id', '<>', 0]];
        $specList = $this
            ->alias("s1")
            ->field('s1.*')
            ->where($where)
            ->order(['s1.list_order' => 'asc', 's1.spec_id' => 'desc'])
            ->select();
        foreach ($specList as $key => $value) {
            if ($value && $value['mark_msg']) {
                $specList[$key]['mark_msg'] = "【" . $value['mark_msg'] . "】";
            }
        }
        return isset($specList) ? $specList->toArray() : [];
    }

    public function getSpecDetailsBySepcIDForPage($curr_page, $limit = 1,
                                                  $search = null, $specID = null)
    {
        $where = [['s1.status', '=', 1], ['s1.parent_id', '=', $specID]];
        $res = $this
            ->alias("s1")
            ->field('s1.*')
            ->where($where)
            ->whereLike('s1.spec_name', '%' . $search . '%')
            ->order(['s1.list_order' => 'asc', 's1.spec_id' => 'desc'])
            ->limit($limit * ($curr_page - 1), $limit)
            ->select();
        return isset($res)?$res->toArray():[];
    }
    public function getSpecDetailsBySepcIDCount($search = null, $specID = null){
        $where = [['s1.status', '=', 1], ['s1.parent_id', '=', $specID]];
        $count = $this
            ->alias("s1")
            ->field('s1.*')
            ->where($where)
            ->whereLike('s1.spec_name', '%' . $search . '%')
            ->count();
        return $count;
    }

}

