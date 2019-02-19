/* Created using the RunOnArduino code from Goldsmith's 
"Machine Learning for Musicians and Artists" course */

int analogPin1 = A1;
int analogPin2 = A2;
int analogPin3 = A3;

void setup() {
  Serial.begin(9600);
}

void loop() {
  int value1 = analogRead(analogPin1);
  int value2 = analogRead(analogPin2);
  int value3 = analogRead(analogPin3);
  
  Serial.print(value1); 
  Serial.print(",");
  Serial.print(value2);
  Serial.print(",");
  Serial.print(value3);  
  Serial.println();
}
