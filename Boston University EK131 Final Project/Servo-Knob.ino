// C++ code
//
#include <Wire.h>
#include <LiquidCrystal_I2C.h>
#define NOTE_B3  247
#define NOTE_C4  262
#define NOTE_D4  294
#define NOTE_E4  330
#define NOTE_G4  392
#define REST      0


// change this to make the song slower or faster
int tempo = 124;

// notes of the moledy followed by the duration.
// a 4 means a quarter note, 8 an eighteenth , 16 sixteenth, so on
// !!negative numbers are used to represent dotted notes,
// so -4 means a dotted quarter note, that is, a quarter plus an eighteenth!!
int melody[] = {
  
  // Seven Nation Army by The White Stripes
  
  NOTE_E4,16/3,REST,16/3,NOTE_E4,8,NOTE_G4,16/3,
  NOTE_E4,16/3,NOTE_D4,8,NOTE_C4,2,NOTE_B3,2,
  NOTE_E4,16/3,REST,16/3,NOTE_E4,8,NOTE_G4,16/3,
  NOTE_E4,16/3,NOTE_D4,8,NOTE_C4,16/3,NOTE_D4,16/3,
  NOTE_C4,8,NOTE_B3,2
  
};

// sizeof gives the number of bytes, each int value is composed of two bytes (16 bits)
// there are two values per note (pitch and duration), so for each note there are four bytes
int notes = sizeof(melody) / sizeof(melody[0]) / 2;

// this calculates the duration of a whole note in ms
int wholenote = (60000 * 4) / tempo;

int divider = 0, noteDuration = 0;

LiquidCrystal_I2C lcd(0x20,16,2);  // set the LCD address to 0x20 for a 16 chars and 2 line display
int sensorPin = A0;
int temperatureF;
int LED = 3;
int buzzer = 5;

void setup()
{
  for (int thisNote = 0; thisNote < notes * 2; thisNote = thisNote + 2) {

    // calculates the duration of each note
    divider = melody[thisNote + 1];
    if (divider > 0) {
      // regular note, just proceed
      noteDuration = (wholenote) / divider;
    } else if (divider < 0) {
      // dotted notes are represented with negative durations!!
      noteDuration = (wholenote) / abs(divider);
      noteDuration *= 1.5; // increases the duration in half for dotted notes
    }

    // we only play the note for 90% of the duration, leaving 10% as a pause
    tone(buzzer, melody[thisNote], noteDuration*0.9);

    // Wait for the specief duration before playing the next note.
    delay(noteDuration);
    
    // stop the waveform generation before the next note.
    noTone(buzzer);}
  lcd.init(); 
  pinMode(LED, OUTPUT);
  Serial.begin(9600);
}

void loop()
{
  int reading = analogRead(sensorPin);  
  
  float voltage = reading * 5.0;
  voltage /= 1024.0; 
  Serial.print(voltage); Serial.println(" volts");
  
  float temperatureC = (voltage - 0.5) * 100 ;
  Serial.print(temperatureC); Serial.println(" degrees C");
  
  float temperatureF = (temperatureC * 9.0 / 5.0) + 32.0;
  Serial.print(temperatureF); Serial.println(" degrees F");
  
  // Print a message to the LCD.
  lcd.backlight();
  lcd.setCursor(2,0);
  lcd.print("Temperature=");
  lcd.setCursor(0,1);
  lcd.print(temperatureF);
  lcd.print(" F");
  delay(1000);
  
  if (temperatureF < 70 || temperatureF > 75)
  {
   lcd.setCursor(8,1);
   lcd.print("Warning!");
   digitalWrite(LED, HIGH);
   tone(buzzer, 1000); // Send 1KHz sound signal...
   delay(1000); // ...for 1 sec
   noTone(buzzer); // Stop sound...
   delay(1000); // ...for 1 sec
   digitalWrite(LED, LOW);
   }
  else
   {
   lcd.setCursor(8,1);
   lcd.print("        ");
   digitalWrite(LED, LOW);
   digitalWrite(buzzer, LOW);
    
   delay(1000);
  
   }
}