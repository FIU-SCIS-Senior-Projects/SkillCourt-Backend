//to run in java
/*String routineCommand = "ca031100000";
String warning ="" ;
boolean isReadyToPlay = true ;
void playTest(){}
void playSuccessSound(){}
void playMissSound(){}
*/

//pad attributes
color lineColor = color(0, 0, 0);
color padOffColor = color(255, 255, 255);
color green = color(53, 232, 44) ;
color red = color(240, 19, 19) ;
color blue = color(91, 134, 214) ;
color orange = color(243, 194, 80);
color yellow = color(252, 211, 7);
color secondYellow = color(242,236,153);
final int padSideLength = 40 ;

//constants wall enum
final int GROUND = 0 ;
final int NORTH  = 1 ; 
final int EAST = 2 ;
final int SOUTH = 3 ;
final int WEST = 4 ;

//constants wall dimensions
final int NS_WIDTH = 6;
final int NS_HEIGHT = 3 ;
final int EW_WIDTH = 3;
final int EW_HEIGHT = 8 ;

//constants routines chars
final String CHASE = "c" ;
final String THREE_WALL_CHASE = "t" ;
final String HOME_CHASE = "g" ;
final String HOME_FLY = "j" ;
final String FLY = "h" ;
final String GROUND_CHASE = "m" ;
final String X_CUE = "x" ;

//constants difficulties chars
final String NOVICE = "n" ;
final String INTERMEDIATE = "i" ;
final String ADVANCED = "a" ;

final int SQUARE_PAD_NUMBER = 4;
final int ROW_PAD_NUMBER = 3;

//doubleClick
int prevX ;
int prevY ;
boolean isFirstClick ;
int firstClickTime;

//for game
Room newRoom ;
boolean isPlaying;
PImage soccerBall ;
Game myGame; 
MasterGame myMasterGame;

double ballMass = 0.45;

//countdown
int startCountdownTime ;

void setup()
{
  size(600, 600) ;  //window size
  //setupImages() ;
  newRoom = new Room() ;

  //testing
  frameRate(10) ;
  isFirstClick = true ; 
  prevX = 0 ;
  prevY = 0 ;
  isPlaying = false ;
  startCountdownTime = 0 ;
}

void draw()
{
    if (isReadyToPlay)                                                        
    { 
      //if (countdown() && !isPlaying)
      if (!isPlaying)
      {
        newRoom = new Room() ;
        
        if (!customCoachRoutine)
        {
          if (routineCommand.length() != 11)
          { 
            background(0,0,0,90); 
            textSize(32) ;
            fill(255) ;
            text("Make sure all options are filled out", 30, 30, 540, 540);
          } else {
            myMasterGame = new MasterGame(newRoom,routineCommand);
            isPlaying = true ;
          }
        } else {
            myMasterGame = new MasterGame(newRoom,customRoutineCommand);
            isPlaying = true ;
        }
      } 
      else if(isPlaying)
      {  
        setupDisplay() ;   
        //newRoom.drawRoom();  
        if (!myMasterGame.areGamesOver()) newRoom.drawRoom();
        else 
        {
          isReadyToPlay = false ;
          isPlaying = false ;
          newRoom = new Room() ;
          routineCommand = "" ; 
          warning ="" ;
        }
      }
    } 
    else
    {
      background(0,0,0,90); 
      fill(255) ;
      textSize(32) ;
      text("Click the Play button to start the chosen routine", 30, 200, 540, 540) ;
      fill(red) ;
      text(warning, 30, 30, 540, 540);
    }
  
}

void reset()
{
  isReadyToPlay = false; 
  newRoom = new Room() ;
  isPlaying = false ;
  startCountdownTime = 0 ;
}

void mousePressed()
{ 
  if (myMasterGame != null && myMasterGame.didGamesStarted())
  {
     if (isFirstClick || !(mouseX == prevX && mouseY == prevY))
    {
      prevX = mouseX ;
      prevY = mouseY ;
      isFirstClick = false ;
      //println("mouse Pressed: Calling handleSingleClick");
      myMasterGame.handleSingleClick(mouseX, mouseY) ;
      firstClickTime = millis() ;
    } else  //second click
    {
      //sprintln("mouse Pressed: Calling handleDoubleClick");
      myMasterGame.handleDoubleClick(mouseX, mouseY , millis() - firstClickTime) ;
      isFirstClick = true ;
    }
  }
  
  /*if (myGame.isGameStarted())
  {
    if (isFirstClick || !(mouseX == prevX && mouseY == prevY))
    {
      prevX = mouseX ;
      prevY = mouseY ;
      isFirstClick = false ;
      println("mouse Pressed: Calling handleSingleClick");
      myGame.handleSingleClick(mouseX, mouseY) ;
      firstClickTime = millis() ;
    } else  //second click
    {
      println("mouse Pressed: Calling handleDoubleClick");
      myGame.handleDoubleClick(mouseX, mouseY , millis() - firstClickTime) ;
      isFirstClick = true ;
    }
  }*/
}

void setupImages() 
{
  soccerBall = loadImage("soccerBall.png") ;
  cursor(soccerBall, 18, 18) ;
}

void setupDisplay() 
{
  background(0,0,0,90);   //window bg color
  fill(0, 0, 0) ;  //next will be filled with black
  textSize(32) ;
}

boolean countdown()
{
  if(startCountdownTime == 0) startCountdownTime = millis() ;
  background(0,0,0,90); 
  int deltaTime = millis()-startCountdownTime ;
  
  if(deltaTime > 3000)  return true ;
  else if(deltaTime > 2000) printOnGround(1) ;
  else if(deltaTime > 1000) printOnGround(2) ;
  else if(deltaTime > 0) printOnGround(3) ;  
  
  newRoom.drawRoom() ;
  return false ;
}

void printOnGround(int n)
{
  int groundWidth = NS_WIDTH - 2;
  int groundHeight = EW_HEIGHT - 2;
  newRoom.lightWall(GROUND,padOffColor) ;
  if(n==1)
  {
    int nWidth = groundWidth / 2;
    
    for(int c = 1 ; c < groundHeight ; c++)
      for(int r = groundWidth/4 ; r < groundWidth/4 + nWidth ; r++)
        newRoom.getPadRC(GROUND, r , c).setColor(blue) ;   
  }
  else if(n==2)
  {
    for(int c = 1 ; c < groundHeight ; c++)
      for(int r = 0 ; r < groundWidth ; r++)
      {
        if(c==2) r=groundWidth-1 ;
        newRoom.getPadRC(GROUND, r , c).setColor(blue) ;
        if(c==4) r=groundWidth ;
      }
  }
  else if(n==3)
  {
    for(int c = 1 ; c < groundHeight ; c++)
      for(int r = 0 ; r < groundWidth ; r++)
      {
        if(c==2||c==4) r=groundWidth-1 ;
        newRoom.getPadRC(GROUND, r , c).setColor(blue) ;
      }
  }
}

// MISSING ABILITY TO PLAY ONE GAME OVER THE OTHER

class MasterGame
{
    ArrayList games;
    boolean didTheGamesStarted;
    String command;
    GameInterface currentGame;
    int currentGameNumber;
    Room myRoom;
    
    MasterGame(Room r, String c)
    {
      //println("Master Game Constructor");
      currentGameNumber = 0;
      didTheGamesStarted = true;
      myRoom = r; 
      games = new ArrayList();
      command = c;
      parseString(command);
      startGames();
    }
    
    void startGames()
    {
      currentGame = games.get(currentGameNumber);
      currentGame.createRoutine();
      currentGame.startRoutine();
    }
    
    void handleSingleClick(int x, int y)
    {
      if (currentGame != null) currentGame.handleSingleClick(x,y);
      else 
        println("Current game is null");
    }
    
    void handleDoubleClick(int x, int y, int deltaClickTime)
    {
      if (currentGame != null) currentGame.handleDoubleClick(x,y,deltaClickTime);
      else 
        println("Current game is null");
    }
    
    boolean didGamesStarted(){
      return  didTheGamesStarted;
    }
    
    boolean areGamesOver(){
      
      if (currentGame.checkStatus())
      {
        println("areGamesOver called: Check Status returned true");
        currentGameNumber++;
        if (games.size() == currentGameNumber) {
          println("games.size(): " +games.size());
          println("currentGameNumber: "+currentGameNumber);
          return true;
        } else {
          startGames();
        }
        
      }
      return false;
    }
    
    int findNextRoutineIndex(String comm, int i)
    {
      for (int j = i; j< comm.length() ; j++)
      {
        String ch = comm.substring(j,j+1);
         switch (ch)
         {
           case GROUND_CHASE:
          
           case THREE_WALL_CHASE:
          
           case X_CUE:
          
           case CHASE:
          
           case HOME_CHASE:
          
           case FLY:
          
           case HOME_FLY:
          
           case "U": return j;
            
         }
      }
      
      return comm.length();
    }
    
    void parseString(String comm)
    {
      int i = 0;
      
      println(comm.substring(i,i+1));
      
      while (i<comm.length())
      {
        
       switch (comm.substring(i,i+1))
       {
         case GROUND_CHASE:
          
         case THREE_WALL_CHASE:
        
         case X_CUE:
        
         case CHASE:
        
         case HOME_CHASE:
        
         case FLY:
        
         case HOME_FLY:
         
         Game newGame = new Game(myRoom,comm.substring(i,i+11));
         games.add(newGame);
         i=i+11;
         break;
        
         case "U": 
         int end = findNextRoutineIndex(comm,i+1);
         CustomGame newCustomGame = new CustomGame(myRoom,comm.substring(i,end));
         games.add(newCustomGame);
         i=end;
         break;
       }
       
      }
      
      println("# of games: " + games.size() );
    }
   
    
    Game handleExistingRoutine(String type){
      
      String existingRoutineCommand;
      Game newGame = null;
      
      if (type.equals(THREE_WALL_CHASE)) existingRoutineCommand = "tn010100000";
      else if (type.equals(HOME_CHASE)) existingRoutineCommand = "gn010100000";
      else if (type.equals(HOME_FLY)) existingRoutineCommand = "jn010100000";
      else if (type.equals(GROUND_CHASE)) existingRoutineCommand = "mn010100000";
      else if (type.equals(X_CUE)) existingRoutineCommand = "xn010100000";
      else return newGame;
      
      Game newGame = new Game(myRoom,existingRoutineCommand);
      
      return newGame;
    }
    
    
}

interface GameInterface
{
  
   void handleSingleClick(int x, int y);
   void handleDoubleClick(int x, int y, int deltaClickTime);
   void createRoutine();
   boolean checkStatus();
   void startRoutine();
}

class CustomGame implements GameInterface
{
  
  Room myRoom;
  boolean isThisGameOver;
  boolean isThisGameStarted;
  String command;
  Routine myCustomRoutine;
  int rounds;
  int roundsPlayed;
  
  CustomGame(Room r, String c)
  {
    println("Starting custom game");
    myRoom = r;
    command = c;
    roundsPlayed = 0;
    createRoutine();
  }
  
  void startRoutine(){
    println("start Routine custom game");
    myCustomRoutine.startRoutine(); 
  }
  
