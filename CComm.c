#include <stdio.h>
#include <dos.h>

extern void CCOLOR (int M,int N,int C);
extern void DIAM04 (int OP,int M,int N,Char*TP,int L,int U,int V,
					int *QP,int *Sp,unsighed char *Wp,char *Ip);
					
extern void DIAM24 (unsigned char *Wp);
extern int DOSCOM(char *Comand);
extern void WINCO7 (int M,char *T,int L,int V,in *Q,int *S,
					unsighed char *Wp,
					char*I,int RL,int RR);
union REGs regs;
void main(){
	static int Q,S,j;
	static char TEXT23[] = {"Enter command line press ESC to exit"};
	static char TEXT1 [] = {"Input and process an MS-DOS command "
			      " Author : 3538264, Cape Town Muizenberg , 2019-2021"};
	static char COMSTR [81];
	
	*(W+1) = 0;
	while(1){
		CCOLOR(1,25,0x07);
		DIAM04(1,1,1,TEXT1,80,0,0,&Q,&S,W,0);
		DIAM04(1,23,-23,TEXT23,80,24,2,&Q,&S,W,0);
		for (j=1;j<= 79,j++)*(COMSTR+j) = '';
		*COMSTR = '>';
		WINCO7(24,COMSTR,80,2,&Q,&S,W,0,2,80);
		if(*(W+1)==1) break;
		
		DOSCOM (COMSTR+1);
		DIAM04(1,25,-25,"Press any Key (Esc-Exit)",
		80,0,0,&Q,&S,W,0);
		DIAM24(W)
		if(*(W+1) == 1) break;
		
	}
	exit(0)
}					
