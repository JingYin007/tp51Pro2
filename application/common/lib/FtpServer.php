<?php
/**
 * Created by PhpStorm.
 * User: moTzxx
 * Date: 2019/8/7
 * Time: 10:30
 */

namespace app\common\lib;


class FtpServer
{
    //FTP 连接资源
    private $link;
    //FTP连接时间
    public $link_time;
    //错误代码
    private $err_code = 0;
    //传送模式{文本模式:FTP_ASCII, 二进制模式:FTP_BINARY}
    public $mode = FTP_BINARY;

    /**
     * 初始化类
     * @param $data
     * @return bool
     */
    public function start($data)
    {
        if(empty($data['PORT'])) $data['PORT'] ='21';
        if(empty($data['PASV'])) $data['PASV'] =false;
        if(empty($data['SSL'])) $data['SSL'] = false;
        if(empty($data['TIME_OUT'])) $data['TIME_OUT'] = 30;
        return $this->connect($data['SERVER'],$data['USER_NAME'],$data['PASSWORD'],$data['PORT'],$data['PASV'],$data['SSL'],$data['TIME_OUT']);
    }

    /**
     * 连接FTP服务器
     * @param string $host     服务器地址
     * @param string $username 用户名
     * @param string $password 密码
     * @param string $port  服务器端口，默认值为21
     * @param bool $pasv    是否开启被动模式
     * @param bool $SSL     是否使用SSL连接
     * @param int $TIME_OUT  超时时间
     * @return bool
     */
    public function connect($host, $username = '', $password = '', $port = '21', $pasv = false, $SSL = false, $TIME_OUT = 30) {
        $start = time();
        if ($SSL) {
            if (!$this->link = @ftp_ssl_connect($host, $port, $TIME_OUT)) {
                $this->err_code = 1;
                return false;
            }
        } else {
            if (!$this->link = @ftp_connect($host, $port, $TIME_OUT)) {
                $this->err_code = 1;
                return false;
            }
        }

        if (@ftp_login($this->link, $username, $password)) {
            if ($pasv)
                ftp_pasv($this->link, true);
            $this->link_time = time() - $start;
            return true;
        } else {
            $this->err_code = 1;
            return false;
        }
        register_shutdown_function(array(&$this, 'close'));
    }

    /**
     * 创建文件夹
     * @param string $dir_name 目录名
     * @return bool
     */
    public function mkdir($dir_name) {
        if (!$this->link) {
            $this->err_code = 2;
            return false;
        }
        $dir_name = $this->ck_dirname($dir_name);
        $now_dir = '/';
        foreach ($dir_name as $v) {
            if ($v && !$this->chdir($now_dir . $v)) {
                if ($now_dir)
                    $this->chdir($now_dir);
                @ftp_mkdir($this->link, $v);
            }
            if ($v)
                $now_dir .= $v . '/';
        }
        return true;
    }

    /**
     * 上传文件
     * @param string $remote   远程存放地址
     * @param string $local    本地存放地址
     * @return bool
     */
    public function put($remote, $local) {
        if (!$this->link) {
            $this->err_code = 2;
            return false;
        }
        $dirname = pathinfo($remote, PATHINFO_DIRNAME);
        if (!$this->chdir($dirname)) {
            $this->mkdir($dirname);
        }
        if (ftp_put($this->link, $remote, $local, $this->mode)) {
            return true;
        } else {
            $this->err_code = 7;
            return false;
        }
    }

    /**
     * 删除文件夹
     * @param string $dir_name  目录地址
     * @param bool $enforce 强制删除
     * @return bool
     */
    public function rmdir($dir_name, $enforce = false) {
        if (!$this->link) {
            $this->err_code = 2;
            return false;
        }
        $list = $this->nlist($dir_name);
        if ($list && $enforce) {
            $this->chdir($dir_name);
            foreach ($list as $v) {
                $this->f_delete($v);
            }
        } elseif ($list && !$enforce) {
            $this->err_code = 3;
            return false;
        }
        @ftp_rmdir($this->link, $dir_name);
        return true;
    }

    /**
     * 删除指定文件
     * @param string $filename 文件名
     * @return bool
     */
    public function f_delete($filename) {
        if (!$this->link) {
            $this->err_code = 2;
            return false;
        }
        if (@ftp_delete($this->link, $filename)) {
            return true;
        } else {
            $this->err_code = 4;
            return false;
        }
    }

    /**
     * 返回给定目录的文件列表
     * @param string $dir_name 目录地址
     * @return array|bool 文件列表数据
     */
    public function nlist($dir_name) {
        if (!$this->link) {
            $this->err_code = 2;
            return false;
        }
        if ($list = @ftp_nlist($this->link, $dir_name)) {
            return $list;
        } else {
            $this->err_code = 5;
            return false;
        }
    }

    /**
     * 在 FTP 服务器上改变当前目录
     * @param string $dir_name 修改服务器上当前目录
     * @return bool
     */
    public function chdir($dir_name) {
        if (!$this->link) {
            $this->err_code = 2;
            return false;
        }
        if (@ftp_chdir($this->link, $dir_name)) {
            return true;
        } else {
            $this->err_code = 6;
            return false;
        }
    }

    /**
     * 获取错误信息
     */
    public function get_error() {
        if (!$this->err_code)
            return false;
        $err_msg = array(
            '1' => 'Server can not connect',
            '2' => 'Not connect to server',
            '3' => 'Can not delete non-empty folder',
            '4' => 'Can not delete file',
            '5' => 'Can not get file list',
            '6' => 'Can not change the current directory on the server',
            '7' => 'Can not upload files'
        );
        return $err_msg[$this->err_code];
    }

    /**
     * 检测目录名
     * @param string $url 目录
     * @return array 由 / 分开的返回数组
     */
    private function ck_dirname($url) {
        $url = str_replace('', '/', $url);
        return explode('/', $url);
    }

    /**
     * 关闭FTP连接
     * @return bool
     */
    public function close() {
        return @ftp_close($this->link);
    }
}