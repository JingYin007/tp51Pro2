<?php


namespace app\common\model;


use think\Model;
use think\model\concern\SoftDelete;

class XcmsOpLogs extends Model
{
    use SoftDelete;

    protected $table;
    public $autoWriteTimestamp = 'datetime';

    /**
     * 如果只是用静态方法，是不会调用构造函数的
     * XcmsOpLogs constructor.
     * @param array $data
     */
    public function __construct($data = [])
    {
        parent::__construct($data);
        $prefix = config('database.prefix');
        $this->table = $prefix.'xcms_op_logs';
    }

}