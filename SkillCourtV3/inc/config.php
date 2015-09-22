<?php
    // these two constants are used to create root-relative web addresses
    // and absolute server paths throughout all the code
	define("BASE_URL","/");
	define("ROOT_PATH",$_SERVER["DOCUMENT_ROOT"] . "/");
	define('ROOT', __DIR__);
?>