
public class wall
{
  pad pads[][];
  public wall(int id)
  {
    if(id == 0)
    {
      pads = new pad[3][5]; //3, 5
      
      for(int r = 0; r < 3; r++)
      {
        for(int c = 0; c < 5; c++)
        {
          pads[r][c] = new pad(0, r, c, false, false, 3*75+c*75, r*75, 3*75+c*75+37, r*75+37);  
        }
      }
    }
    else if(id == 1)
    {
      pads = new pad[3][5]; //3, 5
      
      for(int r = 0; r < 3; r++)
      {
        for(int c = 0; c < 5; c++)
        {
          pads[r][c] = new pad(1, r, c, false, false, r*75, 600-(c+1)*75 , r*75+37, 600-(c+1)*75+37);  
        }
      }
    }
    else if(id == 2)
    {
      pads = new pad[5][5]; //5, 5
      
      for(int r = 0; r < 5; r++)
      {
        for(int c = 0; c < 5; c++)
        {
          pads[r][c] = new pad(2, r, c, false, false, 75*3+c*75, 75*3+r*75 , 75*3+c*75+37, 75*3+r*75+37);  
        }
      }
    }
    else if(id == 3)
    {
      pads = new pad[3][5]; //3, 5
      
      for(int r = 0; r < 3; r++)
      {
        for(int c = 0; c < 5; c++)
        {
          pads[r][c] = new pad(3, r, c, false, false, 825-75*(r+1), 75*3+c*75, 825-75*(r+1)+37, 75*3+c*75+37);  
        }
      }
    }
    else
    {
      pads = new pad[3][5]; //3, 5
      
      for(int r = 0; r < 3; r++)
      {
        for(int c = 0; c < 5; c++)
        {
          pads[r][c] = new pad(4, r, c, false, false, 600-(c+1)*75, 825-(r+1)*75 , 600-(c+1)*75+37, 825-(r+1)*75+37);  
        }
      }
    }
    
    
    
  }

  pad get_pad(int r, int c)
  {
    return pads[r][c];
  }  
  
}