<?php

namespace app\cms\controller;

use app\common\controller\CmsBase;
use think\Request;
use think\response\View;

/**
 * 服务器日志
 * Class Admin
 * @package app\cms\Controller
 */
class ServerLog extends CmsBase
{
    protected $log_path ;  //日志目录

    public function __construct()
    {
        parent::__construct();
        $this->log_path = "../runtime/";
    }

    /**
     * 读取服务器日志列表
     * @param Request $request
     * @return View
     */
    public function log_index(Request $request)
    {
        $name = trim(input('name'), '-') ?? '';
        $name_arr = explode('-', $name);
        $file_name = join('/', array_filter($name_arr));
        //1:获取目录 2:获取目录下的文件
        $dir = $this->log_path . $file_name;
        $type = is_dir($dir) == true ? 1 : 2;

        if ($type == 1) { //文件夹
            $data = $this->getDocFile($dir, $type);
            if ($data) {
                $list_data = $this->list_order($data, 'file_name', 'desc');
            } else {
                $list_data = [];
            }
            $view_data = [
                'log_data' => $list_data,
                'type' => $type,
                'name' => $name
            ];
            return view('log_index', $view_data);
        } else {
            //如果这是文件
            if (!$name) {
                $this->error('文件名称不能为空');
            }else{
                $content = $this->getLogContent($dir);
                $view_data = [
                    'log_data' => $content,
                    'name' => $dir . $name
                ];
                return view('log_content', $view_data);
            }
        }
    }


    //对二维数组进行排序
    public function list_order(&$array, $orderKey, $orderType = 'asc', $orderValueType = 'string')
    {
        if (is_array($array)) {
            $orderArr = array();
            foreach ($array as $val) {
                $orderArr[] = $val[$orderKey];
            }
            $orderType = ($orderType == 'asc') ? SORT_ASC : SORT_DESC;
            $orderValueType = ($orderValueType == 'string') ? SORT_STRING : SORT_NUMERIC;
            array_multisort($orderArr, $orderType, $orderValueType, $array);
            return $array;
        }
    }

    /**
     * 获取文件夹名或文件名
     * @param string $dir 文件所在的路径
     * @param int $type 1，文件夹；2，文件
     * @param string $name 需要检索的目录
     * @return array|mixed|null     返回数据集
     */
    private function getDocFile($dir = '', $type = 1, $name = '')
    {
        if (is_dir($dir)) {
            $info = opendir($dir);
            while (($file = readdir($info)) !== false) {
                $list[] = $file;
            }
            closedir($info);
        }
        $lists[] = NULL;
        $handle = opendir($dir);
        if (false != $handle) {
            $lists = $this->pubWhileFile($handle, $dir);
            //关闭句柄
            closedir($handle);
        }
        $lists[0] = $lists[0] ?? null;
        if ($lists[0] == null) {
            $lists = null;
        }
        return $lists;
    }

    /**
     * 在系统目录时，进行while循环的公共函数
     * @param string $handle 句柄
     * @param string $dir 文件夹地址
     * @return mixed    返回文件夹或文件列表
     */
    private function pubWhileFile($handle = '', $dir = '')
    {
        $i = 0;
        $lists = array();
        while (false !== ($file = readdir($handle))) {
            if ($file != "." && $file != "..") {
                $lists[$i]['file_name'] = $file;
                $lists[$i]['file_size'] = $this->getRealSize($this->getDirSize($dir . "/" . $file));
                $i++;
            }
        }
        return $lists;
    }

    /**
     * 获取指定文件夹的大小
     * @param string $dir 文件夹的地址
     * @return int      大小
     */
    function getDirSize($dir = '')
    {
        $sizeResult = 0;
        if (is_dir($dir)) {
            $handle = opendir($dir);
            while (false !== ($FolderOrFile = readdir($handle))) {
                if ($FolderOrFile != "." && $FolderOrFile != "..") {
                    if (is_dir("$dir/$FolderOrFile"))
                        $sizeResult += $this->getDirSize("$dir/$FolderOrFile");
                    else
                        $sizeResult += filesize("$dir/$FolderOrFile");
                }
            }
            closedir($handle);
        } else {
            $sizeResult = filesize($dir);
        }
        return $sizeResult;
    }

    /**
     * 单位自动转换函数
     * @param int $size 需要转换的大小
     * @return string   返回的字符串大小
     */
    private function getRealSize($size = 0)
    {
        $kb = 1024;   // Kilobyte
        $mb = 1024 * $kb; // Megabyte
        $gb = 1024 * $mb; // Gigabyte
        $tb = 1024 * $gb; // Terabyte
        if ($size < $kb) {
            return $size . " B";
        } else if ($size < $mb) {
            return round($size / $kb, 2) . " KB";
        } else if ($size < $gb) {
            return round($size / $mb, 2) . " MB";
        } else if ($size < $tb) {
            return round($size / $gb, 2) . " GB";
        } else {
            return round($size / $tb, 2) . " TB";
        }
    }

    /**
     * 文件略小时，输出文件
     * @param $name
     * @return bool|mixed|string
     */
    private function getLogContent($name)
    {
        $content = '';
        if (is_file($name)) {
            $content = file_get_contents($name);
            $content = str_replace("\n", '<br /><hr><br />', $content);
        }
        return $content;
    }

}
