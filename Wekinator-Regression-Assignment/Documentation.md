## Wekinator Regression Assignment  
Video: https://youtu.be/ndfyj7X5XAE   
Arduino code: [Inputs](/Wekinator-Regression-Assignment/AnalogInputsArduino.ino)  
Processing code: [Outputs](/Wekinator-Regression-Assignment/Processing_SerialAndOutputs.pde)
    
For this regression assignment, my intention was to use three analog inputs read by an Arduino - I used a MKR 1010, which I've been using for another course - to combine them in some unique way as Wekinator inputs. I chose two potentiometers and a photoresistor, as shown in the image below.  
  
![circuit](/Wekinator-Regression-Assignment/ImagesRegressionAssignment/Circuit.jpg)  
  
I originally wanted to work with sound, which was used often in Goldsmith's online course "Machine Learning for Musicians and Artists", potentially using different sound files and alternating between them, and/or changing aspects like volume and playback rate. However, I had two main problems.  
- The first one was related to the sound libraries I tried. The Processing Sound library and the Minim library have methods to manipulate aspects of sound files, but they didn't work consistently. Not necessarily because of how I trained the inputs and translated them to sound, but because these libraries methods would fail every now and then, as the Processing console let me know with error messages.  
- I couldn't really figure out a logic to the outputs that made sense. I tried training different (sometimes random) combinations of the Wekinator output sliders but realized they didn't result in good interactions.  
  
I was aware that mapping the inputs to the outputs in any way that could easily be done without machine learning was not the purpose of using Wekinator. But it was more difficult than I expected to come up with a concept in which machine learning would be much more efficient than coding for the outputs. I think this might be mostly due to a difficulty with trying to think outside of the limits of that which I *know* how to code; I had a hard time imagining possibilites for outputs that were beyond what I could imagine doing in Processing with machine learning. I think this in itself is evidence of the power of machine learning and artificial intelligence, which can solve situations we might not even conceive of (thought this one was really quite simple, just complicated for me).
  
I ended up creating a circle in Processing for which the photoresistor controls the diameter and the potentiometers control the hue and saturation in HSB color mode (the video shows this, though it's unclear at first which input controls the diameter - I put my hand in front of the lamp that's over the photoresistor as I move a potentiometer, making it look like the pot changes the size when it's really the photoresistor). This is clearly very simple to do without machine learning, so given more time I would change these results to have other ouputs and create an interaction in which the power of regression as a method to create algorithms is much better demonstrated.
