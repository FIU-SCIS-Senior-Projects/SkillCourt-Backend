interface JavaScript
{
  String getDescription() ;
  void setDescription(String type) ;
  void setStepButton(boolean toFinish) ;
}
JavaScript javascript = null ;

//functions called from js
void setJavaScript(JavaScript js) { javascript = js ; }
void showStep(){ myWizard.showCurrentStep() ; } 
void setStepCreator(String type){ myWizard.setStepCreator(type) ; }
void editStep(){ myWizard.editStep() ; }
boolean finishStep(){ return myWizard.finishStep() ; }
boolean finishRound(){ return myWizard.finishRound() ; }
boolean finishRoutine(){ return myWizard.finishRoutine() ; }
void createStep(){ myWizard.createStep() ; }
void createRound(){ myWizard.createRound() ; }
int getCurrentStepNumber(){ return myWizard.getCurrentStepNumber() ; } 
int getCurrentRoundNumber(){ return myWizard.getCurrentRoundNumber() ; } 
int getNumberOfSteps(){ return myWizard.getNumberOfSteps() ; } 
int getNumberOfRounds(){ return myWizard.getNumberOfRounds() ; } 
void nextStep(){ myWizard.nextStep() ; }
void prevStep(){ myWizard.prevStep() ; }
void nextRound(){ myWizard.nextRound() ; }
void prevRound(){ myWizard.prevRound() ; }
void deleteStep(){ myWizard.deleteStep() ; }
void deleteRound(){ myWizard.deleteRound() ; }
String command(){ return myWizard.command() ; } 

//pad attributes
color gray = color(125) ;
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

//step types

final String STEP_SET = "set" ;
final String STEP_GROUND = "ground" ;

//step states
final int STEP_FINISHED = 1 ;
final int STEP_EDIT = 2 ;

//for game
Room newRoom ;
Wizard myWizard ;

void setup()
{
  size(600, 600) ;  
  newRoom = new Room() ;
  myWizard = new Wizard(newRoom) ;

  //testing
  frameRate(10) ;
}

void draw()
{
  background(101, 176, 152);   //window bg color
  if(!myWizard.isFinished()) newRoom.drawRoom() ;
  //else might want to do something when routine is finished
}

void mousePressed()
{ 
  myWizard.handleClick(mouseX, mouseY);
}

void setupDisplay() 
{
  background(101, 176, 152);   //window bg color
  fill(0, 0, 0) ;  //next will be filled with black
  textSize(32) ;
}

class Wizard
{
  boolean isWizardFinished ;
  Room myRoom ;
  ArrayList rounds ;
  StepCreator creator ;
  int roundIndex ;
  int stepIndex ;
  
  Wizard(Room myRoom)
  {
    this.myRoom = myRoom ;
    isWizardFinished = false ;  
    rounds = new ArrayList() ;  
    roundIndex = 0 ;
    stepIndex = 0 ; 
    createRound() ; //add an empty round with an empty step to end of rounds
  }
 
  void createRound()
  {
    Step firstStep = new Step() ;
    Round newRound = new Round() ;
    newRound.addStep(firstStep) ;
    rounds.add(newRound) ;
  }
  
  void createStep()
  {
    Round current = (Round)(rounds.get(roundIndex)) ;
    Step s = new Step() ;
    current.addStepAfter(s, stepIndex) ;
  }
  
  void showCurrentStep()
  {
      Step current = getCurrentStep() ;
      String type = current.getType() ;
      color wallColor = (type == STEP_GROUND) ? gray : padOffColor ;
      color groundColor = (type == STEP_GROUND) ? padOffColor : gray ; 
      myRoom.lightWall(0, groundColor) ;
      for(int i = 1 ; i < 5 ; i++) myRoom.lightWall(i, wallColor) ; 
      if(current.isFinished()) current.drawStep() ;
      
  }
  
  void correctStepView()
  {
    creator.erase() ;
    Step s = getCurrentStep() ;
    if(s.isFinished()) 
    {
      showCurrentStep() ;
      javascript.setStepButton(false) ;
      javascript.setDescription(s.getType());
    }
    else
    {
      setStepCreator(javascript.getDescription()) ;
      javascript.setStepButton(true) ;
    }
  }
  
