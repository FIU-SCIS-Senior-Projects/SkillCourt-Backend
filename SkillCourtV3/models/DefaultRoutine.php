<?php 
class DefaultRoutine extends Routine
{
	public $difficulty;
	public $removedWall;
	public $time;
	public $rounds;
	public $timeperround;
	public $routineType;

	public function __construct($difficulty,
								$removedWall,
								$time,
								$rounds,
								$timeperround,
								$routineType,
								$objectId,
								$command,
								$type,
								$name,
								$description,
								$creator,
								$ParseObject)
	{
		//Parents Attributes
		$this->objectId = $objectId;
		$this->command = $command;
		$this->type = $type;
		$this->name = $name;
		$this->description = $description;
		$this->creator = $creator;
		$this->ParseObject = $ParseObject;

		//Child's class Attributes
		$this->difficulty = $difficulty;
		$this->removedWall = $removedWall;
		$this->time = $time;
		$this->rounds = $rounds;
		$this->timeperround = $timeperround;
		$this->routineType = $routineType;
	}

	public function getDifficulty(){ return $this->difficulty; }

	public function getRemovedWall(){ return $this->removedWall; }

	public function getTime(){ return $this->time; }

	public function getRounds() { return $this->rounds; }

	public function getTimePerRound(){ return $this->timeperround; }

	public function getRoutineType(){ return $this->routineType; }
	
}

 ?>