import java.util.HashMap;
import java.util.LinkedList;
import java.util.Random;


public class groundRoutine
{
  
  //maping from wall number to step
  HashMap<Integer, pad> hmg;
  HashMap<Integer, LinkedList<pad>> hml;
  HashMap<Integer, LinkedList<pad>> hmh;
  char level;
  int rounds;
  int timer;
  
  //room
  room ro;
  
  //counting number of rounds
  int countRounds = 0;
  
  
  //active one
  int activeg = -1;
  int activel = -1;
  int activeh = -1;
  
  int active;
  
  //colours
  colour green;
  colour red;
  colour gray;
  
  //Statistics
  statistics stat;
  
  //start time
  int startTime;
  
  public groundRoutine(char level, int rounds, int timer, room ro)
  {
    constructHashMap(ro);
    this.level = level;
    this.rounds = rounds;
    this.timer = timer;
    this.ro = ro;
    
    green = new colour(0,254,0);
    red = new colour(255,0,0);
    gray = new colour(205,201,201);
    
    stat = new statistics();
  }
  
  public groundRoutine()
  {
  }
  
  public boolean validateRoom(room ro)
  {
    constructHashMap(ro);
    if(hmg.size() >= 1 && (hml.size() + hmh.size()) >= 2)
    {
      return true;
    }
    else
      return false;
    
  }
  
  public step start(int startTime)
  {
    this.startTime = startTime;
    step s = new step();
    return createOnStepGround(s);
  }
  
  private  step createOnStep(step s)
  {
    return null;
  }
  
  private step createOnStepGround(step s)
  {
    Random rand = new Random();
    activeg = rand.nextInt(hmg.size());
        
    pad p = hmg.get(activeg);
    p.set_status(true);
   
    s.addOn(p, green);
    p.set_positive(true);
      
    return s;
  }
  
  private step createOnStepLow(step s)
  {
    Random rand = new Random();
    activel = rand.nextInt(hml.size());
    

    
    pad p0 = hml.get(activel).get(0);
    p0.set_status(true);
    pad p1 = hml.get(activel).get(1);
    p1.set_status(true);
    pad p2 = hml.get(activel).get(2);
    p2.set_status(true);
    
    if(level == 'n')
    {
      
      s.addOn(p0, green);
      p0.set_positive(true);
      s.addOn(p1, green);
      p1.set_positive(true);
      s.addOn(p2, green);
      p2.set_positive(true);
    }
    if(level == 'i')
    {
      s.addOn(p0, red);
      p0.set_positive(false);
      s.addOn(p1, green);
      p1.set_positive(true);
      s.addOn(p2, green);
      p2.set_positive(true);
    }
    else if(level == 'a')
    {
      s.addOn(p0, red);
      p0.set_positive(false);
      s.addOn(p1, green);
      p1.set_positive(true);
      s.addOn(p2, red);
      p2.set_positive(false);
    }
    
    return s;
  }
  
