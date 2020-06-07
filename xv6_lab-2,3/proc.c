#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"
#include "spinlock.h"


static unsigned long int next = 1;
int rand(void)    /* RAND_MAX assumed to be 32767 */
{
    next = next * 1103515245 + 12345;
    return((unsigned int)(next/65536) % 32768);
}

struct {
  struct spinlock lock;
  struct proc proc[NPROC];
} ptable;

static struct proc *initproc;

int nextpid = 1;
extern void forkret(void);
extern void trapret(void);

static void wakeup1(void *chan);

void
pinit(void)
{
  initlock(&ptable.lock, "ptable");
}

// Must be called with interrupts disabled
int
cpuid() {
  return mycpu()-cpus;
}

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void)
{
  int apicid, i;
  
  if(readeflags()&FL_IF)
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return &cpus[i];
  }
  panic("unknown apicid\n");
}

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
  c = mycpu();
  p = c->proc;
  popcli();
  return p;
}

//PAGEBREAK: 32
// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
  ///////////////////////focus/////////////////////////
  p->queuenum = 1;
  //////////////////shell///////////////////
  if(p->pid == 2){
    p->tickets = 1000000;
  }
  p->tickets=10;
  p->priority = 0.01;
  p->executionCycle = 1;
  acquire(&tickslock);
  p->createTime = ticks;
  release(&tickslock);

  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
  p->tf = (struct trapframe*)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  return p;
}

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];
  cprintf("init p\n");
  p = allocproc();
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  p->tf->es = p->tf->ds;
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0;  // beginning of initcode.S

  safestrcpy(p->name, "initcode", sizeof(p->name));
  p->cwd = namei("/");

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);

  p->state = RUNNABLE;

  release(&ptable.lock);
}

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
  uint sz;
  struct proc *curproc = myproc();

  sz = curproc->sz;
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  curproc->sz = sz;
  switchuvm(curproc);
  return 0;
}

// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
    return -1;
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = curproc->sz;
  np->parent = curproc;
  *np->tf = *curproc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));

  pid = np->pid;

  acquire(&ptable.lock);


  np->state = RUNNABLE;

  release(&ptable.lock);

  return pid;
}

// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd]){
      fileclose(curproc->ofile[fd]);
      curproc->ofile[fd] = 0;
    }
  }

  begin_op();
  iput(curproc->cwd);
  end_op();
  curproc->cwd = 0;

  acquire(&ptable.lock);

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
      if(p->state == ZOMBIE)
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
  sched();
  panic("zombie exit");
}

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != curproc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
        freevm(p->pgdir);
        p->pid = 0;
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
        release(&ptable.lock);
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}

//PAGEBREAK: 42
// Per-CPU process scheduler.
// Each CPU calls scheduler() after setting itself up.
// Scheduler never returns.  It loops, doing:
//  - choose a process to run
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.

int checkNotEmpty(int queueNum){
  struct proc *p;
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    //cprintf("jj\n");
    //cprintf("%d",p->queuenum);
    if(p->queuenum == queueNum && (p->state == RUNNABLE)){
      //cprintf("samin\n");
      //cprintf("%d",p->pid);
      return 1;
    }
  }
  return 0;
}

int lottery_range(void){
    struct proc *p;
    int ticket_number=0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
        if(p->state == RUNNABLE && p->queuenum==1){
           ticket_number+=p->tickets;
        }
     }
    return ticket_number;          // returning total number of tickets for runnable processes
}


struct proc* foundTicket(int goldenTicket){
  struct proc *p;
  int count=0;
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
      if (p->state == RUNNABLE && p->queuenum == 1) {
          if (count + p->tickets < goldenTicket)
              count += p->tickets;
          else
              return p;
      }
  }
  return '\0';
}

/////2/////

struct proc* processWithMaxPriority(){
  struct proc* p;
  struct proc* pmax = '\0';
  float _maxHRRN=-1;
  uint currentTick;
  acquire(&tickslock);
  currentTick = ticks;
  release(&tickslock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if((p->queuenum == 2) && (((float)(currentTick - p->createTime) /(float) p->executionCycle) > _maxHRRN) && p->state == RUNNABLE){
      _maxHRRN = (float)((float)(currentTick - p->createTime) / (float)p->executionCycle);
      pmax = p;
    }
  }

  return pmax;

}

