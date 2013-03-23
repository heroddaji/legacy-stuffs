#ifndef CARD_H
#define CARD_H

#include "SDL.h"
#include "SDL_image.h"
#include "SDL_mixer.h"
#include "SDL_ttf.h"

#define CARD_BLOCKFACE 13
#define CARD_DISFACE 14
#define OPEN 1
#define CLOSE 0

class card
{
private:
	SDL_Surface * sur; 	
	
	SDL_Rect r_size;//size of the card
	SDL_Rect r_cardsAllFaces[15];
	SDL_Rect r_cardFace;
	SDL_Rect r_cardPos;

	int state;
	int dis_state;
	int openFace_nr;
public:
	card();
	SDL_Surface* card_sur();

	SDL_Rect card_getFace();	//return the face of card, can be open or close face
	void card_setOpenFace(int rank); //set the open face
	
	int card_getOpenFace(); //return the open face

	SDL_Rect card_getPos();
	void card_setPos(int x, int y);

	void card_changeState(); //change state open or close
	void card_setDiscoveredFace(); //set the final face when it match a pair
	void card_setCloseFace();
	bool card_isOpen();	

};


#endif