  private step createOnStepHigh(step s)
  {
    Random rand = new Random();
    int t1 = rand.nextInt(hmh.size());
    int t2 = rand.nextInt(hmh.size());
    while(t1 == t2)
    {
      t2 = rand.nextInt(hmh.size());
    }
    
    activeh = rand.nextInt(hmh.size());
    
    
    pad p0 = hmh.get(activeh).get(0);
    p0.set_status(true);
    pad p1 = hmh.get(activeh).get(1);
    p1.set_status(true);
    pad p2 = hmh.get(activeh).get(2);
    p2.set_status(true);
    pad p3 = hmh.get(activeh).get(3);
    p3.set_status(true);
    
    if(level == 'n')
    {
      
      s.addOn(p0, green);
      p0.set_positive(true);
      s.addOn(p1, green);
      p1.set_positive(true);
      s.addOn(p2, green);
      p2.set_positive(true);
      s.addOn(p3, green);
      p3.set_positive(true);
    }
    if(level == 'i')
    {
      
      
      if(t1 == 0)
      {
        s.addOn(p0, red);
        p0.set_positive(false);
      }
      else
      {
        s.addOn(p0, green);
        p0.set_positive(true);
      }
      
      if(t1 == 1)
      {
        s.addOn(p1, red);
        p1.set_positive(false);
      }
      else
      {
        s.addOn(p1, green);
        p1.set_positive(true);
      }
      
      if(t1 == 2)
      {
        s.addOn(p2, red);
        p2.set_positive(false);
      }
      else
      {
        s.addOn(p2, green);
        p2.set_positive(true);
      }
      
      if(t1 == 3 )
      {
        s.addOn(p3, red);
        p3.set_positive(false);
      }
      else
      {
        s.addOn(p3, green);
        p3.set_positive(true);
      }
      
    }
    else if(level == 'a')
    {
      if(t1 == 0 || t2 == 0)
      {
        s.addOn(p0, red);
        p0.set_positive(false);
      }
      else
      {
        s.addOn(p0, green);
        p0.set_positive(true);
      }
      
      if(t1 == 1 || t2 == 1)
      {
        s.addOn(p1, red);
        p1.set_positive(false);
      }
      else
      {
        s.addOn(p1, green);
        p1.set_positive(true);
      }
      
      if(t1 == 2 || t2 == 2)
      {
        s.addOn(p2, red);
        p2.set_positive(false);
      }
      else
      {
        s.addOn(p2, green);
        p2.set_positive(true);
      }
      
      if(t1 == 3 || t2 == 3)
      {
        s.addOn(p3, red);
        p3.set_positive(false);
      }
      else
      {
        s.addOn(p3, green);
        p3.set_positive(true);
      }
    }
    
    return s;
  }
  
  private step createOffStepGround(step s)
  {
       
    pad p = hmg.get(activeg);
    activeg = -1;
    p.set_status(false);  
    s.addOff(p, gray);

    return s;
  }
  
  private step createOffStepLow(step s)
  {
       
    pad p0 = hml.get(activel).get(0);
    p0.set_status(false);
    pad p1 = hml.get(activel).get(1);
    p1.set_status(false);
    pad p2 = hml.get(activel).get(2);
    p2.set_status(false);
    activel = -1;
      
    s.addOff(p0, gray);
    s.addOff(p1, gray);
    s.addOff(p2, gray);
    
    return s;
  }
  
  private step createOffStepHigh(step s)
  {
    pad p0 = hmh.get(activeh).get(0);
    p0.set_status(false);
    pad p1 = hmh.get(activeh).get(1);
    p1.set_status(false);
    pad p2 = hmh.get(activeh).get(2);
    p2.set_status(false);
    pad p3 = hmh.get(activeh).get(3);
    p3.set_status(false);
    
    activeh = -1;
      
    s.addOff(p0, gray);
    s.addOff(p1, gray);
    s.addOff(p2, gray);
    s.addOff(p3, gray);
    
    return s;
  }
  
  public step createOffStep(step s)//delete this
  {
    return null;
  }
  
