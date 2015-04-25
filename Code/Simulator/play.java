import processing.core.*;


public class play
{
    char type;
    //check if any routine is active
    boolean playing = false;
    
    //check if the first step already happened
    boolean started = false;
    
    //possible routines
    chaseRoutine cr;
    lowestRowRoutine lr;
    higherRowRoutine hr;
    groundRoutine gr;
    
    public play(String command, room scr)
    {
      type = command.charAt(0);
      char level = command.charAt(1);
      int rounds = Integer.parseInt(command.substring(2,5));
      int timer = Integer.parseInt(command.substring(5,9)) * 1000;
      int timebased = Integer.parseInt(command.substring(9,11));
      
      switch(type)
      {
        case 'c':
          cr = new chaseRoutine();
          if(cr.validateRoom(scr))
          {
            cr = new chaseRoutine(level,rounds,timer,scr);
            playing = true;
          }  
          break;
        
          case 'l':
          lr = new lowestRowRoutine();
          if(lr.validateRoom(scr))
          {
            lr = new lowestRowRoutine(level,rounds,timer,scr);
            playing = true;
          }  
          break;
        
        case 'h':
          hr = new higherRowRoutine();
          if(hr.validateRoom(scr))
          {
            hr = new higherRowRoutine(level,rounds,timer,scr);
            playing = true;
          }  
          break;
        
        case 'g':
          gr = new groundRoutine();
          if(gr.validateRoom(scr))
          {
            gr = new groundRoutine(level,rounds,timer,scr);
            playing = true;
          }  
          break;
        
        default: 
          playing = false;
          break;
        
      }
      
      
    }
    
    public play()
    {
    }
    
    //time in milliseconds
    public step hit(int x, int y, int time, int clickTimeDiff, double massOfBall)
    {
      switch(type)
      {
        case 'c':
          return cr.hit(x,y,time, clickTimeDiff, massOfBall);
        case 'l':
          return lr.hit(x,y,time, clickTimeDiff, massOfBall);
        case 'h':
          return hr.hit(x,y,time, clickTimeDiff, massOfBall);
        case 'g':
          return gr.hit(x,y,time, clickTimeDiff, massOfBall);
        default:
          return null;
      }
    }
    
    public step timeAction(int time)
    {
      switch(type)
      {
        case 'c':
          return cr.timeAction(time);
        case 'l':
          return lr.timeAction(time);
        case 'h':
          return hr.timeAction(time);
        case 'g':
          return gr.timeAction(time);
        default:
          return null;
      }
    }
    
    public boolean playing()
    {
      return playing;
    }
    
    public step startPlaying(int startTime)
    {
      started = true;
      switch(type)
      {
        case 'c':
          return cr.start(startTime);
        case 'l':
          return lr.start(startTime);
        case 'h':
          return hr.start(startTime);
        case 'g':
          return gr.start(startTime);  
        
        default: 
          return null;
        
      }
    }
    
    public boolean hasStarted()
    {
      return started;
    }
}
