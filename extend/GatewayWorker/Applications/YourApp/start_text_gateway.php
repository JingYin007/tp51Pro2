<?php

use \Workerman\Worker;
use \GatewayWorker\Gateway;
use \Workerman\Autoloader;

require_once __DIR__ . '/../../vendor/workerman/workerman/Autoloader.php';
Autoloader::setRootPath(__DIR__);

// 内部推送端口(假设当前服务器内网ip为 192.168.100.100)
// 端口不能与原来 start_gateway.php 中一样
$internal_gateway = new Gateway("Text://0.0.0.0:8227");
$internal_gateway->name = 'internalGateway';

// 不要与原来 start_gateway.php 的一样
// 比原来跨度大一些，比如在原有 startPort 基础上+1000
$internal_gateway->startPort = 3300;

// #### 这里设置成与原 start_gateway.php 一样 ####
$internal_gateway->registerAddress = '127.0.0.1:1238';
// #### 内部推送端口设置完毕 ####

if (!defined('GLOBAL_START')) {
    Worker::runAll();
}