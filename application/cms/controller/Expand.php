<?php
/**
 * Created by PhpStorm.
 * User: moTzxx
 * Date: 2019/4/26
 * Time: 10:10
 */

namespace app\cms\controller;


use app\common\controller\CmsBase;
use app\common\lib\SpreadsheetService;
use app\common\model\Xmozxx;
use think\Request;
use think\response\View;

/**
 * 学习拓展类
 * Class Users
 * @package app\cms\Controller
 */
class Expand extends CmsBase
{
    protected $model;

    public function __construct()
    {
        parent::__construct();
        $this->model = new Xmozxx();
    }

    public function test(Request $request){
        //(new SpreadsheetService())->test();
        echo 'Test';
    }



    public function opExcel(Request $request){
        if ($request->isGet()){
            $loginList = (new Xmozxx())->getExcelTestLoginData();
            return view('op_excel',['loginList' => $loginList]);
        }else{
            $opTag = $request->post('op_tag','up');

            if ($opTag == 'down'){
                $opData = (new Xmozxx())->getExcelTestLoginData();
                $header = ['商品名称','缩略图','产地','售价','状态'];

                //此时去下载 Excel文件
                (new SpreadsheetService())->outputDataToExcelFile($header,$opData,"哎呦喂-数据表");
            }else{
                $file = $request->file('file');
                // 移动到框架应用根目录/upload/ 目录下
                $info = $file->move('upload');
                if ($info){
                    //把反斜杠(\)替换成斜杠(/) 因为在 windows下上传路是反斜杠径
                    $file_real_path = str_replace("\\", "/", $info->getRealPath());
                    unset($info);
                    $sheetData = (new SpreadsheetService())->readExcelFileToArray($file_real_path,'C12');
                    var_dump($sheetData);
                    deleteServerFile($file_real_path);
                    $opRes['status'] = 1;
                    $opRes['message'] = "文件导入成功";
                }else{
                    $opRes['status'] = 0;
                    $opRes['message'] = "文件上传失败 ".$file->getError();

                }
                return showMsg($opRes['status'],$opRes['message']);
            }
        }
    }







    /**
     * React 学习页
     *
     * @param Request $request
     * @return View|void
     */
    public function react(Request $request){

        if ($request->isPost()) {
            return showMsg(1, 'success', []);
        } else {
            // 也可展示 react_hook 页面
            return view('react');
        }
    }


}