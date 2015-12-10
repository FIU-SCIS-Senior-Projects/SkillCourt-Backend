<?php 
	//Load required models when needed. 
	spl_autoload_register(function ($class) {
		require_once ('models/' . $class . '.php');
	});


	function call($controller, $action)
	{
		require_once('controllers/' . $controller . '_controller.php');

		switch ($controller) {
			case 'pages':
				$controller = new PagesController();
				break;
			case 'players':
				$controller = new PlayersController();
				break;
			case 'routines':
				$controller = new RoutinesController();
				break;
		}

		$controller-> { $action }();
	}

	//Lets write the possible controllers and actions for the player section
	$controllers = array('pages'   => ['home', 'error', 'routinesHome'],
						 'players' => ['index', 'recruit', 'signed'],
						 'routines'=> ['showRoutines']);

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