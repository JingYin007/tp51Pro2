<?php

namespace app\common\model;

use app\common\validate\Xactivity;
use app\common\validate\XnavMenu;
use think\Db;
use \think\Model;

/**
 * Created by PhpStorm.
 * User: moTzxx
 * Date: 2018/1/11
 * Time: 16:45
 */
class Xactivitys extends BaseModel
{
    protected $validate;

    public function __construct($data = [])
    {
        parent::__construct($data);
        $this->validate = new Xactivity();
    }


    /**
     * 获取全部可修改状态的 活动数据
     * @param int $id
     * @return array|null|\PDOStatement|string|Model
     */
    public function getActByID($id = 0)
    {
        $res = $this
            ->field('*')
            ->where('id', $id)
            ->find();
        return $res ? $res : [];
    }

    /**
     * 获取 符合条件的 活动数量
     * @param null $search
     * @return int|string
     */
    public function getActsCount($search = null,$actType = null)
    {
        $where = [['id', '>', '0'],['status','=',0]];
        if ($actType){$where[] = ['act_type','=',$actType];}
        if ($search){
            $where[] = ['title', 'like', '%' . $search . '%'];
        }
        return $this->where($where)->count('id');
    }

    /**
     * 分页获取 活动数据
     * @param $curr_page
     * @param $limit
     * @param null $search
     * @param string $OrderType
     * @return array|\PDOStatement|string|\think\Collection
     */
    public function getActsForPage($curr_page, $limit, $search = null,$OrderType = "W",$actType = null)
    {
        $where = [['id', '>', '0'],['status','=',0]];
        if ($OrderType == "W") {
            $order["list_order"] = "asc";
        }else{
            $order["id"] = "desc";
        }
        if ($actType){$where[] = ['act_type','=',$actType];}
        if ($search){
            $where[] = ['title', 'like', '%' . $search . '%'];
        }
        $res = $this
            ->field('*')
            ->where($where)
            ->order($order)
            ->limit($limit * ($curr_page - 1), $limit)
            ->select();
        foreach ($res as $key => $v) {
            if ($v['act_type'] == 1) {
                $res[$key]['type_tip'] = "<span class=\"layui-badge layui-bg-blue\">首页活动</span>";
            } else {
                $res[$key]['type_tip'] = "<span class=\"layui-badge layui-bg-cyan\">其他活动</span>";
            }
            if ($v['is_show'] == 1){
                $res[$key]['status_checked'] = "checked";
            }else{
                $res[$key]['status_checked'] = "";
            }
            $res[$key]['act_img'] = imgToServerView($v['act_img']);
            $res[$key]['start_time'] = date('Y-m-d H:i:s',intval($v['start_time']));
            $res[$key]['end_time'] = date('Y-m-d H:i:s',intval($v['end_time']));
        }
        return $res;
    }

    /**
     * 添加数据
     * @param $data
     * @return array
     */
    public function addActivity($data)
    {
        $addData = [
            'title' => isset($data['title']) ? $data['title'] : '',
            'act_tag' => isset($data['act_tag']) ? $data['act_tag'] : '',
            'act_img' => isset($data['act_img']) ? $data['act_img'] : '/',
            'list_order' => isset($data['list_order']) ? intval($data['list_order']) : 0,
            'is_show' => isset($data['is_show']) ? 1 : 0,
            'act_type' => isset($data['act_type']) ? $data['act_type'] : 2,
            'updated_at' => date("Y-m-d H:i:s",time()),
            'start_time' => isset($data['start_time'])?strtotime($data['start_time']):'',
            'end_time' => isset($data['end_time'])?strtotime($data['end_time']):'',
        ];
        $validateRes = $this->validate($this->validate, $addData);
        if ($validateRes['tag']) {
            $insertGetId = $this->insertGetId($addData);
            $aGoods = isset($data['aGoods'])?$data['aGoods']:[];
            $this->updateGoodsForActivity($insertGetId,$aGoods);
            $validateRes['tag'] = $insertGetId?1:0;
            $validateRes['message'] = $insertGetId ? '活动添加成功' : '添加失败';
        }
        return $validateRes;
    }

