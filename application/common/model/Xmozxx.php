<?php


namespace app\common\model;


use think\Db;

class Xmozxx
{
    /**
     * 获取开发日志
     * @param null $currTag 1：为最新日志  null:所有的日志
     * @return array|\PDOStatement|string|\think\Collection|\think\model\Collection
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     */
    public function getDevLogList($currTag = null){
        $count_date = Db::name('xproDevLogs')
            ->field("date_format(log_time,'%Y-%m-%d') date")
            ->group('date')
            ->count();

        $limit = $currTag ? "0,2" : "2,$count_date";
        $res = Db::name('xproDevLogs')
            ->field("date_format(log_time,'%Y-%m-%d') date")
            ->group('date')
            ->order(['date'=>'desc','id'=>'desc'])
            ->limit($limit)
            ->select();

        foreach ($res as $key => $value){
            $date = $value['date'];
            $logItem = Db::name('xproDevLogs')
                ->field("log_content,date_format(log_time,'%Y-%m-%d') date")
                ->where("log_time",'like',$date."%")
                ->order(['date'=>'desc','id'=>'desc'])
                ->select();
            $res[$key]['content'] = $logItem;
        }
        return isset($res)?$res:[];
    }
}