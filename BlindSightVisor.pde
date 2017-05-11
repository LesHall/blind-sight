// by Les Hall
// started Thur May 11 2017 6:45AM central US time
// 



import processing.sound.*;



String filename = "Sierpinski_carpet_6.svg.png";
int numSources = 5;
float freqMin = 100.0;
float freqMax = 880.0;
PImage img = createImage(512, 512, RGB);
int iota;
color lineColor = color(255, 0, 255);
boolean fileAvailable = false;
float[] sum = {0.0};



SinOsc[] sine = {new SinOsc(this)};
SinOsc scanLine = new SinOsc(this);



void setup() {
  
  size(256, 256);
     
  // Create and start the sine oscillators
  sine[0] = new SinOsc(this);
  for (int s = 1; s < numSources; s++)
    sine = (SinOsc[]) append(sine, new SinOsc(this));
  
  // Start the Sine Oscillators
  for (int s = 0; s < numSources; s++)
    sine[s].play();
  
  // Set the pan of each oscillator
  for (int s = 0; s < numSources; s++)
    sine[s].pan(float(s)/float(numSources));
  scanLine.pan(0.5);
  
  // Set the amplitude of each oscillator
  for (int s = 0; s < numSources; s++)
    sine[s].amp(1.0/float(numSources));
  scanLine.amp(1.0);

  // initialize the sum array
  for (int s = 1; s < numSources; s++)
    sum = (float[]) append(sum, 0.0);
  
  stroke(lineColor);
  fill(lineColor);
  
  iota = width/numSources;
  img = loadImage(filename);
  img.resize(width, height);
  img.loadPixels(); 
  fileAvailable = false;

  selectInput("Select a file to process:", "fileSelected");
}



void draw() {

  int y = frameCount % height;  
  scanLine.freq(float(y)/float(height));
  
  if (fileAvailable) {
    
    for (int s = 0; s < numSources; s++) {
      
      int x = s * iota;
      for (int dx = 0; dx < iota; dx++)
        sum[s] += brightness(img.pixels[y*width + x + dx]) / 256.0;
      
      if ((y % iota) == (iota -1)) {

        float bright = sum[s] / iota / iota;
        float frequency = freqMin + bright * (freqMax - freqMin);
  
        sine[s].freq(frequency);
        
        stroke(color(255*bright));
        fill(color(255*bright));
        rect(s*iota, y-iota, iota-1, iota);
        
        sum[s] = 0;
      }
    }
  }
  
  stroke(lineColor);
  line(0, y, width, y);
}




void fileSelected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("User selected " + selection.getAbsolutePath());
    filename = selection.getAbsolutePath();
    img = loadImage(filename);
    img.resize(width, height);
    img.loadPixels(); 
    fileAvailable = true;
  }
}