<?php


namespace app\common\model;


use PDOStatement;
use think\Collection;
use think\Db;
use think\db\exception\DataNotFoundException;
use think\db\exception\ModelNotFoundException;
use think\exception\DbException;

class Xmozxx
{
    /**
     * 获取开发日志
     * @param null $currTag 1：为最新日志  null:所有的日志
     * @return array|PDOStatement|string|Collection|\think\model\Collection
     * @throws DataNotFoundException
     * @throws ModelNotFoundException
     * @throws DbException
     */
    public function getDevLogList($currTag = null){
        $count_date = Db::name('xproDevLogs')
            ->field("date_format(log_time,'%Y-%m-%d') date")
            ->group('date,id')
            ->count('id');

        $limit = $currTag ? "0,3" : "3,$count_date";

        $res = Db::name('xproDevLogs')
            ->field("date_format(log_time,'%Y-%m-%d') date")
            ->group('date,id')
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

    public function getExcelTestLoginData(){
        //$loginList = Db::name('xexcel_log')->select();
        $loginList = Db::name('xexcel_large')
            ->field('goods_name,thumbnail,place,reference_price,status')
            ->select();
        foreach ($loginList as &$vo){
            $status = $vo['status'] ;
            //-1：删除 0：待上架 1：已上架 2：预售
            switch ($status){
                case -1:
                    $vo['status'] = "删除";
                    break;
                case 0:
                    $vo['status'] = "待上架";
                    break;
                case 1:
                    $vo['status'] = "已上架";
                    break;
                case 2:
                    $vo['status'] = "预售";
                    break;
            }
        }
        return $loginList;
    }
}