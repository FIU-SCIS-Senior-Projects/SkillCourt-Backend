
public class pad extends rectangle 
{
  
  //position of the pad in the 3D room in terms of other pads
  private int wall;
  private int row;
  private int column;
  
  //center of pad
  int xc;
  int yc;

  
  //status if the pad is on or off
  private Boolean status;
  
  //positive or negative pad
  private boolean positive = false;
 
  
  //if the pad in that location exists or not
  private Boolean valid;
  
  //if it is the master pad or not
  private Boolean master = false;
  
  //dimensions
  double length = 1.0; //ft
  double width = 1.0; //ft
  
  //pad color
  int [] color = {255,255,255};//{red, green, blue}
  
  
  public pad(int w, int r, int c, Boolean sta, Boolean v,int xTopLeftCorner, int yTopLeftCorner, int xcenter, int ycenter)
  {
    super(75, 75, xTopLeftCorner, yTopLeftCorner);
    wall = w;
    row = r;
    column = c;
    status = sta;
    valid = v;
    xc = xcenter;
    yc = ycenter;
  }
  
  public void set_positive(boolean b)
  {
    positive = b;
  }
  
 
  
  public boolean isPositive()
  {
    return positive;
  }
  
    
  public int get_wall()
  {
      return wall;
  }
  public int get_row()
  {
    return row;
  }
  public int get_column()
  {
    return column;
  } 
  
  
  public Boolean get_status()
  {
    return status;
  } 
  public void set_status(Boolean sta)
  {
    status = sta;
  }
  public Boolean get_valid()
  {
    return valid;
  }
  public void set_valid(Boolean v)
  {
    color[0] = 205;
    color[1] = 201;
    color[2] = 201;
    valid = v;
  }
  public Boolean is_master()
  {
    return master;
  }
  public void set_master(Boolean m)
  {
    master = m;
  }
  
  public double get_length()
  {
    return length;
  }
  public double get_width()
  {
     return width;
  }
  public int get_x_center()
  {
    return xc;
  }
  public int get_y_center()
  {
    return yc;
  }
  
  public boolean isEqual(pad p)
  {
    return (this.xTopLeftCorner == p.get_xTopLeftCorner() && this.yTopLeftCorner == p.get_yTopLeftCorner());
  }
}
