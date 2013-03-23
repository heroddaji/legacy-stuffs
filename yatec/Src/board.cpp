#include "board.h"

//use for random block
int ranColor=0;
int ranNextColor=1;
int ran=BLOCK_I-1;
int next_ran=0;
int countRan=0;


//use for score and remove line
int countX=0;//count the row
int countY=0;//count the column

//use for timer
int nrOfSec = 0;
int min = 0;
int sec = 0;

//font
int textSize=0;

//use for level up
int oldLevel=0,newLevel=0;

board::board(SDL_Surface *screen,int level2)
{
	this->screen = screen;
	for(int i=0;i<BROW;i++){
		for(int j=0;j<BCOLUMN+1;j++){
			boardSize[i][j]=NODRAW;
		}
	}	

	for(int i=0;i<BROW;i++){
		for(int j=0;j<BCOLUMN+1;j++){
			real_boardSize[i][j]=GREY;
		}
	}	
	
	this->newBlock();
	
	level_timer = SDL_GetTicks();	//timer level	
	this->level = level2;//get the level

	//SDL_Rect r_color[5];
	for(int i=0;i<8;i++){
		r_color[i].x = i*30; 
		r_color[i].y = 0;
		r_color[i].w = BSIZE;
		r_color[i].h = BSIZE;
		
		r_nextColor[i].x = i*20; 
		r_nextColor[i].y = 0;
		r_nextColor[i].w = 20;
		r_nextColor[i].h = 20;

	}
	
	//assign position of the board
	for(int i=0;i<BROW;i++){
		for(int j=0;j<BCOLUMN;j++){
			r_boardSize[i][j].x = j*30+150;		
			r_boardSize[i][j].y = i*30+(550 - (BROW*30));
		}
	}

	//assign position of nextBlock
	for(int i=0;i<4;i++){
		for(int j=0;j<4;j++){
			r_nextBlock[i][j].x = j*20+490;		
			r_nextBlock[i][j].y = i*20+165;
		}
	}
	
	//load image of block
	block_sur = IMG_Load("block_ad.dat");
	nextBlock_sur = IMG_Load("next_block_ad.dat");

	//load sound
	soundRotate = Mix_LoadWAV("audio\\rotation.wav");
	soundDrop = Mix_LoadWAV("audio\\drop.wav");
	soundScore = Mix_LoadWAV("audio\\row.wav");
	soundOver = Mix_LoadWAV("audio\\tryagain.wav");

	//score and line
	score = 0;
	line =0;

	//font,size	
	textSize = 35;	
	font = TTF_OpenFont("font.dll",textSize);

	//gameOver
	gameOver = false;

	//open file to save score	
	this->saveScore();
}


