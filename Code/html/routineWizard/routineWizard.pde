//String routineCommand = "pa003000000";
//String warning ="" ;
//boolean isReadyToPlay = true ;

boolean customCoachRoutineMode = true;

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
  // Custom Coach Routine Mode
  if (customCoachRoutineMode)
  {
    if (isReadyToPlay)
    {
      if (!isPlaying)
      {
        newRoom = new Room();
        //routineCommand = "";
        myGame = new Game(newRoom,routineCommand);
        isPlaying = true ;
      } else if (isPlaying){
        setupDisplay() ;
        if (!myGame.isGameOver()) {
          newRoom.drawRoom();
        }
        else {
          background(101, 176, 152); 
          fill(255) ;
          textSize(32) ;
          text("Click start to play the chosen routine: " + warning, 30, 200, 540, 540) ;
        }
      }
    } else {
        background(101, 176, 152); 
        fill(255) ;
        textSize(32) ;
        text("Click start to play the chosen routine: " + warning, 30, 200, 540, 540) ;
    }
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
      //println("mouse Pressed: Calling handleSingleClick");
      myGame.handleSingleClick(mouseX, mouseY) ;
      firstClickTime = millis() ;
    } else  //second click
    {
      //println("mouse Pressed: Calling handleDoubleClick");
      myGame.handleDoubleClick(mouseX, mouseY , millis() - firstClickTime) ;
      isFirstClick = true ;
    }
  }
  
}


