/* Created using the openCV LiveCamTest and OpticalFlow examples, 
as well as the DTW_Mouse_Explorer and Processing_PitchSlide_1Continuous code
from Goldsmith's "Machine Learning for Musicians and Artists" course*/

import gab.opencv.*;
import processing.video.*;
import java.awt.*;

import ddf.minim.*;
import ddf.minim.ugens.*;

import controlP5.*;
import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress dest;
ControlP5 cp5;

//For video
Capture video;
OpenCV opencv;

//For sound:
Minim       minim;
AudioOutput out;
Oscil       wave;

String[] messageNames = {"/output_1", "/output_2", "/output_3","/output_4","/output_5"};


void setup() {
  size(640, 240);
  video = new Capture(this, 640/2, 240);
  opencv = new OpenCV(this, 640/2, 240);
  video.start();
  
  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this,12000);
  dest = new NetAddress("127.0.0.1",6448);
  
  //Set up sound:
  minim = new Minim(this);
  out = minim.getLineOut();
  wave = new Oscil( 440, 0.5f, Waves.SINE );
  wave.setAmplitude(0.0);
  // patch the Oscil to the output
  wave.patch( out );
}

void draw() {
  image(video, 0, 0);
  opencv.loadImage(video);
  opencv.calculateOpticalFlow();

  image(video, 0, 0);
  translate(video.width,0);
  stroke(255,0,0);
  opencv.drawOpticalFlow();
  
  PVector aveFlow = opencv.getAverageFlow();
  int flowScale = 50;
  println(aveFlow);
  
  OscMessage msg = new OscMessage("/wek/inputs");
  msg.add((float)aveFlow.x);
  msg.add((float)aveFlow.y);
  oscP5.send(msg, dest);
  
  stroke(255);
  strokeWeight(2);
  line(video.width/2, video.height/2, video.width/2 + aveFlow.x*flowScale, video.height/2 + aveFlow.y*flowScale);
}

void captureEvent(Capture c) {
  c.read();
}

//This is called automatically when OSC message is received
void oscEvent(OscMessage theOscMessage) {
 println("Message received");
 for (int i = 0; i < 5; i++) {
    if (theOscMessage.checkAddrPattern(messageNames[i]) == true) {
       showMessage((float)i);
    }
 }
}

void showMessage(float i) {
    wave.setFrequency(Frequency.ofMidiNote(60 + 12*i).asHz());
    wave.setAmplitude(0.5);
}
