#include <Bela.h>
#include <libraries/OscSender/OscSender.h>
#include <libraries/OscReceiver/OscReceiver.h>
#include <cmath>
#include <iostream>
/*
For the example to work, run in a terminal on the board
```
node /root/Bela/resources/osc/osc.js
```
*/

OscSender oscSender;
int remotePort = 12000;
const char* remoteIp = "192.168.6.1";

// number of fingers to be tracked
const int num_fingers = 5;

// Analog in init
int gAudioFramesPerAnalogFrame = 0;

// Set the analog channels to read from
int gNumChannels = 1;
int gSensorInputVelocity = 0;


bool setup(BelaContext *context, void *userData){
	// Check if analog channels are enabled
	if(context->analogFrames == 0 || context->analogFrames > context->audioFrames) {
		rt_printf("Error: this example needs analog enabled, with 4 or 8 channels\n");
		return false;
	}

	// Useful calculations
	gAudioFramesPerAnalogFrame = context->audioFrames / context->analogFrames;
	
	// OSC setup 
	oscSender.setup(remotePort, remoteIp);
	return true;
}

void render(BelaContext *context, void *userData)
{
	static float velocity[num_fingers] = {10., 10., 10., 10., 10.};
	static int velocity_int[num_fingers] = {10, 10, 10, 10, 10};

	for(unsigned int n = 0; n < context->audioFrames; n++) {
		for(unsigned int channel_n = 0; channel_n < gNumChannels; channel_n++) {
			if(gAudioFramesPerAnalogFrame && !(n % gAudioFramesPerAnalogFrame)) {
				velocity[channel_n] = map(analogRead(context, n/gAudioFramesPerAnalogFrame, channel_n), 0, 1, 1, 9);
				velocity[channel_n] = round(velocity[channel_n]);
				velocity_int[channel_n] = (int) velocity[channel_n];
			}
		}
	}
	
    oscSender
	    .newMessage("/belapressure")
	    .add((int)velocity_int[0])
	    .add((int)velocity_int[1])
	    .add((int)velocity_int[2])
	    .add((int)velocity_int[3])
	    .add((int)velocity_int[4])
	    .send();
}

void cleanup(BelaContext *context, void *userData)
{

}
