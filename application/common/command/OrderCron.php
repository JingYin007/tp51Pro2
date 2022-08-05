<?php
namespace app\common\command;

use think\console\Command;
use think\console\Input;
use think\console\input\Argument;
use think\console\Output;

/**
 * 配置自定义指令
 * Class Order
 * @package app\common\command
 */
class OrderCron extends Command
{
    protected function configure()
    {
        $this->setName('order_cron_hello')
            ->addArgument('op_name', Argument::OPTIONAL, "your name")
            ->setDescription('Say Hello');
    }

    /**
     * 执行操作
     * @param Input $input
     * @param Output $output
     * @return int|void|null
     */
    protected function execute(Input $input, Output $output)
    {
        $op_name = trim($input->getArgument('op_name'));
        //示例代码
        while (false){
            /**
             * 1. 获取 redis-sorted set 排序集合中最早的一条订单ID
             * 2. 到数据库查询此订单是否已支付
             * 3. 已支付，则进行状态删除
             *    未支付，则sku数量+操作，然后状态删除
             * 4. redis->zRem() 移除记录
             * 5. 记录日志信息
             */
            $output->writeln("Hello,order-second ...!" );
            sleep(2);
        }
        // 指令输出
        $date_stamp = date('Y-m-d H:i:s',time());
        $output->writeln("$date_stamp order_cron-$op_name");
    }
}