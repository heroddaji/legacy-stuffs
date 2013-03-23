#ifndef BOARD_H
#define BOARD_H

#include "SDL.h"
#include "SDL_image.h"
#include "SDL_mixer.h"
#include "SDL_ttf.h"
#include "card.h"
#include <vector>
#include <time.h>
#include <stdlib.h>
#include "timer.h"
#include <string>
#include <sstream>
#include "SDL_thread.h"

using namespace std;

#define GOTCHA 0
#define NOWAY 1
#define NOTHING 2

#define EASY 100
#define NORMAL 101
#define HARD 102

#define REDRAW_FLAG 200

class board
{
private:

	SDL_Surface* screen;
	vector<card* > c_grids;
	vector<SDL_Rect> c_gridsPos;
	vector<int>matches;
	int nrOfPairs;
	vector<int> v_matchPairs;

	//timer of the game
	timer gameTime; 
	timer gameTime2; 
	SDL_Surface* timer_sur;

	TTF_Font *font;

	//score
	int score;
	SDL_Surface* score_sur;

	//sound	
	Mix_Chunk *sound ;

	//finish game
	int finish;
	
	
public:
	board(SDL_Surface* screen, int diff);
	void board_show();
	void board_generateMatches();
	void board_assignMatches();
	bool board_handleEvent(SDL_Event *gameEvent, bool *quit);
	int board_handleEvent_checkMouseCollision(int x, int y);
	int board_handleEvent_matchPairs();
	void board_reDrawCard(int rank);
	void board_timer();
	void board_finish();

	void board_handlerEvent_MouseDown(int x,int y);
	
	void clean();

  

};


#endif