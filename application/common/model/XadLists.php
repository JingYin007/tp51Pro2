<?php

namespace app\common\model;

use app\common\validate\XadList;
use think\Db;
use \think\Model;

/**
 * Created by PhpStorm.
 * User: moTzxx
 * Date: 2018/1/11
 * Time: 16:45
 */
class XadLists extends BaseModel
{
    protected $validate;

    public function __construct($data = [])
    {
        parent::__construct($data);
        $this->validate = new XadList();
    }


    /**
     * 获取全部可修改状态的 广告数据
     * @param int $id
     * @return array|null|\PDOStatement|string|Model
     */
    public function getAdByID($id = 0)
    {
        $res = $this
            ->field('*')
            ->where('id', $id)
            ->find();
        return $res ? $res : [];
    }

    /**
     * 获取 符合条件的 广告数量
     * @param null $search
     * @return int|string
     */
    public function getAdsCount($search = null)
    {
        $where = [['status','=',0]];
        if ($search){
            $where[] = ['ad_name|ad_tag', 'like', '%' . $search . '%'];
        }
        return $this->where($where)->count('id');
    }

    /**
     * 分页获取 广告数据
     * @param $curr_page
     * @param $limit
     * @param null $search
     * @return array|\PDOStatement|string|\think\Collection
     */
    public function getAdsForPage($curr_page, $limit, $search = null)
    {
        $where = [['status','=',0]];
        if ($search){
            $where[] = ['ad_name|ad_tag', 'like', '%' . $search . '%'];
        }
        $res = $this
            ->field('*')
            ->where($where)
            ->order(['list_order' => 'asc', 'id' => 'desc'])
            ->limit($limit * ($curr_page - 1), $limit)
            ->select();
        foreach ($res as $key => $v) {
            if ($v['is_show'] == 1){
                $res[$key]['status_checked'] = "checked";
            }else{
                $res[$key]['status_checked'] = "";
            }
            $res[$key]['original_img'] = imgToServerView($v['original_img']);
        }
        return isset($res) ? $res->toArray():[];
    }

    /**
     * 添加广告数据
     * @param $data
     * @return array
     */
    public function addAdvertisement($data)
    {
        $addData = [
            'ad_name' => isset($data['ad_name']) ? $data['ad_name'] : '',
            'ad_tag' => isset($data['ad_tag']) ? $data['ad_tag'] : '',
            'original_img' => isset($data['original_img']) ? $data['original_img'] : '/',
            'list_order' => isset($data['list_order']) ? intval($data['list_order']) : 0,
            'is_show' => isset($data['is_show']) ? 1 : 0,
            'start_time' => isset($data['start_time'])?$data['start_time']:'',
            'end_time' => isset($data['end_time'])?$data['end_time']:'',
        ];
        $validateRes = $this->validate($this->validate, $addData);
        if ($validateRes['tag']) {
            $insertGetId = $this->insertGetId($addData);
            $validateRes['tag'] = $insertGetId?1:0;
            $validateRes['message'] = $insertGetId ? '广告添加成功' : 'Sorry,添加失败';
        }
        return $validateRes;
    }

    /**
     * 更新广告数据
     * @param $id
     * @param $data
     * @return array
     */
    public function editAdvertisement($id, $data)
    {
        $opTag = isset($data['tag']) ? $data['tag'] : 'edit';
        $saveTag = 0;
        if ($opTag == 'del') {
            $saveTag = $this->where('id', $id)->update(['status' => -1]);
            $validateRes['message'] = $saveTag ? '数据删除成功' : 'Sorry，数据已删除';
        } else {
            $saveData = [
                'ad_name' => isset($data['ad_name']) ? $data['ad_name'] : '',
                'ad_tag' => isset($data['ad_tag']) ? $data['ad_tag'] : '',
                'original_img' => isset($data['original_img']) ? $data['original_img'] : '/',
                'list_order' => isset($data['list_order']) ? intval($data['list_order']) : 0,
                'is_show' => isset($data['is_show']) ? 1 : 0,
                'start_time' => isset($data['start_time'])?$data['start_time']:'',
                'end_time' => isset($data['end_time'])?$data['end_time']:'',
            ];
            $validateRes = $this->validate($this->validate, $saveData);
            if ($validateRes['tag']) {
                $saveTag = $this->where('id', $id)->update($saveData);
                $validateRes['message'] = $saveTag ? '广告修改成功' : 'Sorry,数据无变动';
            }
        }
        $validateRes['tag'] = $saveTag;
        return $validateRes;
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

}