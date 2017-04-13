#include <TimerOne.h>



unsigned char channel_1 = 4;  // Output to Opto Triac pin, channel 1

unsigned char channel_2 = 5;  // Output to Opto Triac pin, channel 2

unsigned char channel_3 = 6;  // Output to Opto Triac pin, channel 3

unsigned char channel_4 = 7;  // Output to Opto Triac pin, channel 4

unsigned char channel_5 = 8;  // Output to Opto Triac pin, channel 5

unsigned char channel_6 = 9;  // Output to Opto Triac pin, channel 6

unsigned char channel_7 = 10; // Output to Opto Triac pin, channel 7

unsigned char channel_8 = 11; // Output to Opto Triac pin, channel 8

unsigned char CH1, CH2, CH3, CH4, CH5, CH6, CH7, CH8;

unsigned char CHANNEL_SELECT;

unsigned char i=0;

unsigned char clock_tick; // variable for Timer1

unsigned int delay_time = 200;



unsigned char low = 75;

unsigned char high = 5;

unsigned char off = 95;

int channel = 0;





void setup() {

 

pinMode(channel_1, OUTPUT);// Set AC Load pin as output

pinMode(channel_2, OUTPUT);// Set AC Load pin as output

pinMode(channel_3, OUTPUT);// Set AC Load pin as output

pinMode(channel_4, OUTPUT);// Set AC Load pin as output

pinMode(channel_5, OUTPUT);// Set AC Load pin as output

pinMode(channel_6, OUTPUT);// Set AC Load pin as output

pinMode(channel_7, OUTPUT);// Set AC Load pin as output

pinMode(channel_8, OUTPUT);// Set AC Load pin as output

attachInterrupt(1, zero_crosss_int, RISING);

Timer1.initialize(100); // set a timer of length 100 microseconds for 50Hz or 83 microseconds for 60Hz;

Timer1.attachInterrupt( timerIsr ); // attach the service routine here

Serial.begin(115200);

}



void timerIsr()

{

clock_tick++;



if (CH1==clock_tick)

{

digitalWrite(channel_1, HIGH); // triac firing

delayMicroseconds(5); // triac On propogation delay (for 60Hz use 8.33)

digitalWrite(channel_1, LOW); // triac Off

}



if (CH2==clock_tick)

{

digitalWrite(channel_2, HIGH); // triac firing

delayMicroseconds(5); // triac On propogation delay (for 60Hz use 8.33)

digitalWrite(channel_2, LOW); // triac Off

}



if (CH3==clock_tick)

{

digitalWrite(channel_3, HIGH); // triac firing

delayMicroseconds(5); // triac On propogation delay (for 60Hz use 8.33)

digitalWrite(channel_3, LOW); // triac Off

}



if (CH4==clock_tick)

{

digitalWrite(channel_4, HIGH); // triac firing

delayMicroseconds(5); // triac On propogation delay (for 60Hz use 8.33)

digitalWrite(channel_4, LOW); // triac Off

}



if (CH5==clock_tick)

{

digitalWrite(channel_5, HIGH); // triac firing

delayMicroseconds(5); // triac On propogation delay (for 60Hz use 8.33)

digitalWrite(channel_5, LOW); // triac Off

}



if (CH6==clock_tick)

{

digitalWrite(channel_6, HIGH); // triac firing

delayMicroseconds(5); // triac On propogation delay (for 60Hz use 8.33)

digitalWrite(channel_6, LOW); // triac Off

}



if (CH7==clock_tick)

{

digitalWrite(channel_7, HIGH); // triac firing

delayMicroseconds(5); // triac On propogation delay (for 60Hz use 8.33)

digitalWrite(channel_7, LOW); // triac Off

}



if (CH8==clock_tick)

{

digitalWrite(channel_8, HIGH); // triac firing

delayMicroseconds(5); // triac On propogation delay (for 60Hz use 8.33)

digitalWrite(channel_8, LOW); // triac Off

}





}







void zero_crosss_int() // function to be fired at the zero crossing to dim the light

{

// Every zerocrossing interrupt: For 50Hz (1/2 Cycle) => 10ms ; For 60Hz (1/2 Cycle) => 8.33ms

// 10ms=10000us , 8.33ms=8330us



clock_tick=0;

}







void loop() {

char buffer[] = {' ',' ',' ',' ',' ',' ',' '}; // Receive up to 7 bytes
 while (!Serial.available()); // Wait for characters
 Serial.setTimeout(50);
 Serial.readBytesUntil(' ', buffer, 7);
 int channel = atoi(buffer);
 Serial.setTimeout(50);
 Serial.readBytesUntil('n', buffer, 7);
 int incomingValue = atoi(buffer);
// Serial.print("channel: ");
// Serial.println(channel);
// Serial.print("value: ");
// Serial.println(incomingValue);
//  Serial.print(".");
  
  switch (channel) {
    case 1:
        CH1 = incomingValue;
        break;
    case 2:
        CH2 = incomingValue;
        break;
    case 3:
        CH3 = incomingValue;
        break;
    case 4:
        CH4 = incomingValue;
        break;
    case 5:
        CH5 = incomingValue;
        break;
    case 6:
        CH6 = incomingValue;
        break;
    case 7:
        CH7 = incomingValue;
        break;
    case 8:
        CH8 = incomingValue;
        break;
  }


}