  boolean isGameStarted() { 
    return isThisGameStarted;
  }
  boolean isGameOver() { 
    return checkStatus();
  }
  
  boolean checkStatus() {
    
    if (rounds == roundsPlayed){
      println("Game Finished: Check Status Called");
      return true;
    }
    else
      return false;
  }
  
  void handleSingleClick(int x, int y)
  {
    //println("handle single click in Custom Game"); 
    if ( myCustomRoutine.handleInput(x, y, 1, 0) )
    { 
      println("Single clickkkkkkk");
      roundsPlayed++;
      println("roundsPlayed: "+roundsPlayed+" rounds: "+rounds);
    }
  }
  
  void handleDoubleClick(int x, int y, int deltaClickTime)
  {
    //println("handle double click in Custom Game"); 
    if ( myCustomRoutine.handleInput(x, y, 2, deltaClickTime) )
    { 
      //println("Double clickkkkkkk");
      roundsPlayed++;
      println("roundsPlayed: "+roundsPlayed+" rounds: "+rounds);
    }
  }
  
  void createRoutine()
  {
    // Start playing custom routine
    rounds = int(command.substring(1, 3));
    //println("Rounds: " +rounds+" RoundsPlayed: "+roundsPlayed);
    //println("Rounds: "+rounds);
    myCustomRoutine = new CustomRoutine(myRoom, command);
  }
  
}

class Round
{
  ArrayList steps;
  
  Round()
  {
    steps = new ArrayList(); 
  }
  
  int getTotalNumberOfSteps()
  {
    return steps.size(); 
  }
  
  void addStep(Step s)
  {
     steps.add(s);
  }
  
  Step getStep(int stepNumber)
  {
    return (Step)(steps.get(stepNumber));
  }
}

class Step
{
  ArrayList targets;
  String stepType;
  
  Step(ArrayList t, String s)
  {
    stepType = s;
    targets = t;
  }
  
  String getStepStype(){ return stepType;}
  
  void addTarget(Target t) { targets.add(t) };
  
}

class Target
{
  ArrayList pads;
  
  Target()
  {
    pads = new ArrayList();
  }
  
  void addPadToTarget(Pad newPad)
  {
    pads.add(newPad);
  }
  
}

class CustomRoutine extends Routine
{ 
  ArrayList roundsArray;
  ArrayList padsToLight;
  String command;
  Round currentRound;
  int numberOfRounds;
  int currentRoundNumber;
  int currentStepNumber;
  int currentCommandPosition;
  int targetsClickedInStep;
  
  CustomRoutine(Room r, String c)
  {
    super.startRoutine();
    myRoom = r;
    command = c;
    targetsClickedInStep = 0;
    roundsArray = new ArrayList();
    padsToLight = new ArrayList();
    currentRoundNumber = 0;
    currentCommandPosition = 3;
    currentStepNumber = 0;
    numberOfRounds = int(command.substring(1,3));
    storeCommand();
    //println("After storeCommand");
    //generateStep();
  }
  
  void startRoutine(){
    println("start Routine Custom routine");
    generateStep();  
  }

  void generateStep(){
    
    super.generateStep(); 
    println("Generate Step Custom Routine");
    currentRound = roundsArray.get(currentRoundNumber);
    
    if (currentRound.getTotalNumberOfSteps() == currentStepNumber)
    {
      clearPads();
      println("ROUND IS OVER");
      currentStepNumber = 0;
      currentRoundNumber++;
      generateStep();
     // Round is over
    }else{
      // Round is not over, keep feeding steps 
      
      ArrayList s = currentRound.steps;
      //println("Number of steps: " +s.size());
      Step currStep = s.get(currentStepNumber);
      ArrayList tArray = currStep.targets;
      //println("Round #:"+ currentRoundNumber+" Step #: "+currentStepNumber+" # of Targets: "+currStep.targets.size());
     
      String x = currStep.getStepStype();
      
      if (x.equals("N"))
      {
        if (targetsClickedInStep == 0)
        {
          for (int i = 0; i<tArray.size() ; i++)
          {
            Target newTarget = tArray.get(i);
            //println("Target Number: "+i);
            for (int j = 0; j<newTarget.pads.size(); j++)
            {
              Pad currPad = newTarget.pads.get(j);
              currPad.setColor(green); 
            }
          }
        } 
        
      } else if (currStep.stepType.equals("G"))
      {
        //println("Ground");
        //println("# of Targets: " +tArray.size());
        for (int i = 0; i<tArray.size() ; i++)
        {
          Target newTarget = tArray.get(i);
          //println("Target Number: "+i);
          for (int j = 0; j<newTarget.pads.size(); j++)
          {
            Pad currPad = newTarget.pads.get(j);
            currPad.setColor(yellow); 
          }
        }
      }
   
    }
  }
  
  boolean handleInput(int x, int y,int clickNum, int deltaClickTime) 
  {
    super.handleInput(x, y, clickNum, deltaClickTime) ;
    ArrayList s = currentRound.steps;
    Step currStep = s.get(currentStepNumber);
    ArrayList tArray = currStep.targets;
    String type = currStep.getStepStype();
    Target targetToLight;
    
    println(type);
    
    if ((clickNum == 2) && (type.equals("N")) )
    {
        if (myRoom.colorOfClick(x,y) == green)
        { 
            targetsClickedInStep++;
            
            if (targetsClickedInStep >= tArray.size()){
              targetsClickedInStep++;
              println("Step"+currentStepNumber+" In Round"+currentRoundNumber+" is finished");
              currentStepNumber++;
              targetsClickedInStep = 0;
              
              if (currentRound.getTotalNumberOfSteps() == currentStepNumber)
              {
                clearPads();
                println("rounds is NOW over");
                currentStepNumber = 0;
                currentRoundNumber++;
                if (numberOfRounds == currentRoundNumber) return true;
                generateStep();
                return true;
              }
              
            }
            
            for (int i = 0; i<tArray.size() ; i++)
            {
              Target newTarget = tArray.get(i);
              for (int j = 0; j<newTarget.pads.size(); j++)
              {
                Pad clickedPad = myRoom.getPad(x,y);
                Pad currPad = newTarget.pads.get(j);
                if (clickedPad == currPad) {
                  //println("The clicked pad exists as a target");
                  targetToLight = newTarget;
                }
              }
            }
            
            if (targetToLight != null) {
              //println("The clicked pad exists as a target");
              lightTarget(targetToLight);
            }
            
            //if (type.equals("G")) clearPads();
            
            generateStep();
            
          //return true;
        }
    } else if ((clickNum == 1) && (type.equals("G"))) {
      println("One click ground step");
       if (myRoom.colorOfClick(x,y) == yellow)
       {
          
          targetsClickedInStep++;
            
          if (targetsClickedInStep >= tArray.size()){
            targetsClickedInStep++;
            println("Step"+currentStepNumber+" In Round"+currentRoundNumber+" is finished");
            currentStepNumber++;
            targetsClickedInStep = 0;
            
            if (currentRound.getTotalNumberOfSteps() == currentStepNumber)
            {
              clearPads();
              println("rounds is NOW over");
              currentStepNumber = 0;
              currentRoundNumber++;
              if (numberOfRounds == currentRoundNumber) return true;
              generateStep();
              return true;
            }
            
          }
         
         Target newTarget = tArray.get(0);
         Pad clickedPad = myRoom.getPad(x,y);
         
          for (int j = 0; j<newTarget.pads.size(); j++)
          {
            Pad clickedPad = myRoom.getPad(x,y);
            Pad currPad = newTarget.pads.get(j);
            if (clickedPad == currPad) {
              //println("The clicked pad exists as a target");
              targetToLight = newTarget;
            }
          }
         
         println("erase");
         if (type.equals("G")) clearPads();
         
         generateStep();
       }
    }
    
    return false; 
  }
  
  void clearPads()
  {
    for (int i = 0; i<5;i++)
      myRoom.lightWall(i,padOffColor);
  }
  
  void lightTarget(Target t)
  {
    for (int i = 0; i < t.pads.size() ; i++)
    {
      println("Light Target");
      Pad currPad = t.pads.get(i);
      currPad.setColor(blue);
    }
  }
  
  void storeCommand()
  {
    int numberOfStepsPerRound;
    Round newRound;
    String curr;
    ArrayList pads = new ArrayList();
    ArrayList targets = new ArrayList();
    Target newTarget;
    println("StoreCommand");
    curr = str(command.charAt(currentCommandPosition));
    
    while (currentCommandPosition < command.length())
    {
       if (curr.equals("R"))
       {
         newRound = new Round();
         roundsArray.add(newRound);
         currentCommandPosition++;
       } 
       else if (curr.equals("_"))
       {
         numberOfStepsPerRound = curr.substring(currentCommandPosition+1,currentCommandPosition+3);
         currentCommandPosition+=3;
       } 
       else if (curr.equals("*")) 
       {
         println("New Target");
         if (newTarget != null) targets.add(newTarget);
         //targets.add(newTarget);
         newTarget = new Target();
         currentCommandPosition++;
       }
       else if (curr.equals("S")) 
       {
         // Remember to add newTarget to targetArray
         targets.add(newTarget);
         
         String stepType = str(command.charAt(currentCommandPosition+1));
         Step newStep = new Step(targets,stepType);
         newRound.addStep(newStep);
         targets = null;
         targets = new ArrayList();
         newTarget = null;
         //println("step.targets after removal: "+newStep.targets.size());
         currentCommandPosition+=2;
       }
       else 
       {
         int wallID = int(command.charAt(currentCommandPosition));
         int row = int(command.charAt(currentCommandPosition+1));
         int column = int(command.charAt(currentCommandPosition+2));
         println(wallID+" "+row+" "+column);
         Pad newPad = myRoom.getPadRC(wallID,row,column);
         newTarget.addPadToTarget(newPad);
         currentCommandPosition+=3;
       }
       curr = str(command.charAt(currentCommandPosition));
    }
  
  }
  
}

class Game implements GameInterface
{
  boolean isThisGameOver ;
  boolean isThisGameStarted ;
  boolean coachFeedback;
  int gameTime;
  int startTime ;
  int routineTimeStart;
  int routineTime ;
  int rounds ;
  int roundsPlayed;
  String command;
  
  Routine myRoutine ;
  Room myRoom;
  boolean isRoutineGroundBased ;

  Game(Room r, String c)
  {
    isThisGameOver = false;
    isThisGameStarted = true;
    myRoom = r;
    command = c;
    rounds = -1; 
    roundsPlayed = 0;
    gameTime = 0;
    routineTime = 0;
    routineTimeStart = 0;
    //createRoutine(command);
    coachFeedback = false;
    //playTest();
  }

  void startRoutine(){
    myRoutine.startRoutine(); 
  }

