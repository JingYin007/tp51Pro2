<?php


namespace app\common\model;


use app\common\lib\SpreadsheetService;
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
            ->group('date')
            ->count('id');

        $limit = $currTag ? "0,5" : "5,$count_date";

        $res = Db::name('xproDevLogs')
            ->field("date_format(log_time,'%Y-%m-%d') date,min(id) min_id")
            ->group('date')
            ->order(['date'=>'desc','min_id'=>'desc'])
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

    /**
     * 获取测试 Excel 数据表中的数据
     * @return array|PDOStatement|string|Collection|\think\model\Collection
     * @throws DataNotFoundException
     * @throws DbException
     * @throws ModelNotFoundException
     */
    public function getExcelTestData(){
        $downList = Db::name('xop_excel')
            ->field('goods_name,thumbnail,place,reference_price,status')
            ->select();

        foreach ($downList as &$vo){
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
        return $downList;
    }

    /**
     * 导入 excel 表中的数据
     * @param $file_real_path
     * @return array
     */
    public function importExcelData($file_real_path){
        $opRes = (new SpreadsheetService())->readExcelFileToArray($file_real_path,"A2");
        //TODO 根据返回来到数据数组，进行数据向数据库的插入或其他操作 ...
        if (isset($opRes['data'])){
            $resultArr = [];
            foreach ($opRes['data'] as $key => $value) {
                $resultArr[$key]['goods_name'] = isset($value[0])?$value[0]:'';
                $resultArr[$key]['thumbnail'] = isset($value[1])?$value[1]:'';
                $resultArr[$key]['place'] = isset($value[2])?$value[2]:'';
                $resultArr[$key]['reference_price'] = isset($value[3])?$value[3]:'';
                $resultArr[$key]['updated_at'] = date("Y-m-d H:i:s",time());
            }
            /**
             * TODO 此时进行数据表记录的遍历插入操作即可
             * 因为数据量较大，建议使用批量插入的方式,以我的业务需求，代码举例如下：
             */
            Db::name('xop_excel')->data($resultArr)->limit(10)->insertAll();
            unset($resultArr);
        }
        return ['status' => $opRes['status'],'message'=>$opRes['message']];
    }


}