<?php
error_reporting(E_ALL);
ini_set('display_errors', TRUE);
ini_set('display_startup_errors', TRUE);
mysqli_report(MYSQLI_REPORT_ALL);

include_once 'db_connect.php';
include_once 'psl-config.php';
include_once 'functions.php';

sec_session_start();

if (isset($_POST['len'], $_POST['dur'], $_POST['diff'], $_POST['crname'], $_POST['cdesc'])) {
    $length = $_POST['len'];
    $duration = $_POST['dur'];
    $difficulty = $_POST['diff'];
    $name = $_POST['crname'];
    $description = $_POST['cdesc'];

    // Input sanitization
    if (($length > 60) || ($length < 1)) {
	header('Location: ../create.php?error=length');
    } elseif ($duration < 1) {
	header('Location: ../create.php?error=dur');
    } elseif ($name == "") {
	header('Location: ../create.php?error=name');
    } else {
	if (saveRoutine($name, $description, $difficulty, "0", $duration, $length, "C", $mysqli))
	    header('Location: ../routines.php?create=success');
	else
	    header('Location: ../create.php?error=insert');
    }
} elseif (isset($_POST['rnd'], $_POST['diff'], $_POST['crname'], $_POST['cdesc'])) {
    $rounds = $_POST['rnd'];
    $difficulty = $_POST['diff'];
    $name = $_POST['crname'];
    $description = $_POST['cdesc'];

// Input sanitization
    if (($length > 60) ||($length < 1)) {
	header('Location: ./create.php/?error=length');
    } elseif ($name == "") {
	header('Location: ./create.php/?error=name');
    }
} else {
    header('Location: ../create.php?error=idk');
}
