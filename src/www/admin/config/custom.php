<?php
namespace Paheko;

use Paheko\Users\Categories;
use Paheko\Files\Files;
use Paheko\Entities\Files\File;

require_once __DIR__ . '/_inc.php';

$config = Config::getInstance();

$tpl->display('config/custom.tpl');
