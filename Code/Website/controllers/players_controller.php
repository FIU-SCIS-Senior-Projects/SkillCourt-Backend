<?php 

/**
* 
*/
class PlayersController
{
	
	public function index()
	{
		$players = Player::returnAll();
		require_once('view/players/index.php');
	}

	public function recruit()
	{
		//Here we get a given Player
		$player = Player::find();
		require_once('view/players/recruit.php');
	}

	public function signed()
	{
		$signed = Player::getSignedPlayers();
		$mySigned = Player::getSignedPlayersByCoach();

		require_once('view/players/signed.php');
	}
	
}

?>