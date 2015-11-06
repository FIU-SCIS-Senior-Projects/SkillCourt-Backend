<?php 

include_once './inc/parseHeader.php';

use Parse\ParseUser;
use Parse\ParseObject;
use Parse\ParseException;
use Parse\ParseQuery;

class PlayersList
{
	public $currentUser;

	public function searchPlayer($filter, $q)
	{

		$currentUser = ParseUser::getCurrentUser();
		$query = ParseUser::query();
		$results;
		//Get all the users that are not coaches
		switch ($filter) {
			case 'firstname':
				$query->equalTo("firstName", $q);
				$results = $query->find();
				break;
			case 'lastname':
				$query->equalTo("lastName", $q);
				$results = $query->find();
				break;
			case 'username':
				$query->equalTo("username", $q);
				$results = $query->find();
				break;
			case 'position':
				$query->equalTo("position", $q);
				$results = $query->find();
				break;
			case 'email':
				$query->equalTo("email", $q);
				$results = $query->find();
				break;
			default:
				//Query for all users whom are not coaches
				$query->notEqualTo("position", $q);
				$results = $query->find();
				break;
		}
		echo "Succesfully retrieved " . count($results);
		return $results;
	}
}

?>
