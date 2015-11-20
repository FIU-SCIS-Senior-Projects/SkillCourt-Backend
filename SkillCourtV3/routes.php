<?php 

	function call($controller, $action)
	{
		require_once('controllers/' . $controller . '_controller.php');

		switch ($controller) {
			case 'pages':
				$controller = new PagesController();
				break;
			case 'players':
				require_once('models/player.php');
				$controller = new PlayersController();
				break;
		}

		$controller-> { $action }();
	}

	//Lets write the possible controllers and actions for the player section
	$controllers = array('pages'   => ['home', 'error'],
						 'players' => ['index', 'recruit', 'signed']);

	if(array_key_exists($controller, $controllers))
	{
		if(in_array($action, $controllers[$controller]))
		{
			call($controller, $action);
		}else
		{
			call('pages', 'error');
		}
	}else{
		call('pages', 'error');
	}

 ?>