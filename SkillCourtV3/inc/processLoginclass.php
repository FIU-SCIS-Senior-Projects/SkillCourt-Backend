<?php
include_once 'parseHeader.php';

use Parse\ParseUser;
use Parse\ParseObject;
use Parse\ParseException;

class Login
{
	protected $username;
	protected $password;
	protected $currentUser;

	function __construct($userName, $$passWord)
	{
		$this->username = $userName;
		$this->password = $passWord;
		$this->currentUser = "";
		try {
	  		$user = ParseUser::logIn($this->username, $this->password);
	  		$this->currentUser = ParseUser::getCurrentUser();
			// echo $currentUser->getUsername();
			// header('Location: ../index.php');
	  		// Do stuff after successful login.
		} catch (ParseException $error) {
	  		// The login failed. Check error to see why.
	  		echo $error->getCode() . " " . $error->getMessage();
	  		// header('Location: ../index.php?error=1');
		}
	}

	public function getUser()
	{
		return $this->currentUser;
	}

}