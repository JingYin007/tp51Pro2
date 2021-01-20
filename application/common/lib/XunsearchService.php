<?php


namespace app\common\lib;

/**
 * xunsearch 集成使用类
 * Class XunsearchService
 * @package app\common\lib
 */
class XunsearchService
{
    /**
     * 中文分词搜索
     * @param string $keywords 关键词
     * @param string $file ini文件名
     * @param bool $is_scws 是否开启中文分词（例如：口袋新世代，拆分成：口袋、新、世代）
     * @param int $limit 搜索结果条数
     * @return array 返回结果
     * @throws \XSException
     */
    public static function search($keywords,$file = 'demo',$is_scws = false,$limit = 100){
        $xs = new \XS($file);
        if($is_scws === true) {
            //中文分词
            $tokenizer = new \XSTokenizerScws;
            //词语拆分
            $words = $tokenizer->getTokens($keywords);
            $where = '';
            //拼接成查询条件（OR）
            foreach ($words as $key => $val) {
                if ($key == 0) {
                    $where = $val;
                } else {
                    $where .= ' OR ' . $val;
                }
            }
        }else {
            $where = $keywords;
        }
        $search = $xs->search;

        $result =  $search->setQuery($where)
            ->setSort('spec_name','asc') #按索引排序
            ->setDocOrder(true) #按添加索引排序（升序）
            ->setLimit($limit)
            ->search();
        $search->close();
        return isset($result)?$result:[];
    }

    /**
     *  新增/更新/删除 xunsearch 数据库
     * @param array $data
     * @param string $file ini文件名
     * @param string $tag 'add':新增；'update':更新；'[主键ID]':删除
     * @return bool
     */
    public static function save($data,$file = 'demo',$tag = 'add'){
        try {
            $xs = new \XS($file);
            #创建文档对象
            $doc = new \XSDocument;
            $doc->setFields($data);

            #更新（新增）数据
            $index = $xs->index;
            if ($tag == 'add'){
                $index->add($doc);
            }elseif ($tag == 'update'){
                $index->update($doc);
            }else{
                // 此处，传来的是作为主键的值
                $index->del($tag);
            }
            #强制刷新当前索引列表数据
            return $index->flushIndex();
        }catch (\Exception $e){
            return false;
        }
    }

    /**
     * 此处，补充一下：使用测试示例
     */
    public function testForExample(){

        /*--------------- 增添索引操作--------------------*/
        $sku_ID = 2;
        $spec_name = '【随身音箱】小芦蓝牙音箱';
        $xs_data = [
            'sku_id' => $sku_ID,
            'spec_name' => $spec_name
        ];
        $xsService = new XunsearchService();
        $xsService::save($xs_data,'goods_sku');
        /*---------------END---------------------------*/

        /*---------------查询索引数据--------------------*/
        try {
            $message = $xsService::search('我找原味的瓜子和爆款蓝牙', 'goods_sku', true);
        } catch (\XSException $e) {
            $message = $e->getMessage();
        }
        var_dump($message);
        /*------------------END -----------------------*/
    }
}