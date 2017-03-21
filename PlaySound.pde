// special thanks to julienrat from the Processing.org forum for the sound code


public class PlaySound {
  private final int sampleRate = 8000;
  private final int numSamples = sampleRate;
  private final double samples[] = new double[numSamples];
  private final byte generatedSnd[] = new byte[2*(numSamples)];
  double amplitude = 1;
 
   // special thanks to julienrat from the Processing.org forum for the sound code

  
  final AudioTrack audioTrack = new AudioTrack(AudioManager.STREAM_MUSIC, 
  sampleRate, 1, //AudioFormat.CHANNEL_CONFIGURATION_MONO, // changed to constant
  AudioFormat.ENCODING_PCM_16BIT, numSamples, 
  AudioTrack.MODE_STATIC);

  void genAmp(double amp) {
    amplitude = amp;
  }
 
  void genTone(double freqOfTone) {
    // fill out the array
 
    for (int i = 0; i < numSamples; ++i) {
      samples[i] = amplitude * Math.sin(2 * Math.PI * i / (sampleRate/freqOfTone));
    }
    // convert to 16 bit pcm sound array
    // assumes the sample buffer is normalised.
    int idx = 0;
    for (double dVal : samples) {
      // scale to maximum amplitude
      short val = (short) ((dVal * 32767));
      // in 16 bit wav PCM, first byte is the low order byte
      generatedSnd[idx++] = (byte) (val & 0x00ff);
      generatedSnd[idx++] = (byte) ((val & 0xff00) >>> 8);
    }
    audioTrack.write(generatedSnd, 0, numSamples*2);
    audioTrack.setLoopPoints(0, numSamples/2, -1);
  }
 
  void playSound(boolean on) {
    if (on) {
 
      audioTrack.play();
    }
    else {
      audioTrack.pause();
    }
  }
}