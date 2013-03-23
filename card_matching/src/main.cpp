#include "SDL.h"
#include "SDL_image.h"
#include "SDL_mixer.h"
#include "SDL_ttf.h"
#include <fstream>
#include "board.h"
#include "timer.h"
using namespace std;


//global var
fstream logFile("log.txt");
int mX, mY;

SDL_Rect r_button[3];	
SDL_Rect r_button_effect[3];

#define SCREEN_WIDTH 800
#define SCREEN_HEIGHT 600
#define SCREEN_BPP 32

#define PLAY 300
#define OPTION 301
#define QUIT 302
#define WELCOME 303
#define NEWGAME 304


int button_effect(SDL_Surface * screen, SDL_Surface * effect_sur);
//extra function
void init();

int main(int argc, char* args[])
{	
	//first initial
	init();
	//all the surface
	SDL_Surface *screen=NULL;	
	SDL_Surface *background_sur=NULL;
	SDL_Surface* effect_sur;//effect surface
	SDL_Surface* welcome_sur = NULL;
	SDL_Surface* arrow_sur = NULL;
	SDL_Surface* option_sur = NULL;
	
	//load image
	background_sur = IMG_Load("background.dll");
	effect_sur = IMG_Load("effect.dll");
	welcome_sur=IMG_Load("welcome.dll");
	arrow_sur=IMG_Load("arrow.dll");
	option_sur=IMG_Load("option.dll");

	//posstion of sur
	SDL_Rect welcome_rec;
	welcome_rec.x = 250;
	welcome_rec.y = 20;

	SDL_Rect option_rec;
	option_rec.x = 350;
	option_rec.y = 20;

	SDL_Rect arrow_rec[3];
	arrow_rec[0].x = 345;
	arrow_rec[0].y = 50;

	arrow_rec[1] = arrow_rec[0];
	arrow_rec[1].y = arrow_rec[0].y + 96;
	arrow_rec[2] = arrow_rec[1];
	arrow_rec[2].y = arrow_rec[1].y + 96;
	
	//setup screen
	screen = SDL_SetVideoMode(SCREEN_WIDTH,SCREEN_HEIGHT,SCREEN_BPP,SDL_SWSURFACE);
	
	//this is the menu part

	//some variable
	int option_pos=0;
	int flag=WELCOME;
	bool start = false;
	//the while loop of menu event
	bool menu_quit = false;		
	SDL_Event menuEvent;
	

	while (menu_quit != true)
	{
		while(SDL_PollEvent(&menuEvent))
		{
				switch(menuEvent.type)
				{
					case SDL_QUIT:
					return 0;

					case SDL_MOUSEMOTION:
					{
						mX = menuEvent.motion.x;
						mY = menuEvent.motion.y;
					}break;

					case SDL_MOUSEBUTTONDOWN:
					{
						if(button_effect(screen,background_sur)==0)
						{
							flag = PLAY;							
							menu_quit = true;
							start = true;
						}
						else if(button_effect(screen,background_sur)==1)
						{
							flag = OPTION;
						}
						else if(button_effect(screen,background_sur)==2)
							return 0;
					}break;

					case SDL_KEYDOWN:
					{
						if(menuEvent.key.keysym.sym == SDLK_UP)
							option_pos != 0 ? option_pos-- : option_pos = 2;
						if(menuEvent.key.keysym.sym == SDLK_DOWN)
							option_pos != 2 ? option_pos++ : option_pos = 0;
						if(menuEvent.key.keysym.sym == SDLK_RETURN )
							flag = WELCOME;
					}break;
				}
		}
		//draw menu
		SDL_BlitSurface(background_sur,NULL,screen,NULL);
		if(flag == WELCOME)
		{
			SDL_BlitSurface(welcome_sur,NULL,screen,&welcome_rec);
		}
		else if(flag == OPTION)
		{
			SDL_BlitSurface(option_sur,NULL,screen,&option_rec);
			SDL_BlitSurface(arrow_sur,NULL,screen,&arrow_rec[option_pos]);
		}
		button_effect(screen,effect_sur);		
		SDL_Flip(screen);
		
	}	
	//////////////////////////////////
	

	//the game looop
	bool quit = false;		
	SDL_Event gameEvent;
	board * myBoard;
	board * p_board = new board(screen,option_pos+100);//option_pos is the level of dificultty	 	
	myBoard = p_board;
	while(quit != true && start == true)
	{

		while(SDL_PollEvent(&gameEvent))
		{
			switch(gameEvent.type)
			{
				case SDL_QUIT:
					return 0;

				case SDL_MOUSEMOTION:
				{
					mX = gameEvent.motion.x;
					mY = gameEvent.motion.y;
					
				}break;

				case SDL_MOUSEBUTTONDOWN:
				{
					if(button_effect(screen,background_sur)==0)
						{
							flag = NEWGAME;	
						}
						else if(button_effect(screen,background_sur)==1)
						{
							flag = OPTION;
						}
						else if(button_effect(screen,background_sur)==2)
							return 0;
						if(flag == PLAY)
						{
							myBoard->board_handlerEvent_MouseDown(gameEvent.button.x,gameEvent.button.y);
						}
						if(flag == NEWGAME)
						{	
							delete p_board;
							board * p_board = new board(screen,option_pos+100);//option_pos is the level of dificultty	 	
							myBoard = p_board;
							flag = PLAY;
						}						
				
				}break;

				case SDL_KEYDOWN:
				{
					if(flag == OPTION)
					{
						if(gameEvent.key.keysym.sym == SDLK_UP)
							option_pos != 0 ? option_pos-- : option_pos = 2;
						if(gameEvent.key.keysym.sym == SDLK_DOWN)
							option_pos != 2 ? option_pos++ : option_pos = 0;
						if(gameEvent.key.keysym.sym == SDLK_RETURN )
							flag = WELCOME;
					}
				}break;
			}
			
		}			
		//draw background
		SDL_BlitSurface(background_sur,NULL,screen,NULL);		
		
		if(flag == WELCOME)
		{
			SDL_BlitSurface(welcome_sur,NULL,screen,&welcome_rec);
		}
		else if(flag == OPTION)
		{
			SDL_BlitSurface(option_sur,NULL,screen,&option_rec);
			SDL_BlitSurface(arrow_sur,NULL,screen,&arrow_rec[option_pos]);
		}

		button_effect(screen,effect_sur);
		if(flag == PLAY)
		{
			myBoard->board_show();			
		}
		SDL_Flip(screen);				
	}

	logFile.close();
	delete myBoard;
	delete p_board;
	return 0;
}

