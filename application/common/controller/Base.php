<?php
/**
 * Created by PhpStorm.
 * User: moTzxx
 * Date: 2018/1/17
 * Time: 19:02
 */
namespace app\common\controller;

use think\Controller;

class Base extends Controller
{
    /**
     * 初始化处理数据
     * Base constructor.
     */
    public function __construct()
    {
        parent::__construct();
    }

    /**
     * 动态页面静态化处理
     * @access protected
     * @param false $isStatic  是否保存为静态文件
     * @param string $template 模板文件名
     * @param array $vars      模板输出变量
     * @return mixed
     */
    public function staticFetch($isStatic = false,$template = '', $vars = [])
    {
        $dirStart = "shtml";
        //$thisModule=request()->module();//获取模块
        $thisController = request()->controller();//获取控制器
        $thisAction = request()->action();//获取方法
        $para_str = request()->param()? "/".implode("_",request()->param()):"";

        $shtml_dir = $dirStart."/{$thisController}/{$thisAction}";
        $shtml_url = $shtml_dir."/{$para_str}.".config('default_return_type');

        //强制立即转化静态页面
        if ($isStatic){
            $HTML = $this->fetch($template, $vars)->getContent();
            $this->toMakeNewShtmlFile($shtml_dir,$shtml_url,$HTML);
        }else{
            if(is_file($shtml_url) && (time()-filemtime($shtml_url)) < 60){
                //如果没有过时，无需再次生成
                $HTML = file_get_contents($shtml_url);
            }else{
                $HTML = $this->fetch($template, $vars)->getContent();
                $this->toMakeNewShtmlFile($shtml_dir,$shtml_url,$HTML);
            }
        }
        return $HTML;
    }

    /**
     * 静态页面的生成操作
     * @param string $shtml_dir
     * @param string $shtml_url
     * @param string $HTML
     */
    private function toMakeNewShtmlFile($shtml_dir = "",$shtml_url = "",$HTML = ""){
        //判断是否需要保存为静态页
        if(!file_exists($shtml_dir)){
            //检查是否有该文件夹，如果没有就创建，并给予最高权限
            mkdir($shtml_dir, 0777,true);
        }
        file_put_contents($shtml_url,$HTML);//生成静态页
    }
}