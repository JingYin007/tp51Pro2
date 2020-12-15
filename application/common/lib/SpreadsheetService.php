<?php


namespace app\common\lib;

use app\common\model\Xmozxx;
use PhpOffice\PhpSpreadsheet\IOFactory;
use PhpOffice\PhpSpreadsheet\MyReadFilter;
use PhpOffice\PhpSpreadsheet\Spreadsheet;
use PhpOffice\PhpSpreadsheet\Writer\Exception;
use PhpOffice\PhpSpreadsheet\Writer\Xlsx;

/**
 * Spreadsheet 封装整理类
 * phpExcel 的升级开源 PHP库，主要用于 PHP 操作电子表格，数据转化 ...
 * Class SpreadsheetService
 * @package app\common\lib
 */
class SpreadsheetService
{
    protected static $spreadsheet;
    public function __construct()
    {
        //Spreadsheet 载入
        self::$spreadsheet = new Spreadsheet();
    }


    public function test(){
        $this->downLoad();
    }

    /**
     * 将获得的数据，转化为 Excel文件，导出到浏览器
     * @param array $header         头部标题数组
     * @param array $opData         所要导出的数据（二维数组形式），一般为数据库查询所得的一个数组
     *                              注意数据顺序要和 $headerArr 对应！
     *
     * @param string $excelTitle    设置的工作簿标题
     * @param string $saveFileName  保存到桌面的文件名称，例如："moTzxx.xlsx"
     * @param string $colStart      数据从哪一列开始导出，默认为 “A”列
     * @param int $rowStart         数据从第几行开始导出，默认为第一行
     * @throws Exception
     * @throws \PhpOffice\PhpSpreadsheet\Exception
     */
    public function outputDataToExcelFile($header = [],$opData = [],
                                          $excelTitle = "moTzxx",
                                          $saveFileName = "",
                                          $colStart = "A",$rowStart = 1){

        $saveFileName = $saveFileName ? $saveFileName:  date("Ymd",time())."-".time().".xlsx";

        // 获取工作簿
        $work_sheet = self::$spreadsheet->getActiveSheet();
        //设置工作簿标题
        $work_sheet->setTitle($excelTitle);

        //确定表头标题栏的开始位置
        $keyC = ord($colStart);
        foreach ($header as $headName) {
            $colKey = chr($keyC);
            //TODO 设置表格头（即 excel表格的第一行）
            $work_sheet->setCellValue($colKey.$rowStart,$headName);
            $keyC++;
        }
        $work_sheet->fromArray($opData, null, $colStart . intval($rowStart + 1));
        //此处选择将文件下载到 客户端
        self::downloadExcelFileToClient($saveFileName);
    }

    /**
     * 读取 Excel文件，将数据作为数组返回
     * @param string $excel_file_path   文件路径，保证能访问到
     * @param string $rangeStart        读取数据的开始位置，默认为 A1
     * @param int $sheetNo              工作簿标记，默认为 1，即第一个工作表
     * 此处的要求是：
     *          excel文件的后缀名不要手动改动，一般为 xls、xlsx
     *          excel文件中的数据尽量整理的规范
     * @return array
     * @throws \PhpOffice\PhpSpreadsheet\Exception
     * @throws \PhpOffice\PhpSpreadsheet\Reader\Exception
     */
    public function readExcelFileToArray($excel_file_path = "",
                                         $rangeStart = "A1", $sheetNo = 1){
        $inputFileType = self::getInputExcelFileType($excel_file_path);
        $reader = IOFactory::createReader($inputFileType);
        $reader->setReadDataOnly(true);

        $spreadsheet = $reader->load($excel_file_path);
        $work_sheet = $spreadsheet->getSheet(intval($sheetNo-1));// 获取工作簿

        if ($work_sheet){
            # 获取总列数
            $highestColumn = $work_sheet->getHighestColumn();
            # 获取总行数
            $highestRow = $work_sheet->getHighestRow();
            $sheetData = $work_sheet->rangeToArray($rangeStart.":".$highestColumn.$highestRow);
            if (!$sheetData){self::tipError('excel 文件中未查到数据！');}
        }else{self::tipError('excel 文件中没有工作簿！');}

        return isset($sheetData)?$sheetData:[];
    }

