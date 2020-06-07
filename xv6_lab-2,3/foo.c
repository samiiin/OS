
#include "types.h"
#include "stat.h"
#include "user.h"
#include "fs.h"
#include "x86.h"

int
main(int argc, char *argv[])
{
    int id;
    int n = 2;
    int k;
    for (k = 0; k < n; k++) {
        id = fork();
        if (id < 0) {
            printf(1, "%d failed in fork!\n", getpid());
        } 
        if(id == 0) {
            while(1);
        }
    }

    while(wait()>0);
    exit();

}

	
	
	