  // Method that breaks the command and creates a routine
  void createRoutine()
  {  
    String type = str(command.charAt(0));
    String difficulty = str(command.charAt(1));
    
    rounds = int(command.substring(2, 4));
    
    int missingWall = ( (command.substring(4,5).equals("1")) ? 1 : -1 ) * int(command.substring(5,6)) ;

    if(missingWall > 0) myRoom.removeWall(missingWall) ;
    
    gameTime = int(command.substring(6, 9)) *60000;
    int timeBased = int(command.substring(9, 11));
    // Check if the game is timeBased or roundBased  
    if (rounds == 0) rounds = -1;
    text(rounds-roundsPlayed, 100, 100);
    routineTime = timeBased*1000;
    
    if (routineTime > 0) routineTimeStart = millis();
   
    startTime = millis() ;
    isRoutineGroundBased = false; 
    if (type.equals(CHASE)) {
      myRoutine = new ChaseRoutine(myRoom, difficulty, missingWall);
      //myRoutine.startRoutine();
    }
    else if (type.equals(THREE_WALL_CHASE)){
      myRoutine = new ThreeWallChaseRoutine(myRoom, difficulty, missingWall);
    }
    else if (type.equals(HOME_CHASE))
    {
      myRoutine = new HomeChaseRoutine(myRoom, difficulty, missingWall);
      isRoutineGroundBased = true;
    } else if (type.equals(FLY))  myRoutine = new FlyRoutine(myRoom, difficulty, missingWall); 
    else if (type.equals(HOME_FLY)) 
    {
      myRoutine = new HomeFlyRoutine(myRoom, difficulty, missingWall);
      isRoutineGroundBased = true ;
    }
    else if (type.equals(GROUND_CHASE))
    {
      myRoutine = new GroundChaseRoutine(myRoom, difficulty, missingWall); 
      isRoutineGroundBased = true ; 
    }else if (type.equals(X_CUE))
    {
      myRoutine = new xCueRoutine(myRoom, difficulty, missingWall);  
      isRoutineGroundBased = true ;
    } else {
       println("Empty Routine command: Custom Coach routine");
    }
  }

  boolean isGameStarted() { 
    return isThisGameStarted;
  }
  boolean isGameOver() { 
    return checkStatus();
  }
  
  boolean isGameGroundBased() { 
    return isRoutineGroundBased ;
  }

void handleDoubleClick(int x, int y, int deltaClickTime) 
{ 
  if ( myRoutine.handleInput(x, y, 2, deltaClickTime) )
  { 
    fill(0, 0, 0);
    //text(rounds, 0, 150);
    //rounds--;
    roundsPlayed++;
    println("Rounds Played: " +roundsPlayed);  
  }
  
}

void handleSingleClick(int x, int y)
{
  //if (isRoutineGroundBased) myRoutine.handleInput(x, y, 1) ;
  
  if ( (isRoutineGroundBased) && (myRoutine.handleInput(x, y, 1, 0)) )
  { 
    fill(0, 0, 0);
    //text(rounds, 0, 150);
    //rounds--;
    roundsPlayed++;
    // If you succesfully generatedStep then startTime = millis()
    if (routineTime > 0) startTime = millis();
  }
  
}

void postGame() {}

boolean checkStatus()
{
  
  if (roundsPlayed == rounds)
  { 
    fill(0, 0, 0);
    isThisGameOver = true ;
    //text("Round Game is Over", 0, 150);
    return true;
  }
  
  if (roundsPlayed == (rounds/2))
  {
    if (!coachFeedback){
       if (javascript != null) playTest();
       else println("Javascript is null"); 
       coachFeedback = true;
    } 
  }

  // gameTime > 0 if the game is timeBased
  if (gameTime > 0)
  {
    fill(255);
    int timer = int((startTime+gameTime - millis())/1000) ;
    int sec = int(timer % 60)  ;
    int min = int(timer / 60) ;
    String timerOutput = (sec < 10) ? min + ":0" + sec :  min + ":" + sec ;
    text("Time Left " + timerOutput, 10, 10, 160, 160);
   
    //println("startTime: " + (millis() - startTime));
    
    if ( (millis()-startTime) >= (gameTime/2) ) 
    {
      if (!coachFeedback)
      {
        if (javascript != null) playTest();
        else println("Javascript is null"); 
        coachFeedback = true;
      }
      //println("You are half WAY!!!");      
      //text("You are half WAY!!!", 0, 400);
    }

   // Calculating game time in minutes
    if ((millis() - startTime) > gameTime) 
    { 
      fill(255);
      isThisGameOver = true ;
      //text("Time Game is Over", 0, 150);
      return true;
    }
  }
  else
  {
    if (rounds != -1)
      fill(255);
      text("Rounds Left " + (rounds-roundsPlayed), 10, 10, 160, 160);
  }
  
  // routineTime > 0 if game is timeRound based
  if (routineTime > 0)
  {
    if ( ((millis() - routineTimeStart)) > routineTime )
    {
      //println("Sorry! took too long");
      fill(0, 0, 0);
      //text("Sorry! took too long", 0, 150);
      routineTimeStart = millis();
      //println("Before Timeout");
      myRoutine.timeout();
      roundsPlayed++;
      myRoutine.groundPadPressed = false;
      myRoutine.generateStep();
      return false;
    }
  }
  
  return false;
}

  void startGame() 
  {
    isThisGameStarted = true;
    isThisGameOver = false;
  }
}

class ThreeWallChaseCustomRoutine extends Routine
{
  String command;
  String padCommand;
  int currentPosition;
  int currentWallID;
  int prevWallID;
  ArrayList firstWall;
  ArrayList secondWall;
  ArrayList thirdWall;
  ArrayList padsToLight;

  ThreeWallChaseCustomRoutine(Room r, String d, int m, String c)
  {
    myRoom = r;
    difficulty = d;
    missingWall = m;
    command = c;
    padCommand = command.substring(11,command.length());
    println(padCommand);
    currentPosition = 0;
    firstWall = new ArrayList() ;
    secondWall = new ArrayList() ;
    thirdWall = new ArrayList() ;
    padsToLight = new ArrayList() ; 
    myStats = new Stats() ;
    generateStep();
  }
  
  void generateStep()
  {
    super.generateStep();
    clearLitPads();
    initializeRedPads();
    println("Generate step"); 
    println("CurrentPosition: " + currentPosition + " -> "+ padCommand.length());
    if (currentPosition < padCommand.length()){
      
      currentWallID = int(padCommand.charAt(currentPosition));
      prevWallID = currentWallID;
      
      while (currentWallID == prevWallID){
        int wallID = int(padCommand.charAt(currentPosition));
        int row = int(padCommand.charAt(currentPosition+1));
        int column = int(padCommand.charAt(currentPosition+2));
        //println("wallID: " + wallID + ": " + row + " ,"+column);
        currentPosition += 3;
        currentWallID = int(padCommand.charAt(currentPosition));
        Pad newPad = myRoom.getPadRC(wallID,row,column);
        padsToLight.add(newPad);
      }
      
      handleDifficulty(difficulty);
    }
    
  }
  
  boolean handleInput(int x, int y,int clickNum, int deltaClickTime) 
  {
    super.handleInput(x, y, clickNum, deltaClickTime) ;
      
    if(myRoom.colorOfClick(x, y) == green) //green - success
    {
      myStats.addForceDoubleClickTime(deltaClickTime) ;
      myStats.success() ;
      generateStep() ;
      
      return true ;  
    }
    
    if(myRoom.colorOfClick(x, y) == red) myStats.minusPoint(); 
    
    myStats.miss() ;    
    return false ;
  } 
  
  void handleDifficulty(String difficulty)
  {
    int randomPadIndex = int(random(3)); // get random pad index for difficulty

    if (difficulty.equals(NOVICE))      // Lit all pads green
    {
      setRowToColor(padsToLight, green);
    } else if (difficulty.equals(INTERMEDIATE)) {    // Lit one pad red
      setRowAndPadToColor(padsToLight, randomPadIndex, red);
    } else if (difficulty.equals(ADVANCED)) {
      setRowAndPadToColor(padsToLight, randomPadIndex, green);  // Lit one pad green
    }
  }
  
  void initializeRedPads(){
    
    boolean isMissingWall = missingWall > 0 ;
    int wallID = (isMissingWall) ? wallID = missingWall % 4 + 1 : 4 ;  //start at WEST wall ; W -> N -> E
    
    for (int i = 0; i < 3; i++)
    {
      //gets num of pads depending on wall 
      int numPads = (wallID == NORTH || wallID == SOUTH) ? NS_WIDTH - 2 : EW_HEIGHT/2 - 1; 
      int r ,  c , incR , incC ;
      //initializes start point based on row/column depending on wall
      if(missingWall == SOUTH || !isMissingWall)
      {
        if(wallID == NORTH){ r = 1 ; c = NS_HEIGHT - 1 ; }
        else if(wallID == EAST){ r = 0 ; c = 1 ; }
        else { r = EW_WIDTH - 1 ; c = 1 ; }
      }
      else if(missingWall == NORTH)
      {
        if(wallID == SOUTH){ r = 1 ; c = 0 ; }
        else if(wallID == EAST){ r = 0 ; c = EW_HEIGHT/2 - 1; }
        else { r = EW_WIDTH - 1 ; c = EW_HEIGHT/2 - 1 ; }
      }
      else 
      {  
        if(wallID == SOUTH){ r = 1 ; c = 0 ; }
        else if(wallID == NORTH){ r = 1 ; c = NS_HEIGHT - 1 ; }
        else if(wallID == EAST){ r = 0 ; c = 2 ; numPads = EW_HEIGHT/2 ; }
        else { r = EW_WIDTH - 1 ; c = 2 ; numPads = EW_HEIGHT/2 ; }
      }
      //initializes increments for wall/column depending on wall
      incR = (wallID == NORTH || wallID == SOUTH) ? 1 : 0 ;
      incC = (wallID == NORTH || wallID == SOUTH) ? 0 : 1 ;
    
      //println("numPads : "+numPads);
      //gets numPads pads into appropriate color list
      
      //(i == 0) ? wall1 = wallID : ((i == 1) ? wall2 = wallID : wall3 = wallID );
      
      for (int j = 0; j < numPads ; j++)
      {
        Pad newPad = myRoom.getPadRC( wallID , r + incR*j , c + incC*j );
        addCoordinatesToArray(i,newPad,wallID,r + incR*j,c + incC*j);
        
      }  
      //gets next pad in sequence 1-2-3-4-1-...
      wallID = wallID % 4 + 1 ;
    } 
    
    setRowToColor(firstWall,red);
    setRowToColor(secondWall,red);
    setRowToColor(thirdWall,red);
  }
  
  void addCoordinatesToArray(int i, Pad newPad, int wallID, int row, int column){
    if (i == 0) {
      //wall1 = wallID;
      firstWall.add(newPad);
    } else if (i == 1)  {
      //wall2 = wallID;
      secondWall.add(newPad);
    } else if (i == 2) {
      //wall3 = wallID;
      thirdWall.add(newPad);
    }
  }
  
  //turns off all lit pads and empties lists
  private void clearLitPads()
  {
    //turns off pads
    for (int i = 0; i < padsToLight.size (); i++) ((Pad)padsToLight.get(i)).setColor(padOffColor) ;
    //Remove all pads
    while (padsToLight.size() > 0) padsToLight.remove(0) ;
  }
  
}

