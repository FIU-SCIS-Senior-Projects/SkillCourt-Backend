import processing.serial.*;
import java.util.LinkedList;
import java.util.HashMap;
import java.util.Set;

color[][][] padColor;//wall,width,hight

//--------possible colors (legend)-----
color colorOff = color(160,160,160);
color highLight = color(128,128,128);
color colorOn = color(0,205,0);
//---------------------------------------------

//------Pad related--------------
boolean[][][] padOn;//wall,x,y
int [][][] padCornerX;
int [][][] padCornerY;
int padSize = 80;
//-----------------

//-----Cursor-------------
int curCornerX;
int curCornerY;

int coordWall;
int coordX;
int coordY;
//------------------------

//---------flags---------
boolean highLightFlag = false;
boolean arduinoMessageAvailable = false;
//boolean playing = false;
//--------------------------------

//----------Arduino comunication----------------------
Serial myPort;  // Create object from Serial class
String arduinoMessage;    // Data received from the serial port

//----------------------------------------------------

//--------------steps-------
public class step
{
  int startTime;
  int howLong;
  int endTime;
  int wall;
  int row;
  int column;
  
  public step(int sT, int hL, int w, int r, int c)
  {
    startTime = sT + millis()/1000;
    howLong = hL;
    endTime = startTime + howLong;
    wall = w;
    row = r;
    column = c;
  }
  
}
//------------------------



//-----------------Statistics---------------------
public class Statistics
{
  int numberSteps;
  HashMap<Integer, step> hits;//the key is the hit time
  LinkedList<Integer> misses;//store the time of the miss
   
  public Statistics(int n)
  {
    hits = new HashMap();
    misses = new LinkedList();
    numberSteps = n;
  }
}

Statistics stats;
//------------------------------------------------

//--------------Routine-------------------- 
    
public class Routine
{
   HashMap<Integer, LinkedList> toBeStarted;
   HashMap<Integer, LinkedList> toBeStoped;
   HashMap<Integer, LinkedList> toBeAlert;
   //LinkedList<step> toBeStarted;
   //LinkedList<step> toBeStoped;
   //LinkedList<step> toBeAlert;
   int timeAlert = 1000;//in milliseconds
   int lastTimed;
   String arduinoMessage;

   public Routine(String aM)
   {
     arduinoMessage = aM;
     toBeStarted = new HashMap<Integer, LinkedList>();
     toBeStoped = new HashMap<Integer, LinkedList>();
     toBeAlert = new HashMap<Integer, LinkedList>();
     processarduinoMessage();
     lastTimed = millis()/1000;//not needed
     displayContentOfMap(toBeStarted);

   }

   void handleClick()
   {
     eliminateFromToBeStoped();
   }
   
