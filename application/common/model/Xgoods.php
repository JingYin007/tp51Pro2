<?php

namespace app\common\model;

use app\common\lib\IAuth;
use app\common\validate\Xgood;

/**
 * Created by PhpStorm.
 * User: moTzxx
 * Date: 2018/1/11
 * Time: 16:45
 */
class Xgoods extends BaseModel
{
    // 设置当前模型对应的完整数据表名称
    protected $autoWriteTimestamp = 'datetime';
    protected $validate;

    public function __construct($data = [])
    {
        parent::__construct($data);
        $this->validate = new Xgood();
    }

    /**
     * 后台获取 商品数据列表
     * @param $curr_page
     * @param int $limit
     * @param null $search
     * @param string $SelStatus
     * @param int $CatType
     * @param string $OrderType
     * @return array
     */
    public function getCmsGoodsForPage($curr_page, $limit = 1, $search = null,
                                       $SelStatus = "Down", $CatType = 0, $OrderType = "D")
    {
        $status = $SelStatus == "Down" ? 0 : 1;
        $where = [["g.status", '=', $status]];
        if ($CatType != 0) {$where[] = ["g.cat_id", '=', $CatType];}
        if ($OrderType == "D") {
            $order["g.updated_at"] = "desc";
        } elseif ($OrderType == "S") {
            $order["g.stock"] = "asc";
        } elseif ($OrderType == "W") {
            $order["g.list_order"] = "asc";
        }else{
            $order["g.recommend"] = "desc";
        }
        if ($search){
            $where[] = ['g.goods_name|b.brand_name', 'like', '%' . $search . '%'];
        }
        $res = $this
            ->alias('g')
            ->field('g.*,cat_name,brand_name')
            ->join('xcategorys cat', 'cat.cat_id = g.cat_id')
            ->join('xbrands b', 'b.id = g.brand_id')
            ->where($where)
            ->order($order)
            ->limit($limit * ($curr_page - 1), $limit)
            ->select();
        foreach ($res as $key => $v) {
            if ($v['status'] == 1) {
                $res[$key]['status_checked'] = "checked";
            } else {
                $res[$key]['status_checked'] = "";
            }
            $res[$key]['thumbnail'] = imgToServerView($v['thumbnail']);
        }
        return isset($res) ? $res->toArray() : [];
    }

    /**
     * 后台获取 商品总数
     * @param null $search
     * @param string $SelStatus
     * @return float|string
     */
    public function getCmsGoodsCount($search = null, $SelStatus = "Down", $CatType = 0)
    {
        $status = $SelStatus == "Down" ? 0 : 1;
        $where = [
            ["g.status", '=', $status]
        ];
        if ($CatType != 0) {$where[] = ["g.cat_id", '=', $CatType];}
        if ($search){
            $where[] = ['g.goods_name|b.brand_name', 'like', '%' . $search . '%'];
        }
        $count = $this
            ->alias('g')
            ->field('g.status')
            ->join('xcategorys cat', 'cat.cat_id = g.cat_id')
            ->join('xbrands b', 'b.id = g.brand_id')
            ->where($where)
            ->count();
        return $count;
    }

    /**
     * 根据商品ID 获取商品内容
     * @param $id
     * @return array
     */
    public function getCmsGoodsByID($id)
    {
        $res = $this
            ->alias('g')
            ->field('g.*,cat.cat_name')
            ->join('xcategorys cat', 'cat.cat_id = g.cat_id')//给你要关联的表取别名,并让两个值关联
            ->where('g.goods_id', $id)
            ->find();
        if ($res){
            $images_str = $res['slide_imgs'];
            if ($images_str){$img_list = explode(',',$images_str);}
            $res['img_list'] = isset($img_list)?$img_list:[];
            //初始化 SKU 数组
            $res['sku_arr'] = (new Xskus())->getSKUDataByGoodsID($id);
            $res['brandList'] = (new Xbrands())->getSelectableList($res['cat_id']);
        }

        return isset($res) ? $res->toArray() : [];
    }

    /**
     * 更新商品内容
     * @param array $input
     * @param int $id
     * @return array
     */
    public function updateCmsGoodsData($input = [],$id = 0)
    {
        $opTag = isset($input['tag']) ? $input['tag'] : 'edit';
        if ($opTag == 'del') {
            $status = $this->where('goods_id', $id)
                ->update(['status' => -1]);
            $validateRes = ['tag' => 1, 'message' => '记录删除成功'];
            insertCmsOpLogs($status,'GOODS',$id,'删除商品');
        } else {
            $saveData = [
                'goods_name' => isset($input['goods_name']) ? $input['goods_name'] : '',
                'list_order' => isset($input['list_order']) ? $input['list_order'] : 0,
                'details' => isset($input['details']) ? $input['details'] : '',
                'thumbnail' => isset($input['thumbnail']) ? $input['thumbnail'] : '',
                'slide_imgs' => isset($input['slide_imgs'])? $input['slide_imgs']:'',
                'sketch' => isset($input['sketch']) ? $input['sketch'] : '',
                'cat_id' => isset($input['cat_id']) ? intval($input['cat_id']) : 1,
                'brand_id' => isset($input['brand_id']) ? intval($input['brand_id']) : 0,
                'market_price' => isset($input['market_price']) ? round($input['market_price'], 2) : 0.00,
                'selling_price' => isset($input['selling_price']) ? round($input['selling_price'], 2) : 0.00,
                'attr_info' => isset($input['attr_info']) ? $input['attr_info'] : '',
                'stock' => isset($input['stock']) ? intval($input['stock']) : 0,
                'status' => isset($input['status']) ? intval($input['status']) : 0,
                'recommend' => isset($input['recommend']) ? 1 : 0,
                'updated_at' => date('Y-m-d H:i:s', time()),
            ];
            $tokenData = ['__token__' => isset($input['__token__']) ? $input['__token__'] : '',];
            $validateRes = $this->validate($this->validate, $saveData, $tokenData);
            if ($validateRes['tag']) {
                $saveTag = $this
                    ->where('goods_id', $id)
                    ->update($saveData);
                $validateRes['tag'] = $saveTag;
                $validateRes['message'] = $saveTag ? '数据修改成功' : '数据无变动';
                if ($saveTag) {
                    //TODO 此时进行 sku库存信息的上传
                    $sku_arr = isset($input['sku_arr']) ? $input['sku_arr'] : [];
                    (new Xskus())->opSKUforGoodsByID($id, $sku_arr);
                }
                insertCmsOpLogs($saveTag,'GOODS',$id,'商品修改成功');
            }
        }
        return $validateRes;
    }

