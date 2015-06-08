//String routineCommand = "gn010000000";
//String warning ="" ;
//boolean isReadyToPlay = true ;

//pad attributes
color lineColor = color(0, 0, 0);
color padOffColor = color(255, 255, 255);
color green = color(53, 232, 44) ;
color red = color(240, 19, 19) ;
color blue = color(91, 134, 214) ;
color orange = color(243, 194, 80);
color yellow = color(252, 211, 7);
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

//constants difficulties chars
final String NOVICE = "n";
final String INTERMEDIATE = "i";
final String ADVANCED = "a";

//constansts groundChase
//final int GC_NOVICE_DIFFICULTY = 

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
}

void draw()
{
  if (isReadyToPlay)                                                        
    if (routineCommand.length() != 11)
    { 
      background(101, 176, 152); 
      textSize(32) ;
      fill(255) ;
      text("Make sure all options are filled out", 30, 30, 540, 540);
    } else if (!isPlaying)
    {
      myGame = new Game(newRoom, routineCommand) ;
      isPlaying = true ;
    } else
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
  } else
  {
    background(101, 176, 152); 
    fill(255) ;
    textSize(32) ;
    text("Click start to play the current routine: " + warning, 30, 30, 540, 540) ;
  }
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

  void generateStep() {
  }
  void startRoutine() {
  }    

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

      for (int i = 0; i < 2; i++)
      {
        //gets new list of bottom pads 
        ArrayList newPads = (i==0) ? myRoom.getBottomPads(wall1, 3, false, false) : myRoom.getBottomPads(wall2, 3, true, !isGroundPadNorth)  ;

        //Iterate through new bottom pads
        for (int j = 0; j < ROW_PAD_NUMBER; j++)
        {
          if (i == 0) row1.add((Pad)(newPads.get(j)));
          else row2.add((Pad)(newPads.get(j)));
        }
      }

      // Method that handles difficulty
      handleDifficulty(difficulty);

      stepTime = millis() ;
    }
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

      for (int i = 0; i < 2; i++)
      {
        // Locate ground pad position
        // Generate bottom pads until both are on the other side of the ground pad
        //gets new list of bottom pads 
        ArrayList newPads = (i==0) ? myRoom.getUpperSquarePads(wall1, 2, false, false) : myRoom.getUpperSquarePads(wall2, 2, true, !isGroundPadNorth);

        //Iterate through new bottom pads
        for (int j = 0; j < SQUARE_PAD_NUMBER; j++)
        {

          if (i == 0) row1.add((Pad)(newPads.get(j)));
          else row2.add((Pad)(newPads.get(j)));
        }
      }

      // Method that handles difficulty
      handleDifficulty(difficulty);

      stepTime = millis() ;
    }
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
   
    if(workingOnRow1) 
    {
      wall1 += ( wall1 > 2 ) ? -2 : 2; 
      row1 = myRoom.getUpperSquarePads(wall1, SQUARE_PAD_NUMBER/2, false, false);
      handleDifficulty(difficulty, row1);
    }
    else 
    {
      wall2 += ( wall2 > 2 ) ? -2 : 2;
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
   
    if(workingOnRow1)
    {
      wall1 += ( wall1 > 2 ) ? -2 : 2; 
      row1 = myRoom.getBottomPads(wall1, ROW_PAD_NUMBER, false, false) ;
      handleDifficulty(difficulty, row1);
    }
    else 
    {
      wall2 += ( wall2 > 2 ) ? -2 : 2;
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
    int wallID = 4 ;  //start at WEST wall ; W -> N -> E
    int toBeGreen = int(random(3)) ;  //decides green wall
    
    for (int i = 0; i < 3; i++)
    {
      //gets num of pads depending on wall 
      int numPads = (wallID == NORTH) ? NS_WIDTH - 2 : EW_HEIGHT/2 - 1; 
      int r ,  c , incR , incC ;
      //initializes start point based on row/column depending on wall
      if(wallID == NORTH){ r = 1 ; c = NS_HEIGHT - 1 ; }
      else if(wallID == EAST){ r = 0 ; c = 1 ; }
      else { r = EW_WIDTH - 1 ; c = 1 ; }
      //initializes increments for wall/column depending on wall
      incR = (wallID == NORTH) ? 1 : 0 ;
      incC = (wallID == NORTH) ? 0 : 1 ;
    
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
      if (walls[i].isValid())
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

  void gameCountdown()
  {
    for (int i = 4; i >= 0; i--)
    {
      drawRoom();
      lightWall(i, blue);
    }
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


