<?php

namespace app\common\model;

use app\common\validate\Xarticle;
use think\Db;
use \think\Model;

/**
 * Created by PhpStorm.
 * User: moTzxx
 * Date: 2018/1/11
 * Time: 16:45
 */
class Xarticles extends BaseModel
{
    // 设置当前模型对应的完整数据表名称
    protected $autoWriteTimestamp = 'datetime';
    protected $validate;

    public function __construct($data = [])
    {
        parent::__construct($data);
        $this->validate = new Xarticle();
    }

    /**
     * 获取所有的文章
     * @return array
     */
    public function getArticleList()
    {
        $res = $this
            ->field("a.*,ap.picture,ap.abstract")
            ->alias('a')//给主表取别名
            ->join('xarticle_points ap', 'ap.article_id = a.id')//给你要关联的表取别名,并让两个值关联
            ->where('a.id', '>', 0)
            ->where('ap.status', 1)
            ->select();
        //$data = array_merge($data,$data,$data,$data,$data,$data,$data);
        return isset($res) ? $res->toArray() : [];
    }

    /**
     * 获取所要推荐的文章
     * @return array
     */
    public function getRecommendList()
    {
        $res = $this
            ->field('a.title,a.id')
            ->alias('a')
            ->join('xarticle_points ap', 'ap.article_id = a.id')
            ->order('ap.view', 'desc')
            ->where('ap.status', 1)
            ->limit(6)
            ->select();
        return isset($res) ? $res->toArray() : [];
    }

    /**
     * 获取所有的文章首页图片
     * @return array
     */
    public function getPhotos()
    {
        $res = Db::name('xphotos')
            ->field('picture')
            ->order("id", "asc")
            ->limit(9)
            ->select();
        return isset($res) ? $res : [];
    }

    /**
     * 根据文章ID 获取文章详情
     * @param $id
     * @return array
     */
    public function getInfoByID($id)
    {
        $res = [];
        if (is_numeric($id)) {
            $res = $this
                ->alias('a')
                ->join('xarticle_points ap', 'ap.article_id = a.id')
                ->field('a.*')
                ->where('a.id = ' . $id)
                ->find();
        }
        return isset($res) ? $res->toArray() : [];
    }

    /**
     * 后台获取文章数据列表
     * @param $curr_page
     * @param int $limit
     * @param null $search
     * @return array
     */
    public function getCmsArticlesForPage($curr_page, $limit = 1, $search = null)
    {
        $res = $this
            ->alias('a')
            ->field('a.id,title,a.updated_at,status,picture,abstract,recommend,a.list_order')
            ->join('xarticle_points ap', 'ap.article_id = a.id')
            ->where("ap.status","<>", -1)
            ->whereLike('a.title', '%' . $search . '%')
            ->order(['a.list_order' => 'desc', 'a.id' => 'desc'])
            ->limit($limit * ($curr_page - 1), $limit)
            ->select();
        foreach ($res as $key => $v) {
            if ($v['status'] == 1) {
                $res[$key]['status_tip'] = "<span class=\"layui-badge layui-bg-blue\">正常</span>";
            } else {
                $res[$key]['status_tip'] = "<span class=\"layui-badge layui-bg-cyan\">隐藏</span>";
            }
            if ($v['recommend'] == 0) {
                $res[$key]['status_checked'] = "";
            } else {
                $res[$key]['status_checked'] = "checked";
            }
            $res[$key]['picture'] = imgToServerView($v['picture']);
        }
        return isset($res)?$res->toArray():[];
    }

    /**
     * 后台获取文章总数
     * @param null $search
     * @return int|string
     */
    public function getCmsArticlesCount($search = null)
    {
        $count = $this
            ->alias('a')
            ->field('a.id,title,a.updated_at,status,picture,abstract')
            ->join('xarticle_points ap', 'ap.article_id = a.id')
            ->where("ap.status","<>", -1)
            ->whereLike('a.title', '%' . $search . '%')
            ->count();
        return $count;
    }

