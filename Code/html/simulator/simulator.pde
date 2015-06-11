String routineCommand = "xa010000000";
String warning ="" ;
boolean isReadyToPlay = true ;

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
final String CHASE_ME = "c" ;
final String THREE_WALL_CHASE = "t" ;
final String HOME_CHASE = "g";
final String HOME_FLY = "j";
final String FLY = "h";
final String GROUND_CHASE = "m";
final String X_CUE = "x";

//constants difficulties chars
final String NOVICE = "n";
final String INTERMEDIATE = "i";
final String ADVANCED = "a";

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
PImage tennisBall ;
Game myGame; 

double ballMass = 0.45;

//countdown
int startCountdownTime ;

//custom room
//int missingWall = 2;

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
    if (routineCommand.length() != 11)
    { 
      background(101, 176, 152); 
      textSize(32) ;
      fill(255) ;
      text("Make sure all options are filled out", 30, 30, 540, 540);
    }
    else if (countdown() && !isPlaying)
    {
      newRoom = new Room() ;
      myGame = new Game(newRoom, routineCommand) ;
      isPlaying = true ;
    } 
    else if(isPlaying)
    {  
      setupDisplay() ;
      if (!myGame.isGameOver()) newRoom.drawRoom();
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
    background(101, 176, 152); 
    fill(255) ;
    textSize(32) ;
    text("Click start to play the chosen routine: " + warning, 30, 200, 540, 540) ;
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
  if (myGame.isGameStarted())
  {
    if (isFirstClick || !(mouseX == prevX && mouseY == prevY))
    {
      prevX = mouseX ;
      prevY = mouseY ;
      isFirstClick = false ;
      myGame.handleSingleClick(mouseX, mouseY) ;
      firstClickTime = millis() ;
    } else  //second click
    {
      myGame.handleDoubleClick(mouseX, mouseY , millis() - firstClickTime) ;
      isFirstClick = true ;
    }
  }
}

void setupImages() 
{
  soccerBall = loadImage("images/soccerBall.png") ;
  tennisBall = loadImage("images/tennisBall.png") ;
  image(soccerBall, 30, 100) ;
  image(tennisBall, 80, 100) ;
  cursor(soccerBall, 18, 18) ;
}

void setupDisplay() 
{
  background(101, 176, 152);   //window bg color
  fill(0, 0, 0) ;  //next will be filled with black
  textSize(32) ;  
}