class Routine 
{
  Room myRoom ;
  String difficulty ;
  boolean groundPadPressed;
  Stats myStats ;
  int missingWall ;
  
  boolean handleInput(int x, int y, int clickNum, int deltaClickTime) {
    return true;
  }      

  void generateStep() {}
  void startRoutine() {}    

  // Set All pads in a row to a given color
  void setRowToColor (ArrayList row, color myColor)
  {
    for (int i = 0; i < row.size (); i++) ((Pad)row.get(i)).setColor(myColor) ;
  }

  // Set PadIndexToLit to myColor and the rest to the opposite color: red -> green ; green -> red
  void setRowAndPadToColor(ArrayList row, int padIndexToLit, color myColor)
  {
    for (int i = 0; i < row.size (); i++)
    {
      if (i == padIndexToLit) ((Pad)row.get(i)).setColor(myColor);
      else if (myColor == red) ((Pad)row.get(i)).setColor(green);
      else ((Pad)row.get(i)).setColor(red);
    }
  }

  // Set padIndex to myColor
  void setPadInRowToColor(ArrayList row, int padIndex, color myColor)
  {
    for (int i = 0; i < row.size (); i++)
    {
      if (i == padIndex) ((Pad)row.get(i)).setColor(myColor);
    }
  }
  
  void timeout(){ 
    //println("Before my Stats");
    myStats.minusPoint() ; 
    //println("After my stats");
  }
}

class xCueRoutine extends Routine
{
  ArrayList westWallPads;
  ArrayList northWallPads;
  ArrayList southWallPads;
  ArrayList eastWallPads;
  boolean secondGroundPadPressed;
  int successClicks;
  Pad firstGroundPad = null;
  Pad secondGroundPad = null;
  int timer;

  xCueRoutine(Room myRoom, String difficulty, int  missingWall)
  {
    super.startRoutine();
    this.missingWall = missingWall ;
    this.myRoom = myRoom;
    this.difficulty = difficulty; 
    groundPadPressed = false;
    secondGroundPadPressed = false;
    westWallPads = new ArrayList();
    northWallPads = new ArrayList();
    southWallPads = new ArrayList();
    eastWallPads = new ArrayList();
    successClicks = 0;
    myStats = new Stats();
    myStats.setXTime(3);
    //generateStep();
  }
  
  void startRoutine() {generateStep();}
  
  boolean isGroundPadPressed(){
    return groundPadPressed; 
  }
  
  boolean isSecondGroundPadPressed(){
    return secondGroundPadPressed; 
  }
  
  void timeout() 
  { 
    super.timeout() ;
    //println("xCue time out"); 
    groundPadPressed = false;
    secondGroundPadPressed = false;
  }

  void generateStep()
  {
    clearLitPads() ;  
    successClicks = 0 ;
    //println("Generating Step for xCue routine");
    int randomRowGround, randomColumnGround;
    
    randomColumnGround = int(random(((EW_HEIGHT-2)- ((EW_HEIGHT/2)+1))) + ((EW_HEIGHT/2)+1));
    randomRowGround = int(random(NS_WIDTH-2));
    
    if ((!groundPadPressed) && (!secondGroundPadPressed)){
       //println("No pads are pressed"); 
       generateCueWalls();
       firstGroundPad = myRoom.walls[GROUND].getPad(randomRowGround, randomColumnGround) ;
       firstGroundPad.setColor(secondYellow);
    } else if ((groundPadPressed) && (!secondGroundPadPressed)){
      //println("First pad is pressed but not second"); 
      secondGroundPad = myRoom.walls[GROUND].getPad(int(random(NS_WIDTH-2)),randomColumnGround-((EW_HEIGHT/2)+1)) ;
      secondGroundPad.setColor(yellow);
      setAllRowsToColor(yellow);
    } else if ( (groundPadPressed) && (secondGroundPadPressed) ) {
      //println("Both pads are pressed");
      handleDifficulty(difficulty);
    }
    
  }
  
  private void clearLitPads()
  {
     setAllRowsToColor(padOffColor);
     
    if (firstGroundPad != null) firstGroundPad.setColor(padOffColor);
    
    if (secondGroundPad != null) secondGroundPad.setColor(padOffColor);
    
    if (successClicks == 4){
       while (northWallPads.size () > 0) northWallPads.remove(0) ;
       while (southWallPads.size () > 0) southWallPads.remove(0) ;
       while (eastWallPads.size () > 0) eastWallPads.remove(0) ;
       while (westWallPads.size () > 0) westWallPads.remove(0) ;
    }
    
  }
  
  void setGreenPadsToColor(ArrayList row, color myColor)
  {
     for (int i = 0; i < row.size (); i++)
     {
       if ( ((Pad)row.get(i)).getColor() != padOffColor)
         ((Pad)row.get(i)).setColor(myColor) ;
     }
  }
  
  boolean handleInput(int x, int y, int clickNum, int deltaClickTime) 
  {
    super.handleInput(x, y, clickNum, deltaClickTime) ;
    int groundID = 0;
    
    if ((!groundPadPressed) && (!secondGroundPadPressed) && (myRoom.getWallID(x,y) == groundID) && ((myRoom.colorOfClick(x,y) == secondYellow) ) )
    {
      groundPadPressed = true;
      generateStep();
      myStats.firstDribble() ;
      myStats.startXprsTime() ;
      return false;
    } 
    else if ((groundPadPressed) && (!secondGroundPadPressed) && (myRoom.getWallID(x,y) == groundID) && ((myRoom.colorOfClick(x,y) == yellow) ) )
    {
      secondGroundPadPressed = true;
      generateStep();
      myStats.successDribble() ;
      return false;
    } 
    else if (clickNum == 2)
    {
      if (myRoom.colorOfClick(x,y) == green)
      {
        myStats.addForceDoubleClickTime(deltaClickTime) ;
        myStats.success() ;
        int wallID = myRoom.getWallID(x,y);
         
        switch (wallID)
        {
        case NORTH:
        setGreenPadsToColor(northWallPads, blue);
        successClicks++;
          break ;
        case SOUTH:
        setGreenPadsToColor(southWallPads, blue);
        successClicks++;
          break ;
        case EAST:
        setGreenPadsToColor(eastWallPads, blue);
        successClicks++;
          break ;
        case WEST:
        setGreenPadsToColor(westWallPads, blue);
        successClicks++;
          break ;
        default:
        }
        
        if (successClicks == 4){
           myStats.endXprs() ;
           groundPadPressed = false;
           secondGroundPadPressed = false;
           generateStep(); 
           return true;
        }
      }
      else
      { 
        if (myRoom.colorOfClick(x,y) == red) myStats.minusPoint() ;
        myStats.miss() ;
      }
    }
    
    return false;
  }  
  
  void setNumberOfPadsInRowToColor(ArrayList row, int numberOfGreenPads, int numberOfRedPads)
  {
    int randomPad = int(random(row.size()));
    
    for (int i = 0; i < numberOfGreenPads; i++){
      randomPad = (randomPad+1)%(row.size());
      ((Pad)row.get(randomPad)).setColor(green);  
    }
    
    while (numberOfRedPads != 0)
    {
      randomPad = (randomPad+1)%(row.size());
      Pad current = ((Pad)row.get(randomPad));
      if (current.getColor() != green)
      {
        current.setColor(red);
        numberOfRedPads--; 
      }
    }
  }
  
  void handleDifficulty(String difficulty)
  {
    setAllRowsToColor(padOffColor);
    
    if (difficulty.equals(NOVICE))
    {
      setNumberOfPadsInRowToColor(northWallPads,4,0);  // Lit only 4 green pads
      setNumberOfPadsInRowToColor(southWallPads,4,0);
      setNumberOfPadsInRowToColor(westWallPads,4,0);
      setNumberOfPadsInRowToColor(eastWallPads,4,0);
    } else if (difficulty.equals(INTERMEDIATE)) {
      setNumberOfPadsInRowToColor(northWallPads,3,1);  // Lit 3 green pads and 1 red pad
      setNumberOfPadsInRowToColor(southWallPads,3,1); 
      setNumberOfPadsInRowToColor(eastWallPads,3,1); 
      setNumberOfPadsInRowToColor(westWallPads,3,1); 
    } else if (difficulty.equals(ADVANCED)) {
      setNumberOfPadsInRowToColor(northWallPads,2,2);  // Lit 2 green pads and 2 red pads
      setNumberOfPadsInRowToColor(southWallPads,2,2);
      setNumberOfPadsInRowToColor(eastWallPads,2,2);
      setNumberOfPadsInRowToColor(westWallPads,2,2);
    }
    
  }
  
  void generateCueWalls()
  {
    //println("Generating cue walls");
    generateSouthOrWestPads(SOUTH);
    generateSouthOrWestPads(WEST);
    generateNorthPads();
    generateEastPads();
  }
  
  void setAllRowsToColor(color myColor){
    //println("Setting all rows to color " + myColor);
    setRowToColor(northWallPads,myColor);
    setRowToColor(southWallPads,myColor);
    setRowToColor(eastWallPads,myColor);
    setRowToColor(westWallPads,myColor);
  }

  void generateEastPads()
  {
    int startingColumn = int(random(6));
    int fC = startingColumn+2;
    int fR = 1;
    int sC = startingColumn+1;
    int sR = 2;
    int tC = fC;
    int tR = sR;
    
    for (int r = 0; r < 3; r++)
    {
      for (int c = startingColumn; c < startingColumn+3; c++)
      {
        
        if ( ((fC == c) && (fR == r)) || ((sC == c) && (sR == r)) || ((tC == c) && (tR == r)) ) println("First East Pad");
        else 
        {
          //println(r+", "+c);
          Pad currentPad = myRoom.walls[EAST].getPad(r, c) ;
          if (currentPad.isValid())
          {
            //currentPad.setColor(green);
            eastWallPads.add(currentPad);
          }
        }
      } 
    }
    
  }

  void generateNorthPads()
  {
    int padNumber = 4;
    int startingRow = int(random(3));
    int columnNumber = 2;
    int counter = 0;

    for (int i = startingRow; i < startingRow + 4; i++)
    {
      counter++;
      //println("c,r: " + i + ", " + columnNumber);
      if (counter == 3)
      { 
        //println("Third Number");
        generateVerticalPads(i);
      }
      else
      {
        Pad currentPad = myRoom.walls[NORTH].getPad(i, columnNumber) ;
        if (currentPad.isValid())
        {
          //currentPad.setColor(green);
          northWallPads.add(currentPad);
        }
      }
    }
  }

  void generateVerticalPads(int rowNumber)
  {
    //println("Vertical Pads");
    for (int i = 0; i < 3; i++)
    {
      //println(rowNumber+", "+i);
      Pad currentPad = myRoom.walls[NORTH].getPad(rowNumber, i) ;
      if (currentPad.isValid())
      {
        //currentPad.setColor(green);
        northWallPads.add(currentPad);
      }
    }
  }