  void eraseFinishedStep()
  {
    Step s = getCurrentStep() ;
    if(s.isFinished()) s.erase() ;
  }
  
  void deleteStep()
  { 
    eraseFinishedStep();
    Round r = getCurrentRound() ;
    int rsize = r.getStepAmount() ;
    r.removeStepAt(stepIndex) ;
    if(stepIndex == rsize - 1) stepIndex-- ;
    correctStepView() ;
  }
  
  void deleteRound()
  { 
    eraseFinishedStep();
    int gameSize = getNumberOfRounds() ;
    rounds.remove(roundIndex) ; 
    if(roundIndex == gameSize - 1) roundIndex-- ; 
    stepIndex = 0 ; 
    correctStepView() ;
  }
  
  void nextStep()
  { 
    eraseFinishedStep();
    stepIndex++ ;
    correctStepView() ;
  }
  
  void prevStep()
  { 
    eraseFinishedStep();
    stepIndex-- ;
    correctStepView() ;
  }

  void nextRound()
  { 
    eraseFinishedStep();
    roundIndex++ ;
    stepIndex = 0 ;
    correctStepView() ;
  }
  
  void prevRound()
  { 
    eraseFinishedStep();
    roundIndex-- ;
    stepIndex = 0 ;
    correctStepView() ;
  }
  
  void setStepCreator(String type)
  { 
      switch(type)
      {
        case STEP_SET:  
          creator = new SetTargetCreator(myRoom, getCurrentStep()) ; 
          break ;
        case STEP_GROUND: 
          creator = new GroundTargetCreator(myRoom, getCurrentStep()) ; 
          break ;
      }
  }
  
  void editStep()
  {
    setStepCreator(getCurrentStep().getType()) ;
  }
  
  boolean finishRound()
  {
      return getCurrentRound().isFinished() ;
  }
  
  boolean finishStep()
  {
    if(creator.isReady())
    {
      creator.finishStep() ; 
      return true ;
    }
    return false; 
  }
  
  boolean finishRoutine()
  {
    for(int i = 0 ; i < rounds.size() ; i++)
      if(!((Round)(rounds.get(i))).isFinished()) return false;
    
    return true ;
  } 
  
  boolean isFinished()
  {
    return isWizardFinished ;
  }
  
  void handleClick(int x, int y)
  {
    if(creator != null) creator.handleClick(x,y) ;
  }
  
  int getRoundAmount(){ return rounds.size() ; }
  
  private Round getCurrentRound()
  { 
    Round current = (Round)(rounds.get(roundIndex)) ;
    return  current ;
  }
  private Step getCurrentStep(){ return getCurrentRound().getStep(stepIndex) ; }
  
  String command()
  {
    String comm = "U" ;
    
    int roundNum = getRoundAmount() ;
    comm += ((roundNum > 9) ? "" : "0") + roundNum;
    
    for(int n = 0 ; n < roundNum ; n++)
    {
      Round currentRound = (Round)(rounds.get(n)) ;
      int stepNum = currentRound.getStepAmount() ;
      comm += "R_" + ((stepNum > 9) ? "" : "0") +  stepNum ;
      
      for(int s = 0 ; s < stepNum ; s++) 
      {
        Step currentStep = currentRound.getStep(s) ;
        int targetNum = currentStep.getTargetAmount() ;
        
        for(int t = 0 ; t < targetNum ; t++)
        {
          comm += "*" ;
          Target currentTarget = currentStep.getTargetAt(t) ;
          int padNum = currentTarget.getPadAmount() ;
          
          for(int p = 0 ; p < padNum ; p++)
          {
            Pad currentPad = currentTarget.getPadAt(p) ;
            comm += currentPad.getW() ;
            comm += currentPad.getR() ;
            comm += currentPad.getC() ;
          }
        }
        
        switch(currentStep.getType())
        {
          case STEP_SET: comm += "SN" ; break;
          case STEP_GROUND: comm += "SG" ; break;
          default: comm += "ERROR" ; 
        }
      }
    }
    
    return comm; 
  }
  
