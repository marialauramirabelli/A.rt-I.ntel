// Daniel Shiffman
// http://youtube.com/thecodingtrain
// http://codingtra.in

// Transfer Learning Feature Extractor Regression with ml5
// https://youtu.be/aKgq0m1YjvQ

let mobilenet;
let predictor;
let video;
let value = 0.5;
let slider;
let addButton;
let trainButton;

function modelReady() {
  console.log('Model is ready!!!');
}

function videoReady() {
  console.log('Video is ready!!!');
}

function whileTraining(loss) {
  if (loss == null) {
    console.log('Training Complete');
    predictor.predict(gotResults);
  } else {
    console.log(loss);
  }
}


function gotResults(error, result) {
  if (error) {
    console.error(error);
  } else {
    value = result;
    predictor.predict(gotResults);
  }
}

function setup() {
  createCanvas(320, 470);
  video = createCapture(VIDEO);
  video.hide();
  background(0);
  mobilenet = ml5.featureExtractor('MobileNet', modelReady);
  predictor = mobilenet.regression(video, videoReady);

  slider = createSlider(0, 1, 0.5, 0.01);

  addButton = createButton('add example image');
  addButton.mousePressed(function() {
  	console.log("Example added.");
    predictor.addImage(slider.value());
  });


  trainButton = createButton('train');
  trainButton.mousePressed(function() {
    predictor.train(whileTraining);
  });

}

function draw() {
  background(0);

  image(video, 0, 0, 320, 240);
  //rectMode(CENTER);
  //fill(hue, 100, 100);
  //rect(0, 0, 320, 240);

  fill(255);
  textSize(16);
  text(value, 10, height - 10);

  line(0, 240/8, 320, 240/8);
  line(0, 240/8*2, 320, 240/8*2);
  line(0, 240/8*3, 320, 240/8*3);
  line(0, 240/8*4, 320, 240/8*4);
  line(0, 240/8*5, 320, 240/8*5);
  line(0, 240/8*6, 320, 240/8*6);
  line(0, 240/8*7, 320, 240/8*7);

  fill (150, 100, 0);

  triangle(206, 192 + 200, 186, 500, 226, 500);

  var val = map(value, 0, 1, -200, 200);

  fill (0, 255, 100);

  curve(150, 100 + 200, 254 + val, 145 + 200, 206, 192 + 200, 100, 100 + 200);
  curve(150, 100 + 200, 200 + val, 100 + 200, 206, 192 + 200, 100, 100 + 200);
  curve(150, 100 + 200, 250 + val, 75 + 200, 206, 192 + 200, 100, 100 + 200);
  curve(150, 300 + 200, 175 + val, 95 + 200, 206, 192 + 200, 100, 100 + 200);
  curve(80, 300 + 200, 130 + val, 130 + 200, 206, 192 + 200, 100, 100 + 200);
  curve(80, 300 + 200, 100 + val, 160 + 200, 206, 192 + 200, 100, 200 + 200);
}
