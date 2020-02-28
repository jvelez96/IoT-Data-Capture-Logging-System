#include <dht.h>

dht DHT;

#define DHT11_PIN 7
#define FAN_PIN 3

int temperature_limit;

void setup(){
  pinMode(FAN_PIN,OUTPUT);
  Serial.begin(9600);

  temperature_limit = 24; // to be set up later by the server
}

void loop()
{
  int chk = DHT.read11(DHT11_PIN);
  Serial.print("Temperature = ");
  Serial.println(DHT.temperature);

  if(DHT.temperature >= temperature_limit){
    //Fan working 
    int value;
    for(value = 100 ; value <= 400; value+=5)
    {
      analogWrite(FAN_PIN, value);   //PWM
      Serial.println(value);
      delay(30); //1800 total
    }
  } else{
    delay(1800);
  }
}
