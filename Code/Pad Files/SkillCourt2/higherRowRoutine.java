import java.util.HashMap;
import java.util.LinkedList;
import java.util.Random;


public class higherRowRoutine
{
  
  //maping from wall number to step
  HashMap<Integer, LinkedList<pad>> hm;
  char level;
  int rounds;
  int timer;
  
  //room
  room ro;
  
  //counting number of rounds
  int countRounds = 0;
  
  
  //active one
  int active;
  
  //colours
  colour green;
  colour red;
  colour gray;
  
  //Statistics
  statistics stat;
  
  //start time
  int startTime;
  
  public higherRowRoutine(char level, int rounds, int timer, room ro)
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
  
  public higherRowRoutine()
  {
  }
  
  public boolean validateRoom(room ro)
  {
    constructHashMap(ro);
    if(hm.size() >= 1)
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
    return createOnStep(s);
  }
  
  private step createOnStep(step s)
  {
    Random rand = new Random();
    int t1 = rand.nextInt(4);
    int t2 = rand.nextInt(4);
    while(t1 == t2)
    {
      t2 = rand.nextInt(4);
    }
    
    active = rand.nextInt(hm.size()+1);
    
    while(!hm.containsKey(active))
    {
      active = rand.nextInt(hm.size()+1);
    }
    
    pad p0 = hm.get(active).get(0);
    p0.set_status(true);
    pad p1 = hm.get(active).get(1);
    p1.set_status(true);
    pad p2 = hm.get(active).get(2);
    p2.set_status(true);
    pad p3 = hm.get(active).get(3);
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
  
  private step createOffStep(step s)
  {
   
    
    pad p0 = hm.get(active).get(0);
    p0.set_status(false);
    pad p1 = hm.get(active).get(1);
    p1.set_status(false);
    pad p2 = hm.get(active).get(2);
    p2.set_status(false);
    pad p3 = hm.get(active).get(3);
    p3.set_status(false);
    
      
    s.addOff(p0, gray);
    s.addOff(p1, gray);
    s.addOff(p2, gray);
    s.addOff(p3, gray);
    
    return s;
  }
  
  public step hit(int x, int y, int time, int clickTimeDiff, double massOfBall)//hereeeeeeeeeeeee
  {
    //playing for rounds
    step s;
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
             stat.shot(-1, (double)massOfBall, (double)clickTimeDiff, ro.closestPossPad(x, y), (double)time, false);
           }
           
           s = new step();
           s = createOffStep(s);
           s = createOnStep(s);
           
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
         s = createOffStep(s);
         s.setSummary(stat.sumarize());
         s.setLastStep(true);
      }
    }
    return s;
    
  }
  
  //helpers
  //here build the hash map then the rest
  private void constructHashMap(room ro)
  {
    hm = new HashMap<Integer, LinkedList<pad>>();
    for(int w = 0; w < 5; w++)
    {  
      if(w == 2)
        w++;
      for(int r = 0; r < 1; r++)
      {
        for(int c = 0; c < 4; c++)
        {
          pad p0 = ro.get_pad(w, r, c);
          pad p1 = ro.get_pad(w, r+1, c);
          pad p2 = ro.get_pad(w, r, c+1);
          pad p3 = ro.get_pad(w, r+1, c+1);
          if(p0.get_valid() && p1.get_valid() && p2.get_valid() && p3.get_valid())
          {
            LinkedList<pad> l = new LinkedList<pad>();
            l.add(p0);
            l.add(p1);
            l.add(p2);
            l.add(p3);
            
            hm.put(hm.size(), l);
          }
        }
      } 
    }
    
    
  }
}