  int getCurrentStepNumber(){ return stepIndex + 1 ; }
  int getCurrentRoundNumber(){ return roundIndex + 1 ; }
  int getNumberOfSteps(){ return  getCurrentRound().getStepAmount() ; }
  int getNumberOfRounds(){ return rounds.size() ; }
}


class Round
{
  ArrayList steps ;
  
  Round()
  {
    steps = new ArrayList() ;
  }
  
  Step getStep(int i)
  { 
    Step result = (Step)(steps.get(i)) ;
    return result ;
  }
  void removeStepAt(int i){ steps.remove(i) ; }
  void addStep(Step s){ steps.add(s) ; }
  
  void addStepAfter(Step s, int leftStep)
  {
    ArrayList sumList = new ArrayList() ;
    for(int i = 0 ; i < steps.size() ; i++)
    {
      sumList.add(steps.get(i)) ;
      if(i == leftStep) sumList.add(s) ;        
    }
    steps = sumList ;
  }
  
  void addStepBefore(Step s, int rightStep)
  {
    ArrayList sumList = new ArrayList() ;
    for(int i = 0 ; i < steps.size() ; i++)
    {
      sumList.add(steps.get(i)) ;
      if(i+1 == rightStep) sumList.add(s) ;        
    }
    steps = sumList ;
  }
  
  boolean isFinished()
  {
    for(int i = 0 ; i < steps.size() ; i++)
      if(!((Step)(steps.get(i))).isFinished()) return false;
    
    return true ;
  }
  int getStepAmount(){ return steps.size() ; }
}

class Step
{
    ArrayList targets ;
    String type ;
    boolean finished ;
    
    Step(String type)
    {
      Step() ;
      this.type = type ;
      finished = false; 
    }
    
    Step()
    {
      targets = new ArrayList() ; //might not need this? too scared to remove
    }
    
    ArrayList getTargets(){ return targets ; }
    int getTargetAmount(){ return targets.size() ; } 
    Target getTargetAt(int i)
    {
        Target t = (Target)(targets.get(i)) ;
        return t ;
    }
    String getType(){ return type ; } 
    void setType(String type){ this.type = type ; }
    void addTarget(Target t){ targets.add(t) ; }
    void finish(){ finished = true ; }
    void edit(){ finished = false ; }
    void addTargetAfter(Target t, int leftT) 
    {
      ArrayList sumList = new ArrayList() ;
      for(int i = 0 ; i < targets.size(); i++)
      {
        sumList.add(targets.get(i)) ;
        if(i == leftT) sumList.add(t) ;
      }
      
      targets = sumList; 
    }
    
    
    void addTargetBefore(Target t, int rightT) 
    {
      ArrayList sumList = new ArrayList() ;
      for(int i = 0 ; i < targets.size(); i++)
      {
        sumList.add(targets.get(i)) ;
        if(i == rightT - 1) sumList.add(t) ;
      }
      
      targets = sumList; 
    }
    
    boolean isEmpty()
    {
      return targets.size() == 0 ; 
    }
    
    boolean isFinished()
    {
      return finished ;
    }
    
    void clearTargets()
    {
      for(int i = 0 ; i < targets.size() ; i++) targets.remove(0) ;  
    }
    
    void setTargetsToColor(color stepColor)
    {
      for(int i = 0 ; i < targets.size() ; i++)
        ((Target)(targets.get(i))).setColor(stepColor) ; 
    }
    void drawStep()
    {
      color stepColor = (type == STEP_GROUND) ? yellow : green ;
      setTargetsToColor(stepColor) ;
    }
    
    void erase()
    {
      setTargetsToColor(padOffColor) ;
    }
}

interface StepCreator
{
  void handleClick(int x, int y) ;  //handles click appropriately
  void finishStep() ;       //finishes step
  void erase() ;         //sets all on pads to off
  boolean isReady() ;    //step is ready to be finished
}