  void generateSouthOrWestPads(int wallID)
  {

    int startingRow = 0, startingColumn = 0, rowHigh = 0, columnHigh = 0;
    int fR = 0, fC = 0, sR = 0, sC = 0;

    switch(wallID)
    {
    case WEST:
      startingRow = int(random(2));
      startingColumn = int(random(5));
      rowHigh = startingRow+2;
      columnHigh = startingColumn+4;
      fR = startingRow+1; 
      fC  = startingColumn;
      sR = startingRow; 
      sC = startingColumn + 3;
      break;
    case SOUTH:
      startingRow = int(random(3)); 
      startingColumn = int(random(2));
      rowHigh = startingRow+4;
      columnHigh = startingColumn+2;
      fR = startingRow; 
      fC  = startingColumn+1;
      sR = startingRow+3; 
      sC = startingColumn + 1;
      break;
    default:
      break;
    }

    for (int r = startingRow; r < rowHigh; r++)
    {
      for (int c = startingColumn; c < columnHigh; c++)
      {
        if ( ((r == fR) && (c == fC)) || ((r == sR) && (c == sC))) println("Nothing");
        else
        { 
          //println("r & c: " + r + ", "+c);
          Pad currentPad;
          switch (wallID)
          {
          case WEST:
            currentPad = myRoom.walls[WEST].getPad(r, c) ;
            if (currentPad.isValid())
            {
              //currentPad.setColor(green);
              westWallPads.add(currentPad);
            }
            break; 
          case SOUTH:
            currentPad = myRoom.walls[SOUTH].getPad(r, c) ;
            if (currentPad.isValid())
            {
              //currentPad.setColor(green);
              southWallPads.add(currentPad);
            }
          default:
            //println("Switch");
            break;
          }
        }
      }
    }
  }
}

class GroundChaseRoutine extends Routine
{
   ArrayList greenPads;
   ArrayList bluePads;
   ArrayList redPads;
   Pad[] redPadArray;
   boolean[] rowRepetition;
   int clickedColumn;
   int previousPadIndex;
   int [] greenPadCoordinateArray;
  
   GroundChaseRoutine(Room myRoom, String difficulty, int  missingWall)
   {
     super.startRoutine();
     this.myRoom = myRoom;
     this.difficulty = difficulty;
     this.missingWall = missingWall ;
     myStats = new Stats() ;
     greenPads = new ArrayList();
     redPads = new ArrayList();
     bluePads = new ArrayList();
     clickedColumn = 0;
     rowRepetition = new boolean[NS_WIDTH-2];
     greenPadCoordinateArray = new int[(EW_HEIGHT-2)];
     redPadArray = new Pad[(EW_HEIGHT-2)];
     previousPadIndex = -1;
     initRowRepetitionArray();  // Set array values to false
     //generateStep();
   }
   
   void startRoutine() {generateStep();}
   
   void generateStep()
   {
     
    if (clickedColumn == 0)
    { 
      generateRandomPads(0);
      getRedPadsForDifficultyLevel(difficulty);
      if (clickedColumn == 0)
      {
         Pad redPad = redPadArray[clickedColumn];
         if (redPad != null)   redPad.setColor(red);
      }
    }
     // initialize the greenPadCoordinateArray with the row value of each green pad y greenPads
     if (clickedColumn < (EW_HEIGHT - 2))
     {
       Pad padToLit = (Pad)(greenPads.get(clickedColumn));
       padToLit.setColor(green);
     }
   }
   
   void timeout() 
   { 
     super.timeout() ; 
     clickedColumn = 0;
     clearLitPads();
   }
   
   // Generates Random Pads without repeating consecutive positions
   private void generateRandomPads(int wallID)
   {
      for (int i = 0 ; i < (EW_HEIGHT - 2) ; i++)
      { 
        int index = generateRandomPadIndex(i);
        //println("index: "+ index);
        greenPadCoordinateArray[i] = index;
        Pad newPad = myRoom.walls[wallID].getPad(index,i);      
        greenPads.add(newPad);
      } 
   }
   
   private int generateRandomPadIndex(int columnCount)
   {
     int randomIndex = int(random(NS_WIDTH - 2));
     
     if (columnCount < NS_WIDTH - 2)
       {
       while ( (rowRepetition[randomIndex]) || (randomIndex == previousPadIndex) )
       {
          if (rowRepetition[randomIndex]) randomIndex = int(random(NS_WIDTH - 2));
          if (randomIndex == previousPadIndex) randomIndex = int(random(NS_WIDTH - 2)); 
       }
       
       rowRepetition[randomIndex] = true;
       previousPadIndex = randomIndex;
     }
     else
     {
        initRowRepetitionArray();
        randomIndex = int(random(NS_WIDTH - 2));
        
        while (randomIndex == previousPadIndex)
          if (randomIndex == previousPadIndex) randomIndex = int(random(NS_WIDTH - 2));
          
        previousPadIndex = randomIndex;
     }
     
     return randomIndex;
     
   }
   
  boolean handleInput(int x, int y,int clickNum, int deltaClickTime) 
  {
    super.handleInput(x, y, clickNum, deltaClickTime) ;
    if (clickedColumn < (EW_HEIGHT - 2))
    {
       if (myRoom.colorOfClick(x,y) == green)
       {
         //myStats.success() ;
         if(clickedColumn > 0) myStats.successDribble() ;
         if(clickedColumn < EW_HEIGHT - 2) myStats.firstDribble() ;
        
         Pad pressedPad = myRoom.getPad(x,y);
         bluePads.add(pressedPad);
         pressedPad.setColor(blue);
         
         Pad redPad = redPadArray[clickedColumn];
         if (redPad != null)   redPad.setColor(padOffColor);
         
         // Keeps track of the columns
         clickedColumn++;
         
         if (clickedColumn < (EW_HEIGHT - 2))
         {
           redPad = redPadArray[clickedColumn];
           if (redPad != null) redPad.setColor(red);
         }
         
         generateStep();
         
         // Routine Finished if all the columns are hit
         if (clickedColumn >= (EW_HEIGHT - 2))
         { 
           clickedColumn = 0;
           clearLitPads();
           generateStep();
           return true; // Round ended
         }
       }
       if (myRoom.colorOfClick(x,y) == red) myStats.minusPoint() ;
    }
    
    return false;
  }  
  
  //turns off all lit pads and empties lists
  private void clearLitPads()
  {
    //turns off all green pads
    setRowToColor(greenPads, padOffColor) ; 
    setRowToColor(bluePads, padOffColor) ;
    setRowToColor(redPads, padOffColor);
    setArrayRowToColor(redPadArray,padOffColor);
    
    //empties all structures
    while (greenPads.size () > 0) greenPads.remove(0) ;
    while (bluePads.size () > 0) bluePads.remove(0) ;
    while (redPads.size () > 0) redPads.remove(0) ;
    redPadArray = new Pad[EW_HEIGHT-2];
  }
  
  // Set All pads in a row to a given color
  void setArrayRowToColor (Pad[] row, color myColor)
  {
    for (int i = 0; i < row.length ; i++)
    { 
      Pad nPad = (Pad)row[i] ;
      if (nPad != null) nPad.setColor(myColor);
    }
  }
  
  private void initRowRepetitionArray()
  {
    for (int i = 0 ; i < NS_WIDTH - 2 ; i++)
    {
       rowRepetition[i] = false;
    } 
  }
  
  private void getRedPadsForDifficultyLevel(String difficulty)
  {
    int groundHeight = EW_HEIGHT - 2;
    int randomColumn = int(random(groundHeight));
    int redPadNumber = 0;

    if (difficulty.equals(INTERMEDIATE))   redPadNumber = groundHeight/3;
    else if (difficulty.equals(ADVANCED))  redPadNumber = groundHeight/2 ;

    for (int i = 0; i < redPadNumber; i ++)
    {
      // find a random red pad that is not equal to a greenPad
      int aux = greenPadCoordinateArray[randomColumn];
      while (greenPadCoordinateArray[randomColumn] == aux)  
        aux = int(random(NS_WIDTH-2));

      Pad redPad = myRoom.getPadRC(GROUND, aux, randomColumn);
      if (redPad == null) println("redPad in GroundChase is null");
      redPadArray[randomColumn] = redPad;
      //redPad.setColor(red);

      randomColumn = (randomColumn + (groundHeight/redPadNumber)) % (groundHeight);
    }
  } 
}

class HomeChaseRoutine extends Routine 
{
  ArrayList row1 ;
  ArrayList row2 ;
  int wall1 ;
  int wall2 ;
  int successClicks ;
  int stepTime ;
  Pad groundPad;
  boolean isGroundPadNorth ; 


  HomeChaseRoutine (Room myRoom, String difficulty, int  missingWall) 
  {
    super.startRoutine() ;        
    this.myRoom = myRoom ;
    this.difficulty = difficulty ;
     this.missingWall = missingWall ;
    row1 = new ArrayList() ;
    row2 = new ArrayList() ;
    myStats = new Stats() ; 
    successClicks = 0;    // keeps track on the number of succesfull clicks
    groundPadPressed = false;
    groundPad = null;
    //generateStep();
  }
  
  void startRoutine() {generateStep();}
  
  boolean isGroundPadPressed() { 
    return groundPadPressed ;
  } 
  
  void timeout() { super.timeout() ; }
  
  void generateStep()
  {
    super.generateStep() ;
    clearLitPads() ;  
    successClicks = 0 ;

    if (!groundPadPressed) 
    {
      groundPad = myRoom.getRandomGroundPad();
      groundPad.setColor(orange);
    } 
    else
    {
      wall1 = (isGroundPadNorth) ? SOUTH : NORTH ;
      wall2 = (int(random(2)) == 0) ? EAST : WEST ;  //east or west
      
      if(wall1 == missingWall)
        wall1 = (wall2 == EAST) ? WEST : EAST ;
      else if(wall2 == missingWall)
        wall2 = (wall2 == EAST) ? WEST : EAST ;
      
      assignRow(wall1 , row1) ;
      assignRow(wall2 , row2) ;  
      // Method that handles difficulty
      handleDifficulty(difficulty);

      stepTime = millis() ;
    }
  }
  void assignRow(int wallID , ArrayList row)
  {  
    ArrayList newPads;
    if(wallID == EAST || wallID == WEST) 
      newPads = myRoom.getBottomPads(wallID, 3, true, !isGroundPadNorth)  ;
    else 
      newPads = myRoom.getBottomPads(wallID, 3, false, false) ;
  
    for (int j = 0; j < ROW_PAD_NUMBER; j++) row.add((Pad)(newPads.get(j)));
  }
  
  void handleDifficulty(String difficulty)
  {

    int randomPadIndex = int(random(3)); // get random pad index for difficulty

    if (difficulty.equals(NOVICE))      // Lit all pads green
    {
      setRowToColor(row1, green);    
      setRowToColor(row2, green);
    } else if (difficulty.equals(INTERMEDIATE)) {    // Lit one pad red
      setRowAndPadToColor(row1, randomPadIndex, red);
      setRowAndPadToColor(row2, randomPadIndex, red);
    } else if (difficulty.equals(ADVANCED)) {
      setRowAndPadToColor(row1, randomPadIndex, green);  // Lit one pad green
      setRowAndPadToColor(row2, randomPadIndex, green);
    }
  }

