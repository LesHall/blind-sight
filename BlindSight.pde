////////////////////////////////////////////
// 
// BlindSight
// 
//   generates a sine wave sound
//   with frequency varying with
//   brightness under finger position
// 
// created Sun Mar 19 2017
// for e-NABLE
// by Les Hall
// 
// 


/**
 * <p>Ketai Sensor Library for Android: http://KetaiProject.org</p>
 *
 * <p>Ketai Camera Features:
 * <ul>
 * <li>Interface for built-in camera</li>
 * <li>TODO: fix HACK of camera registration that currently exceptions in setup() at the moment.</li>
 * </ul>
 * <p>Updated: 2012-10-21 Daniel Sauter/j.duran</p>
 */
 

// special thanks to julienrat from the Processing.org forum for the sound code


import ketai.camera.*;
import android.media.*;
import android.content.res.*;


KetaiCamera cam;
PlaySound sineWave = new PlaySound();
boolean on = false;
int textHeight = 40;  // height of text in pixels
float freq = 20;  // frequency in Hz
float lastFreq = 0;  // previous frequency in Hz
float amp = 1;  // amplitude in Hz


void setup() {
  
  // screen init
  fullScreen();
  orientation(LANDSCAPE);
  imageMode(CENTER);
  frameRate(10);
  
  // text init
  textAlign(CENTER, CENTER);
  textHeight = width / 20;
  textSize(textHeight);
  
  // sine oscillator init  
  sineWave.genAmp(amp);  // amplitude
  sineWave.genTone(freq);   //frenquency  
}


void draw() {
  
  // draw the cam image and generate the sound if cam is available
  if(cam != null && cam.isStarted() ) {
  
    // draw the background color
    background(128, 0, 128);

    // save cam to an image file for accessing
    PImage img = cam;
    
    // filter the image to monochrome
    img.filter(GRAY);
    
    // scale the image
    float scaleWidth = (float) (width) / (float) (img.width);
    float scaleHeight = (float) (height) / (float) (img.height);
    float scale = ( scaleWidth > scaleHeight) ? scaleHeight : scaleWidth;
    
    // draw the image
    image(img, width/2, height/2, scale * img.width, scale * img.height);

    // calculate new frequency
    lastFreq = freq;
    int mX = (int) ((mouseX - width/2) / scale + img.width/2);
    int mY = (int) ((mouseY - height/2) / scale + img.height/2);
    freq = 80.0 + brightness( img.get(mX, mY) );
    
    // generate the audio
    if ( Math.abs( (lastFreq - freq) / (lastFreq + freq) ) > 0.02 )
      sineWave.genTone(freq);   // set the sine parameters

  } else {
  
    // draw the background color
    background(128, 0, 128);
    
    // draw welcome screen text
    text("BlindSight", width/2, height/2 - 3*textHeight);
    text("Touch to activate camera", width/2, height/2 + 2*textHeight);
    text("Touch menu key for flash on/off", width/2, height/2 + 3*textHeight);
  }
}


void onCameraPreviewEvent() {
  cam.read();
}


// start/stop camera preview by tapping the screen
void mousePressed() 
{
  //HACK: Instantiate camera once we are in the sketch itself
  if(cam == null)
      cam = new KetaiCamera(this, 640, 480, 24);
      
  if (!(cam.isStarted())) {
    cam.start();
    on = true;
    sineWave.playSound(on);
  }
}


void mouseReleased() {
  
  if (cam.isStarted()) {
    cam.stop();
    on = false;
    sineWave.playSound(on);
  }
}


void keyPressed() {
  
  if(cam == null)
    return;
    
  if (key == CODED) {
    if (keyCode == MENU) {
      if (cam.isFlashEnabled())
      
        cam.disableFlash();
      else
      
        cam.enableFlash();
    }
  }
}