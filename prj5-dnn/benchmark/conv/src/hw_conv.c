#include "printf.h"
#include "trap.h"

#define HW_ACC_START	0x0000
#define HW_ACC_DONE		0x0008

int main()
{
	//TODO: Please add your own software to control hardware accelerator
	 volatile  char* addr=(void *)0x40040000;
	*(addr+HW_ACC_START)=1;
	while(!(*(addr+HW_ACC_DONE) & 1)) ;
	
	return 0;
}
