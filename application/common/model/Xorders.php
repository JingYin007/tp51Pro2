<?php


namespace app\common\model;


use think\Db;
use think\db\exception\DataNotFoundException;
use think\db\exception\ModelNotFoundException;
use think\exception\DbException;

/**
 * 订单数据操作类
 * Class Xorders
 * @package app\common\model
 */
class Xorders extends BaseModel
{
    // 设置当前模型对应的完整数据表名称
    protected $table;
    public function __construct($data = [])
    {
        parent::__construct($data);
        $prefix = config('database.prefix');

         $this->table = $prefix.'xorder_infos';
    }

    /**
     * 获取支付订单数据
     * @param int $curr_page
     * @param int $page_limit
     * @param null $search
     * @return array|array[]|\array[][]
     * @throws DataNotFoundException
     * @throws ModelNotFoundException
     * @throws DbException
     */
    public function getPayOrdersForPage($curr_page = 1, $page_limit = 1, $search  = null){
        $where = [['pay_time','>',0]];
        if ($search){
            $where[] = ['order_sn|nick_name|consignee', 'like', '%' . $search . '%'];
        }
        $res = $this
            ->alias('oi')
            ->field("oi.*,user_avatar,nick_name")
            ->join('xusers u','u.id = oi.user_id')
            ->where($where)
            ->order(['oi.pay_time' => 'desc'])
            ->limit($page_limit * ($curr_page - 1), $page_limit)
            ->select();
        foreach ($res as $key => $value){
            $pay_channel = $value['pay_channel'];
            switch ($pay_channel){
                case 0:
                    $pay_channel = "微信";
                    break;
                case 1:
                    $pay_channel = "支付宝";
                    break;
                case 2:
                    $pay_channel = "余额";
                    break;
                default:
                    break;
            }
            $order_id = $value['id'];
            $res[$key]['reduce_amount'] = $value['reduce_amount']>0?$value['reduce_amount']:'——';
            $res[$key]['logistics_fee'] = $value['logistics_fee']>0?$value['logistics_fee']:'——';

            $res[$key]['pay_time'] = date("Y-m-d H:i:s",$value['pay_time']);
            $res[$key]['pay_channel'] = $pay_channel;

            $detailInfo = $this->getOrderDetailsByOrderID($order_id);
            $res[$key]['goods_amount_total'] = $detailInfo['goods_amount_total'];
            $res[$key]['goods_num_total'] = $detailInfo['goods_num_total'];

        }
        return isset($res)?$res->toArray():[];
    }

    /**
     * 获取订单详情数量
     * @param int $order_id
     * @return array|\PDOStatement|string|\think\Model
     * @throws DataNotFoundException
     * @throws ModelNotFoundException
     * @throws DbException
     */
    public function getOrderDetailsByOrderID($order_id = 0){
        $where = [['status','>',0],['order_id','=',$order_id]];
        $detailInfo = Db::name('xorder_details')
            ->field('sum(goods_num) goods_num_total,sum(goods_amount) goods_amount_total')
            ->where($where)
            ->find();
        return isset($detailInfo)?$detailInfo:[];
    }

    /**
     * 获取支付订单数量
     * @param null $search
     * @return float|int|string
     */
    public function getPayOrdersCount($search = null){
        $where = [['pay_time','>',0]];
        if ($search){
            $where[] = ['order_sn|nick_name|consignee', 'like', '%' . $search . '%'];
        }
        return $this
            ->alias('oi')
            ->join('xusers u','u.id = oi.user_id')
            ->where($where)
            ->count('oi.id');
    }

