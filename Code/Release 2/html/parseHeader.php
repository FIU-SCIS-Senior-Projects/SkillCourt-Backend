<?php

require 'vendor/autoload.php';

use Parse\ParseClient;
use Parse\ParseUser;
use Parse\ParseSessionStorage;
    
if(!isset($_SESSION))
{
    session_start();
}

ParseClient::initialize('pBeFT0fHxcLjMnxwQaiJpb6Ul5HQqayb96X2UHAF', '5ypPgG2h9m7qm78rANzsKa5eQS7MJSZcoLA5OvZr', 'fMAAA9m2Y7CV7OynAePqsqsKXjocgcSHIT0qoVE4');

?>