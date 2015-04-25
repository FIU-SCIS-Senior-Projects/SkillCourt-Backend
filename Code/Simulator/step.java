import processing.core.*;
import java.util.LinkedList;

public class step
{
    LinkedList<pad> padsOn;
    LinkedList<colour> colourOn;
    
    LinkedList<pad> padsOff;
    LinkedList<colour> colourOff;
    
    boolean lastStep = false;
    
    String statSumary;
    
    public step(LinkedList<pad> padsOn, LinkedList<colour> colourOn, LinkedList<pad> padsOff, LinkedList<colour> colourOff, boolean lastStep)
    {
      this.padsOn = padsOn;
      this.colourOn = colourOn;
      this.padsOff = padsOff;
      this.colourOff = colourOff;
      this.lastStep = lastStep;
    }
    
    public step()
    {
      this.padsOn = new LinkedList();
      this.colourOn = new LinkedList();
      this.padsOff = new LinkedList();
      this.colourOff = new LinkedList();
      
      lastStep = false;
    }
    
    public void setLastStep(boolean lastStep)
    {
      this.lastStep = lastStep;
    }
    
    public void addOn(pad p, colour c)
    {
      padsOn.add(p);
      colourOn.add(c);
    }
    
    public void addOff(pad p, colour c)
    {
      padsOff.add(p);
      colourOff.add(c);
    }
    
    public boolean isLastStep()
    {
      return lastStep;
    }
    
    public LinkedList<pad> getPadsOn()
    {
      return padsOn;
    }
    public LinkedList<colour> getColourOn()
    {
      return colourOn;
    }
    
    public LinkedList<pad> getPadsOff()
    {
      return padsOff;
    }
    public LinkedList<colour> getColourOff()
    {
      return colourOff;
    }
    public void setSummary(String s)
    {
      statSumary = s;
    }
    public String getSummary()
    {
      return statSumary;
    }
}
