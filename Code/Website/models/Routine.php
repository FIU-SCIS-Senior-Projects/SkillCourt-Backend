<?php 
/*
*This general class, will be the parent of Default and Custom Routines
*/
class Routine
{

	//Lets get some attributes for our class of routines
	public $objectId;
	public $command;
	public $type;
	public $name;
	public $description;
	public $creator;
	public $ParseObject;

	/* Getters and setters sections */
	public function getId(){ return $this->objectId; }

	public function getCommand(){ return $this->command; }

	public function getType(){ return $this->type; }

	public function getName(){ return $this->name; }

	public function getDescription(){ return $this->description; }

	public function getCreator(){ return $this->creator; }

	public function getParseObject(){ return $this->ParseObject; }
}


 ?>