void init()
{
	if(SDL_Init(SDL_INIT_EVERYTHING)==-1)
	{
		return;
	}
	logFile<<"init() success\n";

	//initilize audio
	int audio_rate = 22050;
	Uint16 audio_format = AUDIO_S16SYS;
	int audio_chanels = 2;
	int audio_buffers = 4096;
	if(Mix_OpenAudio(audio_rate, audio_format, audio_chanels,audio_buffers) != 0)
	{
		return ;
	}
	
	if(TTF_Init() == -1)
		return ;


	//0 for play button
	r_button[0].x = 35;
	r_button[0].y = 312;
	r_button[0].w = 87;
	r_button[0].h = 84;
	
	//1 for button option
	r_button[1] = r_button[0];
	r_button[1].y = r_button[0].y + r_button[0].h + 9;

	//2 for button quit
	r_button[2] = r_button[1];
	r_button[2].y = r_button[1].y + r_button[1].h + 11;

	

	r_button_effect[0].x = 2;
	r_button_effect[0].y = 0;
	r_button_effect[0].w = 92;
	r_button_effect[0].h = 87;

	//1 for button option
	r_button_effect[1] = r_button_effect[0];
	r_button_effect[1].y = r_button_effect[0].y + r_button_effect[0].h + 8;

	r_button_effect[2] = r_button_effect[1];
	r_button_effect[2].y = r_button_effect[1].y + r_button_effect[1].h + 8;

	//set icon and caption
	SDL_Surface *icon = IMG_Load("icon.ico");
	SDL_WM_SetIcon(icon,NULL);
	SDL_WM_SetCaption("Card Matching - Presented to you by Tran Hoang Dai","icon.ico");
}



int button_effect(SDL_Surface * screen, SDL_Surface * effect_sur)
{
	for (int i=0;i<3;i++)
	{
		if(    mX > r_button[i].x && mX < r_button[i].x + r_button[i].w 
			&& mY > r_button[i].y && mY < r_button[i].y + r_button[i].h )
		{
			SDL_BlitSurface(effect_sur,&r_button_effect[i],screen,&r_button[i]);
			return i;
		}		
	}	
	return -1;
}