    /**
     * 获取 订单商品清单数据
     * @param int $curr_page
     * @param int $page_limit
     * @param null $search
     * @param null $orderStatus
     * @return array|array[]|\array[][]
     * @throws DataNotFoundException
     * @throws ModelNotFoundException
     * @throws DbException
     */
    public function getOrderDetailsForPage($curr_page = 1, $page_limit = 1, $search  = null, $orderStatus = null){
        $where = [['pay_time','>',0],['od.status','>',0]];
        if ($orderStatus){$where[] = ['od.status','=',$orderStatus];}
        if ($search){
            $where[] = ['order_sn|consignee|mobile|address|goods_name', 'like', '%' . $search . '%'];
        }
        $res = $this
            ->alias('oi')
            ->field("oi.*,od.*")
            ->join('xorder_details od','od.order_id = oi.id')
            ->where($where)
            ->order(['oi.pay_time' => 'desc'])
            ->limit($page_limit * ($curr_page - 1), $page_limit)
            ->select();
        foreach ($res as $key => $value){
            $pay_channel = $value['pay_channel'];
            switch ($pay_channel){
                case 0:
                    $pay_channel = "微信";
                    break;
                case 1:
                    $pay_channel = "支付宝";
                    break;
                case 2:
                    $pay_channel = "余额";
                    break;
                default:
                    break;
            }
            $res[$key]['goods_thumbnail'] = imgToServerView($value['goods_thumbnail']);
            $res[$key]['pay_time'] = date("Y-m-d H:i:s",$value['pay_time']);
            $res[$key]['pay_channel'] = $pay_channel;

            $goods_amount = $value['goods_amount'];
            $tip_pay_msg = "<span class='layui-badge' title='商品总价'>￥$goods_amount</span>";
            $discount_amount = $value['discount_amount'];
            if ($discount_amount > 0){
                $tip_pay_msg .= "<span class='layui-badge layui-bg-green' title='优惠金额'>￥$discount_amount</span>";
            }

            $sku_spec_msg = $value['sku_spec_msg'];
            if ($sku_spec_msg){
                $res[$key]['tip_sku_spec_msg'] = "<hr><span class='layui-badge layui-bg-blue'>$sku_spec_msg</span>";
            }else{
                $res[$key]['tip_sku_spec_msg'] = "";
            }
            $res[$key]['tip_pay_msg'] = $tip_pay_msg;
            $detail_status = $value['status'];
            $layui_bg_color = "";
            switch ($detail_status){
                // 1：已支付; 2：已发货； 3：已收货 4：已评价 ；5：售后申请中 6：售后已完成
                case 1:$status_msg = "待发货";break;
                case 2:$status_msg = "已发货";$layui_bg_color="layui-bg-orange";break;
                case 3:$status_msg = "已收货";$layui_bg_color="layui-bg-green";break;
                case 4:$status_msg = "已评价";$layui_bg_color="layui-bg-cyan";break;
                case 5:$status_msg = "售后申请中";$layui_bg_color="layui-bg-blue";break;
                case 6:$status_msg = "售后已完成";$layui_bg_color="layui-bg-black";break;
                default:$status_msg = "——";break;
            }
            $res[$key]['tip_status_msg'] = "<span class='layui-badge $layui_bg_color'>$status_msg</span>";
            $courier_sn = $value['courier_sn'];
            $courier_sn_str = "<button type='button' class='layui-btn layui-btn-sm layui-btn-radius btn-courier_sn'>$courier_sn</button>";
            $res[$key]['tip_courier_msg'] = ($detail_status > 1 && !empty($courier_sn))?$courier_sn_str."<hr>":"";

        }
        return isset($res)?$res->toArray():[];
    }

    /**
     * 获取订单详情数量
     * @param null $search
     * @param null $orderStatus
     * @return float|int|string
     */
    public function getOrderDetailsCount($search = null,$orderStatus = null){
        $where = [['pay_time','>',0],['od.status','>',0]];
        if ($orderStatus){$where[] = ['od.status','=',$orderStatus];}
        if ($search){
            $where[] = ['order_sn|consignee|mobile|address|goods_name', 'like', '%' . $search . '%'];
        }
        $count = $this
            ->alias('oi')
            ->join('xorder_details od','od.order_id = oi.id')
            ->where($where)
            ->count('od.id');
        return $count;
    }

    /**
     * 根据订单ID 获取清单列表
     * @param string $order_id
     * @return array|\PDOStatement|string|\think\Collection|\think\model\Collection
     * @throws DataNotFoundException
     * @throws ModelNotFoundException
     * @throws DbException
     */
    public function getShoppingList($order_id = ''){
        $res = Db::name('xorder_details')
            ->field('goods_name,goods_price,goods_num,goods_amount,sku_spec_msg')
            ->where([['status','>',0],['order_id','=',$order_id]])
            ->select();
        foreach ($res as $key => $v){
            $res[$key]['sku_spec_msg'] = isset($v['sku_spec_msg'])?$v['sku_spec_msg']:'——';
        }
        return $res;
    }

    /**
     * 获取快递鸟物流公司对应数据
     * @return array|\PDOStatement|string|\think\Collection|\think\model\Collection
     * @throws DataNotFoundException
     * @throws ModelNotFoundException
     * @throws DbException
     */
    public function getBirdExpressList(){
        $birdExpressList = Db::name("xbird_express")
            ->field('*')
            ->select();
        return $birdExpressList;
    }
    /**
     * 根据物流单号，获取其快递公司信息
     * @param string $op_id
     * @return array
     */
    public function getLogisticsMsgFromOrderGoods($op_id = '0')
    {
        $resData = Db::name('xorder_details od')
            ->field("be.name,be.code,od.customer_name,od.courier_sn")
            ->join('xbird_express be', 'be.code = od.courier_code')
            ->where("od.id", $op_id)
            ->find();
        return isset($resData) ? $resData : [];
    }
    public function getCourierInfoByODID($op_id = 0){
        $courierInfo = Db::name('xorder_details')
            ->field('courier_sn,courier_code,customer_name')
            ->where('id',$op_id)
            ->find();
        return $courierInfo ? $courierInfo:[];
    }

