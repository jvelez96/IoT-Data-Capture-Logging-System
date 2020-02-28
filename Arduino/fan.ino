//Arduino Sample Code for Fan Module
//www.DFRobot.com
//Version 1.0

#define Fan 3    //define driver pins

void setup()
{
  pinMode(Fan,OUTPUT);
  Serial.begin(9600);    //Baudrate: 9600
}
void loop()
{
  int value;
  for(value = 0 ; value <= 3000; value+=100)
  {
    analogWrite(Fan, value);   //PWM
    Serial.println(value);
    delay(30);
  }
}
