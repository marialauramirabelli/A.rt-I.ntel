/* Created using the openCV LiveCamTest and FaceDetection examples, 
as well as the Wekinator Simple_MouseXY_2Inputs example */

import gab.opencv.*;
import processing.video.*;
import java.awt.*;

import controlP5.*;
import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress dest;
ControlP5 cp5;

Capture video;
OpenCV opencv;
Rectangle[] faces;

void setup() {
  size(1280, 960);
  video = new Capture(this, 640/2, 480/2);
  opencv = new OpenCV(this, 640/2, 480/2);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);  

  video.start();
    
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);  
  faces = opencv.detect();
  
  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this,12000);
  dest = new NetAddress("127.0.0.1",6448);
}

void draw() {
  pushMatrix();
  scale(-4, 4);
  image(video, -video.width, 0);
  //scale(4);
  //image(video, 0, 0);
  opencv.loadImage(video);
  
  Rectangle[] faces = opencv.detect();
  
  if(faces.length > 0){
    //println("FACE!");
    OscMessage msg = new OscMessage("/wek/inputs");
    msg.add((float)faces[0].x);
    msg.add((float)faces[0].y);
    msg.add((float)faces[0].width);
    msg.add((float)faces[0].height);
    oscP5.send(msg, dest);
  }
  
  popMatrix();
}

void captureEvent(Capture c) {
  c.read();
}

//This is called automatically when OSC message is received
void oscEvent(OscMessage theOscMessage) {
  println("received message");
  if (theOscMessage.checkAddrPattern("/wek/outputs") == true) {
    if(theOscMessage.checkTypetag("f")) {
      float f = theOscMessage.get(0).floatValue();
      println("received1");
      showMessage((int)f);
    }
  }
}

void showMessage(int output){
  if(output == 1){
    tint(255, 0, 0, 126);
  }
  else if(output == 2){
    tint(0, 255, 0, 126);
  }
  else if(output == 3){
    tint(0, 0, 255, 126);
  }
  else if(output == 4){
    tint(255, 255, 255, 126);
  }
}