boolean countdown()
{
  if(startCountdownTime == 0) startCountdownTime = millis() ;
  background(101, 176, 152); 
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

class Game
{
  boolean isThisGameOver ;
  boolean isThisGameStarted ;
  int gameTime;
  int startTime ;
  int routineTime ;
  int rounds ;
  Routine myRoutine ;
  Room myRoom;
  boolean isRoutineGroundBased ;

  Game(Room r, String command)
  {
    isThisGameOver = false;
    isThisGameStarted = true;
    myRoom = r;
    rounds = -1; 
    gameTime = 0;
    routineTime = 0;
    createRoutine(command);
  }

  // Method that breaks the command and creates a routine
  void createRoutine(String command)
  {  
    String type = str(command.charAt(0));
    String difficulty = str(command.charAt(1));

    rounds = int(command.substring(2, 5));
    gameTime = int(command.substring(5, 9)) *60000;
    int timeBased = int(command.substring(9, 11));
    // Check if the game is timeBased or roundBased  
    if (rounds == 0) rounds = -1;
    else text(rounds, 100, 100);

    startTime = millis() ;
    isRoutineGroundBased = false; 
    if (type.equals(CHASE_ME)) myRoutine = new ChaseRoutine(myRoom, difficulty);
    else if (type.equals(THREE_WALL_CHASE)) myRoutine = new ThreeWallChaseRoutine(myRoom, difficulty);
    else if (type.equals(HOME_CHASE))
    {
      myRoutine = new HomeChaseRoutine(myRoom, difficulty);
      isRoutineGroundBased = true;
    } else if (type.equals(FLY))  myRoutine = new FlyRoutine(myRoom, difficulty); 
    else if (type.equals(HOME_FLY)) 
    {
      myRoutine = new HomeFlyRoutine(myRoom, difficulty);
      isRoutineGroundBased = true ;
    }
    else if (type.equals(GROUND_CHASE))
    {
      myRoutine = new GroundChaseRoutine(myRoom, difficulty); 
      isRoutineGroundBased = true ; 
    }else if (type.equals(X_CUE))
    {
      myRoutine = new xCueRoutine(myRoom, difficulty) ; 
      isRoutineGroundBased = true ;
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
    rounds--;

    // If you succesfully generatedStep then startTime = millis()
    if (routineTime > 0) startTime = millis();
  }
}

void handleSingleClick(int x, int y)
{
  //if (isRoutineGroundBased) myRoutine.handleInput(x, y, 1) ;
  
  if ( (isRoutineGroundBased) && (myRoutine.handleInput(x, y, 1, 0)) )
  { 
    fill(0, 0, 0);
    //text(rounds, 0, 150);
    rounds--;

    // If you succesfully generatedStep then startTime = millis()
    if (routineTime > 0) startTime = millis();
  }
  
}
void postGame() {}

boolean checkStatus()
{
  // Round Based game
  // if rounds == 0 then all rounds have passed and game is over
  if (rounds == 0)
  { 
    fill(0, 0, 0);
    isThisGameOver = true ;
    text("Round Game is Over", 0, 150);
    return true;
  }

  // gameTime > 0 if the game is timeBased
  if (gameTime > 0)
  {
  fill(0, 0, 0);
    int timer = int((startTime+gameTime - millis())/1000) ;
    int sec = int(timer % 60)  ;
    int min = int(timer / 60) ;
    String timerOutput = (sec < 10) ? min + ":0" + sec :  min + ":" + sec ;
    text("Time Left " + timerOutput, 10, 10, 160, 160);
   

   // Calculating game time in minutes
    if ((millis() - startTime) > gameTime) 
    { 
      fill(0, 0, 0);
      isThisGameOver = true ;
      text("Time Game is Over", 0, 150);
      return true;
    }
  }
   else
  {
    text("Rounds Left " + rounds, 10, 10, 160, 160);
  }
  
  // routineTime > 0 if game is timeRound based
  if (routineTime > 0)
  {
    if ( ((millis() - startTime)/60000) > routineTime )
    {
      fill(0, 0, 0);
      text("Sorry! took too long", 0, 150);
      startTime = millis();
      rounds--;
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

class Routine 
{
  Room myRoom ;
  String difficulty ;
  boolean groundPadPressed;
  Stats myStats ;
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
  boolean xCueCountdown;

  xCueRoutine(Room myRoom, String difficulty)
  {
    super.startRoutine();
    this.myRoom = myRoom;
    this.difficulty = difficulty; 
    groundPadPressed = false;
    secondGroundPadPressed = false;
    westWallPads = new ArrayList();
    northWallPads = new ArrayList();
    southWallPads = new ArrayList();
    eastWallPads = new ArrayList();
    successClicks = 0;
    xCueCountdown = false;
    generateStep();
  }
  
  boolean isGroundPadPressed(){
    return groundPadPressed; 
  }
  
  boolean isSecondGroundPadPressed(){
    return secondGroundPadPressed; 
  }

  void generateStep()
  {
    clearLitPads() ;  
    successClicks = 0 ;
    println("Generating Step for xCue routine");
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
      return false;
    } 
    else if ((groundPadPressed) && (!secondGroundPadPressed) && (myRoom.getWallID(x,y) == groundID) && ((myRoom.colorOfClick(x,y) == yellow) ) )
    {
      secondGroundPadPressed = true;
      generateStep();
      return false;
    } else if (clickNum == 2)
    {
      if (myRoom.colorOfClick(x,y) == green){
         
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
           groundPadPressed = false;
           secondGroundPadPressed = false;
           generateStep(); 
           return true;
        }
        
        return false;
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
    /*if (!xCueCountdown) 
    {
      println("Countdown is false");
      int startCountdown = millis();
      while((millis()-startCountdown) < 3000)
      {
        //println("Testing countdown");
      }
      xCueCountdown = true;
    }*/
    
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
    println("Generating cue walls");
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
      println(rowNumber+", "+i);
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
  
   GroundChaseRoutine(Room myRoom, String difficulty)
   {
     super.startRoutine();
     this.myRoom = myRoom;
     this.difficulty = difficulty;
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
     generateStep();
   }
   
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
         myStats.success() ; 
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
           if (redPad != null)   redPad.setColor(red);
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


  HomeChaseRoutine (Room myRoom, String difficulty) 
  {
    super.startRoutine() ;        
    this.myRoom = myRoom ;
    this.difficulty = difficulty ;
    row1 = new ArrayList() ;
    row2 = new ArrayList() ;
    myStats = new Stats() ; 
    successClicks = 0;    // keeps track on the number of succesfull clicks
    groundPadPressed = false;
    groundPad = null;
    generateStep();
  }
  boolean isGroundPadPressed() { 
    return groundPadPressed ;
  } 
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

  HomeFlyRoutine (Room myRoom, String difficulty) 
  {
    super.startRoutine() ;        
    this.myRoom = myRoom ;
    this.difficulty = difficulty ;
    row1 = new ArrayList() ;
    row2 = new ArrayList() ;
    myStats = new Stats() ; 
    successClicks = 0;    // keeps track on the number of succesfull clicks
    groundPadPressed = false;
    generateStep();
  }

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

  FlyRoutine (Room myRoom, String difficulty) 
  {
    super.startRoutine() ;        
    this.myRoom = myRoom ;
    this.difficulty = difficulty ;
    row1 = new ArrayList() ;
    row2 = new ArrayList() ;
    wall1 = int(random(4)) + 1;
    wall2 = (wall1 % 4) + 1;
    myStats = new Stats() ; 
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
    }
    else if (myRoom.colorOfClick(x, y) == padOffColor) myStats.miss() ;
    
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

  ChaseRoutine (Room myRoom, String difficulty) 
  {
    super.startRoutine() ;        
    this.myRoom = myRoom ;
    this.difficulty = difficulty ;
    row1 = new ArrayList() ;
    row2 = new ArrayList() ;
    wall1 = int(random(4)) + 1;
    wall2 = wall1 % 4 + 1;
    myStats = new Stats() ;  
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
    }
    else if(myRoom.colorOfClick(x, y) == padOffColor) myStats.miss() ;
    
    return false;
  }  
}

class ThreeWallChaseRoutine extends Routine 
{
  ArrayList greenPads ;
  ArrayList redPads ;

  ThreeWallChaseRoutine(Room myRoom, String difficulty) 
  {
    super.startRoutine() ;        
    this.myRoom = myRoom ;
    this.difficulty = difficulty ;
    greenPads = new ArrayList() ;
    redPads = new ArrayList() ;
    myStats = new Stats() ;
    generateStep();
  }

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
        else if(wallID == EAST){ r = 0 ; c = EW_HEIGHT/2 - 1 ; }
        else { r = EW_WIDTH - 1 ; c = EW_HEIGHT/2 - 1 ; }
      }
      else 
      {  
        if(wallID == SOUTH){ r = 1 ; c = 0 ; }
        else if(wallID == NORTH){ r = 1 ; c = NS_HEIGHT - 1 ; }
        else if(wallID == EAST){ r = 0 ; c = 2 ; }
        else { r = EW_WIDTH - 1 ; c = 2 ; }
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
  int anticipationReactionDribbling ; 
  int minusPoints;
  int lastSuccessAt ;
  boolean isFirstSuccess ;
  
  Stats() 
  {
    forceSum = 0 ;
    successes = 0 ; 
    misses = 0 ;
    minusPoints = 0 ;
    anticipationReactionSum = 0 ;
    anticipationReactionDribbling = 0 ;
    isFirstSuccess = true ;
  }

  void addForceDoubleClickTime(int deltaTime) 
  { 
    //forceSum += (30 + (double)1/(deltaTime-105)) * ballMass;
    forceSum += deltaTime;   
  }
  
  void success() 
  { 
    successes++ ; 
    
    if(isFirstSuccess) isFirstSuccess = false ;
    else anticipationReactionSum += (millis() - lastSuccessAt) ;
    
    lastSuccessAt = millis() ;
    printSummary();
  }
  
  void miss() { misses++ ; printSummary() ;}
  void minusPoint() { minusPoints++ ; printSummary() ;}
 
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
  double getAvgARTime() { 
    double result = (double)anticipationReactionSum/successes ;
    return result ;
  }
  
  void printSummary()
  {
    if(javascript != null) 
    {
      javascript.postFeedback(successes, misses, minusPoints, getAccuracy(), getForceAvg(), getAvgARTime()) ;  
    }
  }
}

class Room
{
  Wall [] walls ;

  Room()
  {
    walls = new Wall[5] ;
    for (int i = 0; i < 5; i++ )
      setupWall( i ) ;
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
  void postFeedback(int successesNum, int missesNum, int minusNum, double accuracyNum, double forceNum, double arTimeNum);
} 

JavaScript javascript = null ;
void setJavaScript(JavaScript js) { javascript = js ; }


