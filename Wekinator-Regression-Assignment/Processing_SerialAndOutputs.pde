import processing.serial.*;
import controlP5.*;
import java.util.*;
import oscP5.*;
import netP5.*;

//Objects for display:
ControlP5 cp5;
CColor defaultColor;

//Serial port info:
int end = 10;    // the number 10 is ASCII for linefeed (end of serial.println), later we will look for this to break up individual messages
String serial;   // declare a new string called 'serial' . A string is a sequence of characters (data type know as "char")
int numPorts = 0;
Serial myPort;  // The serial port
boolean gettingData = false; //True if we've selected a port to read from

//Objects for sending OSC
OscP5 oscP5;
NetAddress dest;

int numFeatures = 0;
String featureString = "";

int saturation = 0;
int hue = 0;
float diameter = 0.1;

void setup() {
  size(2200, 1200);
  frameRate(100);

  //Set up display
  cp5 = new ControlP5(this);
  textAlign(LEFT, CENTER);

  //Populate serial port options:
  List l = Arrays.asList(Serial.list());
  numPorts = l.size();
  cp5.addScrollableList("Port") //Create drop-down menu
     .setPosition(10, 60)
     .setSize(200, 100)
     .setBarHeight(20)
     .setItemHeight(20)
     .addItems(l)
     ;
  defaultColor = cp5.getColor();
  
  oscP5 = new OscP5(this,12000); //listen for OSC messages on port 12000 (Wekinator default)
  dest = new NetAddress("127.0.0.1", 6448); //send messages back to Wekinator on port 6448, localhost (this machine) (default)

}

//Called when new port (n-th) selected in drop-down
void Port(int n) {
 // println(n, cp5.get(ScrollableList.class, "Port").getItem(n));
  CColor c = new CColor();
  c.setBackground(color(255,0,0));
  
  //Color all non-selected ports the default color in drop-down list
  for (int i = 0; i < numPorts; i++) {
      cp5.get(ScrollableList.class, "Port").getItem(i).put("color", defaultColor);
  }
  
  //Color the selected item red in drop-down list
  cp5.get(ScrollableList.class, "Port").getItem(n).put("color", c);
  
  //If we were previously receiving on a port, stop receiving
  if (gettingData) {
    myPort.stop();
  }
  
  //Finally, select new port:
  myPort = new Serial(this, Serial.list()[n], 9600); //Using 9600 baud rate
  myPort.clear(); //Throw out first reading, in case we're mid-feature vector
  gettingData = true;
  serial = null; //Initialise serial string
  numFeatures = 0;
}

//Called in a loop at frame rate (100 Hz)
void draw() {
  colorMode(HSB, 100);
  background(100, 0, 100);
  textSize(20); 
  fill(0);
  text("Serial to OSC by Rebecca Fiebrink", 10, 10);
  text("Select serial port:", 10, 40);
  text("Sending " + numFeatures + " values to port 6448, message /wek/inputs", 10, 180); 
  text("Feature values:", 10, 200);
  text(featureString, 25, 220);

  if (gettingData) {
    getData();
    
    generateCircle();
  }
}

void generateCircle(){
  noStroke();
  fill(hue, saturation, 100);
  ellipse(width/2, height/2, diameter, diameter);
}

//Parses serial data to get button & accel values, also buffers accels if we're in button-segmented mode
void getData() {
  while (myPort.available() > 0 ) { 
    serial = myPort.readStringUntil(end);
  }
  if (serial != null) {  //if the string is not empty, print the following
    
    /*  Note: the split function used below is not necessary if sending only a single variable. However, it is useful for parsing (separating) messages when
        reading from multiple inputs in Arduino. Below is example code for an Arduino sketch
    */
    
      String[] a = split(serial, ',');  //a new array (called 'a') that stores values into separate cells (separated by commas specified in your Arduino program)
      numFeatures = a.length;
      sendFeatures(a);
  }
}

void sendFeatures(String[] s) {
  OscMessage msg = new OscMessage("/wek/inputs");
  StringBuilder sb = new StringBuilder();
  try {
    for (int i = 0; i < s.length; i++) {
      float f = Float.parseFloat(s[i]); 
      msg.add(f);
      sb.append(String.format("%.2f", f)).append(" ");
    }
    oscP5.send(msg, dest);
    featureString = sb.toString();
  } catch (Exception ex) {
     println("Encountered exception parsing string: " + ex); 
  }
}

void oscEvent(OscMessage theOscMessage) {
 //println("received message");
  if (theOscMessage.checkAddrPattern("/wek/outputs") == true) {
    if(theOscMessage.checkTypetag("fff")) {
      float f = theOscMessage.get(0).floatValue();
      float ff = theOscMessage.get(1).floatValue();
      float fff = theOscMessage.get(2).floatValue();
      
      diameter = map(f, 0, 1, 50, height/6*5); 
      hue = (int)map(ff, 0, 1, 0, 100); 
      saturation = (int)map(fff, 0, 1, 0, 100); 
      
      println("received");
    }
  }
  
}