////////3////////
struct proc* choseWithSRTF(){
  int randNum;
  struct proc* samepr[1000];
  int count_samepr = 0;
  struct proc* p;
  struct proc* minp='\0';
  float _min = -1;
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if((p->queuenum == 3) && (p->state == RUNNABLE)){
      _min = p->priority;
      minp = p;
      break;
    }
  }
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if((p->queuenum == 3) && (p->state == RUNNABLE) && (p->priority < _min)){
      _min = p->priority;
      minp = p;
    }
  }
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if((p->queuenum == 3) && (p->state == RUNNABLE) && (p->priority == _min)){
      samepr[count_samepr]=p;
      count_samepr++;
    }
  }
  randNum = rand() % count_samepr;
  
  if(count_samepr == 1){
    if(minp->priority >= 0.1)
      minp->priority -= 0.1;
    return minp;
  }
  else{
    if(samepr[randNum]->priority >= 0.1)
      samepr[randNum]->priority -= 0.1;
    return samepr[randNum];
  }

}

void
scheduler(void)
{
  //cprintf("1\n");
  //struct proc *p;
  //struct proc *p1;
  struct proc *chosen = '\0';
  struct cpu *c = mycpu();
  c->proc = 0;
  long golden_ticket = 0;
  int total_no_tickets=0;
  for(;;){
     // cprintf("3\n");
      sti();
    // Loop over process table looking for process to run.
      acquire(&ptable.lock);
      //for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
        //if(p->state != RUNNABLE)
          //continue;
      //chosen = '\0';
      if(checkNotEmpty(1)){
          total_no_tickets = lottery_range();
          golden_ticket=rand()%total_no_tickets;
          chosen = foundTicket(golden_ticket);
      }
      else if(checkNotEmpty(2)){
        chosen = processWithMaxPriority();
      }
      else if(checkNotEmpty(3)){
        chosen = choseWithSRTF();
      }
      
      


      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      //cprintf("#####%s\n",chosen->name);
      chosen->executionCycle += 1;
      c->proc = chosen;
      switchuvm(chosen);
      chosen->state = RUNNING;
      swtch(&(c->scheduler), chosen->context);
      switchkvm();
      
      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
      release(&ptable.lock);
      
    //}


  }
}

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state. Saves and restores
// intena because intena is a property of this
// kernel thread, not this CPU. It should
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{

  int intena;
  struct proc *p = myproc();
  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
  swtch(&p->context, mycpu()->scheduler);
  mycpu()->intena = intena;
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
  acquire(&ptable.lock);  //DOC: yieldlock
  myproc()->state = RUNNABLE;
  sched();
  release(&ptable.lock);
}

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);

  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
  
  if(p == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");

  // Must acquire ptable.lock in order to
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
    acquire(&ptable.lock);  //DOC: sleeplock1
    release(lk);
  }
  // Go to sleep.
  p->chan = chan;
  p->state = SLEEPING;

  sched();

  // Tidy up.
  p->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  }
}

//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
}

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}

//getchildren of a parent
////////////////////////////////////////////////////////////////////////PART 3///////////////////////////////////////////////////////////////////////

int r2;
int getchildren(int pid) {

    int chname = 0;
    struct proc *p;
    int queue[NPROC], front = -1,rear = -1;
    int delete_item;
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
       if(p->pid == pid)
	  p->visited = 1;
    }
    release(&ptable.lock);

    if(rear != NPROC - 1)
    {
       if(front == -1) 
	  front = 0;
       rear = rear+1;
       queue[rear] = pid;
    }

    while((front != -1) && (front <= rear)){
        delete_item = queue[front];
	front = front+1;
        chname = findch(delete_item) + (chname * r2);
        acquire(&ptable.lock);
        for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
          if((p->parent->pid == delete_item) && (p->visited != 1)){
             if(rear != NPROC - 1)
             {
                if(front == -1) 
	           front = 0;
                rear = rear+1;
                queue[rear] = p->pid;
             }
             p->visited = 1;

          }
        }
        release(&ptable.lock);
    }

    return chname;
}


int findch(int pid){
  r2 = 1;
  int i = 0;
  int j = 0;
  int r = 1;
  struct proc *p;
  int name = 0;
  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent->pid == pid){
       for(j=0;j<i;j++){
           r *= 10;
       }
       r2 *= 10;
       name += r * p->pid;
       i = i + 1;
       r = 1;
    }
  }
  release(&ptable.lock);
  return name;

}


//PAGEBREAK: 36
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
  static char *states[] = {
  [UNUSED]    "unused",
  [EMBRYO]    "embryo",
  [SLEEPING]  "sleep ",
  [RUNNABLE]  "runble",
  [RUNNING]   "run   ",
  [ZOMBIE]    "zombie"
  };
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}

