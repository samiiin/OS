#include "types.h"
#include "stat.h"
#include "user.h"
#include "fs.h"
#include "x86.h"

int
main(int argc, char *argv[])
{
    int mainp = getpid();
    int id;
    int x = 0;
    int n = 10;
    int k;
    chqueue(getpid(), 1);
    setLottery(getpid(),100);
    // int i;
    printf(1, "%d par\n", getpid());
    for (k = 0; k < n; k++) {
        printf(1,"! %d\n",mainp);
        id = fork();
        if (id < 0) {
            printf(1, "%d failed in fork!\n", getpid());
        } else if (id > 0) {  //parent
            printf(1, "k %d creating child  %d\n", k, id);
        } else {
            if(k%3 ==0 ){
                x=20;
            }
            if(k%3 == 1){
                x= 60;
            }
            if(k%3 ==2 ) {
                x = 100;
            }
            chqueue(getpid(), 1);
            setLottery(getpid(),x);
            if(k==8)
                printinfo();
            while(1);
            if(k==8)
                printinfo();
            exit();
        }
    }

    //while(wait()>0);

    printf(1,"end");
    exit();

}
