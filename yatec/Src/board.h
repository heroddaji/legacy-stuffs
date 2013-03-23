#ifndef BOARD_H
#define BOARD_H

#include "SDL.h"
#include "SDL_ttf.h"
#include "SDL_mixer.h"
#include "SDL_image.h"
#include "time.h"
#include <vector>
#include "stdio.h"
#include <sstream>
#include <fstream>

using namespace std;

#define BLOCK_I 100
#define BLOCK_L 101
#define BLOCK_L2 102
#define BLOCK_T 103
#define BLOCK_O 104
#define BLOCK_Z 105
#define BLOCK_Z2 106

#define HIT_WALL 200
#define HIT_BOTTOM 201
#define HIT_BLOCK 202//hit the block when move left or right
#define HIT_PERMANENT_BLOCK 203 //hit the block when move down, so add in to permannet
#define HIT_NOTHING 204


//define board row, column and size of block
const int BROW = 17;
const int BCOLUMN = 10;
const int BSIZE = 30;

const int NODRAW = 0;
const int RED = 1;
const int GREEN = 2;
const int BLUE = 3;
const int PINK = 4;
const int CYAN = 5;
const int DARK = 6;
const int WHILE = 7;
const int GREY = 8;

const int MOVELEFT = 300;
const int MOVERIGHT = 301;
const int MOVEDOWN = 302;
const int MOVEROTATE = 303;

struct piece{
	int size[4][4];
	int x;
	int y;
};

class board{
private:
	//board info
	int boardSize[BROW][BCOLUMN+1];
	int real_boardSize[BROW][BCOLUMN+1];
	SDL_Rect r_boardSize[BROW][BCOLUMN];
	
	SDL_Surface *screen;
	SDL_Surface *block_sur;
	SDL_Surface *nextBlock_sur;
	SDL_Surface *timer_sur;
	
	piece block; //current block
	piece next_block; //next block
	int block_h; //height of a block
	int block_l; //lenght of a block	

	double level_timer; //time to control move and level up
	int level;//level of the game

	//rect store color
	SDL_Rect r_color[8];
	SDL_Rect r_nextColor[8];

	SDL_Rect r_nextBlock[4][4];

	//font
	TTF_Font* font;	

	vector<int> scoreLine; //hold the offset of the score line

	//sound
	Mix_Chunk *soundRotate;
	Mix_Chunk *soundDrop;
	Mix_Chunk *soundScore;
	Mix_Chunk *soundOver;

	//score and line
	int score;	
	int highestScore;	
	int line;
	SDL_Surface *score_sur;
	
	//gameover
	bool gameOver;


public:
	board(SDL_Surface *,int level);
	void newBlock();//generate new block
	void makeBlock(piece &bl,int ra,int raCo);
	void move(int move); //move to left or right
	void updateBoard(); //update the board grid
	void rotateBlock();	
	int rotateCheck(piece &temp);
	int checkCollision(int move);
	void addPermanentBlock(); //add block into the real board size
	void draw();
	void timerAndLevel();
	void timer();
	void clear();
	bool checkGameOver();
	void setGameOver();
	void saveScore();
	int getScore();
	int getHScore();
	void autoMove();
	void normalMove();
};
#endif
