#include <iostream>
using namespace std;
#include "board.h"

//function
void init();
void deinit();

//global variable
const int SWIDTH = 600;
const int SHEIGHT = 600;
const int SBPP = 32;	
SDL_Surface *screen;

//sound and music
Mix_Music *introMusic;
Mix_Music *gameMusic;


int main( int argc, char* args[]) {
	//initialize
	init();

	//set random
	srand(unsigned(time));

	screen = SDL_SetVideoMode(SWIDTH,SHEIGHT,SBPP,SDL_HWSURFACE | SDL_DOUBLEBUF);//setup screen and double buffer

	SDL_Surface *boardBackground_sur = IMG_Load("board_background.dat");//board image
	SDL_Surface *menu_sur = IMG_Load("welcome.dat");//the menu image
	SDL_Surface *cursor_sur = IMG_Load("cursor.dat");//image of cursor use in menu
	SDL_Surface *levelText_sur = NULL;//text to show the level of gameplay

	bool gameQuit = false;
	bool menuQuit = false;
	
	//rect hold position of menu choices
	SDL_Rect r_menuChoice[4]; //0,1,2 use for choose menu, 3 for level
	r_menuChoice[0].x = 190;
	r_menuChoice[0].y = 350;
	r_menuChoice[0].w = 48;
	r_menuChoice[0].h = 48;

	r_menuChoice[1] = r_menuChoice[0];
	r_menuChoice[1].y = r_menuChoice[0].y + 57;

	r_menuChoice[2] = r_menuChoice[1];
	r_menuChoice[2].y = r_menuChoice[1].y + 117;

	r_menuChoice[3] = r_menuChoice[1];
	r_menuChoice[3].y = r_menuChoice[1].y + 43;
	r_menuChoice[3].x = r_menuChoice[1].x + 87;

	int atOption=0;//which option you choose?	
	stringstream out;
	string levelText="";
	int level = 1;
	out<< level;
	levelText = out.str();
	TTF_Font *font;
	int textSize = 70;
	font = TTF_OpenFont("font.dll",textSize);
	SDL_Color color = {255,35,35};//color of the text game level	

	levelText_sur = TTF_RenderText_Solid(font,levelText.c_str(),color);

	//Map the color key to make cursor transparent
	Uint32 colorkey = SDL_MapRGB( cursor_sur->format, 0xFF, 0xFF, 0xFF );	
	SDL_SetColorKey( cursor_sur, SDL_SRCCOLORKEY, colorkey ); 
	
	Mix_VolumeMusic(MIX_MAX_VOLUME/2);//set volum to half
	//play introMusic
	Mix_PlayMusic(introMusic,-1);
	

	//menu loop
	SDL_Event menuEvent;
	while(menuQuit != true){		

		while(SDL_PollEvent(&menuEvent)){
			switch(menuEvent.type){
				case SDL_QUIT:{
					menuQuit = true;
				}break;	

				case SDL_KEYDOWN:{					
					if(menuEvent.key.keysym.sym == SDLK_ESCAPE){						
						menuQuit = true;
						gameQuit = true;
					}
					if(menuEvent.key.keysym.sym == SDLK_DOWN){	//change place of cursor at proper option					
						atOption>=2?atOption=0:atOption++;
					}
					if(menuEvent.key.keysym.sym == SDLK_UP){//change place of cursor at proper option			
						atOption<=0?atOption=2:atOption--;
					}
					if(menuEvent.key.keysym.sym == SDLK_RETURN){						
						if(atOption == 0){
							Mix_HaltMusic();
							Mix_FreeMusic(introMusic);
							// fade out music to finish 3 seconds from now
							//while(!Mix_FadeOutMusic(1000) && Mix_PlayingMusic()) {
							//	// wait for any fades to complete
							//	SDL_Delay(1000);
							//}
							menuQuit = true;						
						}
						if(atOption == 2){
							menuQuit = true;
							gameQuit = true;
						}
					}
					if(menuEvent.key.keysym.sym == SDLK_LEFT){
						//change level here
						if(atOption == 1){
							level <= 1 ? level = 9: level--;
							stringstream out2;
							out2<< level;
							levelText = out2.str();
							levelText_sur = TTF_RenderText_Solid(font,levelText.c_str(),color);
						}
					}
					if(menuEvent.key.keysym.sym == SDLK_RIGHT){
						if(atOption == 1){
							level >= 9 ? level = 1: level++;
							stringstream out2;
							out2<< level;
							levelText = out2.str();
							levelText_sur = TTF_RenderText_Solid(font,levelText.c_str(),color);
						}
					}
				}break;		
			}
		}
		SDL_BlitSurface(menu_sur,NULL,screen,NULL);//blit menu board
		SDL_BlitSurface(cursor_sur,NULL,screen,&r_menuChoice[atOption]);//blit cursor
		SDL_BlitSurface(levelText_sur,NULL,screen,&r_menuChoice[3]);//blit level text
		SDL_Flip(screen);
	}
	//end menu loop
	
	int score = 0,hScore=0;

	//play gameMusic
	Mix_PlayMusic(gameMusic,-1);
	
	board tetrisBoard(screen,level);//creat the board with level user choose		
	//game loop
	SDL_Event gameEvent;	 
	while(gameQuit != true)	{

		//check game Over
		if(tetrisBoard.checkGameOver() == true){
			gameQuit = true;
	
			hScore = tetrisBoard.getHScore();
			score = tetrisBoard.getScore();

					//clear
			tetrisBoard.clear();
		}

		//check for event
		while(SDL_PollEvent(&gameEvent)){
			switch(gameEvent.type){

				case SDL_QUIT:{
					//get score
					hScore = tetrisBoard.getHScore();
					score = tetrisBoard.getScore();

					tetrisBoard.setGameOver();
					tetrisBoard.clear();
					gameQuit = true;					
				}break;						
				
				case SDL_KEYDOWN:{					
					if(gameEvent.key.keysym.sym == SDLK_ESCAPE){
							//get score
						hScore = tetrisBoard.getHScore();
						score = tetrisBoard.getScore();

						tetrisBoard.setGameOver();
						tetrisBoard.clear();
					
						gameQuit = true;
					}		

					if(gameEvent.key.keysym.sym == SDLK_SPACE){
						tetrisBoard.autoMove();
					}
				}break;			

			}
			//get the key state
			Uint8 *keyState = SDL_GetKeyState(NULL);
			if(keyState[SDLK_DOWN])	{
				tetrisBoard.move(MOVEDOWN);
			}
			//if press button left or right, then move
			if(keyState[SDLK_LEFT]){
				tetrisBoard.move(MOVELEFT);
			}
			if(keyState[SDLK_RIGHT]){
				tetrisBoard.move(MOVERIGHT);
			}
			//if press up. rotate
			if(keyState[SDLK_UP]){
				tetrisBoard.rotateBlock();									
			}		
		}

		//apply move down base on level of game
		tetrisBoard.timerAndLevel();

		//draw		
		SDL_BlitSurface(boardBackground_sur,NULL,screen,NULL);
		tetrisBoard.draw();
		SDL_Flip(screen);
		
	}

	//finally, show the end screen and score
	SDL_Surface *end_sur = IMG_Load("gameOver.dat");
	SDL_BlitSurface(end_sur,NULL,screen,NULL);

	//blit score
	SDL_Rect fill;
	fill.x = 260;
	fill.y = 230;	
	stringstream scoreOut;
	scoreOut << score;
//	SDL_Color color = {255,35,35};
	string scoreTex = scoreOut.str();
	levelText_sur = TTF_RenderText_Solid(font,scoreTex.c_str(),color);
	SDL_BlitSurface(levelText_sur,NULL,screen,&fill);

	//blit highest score
	fill.x = 390;
	fill.y = 320;	
	stringstream scoreOut2;
	scoreOut2 << hScore;	
	string scoreTex2 = scoreOut2.str();
	levelText_sur = TTF_RenderText_Solid(font,scoreTex2.c_str(),color);
	SDL_BlitSurface(levelText_sur,NULL,screen,&fill);
	
	SDL_Flip(screen);
	SDL_Delay(1000);
	
	deinit();
	return 0;
}

void init() {	

	//ini Sdl system
	SDL_Init(SDL_INIT_EVERYTHING);
	//ini sdl font
	if(TTF_Init() == -1)
		return ;
	
	//initilize audio
	int audio_rate = 22050;
	Uint16 audio_format = AUDIO_S16SYS;
	int audio_chanels = 2;
	int audio_buffers = 4096;
	if(Mix_OpenAudio(audio_rate, audio_format, audio_chanels,audio_buffers) != 0){
		return ;
	}

	introMusic = Mix_LoadMUS("audio\\intro.ogg");
	gameMusic = Mix_LoadMUS("audio\\music.ogg");
	

	//setup window
	screen = NULL;	
	SDL_WM_SetCaption("A Tetris Clone - Presented to you by Tran Hoang Dai","icon.bmp");
	SDL_Surface *icon = SDL_LoadBMP("icon.bmp");
	SDL_WM_SetIcon(icon,NULL);
}

void deinit() {	
	SDL_ClearError();
	SDL_Quit();		
}
