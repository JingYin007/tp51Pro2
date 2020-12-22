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
use PhpOffice\PhpSpreadsheet\Exception;
use think\db\exception\DataNotFoundException;
use think\db\exception\ModelNotFoundException;
use think\exception\DbException;
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

    public function test(){
        echo 'Test 入口';
    }
    /**
     * Excel 文件操作接口
     * @param Request $request
     * @return View|void
     * @throws Exception
     * @throws \PhpOffice\PhpSpreadsheet\Writer\Exception
     */
    public function opExcel(Request $request){
        if ($request->isGet()){
            try {
                $loginList = (new Xmozxx())->getExcelTestData();
                return view('op_excel',['loginList' => $loginList]);
            } catch (DataNotFoundException $e) {
                $message = $e->getMessage();
            } catch (ModelNotFoundException $e) {
                $message = $e->getMessage();
            } catch (DbException $e) {
                $message = $e->getMessage();
            }
            return showMsg(0,$message);
        }else{
            $opTag = $request->post('op_tag','up');

            if ($opTag == 'down'){
                $header = ['商品名称','缩略图','产地','售价','状态'];
                $opData = (new Xmozxx())->getExcelTestData();
                //此时去下载 Excel文件
                (new SpreadsheetService())->outputDataToExcelFile($header,$opData,"哎呦喂-数据表");
            }else{
                $file = $request->file('file');
                $info = $file->move('upload');
                if ($info){
                    //绝对路径，把反斜杠(\)替换成斜杠(/) 因为在 windows下上传路是反斜杠径
                    $file_real_path = str_replace("\\", "/", $info->getRealPath());
                    unset($info); //释放内存,也可使用 $info = null;(写在这里最好，后面总是不执行！！)
                    $opRes = (new Xmozxx())->importExcelData($file_real_path);
                    //TODO 操作完成后，删除文件
                    deleteServerFile($file_real_path);
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

    public function shtml(){
        ob_start();
        var_dump('OO');
        echo 'HAHACWWW';
        echo 'shtml',PHP_EOL;
        echo '<br/>';

        file_put_contents('index.shtml',ob_get_contents());
    }
    /**
     * 模板输出重写方法
     * @access protected
     * @param  boolean $isStatic 是否保存为静态文件
     * @param  string $template 模板文件名
     * @param  array  $vars     模板输出变量
     * @param  array  $replace  模板替换
     * @param  array  $config   模板参数
     * @return mixed
     */
    private function staticFetch($isStatic=false,$template = '', $vars = [], $replace = [], $config = [])
    {
        $HTML = $this->fetch($template, $vars, $replace, $config);//获得页面HTML代码
        if ($isStatic){//判断是否需要保存为静态页
            $thisModule=request()->module();//获取模块
            $thisController=request()->controller();//获取控制器
            $thisAction=request()->action();//获取方法
            $new_file = "{$thisModule}/{$thisController}";
            if(!file_exists($new_file)){
                //检查是否有该文件夹，如果没有就创建，并给予最高权限
                mkdir($new_file, 0777,true);
            }
            $new_file.="/{$thisAction}.".config('default_return_type');
            file_put_contents($new_file,$HTML);//生成静态页
        }
        return $HTML;
    }

}