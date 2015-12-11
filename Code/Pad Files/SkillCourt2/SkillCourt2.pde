import processing.serial.*;
import java.util.LinkedList;
import ddf.minim.*;
//This is just for Testing purposes
int count = 0;//Remember to delete this and fix the Test function
//-------------------
//the room
room skillCourt;

//images
PImage soccerBall;
PImage soccerBall1;
PImage tennisBall;

//colors
color blue = color(0,0,205);
color grey = color(205,201,201);
color darkGrey = color(139,137,137);

colour colourGreen = new colour(0,254,0);
colour colourRed = new colour(255,0,0);
colour colourGray = new colour(205,201,201);
colour colourBlue = new colour(0,0,250);

//used to set up the room
Boolean masterPadFirstClick = false;
Boolean masterPadSecondClick = false;

//used to check if the microcontroller is connected or not
Boolean connection = false;

//playing if there is already 1 click
Boolean oneClick = false;
int firstClickTime = 0;
int firstW;
int firstR;
int firstC;

//toCheck if the 10 secs count has been done
boolean count10secs = false;
int  startRoutineTime;
int nextSec = 0;


//Routine Playing
play pl;
//....... keep adding

//Comunication with Arduino
Serial port;

//Beep sound
AudioPlayer soundPlayer;
Minim minim;

//The received command
String command;

//the pressure reading
int voltage;

void setup() {
  size(826, 826);
  background(255,255,255);
  skillCourt = new room();
  
  for(int i = 0; i < 5; i++)
  {
    buildSquares(i);
  }

  loadImages();
  //cursor(soccerBall);  
  writeSimulatorName(); 
  setUpSerialPort();
  
  minim = new Minim(this);
  soundPlayer = minim.loadFile("beep.mp3", 2048);//2048
  
  //soundPlayer.play();
 
  pl = new play();
  
}



void draw() 
{   
  if(masterPadSecondClick)
  {
    if(pl.playing())
    {
      if(pl.hasStarted())
      {
        //port = new Serial(this, "COM4", 9600);
        /*String[] portNames = Serial.list();
        for(int i = 0; i < portNames.length; i++)
        {
          println(portNames[i]);
        }*/
        //voltage = 0;
        //port.setDTR(true);
        //if(port.available() > 0)
        //{
        //voltage = port.read();
        //println("voltage = " + voltage);
        if(voltage > 0)
        {
          println("voltage = " + voltage);
          double massOfBall = 0.45;//in grams
          //println("Calling Play.hit()-----------------");
          step s = pl.hit(250,40,millis(), millis()-1, massOfBall);
            
          //println("x = " + mouseX);
          //println("y = " + mouseY);
          handleStep(s);
        }
        //port.clear();
        //}
        //delay(50);
        else
        {
          step s = pl.timeAction(millis());
          handleStep(s);
        }
        showTimer();
        voltage = 0;
        delay(200);
      }
      else
      {
        //wait10secs();
        if(!count10secs)
        {
          if((millis() - startRoutineTime)/1000 > nextSec)
          {
            
            boolean b = true;
            if(nextSec % 2 == 1)
            {
              b = false;
            }
            wait10SecsHelper(b);
            nextSec++;
          }
        }
        else
        {
          step s = pl.startPlaying(millis());
          handleStep(s);
          showTimer();
        }
        
      }
    }
    else
    {
      tryToStablishConnectionTest();
    }
  }
  
  draw4Lines();
  
}


void serialEvent(Serial p) { 
  String inString = p.readString();
  if(!connection)
  {
    if(inString.equals("A"))
    {
      port = p;
      connection = true;
      port.clear();
          for(int j = 0; j < 1000; j++)
          {
            port.write('A');
          }
      println("AAAAAAAAAAAAA");
    }
  }
  else if(!pl.playing())
  {
    println("Problem1");
    if(inString.equals("S"))
        command = "";
    else if(inString.equals("z"))
      command = command + "0";
    else if(inString.equals("E"))
    {
      pl = new play(command, skillCourt);
      startRoutineTime = millis();
      if(!pl.playing())
      {
        pl = new play();
        //println("The set up of the room does not meet the requirements to play the routine you chose");//println("Send message back to the microcontroller saying that the room does not have the requirements to play this specific routine");
        turnEntireRoomOn();
        if(!masterPadSecondClick)
        {
          
          masterPadSecondClick = true;
          pad pa = skillCourt.get_pad(0, 0, 0);
          pa.set_master(true);
        }
        pl = new play(command, skillCourt);
        startRoutineTime = millis();
        
      }
    }
    else
      command = command + inString;
    
    println("Problem2");
  }
  else if(pl.playing())
  {
    voltage = Integer.parseInt(inString);
  }
  println(inString); 
} 