    /**
     * 更新物流信息
     * @param array $postData
     * @return array
     * @throws \think\Exception
     * @throws \think\exception\PDOException
     */
    public function updateCourierInfo($postData = [])
    {
        $opID = isset($postData['opID'])? $postData['opID']:0;
        $courier_sn = isset($postData['courier_sn'])? $postData['courier_sn']:'';
        $courier_code = isset($postData['courier_code'])? $postData['courier_code']:'';
        $customer_name = isset($postData['customer_name'])? $postData['customer_name']:'';

        if ($opID && $courier_sn && $courier_code) {
            $tag = Db::name('xorder_details')
                ->where([
                    ["id", '=', $opID],
                    ["status", '<', 3]
                ])
                ->update([
                    'courier_sn' => trim($courier_sn),
                    'courier_code' => trim($courier_code),
                    'customer_name' => $customer_name,
                    'status' => 2,
                    'delivery_time' => time()
                ]);

            $message = $tag ? "物流单号添加成功" : "当前订单状态，拒绝添加操作";
        } else {
            $tag = 0;
            $message = "请完整填写信息";
        }
        return ['status' => $tag, 'message' => $message];
    }

    /**
     * 获取热销产品数据
     * @param string $date
     * @param string $date2
     * @return array
     * @throws DataNotFoundException
     * @throws ModelNotFoundException
     * @throws DbException
     */
    public function getHotSaleData($date = '',$date2 = ''){
        $date = strtotime($date);
        $date2 = strtotime($date2);
        $where = [
            ['od.status','>',0],
            ["oi.pay_time",['<', $date2], ['>', $date], 'and'],
        ];
        $goodsInfo = Db::name('xgoods g')
            ->field('g.goods_name name,sum(od.goods_num) value')
            ->join("xorder_details od","od.goods_id = g.goods_id")
            ->join("xorder_infos oi","oi.id = od.order_id")
            ->where($where)
            ->group('g.goods_id')
            ->order("value","desc")
            ->limit(30)
            ->select();

        $catInfo = Db::name('xgoods g')
            ->field('cat_name name,sum(od.goods_num) value')
            ->join("xorder_details od","od.goods_id = g.goods_id")
            ->join("xorder_infos oi","oi.id = od.order_id")
            ->join('xcategorys c','c.cat_id = g.cat_id')
            ->where($where)
            ->group('g.cat_id')
            ->order("value","desc")
            ->limit(10)
            ->select();
        $resData = ['goodsInfo' => $goodsInfo, 'catInfo' => $catInfo];
        return $resData;
    }

    /**
     * 获取 24小时销售额数据
     * @param string $date_sel
     * @return array
     * @throws DataNotFoundException
     * @throws ModelNotFoundException
     * @throws DbException
     */
    public function getTimeSaleData($date_sel = ''){

        $time1 = strtotime(date('Y-m-d',strtotime($date_sel)));
        $time2 = strtotime(date('Y-m-d H:i:s',$time1+1*24*60*60));

        $where = [
            ["oi.pay_time",['<', $time2], ['>', $time1], 'and'],
            ['od.status','>',0]];

        $saleInfo = Db::name('xgoods g')
            ->field('sum(od.goods_amount) sale_amount,sum(od.goods_num) sale_num,
            FROM_UNIXTIME(pay_time,"%H") hour')
            ->join("xorder_details od","od.goods_id = g.goods_id")
            ->join("xorder_infos oi","oi.id = od.order_id")
            ->where($where)
            ->group('hour')
            ->select();

        $sale_amount_sum = Db::name('xorder_details od')
            ->join("xorder_infos oi","oi.id = od.order_id")
            ->where($where)
            ->value('sum(goods_amount)');

        $sale_amount_Res = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
        $sale_num_Res = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
        foreach ($sale_amount_Res as $key => $value){
            foreach ($saleInfo as $key2 => $value2){
                $hour = intval($value2['hour']);
                if ($key == $hour){
                    $sale_amount_Res[$key] = $value2['sale_amount'];
                    //echo "hour:".$hour.";key:".$key.";count:".$value2['count']."<br/>";
                    $sale_num_Res[$key] = $value2['sale_num'];
                    break;
                }else{
                    continue;
                }
            }
        }
        $resData = [
            'sale_amount_Res' => $sale_amount_Res,
            'sale_num_Res' => $sale_num_Res,
            'sale_amount_sum' => $sale_amount_sum ? $sale_amount_sum : '0.00',];
        return $resData;
    }
}