   void eliminateFromToBeStoped()
   {
     Set<Integer> s = toBeStoped.keySet();
     for(Integer i : s)//here
     {
       LinkedList<step> steps = toBeStoped.get(i);
       for(int j = 0; j < steps.size(); j++)
       {
         step st = steps.get(j);
         if(st.wall == coordWall && st.row == coordX && st.column == coordY)
         {
           println("++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
           toBeStoped.get(i).remove(j);
           //now handle statistics
         }
       }
       if(toBeStoped.get(i).size() == 0)
       {
         toBeStoped.remove(i);
       }
     }
   }
   
  
   void nextRound()
   {
     Integer time = millis()/1000;
     turnOn(time);
     turnOff(time);
   }

   void turnOff(int time)
   {
     if(toBeStoped.containsKey(time))
      {
        println("\n");
        println("To be stoped");
        displayContentOfMap(toBeStoped);

        LinkedList<step> listTemp = toBeStoped.remove(time);
        for(int i = 0; i < listTemp.size(); i++)
        {
          step temp = listTemp.get(i);
          fill(colorOff);
          rect(padCornerX[temp.wall][temp.row][temp.column], padCornerY[temp.wall][temp.row][temp.column], 80, 80);
          
          padOn[temp.wall][temp.row][temp.column] = false;
        }
      }
   }
   void turnOn(int time)
   {
     //add pads to toBeStopedList

     if(toBeStarted.containsKey(time))
     {

        LinkedList<step> listTemp = toBeStarted.remove(time);
        for(int i = 0; i < listTemp.size(); i++)
        {
          step temp = listTemp.get(i);
          fill(colorOn);
          rect(padCornerX[temp.wall][temp.row][temp.column], padCornerY[temp.wall][temp.row][temp.column], 80, 80);
          padOn[temp.wall][temp.row][temp.column] = true;

          if(toBeStoped.containsKey(temp.endTime))
          {
            //println("TESSSSSTTTT--------");
            //println(toBeStoped.get(time).size());
            toBeStoped.get(temp.endTime).add(temp);
            //println(toBeStoped.get(time).size());
          }
          else
          {
            LinkedList<step> l = new LinkedList();
            l.add(temp);
            toBeStoped.put(temp.endTime, l);
          }
        }
      }
   }

   void displayContentOfMap(HashMap<Integer, LinkedList> map)
   {

     Set<Integer> s = map.keySet();
     for(Integer i : s)//here
     {
       println("*****************************************************");
       println("Key = " + i + ":");
       LinkedList<step> steps = map.get(i);
       for(int j = 0; j < steps.size(); j++)
       {
         step st = steps.get(j);
         println("StartTime = " + st.startTime + " wall = " + st.wall + " row = " + st.row + " column " + st.column + " time = " + st.howLong + " endTime = " + st.endTime);

       }
     }
   }

  void processarduinoMessage()
  {
    String step = new String("");
    for(int i =0; i < arduinoMessage.length(); i+=9)
    {
        step = step + arduinoMessage.substring(i, i+9);
        int startTime = Integer.parseInt(step.substring(0,4));
        int wall = Integer.parseInt(step.substring(4,5));
        int row = Integer.parseInt(step.substring(5,6));
        int column = Integer.parseInt(step.substring(6,7));
        int howLong = Integer.parseInt(step.substring(7,9));
        print("StartTime = " + startTime + " wall = " + wall + " row = " + row + " column " + column + " time = " + howLong);
        println();

        step temp = new step(startTime, howLong, wall, row, column);

        if(toBeStarted.containsKey(startTime))
        {
          toBeStarted.get(startTime).add(temp);
        }
        else
        {
          LinkedList<step> listTemp = new LinkedList<step>();
          listTemp.add(temp);
          toBeStarted.put(startTime, listTemp);

        }

        step = new String("");
    }
  }
}

Routine routine;
//-------------------------------


void setup()
{
  //---------Initialize Serial port-------------------
  String portName = Serial.list()[0];
  println(portName);
  myPort = new Serial(this, portName, 9600); 
  //-----------------------------------------
  
  size(1000, 1000);
  background(255,255,255);
  
  padColor = new color[4][5][3];
  padOn = new boolean[4][5][3];
  padCornerX = new int[4][5][3];
  padCornerY = new int[4][5][3];
  
  for(int w = 0; w < 4; w++)
  {
    for(int x = 0; x < 5; x++)
    {
      for(int y = 0; y < 3; y++)
      {
        padOn[w][x][y] = false;
        padColor[w][x][y] = colorOff;
        
        if(w == 0)
        {
          fill(160,160,160);
          rect(300+x*80,60+y*80,80,80);
          padCornerX[0][x][y] = 300+x*80;
          padCornerY[0][x][y] = 60+y*80;   
        }
        else if(w == 1)
        {
          fill(160,160,160);
          rect(700+y*80,300+x*80,80,80);
          padCornerX[1][x][y] = 700+y*80;
          padCornerY[1][x][y] = 300+x*80;
        }
        else if(w == 2)
        {
          fill(160,160,160);
          rect(300+x*80,60+640+y*80,80,80);
          padCornerX[2][x][y] = 300+x*80;
          padCornerY[2][x][y] = 60+640+y*80;
          
        }
        else
        {
          fill(160,160,160);
          rect(60+y*80,60+240+x*80,80,80);
          padCornerX[3][x][y] = 60+y*80;
          padCornerY[3][x][y] = 60+240+x*80;
        }
        
      }
    }
  }
   
}





void draw()
{
   
  //int x = millis();
  //sendMessageToArduino("A"); 
  if(!arduinoMessageAvailable)
  {
    //check to see if arduinoMessage available
    arduinoMessageAvailable = getArduinoMessageTest();
    if(arduinoMessageAvailable)
    {
      routine = new Routine(arduinoMessage);
    }
  }
  else
  {
    //turn on list of pads
   // println("TEST+++++++++++++++++++++++++1");
    routine.nextRound();
   // println("TEST+++++++++++++++++++++++++2");
    //alert pads
    //pads off
  }
  
  
  if(highLightFlag)
  {
    if(padOn[coordWall][coordX][coordY])
      fill(colorOn);
    else
      fill(colorOff);
    
      
    
    rect(curCornerX, curCornerY, 80, 80);
    highLightFlag = false;
  }
  
  getCurCorner(mouseX, mouseY);
  
  if(highLightFlag)
  {
    if(padOn[coordWall][coordX][coordY])
      fill(76,153,0);
    else
      fill(highLight);
    rect(curCornerX, curCornerY, 80, 80);
  }
}




boolean getArduinoMessageTest()
{
  arduinoMessage = "000131005000133108000112201000124207000124007000124201000112103000131106000121008000124103000100008000124203000122008000123203000124106000103006000112102000131202000121107000121202000104101000124101000124106000124203000134207000124107000120207000103107000113205000122201000102207000111203000101206000103106000131002000120104000100207000134203000113002000102203000132103000110001000100107000120005000113002000134008000130205000121201000111205000210107000230101000220008000230107000230208000210002000201102000230002000211006000234105000212004000233107000200205000200206000213107000233004000224207000203204000224107000230107000204102000234004000203206000230008000230105000223203000230102000223002000222204000201102000212005000201108000231105000214101000212206000200201000234101000224201000213101000232002000220102000224106000234005000200002000223003000231202000220107000231208000201001000212207000204206000303004000320202000304104000334203000334008000301207000320208000321102000303102000302004000333207000322003000310206000331002000312003000320202000331005000323008000300207000334002000330206000330206000314206000330006000330201000322001000321101000333207000302203000314205000322105000303106000330102000312205000331105000330108000301202000314005000330208000304208000301208000311003000321202000333105000330206000300205000304101000303006000322103000322002000330108000302108000300104000321003000321105000331003000304002000320206000323105000411206000422205000411204000421204000432003000400208000430204000402208000414006000400104000404205000404008000424107000414003000400205000421201000402007000432005000413108000423203000402202000420005000422002000404101000413203000412004000432201000414104000422208000420202000433005000431003000430006000422202000400103000401005000412202000423106000433101000430203000403204000414102000402002000424103000434007000403208000403007000430106000430208000414108000410004000424206000420001000411104000423007000521005000523005000531208000522206000514204000501002000534208000533004000500002000500006000531104000520201000531102000500205000503103000501005000501005000532206000513102000503101000532008000510104000521103000522004000501105000501107000524202000534205000520204000504006000533002000531004000500102000500208000511105000534103000512001000520108000504101000532205000520001000510108000523008000501205000532004000503206000522103000532206000512201000502204000533107000603005000634108000631101000630205000614103000604103000633008000603207000634001000611106000633208000634002000622105000630006000603106000622207000633204000613002000621006000601104000623008000624205000612002000601008000603106000610007000611202000602206000611206000634005000622103000611205000620107000601205000602204000602002000604206000602002000632205000600008000630005000612005000630003000603203000600206000632006000623007000614003000623103000621106000602206000612002000631208000624102000612205000604006000614204000604206000621102000720006000724002000730205000711208000731201000731107000723103000714004000711202000711207000724204000703104000713202000731203000714002000700204000703003000720008000721003000713004000711006000714202000721102000730106000711107000721206000714108000721206000732203000720108000700105000701104000730006000722001000733106000721206000734006000721103000731107000721103000803206000822107000803107000821206000834006000820108000804002000814201000823001000813103000810104000810008000810104000811003000800004000820105000822104000800102000814001000823003000811001000832002000812204000814105000811201000832107000833002000823103000833007000801201000810001000834006000831108000810003000800008000831102000824101000824206000831206000824202000813005000832208000832202000801002000802005000810205000804102000822202000820001000834002000910008000901003000901101000930201000900002000912103000904203000912002000931005000930007000920002000910001000921003000934204000903105000903208000922108000910003000931006000922104000901103000922204000900108000930107000920203000930004000913104000912102000930203000932007000934205000921104000903001001032001001003005001034108001011004001034004001011002001014106001003006001013008001034008001024004001034103001023205001023106001000204001013004001034104001012205001012207001033207001004208001023104001034206001004004001001202001002001001013107001031101001032106001020006001011002001034007001002201001034207001014205001012008001004007001020003001010003001030005001030205001012001001000006001002108001021106001002003001033207001024205001014008001010207001023206001022001001014106";
  return true;
}

boolean getArduinoMessage()
{
  if ( myPort.available() > 0) 
  {  
    arduinoMessage = myPort.readStringUntil('\n'); 
    return true;
  }
  
  return false;
}

void sendMessageToArduino(String message)
{
  myPort.write(message);
}


//int coordX;
//int coordY;


void getCurCorner(int x, int y)
{
  if(x > 300 && x < 700 && y > 60 && y < 300)
  {
    //0
    coordWall = 0;
    coordX = (x - 300)/80;
    coordY = (y - 60)/80;
    
    curCornerX = ((x - 300)/80)*80+300;
    curCornerY = ((y - 60)/80)*80+60;
    highLightFlag = true;
  }
  else if(x > 700 && x < 940 && y > 300 && y < 700)
  {
    //1
    coordWall = 1;
    coordY = (x - 700)/80;
    coordX = (y - 300)/80;
    
    curCornerX = ((x - 700)/80)*80+700;
    curCornerY = ((y - 300)/80)*80+300;
    highLightFlag = true;
  }
  else if(x > 300 && x < 700 && y > 700 && y < 940)
  {
    //2
    coordWall = 2;
    coordX = (x - 300)/80;
    coordY = (y - 700)/80;
    curCornerX = ((x - 300)/80)*80+300;
    curCornerY = ((y - 700)/80)*80+700;
    highLightFlag = true;
  }
  else if(x > 60 && x < 300 && y > 300 && y < 700)
  {
    //3
    coordWall = 3;
    coordX = (y - 300)/80;
    coordY = (x - 60)/80;
    curCornerX = ((x - 60)/80)*80+60;
    curCornerY = ((y - 300)/80)*80+300;
    highLightFlag = true;
  }
}

void mousePressed() 
{
  println("Mouse Pressed");
  println("wall = " + coordWall + " row = " + coordX + " column = " + coordY);
  if(padOn[coordWall][coordX][coordY])
  {
    println("inside");
    padOn[coordWall][coordX][coordY] = false;
    routine.handleClick();//WORKING HERE
  }
  else
  {
    //Add missed click to stats
  }  
}


