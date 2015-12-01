<?php 
//Here will be the controller for the Routines page 
/**
* 
*/
class RoutinesController
{
	
	public function showRoutines()
	{
		$routinesDefault = RoutinesList::createDefaultRoutines();
		$routinesCustom = RoutinesList::createCustomRoutines();
		require_once('view/routines/routinesList.php');
	}
}
 ?>