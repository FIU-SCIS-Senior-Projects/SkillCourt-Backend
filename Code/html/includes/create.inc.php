<?php
include_once 'db_connect.php';
include_once 'psl-config.php';

if (isset($_POST['type'])) {
    $type = $_POST['type'];

    if ($type == 'F') {
	$htm = "<h1>Fly Me Routine</h1>
		<form action='includes/process_create.php' method='POST'>
		    <table>
			<tr><td align='right'>How long do you want to play?</td><td><input type='number' id='len' name='len' /></td><td><select id='rt' name='rt'><option value'r'>Rounds</option><option value='t'>Minutes</option></td></tr>
			<tr><td align='right'>Select difficulty:</td><td><select id='diff' name='diff'><option value='N'>Novice</option><option value='I'>Intermediate</option><option value='A'>Advanced</option></select>
			<tr><td align='right'>Ground Targetting:</td><td><input type='checkbox' id='ground' name='ground' onchange='groundChange()'></td></tr>
			<tr><td align='right'>Add a Name for your Routine:</td><td><input type='text' id='crname' name='crname' /></td></tr>
			<tr><td align='right'>Add a quick Descriotion:</td><td><input type='text' id='cdesc' name='cdesc'/> </td></tr>
			<tr><td></td><td><input type='submit' value='Save Routine' /></td></tr>
		    </table>
		</form>";
    } else {
	$htm = "<h1>Chase Me Routine</h1>
		<form action='includes/process_create.php' method='POST'>
		    <table>
			<tr><td align='right'>How many long do you want to play?</td><td><input type='number' id='rnd' /></td><td></td></tr>
			<tr><td align='right'>Select a difficulty:</td><td><select id='diff'><option value='N'>Novice</option><option value='I'>Intermediate</option><option value='A'>Advanced</option></select>
			<tr><td align='right'>Ground Targetting:</td><td><input type='checkbox' id='ground' name='ground' onchange='groundChange()'></td></tr>
			<tr><td align='right'>Add a Name for your Routine:</td><td><input type='text' id='crname' /></td></tr>
			<tr><td align='right'>Add a quick Descriotion:</td><td><input type='text' id='cdesc' /> </td></tr>
			<tr><td></td><td><input type='submit' value='Save Routine' /></td></tr>
		    </table>
		</form>";
    }
}

?>