void board::makeBlock(piece &bl,int ra,int raCo)
{	
			//generate an I	block
		if(ra == BLOCK_I){		
			bl.size[1][0]=raCo;
			bl.size[1][1]=raCo;
			bl.size[1][2]=raCo;
			bl.size[1][3]=raCo;
		}

		//generate an L	block
		if(ra == BLOCK_L){				
			bl.size[1][1]=raCo;
			bl.size[2][1]=raCo;
			bl.size[2][2]=raCo;
			bl.size[2][3]=raCo;
		}

		//generate an L2 block
		if(ra == BLOCK_L2){
			bl.size[2][1]=raCo;
			bl.size[1][1]=raCo;
			bl.size[1][2]=raCo;
			bl.size[1][3]=raCo;
		}

		//generate an T block
		if(ra == BLOCK_T){	
			bl.size[1][1]=raCo;
			bl.size[1][2]=raCo;
			bl.size[0][2]=raCo;
			bl.size[2][2]=raCo;
		}

		//generate an O block
		if(ra == BLOCK_O){
			bl.size[1][1]=raCo;
			bl.size[1][2]=raCo;
			bl.size[2][1]=raCo;
			bl.size[2][2]=raCo;
		}

		//generate an Z block
		if(ra == BLOCK_Z){
			bl.size[0][1]=raCo;
			bl.size[1][1]=raCo;
			bl.size[1][2]=raCo;
			bl.size[2][2]=raCo;		
		}
		//generate an Z2 block
		if(ra == BLOCK_Z2){
			bl.size[2][1]=raCo;
			bl.size[1][1]=raCo;
			bl.size[1][2]=raCo;
			bl.size[0][2]=raCo;		
		}
}
void board::newBlock()
{
	//generate  color for block
	ranColor++;
	if(ranColor>7)ranColor=1;
	ranNextColor++;
	if(ranNextColor>7)ranNextColor=1;
	
	//then begin to generate random blocks
	countRan++;

	//if first time make a block, then generate one 
	if(countRan == 1){
		//first empty all the square
		for(int i=0;i<4;i++){
			for(int j=0;j<4;j++){
				block.size[i][j]=NODRAW;
				next_block.size[i][j]=NODRAW;
			}
		}	

		ran = rand()%7+100; //get a random block	
		
		this->makeBlock(block,ran,ranColor);

		//generate next block
		next_ran = rand()%7+100; //get a random of next block
		this->makeBlock(next_block,next_ran,ranNextColor);	
	}

			

	//if not the first time, get current by next_block and generate new next_block
	if(countRan!=1){
	//empty current block
		for(int i=0;i<4;i++){
			for(int j=0;j<4;j++){
				block.size[i][j]=NODRAW;				
			}
		}	

		for(int i=0;i<4;i++){
			for(int j=0;j<4;j++){
				block.size[i][j] = next_block.size[i][j];
			}
		}

		//empty next block
		for(int i=0;i<4;i++){
			for(int j=0;j<4;j++){			
				next_block.size[i][j]=NODRAW;
			}
		}	
		//and make a new next block
		next_ran = rand()%7+100; //get a random of next block
		//next_ran = BLOCK_I;
		this->makeBlock(next_block,next_ran,ranNextColor);			
	}	
	
	//set block to start at the middble of the board
	block.x= BCOLUMN/2-2;
	block.y=0;
	this->updateBoard();
}

void board::move(int move)
{
	//temp var to remmemer last offset of block
	int oldx = block.x;
	int oldy = block.y;	

	// move the block
	if(move == MOVELEFT){ 		
		if(checkCollision(MOVELEFT) != HIT_WALL && checkCollision(MOVELEFT) != HIT_BLOCK){			
			block.x--;			
		}
	}
	if(move == MOVERIGHT){ 
		if(checkCollision(MOVERIGHT) != HIT_WALL && checkCollision(MOVERIGHT) != HIT_BLOCK){
			block.x++;			
		}
	}
	if(move == MOVEDOWN){
	
		if(checkCollision(MOVEDOWN) == HIT_BOTTOM ){
			this->addPermanentBlock();	
			this->newBlock();
		}
		if(checkCollision(MOVEDOWN) == HIT_PERMANENT_BLOCK ){
			this->addPermanentBlock();			
			this->newBlock();
		}
		else{
			block.y++;
		}		
	}
	if(move == MOVEROTATE){
		rotateBlock();
	}
	
	// empty the last block offset
	if(oldy >=0 && (oldy != block.y || oldx != block.x)){
		for(int i=0;i<4;i++){
			for(int j=0;j<4;j++){
				int ax = oldy + i; //the row
				int ay = oldx + j; //the column		
				if(ax < BROW && ay < BCOLUMN+1){//only update if it within the board boundary
					boardSize[ax][ay] = NODRAW;	
				}
			}
		}	
	}	

	//then update the board
	this->updateBoard();		
}


void board::autoMove()
{
	int oldx = block.x;
	int oldy = block.y;
	// empty the last block offset
	if(oldy >=0 ){
		for(int i=0;i<4;i++){
			for(int j=0;j<4;j++){
				int ax = oldy + i; //the row
				int ay = oldx + j; //the column		
				if(ax < BROW && ay < BCOLUMN+1){//only update if it within the board boundary
					boardSize[ax][ay] = NODRAW;	
				}
			}
		}	
	}	

	//move down to the end immediatly
	do{
		if(checkCollision(MOVEDOWN) == HIT_BOTTOM ){
			this->addPermanentBlock();	
			this->newBlock();			
			return;
		}
		if(checkCollision(MOVEDOWN) == HIT_PERMANENT_BLOCK ){
			this->addPermanentBlock();			
			this->newBlock();		
			return;
		}
		else{
			block.y++;
		}	
	}while(true);	
	
	
}

