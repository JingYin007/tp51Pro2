<?php

namespace app\common\model;

use app\common\validate\XtodayWord;
use think\Db;
use \think\Model;

/**
 * Created by PhpStorm.
 * User: moTzxx
 * Date: 2018/1/11
 * Time: 16:45
 */
class XtodayWords extends BaseModel
{
    protected $validate;

    public function __construct($data = [])
    {
        parent::__construct($data);
        $this->validate = new XtodayWord();
    }

    /**
     * 根据ID 获取赠言数据
     * @param int $id
     * @return array|null|\PDOStatement|string|Model
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     */
    public function getTodayWord($id = 0)
    {
        // 此时，根据ID取出对应的数据
        if ($id) {
            $res = $this
                ->where('id', $id)
                ->find();
            if ($res){
                $images_str = $res['images_str'];
                if ($images_str){$img_list = explode(',',$images_str);}
                $res['img_list'] = isset($img_list)?$img_list:[];
            }
        } else {
            //此處 隨機取出一條數據
            $allRes = $this
                ->field("id")
                ->where("status", 1)
                ->select()
                ->toArray();
            $arrIDs = [];
            foreach ($allRes as $key => $value) {
                array_push($arrIDs, $value['id']);
            }
            $randID = array_rand($arrIDs, 1);
            $res = $this
                //TODO 这个　rand() 有时候不好用
                //->order("rand()")
                ->where('id', $arrIDs[$randID])
                ->find();
        }
        return isset($res)?$res->toArray():[];
    }

    /**
     * 获取 今日赠言 正常数据的数量
     * @return mixed
     */
    public function getTodayWordsCount($search = null)
    {
        $res = $this
            ->field('id')
            ->where("status", 1)
            ->whereLike('from', '%' . $search . '%')
            ->count();
        return $res;
    }

    /**根据页码 获取赠言数据
     * @param $curr_page 当前页数
     * @param $limit 本页要获取的记录条数
     * @param null $search
     * @return array
     */
    public function getTodayWordsForPage($curr_page, $limit, $search = null)
    {
        $res = $this
            ->field('*')
            ->order('id desc')
            ->where('status', 1)
            ->whereLike('from', '%' . $search . '%')
            ->limit($limit * ($curr_page - 1), $limit)
            ->select();
        foreach ($res as $key => $v) {
            if ($v['status'] == 1) {
                $statusTip = '正常';
                $statusColor = 'blue';
            } else {
                $statusTip = '删除';
                $statusColor = 'cyan';
            }
            $res[$key]['status_tip'] = "<span class=\"layui-badge layui-bg-$statusColor\">$statusTip</span>";
            $res[$key]['picture'] = imgToServerView($v['picture']);
            $image_str = $v['images_str'];
            $img_list_str = "";
            if ($image_str){
                $image_list = explode(',',$v['images_str']);
                foreach ($image_list as $key2 => $pic){
                    $picUrl = imgToServerView($pic);
                    $img_list_str.="<img src=\"{$picUrl}\" class=\"view_image\">";
                }
            }
            $res[$key]['image_list_view'] = $img_list_str;
        }
        return isset($res)?$res->toArray():[];
    }

    /**
     * 增加赠言实现代码
     * @param $data
     * @return array
     */
    public function addTodayWord($data)
    {
        $addData = [
            'from' => isset($data['from'])?$data['from']:'',
            'picture' => isset($data['picture'])?$data['picture']:'',
            'word' => isset($data['word'])?$data['word']:'',
            'updated_at' => date("Y-m-d H:i:s", time()),
            'status' => $data['status'],
            'images_str' => isset($data['images_str'])?$data['images_str']:'',
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
     * 编辑赠言实现代码
     * @param $id 赠言标识 ID
     * @param $data post 数据
     * @return mixed
     */
    public function editTodayWord($id, $data)
    {

        $opTag = isset($data['tag']) ? $data['tag'] : 'edit';
        if ($opTag == 'del') {
            $this
                ->where('id', $id)
                ->update(['status' => -1]);
            $validateRes = ['tag' => 1, 'message' => '删除成功'];
        } else {
            $saveData = [
                'from' => isset($data['from'])?$data['from']:'',
                'picture' => isset($data['picture'])?$data['picture']:'',
                'word' => isset($data['word'])?$data['word']:'',
                'updated_at' => date("Y-m-d H:i:s", time()),
                'status' => $data['status'],
                'images_str' => isset($data['images_str'])?$data['images_str']:'',
            ];
            $tokenData = ['__token__' => isset($data['__token__']) ? $data['__token__'] : '',];
            $validateRes = $this->validate($this->validate, $saveData, $tokenData);
            if ($validateRes['tag']) {
                $saveTag = $this
                    ->where('id', $id)
                    ->update($saveData);
                $validateRes['tag'] = $saveTag;
                $validateRes['message'] = $saveTag ? '修改成功' : '数据无变动';
            }
        }
        return $validateRes;
    }
}