void setupImages() 
{
  soccerBall = loadImage("soccerBall.png") ;
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
  boolean coachFeedback;
  int gameTime;
  int startTime ;
  int routineTimeStart;
  int routineTime ;
  int rounds ;
  int roundsPlayed;
  
  Routine myRoutine ;
  Room myRoom;
  Wizard myWizard;
  boolean isRoutineGroundBased ;

  Game(Room r, String command)
  {
    println("Game Starting");
    isThisGameOver = false;
    isThisGameStarted = true;
    myRoom = r;
    rounds = -1; 
    roundsPlayed = 0;
    gameTime = 0;
    routineTime = 0;
    routineTimeStart = 0;
    createRoutine(command);
    coachFeedback = false;
    //playTest();
  }

  // Method that breaks the command and creates a routine
  void createRoutine(String command)
  {  
    String type = str(command.charAt(0));
    String difficulty = str(command.charAt(1));
    
    if (timeForWizard > 0) startTime = millis();

    isRoutineGroundBased = false; 
    if (type.equals(CHASE_ME)) myWizard = new CustomRoutineChaseWizard(myRoom,difficulty); 
    else if (type.equals(THREE_WALL_CHASE)) myWizard = new CustomRoutineThreeWallChaseWizard(myRoom,difficulty);
    else if (type.equals(HOME_CHASE))
    {
      println("Wizard not implemented");
    } else if (type.equals(FLY))  myWizard = new CustomRoutineFlyWizard(myRoom,difficulty);
    else if (type.equals(HOME_FLY)) 
    {
      println("Wizard not implemented");
    }
    else if (type.equals(GROUND_CHASE))
    {
      println("Wizard not implemented");
    }else if (type.equals(X_CUE))
    {
      println("Wizard not implemented");
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
    //println("double click");
    if ( customCoachRoutineMode )
    { 
      //fill(0, 0, 0);
      //text(rounds, 0, 150);
      //rounds--;
      //roundsPlayed++;
      //myWizard.handleInputWizard
      myWizard.handleInputWizard(x,y,2);
    }
  }
  
  void handleSingleClick(int x, int y)
  {
    // If creating Custom Coach Routines
    //println("single click");
    if (customCoachRoutineMode)
    {
        myWizard.handleInputWizard(x,y,1);
    }
    
  }
  void postGame() {}
  
  boolean checkStatus()
  {
    
    if (timeForWizard > 0) {
      fill(0, 0, 0);
      int timer = int((startTime+(timeForWizard*60000) - millis())/1000) ;
      int sec = int(timer % 60)  ;
      int min = int(timer / 60) ;
      String timerOutput = (sec < 10) ? min + ":0" + sec :  min + ":" + sec ;
      text("Time Left " + timerOutput, 10, 10, 160, 160);
      
      if ((millis() - startTime) > (timeForWizard*60000)) 
      { 
        fill(0, 0, 0);
        myWizard.generateString();
        isThisGameOver = true ;
        // To reset the game
        isReadyToPlay = false;
        isPlaying = false;
        return true;
      }
      //return false;
    }
    
    if ((roundsForWizard == 0) && (timeForWizard == 0)){
      fill(0, 0, 0);
      isThisGameOver = true ;
      myWizard.generateString();
      // To reset the game
      isReadyToPlay = false;
      isPlaying = false;
      return true;
    }
    
    if (roundsForWizard > 0)
      text("Rounds Left " + roundsForWizard, 10, 10, 160, 160);
    
    return false;
  }
  
  void startGame() 
  {
    isThisGameStarted = true;
    isThisGameOver = false;
  }
}

class Wizard
{
  boolean testBoolean;
  ArrayList padArrayList;
  boolean clickedPad;
  Room myRoom;
  String difficulty;
  int startTime;
  
  void startWizard() {
    clickedPad = false;
  }
  
  void validateSelectedPad(int wallID, int row, int column) {
     Pad current = myRoom.getPadRC(wallID,row,column);
     println("Validate selected Pad");
     if (myRoom.colorOfClickRC(wallID,row,column) == green){
       
     }
  }
  
  // validates if bottom wall was selected
  boolean validateBottomWall(int wallID, int row, int column){
      //println("Validate Bottom Wall");
      
      switch (wallID)
      {
      case NORTH:
        if (column == NS_HEIGHT - 1) return true;
        break ;
      case SOUTH:
        if (column ==  0) return true;
        break ;
      case EAST:
        if (row ==  0) return true;
        break ;
      case WEST:
        if (row ==  EW_WIDTH - 1) return true;
        break ;
      default:
        return false;
      break;
      }
      
      return false;
  }
  
  void addPadCoordinatesToArray(int wallID, int row, int column){
      padArrayList.add(wallID);
      padArrayList.add(row);
      padArrayList.add(column); 
    }
    
    void addPadCoordinatesToArray(int wallID, int row, int column){
      padArrayList.add(wallID);
      padArrayList.add(row);
      padArrayList.add(column); 
    }
  
  // Returns true if the wallID is north or south, false otherwise
    boolean identifyNorthSouthWall(int wallID){
      if ((wallID == NORTH) || (wallID == SOUTH)) {
        return true;
      } else {
        return false; 
      }
    }
    
    void lightOppositeWall(int wallID){
      int oppositeWallID;
      switch (wallID)
      {
         case NORTH:
           oppositeWallID = SOUTH;
           myRoom.lightWall(oppositeWallID,padOffColor);
           break; 
         case SOUTH:
           oppositeWallID = NORTH;
           myRoom.lightWall(oppositeWallID,padOffColor);
           break;
         case EAST:
           oppositeWallID = WEST;
           myRoom.lightWall(oppositeWallID,padOffColor);
           break;
         case WEST:
           oppositeWallID = EAST;
           myRoom.lightWall(oppositeWallID,padOffColor);
           break;
         default:
         break;
      }
      
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
  
  void generateString(){}
  
}

class CustomRoutineFlyWizard extends Wizard
{
    
    CustomRoutineFlyWizard(Room r, String d)
    {
      super.startWizard();
      myRoom = r; 
      difficulty = d;
      padArrayList = new ArrayList();
      //println("custom Fly");
      
    }
    
    void generatePlay(int wallID, int row, int column){
      
      ArrayList padArray = new ArrayList();
      
      if (wallID != GROUND) { // If you are not clicking a ground pad
            if (identifyNorthSouthWall(wallID)){  // North - South Walls
              if (northRoundsForWizard > 0){
                if (!validateBottomWall(wallID,row,column)){ // Validate if the clicked pad is not at the bottom of the wall
                  //println("Wall "+ wallID+ " Validated");
                  padArray = generatePadSquare(wallID,row,column);  // Generate the pad Square
                  handleDifficulty(ADVANCED,padArray);
                  lightOppositeWall(wallID);
                  northRoundsForWizard--;
                }
              }
            } else if (!identifyNorthSouthWall(wallID)) { // East - West Walls
              if (eastRoundsForWizard > 0) {
                if (!validateBottomWall(wallID,row,column)){
                  padArray = generatePadSquare(wallID,row,column);  // Generate the pad square
                  handleDifficulty(ADVANCED,padArray);
                  lightOppositeWall(wallID);  //Light opposite walls and set wallArray false
                  eastRoundsForWizard--;
                }
              }
            }
          }
    }
    
    void handleInputWizard(int x, int y, int singleClick){
      //println("handle Input");
      int wallID = myRoom.getWallID(x,y);
      int [] testArray = myRoom.getRowColumn(x,y);
      int row = testArray[0];
      int column = testArray[1];
      
      // If single Click was pressed
      if (singleClick == 1) {
        //println("first Click");
        generatePlay(wallID,row,column);
      }
      
    }
    
    void handleDifficulty(String difficulty, ArrayList row)
    {
      
      if (difficulty.equals(NOVICE))
      {
        setRowToColor(row,green); 
      } else if (difficulty.equals(INTERMEDIATE)) {
        setRowAndPadToColor(row, int(random(row.size())),red);
      } else if (difficulty.equals(ADVANCED)) {
        setRowAndPadToColor(row, int(random(row.size())),green);
      }
      
    }
    
    // Generate a Square Pad
    ArrayList generatePadSquare(int wallID, int row, int column){
      int r;
      int c;
      int incR = 0;
      int incC = 0;
      
      ArrayList result = new ArrayList();
      
      println("Generate Square Pad");
      
      switch (wallID)
      {
      case NORTH:
        r = ((row+1) <= (NS_WIDTH-1)) ? row : row-1;
        c = ((column+2) <= (NS_HEIGHT-1)) ? column : column-1;
        break ;
      case SOUTH:
        r = ((row+1) <= (NS_WIDTH-1)) ? row : row-1;
        c = ((column+1) <= NS_HEIGHT-1) ? column : column-1 ;
        break ;
      case EAST:
        r = ((row+1) <= (EW_WIDTH - 1)) ? row : row-1;
        c = ((column+1) <= (EW_HEIGHT-1)) ? column : column-1;
        break ;
      case WEST:
        r = ((row+2) <= (EW_WIDTH-1)) ? row : row-1;
        c = ((column+1) <= (EW_HEIGHT-1)) ? column : column-1;
        break ;
      default:
        break;
      }
      
      //println(r + ", " + c);
      
      Pad current;
      
      for (int i = 0; i<2 ; i++){
        for (int j = 0; j<2 ; j++){
          println((r+j) + ", " + (c+i));
          current = myRoom.getPadRC(wallID,r+j,c+i);
          addPadCoordinatesToArray(wallID,r+j,c+i);
          result.add(current);
          //current.setColor(green);
        }
      }
      
      return result;
    }
    
}

class CustomRoutineChaseWizard extends Wizard
{
    boolean selectedPad;   
    CustomRoutineChaseWizard(Room r, String d)
    {
       super.startWizard();
       println("Start Custom Routine Chase Wizard");
       myRoom = r;
       difficulty = d;
       padArrayList = new ArrayList();
       selectedPad = false;
    }
    
    void generatePlay(int wallID,int row, int column){
      
      ArrayList padArray = new ArrayList();
      
      if (wallID != GROUND) { // If you are not clicking a ground pad
            if (identifyNorthSouthWall(wallID)){  // North - South Walls
              if (northRoundsForWizard > 0){
                 if (validateBottomWall(wallID,row,column)){ // Validate if the clicked pad is at the bottom of the wall
                    padArray = generatePadLine(wallID,row,column);  // Generate the pad line
                    
                      myRoom.lightWall(wallID,padOffColor);
                      handleDifficulty(difficulty,padArray);
                      //lightOppositeWall(wallID);
                      //northRoundsForWizard--;
                    
                 }
              }
            } else if (!identifyNorthSouthWall(wallID)) { // East - West Walls
              if (eastRoundsForWizard > 0) {
                 if (validateBottomWall(wallID,row,column)){ // Validate if the clicked pad is at the bottom of the wall
                    padArray = generatePadLine(wallID,row,column);  // Generate the pad line
                    handleDifficulty(difficulty,padArray);
                    lightOppositeWall(wallID);  //Light opposite walls and set wallArray false
                    eastRoundsForWizard--;
                 }
              }
            }
          }
          
    }
    
    void handleInputWizard(int x, int y, int singleClick){     
      
      int wallID = myRoom.getWallID(x,y);
      int [] testArray = myRoom.getRowColumn(x,y);
      int row = testArray[0];
      int column = testArray[1];
      
      if (singleClick == 1) {
        //println("first Click");
        generatePlay(wallID,row,column);
      } else if (singleClick == 2) {
        
      }
      
    }
    
    // generates a bottom pad line in given wallID and row column pad index
    ArrayList generatePadLine(int wallID, int row, int column){
      
      int aux;
      int maxIndex ;
      Pad current;
      ArrayList result = new ArrayList();
      
      
      if (identifyNorthSouthWall(wallID)){
        aux = row;
        maxIndex = NS_WIDTH - 1;
        for (int i = 0; i < ROW_PAD_NUMBER ; i++){
          if ((aux+i) <= maxIndex){
            //println("B: " + (aux+i) + ", " + column);
            current = myRoom.getPadRC(wallID,(aux+i),column);
            addPadCoordinatesToArray(wallID,aux+i,column);
            //current.setColor(green);
          } else {
            aux--;
            //println("A: " + aux + ", " + column);
            current = myRoom.getPadRC(wallID,aux,column);
            addPadCoordinatesToArray(wallID,aux,column);
            //current.setColor(green);
          }
          result.add(current);
        }
        
      } else if (!identifyNorthSouthWall(wallID)) {
        aux = column;
        maxIndex = EW_HEIGHT - 1;
        for (int i = 0; i < ROW_PAD_NUMBER ; i++){
          if ((aux+i) <= maxIndex){
            if (!identifyNorthSouthWall(wallID)){
              //println("Ba: " + row + ", " + (aux+i));
              current = myRoom.getPadRC(wallID,row,aux+i);
              addPadCoordinatesToArray(wallID,row,aux+i);
              //current.setColor(green);
            }
          } else {
            aux--;
            if (!identifyNorthSouthWall(wallID)){
              //println("B: " + row + ", " + aux);
              current = myRoom.getPadRC(wallID,row,aux);
              addPadCoordinatesToArray(wallID,row,aux);
              //current.setColor(green);
            }
          }
          
          result.add(current);
        }
      }
      
      return result;
    } 
    
  void handleDifficulty(String difficulty, ArrayList row)
  {
    
    
    if (difficulty.equals(NOVICE))
    {
      setRowToColor(row,green); 
    } else if (difficulty.equals(INTERMEDIATE)) {
      setRowAndPadToColor(row, int(random(row.size())),red);
    } else if (difficulty.equals(ADVANCED)) {
      setRowAndPadToColor(row, int(random(row.size())),green);
    }
    
    
  }
    
}

class CustomRoutineThreeWallChaseWizard extends Wizard
{
    boolean selectedPad;
    ArrayList firstWall;
    ArrayList secondWall;
    ArrayList thirdWall;
    ArrayList firstWallCoordinates;
    ArrayList secondWallCoordinates;
    ArrayList thirdWallCoordinates;
    int wall1;
    int wall2;
    int wall3;
  
    CustomRoutineThreeWallChaseWizard(Room r, String d){
      super.startWizard();
      selectedPad = false;
      myRoom = r;
      difficulty = d;
      println("Three Wall Chase Wizard");
      firstWall = new ArrayList() ;
      secondWall = new ArrayList() ;
      thirdWall = new ArrayList() ;
      firstWallCoordinates = new ArrayList();
      secondWallCoordinates = new ArrayList();
      thirdWallCoordinates = new ArrayList();
      initializeRedPads();
      padArrayList = new ArrayList();
      padArrayList.add(routineType); // Adding routine type
      padArrayList.add(difficulty);  // Adding difficulty
      String r = (roundsForWizard < 10) ? ("0" + roundsForWizard ) : roundsForWizard ;
      padArrayList.add(r);           // Adding Rounds
      String m = (missingWall != -1) ? ("1" + missingWall) : ("0"+0);
      padArrayList.add(m);           // Adding missingWall
      String mi = (timeForWizard < 10) ? ("00" + timeForWizard) : ( "0"+timeForWizard ) ;
      padArrayList.add(mi);          // Adding minutes
      String sec = "00";
      padArrayList.add(sec);         // Adding seconds for timedRounds
      startTime = millis();
    }
  
  void handleInputWizard(int x, int y, int singleClick){ 
    
    int wallID = myRoom.getWallID(x,y);
    
    if (myRoom.colorOfClick(x,y) == red){
      int [] testArray = myRoom.getRowColumn(x,y);
      int row = testArray[0];
      int column = testArray[1];
      int numPads;
      Pad current;
        
      if (myRoom.colorOfClick(x,y) == red)
      {
        generatePlay(wallID);
      }
    }
    
  }
  
  void generatePlay(int wallID){
    
    if (wallID == wall1){
      //println("Clicking " + wallID + "and Wall1 = "+wall1);
      handleDifficulty(difficulty,firstWall,wall1);
      setRowToColor(secondWall,red);
      setRowToColor(thirdWall,red);
    } else if (wallID == wall2){
      //println("Clicking " + wallID + "and Wall2 = "+wall2);
      handleDifficulty(difficulty,secondWall,wall2);
      setRowToColor(firstWall,red);
      setRowToColor(thirdWall,red);
    } else if (wallID == wall3){
      //println("Clicking " + wallID + "and Wall3 = "+wall3);
      handleDifficulty(difficulty,thirdWall,wall3);
      setRowToColor(firstWall,red);
      setRowToColor(secondWall,red);
    }
    
    // Game is round based
    if (roundsForWizard > 0){
      roundsForWizard--;
    }
   
  }
  
  void generateString(){
    
    super.generateString();
    String result = "";
    
    // padArrayList i = 0 -> routineType
    // padArrayList i = 1 -> difficulty
    // padArrayList i = 2 -> rounds
    // padArrayList i = 3 -> missingWall
    // padArrayList i = 4 -> minutes
    // padArrayList i = 5 -> timedRounds (seconds)
    
    for (int i = 0; i<padArrayList.size(); i++){
      
      if (i<6) result += (String)(padArrayList.get(i)); //println("difficulty: "+(String)(padArrayList.get(0)));
      else{
        ArrayList row = (ArrayList)(padArrayList.get(i));
        for (int j = 0; j<row.size() ;j++){
          //println("wallID: "+(int)(row.get(j))+" -> "+(int)(row.get(j+1))+", "+(int)(row.get(j+2)));
          result += (int)(row.get(j));
        }
      } 
    }
    
    println("result: "+ result); 
  }
  
  void handleDifficulty(String difficulty, ArrayList row, int wallID)
  {
    if (difficulty.equals(NOVICE))
    {
      setRowToColor(row,green);
    } else if (difficulty.equals(INTERMEDIATE)) {
      setRowAndPadToColor(row, int(random(row.size())),red);
    } else if (difficulty.equals(ADVANCED)) {
      setRowAndPadToColor(row, int(random(row.size())),green);
    }
    
    if (wallID == wall1) padArrayList.add(firstWallCoordinates);
    else if (wallID == wall2) padArrayList.add(secondWallCoordinates);
    else if (wallID == wall3) padArrayList.add(thirdWallCoordinates);
    
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
      wall1 = wallID;
      firstWall.add(newPad);
      firstWallCoordinates.add(wallID);
      firstWallCoordinates.add(row);
      firstWallCoordinates.add(column);
    } else if (i == 1)  {
      wall2 = wallID;
      secondWall.add(newPad);
      secondWallCoordinates.add(wallID);
      secondWallCoordinates.add(row);
      secondWallCoordinates.add(column);
    } else if (i == 2) {
      wall3 = wallID;
      thirdWall.add(newPad);
      thirdWallCoordinates.add(wallID);
      thirdWallCoordinates.add(row);
      thirdWallCoordinates.add(column);
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

  Pad getPadRC(int wallID , int r , int c)
  {
    return walls[wallID].getPad(r,c) ;
  
  }
  
  color colorOfClickRC(int wallID,int r, int c)
  {
      Pad curr = getPadRC(wallID,r,c);   
      return curr.getColor();
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
  
  int [] getRowColumn(int x,int y) 
  {
    int wallID = getWallID(x, y) ;
    //if (wallID < 0)  return null ;

    return  walls[wallID].getRowColumn1(x, y) ;
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
  
  int [] getRowColumn1(int x, int y)
  {
    int [] result = new int [2] ;
    result[0] = (int)((x - topLeftX)/padSideLength) ;
    result[1] = (int)((y - topLeftY)/padSideLength) ;
    return result;
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