  boolean handleInput(int x, int y,int clickNum, int deltaClickTime) 
  {
    super.handleInput(x, y, clickNum, deltaClickTime) ;
    int groundID = 0 ;

    if (!groundPadPressed)
    {
      if (myRoom.getWallID(x, y) == groundID)
      {
        if (myRoom.colorOfClick(x, y) == orange)
        {
          isGroundPadNorth = y < height/2 ; 
          groundPadPressed = true;
          generateStep();
          return false;
        }
      }
    } 
    else if(clickNum == 2)
    {  //only checking double clicks
      if (myRoom.colorOfClick(x, y) == green)
      {
        myStats.addForceDoubleClickTime(deltaClickTime);
        myStats.success() ;
        if (successClicks == 1) 
        {
          groundPadPressed = false;

          // Setting of both rows
          setRowToColor(row1, padOffColor) ; 
          setRowToColor(row2, padOffColor) ; 

          // Setting of ground pad when second row is pressed
          groundPad.setColor(padOffColor) ;
          
          generateStep() ;
          return true ;// ROUNDS: return true. step is finished ;
        } else 
        {
          if (myRoom.getWallID(x, y) == wall1) 
          {
            setRowToColor(row1, blue) ;
            successClicks++;
          } else {
            setRowToColor(row2, blue) ;
            successClicks++;
          }
        }
        return false; // ROUNDS: return false;
      }
      if (myRoom.colorOfClick(x, y) == red) myStats.minusPoint() ;
      myStats.miss() ;
    }
    return false;
  }  

  //turns off all lit pads and empties lists
  private void clearLitPads()
  {
    //turns off all green pads
    setRowToColor(row1, padOffColor) ; 
    setRowToColor(row2, padOffColor) ;

    if (groundPad != null)
    {
      groundPad.setColor(padOffColor);
    }

    //empties greenPad list
    while (row1.size () > 0) row1.remove(0) ;
    while (row2.size () > 0) row2.remove(0) ;
  }
}

class HomeFlyRoutine extends Routine
{
  ArrayList row1 ;
  ArrayList row2 ;
  int wall1 ;
  int wall2 ;
  int successClicks ;
  int stepTime ;
  Pad groundPad = null;
  boolean isGroundPadNorth ;

  HomeFlyRoutine (Room myRoom, String difficulty, int  missingWall) 
  {
    super.startRoutine() ;        
    this.myRoom = myRoom ;
    this.difficulty = difficulty ;
     this.missingWall = missingWall ;
    row1 = new ArrayList() ;
    row2 = new ArrayList() ;
    myStats = new Stats() ; 
    successClicks = 0;    // keeps track on the number of succesfull clicks
    groundPadPressed = false;
    //generateStep();
  }
  
  void startRoutine() {generateStep();}

  void generateStep()
  {
    clearLitPads() ;  
    successClicks = 0 ;

    if (!groundPadPressed) 
    {
      groundPad = myRoom.getRandomGroundPad();
      groundPad.setColor(orange);
    } else
    {  
      wall1 = (isGroundPadNorth) ? SOUTH : NORTH ;
      wall2 = (int(random(2)) == 0) ? EAST : WEST ;  //east or west
      
      if(wall1 == missingWall)
        wall1 = (wall2 == EAST) ? WEST : EAST ;
      else if(wall2 == missingWall)
        wall2 = (wall2 == EAST) ? WEST : EAST ;  
      
      assignRow(wall1 , row1) ;
      assignRow(wall2 , row2) ;

      // Method that handles difficulty
      handleDifficulty(difficulty);
      stepTime = millis() ;
    }
  }
  
  void timeout() { super.timeout() ; }
  
  void assignRow(int wallID , ArrayList row)
  {  
    ArrayList newPads;
    if(wallID == EAST || wallID == WEST) 
      newPads = myRoom.getUpperSquarePads(wallID, SQUARE_PAD_NUMBER/2, true, !isGroundPadNorth)  ;
    else 
      newPads = myRoom.getUpperSquarePads(wallID, SQUARE_PAD_NUMBER/2, false, false) ;
  
    for (int j = 0; j < SQUARE_PAD_NUMBER; j++) row.add((Pad)(newPads.get(j)));
  }
  
  void handleDifficulty(String difficulty)
  {
    int randomPadIndex = int(random(3)); // get random pad index for difficulty

    if (difficulty.equals(NOVICE))      // Lit all pads green
    {
      setRowToColor(row1, green);    
      setRowToColor(row2, green);
    } else if (difficulty.equals(INTERMEDIATE)) {    // Lit one pad red
      setRowAndPadToColor(row1, randomPadIndex, red);
      setRowAndPadToColor(row2, randomPadIndex, red);
    } else if (difficulty.equals(ADVANCED)) {

      for ( int i = 0; i < SQUARE_PAD_NUMBER; i++)
      {
        if (randomPadIndex == i)
        {
          // Set two green pads for each row
          setPadInRowToColor(row1, randomPadIndex, green);
          setPadInRowToColor(row1, ((randomPadIndex+1)%4), green); 
          setPadInRowToColor(row2, randomPadIndex, green);
          setPadInRowToColor(row2, ((randomPadIndex+1)%4), green);
        } else 
        {
          // Set two red pads for each row
          setPadInRowToColor(row1, i, red);
          setPadInRowToColor(row2, i, red);
        }
      }
    }
  }

  boolean handleInput(int x, int y,int clickNum, int deltaClickTime) 
  {
    super.handleInput(x, y,1, deltaClickTime) ;
    int groundID = 0 ;

    if ( (!groundPadPressed) && (myRoom.getWallID(x, y) == groundID) && (myRoom.colorOfClick(x, y) == orange) )
    {
      groundPadPressed = true;
      isGroundPadNorth = y < height/2 ;
      generateStep();
      return false;
    } 
    else if( clickNum == 2) 
    {
      if (myRoom.colorOfClick(x, y) == green)
      {
        myStats.addForceDoubleClickTime(deltaClickTime) ;
        myStats.success() ;
        if (successClicks == 1) 
        {
          groundPadPressed = false;

          // Setting of both rows
          setRowToColor(row1, padOffColor) ; 
          setRowToColor(row2, padOffColor) ; 

          // Setting of ground pad when second row is pressed
          groundPad.setColor(padOffColor) ;

          generateStep() ;
          return true ;// ROUNDS: return true. step is finished ;
        } 
        else if (myRoom.getWallID(x, y) == wall1) 
        {
          setRowToColor(row1, blue) ;
          successClicks++;
        } 
        else 
        {
          setRowToColor(row2, blue) ;
          successClicks++;
        }
        
        return false; // ROUNDS: return false;
      }
      
      if (myRoom.colorOfClick(x, y) == red) myStats.minusPoint() ;
      myStats.miss() ;
    }
    return false;
  }  

  //turns off all lit pads and empties lists
  private void clearLitPads()
  {
    //turns off all green pads
    setRowToColor(row1, padOffColor) ; 
    setRowToColor(row2, padOffColor) ; 
    
    if (groundPad != null)
    {
      groundPad.setColor(padOffColor);
    }

    //empties greenPad list
    while (row1.size () > 0) row1.remove(0) ;
    while (row2.size () > 0) row2.remove(0) ;
  }
}
class FlyRoutine extends Routine
{
  ArrayList row1 ;
  ArrayList row2 ;
  int wall1 ;
  int wall2 ;

  FlyRoutine (Room myRoom, String difficulty, int  missingWall) 
  {
    super.startRoutine() ;        
    this.myRoom = myRoom ;
    this.difficulty = difficulty ;
    this.missingWall = missingWall ;
    row1 = new ArrayList() ;
    row2 = new ArrayList() ;
    wall1 = int(random(4)) + 1;
    wall2 = (wall1 % 4) + 1;
    myStats = new Stats() ; 
    //generateStep();
    //generateStep();
  }
  
  void startRoutine() {
    generateStep();
    generateStep();
  }

  void generateStep()
  {
    super.generateStep() ;
    boolean workingOnRow1 = ( row1.size() == 0 ) ;
    int next ;
    if(workingOnRow1) 
    {
      next = wall1 + (( wall1 > 2 ) ? -2 : 2); 
      wall1 = (next == missingWall) ? wall1 : next ;
      row1 = myRoom.getUpperSquarePads(wall1, SQUARE_PAD_NUMBER/2, false, false);
      handleDifficulty(difficulty, row1);
    }
    else 
    {
      next = wall2 + (( wall2 > 2 ) ? -2 : 2); 
      wall2 = (next == missingWall) ? wall2 : next ;
      row2 = myRoom.getUpperSquarePads(wall2, SQUARE_PAD_NUMBER/2, false, false);
      handleDifficulty(difficulty, row2);
    }  
  }
  
  void timeout() { super.timeout() ; }
  
  void handleDifficulty(String difficulty, ArrayList row)
  {
    int randomPadIndex = int(random(3)); // get random pad index for difficulty

    if (difficulty.equals(NOVICE))      // Lit all pads green
      setRowToColor(row, green);    
    else if (difficulty.equals(INTERMEDIATE))     // Lit one pad red
      setRowAndPadToColor(row, randomPadIndex, red);
    else if (difficulty.equals(ADVANCED)) {

      for ( int i = 0; i < SQUARE_PAD_NUMBER; i++)
      {
        if (randomPadIndex == i)
        {
          // Set two green pads for each row
          setPadInRowToColor(row, randomPadIndex, green);
          setPadInRowToColor(row, ((randomPadIndex+1)%4), green); 
        } else 
          // Set two red pads for each row
          setPadInRowToColor(row, i, red);
      }
    }
  }

  boolean handleInput(int x, int y,int clickNum, int deltaClickTime) 
  {
    super.handleInput(x, y, clickNum, deltaClickTime) ;

    if (myRoom.colorOfClick(x, y) == green)
    {
      myStats.addForceDoubleClickTime(deltaClickTime) ;
      myStats.success() ;
      ArrayList rowHit = (myRoom.getWallID(x, y) == wall1)  ? row1 : row2 ;
      setRowToColor(rowHit, padOffColor) ;
      while( rowHit.size() > 0 ) rowHit.remove(0) ;   
      generateStep() ; 
      return true; 
    }
    else if (myRoom.colorOfClick(x, y) == padOffColor) {
      myStats.miss() ;
      println("You missed");
    } else if (myRoom.colorOfClick(x, y) == red) {
      myStats.minusPoint();
    }
    
    return false;
  }   

  //turns off all lit pads and empties lists
  private void clearLitPads()
  {
    //turns off all green pads
    setRowToColor(row1, padOffColor) ; 
    setRowToColor(row2, padOffColor) ; 

    //empties greenPad list
    while (row1.size () > 0) row1.remove(0) ;
    while (row2.size () > 0) row2.remove(0) ;
  }
}

class ChaseRoutine extends Routine 
{
  ArrayList row1 ;
  ArrayList row2 ;
  int wall1 ;
  int wall2 ;