void mousePressed()
{
  pad p = skillCourt.get_tentative_pad(mouseX, mouseY);
  
  if(p != null)
  {
    //used to set up the room
    if(!masterPadSecondClick && connection)
    {
      setUpRoom(p);    
    }
    
    //if there is any routine playing
    else if(pl.playing())
    {
      if(oneClick)//if there is one click already
      {
        oneClick = false;
        
        if(p.get_wall() == firstW && p.get_row() == firstR && p.get_column() == firstC)
        {
            //println("&&&&&&&&&&&&&&&&&&&&&&&&Click 2&&&&&&&&&&&&&&&&&&");
            //cursor(soccerBall);
            //println("Time difference = " + (millis() - firstClickTime));
            
            if(p.is_master())
            {            
              double massOfBall = 0.45;//in grams
              //println("Calling Play.hit()-----------------");
              step s = pl.hit(mouseX,mouseY,millis(), millis()-firstClickTime, massOfBall);
              
              //println("x = " + mouseX);
              //println("y = " + mouseY);
              handleStep(s);
            }
            else
            {
              double massOfBall = 0.45;//in grams
              //println("Calling Play.hit()-----------------");
              step s = pl.hit(mouseX,mouseY,millis(), millis()-firstClickTime, massOfBall);
              //println("x = " + mouseX);
              //println("y = " + mouseY);
              handleStep(s);
            }
        }
        else
        {
          //println("&&&&&&&&&&&&&&&&&&&&&&&&Click OUT&&&&&&&&&&&&&&&&&&");
          //cursor(soccerBall);
        }
      }
      else//if this is the first click
      {
        oneClick = true;
        firstClickTime = millis();
        firstW = p.get_wall();
        firstR = p.get_row();
        firstC = p.get_column();
        
        //println("&&&&&&&&&&&&&&&&&&&Click 1&&&&&&&&&&&&&&&&&&&&&&&");
        //cursor(soccerBall1);
        
      }
    }
    
    //println("w = " + p.get_wall() + " r = " + p.get_row() + " c = " + p.get_column());
  }
  
  //just testing
  //print3dCoordinates(mouseX,mouseY); 
}

//setup helper
void buildSquares(int w)
{
  int rows = 3;
  int columns = 5;
  
  
  if(w == 2)
  {
    rows = 5;
  }
  
  for(int r = 0; r < rows; r++)
  {
    for(int c = 0; c < columns; c++)
    {
      pad p = skillCourt.get_pad(w, r, c);
      rect(p.get_xTopLeftCorner(), p.get_yTopLeftCorner(), p.get_xDimension(), p.get_yDimension());
      
    }
  }
  
}

void loadImages()
{
  soccerBall = loadImage("soccerBall.png");
  image(soccerBall, 30, 160);
  soccerBall1 = loadImage("soccerBall1.png");
  
  tennisBall = loadImage("tennisBall.png");
  image(tennisBall, 80, 160);  
}

void writeSimulatorName()
{
  fill(0, 0, 0);
  textSize(32);
  text("SkillCourt\nSimulator", 30, 90);
  
}

void setUpSerialPort()
{
  String portName;
  
  for(int i = 0; i < Serial.list().length; i++) //not commented
    { //not commented
      //portName = "COM4"; 
      portName = Serial.list()[i];
      
      try
      {
       
        port = new Serial(this, portName, 9600);
        //need to do a checking send and receive info to make sure it is the device I am looking for
        //println(portName);
        int c = port.read();
        if(c == 'A')
        {
          port.clear();
          for(int j = 0; j < 100; j++) //1000
          {
            port.write('A');
          }
          connection = true;
          break; //not commented
        }
       
      }
      catch(Exception e)
      {
        
        port = null;
      }
    } //not commented
    
  //if(port == null)
  //{
    //fill(0, 0, 0);
    //textSize(20);
    //text("No Micro-controller", 620, 110);
    //connection = false;   
  //}
  
}

