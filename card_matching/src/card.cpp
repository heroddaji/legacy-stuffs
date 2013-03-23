#include "card.h"

card::card()
{
	state = CLOSE;
	dis_state = CLOSE;
	state = OPEN;
	int numOfFaceOnImage = 15;
	int numOfFacePerRow = 4;

	sur = IMG_Load("card2.dll");
	//map the color to set it transparent
	/*Uint32 colorkey = SDL_MapRGB(sur->format,0xFF,0xFF,0xFF);
	SDL_SetColorKey(sur,SDL_SRCCOLORKEY,colorkey);*/

	int ww=95;
	int hh=125;
	//setup pos for all cards image
	for(int i = 0 ; i<numOfFaceOnImage;i++)
	{
		if(i==8)
		{
			int a=0;
		}
		if(i==0)
		{
			r_cardsAllFaces[i].x = 0; 
			r_cardsAllFaces[i].y = 0;
			r_cardsAllFaces[i].w = ww;
			r_cardsAllFaces[i].h = hh;
		}
		if(i>0)
		{
			r_cardsAllFaces[i].x = r_cardsAllFaces[i-1].x+ww; 
			r_cardsAllFaces[i].y = r_cardsAllFaces[i-1].y;
			r_cardsAllFaces[i].w = ww;
			r_cardsAllFaces[i].h = hh;
		}		
		if(i%numOfFacePerRow==0 && i!=0)
		{
			r_cardsAllFaces[i].x = 0; 
			r_cardsAllFaces[i].y = r_cardsAllFaces[i-1].y+hh;
			r_cardsAllFaces[i].w = ww;
			r_cardsAllFaces[i].h = hh;
		}		
	}
	
}

SDL_Rect card::card_getFace()
{
	if(state == CLOSE)
		return r_cardsAllFaces[CARD_BLOCKFACE];
	else
		return r_cardFace;
}

int card::card_getOpenFace()
{	
	return openFace_nr;
}
SDL_Surface* card::card_sur()
{
	return sur;
}

void card::card_setOpenFace(int rank)
{
	openFace_nr = rank;
	r_cardFace = r_cardsAllFaces[rank];
	state = OPEN;
}

void card::card_setCloseFace()
{		
	state = CLOSE;
}

void card::card_changeState()
{
	//first check is it got discovred
	if(dis_state != OPEN)
	{
		if(state == OPEN)
			state = CLOSE;
		else if (state == CLOSE)
			state = OPEN;
	}
}

void card::card_setDiscoveredFace()
{
	r_cardFace = r_cardsAllFaces[CARD_DISFACE];
	dis_state = OPEN;
}

bool card::card_isOpen()
{
	if(state == OPEN)
		return true;
	else return false;
}