  ChaseRoutine (Room myRoom, String difficulty, int  missingWall) 
  {
    super.startRoutine() ;        
    this.myRoom = myRoom ;
    this.difficulty = difficulty ;
    this.missingWall = missingWall ;
    row1 = new ArrayList() ;
    row2 = new ArrayList() ;
    wall1 = int(random(4)) + 1;
    wall2 = wall1 % 4 + 1;
    myStats = new Stats() ;  
    //generateStep();
    //generateStep();
  }
  
  void startRoutine() {
    generateStep();
    generateStep();
  }

  void generateStep()
  {
    super.generateStep() ;
    boolean workingOnRow1 = ( row1.size() == 0 ) ;
    int next ;
    
    if(workingOnRow1)
    {
      next = wall1 + (( wall1 > 2 ) ? -2 : 2 ) ; 
      wall1 = ( next == missingWall ) ? wall1 : next; 
      row1 = myRoom.getBottomPads(wall1, ROW_PAD_NUMBER, false, false) ;
      handleDifficulty(difficulty, row1);
    }
    else 
    {
      next = wall2 + (( wall2 > 2 ) ? -2 : 2); 
      wall2 = ( next == missingWall ) ? wall2 : next; 
      row2 = myRoom.getBottomPads(wall2, ROW_PAD_NUMBER, false, false) ;
      handleDifficulty(difficulty, row2);
    } 
  }

  void handleDifficulty(String difficulty, ArrayList row)
  {
    int randomPadIndex = int(random(3)); // get random pad index for difficulty

    if (difficulty.equals(NOVICE))      // Lit all pads green
      setRowToColor(row, green);    
    else if (difficulty.equals(INTERMEDIATE))     // Lit one pad red
      setRowAndPadToColor(row, randomPadIndex, red);
    else if (difficulty.equals(ADVANCED)) 
      setRowAndPadToColor(row, randomPadIndex, green) ;
  }

  boolean handleInput(int x, int y,int clickNum, int deltaClickTime) 
  {
    super.handleInput(x, y, 1, deltaClickTime) ;

    if (myRoom.colorOfClick(x, y) == green)
    {
      myStats.addForceDoubleClickTime(deltaClickTime) ;
      myStats.success() ;
      ArrayList rowHit = (myRoom.getWallID(x, y) == wall1)  ? row1 : row2 ;
      setRowToColor(rowHit, padOffColor) ;
      while( rowHit.size() > 0 ) rowHit.remove(0) ;   
      generateStep() ;  
      return true;
    }
    else if(myRoom.colorOfClick(x, y) == padOffColor) {
      myStats.miss() ;
    } else if (myRoom.colorOfClick(x, y) == red) {
      myStats.minusPoint();
    }
    
    return false;
  }  
}

class ThreeWallChaseRoutine extends Routine 
{
  ArrayList greenPads ;
  ArrayList redPads ;

  ThreeWallChaseRoutine(Room myRoom, String difficulty, int  missingWall) 
  {
    super.startRoutine() ;        
    this.myRoom = myRoom ;
    this.difficulty = difficulty ;
    this.missingWall = missingWall ;
    greenPads = new ArrayList() ;
    redPads = new ArrayList() ;
    myStats = new Stats() ;
    //generateStep();
  }
  
  void startRoutine() {generateStep();}

  void generateStep() 
  {
    super.generateStep() ;
    clearLitPads() ;  
    boolean isMissingWall = missingWall > 0 ;
    int wallID = (isMissingWall) ? wallID = missingWall % 4 + 1 : 4 ;  //start at WEST wall ; W -> N -> E
    int toBeGreen = int(random(3)) ;  //decides green wall
    
    for (int i = 0; i < 3; i++)
    {
      //gets num of pads depending on wall 
      int numPads = (wallID == NORTH || wallID == SOUTH) ? NS_WIDTH - 2 : EW_HEIGHT/2 - 1; 
      int r ,  c , incR , incC ;
      //initializes start point based on row/column depending on wall
      if(missingWall == SOUTH || !isMissingWall)
      {
        if(wallID == NORTH){ r = 1 ; c = NS_HEIGHT - 1 ; }
        else if(wallID == EAST){ r = 0 ; c = 1 ; }
        else { r = EW_WIDTH - 1 ; c = 1 ; }
      }
      else if(missingWall == NORTH)
      {
        if(wallID == SOUTH){ r = 1 ; c = 0 ; }
        else if(wallID == EAST){ r = 0 ; c = EW_HEIGHT/2 - 1; }
        else { r = EW_WIDTH - 1 ; c = EW_HEIGHT/2 - 1 ; }
      }
      else 
      {  
        if(wallID == SOUTH){ r = 1 ; c = 0 ; }
        else if(wallID == NORTH){ r = 1 ; c = NS_HEIGHT - 1 ; }
        else if(wallID == EAST){ r = 0 ; c = 2 ; numPads = EW_HEIGHT/2 ; }
        else { r = EW_WIDTH - 1 ; c = 2 ; numPads = EW_HEIGHT/2 ; }
      }
      //initializes increments for wall/column depending on wall
      incR = (wallID == NORTH || wallID == SOUTH) ? 1 : 0 ;
      incC = (wallID == NORTH || wallID == SOUTH) ? 0 : 1 ;
    
      //gets numPads pads into appropriate color list
      for (int j = 0; j < numPads ; j++)
      {
        Pad newPad = myRoom.getPadRC( wallID , r + incR*j , c + incC*j );
        //if set to red pads, puts them in the red pads list
        if (i == toBeGreen) greenPads.add(newPad) ;
        //else put pads in green pads list
        else redPads.add(newPad) ;
        
      }  
      //gets next pad in sequence 1-2-3-4-1-...
      wallID = wallID % 4 + 1 ;
    }

    setRowToColor(redPads, red);
    handleDifficulty(difficulty);
  }
  
  void timeout() { super.timeout() ; }

  void handleDifficulty(String difficulty)
  {
    int randomPadIndex = int(random(3)); // get random pad index for difficulty

    if (difficulty.equals(NOVICE))      // Lit all pads green
    {
      setRowToColor(greenPads, green);
    } else if (difficulty.equals(INTERMEDIATE)) {    // Lit one pad red
      setRowAndPadToColor(greenPads, randomPadIndex, red);
    } else if (difficulty.equals(ADVANCED)) {
      setRowAndPadToColor(greenPads, randomPadIndex, green);  // Lit one pad green
    }
  }

  boolean handleInput(int x, int y,int clickNum, int deltaClickTime) 
  {
    super.handleInput(x, y, clickNum, deltaClickTime) ;
      
    if(myRoom.colorOfClick(x, y) == green) //green - success
    {
      myStats.addForceDoubleClickTime(deltaClickTime) ;
      myStats.success() ;
      generateStep() ;
      return true ;  
    }
    
    if(myRoom.colorOfClick(x, y) == red) myStats.minusPoint(); 
    
    myStats.miss() ;    
    return false ;
  }  

  //turns off all lit pads and empties lists
  private void clearLitPads()
  {
    //turns off all green pads
    for (int i = 0; i < greenPads.size (); i++) ((Pad)greenPads.get(i)).setColor(padOffColor) ;
    //turns off all red pads
    for (int i = 0; i < redPads.size (); i++) ((Pad)redPads.get(i)).setColor(padOffColor) ;
    //empties greenPad list
    while (greenPads.size () > 0) greenPads.remove(0) ;
    //empties redPad list
    while (redPads.size () > 0) redPads.remove(0) ;
  }
}

class Stats
{
  double forceSum ;
  int successes ;
  int misses ;
  int anticipationReactionSum ;
  int minusPoints;
  int lastSuccessAt ;
  boolean isFirstSuccess ;
  int startDribble ;
  int dribbleSuccesses ;
  int dribbleARSum ; 
  int xTime ;
  int startXPRS ;
  int sumXPRS ;
  int roundsXPRS ;
  
  Stats() 
  {
    forceSum = 0 ;
    successes = 0 ; 
    misses = 0 ;
    minusPoints = 0 ;
    anticipationReactionSum = 0 ;
    dribbleARSum = 0 ;
    isFirstSuccess = true ;
    dribbleSuccesses = 0 ; 
    startDribble = 0 ;
    xTime = 0 ;
    roundsXPRS = 0 ;
  }

  void addForceDoubleClickTime(int deltaTime) 
  { 
    forceSum += (30 + (double)1/(deltaTime-105)) * ballMass;
    //forceSum += deltaTime;   
  }
  
  void success() 
  { 
    successes++ ; 
    
    if (javascript != null) playSuccessSound();
    else println("Javascript is null"); 
    
    if(isFirstSuccess) isFirstSuccess = false ;
    else anticipationReactionSum += (millis() - lastSuccessAt) ;
    
    lastSuccessAt = millis() ;
    printSummary();
  }
  
  void miss() { misses++ ; printSummary() ;}
  
  void minusPoint() 
  {
    minusPoints++ ; 
    
    if (javascript != null) playMissSound();
    else println("Javascript is null"); 
    
    printSummary() ;
  }
 
  double getForceAvg() 
  { 
    double result = forceSum/successes ; 
    return result ;
  }
  
  int getSuccesses() { return successes ; }
  
  double getAccuracy() 
  { 
    double result = (double)successes/(successes + misses) ;
    return result ;
  }
  int getMinusPoints() { 
    return minusPoints ;
  }
  double getAvgARTime() 
  {
    if(successes == 0) return 0 ;  
    double result = (double)anticipationReactionSum/successes ;
    return result ;
  }
  
  double getAvgDribbleARTime()
  {
    if(dribbleSuccesses == 0) return 0 ;
    double result = (double)dribbleARSum/dribbleSuccesses ; 
    return result ;   
  }
  
  void firstDribble()
  { 
    startDribble = millis() ;
  }
  
  void successDribble()
  {
    dribbleARSum += (millis() - startDribble) ; 
    dribbleSuccesses++ ;
    printSummary() ;
  }
  
  void setXTime(int xSec){ xTime = xSec ; }
  void startXprsTime(){ startXPRS = millis() ; }
  void endXprs()
  { 
    sumXPRS += (millis() - startXPRS - xTime);
    roundsXPRS++ ; 
  }
  
  double getXprs()
  { 
    double result ;
    if(roundsXPRS == 0) return 0 ;  
    else result = (double)sumXPRS/roundsXPRS ; 
    return result ;  
  }
  
  void printSummary()
  {
    if(javascript != null) 
    {
      javascript.postFeedback(successes, misses, minusPoints, getAccuracy(), getForceAvg(), getAvgARTime(), getAvgDribbleARTime(), getXprs()) ;  
    }
  }
}

class Room
{
  Wall [] walls ;
  int missingWall ;
  
  Room()
  {
    missingWall = -1 ;
    walls = new Wall[5] ;
    for (int i = 0; i < 5; i++ )
      setupWall( i ) ;
  }
  
  void removeWall(int wallID)
  {
    missingWall = wallID ;
  }
  
  void switchValid(int wallID)
  {
    walls[wallID].switchValid() ;
  }

