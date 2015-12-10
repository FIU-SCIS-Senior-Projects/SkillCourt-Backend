<?php 

/**
* 
*/
class CustomRoutine extends Routine
{
	public function __construct($objectId, 
								$command,
								$type,
								$name,
								$description,
								$creator,
								$ParseObject)
	{	
		$this->objectId = $objectId;
		$this->command = $command;
		$this->type = $type;
		$this->name = $name;
		$this->description = $description;
		$this->creator = $creator;
		$this->ParseObject = $ParseObject;
	}
}

 ?>