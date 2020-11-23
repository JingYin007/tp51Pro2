<?php
/**
 * Created by PhpStorm.
 * User: moTzxx
 * Date: 2019/4/26
 * Time: 10:10
 */

namespace app\cms\controller;


use app\common\controller\CmsBase;
use app\common\model\Xreacts;
use think\Request;

/**
 * 用户管理类
 * Class Users
 * @package app\cms\Controller
 */
class React extends CmsBase
{
    protected $model;

    public function __construct()
    {
        parent::__construct();
        $this->model = new Xreacts();
    }


    public function index(Request $request){

        if ($request->isPost()) {
            return showMsg(1, 'success', []);
        } else {
             $data = [];
            return view('index', $data);
        }
    }


}