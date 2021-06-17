...........................
extern void Ccolour(int M, int N, int C);
void main(){
   
  static int M = 1, N = 25, C = 0x07;
  Ccolour(M,N,C);      /* set colour and clear screen */
  return;
  
}
...........................