    public function goToUpload($excel_file_path){

        $status = 1;
        $message = 'goToUpload';

        $inputFileType = self::getInputExcelFileType($excel_file_path);
        $reader = IOFactory::createReader($inputFileType);
        $spreadsheet = $reader->load($excel_file_path);

        $sheet = $spreadsheet->getActiveSheet();
        if ($sheet){
            # 获取总列数
            $highestColumn = $sheet->getHighestColumn();
            # 获取总行数
            $highestRow = $sheet->getHighestRow();
            # 列数 改为数字显示
            $highestColumnIndex = \PhpOffice\PhpSpreadsheet\Cell\Coordinate::columnIndexFromString($highestColumn);
            for($a = 2;$a<$highestRow;$a++){
                $title = $sheet->getCellByColumnAndRow(1,$a)->getValue();
                $cat_fname = $sheet->getCellByColumnAndRow(2,$a)->getValue();
            }
        }else{
            $message = "文件中没有工作簿！";
        }
        return ['status'=> $status,'message' => $message];
    }

    public function downLoad(){
        // 获取工作簿
        $sheet = self::$spreadsheet->getActiveSheet();
        $sheet->setTitle('moTzxx 学习');
        $sheet->setCellValue('A1','HELLO WORLD!!xx');

        $sheet->setCellValue('A1','ID');
        $sheet->setCellValue('B1','姓名');
        $sheet->setCellValue('C1','年龄');
        $sheet->setCellValue('D1','身高');

        $sheet->setCellValueByColumnAndRow(1, 2, 1);
        $sheet->setCellValueByColumnAndRow(2, 2, "黄蓉\n桃花岛");
        $sheet->setCellValueByColumnAndRow(3, 2, '18岁');
        $sheet->setCellValueByColumnAndRow(4, 2, '168cm');

        $sheet->getStyle('B2')->getFont()->setBold(true)->setName('宋体')->setSize(25);
        $sheet->getStyle('C2')->getFont()->getColor()->setRGB('#FFFF00');
        $sheet->getStyle('B2')->getAlignment()->setWrapText(true);

        // 保存到本地
        //self::saveExcelFileToLocal('hello_worldz.xls');
        self::downloadExcelFileToClient('hahah.xlsx');
        return ['status'=>1,'message'=>'test'];
    }



    /**
     * 将生成的 Excel 文件保存到本地
     * @param string $save_fileUrl 文件保存路径，例如："/mnt/www/hello_world.xlsx"
     * @throws Exception
     */
    public static function saveExcelFileToLocal($save_fileUrl = ""){
        $writer = new Xlsx(self::$spreadsheet);
        //启用 Office2003 兼容性
        $writer->setOffice2003Compatibility(true);
        $writer->save($save_fileUrl);
    }

    /**
     * 将文件下载到 客户端
     * @param string $fileName 文件名 (推荐扩展名为 "xlsx")
     * @throws Exception
     */
    public static function downloadExcelFileToClient($fileName = "muTou.xlsx"){
        $ext_name = (substr($fileName,-3) == 'xls')?"xls":"xlsx";
        if ($ext_name == 'xls'){
            header('Content-Type:application/vnd.ms-excel');
        }else{
            // MIME 协议，文件的类型，不设置，会默认html
            header('Content-Type:application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
        }
        header("Content-Disposition:attachment;filename=$fileName"); // MIME 协议的扩展
        header('Cache-Control:max-age=0'); // 缓存控制
        $writerType = self::getInputExcelFileType($fileName);
        $writer = IOFactory::createWriter(self::$spreadsheet,$writerType);
        $writer->save('php://output');
    }

    /**
     * 获取 excel 文件的类型
     * @param string $fileName
     * @return string
     */
    public static function getInputExcelFileType($fileName = ""){
        if (file_exists($fileName)){
            $ext_name = (substr($fileName,-3) == 'xls')?"xls":"xlsx";
            return ($ext_name == 'xls')?"Xls":"Xlsx";
        }else{
            self::tipError('文件不存在,请排查错误！');
        }
    }

    public static function tipError($message){
        return showMsg(0,$message);
    }

}