    /**
     * 根据文章ID 获取文章内容
     * @param $id
     * @return array
     */
    public function getCmsArticleByID($id)
    {
        $res = $this
            ->alias('a')
            ->field('a.*,title,status,picture,abstract')
            ->join('xarticle_points ap', 'ap.article_id = a.id')
            ->where('a.id', $id)
            ->find();
        return isset($res) ? $res->toArray() : [];
    }

    /**
     * 更新文章内容
     * @param $input
     * @param int $id
     * @return array
     */
    public function updateCmsArticleData($input,$id = 0)
    {
        $opTag = isset($input['tag']) ? $input['tag'] : 'edit';
        if ($opTag == 'del') {
            Db::name('xarticle_points')
                ->where('article_id', $id)
                ->update(['status' => -1]);
            $validateRes = ['tag' => 1, 'message' => '删除成功'];
            insertCmsOpLogs(1,'ARTICLE',$id,'文章删除操作');
        } else {
            $saveData = [
                'title' => isset($input['title'])?$input['title']:'',
                'list_order' => isset($input['list_order'])?$input['list_order']:0,
                'content' => isset($input['content']) ? ftpImageToServerUE($input['content']) : '',
                'updated_at' => date('Y-m-d H:i:s', time())
            ];
            $tokenData = ['__token__' => isset($input['__token__']) ? $input['__token__'] : '',];
            $validateRes = $this->validate($this->validate, $saveData, $tokenData);
            if ($validateRes['tag']) {
                $saveTag = $this
                    ->where('id', $id)
                    ->update($saveData);
                if ($saveTag) {
                    Db::name('xarticle_points')
                        ->where('article_id', $id)
                        ->update([
                            'picture' => isset($input['picture']) ? $input['picture'] : '',
                            'abstract' => isset($input['abstract'])?$input['abstract']:'',
                            'status' => isset($input['status'])?$input['status']:0,
                        ]);
                    insertCmsOpLogs($saveTag,'ARTICLE',$id,'文章更新');
                }
                $validateRes['tag'] = $saveTag;
                $validateRes['message'] = $saveTag ? '修改成功' : '数据无变动';
            }
        }
        return $validateRes;
    }

    /**
     * 进行新文章的添加操作
     * @param $data
     * @return array
     */

    public function addArticle($data)
    {

        $addData = [
            'title' => isset($data['title'])?$data['title']:'',
            'list_order' => isset($data['list_order'])?$data['list_order']:0,
            'content' => isset($data['content']) ? ftpImageToServerUE($data['content']) : '',
            'user_id' => 1,
            'created_at' => date('Y-m-d H:i:s', time()),
            'updated_at' => date('Y-m-d H:i:s', time())
        ];
        $tokenData = ['__token__' => isset($data['__token__']) ? $data['__token__'] : '',];
        $validateRes = $this->validate($this->validate, $addData, $tokenData);
        if ($validateRes['tag']) {
            $tag = $this->insert($addData);
            if ($tag) {
                Db::name('xarticle_points')
                    ->data([
                        'picture' => isset($data['picture'])?$data['picture']:'',
                        'abstract' => isset($data['abstract'])?$data['abstract']:'',
                        'status' => isset($data['status'])?$data['status']:0,
                        'article_id' => $this->getLastInsID(),
                    ])
                    ->insert();
                insertCmsOpLogs($tag,'ARTICLE',$this->getLastInsID(),'添加文章数据');
            }
            $validateRes['tag'] = $tag;
            $validateRes['message'] = $tag ? '添加成功' : '添加失败';
        }
        return $validateRes;
    }

    /**
     * 更改推荐状态
     * @param int $article_id
     * @param int $okStatus
     * @return array
     */
    public function updateForRecommend($article_id = 0, $okStatus = 0)
    {
        $message = "Success";
        $article_id = isset($article_id) ? intval($article_id) : 0;
        $saveTag = Db::name('xarticle_points')
            ->where('article_id', $article_id)
            ->update(['recommend' => $okStatus]);
        if (!$saveTag) {
            $message = "状态更改失败";
        }else{
            $opMsg = $okStatus?"推荐商品":"取消推荐";
            insertCmsOpLogs($saveTag,'ARTICLE',$article_id,$opMsg);
        }
        return ['tag' => $saveTag, 'message' => $message];
    }
}