class SetTargetCreator implements StepCreator
{
  ArrayList targets ;
  Room myRoom ;
  Step s ;
  
  SetTargetCreator(Room r, Step s)
  {
    this.s = s ; 
    targets = (s.isFinished()) ? s.getTargets() : new ArrayList() ; 
    s.edit() ;
    myRoom = r ;
    myRoom.lightWall(0, gray) ;
    for(int i = 1 ; i < 5 ; i++) myRoom.lightWall(i, padOffColor) ; 
    if(s.isFinished) s.drawStep() ;
  }
  
  void handleClick(int x, int y)
  {
    if(!s.isFinished() && myRoom.getWallID(x,y) != 0)
    {
      Pad selected = myRoom.getPad(x,y) ;   //gets selected pad
      if(selected.getColor() == green) 
      {  
        selected.setColor(padOffColor) ;
        removeFromWall(myRoom.getWallID(x,y), selected); 
      }
      else
      {
        selected.setColor(green) ;
        addToATarget(myRoom.getWallID(x,y), selected) ;
      }           
    }
  }
  
  private void removeFromWall(int wallID, Pad p)
  {
    for(int i = 0 ; i < targets.size() ; i++)
    {
      Target t = (Target)(targets.get(i)) ;
      if(t.getWallID() == wallID) t.removePad(p) ;
    }  
  }
  
  private void addToATarget(int wallID, Pad p)
  {
    int i ;
    for(i = 0 ; i < targets.size() ; i++)
    {
      Target t = (Target)(targets.get(i)) ;
      if(t.getWallID() == wallID) 
      {
        t.addPad(p) ;
        return ;
      }
    }  
    //if target does not exist for wall
    javascript.console.log("target does not exist") ;
    Target newT = new Target(wallID) ;
    newT.addPad(p);
    targets.add(newT) ;     
  }
  
  void finishStep()
  {
    s.clearTargets() ;
    for(int i = 0 ; i < targets.size() ; i ++)
    {
      Target t = (Target)(targets.get(i));
      if(!t.isEmpty()) s.addTarget(t) ;
    }
    s.finish() ;
    s.setType(STEP_SET) ;
    return s ;
  }
  
  void erase()  
  {
    if(s.isFinished()) s.erase() ;
    else 
    {
      for(int i = 0 ; i < targets.size() ; i ++)
        ((Target)targets.get(i)).setColor(padOffColor) ;
    }
  } 
  
  boolean isReady()
  {  
    for(int i = 0 ; i < targets.size() ; i ++)
    {
      Target t = (Target)targets.get(i) ;
      if(!t.isEmpty()) return true ;
    }
    return false;
  }
}

class GroundTargetCreator implements StepCreator
{
  Target target ;
  Room myRoom ;
  Step s ;
  
  GroundTargetCreator(Room r, Step s)
  {
    this.s = s ; 
    target = (s.isFinished()) ? s.getTargetAt(0) : new Target(0) ; 
    s.edit() ;
    myRoom = r ;
    myRoom.lightWall(0, padOffColor) ;
    for(int i = 1 ; i < 5 ; i++) myRoom.lightWall(i, gray) ; 
    if(s.isFinished()) s.drawStep() ;
  } 
  
  void handleClick(int x, int y) 
  {
    if(!s.isFinished() && myRoom.getWallID(x,y) == 0)
    {
      erase() ;                             //turns off our target
      target.clearPads() ;                  //removes all pads from our target
      Pad selected = myRoom.getPad(x,y) ;   //gets selected pad
      selected.setColor(yellow) ;            //turns it on
      target.addPad(selected) ;             //adds pad to our target
    }
  }
  
  void finishStep() 
  {
    //if(s.isFinished()) s.clearTargets ; 
    s.clearTargets() ;
    s.addTarget(target) ;
    s.finish() ;
    s.setType(STEP_GROUND) ;
    return s ;
  }
 
  void erase() 
  {  
    if(s.isFinished()) s.erase() ;
    else target.setColor(padOffColor) ;
  }
  
  boolean isReady()
  {
    return !target.isEmpty() ;  
  }
}