    /**
     * 动态修改商品上下架状态
     * @param int $goods_id
     * @param int $okStatus
     * @return array
     */
    public function updatePutaway($goods_id = 0, $okStatus = 0)
    {
        $goods_id = isset($goods_id) ? intval($goods_id) : 0;
        $saveTag = $this
            ->where('goods_id', $goods_id)
            ->update(['status' => $okStatus, 'updated_at' => date('Y-m-d H:i:s', time())]);
        if (!$saveTag) {
            $message = "状态更改失败";
        }else{
            //0：待上架 1：已上架
            $message = $okStatus ? "商品上架":"商品下架";
            insertCmsOpLogs($saveTag,'GOODS',$goods_id,$message);
        }
        return ['tag' => $saveTag, 'message' => $message];
    }

    /**
     * 进行新商品的添加操作
     * @param $data
     * @return array
     */

    public function addGoods($data)
    {
        $addData = [
            'goods_name' => isset($data['goods_name']) ? $data['goods_name'] : '',
            'list_order' => isset($data['list_order']) ? $data['list_order'] : 0,
            'details' => isset($data['details']) ? $data['details'] : '',
            'thumbnail' => isset($data['thumbnail']) ? $data['thumbnail'] : '',
            'slide_imgs' => isset($input['slide_imgs'])? $input['slide_imgs']:'',
            'sketch' => isset($data['sketch']) ? $data['sketch'] : '',
            'cat_id' => isset($data['cat_id']) ? intval($data['cat_id']) : 1,
            'brand_id' => isset($data['brand_id']) ? intval($data['brand_id']) : 0,
            'market_price' => isset($data['market_price']) ? round($data['market_price'], 2) : 0.00,
            'selling_price' => isset($data['selling_price']) ? round($data['selling_price'], 2) : 0.00,
            'attr_info' => isset($data['attr_info']) ? $data['attr_info'] : '',
            'stock' => isset($data['stock']) ? intval($data['stock']) : 0,
            'status' => isset($data['status']) ? intval($data['status']) : 0,
            'recommend' => isset($data['recommend']) ? 1 : 0,
            'created_at' => date('Y-m-d H:i:s', time()),
            'updated_at' => date('Y-m-d H:i:s', time()),
        ];
        $tokenData = ['__token__' => isset($data['__token__']) ? $data['__token__'] : '',];
        $validateRes = $this->validate($this->validate, $addData, $tokenData);
        if ($validateRes['tag']) {
            $tag = $this->insert($addData);
            $validateRes['tag'] = $tag;
            $validateRes['message'] = $tag ? '数据添加成功' : '数据添加失败';
            if ($tag) {
                $goodsId = $this->getLastInsID();
                //TODO 此时进行 sku库存信息的上传
                $sku_arr = isset($data['sku_arr']) ? $data['sku_arr'] : [];
                (new Xskus())->opSKUforGoodsByID($goodsId, $sku_arr);
                insertCmsOpLogs($tag,'GOODS',$goodsId,'添加商品');
            }
        }
        return $validateRes;
    }

    /**
     * 根据分类获取参加活动的商品
     * @param int $catID
     * @return array
     */
    public function getCatGoodsForActivity($catID = 0)
    {
        $goodsList = $this
            ->field("goods_id,goods_name")
            ->where([['cat_id', '=', $catID], ['status', '>=', '0']])
            ->select();
        return $goodsList ? $goodsList->toArray() : [];
    }

    /**
     * 获取商品售价数据
     * @return array
     */
    public function getGoodsPriceData(){
        $res = $this
            ->alias('g')
            ->field("FLOOR(s.selling_price/100) price,count(g.goods_id) count")
            ->join('xskus s','s.goods_id = g.goods_id')
            ->where([["g.status","=",1],["s.status",'=',0]])
            ->group('price')
            ->order('price','asc')
            ->select();
        $titleArr = [];
        foreach ($res as $key => $value){
            $price = $value['price'];
            if ($price > 0){
                $price_range = $price."00-".intval($price+1)."00(元)";
            }else{
                $price_range = "0-".intval($price+1)."00(元)";
            }
            $res[$key]['name'] = $price_range;
            $res[$key]['value'] = $value['count'];
            $titleArr[] = $price_range;
        }
        return ['opRes'=>$res,'titleArr'=>$titleArr];
    }

}