int
set(char * path)
{ 
    int error=0;  
    int ii=0;
    int i=0;
    int j;
    char temp[100];
    struct inode *ip;
    int size;
    while(path[i]!='\0'){
      add_path[i]=path[i];
      i++;
    }
    add_path[i]='\0';
    size=get_size_string(add_path);
    for(j=0;j<size;j++){
     while(add_path[j]!=':'){
       	temp[ii]=add_path[j];
        ii++;
        j++; 
        if(j>=size)
            break;
     }
     temp[ii]='\0';
       ii++;
       ii=0;
       ip=namei(temp);
       if(ip == 0){
	 cprintf("%s directory doesn't exist!\n",temp);
         error=1;
       }
     }
     if(error)
	exit();
    return 0;
}
int
count(int num)
{
	int c=0;
	while(num/10 > 0){
                  num = num / 10;
                  c += 1;
        }

	return c+1;
}


int chqueue(int pid,int queuenum){

  struct proc *p;
	acquire(&ptable.lock);
	for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->pid == pid){
        p->queuenum = queuenum;
        break;
	    }
  }
  release(&ptable.lock);
  return 0;	

}


int setLottery(int pid,int tickets){

  struct proc *p;
	acquire(&ptable.lock);
	for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
           if(p->pid == pid){
             p->tickets =tickets;
             break;
	   }
    }
  release(&ptable.lock);

	return 0;

}

void reverse(char* str, int len) 
{ 
    int i = 0, j = len - 1, temp; 
    while (i < j) { 
        temp = str[i]; 
        str[i] = str[j]; 
        str[j] = temp; 
        i++; 
        j--; 
    } 
} 
  
// Converts a given integer x to string str[].  
// d is the number of digits required in the output.  
// If d is more than the number of digits in x,  
// then 0s are added at the beginning. 
int intToStr(int x, char str[], int d) 
{ 
    int i = 0; 
    while (x) { 
        str[i++] = (x % 10) + '0'; 
        x = x / 10; 
    } 
  
    // If number of digits required is more, then 
    // add 0s at the beginning 
    while (i < d) 
        str[i++] = '0'; 
  
    reverse(str, i); 
    str[i] = '\0'; 
    return i; 
} 

int power(int x, unsigned int y) 
{ 
    if (y == 0) 
        return 1; 
    else if (y%2 == 0) 
        return power(x, y/2)*power(x, y/2); 
    else
        return x*power(x, y/2)*power(x, y/2); 
} 
  
// Converts a floating-point/double number to a string. 
void ftoa(float n, char* res, int afterpoint) 
{ 
    // Extract integer part 
    int ipart = (int)n; 
  
    // Extract floating part 
    float fpart = n - (float)ipart; 
  
    // convert integer part to string 
    int i = intToStr(ipart, res, 0); 
  
    // check for display option after point 
    if (afterpoint != 0) { 
        res[i] = '.'; // add dot 
  
        // Get the value of fraction part upto given no. 
        // of points after dot. The third parameter  
        // is needed to handle cases like 233.007 
        fpart = fpart * power(10, afterpoint); 
  
        intToStr((int)fpart, res + i + 1, afterpoint); 
    } 
} 


int chprSRPF(int pid,int priority){

  struct proc *p;
	acquire(&ptable.lock);
	for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
           if(p->pid == pid){
             p->priority = priority;
             break;
	   }

        }
        release(&ptable.lock);

	return 0;


}


int printinfo(void){
	struct proc *p;
	sti();
	cprintf("name \t \t pid \t \t state \t \t priority \t \t createTime \t \t lotteryTicket \t \t executionCycle \t \t HRRN \t \t queueNum\n");
  float currentTime;
  acquire(&tickslock);
  currentTime = ticks;
  release(&tickslock);
  acquire(&ptable.lock);
	for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      char buffer1[20]; 
      char buffer2[20];
      ftoa(p->priority, buffer1, 2);
      ftoa((float)((currentTime - p->createTime) / (p->executionCycle)),buffer2, 2);            
   	  if ( p->state == SLEEPING )
                /////////////////////////////////////////hrrn////////////////////////////////////////////
     		  cprintf("%s \t \t %d  \t \t SLEEPING \t \t %s \t \t %d \t \t %d \t \t %d \t \t %s \t \t %d \n", p->name, p->pid, buffer1, p->createTime, p->tickets, p->executionCycle,
          buffer2, p->queuenum);
	    else if ( p->state == RUNNING )
     		  cprintf("%s \t \t %d  \t \t RUNNING \t \t  %s \t \t %d \t \t %d \t \t %d \t \t %s \t \t %d \n", p->name, p->pid, buffer1, p->createTime, p->tickets, p->executionCycle,
          buffer2, p->queuenum);
      
      else if ( p->state == RUNNABLE )
     		  cprintf("%s \t \t %d  \t \t RUNNABLE \t \t  %s \t \t %d \t \t %d \t \t %d \t \t %s \t \t %d \n", p->name, p->pid, buffer1, p->createTime, p->tickets, p->executionCycle,
          buffer2, p->queuenum);
  }

  release(&ptable.lock);

	return 0;

}