  public step hit(int x, int y, int time, int clickTimeDiff, double massOfBall)//hereeeeeeeeeeeee
  {
    //playing for rounds
    step s;
    Random rand = new Random();
    int t1 = rand.nextInt(2);//0 for low and 1 for high
    int t2 = rand.nextInt(2);
    
    //System.out.//println("Total Number of rounds = " + rounds);
    //System.out.//println("Rounds up to now = " + countRounds);
    
    
      pad p = ro.get_tentative_pad(x, y);
      if(p != null)
      {
        if(p.get_status())
        {
           countRounds++;
           if(p.isPositive())
           {
             //System.out.//println("Shooting green pad");
             stat.shot(1, (double)massOfBall, (double)clickTimeDiff, ro.closestPossPad(x, y), (double)time, true);
           }
           else
           {
             //System.out.//println("Shooting a red pad");
             stat.shot(-2, (double)massOfBall, (double)clickTimeDiff, ro.closestPossPad(x, y), (double)time, false);
           }
           
           s = new step();
           
           //If we are cereating 2 of the same type we have to make sure that we are not shosing the same one
           //Only 1 active low and 1 active high but we may need 2 active los and 2 active high
           if(activeg != -1)
           {
             s = createOffStepGround(s);
             
             if(t1 == 0)
             {
               if(hml.size() >= 1)
               {
                 s = createOnStepLow(s);    
               }
               else
               {
                 s = createOnStepHigh(s);
               }
             }
             else
             {
               if(hmh.size() >= 1)
               {
                 s = createOnStepHigh(s);   
               }
               else
               {
                 s = createOnStepLow(s); 
               }
             }
             
             
             
           }
           
           
           
           //--------------------------------
           if(rounds != 0)
           {
             if(countRounds == rounds)
             {
               s.setSummary(stat.sumarize());
               s.setLastStep(true);
             }
           }
           else
           {
             if(time-startTime >= timer)
             {
               s.setSummary(stat.sumarize());
               s.setLastStep(true);
             }
           }
            return s; 
           
        }
        else
        {
          //System.out.//println("Shooting a pad that is not on");
          s = new step();
          stat.shot(-1, (double)massOfBall, (double)clickTimeDiff, ro.closestPossPad(x, y), (double)time, false);
          return s;
        }
      }
      else
      {
        //System.out.//println("Shoot is Outside");
        s=new step();
        return s; 
      }    
    
    
    
  }
  
  public step timeAction(int time)
  {
    step s = new step();
    
    if(rounds == 0)
    {
      if(time-startTime >= timer)
      {
        if(activeg != -1)
        {
          s = createOffStepGround(s);
        }
        if(activeh != -1)
        {
          s = createOffStepHigh(s);
        }
        if(activel != -1)
        {
          s = createOffStepLow(s);
        }
         
         s.setSummary(stat.sumarize());
         s.setLastStep(true);
      }
    }
    return s;
    
  }
  
  //helpers
  private void constructHashMap(room ro)
  {
    hmg = new HashMap<Integer, pad>();
    hml = new HashMap<Integer, LinkedList<pad>>();
    hmh = new HashMap<Integer, LinkedList<pad>>();    
    
    //ground
    for(int r = 0; r < 5; r++)
    {
      for(int c = 0; c < 5; c++)
      {
        pad p = ro.get_pad(2,r,c);
        if(p.get_valid())
        {
          hmg.put(hmg.size(), p);
        }
      }
    }
 
     //lowest row
    for(int w = 0; w < 5; w++)
    {
      if(w == 2)
        w++;
      for(int c = 0; c < 3; c++)
      {
        pad p0 = ro.get_pad(w,2,c);
        pad p1 = ro.get_pad(w,2,c+1);
        pad p2 = ro.get_pad(w,2,c+2);
        if(p0.get_valid() && p1.get_valid() && p2.get_valid())
        {
          LinkedList<pad> l = new LinkedList<pad>();
          l.add(p0);
          l.add(p1);
          l.add(p2);
          
          hml.put(hml.size(), l);
        }
      }
    }
    
    //highest 2 rows
    for(int w = 0; w < 5; w++)
    {
      if(w == 2)
        w++;
      
      for(int c = 0; c < 4; c++)
      {
        pad p0 = ro.get_pad(w,0,c);
        pad p1 = ro.get_pad(w,0,c+1);
        pad p2 = ro.get_pad(w,1,c);
        pad p3 = ro.get_pad(w,1,c+1);
        
        if(p0.get_valid() && p1.get_valid() && p2.get_valid() && p3.get_valid())
        {
          LinkedList<pad> l = new LinkedList<pad>();
          l.add(p0);
          l.add(p1);
          l.add(p2);
          l.add(p3);
          
          hmh.put(hmh.size(), l);
        }
        
      }
      
    }
        
  }
}
