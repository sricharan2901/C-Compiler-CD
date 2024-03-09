//Test Input Program 1

#include<stdio.h>
#include<stdlib.h>

int main() {
	int x = 8;
	int y = 10;
	y = x*2 + 5;
	float c;

	if (y > x){
        	printf("\nWelcome to Program ! \nCheck 1 Completed .. \n");
		y = x + 100;
        	if (y > x){
            		printf("\nCheck 1 and 2 Completed ..\n");
            		y = x;
        	}

		else{
	        	x = y;
			printf("\nCheck 2 Failed ..\n");
        	}
    	}

	else{
        	x = y + 10;
		printf("\nCheck 1 Failed .. \n");
	}

	printf("\n\nThank you. Exiting Program .. \n\n");
	
	return 0;
}