    /**
     * 更新数据
     * @param $id
     * @param $data
     * @return array
     */
    public function editActivity($id, $data)
    {
        $opTag = isset($data['tag']) ? $data['tag'] : 'edit';
        $saveTag = 0;
        if ($opTag == 'del') {
            $saveTag = $this->where('id', $id)->update(['status' => -1]);
            $validateRes['message'] = $saveTag ? '数据删除成功' : 'Sorry，数据已删除';
        } else {
            $saveData = [
                'id' => $id,
                'title' => isset($data['title']) ? $data['title'] : '',
                'act_tag' => isset($data['act_tag']) ? $data['act_tag'] : '',
                'act_img' => isset($data['act_img']) ? $data['act_img'] : '/',
                'list_order' => isset($data['list_order']) ? intval($data['list_order']) : 0,
                'is_show' => isset($data['is_show']) ? 1 : 0,
                'act_type' => isset($data['act_type']) ? $data['act_type'] : 2,
                'start_time' => isset($data['start_time'])?strtotime($data['start_time']):'',
                'end_time' => isset($data['end_time'])?strtotime($data['end_time']):'',
            ];
            $validateRes = $this->validate($this->validate, $saveData,'update');
            if ($validateRes['tag']) {
                $saveTag = $this->where('id', $id)->update($saveData);
                if ($saveTag){
                    $aGoods = isset($data['aGoods'])?$data['aGoods']:[];
                    $this->updateGoodsForActivity($id,$aGoods);
                }
                $validateRes['message'] = $saveTag ? '活动修改成功' : 'Sorry，数据无变动';
            }

        }
        $validateRes['tag'] = $saveTag;
        return $validateRes;
    }

    /**
     * 更新活动下的商品数据
     * @param int $actID
     * @param array $goodsData
     */
    public function updateGoodsForActivity($actID = 0,$goodsData = []){
        //TODO 初始化，默认修改所有的记录为已删除状态
        Db::name("xact_goods")
            ->where('act_id',$actID)
            ->update(['status'=>-1]);
        foreach ($goodsData as $key=>$value){
            $goodsID = $value;
            //判断数据库是否拥有该数据，如果没有则插入一条，反之进行状态更改
            $where = [['act_id','=',$actID],['goods_id','=',$goodsID]];
            $existTag =  Db::name("xact_goods")
                ->where($where)
                ->find();
            if ($existTag){
                Db::name("xact_goods")
                    ->where($where)
                    ->update(['status'=>0]);
            }else{
                Db::name("xact_goods")
                    ->insert(['act_id'=>$actID,'goods_id'=>$goodsID]);
            }
        }
    }
    /**
     * 修改首页显示的状态
     * @param int $act_id
     * @param int $okStatus
     * @return array
     */
    public function updateForShow($act_id = 0,$okStatus = 0){
        $message = "Success";
        $act_id = isset($act_id)?intval($act_id):0;
        $saveTag = $this
            ->where('id',$act_id)
            ->update(['is_show'=>$okStatus]);
        if (!$saveTag){
            $message = "状态更改失败";
        }
        return ['tag'=>$saveTag,'message'=>$message];
    }

    /**
     * 根据活动ID,获取参加该活动的商品
     * @param int $actID
     * @return array
     */
    public function getActGoods($actID = 0){
        $res = $this
            ->alias("a")
            ->field("g.goods_id,g.goods_name")
            ->join('xact_goods ag','a.id = ag.act_id')
            ->join('xgoods g','g.goods_id = ag.goods_id')
            ->where([
                ['ag.status','=',0],
                ['a.id','=',$actID]
            ])
            ->select();
        return $res?$res->toArray():[];
    }

}