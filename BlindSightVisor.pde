// by Les Hall
// started Thur May 11 2017 6:45AM central US time
// 



import processing.sound.*;


String filename = "lena_thumb.jpg";
int numSources = 2;
float freqMax = 440.0;
PImage img;
int iota;
color lineColor = color(255, 0, 255);



SinOsc[] sine = {new SinOsc(this)};



void setup() {
  
  size(512, 512);
  frameRate(10);
     
  // Create and start the sine oscillator.
  sine[0] = new SinOsc(this);
  for (int s = 1; s < numSources; ++s)
    sine = (SinOsc[]) append(sine, new SinOsc(this));
  
  // Start the Sine Oscillator. 
  for (int s = 1; s < numSources; ++s)
    sine[s].play();
  
  // Set the pan of each oscillator
  for (int s = 1; s < numSources; ++s)
    sine[s].pan(float(s)/float(numSources-1));
 
  img = loadImage(filename);
  img.resize(width, height);
  img.loadPixels();
  
  iota = img.width/numSources;
  
  stroke(lineColor);
  fill(lineColor);
}



void draw() {
  background(0);
  image(img, 0, 0);
  
  int y = frameCount % img.height;
  
  for (int x = 0; x < img.width; x += iota) {
    float sum = 0;
    for (int dx = 0; dx < iota; ++dx)
      sum += brightness(img.pixels[y*width + x + dx]) / 256.0;
    float bright = sum / iota;
    float frequency = bright * freqMax;
    for (int s = 1; s < numSources; ++s)
      sine[s].freq(frequency);
  }
  
  line(0, y, width-1, y);
}
