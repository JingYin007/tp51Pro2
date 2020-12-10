<?php

namespace app\common\model;

use app\common\validate\Xconfig;
use \think\Model;

/**
 * 配置项 model处理类
 * Class Xconfigs
 * @package app\common\model
 */
class Xconfigs extends BaseModel
{
    protected $validate;

    public function __construct($data = [])
    {
        parent::__construct($data);
        $this->validate = new Xconfig();
    }


    /**
     * 获取全部可修改状态的 数据
     * @param int $id
     * @return array|null|\PDOStatement|string|Model
     */
    public function getConfigByID($id = 0)
    {
        $res = $this
            ->field('*')
            ->where('id', $id)
            ->find();
        if ($res){
            $res['value'] = imgToServerView($res['value']);
        }
        return $res ? $res : [];
    }

    /**
     * 获取 符合条件的数量
     * @param null $search
     * @param string $input_type
     * @return int|string
     */
    public function getConfigsCount($search = null, $input_type = 'text')
    {
        $where = [["conf_type", '=', 0],["status", '=', 0], ['input_type', '=', $input_type]];
        if ($search){
            $where[] = ['title|tag', 'like', '%' . $search . '%'];
        }
        return $this->where($where)->count('id');
    }

    /**
     * 获取不同类型下的数目
     * @return array
     */
    public function getEachTypeData()
    {
        $res = $this
            ->field("*,count(id) count")
            ->where([["conf_type", '=', 0],["status", '=', 0]])
            ->group("input_type")
            ->select();
        $res  = isset($res) ? $res->toArray() : [];
        $arrCount = ['WB' => 0, 'KG' => 0, 'TP' => 0];
        foreach ($res as $key => $value) {
            $input_type = $value['input_type'];
            switch ($input_type) {
                case 'text':
                    $arrCount['WB'] = $value['count'];
                    break;
                case 'checkbox':
                    $arrCount['KG'] = $value['count'];
                    break;
                case 'button':
                    $arrCount['TP'] = $value['count'];
                    break;
                default:
                    break;
            }
        }
        return $arrCount;
    }

    /**
     * 分页获取数据
     * @param $curr_page
     * @param $limit
     * @param null $search
     * @param string $input_type
     * @return array|\PDOStatement|string|\think\Collection
     */
    public function getConfigsForPage($curr_page, $limit, $search = null, $input_type = 'text')
    {
        $where = [["conf_type", '=', 0],["status", '=', 0], ['input_type', '=', $input_type]];
        if ($search){
            $where[] = ['title|tag', 'like', '%' . $search . '%'];
        }
        $res = $this
            ->field('*')
            ->where($where)
            ->order(['list_order' => 'asc', 'id' => 'desc'])
            ->limit($limit * ($curr_page - 1), $limit)
            ->select();
        foreach ($res as $key => $v) {
            if ($v['input_type'] == "text") {
                $res[$key]['value_tip'] = "<span class=\"span-7EC0EE\">".$v['value']."</span>";
            } elseif ($v['input_type'] == "checkbox") {
                $id = $v['id'];
                $checkTag = $v['value']?"checked":"";
                $value_tip = "<input type=\"checkbox\" class=\"switch_checked\" lay-filter=\"switchConfigID\"
                   switch_config_id=\"$id\" $checkTag lay-skin=\"switch\" lay-text=\"开启|关闭\">";
                $res[$key]['value_tip'] = $value_tip;
            } else {
                $res[$key]['value_tip'] = "<img src=\"".imgToServerView($v['value'])."\">";
            }
        }
        return $res;
    }

    /**
     * 切换操作
     * @param int $config_id
     * @param int $okStatus
     * @return array
     */
    public function updateSwitchValue($config_id = 0, $okStatus = 0)
    {
        $message = "切换成功";
        $config_id = isset($config_id) ? intval($config_id) : 0;
        $saveTag = $this
            ->where('id', $config_id)
            ->update(['value' => $okStatus]);
        if (!$saveTag) {$message = "切换成功";}
        return ['tag' => $saveTag, 'message' => $message];
    }

    /**
     * 添加数据
     * @param $data
     * @return array
     */
    public function addConfig($data)
    {
        $input_type = isset($data['input_type']) ? $data['input_type'] : 'text';

        if ($input_type == "checkbox") {
            $value_checkbox = isset($data['value_checkbox']) ? $data['value_checkbox'] : '';
            $value = $value_checkbox?1:0;
        }elseif ($input_type == "text"){
            $value = isset($data['value_text']) ? $data['value_text'] : '';
        }else{
            $value = isset($data['value_button']) ? $data['value_button'] : '';
        }
        $addData = [
            'title' => isset($data['title']) ? $data['title'] : '',
            'tag' => isset($data['tag']) ? $data['tag'] : '',
            'input_type' => $input_type,
            'value' => $value,
            'list_order' => isset($data['list_order']) ? intval($data['list_order']) : 0,
            'tip' => isset($data['tip']) ? $data['tip'] : '',
            'add_time' => date("Y-m-d H:i:s", time()),
        ];
        $tokenData = ['__token__' => isset($data['__token__']) ? $data['__token__'] : '',];
        $validateRes = $this->validate($this->validate, $addData, $tokenData);
        if ($validateRes['tag']) {
            $insertGetId = $this->allowField(true)->insertGetId($addData);
            $validateRes['tag'] = $insertGetId ? 1 : 0;
            $validateRes['message'] = $insertGetId ? '添加成功' : '添加失败';
        }
        return $validateRes;
    }

    /**
     * 更新数据
     * @param $id
     * @param $data
     * @return array
     */
    public function editConfig($id, $data)
    {
        $opTag = isset($data['tag']) ? $data['tag'] : 'edit';
        $tag = 0;
        if ($opTag == 'del') {
            $tag = $this
                ->where('id', $id)
                ->update(['status' => -1]);
            $validateRes['message'] = $tag ? '数据删除成功' : '已删除';
        } else {
            $input_type = isset($data['input_type']) ? $data['input_type'] : 'text';

            if ($input_type == "checkbox") {
                $value_checkbox = isset($data['value_checkbox']) ? $data['value_checkbox'] : '';
                $value = $value_checkbox?1:0;
            }elseif ($input_type == "text"){
                $value = isset($data['value_text']) ? $data['value_text'] : '';
            }else{
                $value = isset($data['value_button']) ? $data['value_button'] : '';
            }

            $saveData = [
                'id' => $id,
                'title' => isset($data['title']) ? $data['title'] : '',
                'tag' => isset($data['tag']) ? $data['tag'] : '',
                'input_type' => $input_type,
                'value' => $value,
                'list_order' => isset($data['list_order']) ? intval($data['list_order']) : 0,
                'tip' => isset($data['tip']) ? $data['tip'] : '',
            ];
            $tokenData = ['__token__' => isset($data['__token__']) ? $data['__token__'] : '',];
            $validateRes = $this->validate($this->validate, $saveData, $tokenData);

            if ($validateRes['tag']) {
                $tag = $this
                    ->where('id', $id)
                    ->update($saveData);
                $validateRes['message'] = $tag ? '配置修改成功' : 'Sorry，数据无变动';
            }
        }
        $validateRes['tag'] = $tag;
        return $validateRes;
    }
}