#include "board.h"

int ww = 100;
int hh = 130;
int flag=0;
int tt=0;

int faceA,faceB;

int mousex, mousey;

int count1=0;

board::board(SDL_Surface *screen, int diff)
{
	int cRow;
	int cColumn=4;
	switch(diff)
	{
	case EASY:
		{ 
			cRow = 4;
			nrOfPairs = 8;
		}break;
	case NORMAL:
		{ 
			cRow = 5;
			nrOfPairs = 10;
		}break;
	case HARD:
		{ 
			cRow = 6;
			nrOfPairs = 12;
		}break;
	}
	this->screen = screen;	
	
	
	//create the cards, and total of them = double the nrOfPairs
	for(int i = 0;i<nrOfPairs*2;i++)
	{		
		card *myCard = new card();		
		c_grids.push_back(myCard);					
	}
	
	//generate the card Positioin on screen
	int startX = 0;
	int startY = 0;
	int beginX = 150;
	int beginY = 0;
	int endX = 800;
	int endY = 600;
	
		
		startX = ((endX - beginX)-(ww*cRow))/2+beginX;
		startY = ((endY - beginY)-(hh*cColumn))/2 + beginY;
	
	for(int i = 0;i<nrOfPairs*2;i++)
	{	
		SDL_Rect myCardPos;
		c_gridsPos.push_back(myCardPos);
		if(i==0)
		{
			c_gridsPos[i].x = startX;
			c_gridsPos[i].y = startY;
			/*c_gridsPos[i].w = ww;
			c_gridsPos[i].y = hh;*/
		}
		if(i>0)
		{
			c_gridsPos[i].x = c_gridsPos[i-1].x+ww;
			c_gridsPos[i].y = c_gridsPos[i-1].y ;
			/*c_gridsPos[i].w = ww;
			c_gridsPos[i].y = hh;*/
		}
		if(i%cRow == 0 && i!=0)
		{
			c_gridsPos[i].x = startX;
			c_gridsPos[i].y = c_gridsPos[i-1].y+hh ;
			/*c_gridsPos[i].w = ww;
			c_gridsPos[i].y = hh;*/
		}		
	}
	
	//seed random
	srand(unsigned(time(0)));

	//make random matches
	this->board_generateMatches();
	//then assign the random matches to card faces
	this->board_assignMatches();
	//start the timer
	gameTime.start();
	gameTime2.start();

	//load other thing like font, sound..
	int textSize = 50;	
	font = TTF_OpenFont("font.dll",textSize);
	
	//set score	
	score = 0;
	
	//sound
	sound = Mix_LoadWAV("sound.wav");

	//finish
	finish = 0;
}


void board::board_generateMatches()
{
	int numOfFace = 13;
	
	//make this vector will contain 13 faces, then each time pick random one face in this vector, and add it the list of pairs
	vector<int>ranVec;
	
	for(int i=0;i<numOfFace;i++)
		ranVec.push_back(i);
	
	//if the list of pair is less then total faces, then random normlal
	if(nrOfPairs <= numOfFace)
	{
		for(int i=0;i<nrOfPairs;i++)
		{
			int ran = rand() % ranVec.size();
			matches.push_back(ranVec[ran]);
			matches.push_back(ranVec[ran]);
			ranVec.erase(ranVec.begin()+ran);
		}
	}

	//else do normal, then resit and do normal again
	if(nrOfPairs > numOfFace)
	{
		for(int i=0;i<numOfFace;i++)
		{
			int ran = rand() % ranVec.size();
			matches.push_back(ranVec[ran]);
			matches.push_back(ranVec[ran]);
			ranVec.erase(ranVec.begin()+ran);
		}
		//numofPait change here
		nrOfPairs = nrOfPairs - numOfFace;

		for(int i=0;i<numOfFace;i++)
			ranVec.push_back(i);

		for(int i=0;i<nrOfPairs;i++)
		{
			int ran = rand() % ranVec.size();
			matches.push_back(ranVec[ran]);
			matches.push_back(ranVec[ran]);
			ranVec.erase(ranVec.begin()+ran);
		}
	}
}


void board::board_assignMatches()
{
	int size = matches.size();
	//assign random face to each card, each time a face is assigned, the matches vector erase one element and keep going
	for(int i=0;i < size;i++)
	{
		int ran = rand() % matches.size();
		c_grids[i]->card_setOpenFace(matches[ran]);
		c_grids[i]->card_setCloseFace();
		matches.erase(matches.begin()+ran);
	}
}