//collision, and set permanent block into the board
int board::checkCollision(int move)
{
	int ax,ay;
	int newx,newy;

	if(move == MOVELEFT){
		//check colision when move to left
		newx = block.x - 1;
		newy = block.y;

		for(int i=0;i<4;i++){
			for(int j=0;j<4;j++){
				ay = newy + i ; //the row
				ax = newx + j; //the column	
				if(ax < 0 && block.size[i][j]!=NODRAW){					
					return HIT_WALL;
				}
				if(real_boardSize[ay][ax]!=GREY && block.size[i][j]!=NODRAW){
					return HIT_BLOCK;
				}
			}
		}	
	}

	if(move == MOVERIGHT){
		//check colision when move to right
		newx = block.x + 1;	
		newy = block.y;

		for(int i=0;i<4;i++){
			for(int j=0;j<4;j++){
				 ay = newy + i ; //the row
				 ax = newx + j; //the column	
				if(ax >= BCOLUMN && block.size[i][j]!=NODRAW){
					return HIT_WALL;
				}
				if(real_boardSize[ay][ax]!=GREY && block.size[i][j]!=NODRAW){
					return HIT_BLOCK;
				}
			}
		}	
	}

	if(move == MOVEDOWN){
		//check colision when move to down
		newy = block.y + 1;		
		newx = block.x;
		for(int i=0;i<4;i++){
			for(int j=0;j<4;j++){
				 ay = newy + i ; //the row
				 ax = newx + j; //the column	
				if(ay >= BROW && block.size[i][j]!=NODRAW){
					return HIT_BOTTOM;
				}
				if(real_boardSize[ay][ax]!=GREY && block.size[i][j]!=NODRAW){
					return HIT_PERMANENT_BLOCK;
				}
			}
		}	
	}	
	
	return 0;
}

//rotate
void board::rotateBlock()
{
	//play rotate sound
	Mix_PlayChannel(-1,soundRotate,0);	

	//first restore the current post
	if(block.y >=0){
		for(int i=0;i<4;i++){
			for(int j=0;j<4;j++){
				int ay = block.y+i; //the row
				int ax = block.x+j; //the column			
				boardSize[ay][ax] = NODRAW;						
			}
		}	
	}	

	//make a temporary rotate
	piece temp;
	temp.x = block.x;
	temp.y = block.y;
	for(int i=0;i<4;i++){
		for(int j=0;j<4;j++){
			temp.size[3-j][i] = block.size[i][j];
		}
	}

	//check the temporary collision
	if( rotateCheck(temp) == HIT_NOTHING )
	{
		//then apply the rotate
		for(int i=0;i<4;i++){
			for(int j=0;j<4;j++){
				block.size[i][j] = temp.size[i][j];
			}
		}		
	}	

	//update board;
	this->updateBoard();
	
}

int board::rotateCheck(piece &temp)
{
	int ax,ay;
	int	newy = temp.y;		
	int	newx = temp.x;

	for(int i=0;i<4;i++){
		for(int j=0;j<4;j++){
			 ay = newy + i ; //the row
			 ax = newx + j; //the column	
			if(ay >= BROW && temp.size[i][j]!=NODRAW){
				return HIT_BOTTOM;
			}
			//hit wall right
			else if(ax >= BCOLUMN && temp.size[i][j]!=NODRAW){
				return HIT_WALL;
			}
			//hit wall left
			else if(ax < 0 && temp.size[i][j]!=NODRAW){					
				return HIT_WALL;
			}
			//hit temp
			else if(real_boardSize[ay][ax]!=GREY && temp.size[i][j]!=NODRAW){
				return HIT_BLOCK;
			}			
		}
	}		
	return HIT_NOTHING;
}

