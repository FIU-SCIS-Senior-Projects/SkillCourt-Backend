<?php 

/**
* 
*/
class PlayersController
{
	
	public function index()
	{
		$players = Player::all();
		require_once('view/players/index.php');
	}

	public function show()
	{
		//Here we get a given Player
		$player = Player::find();
		require_once('view/players/show.php');
	}
	
}

?>