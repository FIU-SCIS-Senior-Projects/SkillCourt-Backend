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
	public $action;

	public function __construct($firstName,
								$lastName,
								$userName,
								$email,
								$position,
								$status,
								$action)
	{
		$this->firstName = $firstName;
		$this->lastName = $lastName;
		$this->userName = $userName;
		$this->email = $email;
		$this->position = $position;
		$this->status = $status;
		$this->action = $action;
	} 

	public static function all()
	{
		require_once('players_list.php');
		$players = new PlayersList();
		$list = $players->searchPlayer("default","Coach");
		$usuarios = array();
		for ($i=0; $i < count($list); $i++) { 
			$object = $list[$i];
			$usuarios[$i] = new Player($object->get('firstName'), $object->get('lastName'), $object->get('username'), $object->get('email'), $object->get('position'), "Signed", "FREE") ;
		}
		return $usuarios;
	}

	public static function find()
	{
		$usuarios = array();
		require_once('players_list.php');
		if(isset($_GET['search_param']) && isset($_GET['x']))
		{
			$search_param = $_GET['search_param'];
			$q = $_GET['x'];
			$fetched = new PlayersList();
			$list = $fetched->searchPlayer($search_param, $q);

			for ($i=0; $i < count($list); $i++) { 
				$object = $list[$i];
				$usuarios[$i] = new Player($object->get('firstName'), $object->get('lastName'), $object->get('username'), $object->get('email'), $object->get('position'), "Signed", "FREE") ;
			}
		}
		return $usuarios;
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

	public function getAction()
	{
		return $this->action;
	}

}