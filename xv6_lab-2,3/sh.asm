
_sh:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
  return 0;
}

int
main(void)
{
       0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
       4:	83 e4 f0             	and    $0xfffffff0,%esp
       7:	ff 71 fc             	pushl  -0x4(%ecx)
       a:	55                   	push   %ebp
       b:	89 e5                	mov    %esp,%ebp
       d:	51                   	push   %ecx
       e:	83 ec 04             	sub    $0x4,%esp
  static char buf[100];
  int fd;

  // Ensure that three file descriptors are open.
  while((fd = open("console", O_RDWR)) >= 0){
      11:	eb 0e                	jmp    21 <main+0x21>
      13:	90                   	nop
      14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(fd >= 3){
      18:	83 f8 02             	cmp    $0x2,%eax
      1b:	0f 8f c3 00 00 00    	jg     e4 <main+0xe4>
{
  static char buf[100];
  int fd;

  // Ensure that three file descriptors are open.
  while((fd = open("console", O_RDWR)) >= 0){
      21:	83 ec 08             	sub    $0x8,%esp
      24:	6a 02                	push   $0x2
      26:	68 91 12 00 00       	push   $0x1291
      2b:	e8 42 0d 00 00       	call   d72 <open>
      30:	83 c4 10             	add    $0x10,%esp
      33:	85 c0                	test   %eax,%eax
      35:	79 e1                	jns    18 <main+0x18>
      37:	eb 2e                	jmp    67 <main+0x67>
      39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  // Read and run input commands.
  while(getcmd(buf, sizeof(buf)) >= 0){
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
      40:	80 3d a2 18 00 00 20 	cmpb   $0x20,0x18a2
      47:	74 5d                	je     a6 <main+0xa6>
      49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
int
fork1(void)
{
  int pid;

  pid = fork();
      50:	e8 d5 0c 00 00       	call   d2a <fork>
  if(pid == -1)
      55:	83 f8 ff             	cmp    $0xffffffff,%eax
      58:	74 3f                	je     99 <main+0x99>
      buf[strlen(buf)-1] = 0;  // chop \n
      if(chdir(buf+3) < 0)
        printf(2, "cannot cd %s\n", buf+3);
      continue;
    }
    if(fork1() == 0) {
      5a:	85 c0                	test   %eax,%eax
      5c:	0f 84 98 00 00 00    	je     fa <main+0xfa>
        setLottery(getpid(),1000000);
        runcmd(parsecmd(buf));
    }
    wait();
      62:	e8 d3 0c 00 00       	call   d3a <wait>
      break;
    }
  }

  // Read and run input commands.
  while(getcmd(buf, sizeof(buf)) >= 0){
      67:	83 ec 08             	sub    $0x8,%esp
      6a:	6a 64                	push   $0x64
      6c:	68 a0 18 00 00       	push   $0x18a0
      71:	e8 aa 00 00 00       	call   120 <getcmd>
      76:	83 c4 10             	add    $0x10,%esp
      79:	85 c0                	test   %eax,%eax
      7b:	78 78                	js     f5 <main+0xf5>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
      7d:	80 3d a0 18 00 00 63 	cmpb   $0x63,0x18a0
      84:	75 ca                	jne    50 <main+0x50>
      86:	80 3d a1 18 00 00 64 	cmpb   $0x64,0x18a1
      8d:	74 b1                	je     40 <main+0x40>
int
fork1(void)
{
  int pid;

  pid = fork();
      8f:	e8 96 0c 00 00       	call   d2a <fork>
  if(pid == -1)
      94:	83 f8 ff             	cmp    $0xffffffff,%eax
      97:	75 c1                	jne    5a <main+0x5a>
    panic("fork");
      99:	83 ec 0c             	sub    $0xc,%esp
      9c:	68 1a 12 00 00       	push   $0x121a
      a1:	e8 ca 00 00 00       	call   170 <panic>

  // Read and run input commands.
  while(getcmd(buf, sizeof(buf)) >= 0){
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
      // Chdir must be called by the parent, not the child.
      buf[strlen(buf)-1] = 0;  // chop \n
      a6:	83 ec 0c             	sub    $0xc,%esp
      a9:	68 a0 18 00 00       	push   $0x18a0
      ae:	e8 bd 0a 00 00       	call   b70 <strlen>
      if(chdir(buf+3) < 0)
      b3:	c7 04 24 a3 18 00 00 	movl   $0x18a3,(%esp)

  // Read and run input commands.
  while(getcmd(buf, sizeof(buf)) >= 0){
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
      // Chdir must be called by the parent, not the child.
      buf[strlen(buf)-1] = 0;  // chop \n
      ba:	c6 80 9f 18 00 00 00 	movb   $0x0,0x189f(%eax)
      if(chdir(buf+3) < 0)
      c1:	e8 dc 0c 00 00       	call   da2 <chdir>
      c6:	83 c4 10             	add    $0x10,%esp
      c9:	85 c0                	test   %eax,%eax
      cb:	79 9a                	jns    67 <main+0x67>
        printf(2, "cannot cd %s\n", buf+3);
      cd:	51                   	push   %ecx
      ce:	68 a3 18 00 00       	push   $0x18a3
      d3:	68 99 12 00 00       	push   $0x1299
      d8:	6a 02                	push   $0x2
      da:	e8 f1 0d 00 00       	call   ed0 <printf>
      df:	83 c4 10             	add    $0x10,%esp
      e2:	eb 83                	jmp    67 <main+0x67>
  int fd;

  // Ensure that three file descriptors are open.
  while((fd = open("console", O_RDWR)) >= 0){
    if(fd >= 3){
      close(fd);
      e4:	83 ec 0c             	sub    $0xc,%esp
      e7:	50                   	push   %eax
      e8:	e8 6d 0c 00 00       	call   d5a <close>
      break;
      ed:	83 c4 10             	add    $0x10,%esp
      f0:	e9 72 ff ff ff       	jmp    67 <main+0x67>
        setLottery(getpid(),1000000);
        runcmd(parsecmd(buf));
    }
    wait();
  }
  exit();
      f5:	e8 38 0c 00 00       	call   d32 <exit>
      if(chdir(buf+3) < 0)
        printf(2, "cannot cd %s\n", buf+3);
      continue;
    }
    if(fork1() == 0) {
        setLottery(getpid(),1000000);
      fa:	e8 b3 0c 00 00       	call   db2 <getpid>
      ff:	52                   	push   %edx
     100:	52                   	push   %edx
     101:	68 40 42 0f 00       	push   $0xf4240
     106:	50                   	push   %eax
     107:	e8 fe 0c 00 00       	call   e0a <setLottery>
        runcmd(parsecmd(buf));
     10c:	c7 04 24 a0 18 00 00 	movl   $0x18a0,(%esp)
     113:	e8 68 09 00 00       	call   a80 <parsecmd>
     118:	89 04 24             	mov    %eax,(%esp)
     11b:	e8 70 00 00 00       	call   190 <runcmd>

00000120 <getcmd>:
  exit();
}

int
getcmd(char *buf, int nbuf)
{
     120:	55                   	push   %ebp
     121:	89 e5                	mov    %esp,%ebp
     123:	56                   	push   %esi
     124:	53                   	push   %ebx
     125:	8b 75 0c             	mov    0xc(%ebp),%esi
     128:	8b 5d 08             	mov    0x8(%ebp),%ebx
  printf(2, "$ ");
     12b:	83 ec 08             	sub    $0x8,%esp
     12e:	68 f0 11 00 00       	push   $0x11f0
     133:	6a 02                	push   $0x2
     135:	e8 96 0d 00 00       	call   ed0 <printf>
  memset(buf, 0, nbuf);
     13a:	83 c4 0c             	add    $0xc,%esp
     13d:	56                   	push   %esi
     13e:	6a 00                	push   $0x0
     140:	53                   	push   %ebx
     141:	e8 5a 0a 00 00       	call   ba0 <memset>
  gets(buf, nbuf);
     146:	58                   	pop    %eax
     147:	5a                   	pop    %edx
     148:	56                   	push   %esi
     149:	53                   	push   %ebx
     14a:	e8 b1 0a 00 00       	call   c00 <gets>
     14f:	83 c4 10             	add    $0x10,%esp
     152:	31 c0                	xor    %eax,%eax
     154:	80 3b 00             	cmpb   $0x0,(%ebx)
     157:	0f 94 c0             	sete   %al
  if(buf[0] == 0) // EOF
    return -1;
  return 0;
}
     15a:	8d 65 f8             	lea    -0x8(%ebp),%esp
     15d:	f7 d8                	neg    %eax
     15f:	5b                   	pop    %ebx
     160:	5e                   	pop    %esi
     161:	5d                   	pop    %ebp
     162:	c3                   	ret    
     163:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     169:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000170 <panic>:
  exit();
}

void
panic(char *s)
{
     170:	55                   	push   %ebp
     171:	89 e5                	mov    %esp,%ebp
     173:	83 ec 0c             	sub    $0xc,%esp
  printf(2, "%s\n", s);
     176:	ff 75 08             	pushl  0x8(%ebp)
     179:	68 8d 12 00 00       	push   $0x128d
     17e:	6a 02                	push   $0x2
     180:	e8 4b 0d 00 00       	call   ed0 <printf>
  exit();
     185:	e8 a8 0b 00 00       	call   d32 <exit>
     18a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000190 <runcmd>:
struct cmd *parsecmd(char*);

// Execute cmd.  Never returns.
void
runcmd(struct cmd *cmd)
{
     190:	55                   	push   %ebp
     191:	89 e5                	mov    %esp,%ebp
     193:	53                   	push   %ebx
     194:	83 ec 14             	sub    $0x14,%esp
     197:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
     19a:	85 db                	test   %ebx,%ebx
     19c:	74 76                	je     214 <runcmd+0x84>
    exit();

  switch(cmd->type){
     19e:	83 3b 05             	cmpl   $0x5,(%ebx)
     1a1:	0f 87 f8 00 00 00    	ja     29f <runcmd+0x10f>
     1a7:	8b 03                	mov    (%ebx),%eax
     1a9:	ff 24 85 a8 12 00 00 	jmp    *0x12a8(,%eax,4)
    runcmd(lcmd->right);
    break;

  case PIPE:
    pcmd = (struct pipecmd*)cmd;
    if(pipe(p) < 0)
     1b0:	8d 45 f0             	lea    -0x10(%ebp),%eax
     1b3:	83 ec 0c             	sub    $0xc,%esp
     1b6:	50                   	push   %eax
     1b7:	e8 86 0b 00 00       	call   d42 <pipe>
     1bc:	83 c4 10             	add    $0x10,%esp
     1bf:	85 c0                	test   %eax,%eax
     1c1:	0f 88 07 01 00 00    	js     2ce <runcmd+0x13e>
int
fork1(void)
{
  int pid;

  pid = fork();
     1c7:	e8 5e 0b 00 00       	call   d2a <fork>
  if(pid == -1)
     1cc:	83 f8 ff             	cmp    $0xffffffff,%eax
     1cf:	0f 84 d7 00 00 00    	je     2ac <runcmd+0x11c>

  case PIPE:
    pcmd = (struct pipecmd*)cmd;
    if(pipe(p) < 0)
      panic("pipe");
    if(fork1() == 0){
     1d5:	85 c0                	test   %eax,%eax
     1d7:	0f 84 fe 00 00 00    	je     2db <runcmd+0x14b>
int
fork1(void)
{
  int pid;

  pid = fork();
     1dd:	e8 48 0b 00 00       	call   d2a <fork>
  if(pid == -1)
     1e2:	83 f8 ff             	cmp    $0xffffffff,%eax
     1e5:	0f 84 c1 00 00 00    	je     2ac <runcmd+0x11c>
      dup(p[1]);
      close(p[0]);
      close(p[1]);
      runcmd(pcmd->left);
    }
    if(fork1() == 0){
     1eb:	85 c0                	test   %eax,%eax
     1ed:	0f 84 16 01 00 00    	je     309 <runcmd+0x179>
      dup(p[0]);
      close(p[0]);
      close(p[1]);
      runcmd(pcmd->right);
    }
    close(p[0]);
     1f3:	83 ec 0c             	sub    $0xc,%esp
     1f6:	ff 75 f0             	pushl  -0x10(%ebp)
     1f9:	e8 5c 0b 00 00       	call   d5a <close>
    close(p[1]);
     1fe:	58                   	pop    %eax
     1ff:	ff 75 f4             	pushl  -0xc(%ebp)
     202:	e8 53 0b 00 00       	call   d5a <close>
    wait();
     207:	e8 2e 0b 00 00       	call   d3a <wait>
    wait();
     20c:	e8 29 0b 00 00       	call   d3a <wait>
    break;
     211:	83 c4 10             	add    $0x10,%esp
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
    exit();
     214:	e8 19 0b 00 00       	call   d32 <exit>
int
fork1(void)
{
  int pid;

  pid = fork();
     219:	e8 0c 0b 00 00       	call   d2a <fork>
  if(pid == -1)
     21e:	83 f8 ff             	cmp    $0xffffffff,%eax
     221:	0f 84 85 00 00 00    	je     2ac <runcmd+0x11c>
    wait();
    break;

  case BACK:
    bcmd = (struct backcmd*)cmd;
    if(fork1() == 0)
     227:	85 c0                	test   %eax,%eax
     229:	75 e9                	jne    214 <runcmd+0x84>
     22b:	eb 49                	jmp    276 <runcmd+0xe6>
  default:
    panic("runcmd");

  case EXEC:
    ecmd = (struct execcmd*)cmd;
    if(ecmd->argv[0] == 0)
     22d:	8b 43 04             	mov    0x4(%ebx),%eax
     230:	85 c0                	test   %eax,%eax
     232:	74 e0                	je     214 <runcmd+0x84>
      exit();
    exec(ecmd->argv[0], ecmd->argv);
     234:	52                   	push   %edx
     235:	52                   	push   %edx
     236:	8d 53 04             	lea    0x4(%ebx),%edx
     239:	52                   	push   %edx
     23a:	50                   	push   %eax
     23b:	e8 2a 0b 00 00       	call   d6a <exec>
    printf(2, "exec %s failed\n", ecmd->argv[0]);
     240:	83 c4 0c             	add    $0xc,%esp
     243:	ff 73 04             	pushl  0x4(%ebx)
     246:	68 fa 11 00 00       	push   $0x11fa
     24b:	6a 02                	push   $0x2
     24d:	e8 7e 0c 00 00       	call   ed0 <printf>
    break;
     252:	83 c4 10             	add    $0x10,%esp
     255:	eb bd                	jmp    214 <runcmd+0x84>

  case REDIR:
    rcmd = (struct redircmd*)cmd;
    close(rcmd->fd);
     257:	83 ec 0c             	sub    $0xc,%esp
     25a:	ff 73 14             	pushl  0x14(%ebx)
     25d:	e8 f8 0a 00 00       	call   d5a <close>
    if(open(rcmd->file, rcmd->mode) < 0){
     262:	59                   	pop    %ecx
     263:	58                   	pop    %eax
     264:	ff 73 10             	pushl  0x10(%ebx)
     267:	ff 73 08             	pushl  0x8(%ebx)
     26a:	e8 03 0b 00 00       	call   d72 <open>
     26f:	83 c4 10             	add    $0x10,%esp
     272:	85 c0                	test   %eax,%eax
     274:	78 43                	js     2b9 <runcmd+0x129>
    break;

  case BACK:
    bcmd = (struct backcmd*)cmd;
    if(fork1() == 0)
      runcmd(bcmd->cmd);
     276:	83 ec 0c             	sub    $0xc,%esp
     279:	ff 73 04             	pushl  0x4(%ebx)
     27c:	e8 0f ff ff ff       	call   190 <runcmd>
int
fork1(void)
{
  int pid;

  pid = fork();
     281:	e8 a4 0a 00 00       	call   d2a <fork>
  if(pid == -1)
     286:	83 f8 ff             	cmp    $0xffffffff,%eax
     289:	74 21                	je     2ac <runcmd+0x11c>
    runcmd(rcmd->cmd);
    break;

  case LIST:
    lcmd = (struct listcmd*)cmd;
    if(fork1() == 0)
     28b:	85 c0                	test   %eax,%eax
     28d:	74 e7                	je     276 <runcmd+0xe6>
      runcmd(lcmd->left);
    wait();
     28f:	e8 a6 0a 00 00       	call   d3a <wait>
    runcmd(lcmd->right);
     294:	83 ec 0c             	sub    $0xc,%esp
     297:	ff 73 08             	pushl  0x8(%ebx)
     29a:	e8 f1 fe ff ff       	call   190 <runcmd>
  if(cmd == 0)
    exit();

  switch(cmd->type){
  default:
    panic("runcmd");
     29f:	83 ec 0c             	sub    $0xc,%esp
     2a2:	68 f3 11 00 00       	push   $0x11f3
     2a7:	e8 c4 fe ff ff       	call   170 <panic>
{
  int pid;

  pid = fork();
  if(pid == -1)
    panic("fork");
     2ac:	83 ec 0c             	sub    $0xc,%esp
     2af:	68 1a 12 00 00       	push   $0x121a
     2b4:	e8 b7 fe ff ff       	call   170 <panic>

  case REDIR:
    rcmd = (struct redircmd*)cmd;
    close(rcmd->fd);
    if(open(rcmd->file, rcmd->mode) < 0){
      printf(2, "open %s failed\n", rcmd->file);
     2b9:	52                   	push   %edx
     2ba:	ff 73 08             	pushl  0x8(%ebx)
     2bd:	68 0a 12 00 00       	push   $0x120a
     2c2:	6a 02                	push   $0x2
     2c4:	e8 07 0c 00 00       	call   ed0 <printf>
      exit();
     2c9:	e8 64 0a 00 00       	call   d32 <exit>
    break;

  case PIPE:
    pcmd = (struct pipecmd*)cmd;
    if(pipe(p) < 0)
      panic("pipe");
     2ce:	83 ec 0c             	sub    $0xc,%esp
     2d1:	68 1f 12 00 00       	push   $0x121f
     2d6:	e8 95 fe ff ff       	call   170 <panic>
    if(fork1() == 0){
      close(1);
     2db:	83 ec 0c             	sub    $0xc,%esp
     2de:	6a 01                	push   $0x1
     2e0:	e8 75 0a 00 00       	call   d5a <close>
      dup(p[1]);
     2e5:	58                   	pop    %eax
     2e6:	ff 75 f4             	pushl  -0xc(%ebp)
     2e9:	e8 bc 0a 00 00       	call   daa <dup>
      close(p[0]);
     2ee:	58                   	pop    %eax
     2ef:	ff 75 f0             	pushl  -0x10(%ebp)
     2f2:	e8 63 0a 00 00       	call   d5a <close>
      close(p[1]);
     2f7:	58                   	pop    %eax
     2f8:	ff 75 f4             	pushl  -0xc(%ebp)
     2fb:	e8 5a 0a 00 00       	call   d5a <close>
      runcmd(pcmd->left);
     300:	58                   	pop    %eax
     301:	ff 73 04             	pushl  0x4(%ebx)
     304:	e8 87 fe ff ff       	call   190 <runcmd>
    }
    if(fork1() == 0){
      close(0);
     309:	83 ec 0c             	sub    $0xc,%esp
     30c:	6a 00                	push   $0x0
     30e:	e8 47 0a 00 00       	call   d5a <close>
      dup(p[0]);
     313:	5a                   	pop    %edx
     314:	ff 75 f0             	pushl  -0x10(%ebp)
     317:	e8 8e 0a 00 00       	call   daa <dup>
      close(p[0]);
     31c:	59                   	pop    %ecx
     31d:	ff 75 f0             	pushl  -0x10(%ebp)
     320:	e8 35 0a 00 00       	call   d5a <close>
      close(p[1]);
     325:	58                   	pop    %eax
     326:	ff 75 f4             	pushl  -0xc(%ebp)
     329:	e8 2c 0a 00 00       	call   d5a <close>
      runcmd(pcmd->right);
     32e:	58                   	pop    %eax
     32f:	ff 73 08             	pushl  0x8(%ebx)
     332:	e8 59 fe ff ff       	call   190 <runcmd>
     337:	89 f6                	mov    %esi,%esi
     339:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000340 <fork1>:
  exit();
}

int
fork1(void)
{
     340:	55                   	push   %ebp
     341:	89 e5                	mov    %esp,%ebp
     343:	83 ec 08             	sub    $0x8,%esp
  int pid;

  pid = fork();
     346:	e8 df 09 00 00       	call   d2a <fork>
  if(pid == -1)
     34b:	83 f8 ff             	cmp    $0xffffffff,%eax
     34e:	74 02                	je     352 <fork1+0x12>
    panic("fork");
  return pid;
}
     350:	c9                   	leave  
     351:	c3                   	ret    
{
  int pid;

  pid = fork();
  if(pid == -1)
    panic("fork");
     352:	83 ec 0c             	sub    $0xc,%esp
     355:	68 1a 12 00 00       	push   $0x121a
     35a:	e8 11 fe ff ff       	call   170 <panic>
     35f:	90                   	nop

00000360 <execcmd>:
//PAGEBREAK!
// Constructors

struct cmd*
execcmd(void)
{
     360:	55                   	push   %ebp
     361:	89 e5                	mov    %esp,%ebp
     363:	53                   	push   %ebx
     364:	83 ec 10             	sub    $0x10,%esp
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     367:	6a 54                	push   $0x54
     369:	e8 92 0d 00 00       	call   1100 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     36e:	83 c4 0c             	add    $0xc,%esp
struct cmd*
execcmd(void)
{
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     371:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     373:	6a 54                	push   $0x54
     375:	6a 00                	push   $0x0
     377:	50                   	push   %eax
     378:	e8 23 08 00 00       	call   ba0 <memset>
  cmd->type = EXEC;
     37d:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  return (struct cmd*)cmd;
}
     383:	89 d8                	mov    %ebx,%eax
     385:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     388:	c9                   	leave  
     389:	c3                   	ret    
     38a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000390 <redircmd>:

struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
     390:	55                   	push   %ebp
     391:	89 e5                	mov    %esp,%ebp
     393:	53                   	push   %ebx
     394:	83 ec 10             	sub    $0x10,%esp
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
     397:	6a 18                	push   $0x18
     399:	e8 62 0d 00 00       	call   1100 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     39e:	83 c4 0c             	add    $0xc,%esp
struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
     3a1:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     3a3:	6a 18                	push   $0x18
     3a5:	6a 00                	push   $0x0
     3a7:	50                   	push   %eax
     3a8:	e8 f3 07 00 00       	call   ba0 <memset>
  cmd->type = REDIR;
  cmd->cmd = subcmd;
     3ad:	8b 45 08             	mov    0x8(%ebp),%eax
{
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
  memset(cmd, 0, sizeof(*cmd));
  cmd->type = REDIR;
     3b0:	c7 03 02 00 00 00    	movl   $0x2,(%ebx)
  cmd->cmd = subcmd;
     3b6:	89 43 04             	mov    %eax,0x4(%ebx)
  cmd->file = file;
     3b9:	8b 45 0c             	mov    0xc(%ebp),%eax
     3bc:	89 43 08             	mov    %eax,0x8(%ebx)
  cmd->efile = efile;
     3bf:	8b 45 10             	mov    0x10(%ebp),%eax
     3c2:	89 43 0c             	mov    %eax,0xc(%ebx)
  cmd->mode = mode;
     3c5:	8b 45 14             	mov    0x14(%ebp),%eax
     3c8:	89 43 10             	mov    %eax,0x10(%ebx)
  cmd->fd = fd;
     3cb:	8b 45 18             	mov    0x18(%ebp),%eax
     3ce:	89 43 14             	mov    %eax,0x14(%ebx)
  return (struct cmd*)cmd;
}
     3d1:	89 d8                	mov    %ebx,%eax
     3d3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     3d6:	c9                   	leave  
     3d7:	c3                   	ret    
     3d8:	90                   	nop
     3d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000003e0 <pipecmd>:

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
     3e0:	55                   	push   %ebp
     3e1:	89 e5                	mov    %esp,%ebp
     3e3:	53                   	push   %ebx
     3e4:	83 ec 10             	sub    $0x10,%esp
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
     3e7:	6a 0c                	push   $0xc
     3e9:	e8 12 0d 00 00       	call   1100 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     3ee:	83 c4 0c             	add    $0xc,%esp
struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
     3f1:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     3f3:	6a 0c                	push   $0xc
     3f5:	6a 00                	push   $0x0
     3f7:	50                   	push   %eax
     3f8:	e8 a3 07 00 00       	call   ba0 <memset>
  cmd->type = PIPE;
  cmd->left = left;
     3fd:	8b 45 08             	mov    0x8(%ebp),%eax
{
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
  memset(cmd, 0, sizeof(*cmd));
  cmd->type = PIPE;
     400:	c7 03 03 00 00 00    	movl   $0x3,(%ebx)
  cmd->left = left;
     406:	89 43 04             	mov    %eax,0x4(%ebx)
  cmd->right = right;
     409:	8b 45 0c             	mov    0xc(%ebp),%eax
     40c:	89 43 08             	mov    %eax,0x8(%ebx)
  return (struct cmd*)cmd;
}
     40f:	89 d8                	mov    %ebx,%eax
     411:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     414:	c9                   	leave  
     415:	c3                   	ret    
     416:	8d 76 00             	lea    0x0(%esi),%esi
     419:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000420 <listcmd>:

struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
     420:	55                   	push   %ebp
     421:	89 e5                	mov    %esp,%ebp
     423:	53                   	push   %ebx
     424:	83 ec 10             	sub    $0x10,%esp
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     427:	6a 0c                	push   $0xc
     429:	e8 d2 0c 00 00       	call   1100 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     42e:	83 c4 0c             	add    $0xc,%esp
struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     431:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     433:	6a 0c                	push   $0xc
     435:	6a 00                	push   $0x0
     437:	50                   	push   %eax
     438:	e8 63 07 00 00       	call   ba0 <memset>
  cmd->type = LIST;
  cmd->left = left;
     43d:	8b 45 08             	mov    0x8(%ebp),%eax
{
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
  memset(cmd, 0, sizeof(*cmd));
  cmd->type = LIST;
     440:	c7 03 04 00 00 00    	movl   $0x4,(%ebx)
  cmd->left = left;
     446:	89 43 04             	mov    %eax,0x4(%ebx)
  cmd->right = right;
     449:	8b 45 0c             	mov    0xc(%ebp),%eax
     44c:	89 43 08             	mov    %eax,0x8(%ebx)
  return (struct cmd*)cmd;
}
     44f:	89 d8                	mov    %ebx,%eax
     451:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     454:	c9                   	leave  
     455:	c3                   	ret    
     456:	8d 76 00             	lea    0x0(%esi),%esi
     459:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000460 <backcmd>:

struct cmd*
backcmd(struct cmd *subcmd)
{
     460:	55                   	push   %ebp
     461:	89 e5                	mov    %esp,%ebp
     463:	53                   	push   %ebx
     464:	83 ec 10             	sub    $0x10,%esp
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     467:	6a 08                	push   $0x8
     469:	e8 92 0c 00 00       	call   1100 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     46e:	83 c4 0c             	add    $0xc,%esp
struct cmd*
backcmd(struct cmd *subcmd)
{
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     471:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     473:	6a 08                	push   $0x8
     475:	6a 00                	push   $0x0
     477:	50                   	push   %eax
     478:	e8 23 07 00 00       	call   ba0 <memset>
  cmd->type = BACK;
  cmd->cmd = subcmd;
     47d:	8b 45 08             	mov    0x8(%ebp),%eax
{
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
  memset(cmd, 0, sizeof(*cmd));
  cmd->type = BACK;
     480:	c7 03 05 00 00 00    	movl   $0x5,(%ebx)
  cmd->cmd = subcmd;
     486:	89 43 04             	mov    %eax,0x4(%ebx)
  return (struct cmd*)cmd;
}
     489:	89 d8                	mov    %ebx,%eax
     48b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     48e:	c9                   	leave  
     48f:	c3                   	ret    

00000490 <gettoken>:
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
     490:	55                   	push   %ebp
     491:	89 e5                	mov    %esp,%ebp
     493:	57                   	push   %edi
     494:	56                   	push   %esi
     495:	53                   	push   %ebx
     496:	83 ec 0c             	sub    $0xc,%esp
  char *s;
  int ret;

  s = *ps;
     499:	8b 45 08             	mov    0x8(%ebp),%eax
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
     49c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
     49f:	8b 75 10             	mov    0x10(%ebp),%esi
  char *s;
  int ret;

  s = *ps;
     4a2:	8b 38                	mov    (%eax),%edi
  while(s < es && strchr(whitespace, *s))
     4a4:	39 df                	cmp    %ebx,%edi
     4a6:	72 13                	jb     4bb <gettoken+0x2b>
     4a8:	eb 29                	jmp    4d3 <gettoken+0x43>
     4aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    s++;
     4b0:	83 c7 01             	add    $0x1,%edi
{
  char *s;
  int ret;

  s = *ps;
  while(s < es && strchr(whitespace, *s))
     4b3:	39 fb                	cmp    %edi,%ebx
     4b5:	0f 84 ed 00 00 00    	je     5a8 <gettoken+0x118>
     4bb:	0f be 07             	movsbl (%edi),%eax
     4be:	83 ec 08             	sub    $0x8,%esp
     4c1:	50                   	push   %eax
     4c2:	68 98 18 00 00       	push   $0x1898
     4c7:	e8 f4 06 00 00       	call   bc0 <strchr>
     4cc:	83 c4 10             	add    $0x10,%esp
     4cf:	85 c0                	test   %eax,%eax
     4d1:	75 dd                	jne    4b0 <gettoken+0x20>
    s++;
  if(q)
     4d3:	85 f6                	test   %esi,%esi
     4d5:	74 02                	je     4d9 <gettoken+0x49>
    *q = s;
     4d7:	89 3e                	mov    %edi,(%esi)
  ret = *s;
     4d9:	0f be 37             	movsbl (%edi),%esi
     4dc:	89 f1                	mov    %esi,%ecx
     4de:	89 f0                	mov    %esi,%eax
  switch(*s){
     4e0:	80 f9 29             	cmp    $0x29,%cl
     4e3:	7f 5b                	jg     540 <gettoken+0xb0>
     4e5:	80 f9 28             	cmp    $0x28,%cl
     4e8:	7d 61                	jge    54b <gettoken+0xbb>
     4ea:	84 c9                	test   %cl,%cl
     4ec:	0f 85 de 00 00 00    	jne    5d0 <gettoken+0x140>
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
  }
  if(eq)
     4f2:	8b 55 14             	mov    0x14(%ebp),%edx
     4f5:	85 d2                	test   %edx,%edx
     4f7:	74 05                	je     4fe <gettoken+0x6e>
    *eq = s;
     4f9:	8b 45 14             	mov    0x14(%ebp),%eax
     4fc:	89 38                	mov    %edi,(%eax)

  while(s < es && strchr(whitespace, *s))
     4fe:	39 fb                	cmp    %edi,%ebx
     500:	77 0d                	ja     50f <gettoken+0x7f>
     502:	eb 23                	jmp    527 <gettoken+0x97>
     504:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    s++;
     508:	83 c7 01             	add    $0x1,%edi
    break;
  }
  if(eq)
    *eq = s;

  while(s < es && strchr(whitespace, *s))
     50b:	39 fb                	cmp    %edi,%ebx
     50d:	74 18                	je     527 <gettoken+0x97>
     50f:	0f be 07             	movsbl (%edi),%eax
     512:	83 ec 08             	sub    $0x8,%esp
     515:	50                   	push   %eax
     516:	68 98 18 00 00       	push   $0x1898
     51b:	e8 a0 06 00 00       	call   bc0 <strchr>
     520:	83 c4 10             	add    $0x10,%esp
     523:	85 c0                	test   %eax,%eax
     525:	75 e1                	jne    508 <gettoken+0x78>
    s++;
  *ps = s;
     527:	8b 45 08             	mov    0x8(%ebp),%eax
     52a:	89 38                	mov    %edi,(%eax)
  return ret;
}
     52c:	8d 65 f4             	lea    -0xc(%ebp),%esp
     52f:	89 f0                	mov    %esi,%eax
     531:	5b                   	pop    %ebx
     532:	5e                   	pop    %esi
     533:	5f                   	pop    %edi
     534:	5d                   	pop    %ebp
     535:	c3                   	ret    
     536:	8d 76 00             	lea    0x0(%esi),%esi
     539:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  while(s < es && strchr(whitespace, *s))
    s++;
  if(q)
    *q = s;
  ret = *s;
  switch(*s){
     540:	80 f9 3e             	cmp    $0x3e,%cl
     543:	75 0b                	jne    550 <gettoken+0xc0>
  case '<':
    s++;
    break;
  case '>':
    s++;
    if(*s == '>'){
     545:	80 7f 01 3e          	cmpb   $0x3e,0x1(%edi)
     549:	74 75                	je     5c0 <gettoken+0x130>
  case '&':
  case '<':
    s++;
    break;
  case '>':
    s++;
     54b:	83 c7 01             	add    $0x1,%edi
     54e:	eb a2                	jmp    4f2 <gettoken+0x62>
  while(s < es && strchr(whitespace, *s))
    s++;
  if(q)
    *q = s;
  ret = *s;
  switch(*s){
     550:	7f 5e                	jg     5b0 <gettoken+0x120>
     552:	83 e9 3b             	sub    $0x3b,%ecx
     555:	80 f9 01             	cmp    $0x1,%cl
     558:	76 f1                	jbe    54b <gettoken+0xbb>
      s++;
    }
    break;
  default:
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     55a:	39 fb                	cmp    %edi,%ebx
     55c:	77 24                	ja     582 <gettoken+0xf2>
     55e:	eb 7c                	jmp    5dc <gettoken+0x14c>
     560:	0f be 07             	movsbl (%edi),%eax
     563:	83 ec 08             	sub    $0x8,%esp
     566:	50                   	push   %eax
     567:	68 90 18 00 00       	push   $0x1890
     56c:	e8 4f 06 00 00       	call   bc0 <strchr>
     571:	83 c4 10             	add    $0x10,%esp
     574:	85 c0                	test   %eax,%eax
     576:	75 1f                	jne    597 <gettoken+0x107>
      s++;
     578:	83 c7 01             	add    $0x1,%edi
      s++;
    }
    break;
  default:
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     57b:	39 fb                	cmp    %edi,%ebx
     57d:	74 5b                	je     5da <gettoken+0x14a>
     57f:	0f be 07             	movsbl (%edi),%eax
     582:	83 ec 08             	sub    $0x8,%esp
     585:	50                   	push   %eax
     586:	68 98 18 00 00       	push   $0x1898
     58b:	e8 30 06 00 00       	call   bc0 <strchr>
     590:	83 c4 10             	add    $0x10,%esp
     593:	85 c0                	test   %eax,%eax
     595:	74 c9                	je     560 <gettoken+0xd0>
      ret = '+';
      s++;
    }
    break;
  default:
    ret = 'a';
     597:	be 61 00 00 00       	mov    $0x61,%esi
     59c:	e9 51 ff ff ff       	jmp    4f2 <gettoken+0x62>
     5a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     5a8:	89 df                	mov    %ebx,%edi
     5aa:	e9 24 ff ff ff       	jmp    4d3 <gettoken+0x43>
     5af:	90                   	nop
  while(s < es && strchr(whitespace, *s))
    s++;
  if(q)
    *q = s;
  ret = *s;
  switch(*s){
     5b0:	80 f9 7c             	cmp    $0x7c,%cl
     5b3:	74 96                	je     54b <gettoken+0xbb>
     5b5:	eb a3                	jmp    55a <gettoken+0xca>
     5b7:	89 f6                	mov    %esi,%esi
     5b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    break;
  case '>':
    s++;
    if(*s == '>'){
      ret = '+';
      s++;
     5c0:	83 c7 02             	add    $0x2,%edi
    s++;
    break;
  case '>':
    s++;
    if(*s == '>'){
      ret = '+';
     5c3:	be 2b 00 00 00       	mov    $0x2b,%esi
     5c8:	e9 25 ff ff ff       	jmp    4f2 <gettoken+0x62>
     5cd:	8d 76 00             	lea    0x0(%esi),%esi
  while(s < es && strchr(whitespace, *s))
    s++;
  if(q)
    *q = s;
  ret = *s;
  switch(*s){
     5d0:	80 f9 26             	cmp    $0x26,%cl
     5d3:	75 85                	jne    55a <gettoken+0xca>
     5d5:	e9 71 ff ff ff       	jmp    54b <gettoken+0xbb>
     5da:	89 df                	mov    %ebx,%edi
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
  }
  if(eq)
     5dc:	8b 45 14             	mov    0x14(%ebp),%eax
     5df:	be 61 00 00 00       	mov    $0x61,%esi
     5e4:	85 c0                	test   %eax,%eax
     5e6:	0f 85 0d ff ff ff    	jne    4f9 <gettoken+0x69>
     5ec:	e9 36 ff ff ff       	jmp    527 <gettoken+0x97>
     5f1:	eb 0d                	jmp    600 <peek>
     5f3:	90                   	nop
     5f4:	90                   	nop
     5f5:	90                   	nop
     5f6:	90                   	nop
     5f7:	90                   	nop
     5f8:	90                   	nop
     5f9:	90                   	nop
     5fa:	90                   	nop
     5fb:	90                   	nop
     5fc:	90                   	nop
     5fd:	90                   	nop
     5fe:	90                   	nop
     5ff:	90                   	nop

00000600 <peek>:
  return ret;
}

int
peek(char **ps, char *es, char *toks)
{
     600:	55                   	push   %ebp
     601:	89 e5                	mov    %esp,%ebp
     603:	57                   	push   %edi
     604:	56                   	push   %esi
     605:	53                   	push   %ebx
     606:	83 ec 0c             	sub    $0xc,%esp
     609:	8b 7d 08             	mov    0x8(%ebp),%edi
     60c:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *s;

  s = *ps;
     60f:	8b 1f                	mov    (%edi),%ebx
  while(s < es && strchr(whitespace, *s))
     611:	39 f3                	cmp    %esi,%ebx
     613:	72 12                	jb     627 <peek+0x27>
     615:	eb 28                	jmp    63f <peek+0x3f>
     617:	89 f6                	mov    %esi,%esi
     619:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    s++;
     620:	83 c3 01             	add    $0x1,%ebx
peek(char **ps, char *es, char *toks)
{
  char *s;

  s = *ps;
  while(s < es && strchr(whitespace, *s))
     623:	39 de                	cmp    %ebx,%esi
     625:	74 18                	je     63f <peek+0x3f>
     627:	0f be 03             	movsbl (%ebx),%eax
     62a:	83 ec 08             	sub    $0x8,%esp
     62d:	50                   	push   %eax
     62e:	68 98 18 00 00       	push   $0x1898
     633:	e8 88 05 00 00       	call   bc0 <strchr>
     638:	83 c4 10             	add    $0x10,%esp
     63b:	85 c0                	test   %eax,%eax
     63d:	75 e1                	jne    620 <peek+0x20>
    s++;
  *ps = s;
     63f:	89 1f                	mov    %ebx,(%edi)
  return *s && strchr(toks, *s);
     641:	0f be 13             	movsbl (%ebx),%edx
     644:	31 c0                	xor    %eax,%eax
     646:	84 d2                	test   %dl,%dl
     648:	74 17                	je     661 <peek+0x61>
     64a:	83 ec 08             	sub    $0x8,%esp
     64d:	52                   	push   %edx
     64e:	ff 75 10             	pushl  0x10(%ebp)
     651:	e8 6a 05 00 00       	call   bc0 <strchr>
     656:	83 c4 10             	add    $0x10,%esp
     659:	85 c0                	test   %eax,%eax
     65b:	0f 95 c0             	setne  %al
     65e:	0f b6 c0             	movzbl %al,%eax
}
     661:	8d 65 f4             	lea    -0xc(%ebp),%esp
     664:	5b                   	pop    %ebx
     665:	5e                   	pop    %esi
     666:	5f                   	pop    %edi
     667:	5d                   	pop    %ebp
     668:	c3                   	ret    
     669:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000670 <parseredirs>:
  return cmd;
}

struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
     670:	55                   	push   %ebp
     671:	89 e5                	mov    %esp,%ebp
     673:	57                   	push   %edi
     674:	56                   	push   %esi
     675:	53                   	push   %ebx
     676:	83 ec 1c             	sub    $0x1c,%esp
     679:	8b 75 0c             	mov    0xc(%ebp),%esi
     67c:	8b 5d 10             	mov    0x10(%ebp),%ebx
     67f:	90                   	nop
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     680:	83 ec 04             	sub    $0x4,%esp
     683:	68 41 12 00 00       	push   $0x1241
     688:	53                   	push   %ebx
     689:	56                   	push   %esi
     68a:	e8 71 ff ff ff       	call   600 <peek>
     68f:	83 c4 10             	add    $0x10,%esp
     692:	85 c0                	test   %eax,%eax
     694:	74 6a                	je     700 <parseredirs+0x90>
    tok = gettoken(ps, es, 0, 0);
     696:	6a 00                	push   $0x0
     698:	6a 00                	push   $0x0
     69a:	53                   	push   %ebx
     69b:	56                   	push   %esi
     69c:	e8 ef fd ff ff       	call   490 <gettoken>
     6a1:	89 c7                	mov    %eax,%edi
    if(gettoken(ps, es, &q, &eq) != 'a')
     6a3:	8d 45 e4             	lea    -0x1c(%ebp),%eax
     6a6:	50                   	push   %eax
     6a7:	8d 45 e0             	lea    -0x20(%ebp),%eax
     6aa:	50                   	push   %eax
     6ab:	53                   	push   %ebx
     6ac:	56                   	push   %esi
     6ad:	e8 de fd ff ff       	call   490 <gettoken>
     6b2:	83 c4 20             	add    $0x20,%esp
     6b5:	83 f8 61             	cmp    $0x61,%eax
     6b8:	75 51                	jne    70b <parseredirs+0x9b>
      panic("missing file for redirection");
    switch(tok){
     6ba:	83 ff 3c             	cmp    $0x3c,%edi
     6bd:	74 31                	je     6f0 <parseredirs+0x80>
     6bf:	83 ff 3e             	cmp    $0x3e,%edi
     6c2:	74 05                	je     6c9 <parseredirs+0x59>
     6c4:	83 ff 2b             	cmp    $0x2b,%edi
     6c7:	75 b7                	jne    680 <parseredirs+0x10>
      break;
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
      break;
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     6c9:	83 ec 0c             	sub    $0xc,%esp
     6cc:	6a 01                	push   $0x1
     6ce:	68 01 02 00 00       	push   $0x201
     6d3:	ff 75 e4             	pushl  -0x1c(%ebp)
     6d6:	ff 75 e0             	pushl  -0x20(%ebp)
     6d9:	ff 75 08             	pushl  0x8(%ebp)
     6dc:	e8 af fc ff ff       	call   390 <redircmd>
      break;
     6e1:	83 c4 20             	add    $0x20,%esp
      break;
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
      break;
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     6e4:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
     6e7:	eb 97                	jmp    680 <parseredirs+0x10>
     6e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    tok = gettoken(ps, es, 0, 0);
    if(gettoken(ps, es, &q, &eq) != 'a')
      panic("missing file for redirection");
    switch(tok){
    case '<':
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     6f0:	83 ec 0c             	sub    $0xc,%esp
     6f3:	6a 00                	push   $0x0
     6f5:	6a 00                	push   $0x0
     6f7:	eb da                	jmp    6d3 <parseredirs+0x63>
     6f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
      break;
    }
  }
  return cmd;
}
     700:	8b 45 08             	mov    0x8(%ebp),%eax
     703:	8d 65 f4             	lea    -0xc(%ebp),%esp
     706:	5b                   	pop    %ebx
     707:	5e                   	pop    %esi
     708:	5f                   	pop    %edi
     709:	5d                   	pop    %ebp
     70a:	c3                   	ret    
  char *q, *eq;

  while(peek(ps, es, "<>")){
    tok = gettoken(ps, es, 0, 0);
    if(gettoken(ps, es, &q, &eq) != 'a')
      panic("missing file for redirection");
     70b:	83 ec 0c             	sub    $0xc,%esp
     70e:	68 24 12 00 00       	push   $0x1224
     713:	e8 58 fa ff ff       	call   170 <panic>
     718:	90                   	nop
     719:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000720 <parseexec>:
  return cmd;
}

struct cmd*
parseexec(char **ps, char *es)
{
     720:	55                   	push   %ebp
     721:	89 e5                	mov    %esp,%ebp
     723:	57                   	push   %edi
     724:	56                   	push   %esi
     725:	53                   	push   %ebx
     726:	83 ec 30             	sub    $0x30,%esp
     729:	8b 75 08             	mov    0x8(%ebp),%esi
     72c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;

  if(peek(ps, es, "("))
     72f:	68 44 12 00 00       	push   $0x1244
     734:	57                   	push   %edi
     735:	56                   	push   %esi
     736:	e8 c5 fe ff ff       	call   600 <peek>
     73b:	83 c4 10             	add    $0x10,%esp
     73e:	85 c0                	test   %eax,%eax
     740:	0f 85 9a 00 00 00    	jne    7e0 <parseexec+0xc0>
    return parseblock(ps, es);

  ret = execcmd();
     746:	e8 15 fc ff ff       	call   360 <execcmd>
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
     74b:	83 ec 04             	sub    $0x4,%esp
  struct cmd *ret;

  if(peek(ps, es, "("))
    return parseblock(ps, es);

  ret = execcmd();
     74e:	89 c3                	mov    %eax,%ebx
     750:	89 45 cc             	mov    %eax,-0x34(%ebp)
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
     753:	57                   	push   %edi
     754:	56                   	push   %esi
     755:	8d 5b 04             	lea    0x4(%ebx),%ebx
     758:	50                   	push   %eax
     759:	e8 12 ff ff ff       	call   670 <parseredirs>
     75e:	83 c4 10             	add    $0x10,%esp
     761:	89 45 d0             	mov    %eax,-0x30(%ebp)
    return parseblock(ps, es);

  ret = execcmd();
  cmd = (struct execcmd*)ret;

  argc = 0;
     764:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
     76b:	eb 16                	jmp    783 <parseexec+0x63>
     76d:	8d 76 00             	lea    0x0(%esi),%esi
    cmd->argv[argc] = q;
    cmd->eargv[argc] = eq;
    argc++;
    if(argc >= MAXARGS)
      panic("too many args");
    ret = parseredirs(ret, ps, es);
     770:	83 ec 04             	sub    $0x4,%esp
     773:	57                   	push   %edi
     774:	56                   	push   %esi
     775:	ff 75 d0             	pushl  -0x30(%ebp)
     778:	e8 f3 fe ff ff       	call   670 <parseredirs>
     77d:	83 c4 10             	add    $0x10,%esp
     780:	89 45 d0             	mov    %eax,-0x30(%ebp)
  ret = execcmd();
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
  while(!peek(ps, es, "|)&;")){
     783:	83 ec 04             	sub    $0x4,%esp
     786:	68 5b 12 00 00       	push   $0x125b
     78b:	57                   	push   %edi
     78c:	56                   	push   %esi
     78d:	e8 6e fe ff ff       	call   600 <peek>
     792:	83 c4 10             	add    $0x10,%esp
     795:	85 c0                	test   %eax,%eax
     797:	75 5f                	jne    7f8 <parseexec+0xd8>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
     799:	8d 45 e4             	lea    -0x1c(%ebp),%eax
     79c:	50                   	push   %eax
     79d:	8d 45 e0             	lea    -0x20(%ebp),%eax
     7a0:	50                   	push   %eax
     7a1:	57                   	push   %edi
     7a2:	56                   	push   %esi
     7a3:	e8 e8 fc ff ff       	call   490 <gettoken>
     7a8:	83 c4 10             	add    $0x10,%esp
     7ab:	85 c0                	test   %eax,%eax
     7ad:	74 49                	je     7f8 <parseexec+0xd8>
      break;
    if(tok != 'a')
     7af:	83 f8 61             	cmp    $0x61,%eax
     7b2:	75 66                	jne    81a <parseexec+0xfa>
      panic("syntax");
    cmd->argv[argc] = q;
     7b4:	8b 45 e0             	mov    -0x20(%ebp),%eax
    cmd->eargv[argc] = eq;
    argc++;
     7b7:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
     7bb:	83 c3 04             	add    $0x4,%ebx
  while(!peek(ps, es, "|)&;")){
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
      break;
    if(tok != 'a')
      panic("syntax");
    cmd->argv[argc] = q;
     7be:	89 43 fc             	mov    %eax,-0x4(%ebx)
    cmd->eargv[argc] = eq;
     7c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     7c4:	89 43 24             	mov    %eax,0x24(%ebx)
    argc++;
     7c7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    if(argc >= MAXARGS)
     7ca:	83 f8 0a             	cmp    $0xa,%eax
     7cd:	75 a1                	jne    770 <parseexec+0x50>
      panic("too many args");
     7cf:	83 ec 0c             	sub    $0xc,%esp
     7d2:	68 4d 12 00 00       	push   $0x124d
     7d7:	e8 94 f9 ff ff       	call   170 <panic>
     7dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;

  if(peek(ps, es, "("))
    return parseblock(ps, es);
     7e0:	83 ec 08             	sub    $0x8,%esp
     7e3:	57                   	push   %edi
     7e4:	56                   	push   %esi
     7e5:	e8 56 01 00 00       	call   940 <parseblock>
     7ea:	83 c4 10             	add    $0x10,%esp
    ret = parseredirs(ret, ps, es);
  }
  cmd->argv[argc] = 0;
  cmd->eargv[argc] = 0;
  return ret;
}
     7ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
     7f0:	5b                   	pop    %ebx
     7f1:	5e                   	pop    %esi
     7f2:	5f                   	pop    %edi
     7f3:	5d                   	pop    %ebp
     7f4:	c3                   	ret    
     7f5:	8d 76 00             	lea    0x0(%esi),%esi
     7f8:	8b 45 cc             	mov    -0x34(%ebp),%eax
     7fb:	8b 55 d4             	mov    -0x2c(%ebp),%edx
     7fe:	8d 04 90             	lea    (%eax,%edx,4),%eax
    argc++;
    if(argc >= MAXARGS)
      panic("too many args");
    ret = parseredirs(ret, ps, es);
  }
  cmd->argv[argc] = 0;
     801:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  cmd->eargv[argc] = 0;
     808:	c7 40 2c 00 00 00 00 	movl   $0x0,0x2c(%eax)
     80f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  return ret;
}
     812:	8d 65 f4             	lea    -0xc(%ebp),%esp
     815:	5b                   	pop    %ebx
     816:	5e                   	pop    %esi
     817:	5f                   	pop    %edi
     818:	5d                   	pop    %ebp
     819:	c3                   	ret    
  ret = parseredirs(ret, ps, es);
  while(!peek(ps, es, "|)&;")){
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
      break;
    if(tok != 'a')
      panic("syntax");
     81a:	83 ec 0c             	sub    $0xc,%esp
     81d:	68 46 12 00 00       	push   $0x1246
     822:	e8 49 f9 ff ff       	call   170 <panic>
     827:	89 f6                	mov    %esi,%esi
     829:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000830 <parsepipe>:
  return cmd;
}

struct cmd*
parsepipe(char **ps, char *es)
{
     830:	55                   	push   %ebp
     831:	89 e5                	mov    %esp,%ebp
     833:	57                   	push   %edi
     834:	56                   	push   %esi
     835:	53                   	push   %ebx
     836:	83 ec 14             	sub    $0x14,%esp
     839:	8b 5d 08             	mov    0x8(%ebp),%ebx
     83c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct cmd *cmd;

  cmd = parseexec(ps, es);
     83f:	56                   	push   %esi
     840:	53                   	push   %ebx
     841:	e8 da fe ff ff       	call   720 <parseexec>
  if(peek(ps, es, "|")){
     846:	83 c4 0c             	add    $0xc,%esp
struct cmd*
parsepipe(char **ps, char *es)
{
  struct cmd *cmd;

  cmd = parseexec(ps, es);
     849:	89 c7                	mov    %eax,%edi
  if(peek(ps, es, "|")){
     84b:	68 60 12 00 00       	push   $0x1260
     850:	56                   	push   %esi
     851:	53                   	push   %ebx
     852:	e8 a9 fd ff ff       	call   600 <peek>
     857:	83 c4 10             	add    $0x10,%esp
     85a:	85 c0                	test   %eax,%eax
     85c:	75 12                	jne    870 <parsepipe+0x40>
    gettoken(ps, es, 0, 0);
    cmd = pipecmd(cmd, parsepipe(ps, es));
  }
  return cmd;
}
     85e:	8d 65 f4             	lea    -0xc(%ebp),%esp
     861:	89 f8                	mov    %edi,%eax
     863:	5b                   	pop    %ebx
     864:	5e                   	pop    %esi
     865:	5f                   	pop    %edi
     866:	5d                   	pop    %ebp
     867:	c3                   	ret    
     868:	90                   	nop
     869:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
  struct cmd *cmd;

  cmd = parseexec(ps, es);
  if(peek(ps, es, "|")){
    gettoken(ps, es, 0, 0);
     870:	6a 00                	push   $0x0
     872:	6a 00                	push   $0x0
     874:	56                   	push   %esi
     875:	53                   	push   %ebx
     876:	e8 15 fc ff ff       	call   490 <gettoken>
    cmd = pipecmd(cmd, parsepipe(ps, es));
     87b:	58                   	pop    %eax
     87c:	5a                   	pop    %edx
     87d:	56                   	push   %esi
     87e:	53                   	push   %ebx
     87f:	e8 ac ff ff ff       	call   830 <parsepipe>
     884:	89 7d 08             	mov    %edi,0x8(%ebp)
     887:	89 45 0c             	mov    %eax,0xc(%ebp)
     88a:	83 c4 10             	add    $0x10,%esp
  }
  return cmd;
}
     88d:	8d 65 f4             	lea    -0xc(%ebp),%esp
     890:	5b                   	pop    %ebx
     891:	5e                   	pop    %esi
     892:	5f                   	pop    %edi
     893:	5d                   	pop    %ebp
  struct cmd *cmd;

  cmd = parseexec(ps, es);
  if(peek(ps, es, "|")){
    gettoken(ps, es, 0, 0);
    cmd = pipecmd(cmd, parsepipe(ps, es));
     894:	e9 47 fb ff ff       	jmp    3e0 <pipecmd>
     899:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000008a0 <parseline>:
  return cmd;
}

struct cmd*
parseline(char **ps, char *es)
{
     8a0:	55                   	push   %ebp
     8a1:	89 e5                	mov    %esp,%ebp
     8a3:	57                   	push   %edi
     8a4:	56                   	push   %esi
     8a5:	53                   	push   %ebx
     8a6:	83 ec 14             	sub    $0x14,%esp
     8a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
     8ac:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct cmd *cmd;

  cmd = parsepipe(ps, es);
     8af:	56                   	push   %esi
     8b0:	53                   	push   %ebx
     8b1:	e8 7a ff ff ff       	call   830 <parsepipe>
  while(peek(ps, es, "&")){
     8b6:	83 c4 10             	add    $0x10,%esp
struct cmd*
parseline(char **ps, char *es)
{
  struct cmd *cmd;

  cmd = parsepipe(ps, es);
     8b9:	89 c7                	mov    %eax,%edi
  while(peek(ps, es, "&")){
     8bb:	eb 1b                	jmp    8d8 <parseline+0x38>
     8bd:	8d 76 00             	lea    0x0(%esi),%esi
    gettoken(ps, es, 0, 0);
     8c0:	6a 00                	push   $0x0
     8c2:	6a 00                	push   $0x0
     8c4:	56                   	push   %esi
     8c5:	53                   	push   %ebx
     8c6:	e8 c5 fb ff ff       	call   490 <gettoken>
    cmd = backcmd(cmd);
     8cb:	89 3c 24             	mov    %edi,(%esp)
     8ce:	e8 8d fb ff ff       	call   460 <backcmd>
     8d3:	83 c4 10             	add    $0x10,%esp
     8d6:	89 c7                	mov    %eax,%edi
parseline(char **ps, char *es)
{
  struct cmd *cmd;

  cmd = parsepipe(ps, es);
  while(peek(ps, es, "&")){
     8d8:	83 ec 04             	sub    $0x4,%esp
     8db:	68 62 12 00 00       	push   $0x1262
     8e0:	56                   	push   %esi
     8e1:	53                   	push   %ebx
     8e2:	e8 19 fd ff ff       	call   600 <peek>
     8e7:	83 c4 10             	add    $0x10,%esp
     8ea:	85 c0                	test   %eax,%eax
     8ec:	75 d2                	jne    8c0 <parseline+0x20>
    gettoken(ps, es, 0, 0);
    cmd = backcmd(cmd);
  }
  if(peek(ps, es, ";")){
     8ee:	83 ec 04             	sub    $0x4,%esp
     8f1:	68 5e 12 00 00       	push   $0x125e
     8f6:	56                   	push   %esi
     8f7:	53                   	push   %ebx
     8f8:	e8 03 fd ff ff       	call   600 <peek>
     8fd:	83 c4 10             	add    $0x10,%esp
     900:	85 c0                	test   %eax,%eax
     902:	75 0c                	jne    910 <parseline+0x70>
    gettoken(ps, es, 0, 0);
    cmd = listcmd(cmd, parseline(ps, es));
  }
  return cmd;
}
     904:	8d 65 f4             	lea    -0xc(%ebp),%esp
     907:	89 f8                	mov    %edi,%eax
     909:	5b                   	pop    %ebx
     90a:	5e                   	pop    %esi
     90b:	5f                   	pop    %edi
     90c:	5d                   	pop    %ebp
     90d:	c3                   	ret    
     90e:	66 90                	xchg   %ax,%ax
  while(peek(ps, es, "&")){
    gettoken(ps, es, 0, 0);
    cmd = backcmd(cmd);
  }
  if(peek(ps, es, ";")){
    gettoken(ps, es, 0, 0);
     910:	6a 00                	push   $0x0
     912:	6a 00                	push   $0x0
     914:	56                   	push   %esi
     915:	53                   	push   %ebx
     916:	e8 75 fb ff ff       	call   490 <gettoken>
    cmd = listcmd(cmd, parseline(ps, es));
     91b:	58                   	pop    %eax
     91c:	5a                   	pop    %edx
     91d:	56                   	push   %esi
     91e:	53                   	push   %ebx
     91f:	e8 7c ff ff ff       	call   8a0 <parseline>
     924:	89 7d 08             	mov    %edi,0x8(%ebp)
     927:	89 45 0c             	mov    %eax,0xc(%ebp)
     92a:	83 c4 10             	add    $0x10,%esp
  }
  return cmd;
}
     92d:	8d 65 f4             	lea    -0xc(%ebp),%esp
     930:	5b                   	pop    %ebx
     931:	5e                   	pop    %esi
     932:	5f                   	pop    %edi
     933:	5d                   	pop    %ebp
    gettoken(ps, es, 0, 0);
    cmd = backcmd(cmd);
  }
  if(peek(ps, es, ";")){
    gettoken(ps, es, 0, 0);
    cmd = listcmd(cmd, parseline(ps, es));
     934:	e9 e7 fa ff ff       	jmp    420 <listcmd>
     939:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000940 <parseblock>:
  return cmd;
}

struct cmd*
parseblock(char **ps, char *es)
{
     940:	55                   	push   %ebp
     941:	89 e5                	mov    %esp,%ebp
     943:	57                   	push   %edi
     944:	56                   	push   %esi
     945:	53                   	push   %ebx
     946:	83 ec 10             	sub    $0x10,%esp
     949:	8b 5d 08             	mov    0x8(%ebp),%ebx
     94c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct cmd *cmd;

  if(!peek(ps, es, "("))
     94f:	68 44 12 00 00       	push   $0x1244
     954:	56                   	push   %esi
     955:	53                   	push   %ebx
     956:	e8 a5 fc ff ff       	call   600 <peek>
     95b:	83 c4 10             	add    $0x10,%esp
     95e:	85 c0                	test   %eax,%eax
     960:	74 4a                	je     9ac <parseblock+0x6c>
    panic("parseblock");
  gettoken(ps, es, 0, 0);
     962:	6a 00                	push   $0x0
     964:	6a 00                	push   $0x0
     966:	56                   	push   %esi
     967:	53                   	push   %ebx
     968:	e8 23 fb ff ff       	call   490 <gettoken>
  cmd = parseline(ps, es);
     96d:	58                   	pop    %eax
     96e:	5a                   	pop    %edx
     96f:	56                   	push   %esi
     970:	53                   	push   %ebx
     971:	e8 2a ff ff ff       	call   8a0 <parseline>
  if(!peek(ps, es, ")"))
     976:	83 c4 0c             	add    $0xc,%esp
  struct cmd *cmd;

  if(!peek(ps, es, "("))
    panic("parseblock");
  gettoken(ps, es, 0, 0);
  cmd = parseline(ps, es);
     979:	89 c7                	mov    %eax,%edi
  if(!peek(ps, es, ")"))
     97b:	68 80 12 00 00       	push   $0x1280
     980:	56                   	push   %esi
     981:	53                   	push   %ebx
     982:	e8 79 fc ff ff       	call   600 <peek>
     987:	83 c4 10             	add    $0x10,%esp
     98a:	85 c0                	test   %eax,%eax
     98c:	74 2b                	je     9b9 <parseblock+0x79>
    panic("syntax - missing )");
  gettoken(ps, es, 0, 0);
     98e:	6a 00                	push   $0x0
     990:	6a 00                	push   $0x0
     992:	56                   	push   %esi
     993:	53                   	push   %ebx
     994:	e8 f7 fa ff ff       	call   490 <gettoken>
  cmd = parseredirs(cmd, ps, es);
     999:	83 c4 0c             	add    $0xc,%esp
     99c:	56                   	push   %esi
     99d:	53                   	push   %ebx
     99e:	57                   	push   %edi
     99f:	e8 cc fc ff ff       	call   670 <parseredirs>
  return cmd;
}
     9a4:	8d 65 f4             	lea    -0xc(%ebp),%esp
     9a7:	5b                   	pop    %ebx
     9a8:	5e                   	pop    %esi
     9a9:	5f                   	pop    %edi
     9aa:	5d                   	pop    %ebp
     9ab:	c3                   	ret    
parseblock(char **ps, char *es)
{
  struct cmd *cmd;

  if(!peek(ps, es, "("))
    panic("parseblock");
     9ac:	83 ec 0c             	sub    $0xc,%esp
     9af:	68 64 12 00 00       	push   $0x1264
     9b4:	e8 b7 f7 ff ff       	call   170 <panic>
  gettoken(ps, es, 0, 0);
  cmd = parseline(ps, es);
  if(!peek(ps, es, ")"))
    panic("syntax - missing )");
     9b9:	83 ec 0c             	sub    $0xc,%esp
     9bc:	68 6f 12 00 00       	push   $0x126f
     9c1:	e8 aa f7 ff ff       	call   170 <panic>
     9c6:	8d 76 00             	lea    0x0(%esi),%esi
     9c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000009d0 <nulterminate>:
}

// NUL-terminate all the counted strings.
struct cmd*
nulterminate(struct cmd *cmd)
{
     9d0:	55                   	push   %ebp
     9d1:	89 e5                	mov    %esp,%ebp
     9d3:	53                   	push   %ebx
     9d4:	83 ec 04             	sub    $0x4,%esp
     9d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
     9da:	85 db                	test   %ebx,%ebx
     9dc:	0f 84 96 00 00 00    	je     a78 <nulterminate+0xa8>
    return 0;

  switch(cmd->type){
     9e2:	83 3b 05             	cmpl   $0x5,(%ebx)
     9e5:	77 48                	ja     a2f <nulterminate+0x5f>
     9e7:	8b 03                	mov    (%ebx),%eax
     9e9:	ff 24 85 c0 12 00 00 	jmp    *0x12c0(,%eax,4)
    nulterminate(pcmd->right);
    break;

  case LIST:
    lcmd = (struct listcmd*)cmd;
    nulterminate(lcmd->left);
     9f0:	83 ec 0c             	sub    $0xc,%esp
     9f3:	ff 73 04             	pushl  0x4(%ebx)
     9f6:	e8 d5 ff ff ff       	call   9d0 <nulterminate>
    nulterminate(lcmd->right);
     9fb:	58                   	pop    %eax
     9fc:	ff 73 08             	pushl  0x8(%ebx)
     9ff:	e8 cc ff ff ff       	call   9d0 <nulterminate>
    break;
     a04:	83 c4 10             	add    $0x10,%esp
     a07:	89 d8                	mov    %ebx,%eax
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
    break;
  }
  return cmd;
}
     a09:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     a0c:	c9                   	leave  
     a0d:	c3                   	ret    
     a0e:	66 90                	xchg   %ax,%ax
    return 0;

  switch(cmd->type){
  case EXEC:
    ecmd = (struct execcmd*)cmd;
    for(i=0; ecmd->argv[i]; i++)
     a10:	8b 4b 04             	mov    0x4(%ebx),%ecx
     a13:	8d 43 2c             	lea    0x2c(%ebx),%eax
     a16:	85 c9                	test   %ecx,%ecx
     a18:	74 15                	je     a2f <nulterminate+0x5f>
     a1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      *ecmd->eargv[i] = 0;
     a20:	8b 10                	mov    (%eax),%edx
     a22:	83 c0 04             	add    $0x4,%eax
     a25:	c6 02 00             	movb   $0x0,(%edx)
    return 0;

  switch(cmd->type){
  case EXEC:
    ecmd = (struct execcmd*)cmd;
    for(i=0; ecmd->argv[i]; i++)
     a28:	8b 50 d8             	mov    -0x28(%eax),%edx
     a2b:	85 d2                	test   %edx,%edx
     a2d:	75 f1                	jne    a20 <nulterminate+0x50>
  struct redircmd *rcmd;

  if(cmd == 0)
    return 0;

  switch(cmd->type){
     a2f:	89 d8                	mov    %ebx,%eax
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
    break;
  }
  return cmd;
}
     a31:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     a34:	c9                   	leave  
     a35:	c3                   	ret    
     a36:	8d 76 00             	lea    0x0(%esi),%esi
     a39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    nulterminate(lcmd->right);
    break;

  case BACK:
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
     a40:	83 ec 0c             	sub    $0xc,%esp
     a43:	ff 73 04             	pushl  0x4(%ebx)
     a46:	e8 85 ff ff ff       	call   9d0 <nulterminate>
    break;
     a4b:	89 d8                	mov    %ebx,%eax
     a4d:	83 c4 10             	add    $0x10,%esp
  }
  return cmd;
}
     a50:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     a53:	c9                   	leave  
     a54:	c3                   	ret    
     a55:	8d 76 00             	lea    0x0(%esi),%esi
      *ecmd->eargv[i] = 0;
    break;

  case REDIR:
    rcmd = (struct redircmd*)cmd;
    nulterminate(rcmd->cmd);
     a58:	83 ec 0c             	sub    $0xc,%esp
     a5b:	ff 73 04             	pushl  0x4(%ebx)
     a5e:	e8 6d ff ff ff       	call   9d0 <nulterminate>
    *rcmd->efile = 0;
     a63:	8b 43 0c             	mov    0xc(%ebx),%eax
    break;
     a66:	83 c4 10             	add    $0x10,%esp
    break;

  case REDIR:
    rcmd = (struct redircmd*)cmd;
    nulterminate(rcmd->cmd);
    *rcmd->efile = 0;
     a69:	c6 00 00             	movb   $0x0,(%eax)
    break;
     a6c:	89 d8                	mov    %ebx,%eax
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
    break;
  }
  return cmd;
}
     a6e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     a71:	c9                   	leave  
     a72:	c3                   	ret    
     a73:	90                   	nop
     a74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
    return 0;
     a78:	31 c0                	xor    %eax,%eax
     a7a:	eb 8d                	jmp    a09 <nulterminate+0x39>
     a7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000a80 <parsecmd>:
struct cmd *parseexec(char**, char*);
struct cmd *nulterminate(struct cmd*);

struct cmd*
parsecmd(char *s)
{
     a80:	55                   	push   %ebp
     a81:	89 e5                	mov    %esp,%ebp
     a83:	56                   	push   %esi
     a84:	53                   	push   %ebx
  char *es;
  struct cmd *cmd;

  es = s + strlen(s);
     a85:	8b 5d 08             	mov    0x8(%ebp),%ebx
     a88:	83 ec 0c             	sub    $0xc,%esp
     a8b:	53                   	push   %ebx
     a8c:	e8 df 00 00 00       	call   b70 <strlen>
  cmd = parseline(&s, es);
     a91:	59                   	pop    %ecx
parsecmd(char *s)
{
  char *es;
  struct cmd *cmd;

  es = s + strlen(s);
     a92:	01 c3                	add    %eax,%ebx
  cmd = parseline(&s, es);
     a94:	8d 45 08             	lea    0x8(%ebp),%eax
     a97:	5e                   	pop    %esi
     a98:	53                   	push   %ebx
     a99:	50                   	push   %eax
     a9a:	e8 01 fe ff ff       	call   8a0 <parseline>
     a9f:	89 c6                	mov    %eax,%esi
  peek(&s, es, "");
     aa1:	8d 45 08             	lea    0x8(%ebp),%eax
     aa4:	83 c4 0c             	add    $0xc,%esp
     aa7:	68 09 12 00 00       	push   $0x1209
     aac:	53                   	push   %ebx
     aad:	50                   	push   %eax
     aae:	e8 4d fb ff ff       	call   600 <peek>
  if(s != es){
     ab3:	8b 45 08             	mov    0x8(%ebp),%eax
     ab6:	83 c4 10             	add    $0x10,%esp
     ab9:	39 c3                	cmp    %eax,%ebx
     abb:	75 12                	jne    acf <parsecmd+0x4f>
    printf(2, "leftovers: %s\n", s);
    panic("syntax");
  }
  nulterminate(cmd);
     abd:	83 ec 0c             	sub    $0xc,%esp
     ac0:	56                   	push   %esi
     ac1:	e8 0a ff ff ff       	call   9d0 <nulterminate>
  return cmd;
}
     ac6:	8d 65 f8             	lea    -0x8(%ebp),%esp
     ac9:	89 f0                	mov    %esi,%eax
     acb:	5b                   	pop    %ebx
     acc:	5e                   	pop    %esi
     acd:	5d                   	pop    %ebp
     ace:	c3                   	ret    

  es = s + strlen(s);
  cmd = parseline(&s, es);
  peek(&s, es, "");
  if(s != es){
    printf(2, "leftovers: %s\n", s);
     acf:	52                   	push   %edx
     ad0:	50                   	push   %eax
     ad1:	68 82 12 00 00       	push   $0x1282
     ad6:	6a 02                	push   $0x2
     ad8:	e8 f3 03 00 00       	call   ed0 <printf>
    panic("syntax");
     add:	c7 04 24 46 12 00 00 	movl   $0x1246,(%esp)
     ae4:	e8 87 f6 ff ff       	call   170 <panic>
     ae9:	66 90                	xchg   %ax,%ax
     aeb:	66 90                	xchg   %ax,%ax
     aed:	66 90                	xchg   %ax,%ax
     aef:	90                   	nop

00000af0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
     af0:	55                   	push   %ebp
     af1:	89 e5                	mov    %esp,%ebp
     af3:	53                   	push   %ebx
     af4:	8b 45 08             	mov    0x8(%ebp),%eax
     af7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     afa:	89 c2                	mov    %eax,%edx
     afc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     b00:	83 c1 01             	add    $0x1,%ecx
     b03:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
     b07:	83 c2 01             	add    $0x1,%edx
     b0a:	84 db                	test   %bl,%bl
     b0c:	88 5a ff             	mov    %bl,-0x1(%edx)
     b0f:	75 ef                	jne    b00 <strcpy+0x10>
    ;
  return os;
}
     b11:	5b                   	pop    %ebx
     b12:	5d                   	pop    %ebp
     b13:	c3                   	ret    
     b14:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     b1a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000b20 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     b20:	55                   	push   %ebp
     b21:	89 e5                	mov    %esp,%ebp
     b23:	56                   	push   %esi
     b24:	53                   	push   %ebx
     b25:	8b 55 08             	mov    0x8(%ebp),%edx
     b28:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
     b2b:	0f b6 02             	movzbl (%edx),%eax
     b2e:	0f b6 19             	movzbl (%ecx),%ebx
     b31:	84 c0                	test   %al,%al
     b33:	75 1e                	jne    b53 <strcmp+0x33>
     b35:	eb 29                	jmp    b60 <strcmp+0x40>
     b37:	89 f6                	mov    %esi,%esi
     b39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    p++, q++;
     b40:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
     b43:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
     b46:	8d 71 01             	lea    0x1(%ecx),%esi
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
     b49:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
     b4d:	84 c0                	test   %al,%al
     b4f:	74 0f                	je     b60 <strcmp+0x40>
     b51:	89 f1                	mov    %esi,%ecx
     b53:	38 d8                	cmp    %bl,%al
     b55:	74 e9                	je     b40 <strcmp+0x20>
    p++, q++;
  return (uchar)*p - (uchar)*q;
     b57:	29 d8                	sub    %ebx,%eax
}
     b59:	5b                   	pop    %ebx
     b5a:	5e                   	pop    %esi
     b5b:	5d                   	pop    %ebp
     b5c:	c3                   	ret    
     b5d:	8d 76 00             	lea    0x0(%esi),%esi
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
     b60:	31 c0                	xor    %eax,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
     b62:	29 d8                	sub    %ebx,%eax
}
     b64:	5b                   	pop    %ebx
     b65:	5e                   	pop    %esi
     b66:	5d                   	pop    %ebp
     b67:	c3                   	ret    
     b68:	90                   	nop
     b69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000b70 <strlen>:

uint
strlen(const char *s)
{
     b70:	55                   	push   %ebp
     b71:	89 e5                	mov    %esp,%ebp
     b73:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
     b76:	80 39 00             	cmpb   $0x0,(%ecx)
     b79:	74 12                	je     b8d <strlen+0x1d>
     b7b:	31 d2                	xor    %edx,%edx
     b7d:	8d 76 00             	lea    0x0(%esi),%esi
     b80:	83 c2 01             	add    $0x1,%edx
     b83:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
     b87:	89 d0                	mov    %edx,%eax
     b89:	75 f5                	jne    b80 <strlen+0x10>
    ;
  return n;
}
     b8b:	5d                   	pop    %ebp
     b8c:	c3                   	ret    
uint
strlen(const char *s)
{
  int n;

  for(n = 0; s[n]; n++)
     b8d:	31 c0                	xor    %eax,%eax
    ;
  return n;
}
     b8f:	5d                   	pop    %ebp
     b90:	c3                   	ret    
     b91:	eb 0d                	jmp    ba0 <memset>
     b93:	90                   	nop
     b94:	90                   	nop
     b95:	90                   	nop
     b96:	90                   	nop
     b97:	90                   	nop
     b98:	90                   	nop
     b99:	90                   	nop
     b9a:	90                   	nop
     b9b:	90                   	nop
     b9c:	90                   	nop
     b9d:	90                   	nop
     b9e:	90                   	nop
     b9f:	90                   	nop

00000ba0 <memset>:

void*
memset(void *dst, int c, uint n)
{
     ba0:	55                   	push   %ebp
     ba1:	89 e5                	mov    %esp,%ebp
     ba3:	57                   	push   %edi
     ba4:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
     ba7:	8b 4d 10             	mov    0x10(%ebp),%ecx
     baa:	8b 45 0c             	mov    0xc(%ebp),%eax
     bad:	89 d7                	mov    %edx,%edi
     baf:	fc                   	cld    
     bb0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
     bb2:	89 d0                	mov    %edx,%eax
     bb4:	5f                   	pop    %edi
     bb5:	5d                   	pop    %ebp
     bb6:	c3                   	ret    
     bb7:	89 f6                	mov    %esi,%esi
     bb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000bc0 <strchr>:

char*
strchr(const char *s, char c)
{
     bc0:	55                   	push   %ebp
     bc1:	89 e5                	mov    %esp,%ebp
     bc3:	53                   	push   %ebx
     bc4:	8b 45 08             	mov    0x8(%ebp),%eax
     bc7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
     bca:	0f b6 10             	movzbl (%eax),%edx
     bcd:	84 d2                	test   %dl,%dl
     bcf:	74 1d                	je     bee <strchr+0x2e>
    if(*s == c)
     bd1:	38 d3                	cmp    %dl,%bl
     bd3:	89 d9                	mov    %ebx,%ecx
     bd5:	75 0d                	jne    be4 <strchr+0x24>
     bd7:	eb 17                	jmp    bf0 <strchr+0x30>
     bd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     be0:	38 ca                	cmp    %cl,%dl
     be2:	74 0c                	je     bf0 <strchr+0x30>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
     be4:	83 c0 01             	add    $0x1,%eax
     be7:	0f b6 10             	movzbl (%eax),%edx
     bea:	84 d2                	test   %dl,%dl
     bec:	75 f2                	jne    be0 <strchr+0x20>
    if(*s == c)
      return (char*)s;
  return 0;
     bee:	31 c0                	xor    %eax,%eax
}
     bf0:	5b                   	pop    %ebx
     bf1:	5d                   	pop    %ebp
     bf2:	c3                   	ret    
     bf3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     bf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000c00 <gets>:

char*
gets(char *buf, int max)
{
     c00:	55                   	push   %ebp
     c01:	89 e5                	mov    %esp,%ebp
     c03:	57                   	push   %edi
     c04:	56                   	push   %esi
     c05:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     c06:	31 f6                	xor    %esi,%esi
    cc = read(0, &c, 1);
     c08:	8d 7d e7             	lea    -0x19(%ebp),%edi
  return 0;
}

char*
gets(char *buf, int max)
{
     c0b:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     c0e:	eb 29                	jmp    c39 <gets+0x39>
    cc = read(0, &c, 1);
     c10:	83 ec 04             	sub    $0x4,%esp
     c13:	6a 01                	push   $0x1
     c15:	57                   	push   %edi
     c16:	6a 00                	push   $0x0
     c18:	e8 2d 01 00 00       	call   d4a <read>
    if(cc < 1)
     c1d:	83 c4 10             	add    $0x10,%esp
     c20:	85 c0                	test   %eax,%eax
     c22:	7e 1d                	jle    c41 <gets+0x41>
      break;
    buf[i++] = c;
     c24:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
     c28:	8b 55 08             	mov    0x8(%ebp),%edx
     c2b:	89 de                	mov    %ebx,%esi
    if(c == '\n' || c == '\r')
     c2d:	3c 0a                	cmp    $0xa,%al

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
     c2f:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
     c33:	74 1b                	je     c50 <gets+0x50>
     c35:	3c 0d                	cmp    $0xd,%al
     c37:	74 17                	je     c50 <gets+0x50>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     c39:	8d 5e 01             	lea    0x1(%esi),%ebx
     c3c:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
     c3f:	7c cf                	jl     c10 <gets+0x10>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
     c41:	8b 45 08             	mov    0x8(%ebp),%eax
     c44:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
     c48:	8d 65 f4             	lea    -0xc(%ebp),%esp
     c4b:	5b                   	pop    %ebx
     c4c:	5e                   	pop    %esi
     c4d:	5f                   	pop    %edi
     c4e:	5d                   	pop    %ebp
     c4f:	c3                   	ret    
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
     c50:	8b 45 08             	mov    0x8(%ebp),%eax
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     c53:	89 de                	mov    %ebx,%esi
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
     c55:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
     c59:	8d 65 f4             	lea    -0xc(%ebp),%esp
     c5c:	5b                   	pop    %ebx
     c5d:	5e                   	pop    %esi
     c5e:	5f                   	pop    %edi
     c5f:	5d                   	pop    %ebp
     c60:	c3                   	ret    
     c61:	eb 0d                	jmp    c70 <stat>
     c63:	90                   	nop
     c64:	90                   	nop
     c65:	90                   	nop
     c66:	90                   	nop
     c67:	90                   	nop
     c68:	90                   	nop
     c69:	90                   	nop
     c6a:	90                   	nop
     c6b:	90                   	nop
     c6c:	90                   	nop
     c6d:	90                   	nop
     c6e:	90                   	nop
     c6f:	90                   	nop

00000c70 <stat>:

int
stat(const char *n, struct stat *st)
{
     c70:	55                   	push   %ebp
     c71:	89 e5                	mov    %esp,%ebp
     c73:	56                   	push   %esi
     c74:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     c75:	83 ec 08             	sub    $0x8,%esp
     c78:	6a 00                	push   $0x0
     c7a:	ff 75 08             	pushl  0x8(%ebp)
     c7d:	e8 f0 00 00 00       	call   d72 <open>
  if(fd < 0)
     c82:	83 c4 10             	add    $0x10,%esp
     c85:	85 c0                	test   %eax,%eax
     c87:	78 27                	js     cb0 <stat+0x40>
    return -1;
  r = fstat(fd, st);
     c89:	83 ec 08             	sub    $0x8,%esp
     c8c:	ff 75 0c             	pushl  0xc(%ebp)
     c8f:	89 c3                	mov    %eax,%ebx
     c91:	50                   	push   %eax
     c92:	e8 f3 00 00 00       	call   d8a <fstat>
     c97:	89 c6                	mov    %eax,%esi
  close(fd);
     c99:	89 1c 24             	mov    %ebx,(%esp)
     c9c:	e8 b9 00 00 00       	call   d5a <close>
  return r;
     ca1:	83 c4 10             	add    $0x10,%esp
     ca4:	89 f0                	mov    %esi,%eax
}
     ca6:	8d 65 f8             	lea    -0x8(%ebp),%esp
     ca9:	5b                   	pop    %ebx
     caa:	5e                   	pop    %esi
     cab:	5d                   	pop    %ebp
     cac:	c3                   	ret    
     cad:	8d 76 00             	lea    0x0(%esi),%esi
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
     cb0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     cb5:	eb ef                	jmp    ca6 <stat+0x36>
     cb7:	89 f6                	mov    %esi,%esi
     cb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000cc0 <atoi>:
  return r;
}

int
atoi(const char *s)
{
     cc0:	55                   	push   %ebp
     cc1:	89 e5                	mov    %esp,%ebp
     cc3:	53                   	push   %ebx
     cc4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     cc7:	0f be 11             	movsbl (%ecx),%edx
     cca:	8d 42 d0             	lea    -0x30(%edx),%eax
     ccd:	3c 09                	cmp    $0x9,%al
     ccf:	b8 00 00 00 00       	mov    $0x0,%eax
     cd4:	77 1f                	ja     cf5 <atoi+0x35>
     cd6:	8d 76 00             	lea    0x0(%esi),%esi
     cd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
     ce0:	8d 04 80             	lea    (%eax,%eax,4),%eax
     ce3:	83 c1 01             	add    $0x1,%ecx
     ce6:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     cea:	0f be 11             	movsbl (%ecx),%edx
     ced:	8d 5a d0             	lea    -0x30(%edx),%ebx
     cf0:	80 fb 09             	cmp    $0x9,%bl
     cf3:	76 eb                	jbe    ce0 <atoi+0x20>
    n = n*10 + *s++ - '0';
  return n;
}
     cf5:	5b                   	pop    %ebx
     cf6:	5d                   	pop    %ebp
     cf7:	c3                   	ret    
     cf8:	90                   	nop
     cf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000d00 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     d00:	55                   	push   %ebp
     d01:	89 e5                	mov    %esp,%ebp
     d03:	56                   	push   %esi
     d04:	53                   	push   %ebx
     d05:	8b 5d 10             	mov    0x10(%ebp),%ebx
     d08:	8b 45 08             	mov    0x8(%ebp),%eax
     d0b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
     d0e:	85 db                	test   %ebx,%ebx
     d10:	7e 14                	jle    d26 <memmove+0x26>
     d12:	31 d2                	xor    %edx,%edx
     d14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
     d18:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
     d1c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
     d1f:	83 c2 01             	add    $0x1,%edx
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
     d22:	39 da                	cmp    %ebx,%edx
     d24:	75 f2                	jne    d18 <memmove+0x18>
    *dst++ = *src++;
  return vdst;
}
     d26:	5b                   	pop    %ebx
     d27:	5e                   	pop    %esi
     d28:	5d                   	pop    %ebp
     d29:	c3                   	ret    

00000d2a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
     d2a:	b8 01 00 00 00       	mov    $0x1,%eax
     d2f:	cd 40                	int    $0x40
     d31:	c3                   	ret    

00000d32 <exit>:
SYSCALL(exit)
     d32:	b8 02 00 00 00       	mov    $0x2,%eax
     d37:	cd 40                	int    $0x40
     d39:	c3                   	ret    

00000d3a <wait>:
SYSCALL(wait)
     d3a:	b8 03 00 00 00       	mov    $0x3,%eax
     d3f:	cd 40                	int    $0x40
     d41:	c3                   	ret    

00000d42 <pipe>:
SYSCALL(pipe)
     d42:	b8 04 00 00 00       	mov    $0x4,%eax
     d47:	cd 40                	int    $0x40
     d49:	c3                   	ret    

00000d4a <read>:
SYSCALL(read)
     d4a:	b8 05 00 00 00       	mov    $0x5,%eax
     d4f:	cd 40                	int    $0x40
     d51:	c3                   	ret    

00000d52 <write>:
SYSCALL(write)
     d52:	b8 10 00 00 00       	mov    $0x10,%eax
     d57:	cd 40                	int    $0x40
     d59:	c3                   	ret    

00000d5a <close>:
SYSCALL(close)
     d5a:	b8 15 00 00 00       	mov    $0x15,%eax
     d5f:	cd 40                	int    $0x40
     d61:	c3                   	ret    

00000d62 <kill>:
SYSCALL(kill)
     d62:	b8 06 00 00 00       	mov    $0x6,%eax
     d67:	cd 40                	int    $0x40
     d69:	c3                   	ret    

00000d6a <exec>:
SYSCALL(exec)
     d6a:	b8 07 00 00 00       	mov    $0x7,%eax
     d6f:	cd 40                	int    $0x40
     d71:	c3                   	ret    

00000d72 <open>:
SYSCALL(open)
     d72:	b8 0f 00 00 00       	mov    $0xf,%eax
     d77:	cd 40                	int    $0x40
     d79:	c3                   	ret    

00000d7a <mknod>:
SYSCALL(mknod)
     d7a:	b8 11 00 00 00       	mov    $0x11,%eax
     d7f:	cd 40                	int    $0x40
     d81:	c3                   	ret    

00000d82 <unlink>:
SYSCALL(unlink)
     d82:	b8 12 00 00 00       	mov    $0x12,%eax
     d87:	cd 40                	int    $0x40
     d89:	c3                   	ret    

00000d8a <fstat>:
SYSCALL(fstat)
     d8a:	b8 08 00 00 00       	mov    $0x8,%eax
     d8f:	cd 40                	int    $0x40
     d91:	c3                   	ret    

00000d92 <link>:
SYSCALL(link)
     d92:	b8 13 00 00 00       	mov    $0x13,%eax
     d97:	cd 40                	int    $0x40
     d99:	c3                   	ret    

00000d9a <mkdir>:
SYSCALL(mkdir)
     d9a:	b8 14 00 00 00       	mov    $0x14,%eax
     d9f:	cd 40                	int    $0x40
     da1:	c3                   	ret    

00000da2 <chdir>:
SYSCALL(chdir)
     da2:	b8 09 00 00 00       	mov    $0x9,%eax
     da7:	cd 40                	int    $0x40
     da9:	c3                   	ret    

00000daa <dup>:
SYSCALL(dup)
     daa:	b8 0a 00 00 00       	mov    $0xa,%eax
     daf:	cd 40                	int    $0x40
     db1:	c3                   	ret    

00000db2 <getpid>:
SYSCALL(getpid)
     db2:	b8 0b 00 00 00       	mov    $0xb,%eax
     db7:	cd 40                	int    $0x40
     db9:	c3                   	ret    

00000dba <get_parent_id>:
SYSCALL(get_parent_id)
     dba:	b8 16 00 00 00       	mov    $0x16,%eax
     dbf:	cd 40                	int    $0x40
     dc1:	c3                   	ret    

00000dc2 <getchildren>:
SYSCALL(getchildren)
     dc2:	b8 17 00 00 00       	mov    $0x17,%eax
     dc7:	cd 40                	int    $0x40
     dc9:	c3                   	ret    

00000dca <sbrk>:
SYSCALL(sbrk)
     dca:	b8 0c 00 00 00       	mov    $0xc,%eax
     dcf:	cd 40                	int    $0x40
     dd1:	c3                   	ret    

00000dd2 <sleep>:
SYSCALL(sleep)
     dd2:	b8 0d 00 00 00       	mov    $0xd,%eax
     dd7:	cd 40                	int    $0x40
     dd9:	c3                   	ret    

00000dda <uptime>:
SYSCALL(uptime)
     dda:	b8 0e 00 00 00       	mov    $0xe,%eax
     ddf:	cd 40                	int    $0x40
     de1:	c3                   	ret    

00000de2 <set>:
SYSCALL(set)
     de2:	b8 18 00 00 00       	mov    $0x18,%eax
     de7:	cd 40                	int    $0x40
     de9:	c3                   	ret    

00000dea <count>:
SYSCALL(count)
     dea:	b8 19 00 00 00       	mov    $0x19,%eax
     def:	cd 40                	int    $0x40
     df1:	c3                   	ret    

00000df2 <sleepp>:
SYSCALL(sleepp)
     df2:	b8 1a 00 00 00       	mov    $0x1a,%eax
     df7:	cd 40                	int    $0x40
     df9:	c3                   	ret    

00000dfa <cmos>:
SYSCALL(cmos)
     dfa:	b8 1b 00 00 00       	mov    $0x1b,%eax
     dff:	cd 40                	int    $0x40
     e01:	c3                   	ret    

00000e02 <chqueue>:
SYSCALL(chqueue)
     e02:	b8 1c 00 00 00       	mov    $0x1c,%eax
     e07:	cd 40                	int    $0x40
     e09:	c3                   	ret    

00000e0a <setLottery>:
SYSCALL(setLottery)
     e0a:	b8 1d 00 00 00       	mov    $0x1d,%eax
     e0f:	cd 40                	int    $0x40
     e11:	c3                   	ret    

00000e12 <chprSRPF>:
SYSCALL(chprSRPF)
     e12:	b8 1e 00 00 00       	mov    $0x1e,%eax
     e17:	cd 40                	int    $0x40
     e19:	c3                   	ret    

00000e1a <printinfo>:
SYSCALL(printinfo)
     e1a:	b8 1f 00 00 00       	mov    $0x1f,%eax
     e1f:	cd 40                	int    $0x40
     e21:	c3                   	ret    
     e22:	66 90                	xchg   %ax,%ax
     e24:	66 90                	xchg   %ax,%ax
     e26:	66 90                	xchg   %ax,%ax
     e28:	66 90                	xchg   %ax,%ax
     e2a:	66 90                	xchg   %ax,%ax
     e2c:	66 90                	xchg   %ax,%ax
     e2e:	66 90                	xchg   %ax,%ax

00000e30 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
     e30:	55                   	push   %ebp
     e31:	89 e5                	mov    %esp,%ebp
     e33:	57                   	push   %edi
     e34:	56                   	push   %esi
     e35:	53                   	push   %ebx
     e36:	89 c6                	mov    %eax,%esi
     e38:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     e3b:	8b 5d 08             	mov    0x8(%ebp),%ebx
     e3e:	85 db                	test   %ebx,%ebx
     e40:	74 7e                	je     ec0 <printint+0x90>
     e42:	89 d0                	mov    %edx,%eax
     e44:	c1 e8 1f             	shr    $0x1f,%eax
     e47:	84 c0                	test   %al,%al
     e49:	74 75                	je     ec0 <printint+0x90>
    neg = 1;
    x = -xx;
     e4b:	89 d0                	mov    %edx,%eax
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
     e4d:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
    x = -xx;
     e54:	f7 d8                	neg    %eax
     e56:	89 75 c0             	mov    %esi,-0x40(%ebp)
  } else {
    x = xx;
  }

  i = 0;
     e59:	31 ff                	xor    %edi,%edi
     e5b:	8d 5d d7             	lea    -0x29(%ebp),%ebx
     e5e:	89 ce                	mov    %ecx,%esi
     e60:	eb 08                	jmp    e6a <printint+0x3a>
     e62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
     e68:	89 cf                	mov    %ecx,%edi
     e6a:	31 d2                	xor    %edx,%edx
     e6c:	8d 4f 01             	lea    0x1(%edi),%ecx
     e6f:	f7 f6                	div    %esi
     e71:	0f b6 92 e0 12 00 00 	movzbl 0x12e0(%edx),%edx
  }while((x /= base) != 0);
     e78:	85 c0                	test   %eax,%eax
    x = xx;
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
     e7a:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
  }while((x /= base) != 0);
     e7d:	75 e9                	jne    e68 <printint+0x38>
  if(neg)
     e7f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
     e82:	8b 75 c0             	mov    -0x40(%ebp),%esi
     e85:	85 c0                	test   %eax,%eax
     e87:	74 08                	je     e91 <printint+0x61>
    buf[i++] = '-';
     e89:	c6 44 0d d8 2d       	movb   $0x2d,-0x28(%ebp,%ecx,1)
     e8e:	8d 4f 02             	lea    0x2(%edi),%ecx
     e91:	8d 7c 0d d7          	lea    -0x29(%ebp,%ecx,1),%edi
     e95:	8d 76 00             	lea    0x0(%esi),%esi
     e98:	0f b6 07             	movzbl (%edi),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
     e9b:	83 ec 04             	sub    $0x4,%esp
     e9e:	83 ef 01             	sub    $0x1,%edi
     ea1:	6a 01                	push   $0x1
     ea3:	53                   	push   %ebx
     ea4:	56                   	push   %esi
     ea5:	88 45 d7             	mov    %al,-0x29(%ebp)
     ea8:	e8 a5 fe ff ff       	call   d52 <write>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
     ead:	83 c4 10             	add    $0x10,%esp
     eb0:	39 df                	cmp    %ebx,%edi
     eb2:	75 e4                	jne    e98 <printint+0x68>
    putc(fd, buf[i]);
}
     eb4:	8d 65 f4             	lea    -0xc(%ebp),%esp
     eb7:	5b                   	pop    %ebx
     eb8:	5e                   	pop    %esi
     eb9:	5f                   	pop    %edi
     eba:	5d                   	pop    %ebp
     ebb:	c3                   	ret    
     ebc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
  } else {
    x = xx;
     ec0:	89 d0                	mov    %edx,%eax
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
     ec2:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
     ec9:	eb 8b                	jmp    e56 <printint+0x26>
     ecb:	90                   	nop
     ecc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000ed0 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
     ed0:	55                   	push   %ebp
     ed1:	89 e5                	mov    %esp,%ebp
     ed3:	57                   	push   %edi
     ed4:	56                   	push   %esi
     ed5:	53                   	push   %ebx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
     ed6:	8d 45 10             	lea    0x10(%ebp),%eax
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
     ed9:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
     edc:	8b 75 0c             	mov    0xc(%ebp),%esi
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
     edf:	8b 7d 08             	mov    0x8(%ebp),%edi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
     ee2:	89 45 d0             	mov    %eax,-0x30(%ebp)
     ee5:	0f b6 1e             	movzbl (%esi),%ebx
     ee8:	83 c6 01             	add    $0x1,%esi
     eeb:	84 db                	test   %bl,%bl
     eed:	0f 84 b0 00 00 00    	je     fa3 <printf+0xd3>
     ef3:	31 d2                	xor    %edx,%edx
     ef5:	eb 39                	jmp    f30 <printf+0x60>
     ef7:	89 f6                	mov    %esi,%esi
     ef9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
     f00:	83 f8 25             	cmp    $0x25,%eax
     f03:	89 55 d4             	mov    %edx,-0x2c(%ebp)
        state = '%';
     f06:	ba 25 00 00 00       	mov    $0x25,%edx
  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
     f0b:	74 18                	je     f25 <printf+0x55>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
     f0d:	8d 45 e2             	lea    -0x1e(%ebp),%eax
     f10:	83 ec 04             	sub    $0x4,%esp
     f13:	88 5d e2             	mov    %bl,-0x1e(%ebp)
     f16:	6a 01                	push   $0x1
     f18:	50                   	push   %eax
     f19:	57                   	push   %edi
     f1a:	e8 33 fe ff ff       	call   d52 <write>
     f1f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
     f22:	83 c4 10             	add    $0x10,%esp
     f25:	83 c6 01             	add    $0x1,%esi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
     f28:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
     f2c:	84 db                	test   %bl,%bl
     f2e:	74 73                	je     fa3 <printf+0xd3>
    c = fmt[i] & 0xff;
    if(state == 0){
     f30:	85 d2                	test   %edx,%edx
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
     f32:	0f be cb             	movsbl %bl,%ecx
     f35:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
     f38:	74 c6                	je     f00 <printf+0x30>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
     f3a:	83 fa 25             	cmp    $0x25,%edx
     f3d:	75 e6                	jne    f25 <printf+0x55>
      if(c == 'd'){
     f3f:	83 f8 64             	cmp    $0x64,%eax
     f42:	0f 84 f8 00 00 00    	je     1040 <printf+0x170>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
     f48:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
     f4e:	83 f9 70             	cmp    $0x70,%ecx
     f51:	74 5d                	je     fb0 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
     f53:	83 f8 73             	cmp    $0x73,%eax
     f56:	0f 84 84 00 00 00    	je     fe0 <printf+0x110>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
     f5c:	83 f8 63             	cmp    $0x63,%eax
     f5f:	0f 84 ea 00 00 00    	je     104f <printf+0x17f>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
     f65:	83 f8 25             	cmp    $0x25,%eax
     f68:	0f 84 c2 00 00 00    	je     1030 <printf+0x160>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
     f6e:	8d 45 e7             	lea    -0x19(%ebp),%eax
     f71:	83 ec 04             	sub    $0x4,%esp
     f74:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
     f78:	6a 01                	push   $0x1
     f7a:	50                   	push   %eax
     f7b:	57                   	push   %edi
     f7c:	e8 d1 fd ff ff       	call   d52 <write>
     f81:	83 c4 0c             	add    $0xc,%esp
     f84:	8d 45 e6             	lea    -0x1a(%ebp),%eax
     f87:	88 5d e6             	mov    %bl,-0x1a(%ebp)
     f8a:	6a 01                	push   $0x1
     f8c:	50                   	push   %eax
     f8d:	57                   	push   %edi
     f8e:	83 c6 01             	add    $0x1,%esi
     f91:	e8 bc fd ff ff       	call   d52 <write>
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
     f96:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
     f9a:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
     f9d:	31 d2                	xor    %edx,%edx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
     f9f:	84 db                	test   %bl,%bl
     fa1:	75 8d                	jne    f30 <printf+0x60>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
     fa3:	8d 65 f4             	lea    -0xc(%ebp),%esp
     fa6:	5b                   	pop    %ebx
     fa7:	5e                   	pop    %esi
     fa8:	5f                   	pop    %edi
     fa9:	5d                   	pop    %ebp
     faa:	c3                   	ret    
     fab:	90                   	nop
     fac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
     fb0:	83 ec 0c             	sub    $0xc,%esp
     fb3:	b9 10 00 00 00       	mov    $0x10,%ecx
     fb8:	6a 00                	push   $0x0
     fba:	8b 5d d0             	mov    -0x30(%ebp),%ebx
     fbd:	89 f8                	mov    %edi,%eax
     fbf:	8b 13                	mov    (%ebx),%edx
     fc1:	e8 6a fe ff ff       	call   e30 <printint>
        ap++;
     fc6:	89 d8                	mov    %ebx,%eax
     fc8:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
     fcb:	31 d2                	xor    %edx,%edx
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
        ap++;
     fcd:	83 c0 04             	add    $0x4,%eax
     fd0:	89 45 d0             	mov    %eax,-0x30(%ebp)
     fd3:	e9 4d ff ff ff       	jmp    f25 <printf+0x55>
     fd8:	90                   	nop
     fd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      } else if(c == 's'){
        s = (char*)*ap;
     fe0:	8b 45 d0             	mov    -0x30(%ebp),%eax
     fe3:	8b 18                	mov    (%eax),%ebx
        ap++;
     fe5:	83 c0 04             	add    $0x4,%eax
     fe8:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
          s = "(null)";
     feb:	b8 d8 12 00 00       	mov    $0x12d8,%eax
     ff0:	85 db                	test   %ebx,%ebx
     ff2:	0f 44 d8             	cmove  %eax,%ebx
        while(*s != 0){
     ff5:	0f b6 03             	movzbl (%ebx),%eax
     ff8:	84 c0                	test   %al,%al
     ffa:	74 23                	je     101f <printf+0x14f>
     ffc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    1000:	88 45 e3             	mov    %al,-0x1d(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    1003:	8d 45 e3             	lea    -0x1d(%ebp),%eax
    1006:	83 ec 04             	sub    $0x4,%esp
    1009:	6a 01                	push   $0x1
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
    100b:	83 c3 01             	add    $0x1,%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    100e:	50                   	push   %eax
    100f:	57                   	push   %edi
    1010:	e8 3d fd ff ff       	call   d52 <write>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    1015:	0f b6 03             	movzbl (%ebx),%eax
    1018:	83 c4 10             	add    $0x10,%esp
    101b:	84 c0                	test   %al,%al
    101d:	75 e1                	jne    1000 <printf+0x130>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    101f:	31 d2                	xor    %edx,%edx
    1021:	e9 ff fe ff ff       	jmp    f25 <printf+0x55>
    1026:	8d 76 00             	lea    0x0(%esi),%esi
    1029:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    1030:	83 ec 04             	sub    $0x4,%esp
    1033:	88 5d e5             	mov    %bl,-0x1b(%ebp)
    1036:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1039:	6a 01                	push   $0x1
    103b:	e9 4c ff ff ff       	jmp    f8c <printf+0xbc>
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
    1040:	83 ec 0c             	sub    $0xc,%esp
    1043:	b9 0a 00 00 00       	mov    $0xa,%ecx
    1048:	6a 01                	push   $0x1
    104a:	e9 6b ff ff ff       	jmp    fba <printf+0xea>
    104f:	8b 5d d0             	mov    -0x30(%ebp),%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    1052:	83 ec 04             	sub    $0x4,%esp
    1055:	8b 03                	mov    (%ebx),%eax
    1057:	6a 01                	push   $0x1
    1059:	88 45 e4             	mov    %al,-0x1c(%ebp)
    105c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
    105f:	50                   	push   %eax
    1060:	57                   	push   %edi
    1061:	e8 ec fc ff ff       	call   d52 <write>
    1066:	e9 5b ff ff ff       	jmp    fc6 <printf+0xf6>
    106b:	66 90                	xchg   %ax,%ax
    106d:	66 90                	xchg   %ax,%ax
    106f:	90                   	nop

00001070 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1070:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1071:	a1 04 19 00 00       	mov    0x1904,%eax
static Header base;
static Header *freep;

void
free(void *ap)
{
    1076:	89 e5                	mov    %esp,%ebp
    1078:	57                   	push   %edi
    1079:	56                   	push   %esi
    107a:	53                   	push   %ebx
    107b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    107e:	8b 10                	mov    (%eax),%edx
void
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1080:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1083:	39 c8                	cmp    %ecx,%eax
    1085:	73 19                	jae    10a0 <free+0x30>
    1087:	89 f6                	mov    %esi,%esi
    1089:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    1090:	39 d1                	cmp    %edx,%ecx
    1092:	72 1c                	jb     10b0 <free+0x40>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1094:	39 d0                	cmp    %edx,%eax
    1096:	73 18                	jae    10b0 <free+0x40>
static Header base;
static Header *freep;

void
free(void *ap)
{
    1098:	89 d0                	mov    %edx,%eax
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    109a:	39 c8                	cmp    %ecx,%eax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    109c:	8b 10                	mov    (%eax),%edx
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    109e:	72 f0                	jb     1090 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    10a0:	39 d0                	cmp    %edx,%eax
    10a2:	72 f4                	jb     1098 <free+0x28>
    10a4:	39 d1                	cmp    %edx,%ecx
    10a6:	73 f0                	jae    1098 <free+0x28>
    10a8:	90                   	nop
    10a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      break;
  if(bp + bp->s.size == p->s.ptr){
    10b0:	8b 73 fc             	mov    -0x4(%ebx),%esi
    10b3:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
    10b6:	39 d7                	cmp    %edx,%edi
    10b8:	74 19                	je     10d3 <free+0x63>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
    10ba:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
    10bd:	8b 50 04             	mov    0x4(%eax),%edx
    10c0:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    10c3:	39 f1                	cmp    %esi,%ecx
    10c5:	74 23                	je     10ea <free+0x7a>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
    10c7:	89 08                	mov    %ecx,(%eax)
  freep = p;
    10c9:	a3 04 19 00 00       	mov    %eax,0x1904
}
    10ce:	5b                   	pop    %ebx
    10cf:	5e                   	pop    %esi
    10d0:	5f                   	pop    %edi
    10d1:	5d                   	pop    %ebp
    10d2:	c3                   	ret    
  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    10d3:	03 72 04             	add    0x4(%edx),%esi
    10d6:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
    10d9:	8b 10                	mov    (%eax),%edx
    10db:	8b 12                	mov    (%edx),%edx
    10dd:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    10e0:	8b 50 04             	mov    0x4(%eax),%edx
    10e3:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    10e6:	39 f1                	cmp    %esi,%ecx
    10e8:	75 dd                	jne    10c7 <free+0x57>
    p->s.size += bp->s.size;
    10ea:	03 53 fc             	add    -0x4(%ebx),%edx
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
    10ed:	a3 04 19 00 00       	mov    %eax,0x1904
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    10f2:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    10f5:	8b 53 f8             	mov    -0x8(%ebx),%edx
    10f8:	89 10                	mov    %edx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
}
    10fa:	5b                   	pop    %ebx
    10fb:	5e                   	pop    %esi
    10fc:	5f                   	pop    %edi
    10fd:	5d                   	pop    %ebp
    10fe:	c3                   	ret    
    10ff:	90                   	nop

00001100 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    1100:	55                   	push   %ebp
    1101:	89 e5                	mov    %esp,%ebp
    1103:	57                   	push   %edi
    1104:	56                   	push   %esi
    1105:	53                   	push   %ebx
    1106:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1109:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
    110c:	8b 15 04 19 00 00    	mov    0x1904,%edx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1112:	8d 78 07             	lea    0x7(%eax),%edi
    1115:	c1 ef 03             	shr    $0x3,%edi
    1118:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
    111b:	85 d2                	test   %edx,%edx
    111d:	0f 84 a3 00 00 00    	je     11c6 <malloc+0xc6>
    1123:	8b 02                	mov    (%edx),%eax
    1125:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
    1128:	39 cf                	cmp    %ecx,%edi
    112a:	76 74                	jbe    11a0 <malloc+0xa0>
    112c:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
    1132:	be 00 10 00 00       	mov    $0x1000,%esi
    1137:	8d 1c fd 00 00 00 00 	lea    0x0(,%edi,8),%ebx
    113e:	0f 43 f7             	cmovae %edi,%esi
    1141:	ba 00 80 00 00       	mov    $0x8000,%edx
    1146:	81 ff ff 0f 00 00    	cmp    $0xfff,%edi
    114c:	0f 46 da             	cmovbe %edx,%ebx
    114f:	eb 10                	jmp    1161 <malloc+0x61>
    1151:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1158:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
    115a:	8b 48 04             	mov    0x4(%eax),%ecx
    115d:	39 cf                	cmp    %ecx,%edi
    115f:	76 3f                	jbe    11a0 <malloc+0xa0>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    1161:	39 05 04 19 00 00    	cmp    %eax,0x1904
    1167:	89 c2                	mov    %eax,%edx
    1169:	75 ed                	jne    1158 <malloc+0x58>
  char *p;
  Header *hp;

  if(nu < 4096)
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
    116b:	83 ec 0c             	sub    $0xc,%esp
    116e:	53                   	push   %ebx
    116f:	e8 56 fc ff ff       	call   dca <sbrk>
  if(p == (char*)-1)
    1174:	83 c4 10             	add    $0x10,%esp
    1177:	83 f8 ff             	cmp    $0xffffffff,%eax
    117a:	74 1c                	je     1198 <malloc+0x98>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
    117c:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
    117f:	83 ec 0c             	sub    $0xc,%esp
    1182:	83 c0 08             	add    $0x8,%eax
    1185:	50                   	push   %eax
    1186:	e8 e5 fe ff ff       	call   1070 <free>
  return freep;
    118b:	8b 15 04 19 00 00    	mov    0x1904,%edx
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
    1191:	83 c4 10             	add    $0x10,%esp
    1194:	85 d2                	test   %edx,%edx
    1196:	75 c0                	jne    1158 <malloc+0x58>
        return 0;
    1198:	31 c0                	xor    %eax,%eax
    119a:	eb 1c                	jmp    11b8 <malloc+0xb8>
    119c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
    11a0:	39 cf                	cmp    %ecx,%edi
    11a2:	74 1c                	je     11c0 <malloc+0xc0>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
    11a4:	29 f9                	sub    %edi,%ecx
    11a6:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
    11a9:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
    11ac:	89 78 04             	mov    %edi,0x4(%eax)
      }
      freep = prevp;
    11af:	89 15 04 19 00 00    	mov    %edx,0x1904
      return (void*)(p + 1);
    11b5:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    11b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
    11bb:	5b                   	pop    %ebx
    11bc:	5e                   	pop    %esi
    11bd:	5f                   	pop    %edi
    11be:	5d                   	pop    %ebp
    11bf:	c3                   	ret    
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
    11c0:	8b 08                	mov    (%eax),%ecx
    11c2:	89 0a                	mov    %ecx,(%edx)
    11c4:	eb e9                	jmp    11af <malloc+0xaf>
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    11c6:	c7 05 04 19 00 00 08 	movl   $0x1908,0x1904
    11cd:	19 00 00 
    11d0:	c7 05 08 19 00 00 08 	movl   $0x1908,0x1908
    11d7:	19 00 00 
    base.s.size = 0;
    11da:	b8 08 19 00 00       	mov    $0x1908,%eax
    11df:	c7 05 0c 19 00 00 00 	movl   $0x0,0x190c
    11e6:	00 00 00 
    11e9:	e9 3e ff ff ff       	jmp    112c <malloc+0x2c>
