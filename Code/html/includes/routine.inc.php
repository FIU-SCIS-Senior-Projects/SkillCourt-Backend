<?php
include_once 'db_connect.php';
include_once 'psl-config.php';

if (isset($_POST['rtype'])) {
    $type = $_POST['rtype'];

    if ($type == 'T') {
	$htm = "<h1>Timed Chase Routine</h1>
		<form action='includes/process_create.php' method='POST'>
		    <table>
			<tr><td>How long do you want to play?</td><td><input type='number' id='len' name='len' /></td><td><select id='rt' name='rt' size='2'><option value'r'>Rounds</option><option value='t'>Minutes</option></td></tr>
			<tr><td align='right'>Select difficulty:</td><td><select id='diff' name='diff' size='3'><option value='N'>Novice</option><option value='I'>Intermediate</option><option value='A'>Advanced</option></select>
			<tr><td align='right'>Ground Targetting:</td><td><input type='checkbox' id='ground' name='ground' onclick='groundChange()'></td></tr>
			<tr><td>Add a Name for your Routine:</td><td><input type='text' id='crname' name='crname' /></td></tr>
			<tr><td>Add a quick Descriotion:</td><td><input type='text' id='cdesc' name='cdesc'/> </td></tr>
			<tr><td></td><td><input type='submit' value='Save Routine' /></td>
		    </table>
		</form>";
    } else {
	$htm = "<h1>Rounded Chase Routine</h1>
		<form action='includes/process_create.php' method='POST'>
		    <table>
			<tr><td>How many rounds do you want to play?</td><td><input type='number' id='rnd' /></td><td></td></tr>
			<tr><td align='right'>Select a difficulty:</td><td><select id='diff'><option value='N'>Novice</option><option value='I'>Intermediate</option><option value='A'>Advanced</option></select>
			<tr><td>Add a Name for your Routine:</td><td><input type='text' id='crname' /></td></tr>
			<tr><td>Add a quick Descriotion:</td><td><input type='text' id='cdesc' /> </td></tr>
			<tr><td></td><td><input type='submit' value='Save Routine' /></td>
		    </table>
		</form>";
    }
}

elseif (isset($_POST['type'])) {

    // Get the type of game
    $seltype = $_POST['type'];

    // set value of htm according to selected type
    if ($seltype == "T") {
	$htm = "<h1>Timed Routine</h1>
		<form method='post' onsubmit='saveRoutine(this.form)'>
		    Choose number of steps (10-100): <input type='number' id='steps'> <br>
		    Choose light duration (1-10): <input type='number' id='dur'> <br>
		    Choose speed (1-10): <input type='number' id='spd'><br>
		    <input type='submit' value='Submit'>
		</form>";
    } elseif ($seltype == "C") {
	$htm = "<h1>Chase Routine</h1>  
		<form action='./create.php' method='post'> Would you like to make a 
		   <input type='radio' name='rtype' value='T' onclick='this.form.submit()' /> <b>Time</b> or a
		   <input type='radio' name='rtype' value='S' onclick='this.form.submit()' /> <b>Round</b> Based Routine?
		</form>";
	
/*		<form method='post' onsubmit='saveRoutine(this.form)'>
		    Choose number of steps (10-100): <input type='number' id='steps'> <br>
		    Select difficulty: 
			<select>
			    <option value=''>--
			    <option value='N'>Novice
			    <option value='I'>Intermediate
			    <option value='A'>Advanced
			</select><br>
		    <input type='submit' value='Submit'>
		</form>";
*/  } elseif ($seltype == "S") {
	$htm = "<h1>Sequence Routine</h1>
		<form method='post' onsubmit='saveRoutine(this.form)'>
		    Choose number of steps (10-100): <input type='number' id='steps'><br> 
		    <input type='submit' value='Submit'>
		</form>";
    } else {
	header('Location: ./routines.php');
    }
}
?>