//draw helper
void showTimer()
{
  int secs = ((millis() - startRoutineTime)/1000) - 10;
  
  stroke(255, 255, 255);
  fill(255, 255, 255);
  rect(630, 650,200,200);
  
  fill(0, 0, 0);
  textSize(32);
  text(nf(secs/60, 2) + " : " + nf(secs%60,2), 675, 720);
  
}

//wait 10 secs
void wait10SecsHelper(boolean b)
{
          LinkedList<pad> l = skillCourt.getAllValid();
          colour c = colourGray;
          if(b)
            c = colourBlue;
          
          
          for(int i = 0; i < l.size(); i++)
          {
              changePadColor(l.get(i), c);
          }
          
          soundPlayer.play();
          soundPlayer = minim.loadFile("beep.mp3", 2048);
          
          
          if(((millis()-startRoutineTime)/1000) >= 10)
          {
            count10secs = !count10secs;
            nextSec = 0;
          }
}

void changePadColor(pad p, colour c)
{
  //println("Turn On");
  fill(c.getRed(), c.getGreen(), c.getBlue());
  rect(p.get_xTopLeftCorner(), p.get_yTopLeftCorner(),75,75);
  
  if(p.is_master())
  {
    println("MASTERRRRRRRRR");
    
    if(c.getRed()>0 && c.getGreen()>0 && c.getBlue()>0) //c.getRed()>0 && c.getGreen()>0 && c.getBlue()>0
    {
      println("OFF");
          
            port.write("o\n");      
      
    }
    else if(c.getRed()>0)
    {
      println("RED");
          
            port.write("r\n");
          
      //port.write("r\n");
    }
    else if(c.getGreen()>0)
    {
      println("GREEN");
          
            port.write("g\n");
          
      //port.write("g\n");
    }
    else if(c.getBlue()>0)
    {
          
            port.write("b\n");
          
      println("BLUE");
      //port.write("b\n");
    }
  }
}

void changePadColor2(pad p, colour c)
{
  //println("Turn On");
  fill(c.getRed(), c.getGreen(), c.getBlue());
  rect(p.get_xTopLeftCorner(), p.get_yTopLeftCorner(),75,75);
  
  if(p.is_master())
  {
    println("MASTERRRRRRRRR");
    
    //read pressure
    double voltage = 0;
    while(voltage < 1)
    {
      voltage = port.read();
    }
    
    if(voltage >= 1 || (c.getRed()>0 && c.getGreen()>0 && c.getBlue()>0)) //c.getRed()>0 && c.getGreen()>0 && c.getBlue()>0
    {
      println("OFF");
          
            port.write("o\n");
          
      
    }
    else if(c.getRed()>0)
    {
      println("RED");
          
            port.write("r\n");
          
      //port.write("r\n");
    }
    else if(c.getGreen()>0)
    {
      println("GREEN");
          
            port.write("g\n");
          
      //port.write("g\n");
    }
    else if(c.getBlue()>0)
    {
          
            port.write("b\n");
          
      println("BLUE");
      //port.write("b\n");
    }
  }
}

void handleStep(step s)
{
  
  LinkedList<pad> pon = s.getPadsOn();
  LinkedList<colour> con = s.getColourOn();
  LinkedList<pad> poff = s.getPadsOff();
  LinkedList<colour> coff = s.getColourOff();
  
  
  for(int i = 0; i < coff.size(); i++)
  {
    //if pad is master send message to microcontroller
    pad p = poff.get(i);
    colour c = coff.get(i);
    changePadColor(p, c); //erase 2
  }
  
  
  if(!s.isLastStep())
  {
      for(int i = 0; i < pon.size(); i++)
      {
        //if pad is master send message to microcontroller
        pad p = pon.get(i);
        colour c = con.get(i);
        changePadColor(p, c); //erase 2     
      }
      
      count10secs = false;
      
  }
  else
  {
    //send message to microcontroller saying that it is done
    //make sure everything is aware that routine is over
    //display/send statistics
    println("Routine is Over: ");
    println("Stats: " + s.getSummary());
    pl = new play();
    port.write(s.getSummary());
  }
  
  //printAllPadsValues();
}

