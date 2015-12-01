<?php 
//Here we will have a model of the routines by current user.
include_once './inc/parseHeader.php';

use Parse\ParseUser;
use Parse\ParseObject;
use Parse\ParseException;
use Parse\ParseQuery;

class RoutinesList
{
	public function createRoutines()
	{
		$custRoutines = RoutinesList::createDefaultRoutine();
		$defltRoutines = RoutinesList::createCustomRoutine();

		$routines = array();
		$playersAssigned = array();
		foreach ($custRoutines as $custRoutine) {
			array_push($routines, $custRoutine);

		}
		foreach ($defltRoutines as $defltRoutine) {
			array_push($routines, $defltRoutine);
		}
		return $routines;
	}

	public function createDefaultRoutines()
	{
		$defaultObjects = array();
		$defaultPlayers = array();
		$list = RoutinesList::getDefaultRoutines();

		$userQuery = ParseUser::query();

		for ($i=0; $i < count($list); $i++) { 
			$object = $list[$i];
			$defaultPlayers[$object->getObjectId()] = RoutinesList::getRoutinesToDefault($object);
			for ($j=0; $j < count($defaultPlayers[$object->getObjectId()]); $j++) { 
				//Assign username to this user's object id. 
				$objectId = $defaultPlayers[$object->getObjectId()][$j];
				$userQuery->equalTo('objectId', $objectId);
				$results = $userQuery->find();
				if(empty($results)){
					//There are no players assigned to this!
				}else{
					$username = $results[0];
					$defaultPlayers[$object->getObjectId()][$j] = $username;
				}
			}
			$defaultObjects[$i] = RoutinesList::newDefaultRoutine($object);
		}
	
		//Save the players to the session variable players
		$_SESSION['playersDefault'] = $defaultPlayers;

		return $defaultObjects;
	}

	public function getRoutinesToDefault($routinesObject)
	{
		$query = new ParseQuery('AssignedRoutines');
		$query->equalTo('defaultRoutine',$routinesObject);
		$fetch = $query->find();
		$result = RoutinesList::getUserObjectId($fetch);

		return $result;
	}

	private function getUserObjectId($userObject)
	{
		$userObjectId = array();
		foreach ($userObject as $object) {
			array_push($userObjectId, $object->get('user')->getObjectId());
		}
		return $userObjectId;
	}

	public function createCustomRoutines()
	{
		$customObjects = array();
		$customPlayers = array();
		$list = RoutinesList::getCustomRoutines();

		//Query this user's information (Username)
		$userQuery = ParseUser::query();

		for ($i=0; $i < count($list); $i++) { 
			$object = $list[$i];
			$customPlayers[$object->getObjectId()] = RoutinesList::getRoutinesToCustom($object);
			for ($j=0; $j < count($customPlayers[$object->getObjectId()]); $j++) { 
				//Assign username to this user's object id. 
				$objectId = $customPlayers[$object->getObjectId()][$j];
				$userQuery->equalTo('objectId', $objectId);
				$results = $userQuery->find();
				if(empty($results)){
					//There are no users assigned to this routine
				}else{
					$username = $results[0];
					$customPlayers[$object->getObjectId()][$j] = $username;
				}
			}
			$customObjects[$i] = RoutinesList::newCustomRoutine($object);
		}

		$_SESSION['playersCustom'] = $customPlayers;
		return $customObjects;
	}

	public function getRoutinesToCustom($routinesObject)
	{
		$query = new ParseQuery('AssignedRoutines');
		$query->equalTo('customRoutine',$routinesObject);
		$fetch = $query->find();
		$result = RoutinesList::getUserObjectId($fetch);

		return $result;
	}

	public function newDefaultRoutine($object)
	{
		return new DefaultRoutine($object->get('difficulty'),
								  $object->get('removedWall'),
								  $object->get('time'),
								  $object->get('rounds'),
								  $object->get('timePerRound'),
								  $object->get('routineType'),
								  $object->getObjectId(),
								  $object->get('command'),
								  'default',
								  $object->get('name'),
								  $object->get('description'),
								  $object->get('creator'),
								  $object);
	}

	public function newCustomRoutine($object)
	{
		return new CustomRoutine( $object->getObjectId(),
								  $object->get('command'),
								  'custom',
								  $object->get('name'),
								  $object->get('description'),
								  $object->get('creator'),
								  $object);
	}

	//Currently not being used. 
	public function getRoutines()
	{
		//This class when called, it will return all of the routines if any.
		$routines = array();
		$customRoutines = RoutinesList::getCustomRoutines();
		$defaultRoutines = RoutinesList::getDefaultRoutines();
		if(!empty($customRoutines)){
			foreach ($customRoutines as $custRoutine) {
				array_push($routines, $custRoutine);
			}	
		}
		if (!empty($defaultRoutines)) {
			foreach ($defaultRoutines as $defltRoutine) {
				array_push($routines, $defltRoutine);
			}
		}
		return $routines;
	}

	private function getCustomRoutines()
	{
		$currentUserIndex = RoutinesList::getCurrentUser();
		$query = new ParseQuery('CustomRoutine');
		$query->equalTo('creator', $currentUserIndex);
		$customRoutines = $query->find();
		// $_SESSION["coachRoutines"] = $customRoutines;
		return $customRoutines;
	}

	private function getDefaultRoutines()
	{
		$currentUserIndex = RoutinesList::getCurrentUser();
		$query = new ParseQuery('DefaultRoutine');
		$query->equalTo('creator', $currentUserIndex);
		$defaultRoutines = $query->find();
		// $_SESSION["defaultRoutines"] = $defaultRoutines;
		return $defaultRoutines;
	}

	private function getCurrentUser()
	{
		return ParseUser::getCurrentUser();
	}

}

 ?>