void board::updateBoard()
{
	//here is a little confuse
	// 
	for(int i=0;i<4;i++){
		for(int j=0;j<4;j++){
			int ay = block.y+i ; //the row
			int ax = block.x+j; //the column
			
			if(ay < BROW && ax < BCOLUMN+1){//only update if it within the board boundary
				if(block.size[i][j] !=NODRAW){
					boardSize[ay][ax] = block.size[i][j];				
				}
			}
		}
	}	
	
}

void board::addPermanentBlock()
{
	//play drop sound
	Mix_PlayChannel(-1,soundDrop,0);
	//add score
	score += 5;
	this->saveScore();

	//check gameover
	for(int j=0;j<BCOLUMN;j++){
		if(real_boardSize[2][j] != GREY || real_boardSize[1][j] != GREY || real_boardSize[0][j] != GREY){
			Mix_HaltMusic();
			Mix_PlayChannel(-1,soundOver,0);
			SDL_Delay(2000);
			gameOver = true;	
			return ;
		}
	}	
	//add permanent blocks
	for(int i=0;i<4;i++){
		for(int j=0;j<4;j++){
			int ay = block.y+i ; //the row
			int ax = block.x+j; //the column			
			if(ay < BROW && ax < BCOLUMN+1){//only update if it within the board boundary
				if(block.size[i][j] !=NODRAW){
					real_boardSize[ay][ax] = block.size[i][j];				
				}
			}
		}
	}	
	
	

	//after add permanent block
	//check if full line is in, then score, and remove the line	
	countY=0;
	for(int i = BROW - 1; i>0; i--){
		for(int j=0;j<BCOLUMN;j++){
			if(real_boardSize[i][j] != GREY){
				countY++;
				if(countY == BCOLUMN){
					//countX++;
					scoreLine.push_back(i); //push the score line offset to vector
					countY = 0;
				}				
			}
		}
		countY=0;
	}	

	//now remove the line
	if(scoreLine.size() >= 1){		

		//add number of line u remove into line score
		line += scoreLine.size();
		//increase level every 5 line score
		if( level < 9){
            newLevel = line/5;
            if(oldLevel != newLevel){            
               level++;
			   oldLevel = newLevel;
           }
		}

		//play score sound		
		Mix_PlayChannel(-1,soundScore,0);

		//add score
		score += 20*scoreLine.size();   

		//apply remove effect here
		for(int i=0;i<scoreLine.size();i++){
			for(int j=0;j<BCOLUMN;j++){
				//real_boardSize[i][j] = NODRAW;
				SDL_BlitSurface(block_sur,&r_color[GREY-1],screen,&r_boardSize[scoreLine[i]][j]);
				SDL_Flip(screen);
				SDL_Delay(30);
			}
		}
		//delete the line
		for(int i=0;i<scoreLine.size();i++){
			for(int j=0;j<BCOLUMN;j++){
				real_boardSize[scoreLine[i]][j] = GREY;				
			}
		}
		
		
		//now move the remain block down where the score line just remove
		int lastLine = scoreLine[0];
		int offset = lastLine;
		for(int i = offset;i> 0 ;i--){
			for(int j = 0;j<BCOLUMN;j++){
				if(real_boardSize[i][j] != GREY){
					for(int k=0;k<BCOLUMN;k++){
						real_boardSize[lastLine][k] = real_boardSize[i][k];
					}
					for(int k=0;k<BCOLUMN;k++){
						real_boardSize[i][k] = GREY;
					}
					j = BCOLUMN;//skip the current row
					lastLine--;
				}
			}
		}

		//erase score line vector
		do{
			scoreLine.erase(scoreLine.begin());
		}while(scoreLine.size() >= 1 );	
	}
}

void board::timerAndLevel()
{
	if(SDL_GetTicks() - level_timer > (1000 - level*100)){
		this->move(MOVEDOWN);
		level_timer = SDL_GetTicks();
	}
}

void board::timer()
{
	///hanler timer draw
	stringstream outSec,outMin;
	int nrOfSec = SDL_GetTicks()/1000;
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
	
	
	timeText = timeMin + ":" + timeSec;

	SDL_Color color = {255,35,35};
	
	timer_sur = TTF_RenderText_Solid(font,timeText.c_str(),color);
	
	SDL_Rect fill;
	fill.x = 35;
	fill.y = 170;		
	SDL_BlitSurface(timer_sur,NULL,screen,&fill);
}

