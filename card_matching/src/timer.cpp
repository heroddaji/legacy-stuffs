#include "timer.h"

timer::timer()
{
	startTicks=0;
	pauseTicks=0;

	started = false;
	paused = false;
}

void timer::start()
{
	startTicks = SDL_GetTicks();

	started = true;
	paused = false;
}

void timer::stop()
{
	started = false;
	paused = false;
}

void timer::pause()
{
	if( started == true && paused ==false)
	{
		paused = true;
		pauseTicks = SDL_GetTicks() - startTicks;
	}
}
void timer::unpause()
{
	if(paused == true)
	{
		paused = false;

		startTicks = SDL_GetTicks() - pauseTicks;

		pauseTicks = 0;
	}
}

int timer::get_ticks()
{
	if(started == true)
	{
		if(paused == true)
		{
			return pauseTicks;
		}
		else return SDL_GetTicks()-startTicks;
	}

	return 0;
}

int timer::waitASec(void *a)
{
	int sec = 1 ;//time to wait
	int begin = SDL_GetTicks();
	int lap = (SDL_GetTicks()-begin) /1000;
	while( lap < sec)
	{
		lap = (SDL_GetTicks()-begin) /1000;
	}
	if(lap >= sec)
		return 1;

	return 0;
}

