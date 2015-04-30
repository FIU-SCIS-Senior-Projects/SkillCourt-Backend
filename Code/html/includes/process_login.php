<?php
include_once 'db_connect.php';
include_once 'functions.php';

sec_session_start(); // Our custom secure way of starting a PHP session.

if (isset($_POST['un'], $_POST['pw'])) {
    $username = $_POST['un']; // Player's username
    $password = $_POST['pw']; // The non-hashed password.
    $userType = $_POST['ut']; // Coach or Player
    if (login($username, $password, $userType, $mysqli) == true) {
        // Login success
        header('Location: ../Main.php');
    } else {
        // Login failed
        header('Location: ../index.php?error=1');
    }
} else {
    // The correct POST variables were not sent to this page.
    echo 'Invalid Request';
}