class Target
{
    ArrayList pads ;
    int wallID ;

    Target(int wallID)
    {
      pads = new ArrayList() ;    
      this.wallID = wallID;
    }
    
    Pad getPadAt(int i)
    { 
      Pad p =  (Pad)(pads.get(i)) ; 
      return p ;
    }
    int getPadAmount(){ return pads.size() ; }
    boolean isEmpty(){ return pads.size() == 0 ; }
    ArrayList getPads(){ return pads ; }
    int getWallID(){ return wallID ; }
    
    void removePad(Pad p)
    {
      for(int i = 0 ; i < pads.size() ; i++) 
      {
        Pad current = (Pad)(pads.get(i)) ;   
        if(current == p) pads.remove(i) ;
      }
    }
    
    void setColor(color c)
    {
      for(int i = 0 ; i < pads.size() ; i++) ((Pad)pads.get(i)).setColor(c) ;  
    } 
    
    void clearPads()
    {
      for(int i = 0 ; i < pads.size() ; i++) pads.remove(0) ;
    }
    
    void addPad(Pad p)
    {
      pads.add(p) ;
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
  
  void lightWall(int wallID, color newColor)
  {
    Wall myWall = walls[wallID] ;

    for (int r = 0; r < myWall.getRows (); r++)
      for (int c = 0; c < myWall.getCols (); c++)
        myWall.getPad(r, c).setColor(newColor) ;
  }

  
  void drawRoom()
  { 
    for (int i = 0; i < 5; i++ ) walls[i].drawWall() ;
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

    return  walls[wallID].getRowColumn1(x, y) ;
  }
  
  boolean turnOffPad(int x, int y)
  {
    int wallID = getWallID(x, y) ;
    if (wallID < 0) return false ;
    walls[wallID].turnOffPad(x, y) ;
    return true ;
  }
  
  int getWallID(int x, int y)
  {
    for (int i = 0; i < 5; i++)
      if (walls[i].contains(x, y))
        return i ;
    return -1 ;
  }

  private void setupWall(int wallID)
  {
    int xOffset = getXOffset(wallID) ;
    int yOffset = getYOffset(wallID) ;
    int padsWide = getPadsWide(wallID) ;
    int padsTall = getPadsTall(wallID) ;
    walls[wallID] = new Wall(xOffset, yOffset, padsWide, padsTall, wallID);
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
  int wallID ;

  Wall(int x, int y, int widthInPads, int heightInPads, int wallID) 
  {
    topLeftX = x ;
    topLeftY = y ;
    rows = widthInPads ;
    cols = heightInPads ;
    pads = new Pad[rows][cols] ;
    this.wallID = wallID ;

    for (int i = 0; i < rows; i++ )
      for (int j = 0; j < cols; j++)
        pads[i][j] = new Pad(padSideLength, padOffColor, wallID, i, j) ;
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
    if(wallID == 0)
    {
      fill(255/2) ;
      rect(topLeftX - padSideLength , topLeftY - padSideLength, padSideLength*NS_WIDTH, padSideLength*EW_HEIGHT) ; 
    }
    for (int i = 0; i < rows; i++ )
      for (int j = 0; j < cols; j++)
        drawPad( i, j ) ;
  }

  void drawPad(int x, int y)
  {
    Pad padToDraw = pads[x][y] ;
    int side = padToDraw.getSideLength() ;

    fill(padToDraw.getColor()) ;
    stroke(lineColor) ;
    rect( topLeftX + x*side, topLeftY + y*side, side, side ) ;
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
  int wallID ;
  int row ;
  int column ;

  Pad(int sideLength, color myColor, int wallID, int row, int column)
  {
    this.sideLength = sideLength ;
    this.myColor = myColor ;
    this.wallID = wallID ;
    this.row = row ;
    this.column = column ;
  }
  int getW(){ return wallID ; }
  int getR(){ return row ; }
  int getC(){ return column ; }
  int getSideLength() { 
    return sideLength ;
  }
  color getColor() { 
    return myColor ;
  }
  void setColor(color newColor) { 
    myColor = newColor ;
  }
}


