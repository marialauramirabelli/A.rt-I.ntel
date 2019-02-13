## Wekinator Assignment  
Video: https://youtu.be/4RyYUP0bcEA   
Processing code: [Wekinator Assignment](/Wekinator-Assignment/WekinatorAssignment.pde)

For this first assignment, the prompt was to carry out machine learning with more than two features into Wekinator to output different results depending on the classes created. What I've done is quite simple: I have a Processing sketch that uses OpenCV to access my laptop's camera and track a face (the first one that appears on-screen). The sketch creates a rectangle around the face and sends its upper right corner's x and y coordinates, as well as its width and height, to Wekinator.  
  
Wekinator was set up to receive four inputs and send one output back to the Processing sketch; machine learning was carried out using the k-Nearest Neighbour classification algorithm, dividing the training data into four classes. Processing receives that one ouput and tints the screen with a different color depending on the value it receives. These values/classes can be labeled as follows:
  
* left, close: the face is on the left of the screen (higher x value), close to it (higher width and height values)
* right, close: the face is on the right of the screen (lower x values), close to it  
  
![screen vertical](/Wekinator-Assignment/ImagesWekinatorAssignment/Screen1.png)  
  
* upper right corner, far: the face is above a diagonal that goes from the upper left corner to the lower right corner (x and y values above the diagonal), far from the screen (lower width and height values)
* lower left corner, far: the face is below a diagonal that goes from the upper left corner to the lower right corner, far from the screen 
  
![screen diagonal](/Wekinator-Assignment/ImagesWekinatorAssignment/Screen.png)  
  
For the screen to mirror what the camera captures, I used pushMatrix() and popMatrix() in the code (to invert the video along the y-axis). This is why the x values appear as "higher" on the left side of the screen and "lower" on the right side (which is the inverse of what's intuitive). Another aspect worth noticing is that the divisions between "left" and "right", and "above diagonal" and "below diagonal" learned by Wekinator (particularly in the case of the "close" classes) doesn't exactly correspond to what I intended. The position features (x and y values) could be improved; because they correspond to a corner of the face, no values are detected when that specific corner is not on-screen. This means that there are certain spots at the edge of the video where the presence of the face is ignored (this is what happens in the video at 0:18).
    
I decided to try using OpenCV after it was suggested in Goldsmith's online course "Machine Learning for Musicians and Artists"; deciding what to do with my sketch (interaction) though, and which features to send to Wekinator (choosing the features *is* as important as they say) was tricky. Several trials and adjustments were needed to set up a sketch that did (for the most part) what I expected it to do and smoothly communicated with Wekinator. But after this first experience, I find that Wekinator is a very useful and easy-to-use tool, particularly considering how much aid it can provide in programming.
