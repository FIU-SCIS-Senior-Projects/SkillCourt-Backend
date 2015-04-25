import processing.core.*;
import java.util.LinkedList;
import java.text.DecimalFormat;

public class statistics
{
 
    LinkedList<Double> force;
    LinkedList<Double> accuracy;//how far from closest active positive pad
    LinkedList<Double> timeOfShots;
    LinkedList<Boolean> shots;
      
    //int numberOfShots;
    //int inTargetShots;
    int points;
    
    
    public statistics()
    {
      
      force = new LinkedList<Double>();
      accuracy = new LinkedList<Double>();//how far from closest active positive pad
      timeOfShots = new LinkedList<Double>();
      shots = new LinkedList<Boolean>();
      
      points = 0;
    }
    
    public void shot(int points, double massOfBall, double clickDifference, double accuracy, double timeOfShots, boolean inTarget)
    {
      this.points = this.points + points;
      this.force.add(calculateAcceleration(clickDifference)*massOfBall);
      this.accuracy.add(accuracy);
      this.timeOfShots.add(timeOfShots);
      this.shots.add(inTarget);
    }
    
    //fix this function to be inversely proportional to the clicking difference
    public double calculateAcceleration(double clickDifference)
    {
      return 30 + 1/(clickDifference-105);
    }
    
    public String sumarize()
    {
      
      int tNumbShots = shots.size();
      int lStrike = 0;//keep this one
      int lStrikeT = 0;
      int onTarget = 0;
      for(int i = 0; i < shots.size(); i++)
      {
        if(shots.get(i))
        {
          lStrikeT++;
          onTarget++;
        }
        else
        {
          if(lStrikeT > lStrike)
          {
            lStrike = lStrikeT;
            lStrikeT = 0; 
          }
        }
      }
      
      double avgTimeBetwShots = 0;
      for(int i = 0; i < timeOfShots.size()-1;i++)
      {
         avgTimeBetwShots = avgTimeBetwShots + timeOfShots.get(i+1) - timeOfShots.get(i);  
      }
      
      if(timeOfShots.size() != 1)
        avgTimeBetwShots = avgTimeBetwShots/(timeOfShots.size()-1);
      
      double avgForce = 0;
      for(int i = 0; i < force.size(); i++)
      {
        avgForce = avgForce + force.get(i);
      }
      if(timeOfShots.size() != 0)
        avgForce = avgForce/force.size();
      
      DecimalFormat newFormat = new DecimalFormat("#.###");
      avgTimeBetwShots = avgTimeBetwShots/1000;
      avgTimeBetwShots =  Double.valueOf(newFormat.format(avgTimeBetwShots));
      avgForce = Double.valueOf(newFormat.format(avgForce));
      
      String msg = "p"+Integer.toString(points)+"s"+Integer.toString(tNumbShots)+"o" + Integer.toString(onTarget)+"l"+Integer.toString(lStrike)+"t"+Double.toString(avgTimeBetwShots)+"f"+Double.toString(avgForce);
      for(int i = msg.length(); i < 40; i++)
      {
        msg = msg + "n";
      }
      msg = msg + "\n";
      
      return msg;
    }
}