void tryToStablishConnectionTest(){}

void tryToStablishConnectionTest1()
{
  String command;
  if(count == 0)
    command = "ha006000000";//"ci003000000";
  else if(count == 1)
    command = "hi000001000";
  else
    command = "ci000001000";
  
  pl = new play(command, skillCourt);
    startRoutineTime = millis();
    if(!pl.playing())
    {
      pl = new play();
      println("The set up of the room does not meet the requirements to play the routine you chose");//println("Send message back to the microcontroller saying that the room does not have the requirements to play this specific routine");
    }
  count++;
    
}


void draw4Lines()
{
  stroke(204, 102, 0);
  strokeWeight(2.0);
  line(75*3, 75*3, 75*8, 75*3);
  line(75*3, 75*3, 75*3, 75*8);
  line(75*8, 75*3, 75*8, 75*8);
  line(75*3, 75*8, 75*8, 75*8);
  stroke(0, 0, 0);
  strokeWeight(1.0);
}



//working here
void tryToStablishConnection()
{
  if(port.available() > 0)
  {
    String str = port.readStringUntil('o');
    if(str == null)
      return;
    
    //println(str.length());
    //println(str);
    
    if(str.equals("Hello"))
    {
      //println("Inside");
      port.write('H');
      //while(){}
    }
  }
}

//mouse pressed helper
void setUpRoom(pad p)
{
  if(!masterPadFirstClick)
      {
        fill(darkGrey);
        rect(p.get_xTopLeftCorner(), p.get_yTopLeftCorner(),75,75);
      
        masterPadFirstClick = true;
        
        p.set_master(true);//test if this is working
        p.set_valid(true);
      }
      else
      {
        if(p.is_master())
        {
          fill(grey);
          rect(p.get_xTopLeftCorner(), p.get_yTopLeftCorner(),75,75);
          
          /*double voltage = 0;
          while(voltage < 1)
          {
            if(0 < port.available())
            {
              voltage = port.read();
            }
          }
          
          if(voltage >= 1)
          {
            masterPadSecondClick = true;
          }*/
          masterPadSecondClick = true; //wasn't commented
        }
        else
        {
          fill(grey);
          rect(p.get_xTopLeftCorner(), p.get_yTopLeftCorner(),75,75);
          p.set_valid(true);
        }
      }
}


//Check 3d value
void print3dCoordinates(int x,int y)
{
  double[] td = skillCourt.from2dTo3d(x, y);
  if(td != null)
  {
    //println("x = " + td[0]);
    //println("y = " + td[1]);
    //println("z = " + td[2]);
    //println("-------------------------------------------------------------------");
  }
}

void printAllPadsValues()
{
  //println("*******************************************************");
  for(int w = 0; w < 5; w++)
  {
    //println("New Wall wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww");
    //println("WALL = " + w);
    int t = 3;
    if(w == 2)
      t = 5;
      
    for(int r = 0; r < t; r++)
    {
      //println("New Row rrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr");
      //println("ROW = " + r);
      for(int c = 0; c < 5; c ++)
      {
        //println("Column = " + c);
        pad p = skillCourt.get_pad(w, r, c);
        //println("Valid = " + p.get_valid());
        //println("Status = " + p.get_status());
        //println("Positive = " + p.isPositive());
      }
    }
  }
 //println("*******************************************************"); 
}

void delay(int time)
{
  int m = millis();
  
  while(millis() - m < time)
  {
  }
}

void turnEntireRoomOn()
{
          
          
          
  for(int w = 0; w < 5; w++)
  {
    
    int t = 3;
    if(w == 2)
      t = 5;
      
    for(int r = 0; r < t; r++)
    {
      
      for(int c = 0; c < 5; c ++)
      {
        pad p = skillCourt.get_pad(w, r, c);
        fill(grey);
        rect(p.get_xTopLeftCorner(), p.get_yTopLeftCorner(),75,75);
        p.set_valid(true);
        
      }
    }
  }
}
