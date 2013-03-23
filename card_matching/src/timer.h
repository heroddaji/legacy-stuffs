#ifndef TIMER_H
#define TIMER_H


#include "SDL.h"


class timer
{
private:
	int startTicks;
	int pauseTicks;
	bool paused;
	bool started;
	


public:
	timer();
	void start();
	void pause();
	void unpause();
	void stop();
	int get_ticks();
	int waitASec(void *a);//this function only use by other thread

};
#endif