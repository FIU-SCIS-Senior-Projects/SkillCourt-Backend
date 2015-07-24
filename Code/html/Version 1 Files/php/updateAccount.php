<?php
$hostname_localhost ="localhost";
$database_localhost ="skillcourt";
$username_localhost ="skillcourt";
$password_localhost ="skillcourt";
$localhost = mysql_connect($hostname_localhost,$username_localhost,$password_localhost)
or
trigger_error(mysql_error(),E_USER_ERROR);

mysql_select_db($database_localhost, $localhost);

$firstname = $_POST['firstName'];
$lastName = $_POST['lastName'];
$dateOfBirth = $_POST['dateOfBirth'];
$email = $_POST['email'];
$coachUserName = $_POST['coachUserName'];
$position = $_POST['position'];
$userName = $_POST['userName'];
$password = $_POST['password'];

//echo "Test";
$query_search = "update `skillcourt`.`player` set `fname` = '".$firstname."', lname ='".$lastName."', dbirth ='".$dateOfBirth."',cuname='".$coachUserName."', pos = '".$position."' where puname = '".$userName."'";
$query_exec = mysql_query($query_search) or die(mysql_error());
$rows = mysql_num_rows($query_exec);
//echo $rows;
//echo "Done";
if($rows == 0) { 
 echo "No Such User Found"; 
 }
 else  {
        echo "User Found"; 
}



mysql_close();
?>

