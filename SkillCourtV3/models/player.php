<?php 
//Model

class Player
{
	//We have 7 attributes
	public $firstName;
	public $lastName;
	public $userName;
	public $email;
	public $position;
	public $status;
	public $objectId;
	public $coach;

	public function __construct($firstName,
								$lastName,
								$userName,
								$email,
								$position,
								$status,
								$objectId,
								$coach)
	{
		$this->firstName = $firstName;
		$this->lastName = $lastName;
		$this->userName = $userName;
		$this->email = $email;
		$this->position = $position;
		$this->status = $status;
		$this->objectId = $objectId;
		$this->coach = $coach;
	} 

	public function getCoach()
	{
		return $this->coach;
	}

	public function hasCoach()
	{
		return ($this->getCoach() == "No Coach*") ? false : true;
	}

	public function isCurrentUserTheCoach()
	{
		$currentCoach = PlayersList::getCurrentUser();
		$curCoachUsername = $currentCoach->get('username');

		return ($curCoachUsername == $this->getCoach()) ? true : false;
	}

	public function getFirstName()
	{
		return $this->firstName;
	}

	public function getLastName()
	{
		return $this->lastName;
	}

	public function getUserName()
	{
		return $this->userName;
	}

	public function getEmail()
	{
		return $this->email;
	}

	public function getPosition()
	{
		return $this->position;
	}

	public function getStatus()
	{
		return $this->status;
	}

	public function getId()
	{
		return $this->objectId;
	}


	/** Static Methods
	* These static methods allow to return a collection of players
	*/


	private static function newUser($object, $coach)
	{	
		$statusBool = ($coach == "No Coach*") ? false : true;

		$user = new Player($object->get('firstName'), $object->get('lastName'), $object->get('username'), $object->get('email'), $object->get('position'), $statusBool, $object->getObjectId(), $coach);
		return $user;
	}

	private static function createUser($list)
	{
		$userObject = array();
		for ($i=0; $i < count($list); $i++) { 
			$object = $list[$i];
			$coach = PlayersList::getCoachName($object->get('username'));
			$userObject[$i] = Player::newUser($object, $coach);
		}
		return $userObject;
	}

	public static function returnAll()
	{
		require_once('players_list.php');
		$players = new PlayersList();
		$list = $players->searchPlayer("default","Coach");
		$usuarios = Player::createUser($list);
		return $usuarios;
	}

	public static function find()
	{
		require_once('players_list.php');
		$usuarios = array();
		if(isset($_GET['search_param']) && isset($_GET['x']))
		{
			$search_param = $_GET['search_param'];
			$q = $_GET['x'];
			$fetched = new PlayersList();
			$list = $fetched->searchPlayer($search_param, $q);

			$usuarios = Player::createUser($list);
		}
		return $usuarios;
	}

	public static function getSignedPlayers()
	{
		require_once('players_list.php');
		$fetched = new PlayersList();
		$list = $fetched->getSignedPlayers();
		
		$signedPlayers = Player::createUser($list);
		return $signedPlayers;
	}

	public static function getSignedPlayersByCoach()
	{
		require_once('players_list.php');
		$fetched = new PlayersList();
		$list = $fetched->getSignedPlayersByCoach();
		
		$signedPlayers = Player::createUser($list);
		return $signedPlayers;
	}

	public static function isUserSigned()
	{
		
	}
}