void board::draw()
{
	/*first blit the grey of real board
	for(int i=0;i<BROW;i++){
		for(int j=0;j<BCOLUMN;j++){
			if(real_boardSize[i][j]==GREY){
				if(SDL_BlitSurface(block_sur,&r_color[real_boardSize[i][j]-1],screen,&r_boardSize[i][j]) == -1)
				{
				    char* t;
					t= SDL_GetError();
				}
			}
		}
	}*/

	//then blit surface of moving block
	for(int i=0;i<BROW;i++){
		for(int j=0;j<BCOLUMN;j++){
			if(boardSize[i][j]!=NODRAW){
				if(SDL_BlitSurface(block_sur,&r_color[boardSize[i][j]-1],screen,&r_boardSize[i][j]) == -1)
				{
				    char* t;
					t= SDL_GetError();
				}
			}
		}
	}

	//then blit surface of permanent block
	for(int i=0;i<BROW;i++){
		for(int j=0;j<BCOLUMN;j++){
			if(real_boardSize[i][j]!=GREY){
				if(SDL_BlitSurface(block_sur,&r_color[real_boardSize[i][j]-1],screen,&r_boardSize[i][j]) == -1)
				{
				    char* t;
					t= SDL_GetError();
				}
			}
		}
	}

	//blit the next Block on the right screen
	for(int i=0;i<4;i++){
		for(int j=0;j<4;j++){
			if(next_block.size[i][j]!=NODRAW){
				if(SDL_BlitSurface(nextBlock_sur,&r_nextColor[next_block.size[i][j]-1],screen,&r_nextBlock[i][j]) == -1)
				{
				    char* t;
					t= SDL_GetError();
				}
			}
		}
	}
	
	//blit timer
	this->timer();

	//blit score
	SDL_Rect fill;
	fill.x = 55;
	fill.y = 270;	
	stringstream scoreOut;
	scoreOut << score;
	SDL_Color color = {255,35,35};
	string scoreTex = scoreOut.str();
	score_sur = TTF_RenderText_Solid(font,scoreTex.c_str(),color);
	SDL_BlitSurface(score_sur,NULL,screen,&fill);

	//blit current level
	fill.x = 520;
	fill.y = 270;	
	stringstream levelOut;
	levelOut << level;	
	string levelText = levelOut.str();
	score_sur = TTF_RenderText_Solid(font,levelText.c_str(),color);
	SDL_BlitSurface(score_sur,NULL,screen,&fill);

	//blit number of line u score
	fill.x = 55;
	fill.y = 370;	
	stringstream lineOut;
	lineOut << line;	
	string lineText = lineOut.str();
	score_sur = TTF_RenderText_Solid(font,lineText.c_str(),color);
	SDL_BlitSurface(score_sur,NULL,screen,&fill);
}

bool board::checkGameOver()
{
	return gameOver;
}

void board::setGameOver()
{
	Mix_HaltMusic();
	gameOver = true;
}
int board::getHScore(){
	return highestScore;
}
int board::getScore(){
	return score;
}

void board::saveScore()
{
	int maxScore;	
	ofstream temp("temp.txt");
	ifstream file("score.dat");	
	//file.seekg(0,ios::beg);	
	file >> maxScore;
	highestScore = maxScore;
	if(maxScore <= score){
		maxScore = score;
		highestScore = maxScore;
		stringstream out;
		out<<maxScore;
		//write current score to file
		//file.seekp(0,ios::beg);
		temp << out.str();
		temp.close();
		file.close();		
	}
	remove("score.dat");
	rename("temp.txt","score.dat");
	remove("temp.txt");
	
	
}

void board::clear()
{

	SDL_FreeSurface(screen);
	SDL_FreeSurface(block_sur);
	SDL_FreeSurface(nextBlock_sur);
	SDL_FreeSurface(timer_sur);

	for(int i=0;i<BROW;i++){
		for(int j=0;j<BCOLUMN+1;j++){
			boardSize[i][j]=NODRAW;
			real_boardSize[i][j]=NODRAW;
		}
	}
}
