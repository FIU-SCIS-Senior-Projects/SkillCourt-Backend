#include <SoftwareSerial.h>

// pins for the LEDs:
const int redPin = 8;
const int greenPin = 9;
const int bluePin = 10;

//bluetooth
int bluetoothTx = 2;
int bluetoothRx = 3;

SoftwareSerial bluetooth(bluetoothTx, bluetoothRx);
String recv;

boolean conn = false;
boolean routine = false;

void setup()
{
  
   // make the pins outputs:
  pinMode(redPin, OUTPUT);
  pinMode(greenPin, OUTPUT);
  pinMode(bluePin, OUTPUT);
  
  
  //set initial values  
  setLed(0,0,0);
  
  
  Serial.begin(9600);
  establishContact();
  
  
  bluetooth.begin(115200);
  bluetooth.print("$$$");
  delay(100);
  bluetooth.println("U,9600,N");
  bluetooth.begin(9600);
  
  
}

void loop()
{
  
  if( !conn) 
  {
    setLed(254, 254, 254);
    if(bluetooth.available())
    { 
      recv =  bluetooth.readStringUntil('\n');
      if(recv == "Hello")
      {
        
        delay(10);
        bluetooth.print("Hello from pad\n");
        conn = true;
      }
    } 
    
    
  }
  else
  {
    if(!routine)//it is already connected to the Android device but routine hasn't been received
    {
      setLed(100, 159, 30);
      if(bluetooth.available())
      {
        
        recv =  bluetooth.readStringUntil('\n');
        
        if(recv.length() == 13)//else we can check by sendin a message back
        {
          Serial.print(recv);
          routine = true;
        }
        else if(recv == "disc")
        {
          setLed(0, 0, 0);
          conn = false;
        }
      }
    }
    else//routine playing wating to know which light to turn on or if the end to send back stats and reset variables
    {
      
      if(Serial.available())
      {
        
        recv = Serial.readStringUntil('\n');
        
        
          
          
          if(recv == "r")
          {
            setLed(254, 0, 0);
          }
          else if(recv == "g")
          {
            setLed(0, 254, 0);
          }
          else if(recv == "b")
          {
            setLed(0, 0, 254);
          }
          else if(recv == "o")
          {
            setLed(0, 0, 0);
          }
          else if(recv[0] == 'p')//routine is over
          {
            //setLed(100, 100, 100);
            bluetooth.print(recv);//the problem is here for some reason the message is not being received
            //Serial.print(recv);
            delay(500);
            routine = false;
          }
      }
    }
  }
  
  
   
}

void establishContact() {
  
  while (Serial.available() <= 0) {
    Serial.print('A');   // send a capital A
    
  }
  
  
}


void setLed(int redVal, int greenVal, int blueVal)
{
     analogWrite(redPin, redVal);
     analogWrite(greenPin, greenVal);
     analogWrite(bluePin, blueVal);
}
