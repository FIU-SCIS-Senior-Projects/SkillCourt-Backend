import processing.core.*;
import java.util.LinkedList;

public class room
{
  //5 walls
  wall w0;
  wall w1;
  wall w2;
  wall w3;
  wall w4;
  
  public room()
  {
    w0 = new wall(0);
    w1 = new wall(1);
    w2 = new wall(2);
    w3 = new wall(3);
    w4 = new wall(4);
    
  }
  
  public pad get_pad(int w, int r, int c)
  {
    if(w == 0)
    {
      return w0.get_pad(r,c);
    }
    else if(w == 1)
    {
      return w1.get_pad(r,c);
    }
    else if(w == 2)
    {
      return w2.get_pad(r,c);
    }
    else if(w == 3)
    {
      return w3.get_pad(r,c);
    }
    else
    {
      return w4.get_pad(r,c);
    }
    
  }
  
  public pad get_pad(int xCoordinate, int yCoordinate)
  {
    for(int w = 0; w < 5; w++)
    {
      int row = 3;
      int column = 5;
      
      if(w == 2)
        row = 5;
      
      for(int r = 0; r < row; r++)
      {
        for(int c = 0; c < column; c++)
        {
          pad p = get_pad(w, r, c);
          if(xCoordinate > p.get_xTopLeftCorner() && xCoordinate < p.get_xTopLeftCorner() + 75 && yCoordinate > p.get_yTopLeftCorner() && yCoordinate < p.get_yTopLeftCorner()+75 && p.get_valid())
          {
            return p;
          }
          
        }
      }
      
    }
    
    //meaning that there is no pad in that location (there may be an square but no pad)
    return null;
  }
  
  public pad get_tentative_pad(int xCoordinate, int yCoordinate)
  {
    for(int w = 0; w < 5; w++)
    {
      int row = 3;
      int column = 5;
      
      if(w == 2)
        row = 5;
      
      for(int r = 0; r < row; r++)
      {
        for(int c = 0; c < column; c++)
        {
          pad p = get_pad(w, r, c);
          if(xCoordinate > p.get_xTopLeftCorner() && xCoordinate < p.get_xTopLeftCorner() + 75 && yCoordinate > p.get_yTopLeftCorner() && yCoordinate < p.get_yTopLeftCorner()+75)
          {
            return p;
          }
          
        }
      }
      
    }
    
    //meaning that there is no pad in that location (there may be an square but no pad)
    return null;
  }
  
  //maps from the 2d position of the mouse (in pixels) to the 3d position in the real room (in feets)
  double[] from2dTo3d(int xpx, int ypx)
  {
    //x,y,z
    double[] threeD = new double[3];
    
    pad p = get_tentative_pad(xpx, ypx);
    
    //the x y position is outside the room
    if(p == null)
    {
      return null;  
    }
    
    int w = p.get_wall();
    
    //fix conversion factor based on length and width of pad
    if(w == 0)
    {
      threeD[0] = ((double)(xpx - 225))/75.0;
      threeD[1] = 0;
      threeD[2] = ((double)(225 - ypx))/75.0;  
    }
    else if(w == 1)
    {
      threeD[0] = 0;
      threeD[1] = ((double)(ypx - 225))/75.0;
      threeD[2] = ((double)(225 - xpx))/75.0;
    }
    else if(w == 2)
    {
      threeD[0] = ((double)(xpx - 225))/75.0;
      threeD[1] = ((double)(ypx - 225))/75.0;
      threeD[2] = 0.0;
    }
    else if(w == 3)
    {
      threeD[0] = 5.0;
      threeD[1] = ((double)(ypx - 225))/75.0;
      threeD[2] = ((double)(xpx - 600))/75.0; 
    }
    else
    {
      threeD[0] = ((double)(xpx - 225))/75.0;
      threeD[1] = 5.0;
      threeD[2] = ((double)(ypx - 600))/75.0; 
    }
    
    return threeD;
    
  }
 
 //given x and y positions in 2D (pixels) of 2 points return the pythagorean distance of the 3d representation of those points 
 public Double pyt3Df2D(int[] p02d, int[] p12d)
 {
   //it is needed 2 coordinates per point
   if(p02d.length != 2 || p12d.length != 2)
   {
     return null;
   }
   double[] p03d = from2dTo3d(p02d[0], p02d[1]);
   double[] p13d = from2dTo3d(p12d[0], p12d[1]);
    
   if(p03d == null || p13d == null)
   {
     return null;
   }
   
   return pyt3Df3D(p03d, p13d);
     
 }
  
 public Double pyt3Df3D(double[] p03d, double[] p13d)
 {
   //System.out.//println(p03d[0] + " " + p03d[1]+ " " + p03d[2]);
   //System.out.//println(p13d[0] + " " + p13d[1]+ " " + p13d[2]);
   //it is needed 2 coordinates per point
   if(p03d.length != 3 || p13d.length != 3)
   {
     return null;
   }
   return Math.sqrt(Math.pow((p03d[0] - p13d[0]), 2) + Math.pow((p03d[1] - p13d[1]), 2) + Math.pow((p03d[2] - p13d[2]), 2));
 }
  
 public double closestPossPad(int x, int y)
 {
   return 0.0;
 } 
  
 public LinkedList<pad> getAllValid()
 {
   LinkedList<pad> l = new LinkedList<pad>();
   
   for(int w = 0; w < 5; w++)
   {
     int rows = 3;
     if(w == 2)
       rows = 5;
       
     for(int r = 0; r < rows; r++)
     {
       for(int c = 0; c < 5; c++)
       {
         pad p = get_pad(w,r,c);
         if(p.get_valid())
         {
           l.add(p);
         }
         
       }
     }
   }
   
   return l;
 }
}