void board::board_show()
{
	if(finish != c_grids.size())
	{
		for(int i = 0;i<c_grids.size();i++)
		{		
			SDL_BlitSurface(c_grids[i]->card_sur(),&c_grids[i]->card_getFace(),screen,&c_gridsPos[i]);
		}

		//draw the score
		SDL_Color score_color = {255,35,35};		
		SDL_Rect fill;
		fill.x = 60;
		fill.y = 65;
		stringstream s_out;
		s_out << score;
		string s = s_out.str();
		score_sur = TTF_RenderText_Solid(font,s.c_str(),score_color);
		SDL_BlitSurface(score_sur,NULL,screen,&fill);

		//draw time		
		this->board_timer();	
	}

	//finish
	if(finish == c_grids.size())
	{
		this->board_finish();
		//draw final timer
		if(count1==0)
		{
			this->board_timer();
			count1++;
		}
		
	}
	
}

void board::board_handlerEvent_MouseDown(int x, int y)
{
	int rank;
	if( (rank=board_handleEvent_checkMouseCollision(x,y)) != -1)
	{				
		if(c_grids[rank]->card_isOpen() != true)
		{
			//play the sound
			Mix_PlayChannel(-1,sound,0);

			c_grids[rank]->card_changeState();
			this->board_reDrawCard(rank);//redraw the card face
			v_matchPairs.push_back(rank);			
		}	
	}
		board_handleEvent_matchPairs();		
}

void board::board_reDrawCard(int rank)
{	
	//play the sound
	Mix_PlayChannel(-1,sound,0);

	SDL_BlitSurface(c_grids[rank]->card_sur(),&c_grids[rank]->card_getFace(),screen,&c_gridsPos[rank]);
	SDL_Flip(screen);
}


int board::board_handleEvent_checkMouseCollision(int x, int y)
{
	//check if the offset of mouse when click is on the card or not
	//if found, return the rank of card, is not, return -1
	for(int i=0;i<c_grids.size();i++)
	{
		SDL_Rect r = c_gridsPos[i];
		r.w = r.x + ww;
		r.h = r.y + hh;

		if( x > r.x && x < r.w && 
			y > r.y && y < r.h)
		{			
			return i;
		}
	}
	return -1;
}

int board::board_handleEvent_matchPairs()
{	
	if(v_matchPairs.size() >=2)
	{
		flag = REDRAW_FLAG;
		tt = SDL_GetTicks()/1000;
		faceA = c_grids[v_matchPairs[0]]->card_getOpenFace();
		faceB = c_grids[v_matchPairs[1]]->card_getOpenFace();
	}	
	return 0;
}
void board::board_timer()
{		
	//hanler redraw the card if pass 1 sec
	if(flag == REDRAW_FLAG)
	{
		if( SDL_GetTicks()/1000 - tt >= 1)
		{
			if(faceA==faceB)
			{
				
				//set card face
				c_grids[v_matchPairs[0]]->card_setDiscoveredFace();	
				c_grids[v_matchPairs[1]]->card_setDiscoveredFace();
				//update score
				score +=10;
				//update finish
				if(finish != c_grids.size() )
					finish +=2;
							
			}
			else
			{			
				//samthing here 
				c_grids[v_matchPairs[0]]->card_setCloseFace();
				c_grids[v_matchPairs[1]]->card_setCloseFace();
				//update score
				score>0?score--:score;					
			}	

			v_matchPairs.erase(v_matchPairs.begin());
			v_matchPairs.erase(v_matchPairs.begin());
			
			flag = 0;			
		}
	}
	if(v_matchPairs.size()>0)
		this->board_handleEvent_matchPairs();

	

	///hanler timer draw
	stringstream outSec,outMin;
	int nrOfSec = (gameTime.get_ticks())/1000;
	int min = nrOfSec / 60;
	int sec = nrOfSec - (min * 60);
	string timeText;
	outSec<< sec;
	outMin<< min;
	string timeSec;
	string timeMin;
	if(sec<10)
		timeSec = "0"+outSec.str();
	else timeSec = outSec.str();

	if(min<10)
		timeMin = "0"+outMin.str();
	else timeMin = outMin.str();
	
	if(SDL_GetTicks() % 7000 == 0 )
		score--;
	
	timeText = timeMin + ":" + timeSec;

	SDL_Color color = {255,35,35};
	
	timer_sur = TTF_RenderText_Solid(font,timeText.c_str(),color);
	
	SDL_Rect fill;
	fill.x = 25;
	fill.y = 200;
	//fill.w = 50;
	//fill.h = 50;
	
	SDL_BlitSurface(timer_sur,NULL,screen,&fill);
	//SDL_Flip(screen);
	
}

void board::board_finish()
{
	SDL_Rect pos;
	pos.x = 250;
	pos.y = 200;
	stringstream out;
	out << score;
	string text = "Thanks for playing";
	SDL_Color color = {255,35,35};
	SDL_Surface * finish_sur = TTF_RenderText_Solid(font,text.c_str(),color);
	SDL_BlitSurface(finish_sur,NULL,screen,&pos);
}

void board::clean()
{
	for(int i=0;i < c_grids.size();i++)
	{
		c_grids.erase(c_grids.begin());
	}
}



