public class rectangle
{
  //the dimensions of the rectangle based on pixels
  private int xDimension;
  private int yDimension;
  
  //The x and y coordinates of the top left corner of the rectangle in pixels
  protected int xTopLeftCorner;
  protected int yTopLeftCorner;
  
  public rectangle(int xD, int yD, int xT, int yT)
  {
    xDimension = xD;
    yDimension = yD;
    xTopLeftCorner = xT;
    yTopLeftCorner = yT;
  }
  
  public int get_xDimension()
  {
    return xDimension;
  }
  
  public int get_yDimension()
  {
    return yDimension; 
  }
  
  public int get_xTopLeftCorner()
  {
    return xTopLeftCorner;
  }
  
  public int get_yTopLeftCorner()
  {
    return yTopLeftCorner;
  }
  
  
  
}