  void drawRoom()
  { 
    for (int i = 0; i < 5; i++ ) 
      if (i != missingWall && walls[i].isValid())
        walls[i].drawWall() ;
  }

  boolean lightPad(int x, int y, color newColor)
  {
    int wallID = getWallID(x, y) ;
    if (wallID < 0)  return false ;
    walls[wallID].lightPad(x, y, newColor) ;
    return true ;
  }

  color colorOfClick(int x, int y)
  {
    int wallID = getWallID(x, y) ;
    if (wallID < 0)  return padOffColor ;

    return  walls[wallID].getPadColor(x, y) ;
  }

  Pad getPad(int x, int y)
  {
    int wallID = getWallID(x, y) ;
    if (wallID < 0)  return null ;

    return  walls[wallID].getPadFromCoordinates(x, y) ;
  }

  boolean turnOffPad(int x, int y)
  {
    int wallID = getWallID(x, y) ;
    if (wallID < 0) return false ;
    walls[wallID].turnOffPad(x, y) ;
    return true ;
  }

  boolean isWallValid(int wallID)
  {
    return walls[wallID].isValid() ;
  }

  Pad getRandomGroundPad()
  {
    int rX = int(random(4));
    int rY = int(random(6)) ;
    return walls[0].getPad(rX, rY) ;
  }

  void lightWall(int wallID, color newColor)
  {
    Wall myWall = walls[wallID] ;

    for (int r = 0; r < myWall.getRows (); r++)
      for (int c = 0; c < myWall.getCols (); c++)
        myWall.getPad(r, c).setColor(newColor) ;
  }

  Pad getPadRC(int wallID , int r , int c)
  {
    return walls[wallID].getPad(r,c) ;
  
  }
  
  ArrayList getUpperSquarePads (int wallID, int padNum, boolean isGroundBased, boolean needNorth)
  {

    ArrayList ret = new ArrayList();
    int r;
    int c;
    int incR = 0;
    int incC = 0;
    int forBot = 0 ;  //to get bottom row of square

    switch (wallID)
    {
    case NORTH:
      r = 0; 
      c = 0; 
      incR++ ; 
      forBot = 1 ; 
      break ;
    case SOUTH:
      r = 0; 
      c = NS_HEIGHT-1; 
      incR++; 
      forBot = -1 ; 
      break ;
    case EAST:
      r = EW_WIDTH-1; 
      c = 0; 
      incC++ ; 
      forBot = -1 ; 
      break ;
    case WEST:
      r = 0; 
      c = 0; 
      incC++ ; 
      forBot = 1 ; 
      break ;
    default:
      return ret;
    }

    while (r < NS_WIDTH - 1  && c < EW_HEIGHT - 1)
    {
      r += incR ;
      c += incC ;
    }  

    int highNum = (r==NS_WIDTH-1) ? NS_WIDTH : EW_HEIGHT ;
    int lowNum = 0 ;

    if (isGroundBased)
      if (needNorth) highNum = EW_HEIGHT/2 ;
      else lowNum = EW_HEIGHT/2 ;     

    int rng = int(random(highNum - padNum + 1 - lowNum)) + lowNum ;

    for (int i = 0; i < padNum; i++)
    {
      Pad current ;

      int newR = (r==NS_WIDTH-1) ? rng + i : r ;
      int newC = (r==NS_WIDTH-1) ? c : rng + i ; 
      current = walls[wallID].getPad(newR, newC) ; 

      if (current.isValid()) ret.add(current) ;  

      newR = (r==NS_WIDTH-1) ? rng + i : r+forBot ;
      newC = (r==NS_WIDTH-1) ? c+forBot : rng + i ; 
      current = walls[wallID].getPad(newR, newC) ;
      
      if (current.isValid()) ret.add(current)   ;
    }

    return ret;
  }

  ArrayList getBottomPads(int wallID, int padNum, boolean isGroundBased, boolean needNorth)
  {
    ArrayList ret = new ArrayList() ;
    int r ;
    int c ;
    int incR = 0 ; 
    int incC = 0 ;

    switch(wallID)
    {
    case NORTH: 
      r = 0 ; 
      c = NS_HEIGHT-1 ; 
      incR++ ; 
      break ; 
    case SOUTH: 
      r = 0 ; 
      c = 0 ; 
      incR++ ; 
      break ;
    case EAST: 
      r = 0 ; 
      c = 0 ; 
      incC++ ; 
      break ;
    case WEST: 
      r = EW_WIDTH-1 ; 
      c = 0 ; 
      incC++ ; 
      break ;
    default: 
      return ret ;
    }

    while (r < NS_WIDTH - 1 && c < EW_HEIGHT - 1)
    {
      r += incR ;
      c += incC ;
    }  

    int highNum = (r==NS_WIDTH-1) ? NS_WIDTH : EW_HEIGHT ;
    int lowNum = 0 ;

    if (isGroundBased)
      if (needNorth) highNum = EW_HEIGHT/2 ;
      else lowNum = EW_HEIGHT/2 ;     

    int rng = int(random(highNum - padNum + 1 - lowNum)) + lowNum ;

    for (int i = 0; i < padNum; i++)
    {
      Pad current ;

      int newR = (r==NS_WIDTH-1) ? rng + i : r ;
      int newC = (r==NS_WIDTH-1) ? c : rng + i ; 
      current = walls[wallID].getPad(newR, newC) ;  //NS

      if (current.isValid()) ret.add(current) ;
    }

    return ret ;
  }

  private int getWallID(int x, int y)
  {
    for (int i = 0; i < 5; i++)
      if (walls[i].isValid() && walls[i].contains(x, y))
        return i ;
    return -1 ;
  }

  private void setupWall(int wallID)
  {
    int xOffset = getXOffset(wallID) ;
    int yOffset = getYOffset(wallID) ;
    int padsWide = getPadsWide(wallID) ;
    int padsTall = getPadsTall(wallID) ;
    walls[wallID] = new Wall(xOffset, yOffset, padsWide, padsTall);
  }

  private int getPadsWide(int wallID)
  {
    if (wallID == NORTH || wallID == SOUTH)
      return NS_WIDTH ;
    else if (wallID == EAST || wallID == WEST)
      return EW_WIDTH ;
    else //ground
    return NS_WIDTH-2 ;
  }

  private int getPadsTall(int wallID)
  {
    if (wallID == NORTH || wallID == SOUTH)
      return NS_HEIGHT ;
    else if (wallID == EAST || wallID == WEST)
      return EW_HEIGHT ;
    else //ground
    return EW_HEIGHT-2 ;
  }

  private int getXOffset(int wallID)
  {
    int ret ;

    if (wallID == NORTH || wallID == SOUTH) 
      ret = ((width/2) - ((NS_WIDTH/2)*padSideLength)) ;     
    else if (wallID == EAST)
      ret = ((width/2) + ((NS_WIDTH/2)*padSideLength)) ; 
    else if (wallID == WEST)
      ret = ((width/2) - ((NS_WIDTH/2+EW_WIDTH)*padSideLength)) ;   
    else  //ground
    ret = ((width/2) - ((NS_WIDTH/2 - 1)*padSideLength)) ;

    return ret ;
  }

  private int getYOffset(int wallID)
  {
    int ret ;

    if (wallID == NORTH)
      ret = (height/2) - ((EW_HEIGHT/2 + NS_HEIGHT)*padSideLength) ;
    else if (wallID == SOUTH) 
      ret = (height/2) + ((EW_HEIGHT/2)*padSideLength) ;     
    else if (wallID == EAST || wallID == WEST)
      ret = (height/2) - ((EW_HEIGHT/2)*padSideLength) ;
    else  //ground
    ret = (height/2) - ((EW_HEIGHT/2-1)*padSideLength) ;

    return ret ;
  }
}

class Wall
{
  int topLeftX ;
  int topLeftY ;
  int rows ;
  int cols ;
  Pad [][] pads ;
  boolean valid ;

  Wall(int x, int y, int widthInPads, int heightInPads)
  {
    topLeftX = x ;
    topLeftY = y ;
    rows = widthInPads ;
    cols = heightInPads ;
    pads = new Pad[rows][cols] ;
    valid = true ;

    for (int i = 0; i < rows; i++ )
      for (int j = 0; j < cols; j++)
        pads[i][j] = new Pad(padSideLength, padOffColor, true) ;
  }

  void switchValid() { 
    valid = !valid ;
  }
  boolean isValid() { 
    return valid ;
  }
  int getRows() { 
    return rows ;
  }
  int getCols() { 
    return cols ;
  }
  Pad getPad(int r, int c) { 
    return pads[r][c] ;
  }

  boolean contains(int x, int y)
  {
    boolean withinX = (x <= (topLeftX + rows*padSideLength)) && (x >= topLeftX) ;
    boolean withinY = (y <= (topLeftY + cols*padSideLength)) && (y >= topLeftY) ;

    return withinX && withinY ;
  }

  color getPadColor(int x, int y)
  {
    int r = (int)((x - topLeftX)/padSideLength) ;
    int c = (int)((y - topLeftY)/padSideLength) ;
    return pads[r][c].getColor() ;
  }

  Pad getPadFromCoordinates(int x, int y)
  {
    int r = (int)((x - topLeftX)/padSideLength) ;
    int c = (int)((y - topLeftY)/padSideLength) ;
    return pads[r][c];
  }

  void drawWall()
  {
    for (int i = 0; i < rows; i++ )
      for (int j = 0; j < cols; j++)
        drawPad( i, j ) ;
  }

  void drawPad(int x, int y)
  {
    Pad padToDraw = pads[x][y] ;
    if (padToDraw.isValid())
    {
      int side = padToDraw.getSideLength() ;

      fill(padToDraw.getColor()) ;
      stroke(lineColor) ;
      rect( topLeftX + x*side, topLeftY + y*side, side, side ) ;
    }
  }

  void lightPad(int x, int y, color newColor)
  {
    x = (int)((x - topLeftX)/padSideLength) ;
    y = (int)((y - topLeftY)/padSideLength) ;
    pads[x][y].setColor(newColor) ;
  }

  void turnOffPad(int x, int y)
  {
    x = (int)((x - topLeftX)/padSideLength) ;
    y = (int)((y - topLeftY)/padSideLength) ;
    pads[x][y].setColor(padOffColor) ;
  }
}

class Pad
{
  int sideLength ;
  color myColor ;
  boolean valid ;

  Pad(int sideLength, color myColor, boolean valid)
  {
    this.sideLength = sideLength ;
    this.myColor = myColor ;
    this.valid = valid ;
  }

  int getSideLength() { 
    return sideLength ;
  }
  color getColor() { 
    return myColor ;
  }
  boolean isValid() { 
    return valid ;
  }
  void setColor(color newColor) { 
    myColor = newColor ;
  }
  void switchValid() { 
    valid = !valid ;
  }
}

interface JavaScript
{
  void postFeedback(int successesNum, int missesNum, int minusNum, double accuracyNum, double forceNum, double arTimeNum, double dribbleTimeNum);
  void playMissSound();
  void playSuccessSound();
  void playTest();
} 

JavaScript javascript = null ;
void setJavaScript(JavaScript js) { javascript = js ; }
