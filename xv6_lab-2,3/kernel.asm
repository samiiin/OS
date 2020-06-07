
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc c0 c5 10 80       	mov    $0x8010c5c0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 b0 30 10 80       	mov    $0x801030b0,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb f4 c5 10 80       	mov    $0x8010c5f4,%ebx
  struct buf head;
} bcache;

void
binit(void)
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010004c:	68 60 80 10 80       	push   $0x80108060
80100051:	68 c0 c5 10 80       	push   $0x8010c5c0
80100056:	e8 75 4f 00 00       	call   80104fd0 <initlock>

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010005b:	c7 05 0c 0d 11 80 bc 	movl   $0x80110cbc,0x80110d0c
80100062:	0c 11 80 
  bcache.head.next = &bcache.head;
80100065:	c7 05 10 0d 11 80 bc 	movl   $0x80110cbc,0x80110d10
8010006c:	0c 11 80 
8010006f:	83 c4 10             	add    $0x10,%esp
80100072:	ba bc 0c 11 80       	mov    $0x80110cbc,%edx
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 c3                	mov    %eax,%ebx
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100082:	8d 43 0c             	lea    0xc(%ebx),%eax
80100085:	83 ec 08             	sub    $0x8,%esp
//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    b->next = bcache.head.next;
80100088:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008b:	c7 43 50 bc 0c 11 80 	movl   $0x80110cbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 67 80 10 80       	push   $0x80108067
80100097:	50                   	push   %eax
80100098:	e8 03 4e 00 00       	call   80104ea0 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 10 0d 11 80       	mov    0x80110d10,%eax

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	83 c4 10             	add    $0x10,%esp
801000a5:	89 da                	mov    %ebx,%edx
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
801000a7:	89 58 50             	mov    %ebx,0x50(%eax)

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
    bcache.head.next = b;
801000b0:	89 1d 10 0d 11 80    	mov    %ebx,0x80110d10

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	3d bc 0c 11 80       	cmp    $0x80110cbc,%eax
801000bb:	75 c3                	jne    80100080 <binit+0x40>
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
}
801000bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c0:	c9                   	leave  
801000c1:	c3                   	ret    
801000c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
static struct buf*
bget(uint dev, uint blockno)
{
  struct buf *b;

  acquire(&bcache.lock);
801000df:	68 c0 c5 10 80       	push   $0x8010c5c0
801000e4:	e8 47 50 00 00       	call   80105130 <acquire>

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 10 0d 11 80    	mov    0x80110d10,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	90                   	nop
8010011c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }

  // Not cached; recycle an unused buffer.
  // Even if refcnt==0, B_DIRTY indicates a buffer is in use
  // because log.c has modified it but not yet committed it.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 0c 0d 11 80    	mov    0x80110d0c,%ebx
80100126:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 60                	jmp    80100190 <bread+0xc0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
80100139:	74 55                	je     80100190 <bread+0xc0>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 c0 c5 10 80       	push   $0x8010c5c0
80100162:	e8 79 50 00 00       	call   801051e0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 6e 4d 00 00       	call   80104ee0 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
bread(uint dev, uint blockno)
{
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	75 0c                	jne    80100186 <bread+0xb6>
    iderw(b);
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	53                   	push   %ebx
8010017e:	e8 bd 21 00 00       	call   80102340 <iderw>
80100183:	83 c4 10             	add    $0x10,%esp
  }
  return b;
}
80100186:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100189:	89 d8                	mov    %ebx,%eax
8010018b:	5b                   	pop    %ebx
8010018c:	5e                   	pop    %esi
8010018d:	5f                   	pop    %edi
8010018e:	5d                   	pop    %ebp
8010018f:	c3                   	ret    
      release(&bcache.lock);
      acquiresleep(&b->lock);
      return b;
    }
  }
  panic("bget: no buffers");
80100190:	83 ec 0c             	sub    $0xc,%esp
80100193:	68 6e 80 10 80       	push   $0x8010806e
80100198:	e8 d3 01 00 00       	call   80100370 <panic>
8010019d:	8d 76 00             	lea    0x0(%esi),%esi

801001a0 <bwrite>:
}

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001a0:	55                   	push   %ebp
801001a1:	89 e5                	mov    %esp,%ebp
801001a3:	53                   	push   %ebx
801001a4:	83 ec 10             	sub    $0x10,%esp
801001a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801001ad:	50                   	push   %eax
801001ae:	e8 cd 4d 00 00       	call   80104f80 <holdingsleep>
801001b3:	83 c4 10             	add    $0x10,%esp
801001b6:	85 c0                	test   %eax,%eax
801001b8:	74 0f                	je     801001c9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ba:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001bd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001c3:	c9                   	leave  
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
  b->flags |= B_DIRTY;
  iderw(b);
801001c4:	e9 77 21 00 00       	jmp    80102340 <iderw>
// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 7f 80 10 80       	push   $0x8010807f
801001d1:	e8 9a 01 00 00       	call   80100370 <panic>
801001d6:	8d 76 00             	lea    0x0(%esi),%esi
801001d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801001e0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001e0:	55                   	push   %ebp
801001e1:	89 e5                	mov    %esp,%ebp
801001e3:	56                   	push   %esi
801001e4:	53                   	push   %ebx
801001e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001e8:	83 ec 0c             	sub    $0xc,%esp
801001eb:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ee:	56                   	push   %esi
801001ef:	e8 8c 4d 00 00       	call   80104f80 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 3c 4d 00 00       	call   80104f40 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 c0 c5 10 80 	movl   $0x8010c5c0,(%esp)
8010020b:	e8 20 4f 00 00       	call   80105130 <acquire>
  b->refcnt--;
80100210:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100213:	83 c4 10             	add    $0x10,%esp
    panic("brelse");

  releasesleep(&b->lock);

  acquire(&bcache.lock);
  b->refcnt--;
80100216:	83 e8 01             	sub    $0x1,%eax
  if (b->refcnt == 0) {
80100219:	85 c0                	test   %eax,%eax
    panic("brelse");

  releasesleep(&b->lock);

  acquire(&bcache.lock);
  b->refcnt--;
8010021b:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010021e:	75 2f                	jne    8010024f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100220:	8b 43 54             	mov    0x54(%ebx),%eax
80100223:	8b 53 50             	mov    0x50(%ebx),%edx
80100226:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100229:	8b 43 50             	mov    0x50(%ebx),%eax
8010022c:	8b 53 54             	mov    0x54(%ebx),%edx
8010022f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100232:	a1 10 0d 11 80       	mov    0x80110d10,%eax
    b->prev = &bcache.head;
80100237:	c7 43 50 bc 0c 11 80 	movl   $0x80110cbc,0x50(%ebx)
  b->refcnt--;
  if (b->refcnt == 0) {
    // no one is waiting for it.
    b->next->prev = b->prev;
    b->prev->next = b->next;
    b->next = bcache.head.next;
8010023e:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    bcache.head.next->prev = b;
80100241:	a1 10 0d 11 80       	mov    0x80110d10,%eax
80100246:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100249:	89 1d 10 0d 11 80    	mov    %ebx,0x80110d10
  }
  
  release(&bcache.lock);
8010024f:	c7 45 08 c0 c5 10 80 	movl   $0x8010c5c0,0x8(%ebp)
}
80100256:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100259:	5b                   	pop    %ebx
8010025a:	5e                   	pop    %esi
8010025b:	5d                   	pop    %ebp
    b->prev = &bcache.head;
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
  
  release(&bcache.lock);
8010025c:	e9 7f 4f 00 00       	jmp    801051e0 <release>
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 86 80 10 80       	push   $0x80108086
80100269:	e8 02 01 00 00       	call   80100370 <panic>
8010026e:	66 90                	xchg   %ax,%ax

80100270 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100270:	55                   	push   %ebp
80100271:	89 e5                	mov    %esp,%ebp
80100273:	57                   	push   %edi
80100274:	56                   	push   %esi
80100275:	53                   	push   %ebx
80100276:	83 ec 28             	sub    $0x28,%esp
80100279:	8b 7d 08             	mov    0x8(%ebp),%edi
8010027c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010027f:	57                   	push   %edi
80100280:	e8 1b 17 00 00       	call   801019a0 <iunlock>
  target = n;
  acquire(&cons.lock);
80100285:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010028c:	e8 9f 4e 00 00       	call   80105130 <acquire>
  while(n > 0){
80100291:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100294:	83 c4 10             	add    $0x10,%esp
80100297:	31 c0                	xor    %eax,%eax
80100299:	85 db                	test   %ebx,%ebx
8010029b:	0f 8e 9a 00 00 00    	jle    8010033b <consoleread+0xcb>
    while(input.r == input.w){
801002a1:	a1 20 10 11 80       	mov    0x80111020,%eax
801002a6:	3b 05 24 10 11 80    	cmp    0x80111024,%eax
801002ac:	74 24                	je     801002d2 <consoleread+0x62>
801002ae:	eb 58                	jmp    80100308 <consoleread+0x98>
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002b0:	83 ec 08             	sub    $0x8,%esp
801002b3:	68 20 b5 10 80       	push   $0x8010b520
801002b8:	68 20 10 11 80       	push   $0x80111020
801002bd:	e8 0e 41 00 00       	call   801043d0 <sleep>

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
801002c2:	a1 20 10 11 80       	mov    0x80111020,%eax
801002c7:	83 c4 10             	add    $0x10,%esp
801002ca:	3b 05 24 10 11 80    	cmp    0x80111024,%eax
801002d0:	75 36                	jne    80100308 <consoleread+0x98>
      if(myproc()->killed){
801002d2:	e8 59 37 00 00       	call   80103a30 <myproc>
801002d7:	8b 40 24             	mov    0x24(%eax),%eax
801002da:	85 c0                	test   %eax,%eax
801002dc:	74 d2                	je     801002b0 <consoleread+0x40>
        release(&cons.lock);
801002de:	83 ec 0c             	sub    $0xc,%esp
801002e1:	68 20 b5 10 80       	push   $0x8010b520
801002e6:	e8 f5 4e 00 00       	call   801051e0 <release>
        ilock(ip);
801002eb:	89 3c 24             	mov    %edi,(%esp)
801002ee:	e8 cd 15 00 00       	call   801018c0 <ilock>
        return -1;
801002f3:	83 c4 10             	add    $0x10,%esp
801002f6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
801002fb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801002fe:	5b                   	pop    %ebx
801002ff:	5e                   	pop    %esi
80100300:	5f                   	pop    %edi
80100301:	5d                   	pop    %ebp
80100302:	c3                   	ret    
80100303:	90                   	nop
80100304:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
80100308:	8d 50 01             	lea    0x1(%eax),%edx
8010030b:	89 15 20 10 11 80    	mov    %edx,0x80111020
80100311:	89 c2                	mov    %eax,%edx
80100313:	83 e2 7f             	and    $0x7f,%edx
80100316:	0f be 92 a0 0f 11 80 	movsbl -0x7feef060(%edx),%edx
    if(c == C('D')){  // EOF
8010031d:	83 fa 04             	cmp    $0x4,%edx
80100320:	74 39                	je     8010035b <consoleread+0xeb>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
80100322:	83 c6 01             	add    $0x1,%esi
    --n;
80100325:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
80100328:	83 fa 0a             	cmp    $0xa,%edx
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
8010032b:	88 56 ff             	mov    %dl,-0x1(%esi)
    --n;
    if(c == '\n')
8010032e:	74 35                	je     80100365 <consoleread+0xf5>
  int c;

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
80100330:	85 db                	test   %ebx,%ebx
80100332:	0f 85 69 ff ff ff    	jne    801002a1 <consoleread+0x31>
80100338:	8b 45 10             	mov    0x10(%ebp),%eax
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
  }
  release(&cons.lock);
8010033b:	83 ec 0c             	sub    $0xc,%esp
8010033e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100341:	68 20 b5 10 80       	push   $0x8010b520
80100346:	e8 95 4e 00 00       	call   801051e0 <release>
  ilock(ip);
8010034b:	89 3c 24             	mov    %edi,(%esp)
8010034e:	e8 6d 15 00 00       	call   801018c0 <ilock>

  return target - n;
80100353:	83 c4 10             	add    $0x10,%esp
80100356:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100359:	eb a0                	jmp    801002fb <consoleread+0x8b>
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
    if(c == C('D')){  // EOF
      if(n < target){
8010035b:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010035e:	76 05                	jbe    80100365 <consoleread+0xf5>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
80100360:	a3 20 10 11 80       	mov    %eax,0x80111020
80100365:	8b 45 10             	mov    0x10(%ebp),%eax
80100368:	29 d8                	sub    %ebx,%eax
8010036a:	eb cf                	jmp    8010033b <consoleread+0xcb>
8010036c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100370 <panic>:
    release(&cons.lock);
}

void
panic(char *s)
{
80100370:	55                   	push   %ebp
80100371:	89 e5                	mov    %esp,%ebp
80100373:	56                   	push   %esi
80100374:	53                   	push   %ebx
80100375:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100378:	fa                   	cli    
  int i;
  uint pcs[10];

  cli();
  cons.locking = 0;
80100379:	c7 05 54 b5 10 80 00 	movl   $0x0,0x8010b554
80100380:	00 00 00 
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
80100383:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100386:	8d 75 f8             	lea    -0x8(%ebp),%esi
  uint pcs[10];

  cli();
  cons.locking = 0;
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
80100389:	e8 b2 25 00 00       	call   80102940 <lapicid>
8010038e:	83 ec 08             	sub    $0x8,%esp
80100391:	50                   	push   %eax
80100392:	68 8d 80 10 80       	push   $0x8010808d
80100397:	e8 c4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
8010039c:	58                   	pop    %eax
8010039d:	ff 75 08             	pushl  0x8(%ebp)
801003a0:	e8 bb 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003a5:	c7 04 24 90 86 10 80 	movl   $0x80108690,(%esp)
801003ac:	e8 af 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003b1:	5a                   	pop    %edx
801003b2:	8d 45 08             	lea    0x8(%ebp),%eax
801003b5:	59                   	pop    %ecx
801003b6:	53                   	push   %ebx
801003b7:	50                   	push   %eax
801003b8:	e8 33 4c 00 00       	call   80104ff0 <getcallerpcs>
801003bd:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
    cprintf(" %p", pcs[i]);
801003c0:	83 ec 08             	sub    $0x8,%esp
801003c3:	ff 33                	pushl  (%ebx)
801003c5:	83 c3 04             	add    $0x4,%ebx
801003c8:	68 a1 80 10 80       	push   $0x801080a1
801003cd:	e8 8e 02 00 00       	call   80100660 <cprintf>
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
801003d2:	83 c4 10             	add    $0x10,%esp
801003d5:	39 f3                	cmp    %esi,%ebx
801003d7:	75 e7                	jne    801003c0 <panic+0x50>
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
801003d9:	c7 05 58 b5 10 80 01 	movl   $0x1,0x8010b558
801003e0:	00 00 00 
801003e3:	eb fe                	jmp    801003e3 <panic+0x73>
801003e5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801003e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801003f0 <consputc>:
}

void
consputc(int c)
{
  if(panicked){
801003f0:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
801003f6:	85 d2                	test   %edx,%edx
801003f8:	74 06                	je     80100400 <consputc+0x10>
801003fa:	fa                   	cli    
801003fb:	eb fe                	jmp    801003fb <consputc+0xb>
801003fd:	8d 76 00             	lea    0x0(%esi),%esi
  crt[pos] = ' ' | 0x0700;
}

void
consputc(int c)
{
80100400:	55                   	push   %ebp
80100401:	89 e5                	mov    %esp,%ebp
80100403:	57                   	push   %edi
80100404:	56                   	push   %esi
80100405:	53                   	push   %ebx
80100406:	89 c3                	mov    %eax,%ebx
80100408:	83 ec 0c             	sub    $0xc,%esp
    cli();
    for(;;)
      ;
  }

  if(c == BACKSPACE){
8010040b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100410:	0f 84 b8 00 00 00    	je     801004ce <consputc+0xde>
    uartputc('\b'); uartputc(' '); uartputc('\b');
  } else
    uartputc(c);
80100416:	83 ec 0c             	sub    $0xc,%esp
80100419:	50                   	push   %eax
8010041a:	e8 01 68 00 00       	call   80106c20 <uartputc>
8010041f:	83 c4 10             	add    $0x10,%esp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100422:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100427:	b8 0e 00 00 00       	mov    $0xe,%eax
8010042c:	89 fa                	mov    %edi,%edx
8010042e:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010042f:	be d5 03 00 00       	mov    $0x3d5,%esi
80100434:	89 f2                	mov    %esi,%edx
80100436:	ec                   	in     (%dx),%al
{
  int pos;

  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
  pos = inb(CRTPORT+1) << 8;
80100437:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010043a:	89 fa                	mov    %edi,%edx
8010043c:	c1 e0 08             	shl    $0x8,%eax
8010043f:	89 c1                	mov    %eax,%ecx
80100441:	b8 0f 00 00 00       	mov    $0xf,%eax
80100446:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100447:	89 f2                	mov    %esi,%edx
80100449:	ec                   	in     (%dx),%al
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);
8010044a:	0f b6 c0             	movzbl %al,%eax
8010044d:	09 c8                	or     %ecx,%eax

  if(c == '\n')
8010044f:	83 fb 0a             	cmp    $0xa,%ebx
80100452:	0f 84 0b 01 00 00    	je     80100563 <consputc+0x173>
    pos += 80 - pos%80;
  else if(c == BACKSPACE){
80100458:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
8010045e:	0f 84 e6 00 00 00    	je     8010054a <consputc+0x15a>
    if(pos > 0) --pos;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100464:	0f b6 d3             	movzbl %bl,%edx
80100467:	8d 78 01             	lea    0x1(%eax),%edi
8010046a:	80 ce 07             	or     $0x7,%dh
8010046d:	66 89 94 00 00 80 0b 	mov    %dx,-0x7ff48000(%eax,%eax,1)
80100474:	80 

  if(pos < 0 || pos > 25*80)
80100475:	81 ff d0 07 00 00    	cmp    $0x7d0,%edi
8010047b:	0f 8f bc 00 00 00    	jg     8010053d <consputc+0x14d>
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
80100481:	81 ff 7f 07 00 00    	cmp    $0x77f,%edi
80100487:	7f 6f                	jg     801004f8 <consputc+0x108>
80100489:	89 f8                	mov    %edi,%eax
8010048b:	8d 8c 3f 00 80 0b 80 	lea    -0x7ff48000(%edi,%edi,1),%ecx
80100492:	89 fb                	mov    %edi,%ebx
80100494:	c1 e8 08             	shr    $0x8,%eax
80100497:	89 c6                	mov    %eax,%esi
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100499:	bf d4 03 00 00       	mov    $0x3d4,%edi
8010049e:	b8 0e 00 00 00       	mov    $0xe,%eax
801004a3:	89 fa                	mov    %edi,%edx
801004a5:	ee                   	out    %al,(%dx)
801004a6:	ba d5 03 00 00       	mov    $0x3d5,%edx
801004ab:	89 f0                	mov    %esi,%eax
801004ad:	ee                   	out    %al,(%dx)
801004ae:	b8 0f 00 00 00       	mov    $0xf,%eax
801004b3:	89 fa                	mov    %edi,%edx
801004b5:	ee                   	out    %al,(%dx)
801004b6:	ba d5 03 00 00       	mov    $0x3d5,%edx
801004bb:	89 d8                	mov    %ebx,%eax
801004bd:	ee                   	out    %al,(%dx)

  outb(CRTPORT, 14);
  outb(CRTPORT+1, pos>>8);
  outb(CRTPORT, 15);
  outb(CRTPORT+1, pos);
  crt[pos] = ' ' | 0x0700;
801004be:	b8 20 07 00 00       	mov    $0x720,%eax
801004c3:	66 89 01             	mov    %ax,(%ecx)
  if(c == BACKSPACE){
    uartputc('\b'); uartputc(' '); uartputc('\b');
  } else
    uartputc(c);
  cgaputc(c);
}
801004c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004c9:	5b                   	pop    %ebx
801004ca:	5e                   	pop    %esi
801004cb:	5f                   	pop    %edi
801004cc:	5d                   	pop    %ebp
801004cd:	c3                   	ret    
    for(;;)
      ;
  }

  if(c == BACKSPACE){
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004ce:	83 ec 0c             	sub    $0xc,%esp
801004d1:	6a 08                	push   $0x8
801004d3:	e8 48 67 00 00       	call   80106c20 <uartputc>
801004d8:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004df:	e8 3c 67 00 00       	call   80106c20 <uartputc>
801004e4:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004eb:	e8 30 67 00 00       	call   80106c20 <uartputc>
801004f0:	83 c4 10             	add    $0x10,%esp
801004f3:	e9 2a ff ff ff       	jmp    80100422 <consputc+0x32>

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004f8:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
801004fb:	8d 5f b0             	lea    -0x50(%edi),%ebx

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004fe:	68 60 0e 00 00       	push   $0xe60
80100503:	68 a0 80 0b 80       	push   $0x800b80a0
80100508:	68 00 80 0b 80       	push   $0x800b8000
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
8010050d:	8d b4 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%esi

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100514:	e8 c7 4d 00 00       	call   801052e0 <memmove>
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100519:	b8 80 07 00 00       	mov    $0x780,%eax
8010051e:	83 c4 0c             	add    $0xc,%esp
80100521:	29 d8                	sub    %ebx,%eax
80100523:	01 c0                	add    %eax,%eax
80100525:	50                   	push   %eax
80100526:	6a 00                	push   $0x0
80100528:	56                   	push   %esi
80100529:	e8 02 4d 00 00       	call   80105230 <memset>
8010052e:	89 f1                	mov    %esi,%ecx
80100530:	83 c4 10             	add    $0x10,%esp
80100533:	be 07 00 00 00       	mov    $0x7,%esi
80100538:	e9 5c ff ff ff       	jmp    80100499 <consputc+0xa9>
    if(pos > 0) --pos;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");
8010053d:	83 ec 0c             	sub    $0xc,%esp
80100540:	68 a5 80 10 80       	push   $0x801080a5
80100545:	e8 26 fe ff ff       	call   80100370 <panic>
  pos |= inb(CRTPORT+1);

  if(c == '\n')
    pos += 80 - pos%80;
  else if(c == BACKSPACE){
    if(pos > 0) --pos;
8010054a:	85 c0                	test   %eax,%eax
8010054c:	8d 78 ff             	lea    -0x1(%eax),%edi
8010054f:	0f 85 20 ff ff ff    	jne    80100475 <consputc+0x85>
80100555:	b9 00 80 0b 80       	mov    $0x800b8000,%ecx
8010055a:	31 db                	xor    %ebx,%ebx
8010055c:	31 f6                	xor    %esi,%esi
8010055e:	e9 36 ff ff ff       	jmp    80100499 <consputc+0xa9>
  pos = inb(CRTPORT+1) << 8;
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);

  if(c == '\n')
    pos += 80 - pos%80;
80100563:	ba 67 66 66 66       	mov    $0x66666667,%edx
80100568:	f7 ea                	imul   %edx
8010056a:	89 d0                	mov    %edx,%eax
8010056c:	c1 e8 05             	shr    $0x5,%eax
8010056f:	8d 04 80             	lea    (%eax,%eax,4),%eax
80100572:	c1 e0 04             	shl    $0x4,%eax
80100575:	8d 78 50             	lea    0x50(%eax),%edi
80100578:	e9 f8 fe ff ff       	jmp    80100475 <consputc+0x85>
8010057d:	8d 76 00             	lea    0x0(%esi),%esi

80100580 <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
80100580:	55                   	push   %ebp
80100581:	89 e5                	mov    %esp,%ebp
80100583:	57                   	push   %edi
80100584:	56                   	push   %esi
80100585:	53                   	push   %ebx
80100586:	89 d6                	mov    %edx,%esi
80100588:	83 ec 2c             	sub    $0x2c,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
8010058b:	85 c9                	test   %ecx,%ecx
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
8010058d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
80100590:	74 0c                	je     8010059e <printint+0x1e>
80100592:	89 c7                	mov    %eax,%edi
80100594:	c1 ef 1f             	shr    $0x1f,%edi
80100597:	85 c0                	test   %eax,%eax
80100599:	89 7d d4             	mov    %edi,-0x2c(%ebp)
8010059c:	78 51                	js     801005ef <printint+0x6f>
    x = -xx;
  else
    x = xx;

  i = 0;
8010059e:	31 ff                	xor    %edi,%edi
801005a0:	8d 5d d7             	lea    -0x29(%ebp),%ebx
801005a3:	eb 05                	jmp    801005aa <printint+0x2a>
801005a5:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
801005a8:	89 cf                	mov    %ecx,%edi
801005aa:	31 d2                	xor    %edx,%edx
801005ac:	8d 4f 01             	lea    0x1(%edi),%ecx
801005af:	f7 f6                	div    %esi
801005b1:	0f b6 92 d0 80 10 80 	movzbl -0x7fef7f30(%edx),%edx
  }while((x /= base) != 0);
801005b8:	85 c0                	test   %eax,%eax
  else
    x = xx;

  i = 0;
  do{
    buf[i++] = digits[x % base];
801005ba:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
  }while((x /= base) != 0);
801005bd:	75 e9                	jne    801005a8 <printint+0x28>

  if(sign)
801005bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801005c2:	85 c0                	test   %eax,%eax
801005c4:	74 08                	je     801005ce <printint+0x4e>
    buf[i++] = '-';
801005c6:	c6 44 0d d8 2d       	movb   $0x2d,-0x28(%ebp,%ecx,1)
801005cb:	8d 4f 02             	lea    0x2(%edi),%ecx
801005ce:	8d 74 0d d7          	lea    -0x29(%ebp,%ecx,1),%esi
801005d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  while(--i >= 0)
    consputc(buf[i]);
801005d8:	0f be 06             	movsbl (%esi),%eax
801005db:	83 ee 01             	sub    $0x1,%esi
801005de:	e8 0d fe ff ff       	call   801003f0 <consputc>
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
801005e3:	39 de                	cmp    %ebx,%esi
801005e5:	75 f1                	jne    801005d8 <printint+0x58>
    consputc(buf[i]);
}
801005e7:	83 c4 2c             	add    $0x2c,%esp
801005ea:	5b                   	pop    %ebx
801005eb:	5e                   	pop    %esi
801005ec:	5f                   	pop    %edi
801005ed:	5d                   	pop    %ebp
801005ee:	c3                   	ret    
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    x = -xx;
801005ef:	f7 d8                	neg    %eax
801005f1:	eb ab                	jmp    8010059e <printint+0x1e>
801005f3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801005f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100600 <consolewrite>:
  return target - n;
}

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100600:	55                   	push   %ebp
80100601:	89 e5                	mov    %esp,%ebp
80100603:	57                   	push   %edi
80100604:	56                   	push   %esi
80100605:	53                   	push   %ebx
80100606:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
80100609:	ff 75 08             	pushl  0x8(%ebp)
  return target - n;
}

int
consolewrite(struct inode *ip, char *buf, int n)
{
8010060c:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
8010060f:	e8 8c 13 00 00       	call   801019a0 <iunlock>
  acquire(&cons.lock);
80100614:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010061b:	e8 10 4b 00 00       	call   80105130 <acquire>
80100620:	8b 7d 0c             	mov    0xc(%ebp),%edi
  for(i = 0; i < n; i++)
80100623:	83 c4 10             	add    $0x10,%esp
80100626:	85 f6                	test   %esi,%esi
80100628:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010062b:	7e 12                	jle    8010063f <consolewrite+0x3f>
8010062d:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100630:	0f b6 07             	movzbl (%edi),%eax
80100633:	83 c7 01             	add    $0x1,%edi
80100636:	e8 b5 fd ff ff       	call   801003f0 <consputc>
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
8010063b:	39 df                	cmp    %ebx,%edi
8010063d:	75 f1                	jne    80100630 <consolewrite+0x30>
    consputc(buf[i] & 0xff);
  release(&cons.lock);
8010063f:	83 ec 0c             	sub    $0xc,%esp
80100642:	68 20 b5 10 80       	push   $0x8010b520
80100647:	e8 94 4b 00 00       	call   801051e0 <release>
  ilock(ip);
8010064c:	58                   	pop    %eax
8010064d:	ff 75 08             	pushl  0x8(%ebp)
80100650:	e8 6b 12 00 00       	call   801018c0 <ilock>

  return n;
}
80100655:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100658:	89 f0                	mov    %esi,%eax
8010065a:	5b                   	pop    %ebx
8010065b:	5e                   	pop    %esi
8010065c:	5f                   	pop    %edi
8010065d:	5d                   	pop    %ebp
8010065e:	c3                   	ret    
8010065f:	90                   	nop

80100660 <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
80100660:	55                   	push   %ebp
80100661:	89 e5                	mov    %esp,%ebp
80100663:	57                   	push   %edi
80100664:	56                   	push   %esi
80100665:	53                   	push   %ebx
80100666:	83 ec 1c             	sub    $0x1c,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
80100669:	a1 54 b5 10 80       	mov    0x8010b554,%eax
  if(locking)
8010066e:	85 c0                	test   %eax,%eax
{
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
80100670:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
80100673:	0f 85 47 01 00 00    	jne    801007c0 <cprintf+0x160>
    acquire(&cons.lock);

  if (fmt == 0)
80100679:	8b 45 08             	mov    0x8(%ebp),%eax
8010067c:	85 c0                	test   %eax,%eax
8010067e:	89 c1                	mov    %eax,%ecx
80100680:	0f 84 4f 01 00 00    	je     801007d5 <cprintf+0x175>
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100686:	0f b6 00             	movzbl (%eax),%eax
80100689:	31 db                	xor    %ebx,%ebx
8010068b:	8d 75 0c             	lea    0xc(%ebp),%esi
8010068e:	89 cf                	mov    %ecx,%edi
80100690:	85 c0                	test   %eax,%eax
80100692:	75 55                	jne    801006e9 <cprintf+0x89>
80100694:	eb 68                	jmp    801006fe <cprintf+0x9e>
80100696:	8d 76 00             	lea    0x0(%esi),%esi
80100699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(c != '%'){
      consputc(c);
      continue;
    }
    c = fmt[++i] & 0xff;
801006a0:	83 c3 01             	add    $0x1,%ebx
801006a3:	0f b6 14 1f          	movzbl (%edi,%ebx,1),%edx
    if(c == 0)
801006a7:	85 d2                	test   %edx,%edx
801006a9:	74 53                	je     801006fe <cprintf+0x9e>
      break;
    switch(c){
801006ab:	83 fa 70             	cmp    $0x70,%edx
801006ae:	74 7a                	je     8010072a <cprintf+0xca>
801006b0:	7f 6e                	jg     80100720 <cprintf+0xc0>
801006b2:	83 fa 25             	cmp    $0x25,%edx
801006b5:	0f 84 ad 00 00 00    	je     80100768 <cprintf+0x108>
801006bb:	83 fa 64             	cmp    $0x64,%edx
801006be:	0f 85 84 00 00 00    	jne    80100748 <cprintf+0xe8>
    case 'd':
      printint(*argp++, 10, 1);
801006c4:	8d 46 04             	lea    0x4(%esi),%eax
801006c7:	b9 01 00 00 00       	mov    $0x1,%ecx
801006cc:	ba 0a 00 00 00       	mov    $0xa,%edx
801006d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801006d4:	8b 06                	mov    (%esi),%eax
801006d6:	e8 a5 fe ff ff       	call   80100580 <printint>
801006db:	8b 75 e4             	mov    -0x1c(%ebp),%esi

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006de:	83 c3 01             	add    $0x1,%ebx
801006e1:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801006e5:	85 c0                	test   %eax,%eax
801006e7:	74 15                	je     801006fe <cprintf+0x9e>
    if(c != '%'){
801006e9:	83 f8 25             	cmp    $0x25,%eax
801006ec:	74 b2                	je     801006a0 <cprintf+0x40>
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
      break;
    case '%':
      consputc('%');
801006ee:	e8 fd fc ff ff       	call   801003f0 <consputc>

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006f3:	83 c3 01             	add    $0x1,%ebx
801006f6:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801006fa:	85 c0                	test   %eax,%eax
801006fc:	75 eb                	jne    801006e9 <cprintf+0x89>
      consputc(c);
      break;
    }
  }

  if(locking)
801006fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100701:	85 c0                	test   %eax,%eax
80100703:	74 10                	je     80100715 <cprintf+0xb5>
    release(&cons.lock);
80100705:	83 ec 0c             	sub    $0xc,%esp
80100708:	68 20 b5 10 80       	push   $0x8010b520
8010070d:	e8 ce 4a 00 00       	call   801051e0 <release>
80100712:	83 c4 10             	add    $0x10,%esp
}
80100715:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100718:	5b                   	pop    %ebx
80100719:	5e                   	pop    %esi
8010071a:	5f                   	pop    %edi
8010071b:	5d                   	pop    %ebp
8010071c:	c3                   	ret    
8010071d:	8d 76 00             	lea    0x0(%esi),%esi
      continue;
    }
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
    switch(c){
80100720:	83 fa 73             	cmp    $0x73,%edx
80100723:	74 5b                	je     80100780 <cprintf+0x120>
80100725:	83 fa 78             	cmp    $0x78,%edx
80100728:	75 1e                	jne    80100748 <cprintf+0xe8>
    case 'd':
      printint(*argp++, 10, 1);
      break;
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
8010072a:	8d 46 04             	lea    0x4(%esi),%eax
8010072d:	31 c9                	xor    %ecx,%ecx
8010072f:	ba 10 00 00 00       	mov    $0x10,%edx
80100734:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100737:	8b 06                	mov    (%esi),%eax
80100739:	e8 42 fe ff ff       	call   80100580 <printint>
8010073e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
      break;
80100741:	eb 9b                	jmp    801006de <cprintf+0x7e>
80100743:	90                   	nop
80100744:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    case '%':
      consputc('%');
      break;
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
80100748:	b8 25 00 00 00       	mov    $0x25,%eax
8010074d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80100750:	e8 9b fc ff ff       	call   801003f0 <consputc>
      consputc(c);
80100755:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80100758:	89 d0                	mov    %edx,%eax
8010075a:	e8 91 fc ff ff       	call   801003f0 <consputc>
      break;
8010075f:	e9 7a ff ff ff       	jmp    801006de <cprintf+0x7e>
80100764:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
      break;
    case '%':
      consputc('%');
80100768:	b8 25 00 00 00       	mov    $0x25,%eax
8010076d:	e8 7e fc ff ff       	call   801003f0 <consputc>
80100772:	e9 7c ff ff ff       	jmp    801006f3 <cprintf+0x93>
80100777:	89 f6                	mov    %esi,%esi
80100779:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
80100780:	8d 46 04             	lea    0x4(%esi),%eax
80100783:	8b 36                	mov    (%esi),%esi
80100785:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        s = "(null)";
80100788:	b8 b8 80 10 80       	mov    $0x801080b8,%eax
8010078d:	85 f6                	test   %esi,%esi
8010078f:	0f 44 f0             	cmove  %eax,%esi
      for(; *s; s++)
80100792:	0f be 06             	movsbl (%esi),%eax
80100795:	84 c0                	test   %al,%al
80100797:	74 16                	je     801007af <cprintf+0x14f>
80100799:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801007a0:	83 c6 01             	add    $0x1,%esi
        consputc(*s);
801007a3:	e8 48 fc ff ff       	call   801003f0 <consputc>
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
801007a8:	0f be 06             	movsbl (%esi),%eax
801007ab:	84 c0                	test   %al,%al
801007ad:	75 f1                	jne    801007a0 <cprintf+0x140>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
801007af:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801007b2:	e9 27 ff ff ff       	jmp    801006de <cprintf+0x7e>
801007b7:	89 f6                	mov    %esi,%esi
801007b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  uint *argp;
  char *s;

  locking = cons.locking;
  if(locking)
    acquire(&cons.lock);
801007c0:	83 ec 0c             	sub    $0xc,%esp
801007c3:	68 20 b5 10 80       	push   $0x8010b520
801007c8:	e8 63 49 00 00       	call   80105130 <acquire>
801007cd:	83 c4 10             	add    $0x10,%esp
801007d0:	e9 a4 fe ff ff       	jmp    80100679 <cprintf+0x19>

  if (fmt == 0)
    panic("null fmt");
801007d5:	83 ec 0c             	sub    $0xc,%esp
801007d8:	68 bf 80 10 80       	push   $0x801080bf
801007dd:	e8 8e fb ff ff       	call   80100370 <panic>
801007e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801007e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801007f0 <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007f0:	55                   	push   %ebp
801007f1:	89 e5                	mov    %esp,%ebp
801007f3:	57                   	push   %edi
801007f4:	56                   	push   %esi
801007f5:	53                   	push   %ebx
  int c, doprocdump = 0;
801007f6:	31 f6                	xor    %esi,%esi

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007f8:	83 ec 18             	sub    $0x18,%esp
801007fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int c, doprocdump = 0;

  acquire(&cons.lock);
801007fe:	68 20 b5 10 80       	push   $0x8010b520
80100803:	e8 28 49 00 00       	call   80105130 <acquire>
  while((c = getc()) >= 0){
80100808:	83 c4 10             	add    $0x10,%esp
8010080b:	90                   	nop
8010080c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100810:	ff d3                	call   *%ebx
80100812:	85 c0                	test   %eax,%eax
80100814:	89 c7                	mov    %eax,%edi
80100816:	78 48                	js     80100860 <consoleintr+0x70>
    switch(c){
80100818:	83 ff 10             	cmp    $0x10,%edi
8010081b:	0f 84 3f 01 00 00    	je     80100960 <consoleintr+0x170>
80100821:	7e 5d                	jle    80100880 <consoleintr+0x90>
80100823:	83 ff 15             	cmp    $0x15,%edi
80100826:	0f 84 dc 00 00 00    	je     80100908 <consoleintr+0x118>
8010082c:	83 ff 7f             	cmp    $0x7f,%edi
8010082f:	75 54                	jne    80100885 <consoleintr+0x95>
        input.e--;
        consputc(BACKSPACE);
      }
      break;
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
80100831:	a1 28 10 11 80       	mov    0x80111028,%eax
80100836:	3b 05 24 10 11 80    	cmp    0x80111024,%eax
8010083c:	74 d2                	je     80100810 <consoleintr+0x20>
        input.e--;
8010083e:	83 e8 01             	sub    $0x1,%eax
80100841:	a3 28 10 11 80       	mov    %eax,0x80111028
        consputc(BACKSPACE);
80100846:	b8 00 01 00 00       	mov    $0x100,%eax
8010084b:	e8 a0 fb ff ff       	call   801003f0 <consputc>
consoleintr(int (*getc)(void))
{
  int c, doprocdump = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
80100850:	ff d3                	call   *%ebx
80100852:	85 c0                	test   %eax,%eax
80100854:	89 c7                	mov    %eax,%edi
80100856:	79 c0                	jns    80100818 <consoleintr+0x28>
80100858:	90                   	nop
80100859:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        }
      }
      break;
    }
  }
  release(&cons.lock);
80100860:	83 ec 0c             	sub    $0xc,%esp
80100863:	68 20 b5 10 80       	push   $0x8010b520
80100868:	e8 73 49 00 00       	call   801051e0 <release>
  if(doprocdump) {
8010086d:	83 c4 10             	add    $0x10,%esp
80100870:	85 f6                	test   %esi,%esi
80100872:	0f 85 f8 00 00 00    	jne    80100970 <consoleintr+0x180>
    procdump();  // now call procdump() wo. cons.lock held
  }
}
80100878:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010087b:	5b                   	pop    %ebx
8010087c:	5e                   	pop    %esi
8010087d:	5f                   	pop    %edi
8010087e:	5d                   	pop    %ebp
8010087f:	c3                   	ret    
{
  int c, doprocdump = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
    switch(c){
80100880:	83 ff 08             	cmp    $0x8,%edi
80100883:	74 ac                	je     80100831 <consoleintr+0x41>
        input.e--;
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100885:	85 ff                	test   %edi,%edi
80100887:	74 87                	je     80100810 <consoleintr+0x20>
80100889:	a1 28 10 11 80       	mov    0x80111028,%eax
8010088e:	89 c2                	mov    %eax,%edx
80100890:	2b 15 20 10 11 80    	sub    0x80111020,%edx
80100896:	83 fa 7f             	cmp    $0x7f,%edx
80100899:	0f 87 71 ff ff ff    	ja     80100810 <consoleintr+0x20>
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
8010089f:	8d 50 01             	lea    0x1(%eax),%edx
801008a2:	83 e0 7f             	and    $0x7f,%eax
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
801008a5:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
801008a8:	89 15 28 10 11 80    	mov    %edx,0x80111028
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
801008ae:	0f 84 c8 00 00 00    	je     8010097c <consoleintr+0x18c>
        input.buf[input.e++ % INPUT_BUF] = c;
801008b4:	89 f9                	mov    %edi,%ecx
801008b6:	88 88 a0 0f 11 80    	mov    %cl,-0x7feef060(%eax)
        consputc(c);
801008bc:	89 f8                	mov    %edi,%eax
801008be:	e8 2d fb ff ff       	call   801003f0 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008c3:	83 ff 0a             	cmp    $0xa,%edi
801008c6:	0f 84 c1 00 00 00    	je     8010098d <consoleintr+0x19d>
801008cc:	83 ff 04             	cmp    $0x4,%edi
801008cf:	0f 84 b8 00 00 00    	je     8010098d <consoleintr+0x19d>
801008d5:	a1 20 10 11 80       	mov    0x80111020,%eax
801008da:	83 e8 80             	sub    $0xffffff80,%eax
801008dd:	39 05 28 10 11 80    	cmp    %eax,0x80111028
801008e3:	0f 85 27 ff ff ff    	jne    80100810 <consoleintr+0x20>
          input.w = input.e;
          wakeup(&input.r);
801008e9:	83 ec 0c             	sub    $0xc,%esp
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
        consputc(c);
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
          input.w = input.e;
801008ec:	a3 24 10 11 80       	mov    %eax,0x80111024
          wakeup(&input.r);
801008f1:	68 20 10 11 80       	push   $0x80111020
801008f6:	e8 95 3c 00 00       	call   80104590 <wakeup>
801008fb:	83 c4 10             	add    $0x10,%esp
801008fe:	e9 0d ff ff ff       	jmp    80100810 <consoleintr+0x20>
80100903:	90                   	nop
80100904:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100908:	a1 28 10 11 80       	mov    0x80111028,%eax
8010090d:	39 05 24 10 11 80    	cmp    %eax,0x80111024
80100913:	75 2b                	jne    80100940 <consoleintr+0x150>
80100915:	e9 f6 fe ff ff       	jmp    80100810 <consoleintr+0x20>
8010091a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
80100920:	a3 28 10 11 80       	mov    %eax,0x80111028
        consputc(BACKSPACE);
80100925:	b8 00 01 00 00       	mov    $0x100,%eax
8010092a:	e8 c1 fa ff ff       	call   801003f0 <consputc>
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
8010092f:	a1 28 10 11 80       	mov    0x80111028,%eax
80100934:	3b 05 24 10 11 80    	cmp    0x80111024,%eax
8010093a:	0f 84 d0 fe ff ff    	je     80100810 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100940:	83 e8 01             	sub    $0x1,%eax
80100943:	89 c2                	mov    %eax,%edx
80100945:	83 e2 7f             	and    $0x7f,%edx
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100948:	80 ba a0 0f 11 80 0a 	cmpb   $0xa,-0x7feef060(%edx)
8010094f:	75 cf                	jne    80100920 <consoleintr+0x130>
80100951:	e9 ba fe ff ff       	jmp    80100810 <consoleintr+0x20>
80100956:	8d 76 00             	lea    0x0(%esi),%esi
80100959:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  acquire(&cons.lock);
  while((c = getc()) >= 0){
    switch(c){
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
80100960:	be 01 00 00 00       	mov    $0x1,%esi
80100965:	e9 a6 fe ff ff       	jmp    80100810 <consoleintr+0x20>
8010096a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  }
  release(&cons.lock);
  if(doprocdump) {
    procdump();  // now call procdump() wo. cons.lock held
  }
}
80100970:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100973:	5b                   	pop    %ebx
80100974:	5e                   	pop    %esi
80100975:	5f                   	pop    %edi
80100976:	5d                   	pop    %ebp
      break;
    }
  }
  release(&cons.lock);
  if(doprocdump) {
    procdump();  // now call procdump() wo. cons.lock held
80100977:	e9 d4 3e 00 00       	jmp    80104850 <procdump>
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
8010097c:	c6 80 a0 0f 11 80 0a 	movb   $0xa,-0x7feef060(%eax)
        consputc(c);
80100983:	b8 0a 00 00 00       	mov    $0xa,%eax
80100988:	e8 63 fa ff ff       	call   801003f0 <consputc>
8010098d:	a1 28 10 11 80       	mov    0x80111028,%eax
80100992:	e9 52 ff ff ff       	jmp    801008e9 <consoleintr+0xf9>
80100997:	89 f6                	mov    %esi,%esi
80100999:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801009a0 <consoleinit>:
  return n;
}

void
consoleinit(void)
{
801009a0:	55                   	push   %ebp
801009a1:	89 e5                	mov    %esp,%ebp
801009a3:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
801009a6:	68 c8 80 10 80       	push   $0x801080c8
801009ab:	68 20 b5 10 80       	push   $0x8010b520
801009b0:	e8 1b 46 00 00       	call   80104fd0 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
801009b5:	58                   	pop    %eax
801009b6:	5a                   	pop    %edx
801009b7:	6a 00                	push   $0x0
801009b9:	6a 01                	push   $0x1
void
consoleinit(void)
{
  initlock(&cons.lock, "console");

  devsw[CONSOLE].write = consolewrite;
801009bb:	c7 05 ec 19 11 80 00 	movl   $0x80100600,0x801119ec
801009c2:	06 10 80 
  devsw[CONSOLE].read = consoleread;
801009c5:	c7 05 e8 19 11 80 70 	movl   $0x80100270,0x801119e8
801009cc:	02 10 80 
  cons.locking = 1;
801009cf:	c7 05 54 b5 10 80 01 	movl   $0x1,0x8010b554
801009d6:	00 00 00 

  ioapicenable(IRQ_KBD, 0);
801009d9:	e8 12 1b 00 00       	call   801024f0 <ioapicenable>
}
801009de:	83 c4 10             	add    $0x10,%esp
801009e1:	c9                   	leave  
801009e2:	c3                   	ret    
801009e3:	66 90                	xchg   %ax,%ax
801009e5:	66 90                	xchg   %ax,%ax
801009e7:	66 90                	xchg   %ax,%ax
801009e9:	66 90                	xchg   %ax,%ax
801009eb:	66 90                	xchg   %ax,%ax
801009ed:	66 90                	xchg   %ax,%ax
801009ef:	90                   	nop

801009f0 <get_size_string>:
#include "proc.h"
#include "defs.h"
#include "x86.h"
#include "elf.h"

int get_size_string(char* string){
801009f0:	55                   	push   %ebp
    int i=0;
801009f1:	31 c0                	xor    %eax,%eax
#include "proc.h"
#include "defs.h"
#include "x86.h"
#include "elf.h"

int get_size_string(char* string){
801009f3:	89 e5                	mov    %esp,%ebp
801009f5:	8b 55 08             	mov    0x8(%ebp),%edx
    int i=0;
    while(1){
        if(string[i]=='\0')
801009f8:	80 3a 00             	cmpb   $0x0,(%edx)
801009fb:	74 0c                	je     80100a09 <get_size_string+0x19>
801009fd:	8d 76 00             	lea    0x0(%esi),%esi
            break;
        i++;
80100a00:	83 c0 01             	add    $0x1,%eax
#include "elf.h"

int get_size_string(char* string){
    int i=0;
    while(1){
        if(string[i]=='\0')
80100a03:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80100a07:	75 f7                	jne    80100a00 <get_size_string+0x10>
            break;
        i++;
    }
    return i;
}
80100a09:	5d                   	pop    %ebp
80100a0a:	c3                   	ret    
80100a0b:	90                   	nop
80100a0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100a10 <exec>:

int
exec(char *path, char **argv)
{
80100a10:	55                   	push   %ebp
80100a11:	89 e5                	mov    %esp,%ebp
80100a13:	57                   	push   %edi
80100a14:	56                   	push   %esi
80100a15:	53                   	push   %ebx
80100a16:	81 ec 7c 01 00 00    	sub    $0x17c,%esp
80100a1c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100a1f:	e8 0c 30 00 00       	call   80103a30 <myproc>
80100a24:	89 85 84 fe ff ff    	mov    %eax,-0x17c(%ebp)
#include "elf.h"

int get_size_string(char* string){
    int i=0;
    while(1){
        if(string[i]=='\0')
80100a2a:	0f b6 03             	movzbl (%ebx),%eax
80100a2d:	84 c0                	test   %al,%al
80100a2f:	0f 84 5f 03 00 00    	je     80100d94 <exec+0x384>
80100a35:	31 f6                	xor    %esi,%esi
80100a37:	89 f6                	mov    %esi,%esi
80100a39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
            break;
        i++;
80100a40:	83 c6 01             	add    $0x1,%esi
#include "elf.h"

int get_size_string(char* string){
    int i=0;
    while(1){
        if(string[i]=='\0')
80100a43:	80 3c 33 00          	cmpb   $0x0,(%ebx,%esi,1)
80100a47:	75 f7                	jne    80100a40 <exec+0x30>
80100a49:	80 3d 20 0f 11 80 00 	cmpb   $0x0,0x80110f20
80100a50:	0f 84 1b 03 00 00    	je     80100d71 <exec+0x361>
#include "defs.h"
#include "x86.h"
#include "elf.h"

int get_size_string(char* string){
    int i=0;
80100a56:	31 d2                	xor    %edx,%edx
80100a58:	90                   	nop
80100a59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    while(1){
        if(string[i]=='\0')
            break;
        i++;
80100a60:	83 c2 01             	add    $0x1,%edx
#include "elf.h"

int get_size_string(char* string){
    int i=0;
    while(1){
        if(string[i]=='\0')
80100a63:	80 ba 20 0f 11 80 00 	cmpb   $0x0,-0x7feef0e0(%edx)
80100a6a:	75 f4                	jne    80100a60 <exec+0x50>
80100a6c:	84 c0                	test   %al,%al
80100a6e:	89 95 94 fe ff ff    	mov    %edx,-0x16c(%ebp)
80100a74:	0f 84 06 03 00 00    	je     80100d80 <exec+0x370>
80100a7a:	31 c0                	xor    %eax,%eax
80100a7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            break;
        i++;
80100a80:	83 c0 01             	add    $0x1,%eax
#include "elf.h"

int get_size_string(char* string){
    int i=0;
    while(1){
        if(string[i]=='\0')
80100a83:	80 3c 03 00          	cmpb   $0x0,(%ebx,%eax,1)
80100a87:	75 f7                	jne    80100a80 <exec+0x70>
80100a89:	89 85 88 fe ff ff    	mov    %eax,-0x178(%ebp)
  int fsize=get_size_string(path);
  int found=0;//found == 0 if ip not found
  int size=get_size_string(add_path);
  int psize=get_size_string(path);
  int c=0;
  begin_op();
80100a8f:	e8 0c 23 00 00       	call   80102da0 <begin_op>
  //add
  if(size>0){
80100a94:	8b 95 94 fe ff ff    	mov    -0x16c(%ebp),%edx
80100a9a:	85 d2                	test   %edx,%edx
80100a9c:	0f 84 9f 01 00 00    	je     80100c41 <exec+0x231>
80100aa2:	85 f6                	test   %esi,%esi
80100aa4:	b8 00 00 00 00       	mov    $0x0,%eax
80100aa9:	0f 49 c6             	cmovns %esi,%eax
  int fsize=get_size_string(path);
  int found=0;//found == 0 if ip not found
  int size=get_size_string(add_path);
  int psize=get_size_string(path);
  int c=0;
  begin_op();
80100aac:	31 c9                	xor    %ecx,%ecx
80100aae:	89 85 8c fe ff ff    	mov    %eax,-0x174(%ebp)
80100ab4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100ab8:	89 b5 90 fe ff ff    	mov    %esi,-0x170(%ebp)
80100abe:	89 cf                	mov    %ecx,%edi
80100ac0:	31 c0                	xor    %eax,%eax
80100ac2:	8b b5 94 fe ff ff    	mov    -0x16c(%ebp),%esi
80100ac8:	eb 17                	jmp    80100ae1 <exec+0xd1>
80100aca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(size>0){
  for(j=0;j<size;j++){
     while(add_path[j]!=':'){
       	temp[ii]=add_path[j];
        ii++;
        j++; 
80100ad0:	83 c7 01             	add    $0x1,%edi
  begin_op();
  //add
  if(size>0){
  for(j=0;j<size;j++){
     while(add_path[j]!=':'){
       	temp[ii]=add_path[j];
80100ad3:	88 94 05 f4 fe ff ff 	mov    %dl,-0x10c(%ebp,%eax,1)
        ii++;
80100ada:	83 c0 01             	add    $0x1,%eax
        j++; 
        if(j>=size)
80100add:	39 f7                	cmp    %esi,%edi
80100adf:	7d 0d                	jge    80100aee <exec+0xde>
  int c=0;
  begin_op();
  //add
  if(size>0){
  for(j=0;j<size;j++){
     while(add_path[j]!=':'){
80100ae1:	0f b6 94 01 20 0f 11 	movzbl -0x7feef0e0(%ecx,%eax,1),%edx
80100ae8:	80 
80100ae9:	80 fa 3a             	cmp    $0x3a,%dl
80100aec:	75 e2                	jne    80100ad0 <exec+0xc0>
80100aee:	8b b5 90 fe ff ff    	mov    -0x170(%ebp),%esi
        ii++;
        j++; 
        if(j>=size)
            break;
     }
     temp[ii]='/';
80100af4:	c6 84 05 f4 fe ff ff 	movb   $0x2f,-0x10c(%ebp,%eax,1)
80100afb:	2f 
       ii++;
80100afc:	8d 48 01             	lea    0x1(%eax),%ecx
     for(c=0;c<fsize;c++){
80100aff:	85 f6                	test   %esi,%esi
80100b01:	74 2a                	je     80100b2d <exec+0x11d>
       temp[ii+c]=path[c];}
80100b03:	8d 95 f4 fe ff ff    	lea    -0x10c(%ebp),%edx
80100b09:	89 8d 90 fe ff ff    	mov    %ecx,-0x170(%ebp)
80100b0f:	01 d0                	add    %edx,%eax
80100b11:	31 d2                	xor    %edx,%edx
80100b13:	90                   	nop
80100b14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100b18:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80100b1c:	88 4c 10 01          	mov    %cl,0x1(%eax,%edx,1)
        if(j>=size)
            break;
     }
     temp[ii]='/';
       ii++;
     for(c=0;c<fsize;c++){
80100b20:	83 c2 01             	add    $0x1,%edx
80100b23:	39 f2                	cmp    %esi,%edx
80100b25:	75 f1                	jne    80100b18 <exec+0x108>
80100b27:	8b 8d 90 fe ff ff    	mov    -0x170(%ebp),%ecx
       temp[ii+c]=path[c];}
       temp[ii+c]='\0';
80100b2d:	8d 45 e8             	lea    -0x18(%ebp),%eax
       ii=0;
       //cprintf("search path:%s\n",temp);
       ip=namei(temp);
80100b30:	83 ec 0c             	sub    $0xc,%esp
     }
     temp[ii]='/';
       ii++;
     for(c=0;c<fsize;c++){
       temp[ii+c]=path[c];}
       temp[ii+c]='\0';
80100b33:	01 c1                	add    %eax,%ecx
80100b35:	8b 85 8c fe ff ff    	mov    -0x174(%ebp),%eax
80100b3b:	c6 84 08 0c ff ff ff 	movb   $0x0,-0xf4(%eax,%ecx,1)
80100b42:	00 
       ii=0;
       //cprintf("search path:%s\n",temp);
       ip=namei(temp);
80100b43:	8d 85 f4 fe ff ff    	lea    -0x10c(%ebp),%eax
80100b49:	50                   	push   %eax
80100b4a:	e8 c1 15 00 00       	call   80102110 <namei>
       if(ip != 0){
80100b4f:	83 c4 10             	add    $0x10,%esp
80100b52:	85 c0                	test   %eax,%eax
80100b54:	0f 85 8e 00 00 00    	jne    80100be8 <exec+0x1d8>
  int psize=get_size_string(path);
  int c=0;
  begin_op();
  //add
  if(size>0){
  for(j=0;j<size;j++){
80100b5a:	8d 4f 01             	lea    0x1(%edi),%ecx
80100b5d:	3b 8d 94 fe ff ff    	cmp    -0x16c(%ebp),%ecx
80100b63:	0f 8c 4f ff ff ff    	jl     80100ab8 <exec+0xa8>
	 found=1;
         break;
       }
     }
  if(!found){
        if(path[0]!='/'){
80100b69:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80100b6c:	0f 84 cf 00 00 00    	je     80100c41 <exec+0x231>
	   temp[0]='/';
  	   for (c=0;c<psize;c++){
80100b72:	8b 8d 88 fe ff ff    	mov    -0x178(%ebp),%ecx
         break;
       }
     }
  if(!found){
        if(path[0]!='/'){
	   temp[0]='/';
80100b78:	c6 85 f4 fe ff ff 2f 	movb   $0x2f,-0x10c(%ebp)
  	   for (c=0;c<psize;c++){
80100b7f:	85 c9                	test   %ecx,%ecx
80100b81:	0f 84 21 02 00 00    	je     80100da8 <exec+0x398>
80100b87:	31 c0                	xor    %eax,%eax
80100b89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
             temp[c+1]=path[c];
80100b90:	83 c0 01             	add    $0x1,%eax
80100b93:	0f b6 54 03 ff       	movzbl -0x1(%ebx,%eax,1),%edx
       }
     }
  if(!found){
        if(path[0]!='/'){
	   temp[0]='/';
  	   for (c=0;c<psize;c++){
80100b98:	39 c8                	cmp    %ecx,%eax
             temp[c+1]=path[c];
80100b9a:	88 94 05 f4 fe ff ff 	mov    %dl,-0x10c(%ebp,%eax,1)
       }
     }
  if(!found){
        if(path[0]!='/'){
	   temp[0]='/';
  	   for (c=0;c<psize;c++){
80100ba1:	75 ed                	jne    80100b90 <exec+0x180>
80100ba3:	83 c0 01             	add    $0x1,%eax
             temp[c+1]=path[c];
           }
  	   temp[c+1]='\0';
80100ba6:	c6 84 05 f4 fe ff ff 	movb   $0x0,-0x10c(%ebp,%eax,1)
80100bad:	00 
         }
       if(path[0]!='/')
          ip=namei(temp);
80100bae:	8d 85 f4 fe ff ff    	lea    -0x10c(%ebp),%eax
80100bb4:	83 ec 0c             	sub    $0xc,%esp
80100bb7:	50                   	push   %eax
80100bb8:	e8 53 15 00 00       	call   80102110 <namei>
80100bbd:	83 c4 10             	add    $0x10,%esp
80100bc0:	89 c2                	mov    %eax,%edx
    return -1;
  }
  }
  else{
   ip=namei(path);
   if(ip == 0){
80100bc2:	85 d2                	test   %edx,%edx
80100bc4:	75 24                	jne    80100bea <exec+0x1da>
    end_op();
80100bc6:	e8 45 22 00 00       	call   80102e10 <end_op>
    cprintf("exec: fail\n");
80100bcb:	83 ec 0c             	sub    $0xc,%esp
80100bce:	68 e1 80 10 80       	push   $0x801080e1
80100bd3:	e8 88 fa ff ff       	call   80100660 <cprintf>
    return -1;
80100bd8:	83 c4 10             	add    $0x10,%esp
  if(ip){
    iunlockput(ip);
    end_op();
  }
  return -1;
}
80100bdb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  else{
   ip=namei(path);
   if(ip == 0){
    end_op();
    cprintf("exec: fail\n");
    return -1;
80100bde:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(ip){
    iunlockput(ip);
    end_op();
  }
  return -1;
}
80100be3:	5b                   	pop    %ebx
80100be4:	5e                   	pop    %esi
80100be5:	5f                   	pop    %edi
80100be6:	5d                   	pop    %ebp
80100be7:	c3                   	ret    
80100be8:	89 c2                	mov    %eax,%edx
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  }
  ilock(ip);
80100bea:	83 ec 0c             	sub    $0xc,%esp
80100bed:	89 95 94 fe ff ff    	mov    %edx,-0x16c(%ebp)
80100bf3:	52                   	push   %edx
80100bf4:	e8 c7 0c 00 00       	call   801018c0 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100bf9:	8b 95 94 fe ff ff    	mov    -0x16c(%ebp),%edx
80100bff:	8d 85 c0 fe ff ff    	lea    -0x140(%ebp),%eax
80100c05:	6a 34                	push   $0x34
80100c07:	6a 00                	push   $0x0
80100c09:	50                   	push   %eax
80100c0a:	52                   	push   %edx
80100c0b:	e8 90 0f 00 00       	call   80101ba0 <readi>
80100c10:	83 c4 20             	add    $0x20,%esp
80100c13:	83 f8 34             	cmp    $0x34,%eax
80100c16:	8b 95 94 fe ff ff    	mov    -0x16c(%ebp),%edx
80100c1c:	74 36                	je     80100c54 <exec+0x244>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100c1e:	83 ec 0c             	sub    $0xc,%esp
80100c21:	52                   	push   %edx
80100c22:	e8 29 0f 00 00       	call   80101b50 <iunlockput>
    end_op();
80100c27:	e8 e4 21 00 00       	call   80102e10 <end_op>
80100c2c:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100c2f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100c34:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100c37:	5b                   	pop    %ebx
80100c38:	5e                   	pop    %esi
80100c39:	5f                   	pop    %edi
80100c3a:	5d                   	pop    %ebp
80100c3b:	c3                   	ret    
  int fsize=get_size_string(path);
  int found=0;//found == 0 if ip not found
  int size=get_size_string(add_path);
  int psize=get_size_string(path);
  int c=0;
  begin_op();
80100c3c:	e8 5f 21 00 00       	call   80102da0 <begin_op>
    cprintf("exec: fail\n");
    return -1;
  }
  }
  else{
   ip=namei(path);
80100c41:	83 ec 0c             	sub    $0xc,%esp
80100c44:	53                   	push   %ebx
80100c45:	e8 c6 14 00 00       	call   80102110 <namei>
   if(ip == 0){
80100c4a:	83 c4 10             	add    $0x10,%esp
    cprintf("exec: fail\n");
    return -1;
  }
  }
  else{
   ip=namei(path);
80100c4d:	89 c2                	mov    %eax,%edx
80100c4f:	e9 6e ff ff ff       	jmp    80100bc2 <exec+0x1b2>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100c54:	81 bd c0 fe ff ff 7f 	cmpl   $0x464c457f,-0x140(%ebp)
80100c5b:	45 4c 46 
80100c5e:	75 be                	jne    80100c1e <exec+0x20e>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100c60:	e8 4b 71 00 00       	call   80107db0 <setupkvm>
80100c65:	85 c0                	test   %eax,%eax
80100c67:	89 c6                	mov    %eax,%esi
80100c69:	8b 95 94 fe ff ff    	mov    -0x16c(%ebp),%edx
80100c6f:	74 ad                	je     80100c1e <exec+0x20e>
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100c71:	66 83 bd ec fe ff ff 	cmpw   $0x0,-0x114(%ebp)
80100c78:	00 
80100c79:	8b 85 dc fe ff ff    	mov    -0x124(%ebp),%eax
80100c7f:	89 85 90 fe ff ff    	mov    %eax,-0x170(%ebp)
80100c85:	0f 84 27 01 00 00    	je     80100db2 <exec+0x3a2>
80100c8b:	89 5d 08             	mov    %ebx,0x8(%ebp)
80100c8e:	31 ff                	xor    %edi,%edi
80100c90:	c7 85 94 fe ff ff 00 	movl   $0x0,-0x16c(%ebp)
80100c97:	00 00 00 
80100c9a:	89 d3                	mov    %edx,%ebx
80100c9c:	eb 25                	jmp    80100cc3 <exec+0x2b3>
80100c9e:	66 90                	xchg   %ax,%ax
80100ca0:	83 85 94 fe ff ff 01 	addl   $0x1,-0x16c(%ebp)
80100ca7:	0f b7 85 ec fe ff ff 	movzwl -0x114(%ebp),%eax
80100cae:	8b 8d 94 fe ff ff    	mov    -0x16c(%ebp),%ecx
80100cb4:	83 85 90 fe ff ff 20 	addl   $0x20,-0x170(%ebp)
80100cbb:	39 c8                	cmp    %ecx,%eax
80100cbd:	0f 8e 2f 01 00 00    	jle    80100df2 <exec+0x3e2>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100cc3:	8d 85 a0 fe ff ff    	lea    -0x160(%ebp),%eax
80100cc9:	6a 20                	push   $0x20
80100ccb:	ff b5 90 fe ff ff    	pushl  -0x170(%ebp)
80100cd1:	50                   	push   %eax
80100cd2:	53                   	push   %ebx
80100cd3:	e8 c8 0e 00 00       	call   80101ba0 <readi>
80100cd8:	83 c4 10             	add    $0x10,%esp
80100cdb:	83 f8 20             	cmp    $0x20,%eax
80100cde:	75 62                	jne    80100d42 <exec+0x332>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100ce0:	83 bd a0 fe ff ff 01 	cmpl   $0x1,-0x160(%ebp)
80100ce7:	75 b7                	jne    80100ca0 <exec+0x290>
      continue;
    if(ph.memsz < ph.filesz)
80100ce9:	8b 85 b4 fe ff ff    	mov    -0x14c(%ebp),%eax
80100cef:	3b 85 b0 fe ff ff    	cmp    -0x150(%ebp),%eax
80100cf5:	72 4b                	jb     80100d42 <exec+0x332>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100cf7:	03 85 a8 fe ff ff    	add    -0x158(%ebp),%eax
80100cfd:	72 43                	jb     80100d42 <exec+0x332>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100cff:	83 ec 04             	sub    $0x4,%esp
80100d02:	50                   	push   %eax
80100d03:	57                   	push   %edi
80100d04:	56                   	push   %esi
80100d05:	e8 f6 6e 00 00       	call   80107c00 <allocuvm>
80100d0a:	83 c4 10             	add    $0x10,%esp
80100d0d:	85 c0                	test   %eax,%eax
80100d0f:	89 c7                	mov    %eax,%edi
80100d11:	74 2f                	je     80100d42 <exec+0x332>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
80100d13:	8b 85 a8 fe ff ff    	mov    -0x158(%ebp),%eax
80100d19:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100d1e:	75 22                	jne    80100d42 <exec+0x332>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100d20:	83 ec 0c             	sub    $0xc,%esp
80100d23:	ff b5 b0 fe ff ff    	pushl  -0x150(%ebp)
80100d29:	ff b5 a4 fe ff ff    	pushl  -0x15c(%ebp)
80100d2f:	53                   	push   %ebx
80100d30:	50                   	push   %eax
80100d31:	56                   	push   %esi
80100d32:	e8 09 6e 00 00       	call   80107b40 <loaduvm>
80100d37:	83 c4 20             	add    $0x20,%esp
80100d3a:	85 c0                	test   %eax,%eax
80100d3c:	0f 89 5e ff ff ff    	jns    80100ca0 <exec+0x290>
80100d42:	89 da                	mov    %ebx,%edx
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100d44:	83 ec 0c             	sub    $0xc,%esp
80100d47:	89 95 94 fe ff ff    	mov    %edx,-0x16c(%ebp)
80100d4d:	56                   	push   %esi
80100d4e:	e8 dd 6f 00 00       	call   80107d30 <freevm>
  if(ip){
80100d53:	8b 95 94 fe ff ff    	mov    -0x16c(%ebp),%edx
80100d59:	83 c4 10             	add    $0x10,%esp
80100d5c:	85 d2                	test   %edx,%edx
80100d5e:	0f 85 ba fe ff ff    	jne    80100c1e <exec+0x20e>
    iunlockput(ip);
    end_op();
  }
  return -1;
}
80100d64:	8d 65 f4             	lea    -0xc(%ebp),%esp
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
    end_op();
  }
  return -1;
80100d67:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100d6c:	5b                   	pop    %ebx
80100d6d:	5e                   	pop    %esi
80100d6e:	5f                   	pop    %edi
80100d6f:	5d                   	pop    %ebp
80100d70:	c3                   	ret    
#include "elf.h"

int get_size_string(char* string){
    int i=0;
    while(1){
        if(string[i]=='\0')
80100d71:	c7 85 94 fe ff ff 00 	movl   $0x0,-0x16c(%ebp)
80100d78:	00 00 00 
80100d7b:	e9 fa fc ff ff       	jmp    80100a7a <exec+0x6a>
  int fsize=get_size_string(path);
  int found=0;//found == 0 if ip not found
  int size=get_size_string(add_path);
  int psize=get_size_string(path);
  int c=0;
  begin_op();
80100d80:	e8 1b 20 00 00       	call   80102da0 <begin_op>
80100d85:	c7 85 88 fe ff ff 00 	movl   $0x0,-0x178(%ebp)
80100d8c:	00 00 00 
80100d8f:	e9 0e fd ff ff       	jmp    80100aa2 <exec+0x92>
#include "elf.h"

int get_size_string(char* string){
    int i=0;
    while(1){
        if(string[i]=='\0')
80100d94:	80 3d 20 0f 11 80 00 	cmpb   $0x0,0x80110f20
80100d9b:	0f 84 9b fe ff ff    	je     80100c3c <exec+0x22c>
#include "defs.h"
#include "x86.h"
#include "elf.h"

int get_size_string(char* string){
    int i=0;
80100da1:	31 f6                	xor    %esi,%esi
80100da3:	e9 ae fc ff ff       	jmp    80100a56 <exec+0x46>
       }
     }
  if(!found){
        if(path[0]!='/'){
	   temp[0]='/';
  	   for (c=0;c<psize;c++){
80100da8:	b8 01 00 00 00       	mov    $0x1,%eax
80100dad:	e9 f4 fd ff ff       	jmp    80100ba6 <exec+0x196>
  if((pgdir = setupkvm()) == 0)
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100db2:	b8 00 20 00 00       	mov    $0x2000,%eax
80100db7:	31 ff                	xor    %edi,%edi
    if(ph.vaddr % PGSIZE != 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100db9:	83 ec 0c             	sub    $0xc,%esp
80100dbc:	89 85 94 fe ff ff    	mov    %eax,-0x16c(%ebp)
80100dc2:	52                   	push   %edx
80100dc3:	e8 88 0d 00 00       	call   80101b50 <iunlockput>
  end_op();
80100dc8:	e8 43 20 00 00       	call   80102e10 <end_op>
  ip = 0;

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100dcd:	8b 85 94 fe ff ff    	mov    -0x16c(%ebp),%eax
80100dd3:	83 c4 0c             	add    $0xc,%esp
80100dd6:	50                   	push   %eax
80100dd7:	57                   	push   %edi
80100dd8:	56                   	push   %esi
80100dd9:	e8 22 6e 00 00       	call   80107c00 <allocuvm>
80100dde:	83 c4 10             	add    $0x10,%esp
80100de1:	85 c0                	test   %eax,%eax
80100de3:	89 85 94 fe ff ff    	mov    %eax,-0x16c(%ebp)
80100de9:	75 20                	jne    80100e0b <exec+0x3fb>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
  end_op();
  ip = 0;
80100deb:	31 d2                	xor    %edx,%edx
80100ded:	e9 52 ff ff ff       	jmp    80100d44 <exec+0x334>
80100df2:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100df8:	89 da                	mov    %ebx,%edx
80100dfa:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100dfd:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100e03:	8d 87 00 20 00 00    	lea    0x2000(%edi),%eax
80100e09:	eb ae                	jmp    80100db9 <exec+0x3a9>
  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100e0b:	8b bd 94 fe ff ff    	mov    -0x16c(%ebp),%edi
80100e11:	83 ec 08             	sub    $0x8,%esp
80100e14:	89 f8                	mov    %edi,%eax
80100e16:	2d 00 20 00 00       	sub    $0x2000,%eax
80100e1b:	50                   	push   %eax
80100e1c:	56                   	push   %esi
80100e1d:	e8 2e 70 00 00       	call   80107e50 <clearpteu>
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100e22:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e25:	83 c4 10             	add    $0x10,%esp
80100e28:	31 d2                	xor    %edx,%edx
80100e2a:	8b 08                	mov    (%eax),%ecx
80100e2c:	85 c9                	test   %ecx,%ecx
80100e2e:	74 6a                	je     80100e9a <exec+0x48a>
80100e30:	89 5d 08             	mov    %ebx,0x8(%ebp)
80100e33:	89 d3                	mov    %edx,%ebx
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100e35:	83 ec 0c             	sub    $0xc,%esp
80100e38:	51                   	push   %ecx
80100e39:	e8 32 46 00 00       	call   80105470 <strlen>
80100e3e:	f7 d0                	not    %eax
80100e40:	01 c7                	add    %eax,%edi
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100e42:	58                   	pop    %eax
80100e43:	8b 45 0c             	mov    0xc(%ebp),%eax

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100e46:	83 e7 fc             	and    $0xfffffffc,%edi
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100e49:	ff 34 98             	pushl  (%eax,%ebx,4)
80100e4c:	e8 1f 46 00 00       	call   80105470 <strlen>
80100e51:	83 c0 01             	add    $0x1,%eax
80100e54:	50                   	push   %eax
80100e55:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e58:	ff 34 98             	pushl  (%eax,%ebx,4)
80100e5b:	57                   	push   %edi
80100e5c:	56                   	push   %esi
80100e5d:	e8 5e 71 00 00       	call   80107fc0 <copyout>
80100e62:	83 c4 20             	add    $0x20,%esp
80100e65:	85 c0                	test   %eax,%eax
80100e67:	78 82                	js     80100deb <exec+0x3db>
      goto bad;
    ustack[3+argc] = sp;
80100e69:	8d 85 58 ff ff ff    	lea    -0xa8(%ebp),%eax
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100e6f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
80100e72:	89 bc 9d 64 ff ff ff 	mov    %edi,-0x9c(%ebp,%ebx,4)
80100e79:	89 85 88 fe ff ff    	mov    %eax,-0x178(%ebp)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100e7f:	8d 43 01             	lea    0x1(%ebx),%eax
80100e82:	8b 0c 81             	mov    (%ecx,%eax,4),%ecx
80100e85:	85 c9                	test   %ecx,%ecx
80100e87:	0f 84 f8 00 00 00    	je     80100f85 <exec+0x575>
    if(argc >= MAXARG)
80100e8d:	83 f8 20             	cmp    $0x20,%eax
80100e90:	0f 84 55 ff ff ff    	je     80100deb <exec+0x3db>
80100e96:	89 c3                	mov    %eax,%ebx
80100e98:	eb 9b                	jmp    80100e35 <exec+0x425>
80100e9a:	8d 85 58 ff ff ff    	lea    -0xa8(%ebp),%eax
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100ea0:	8b bd 94 fe ff ff    	mov    -0x16c(%ebp),%edi
80100ea6:	b9 10 00 00 00       	mov    $0x10,%ecx
80100eab:	ba 04 00 00 00       	mov    $0x4,%edx
80100eb0:	c7 85 8c fe ff ff 03 	movl   $0x3,-0x174(%ebp)
80100eb7:	00 00 00 
80100eba:	c7 85 90 fe ff ff 00 	movl   $0x0,-0x170(%ebp)
80100ec1:	00 00 00 
80100ec4:	89 85 88 fe ff ff    	mov    %eax,-0x178(%ebp)
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100eca:	8b 85 8c fe ff ff    	mov    -0x174(%ebp),%eax
  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100ed0:	51                   	push   %ecx
80100ed1:	ff b5 88 fe ff ff    	pushl  -0x178(%ebp)
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100ed7:	c7 84 85 58 ff ff ff 	movl   $0x0,-0xa8(%ebp,%eax,4)
80100ede:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
80100ee2:	8b 85 90 fe ff ff    	mov    -0x170(%ebp),%eax
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
80100ee8:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100eef:	ff ff ff 
  ustack[1] = argc;
80100ef2:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100ef8:	89 f8                	mov    %edi,%eax

  sp -= (3+argc+1) * 4;
80100efa:	29 cf                	sub    %ecx,%edi
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100efc:	57                   	push   %edi
80100efd:	56                   	push   %esi
  }
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100efe:	29 d0                	sub    %edx,%eax
80100f00:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100f06:	e8 b5 70 00 00       	call   80107fc0 <copyout>
80100f0b:	83 c4 10             	add    $0x10,%esp
80100f0e:	85 c0                	test   %eax,%eax
80100f10:	0f 88 d5 fe ff ff    	js     80100deb <exec+0x3db>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100f16:	0f b6 13             	movzbl (%ebx),%edx
80100f19:	84 d2                	test   %dl,%dl
80100f1b:	74 13                	je     80100f30 <exec+0x520>
80100f1d:	8d 43 01             	lea    0x1(%ebx),%eax
    if(*s == '/')
      last = s+1;
80100f20:	80 fa 2f             	cmp    $0x2f,%dl
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100f23:	0f b6 10             	movzbl (%eax),%edx
    if(*s == '/')
      last = s+1;
80100f26:	0f 44 d8             	cmove  %eax,%ebx
80100f29:	83 c0 01             	add    $0x1,%eax
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100f2c:	84 d2                	test   %dl,%dl
80100f2e:	75 f0                	jne    80100f20 <exec+0x510>
    if(*s == '/')
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100f30:	83 ec 04             	sub    $0x4,%esp
80100f33:	6a 10                	push   $0x10
80100f35:	53                   	push   %ebx
80100f36:	8b 9d 84 fe ff ff    	mov    -0x17c(%ebp),%ebx
80100f3c:	89 d8                	mov    %ebx,%eax
80100f3e:	83 c0 6c             	add    $0x6c,%eax
80100f41:	50                   	push   %eax
80100f42:	e8 e9 44 00 00       	call   80105430 <safestrcpy>

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
80100f47:	89 d8                	mov    %ebx,%eax
80100f49:	8b 5b 04             	mov    0x4(%ebx),%ebx
  curproc->pgdir = pgdir;
80100f4c:	89 70 04             	mov    %esi,0x4(%eax)
  curproc->sz = sz;
80100f4f:	8b b5 94 fe ff ff    	mov    -0x16c(%ebp),%esi
80100f55:	89 30                	mov    %esi,(%eax)
  /*curproc->start = 1;
  curproc->finish = 100000;
  curproc->queuenum = 1;*/
  curproc->tf->eip = elf.entry;  // main
80100f57:	89 c6                	mov    %eax,%esi
80100f59:	8b 95 d8 fe ff ff    	mov    -0x128(%ebp),%edx
80100f5f:	8b 40 18             	mov    0x18(%eax),%eax
80100f62:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100f65:	8b 46 18             	mov    0x18(%esi),%eax
80100f68:	89 78 44             	mov    %edi,0x44(%eax)
  switchuvm(curproc);
80100f6b:	89 34 24             	mov    %esi,(%esp)
80100f6e:	e8 3d 6a 00 00       	call   801079b0 <switchuvm>
  freevm(oldpgdir);
80100f73:	89 1c 24             	mov    %ebx,(%esp)
80100f76:	e8 b5 6d 00 00       	call   80107d30 <freevm>
  return 0;
80100f7b:	83 c4 10             	add    $0x10,%esp
80100f7e:	31 c0                	xor    %eax,%eax
80100f80:	e9 af fc ff ff       	jmp    80100c34 <exec+0x224>
80100f85:	89 da                	mov    %ebx,%edx
80100f87:	89 85 90 fe ff ff    	mov    %eax,-0x170(%ebp)
80100f8d:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100f90:	8d 42 04             	lea    0x4(%edx),%eax
80100f93:	8d 14 95 08 00 00 00 	lea    0x8(,%edx,4),%edx
80100f9a:	89 85 8c fe ff ff    	mov    %eax,-0x174(%ebp)
80100fa0:	8d 4a 0c             	lea    0xc(%edx),%ecx
80100fa3:	e9 22 ff ff ff       	jmp    80100eca <exec+0x4ba>
80100fa8:	66 90                	xchg   %ax,%ax
80100faa:	66 90                	xchg   %ax,%ax
80100fac:	66 90                	xchg   %ax,%ax
80100fae:	66 90                	xchg   %ax,%ax

80100fb0 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100fb0:	55                   	push   %ebp
80100fb1:	89 e5                	mov    %esp,%ebp
80100fb3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100fb6:	68 ed 80 10 80       	push   $0x801080ed
80100fbb:	68 40 10 11 80       	push   $0x80111040
80100fc0:	e8 0b 40 00 00       	call   80104fd0 <initlock>
}
80100fc5:	83 c4 10             	add    $0x10,%esp
80100fc8:	c9                   	leave  
80100fc9:	c3                   	ret    
80100fca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100fd0 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100fd0:	55                   	push   %ebp
80100fd1:	89 e5                	mov    %esp,%ebp
80100fd3:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100fd4:	bb 74 10 11 80       	mov    $0x80111074,%ebx
}

// Allocate a file structure.
struct file*
filealloc(void)
{
80100fd9:	83 ec 10             	sub    $0x10,%esp
  struct file *f;

  acquire(&ftable.lock);
80100fdc:	68 40 10 11 80       	push   $0x80111040
80100fe1:	e8 4a 41 00 00       	call   80105130 <acquire>
80100fe6:	83 c4 10             	add    $0x10,%esp
80100fe9:	eb 10                	jmp    80100ffb <filealloc+0x2b>
80100feb:	90                   	nop
80100fec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100ff0:	83 c3 18             	add    $0x18,%ebx
80100ff3:	81 fb d4 19 11 80    	cmp    $0x801119d4,%ebx
80100ff9:	74 25                	je     80101020 <filealloc+0x50>
    if(f->ref == 0){
80100ffb:	8b 43 04             	mov    0x4(%ebx),%eax
80100ffe:	85 c0                	test   %eax,%eax
80101000:	75 ee                	jne    80100ff0 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80101002:	83 ec 0c             	sub    $0xc,%esp
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    if(f->ref == 0){
      f->ref = 1;
80101005:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
8010100c:	68 40 10 11 80       	push   $0x80111040
80101011:	e8 ca 41 00 00       	call   801051e0 <release>
      return f;
80101016:	89 d8                	mov    %ebx,%eax
80101018:	83 c4 10             	add    $0x10,%esp
    }
  }
  release(&ftable.lock);
  return 0;
}
8010101b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010101e:	c9                   	leave  
8010101f:	c3                   	ret    
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80101020:	83 ec 0c             	sub    $0xc,%esp
80101023:	68 40 10 11 80       	push   $0x80111040
80101028:	e8 b3 41 00 00       	call   801051e0 <release>
  return 0;
8010102d:	83 c4 10             	add    $0x10,%esp
80101030:	31 c0                	xor    %eax,%eax
}
80101032:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101035:	c9                   	leave  
80101036:	c3                   	ret    
80101037:	89 f6                	mov    %esi,%esi
80101039:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101040 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80101040:	55                   	push   %ebp
80101041:	89 e5                	mov    %esp,%ebp
80101043:	53                   	push   %ebx
80101044:	83 ec 10             	sub    $0x10,%esp
80101047:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
8010104a:	68 40 10 11 80       	push   $0x80111040
8010104f:	e8 dc 40 00 00       	call   80105130 <acquire>
  if(f->ref < 1)
80101054:	8b 43 04             	mov    0x4(%ebx),%eax
80101057:	83 c4 10             	add    $0x10,%esp
8010105a:	85 c0                	test   %eax,%eax
8010105c:	7e 1a                	jle    80101078 <filedup+0x38>
    panic("filedup");
  f->ref++;
8010105e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80101061:	83 ec 0c             	sub    $0xc,%esp
filedup(struct file *f)
{
  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("filedup");
  f->ref++;
80101064:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80101067:	68 40 10 11 80       	push   $0x80111040
8010106c:	e8 6f 41 00 00       	call   801051e0 <release>
  return f;
}
80101071:	89 d8                	mov    %ebx,%eax
80101073:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101076:	c9                   	leave  
80101077:	c3                   	ret    
struct file*
filedup(struct file *f)
{
  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("filedup");
80101078:	83 ec 0c             	sub    $0xc,%esp
8010107b:	68 f4 80 10 80       	push   $0x801080f4
80101080:	e8 eb f2 ff ff       	call   80100370 <panic>
80101085:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101089:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101090 <fileclose>:
}

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80101090:	55                   	push   %ebp
80101091:	89 e5                	mov    %esp,%ebp
80101093:	57                   	push   %edi
80101094:	56                   	push   %esi
80101095:	53                   	push   %ebx
80101096:	83 ec 28             	sub    $0x28,%esp
80101099:	8b 7d 08             	mov    0x8(%ebp),%edi
  struct file ff;

  acquire(&ftable.lock);
8010109c:	68 40 10 11 80       	push   $0x80111040
801010a1:	e8 8a 40 00 00       	call   80105130 <acquire>
  if(f->ref < 1)
801010a6:	8b 47 04             	mov    0x4(%edi),%eax
801010a9:	83 c4 10             	add    $0x10,%esp
801010ac:	85 c0                	test   %eax,%eax
801010ae:	0f 8e 9b 00 00 00    	jle    8010114f <fileclose+0xbf>
    panic("fileclose");
  if(--f->ref > 0){
801010b4:	83 e8 01             	sub    $0x1,%eax
801010b7:	85 c0                	test   %eax,%eax
801010b9:	89 47 04             	mov    %eax,0x4(%edi)
801010bc:	74 1a                	je     801010d8 <fileclose+0x48>
    release(&ftable.lock);
801010be:	c7 45 08 40 10 11 80 	movl   $0x80111040,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
801010c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010c8:	5b                   	pop    %ebx
801010c9:	5e                   	pop    %esi
801010ca:	5f                   	pop    %edi
801010cb:	5d                   	pop    %ebp

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
801010cc:	e9 0f 41 00 00       	jmp    801051e0 <release>
801010d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return;
  }
  ff = *f;
801010d8:	0f b6 47 09          	movzbl 0x9(%edi),%eax
801010dc:	8b 1f                	mov    (%edi),%ebx
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
801010de:	83 ec 0c             	sub    $0xc,%esp
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
801010e1:	8b 77 0c             	mov    0xc(%edi),%esi
  f->ref = 0;
  f->type = FD_NONE;
801010e4:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
801010ea:	88 45 e7             	mov    %al,-0x19(%ebp)
801010ed:	8b 47 10             	mov    0x10(%edi),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
801010f0:	68 40 10 11 80       	push   $0x80111040
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
801010f5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
801010f8:	e8 e3 40 00 00       	call   801051e0 <release>

  if(ff.type == FD_PIPE)
801010fd:	83 c4 10             	add    $0x10,%esp
80101100:	83 fb 01             	cmp    $0x1,%ebx
80101103:	74 13                	je     80101118 <fileclose+0x88>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80101105:	83 fb 02             	cmp    $0x2,%ebx
80101108:	74 26                	je     80101130 <fileclose+0xa0>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
8010110a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010110d:	5b                   	pop    %ebx
8010110e:	5e                   	pop    %esi
8010110f:	5f                   	pop    %edi
80101110:	5d                   	pop    %ebp
80101111:	c3                   	ret    
80101112:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);

  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
80101118:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
8010111c:	83 ec 08             	sub    $0x8,%esp
8010111f:	53                   	push   %ebx
80101120:	56                   	push   %esi
80101121:	e8 1a 24 00 00       	call   80103540 <pipeclose>
80101126:	83 c4 10             	add    $0x10,%esp
80101129:	eb df                	jmp    8010110a <fileclose+0x7a>
8010112b:	90                   	nop
8010112c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  else if(ff.type == FD_INODE){
    begin_op();
80101130:	e8 6b 1c 00 00       	call   80102da0 <begin_op>
    iput(ff.ip);
80101135:	83 ec 0c             	sub    $0xc,%esp
80101138:	ff 75 e0             	pushl  -0x20(%ebp)
8010113b:	e8 b0 08 00 00       	call   801019f0 <iput>
    end_op();
80101140:	83 c4 10             	add    $0x10,%esp
  }
}
80101143:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101146:	5b                   	pop    %ebx
80101147:	5e                   	pop    %esi
80101148:	5f                   	pop    %edi
80101149:	5d                   	pop    %ebp
  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
8010114a:	e9 c1 1c 00 00       	jmp    80102e10 <end_op>
{
  struct file ff;

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
8010114f:	83 ec 0c             	sub    $0xc,%esp
80101152:	68 fc 80 10 80       	push   $0x801080fc
80101157:	e8 14 f2 ff ff       	call   80100370 <panic>
8010115c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101160 <filestat>:
}

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80101160:	55                   	push   %ebp
80101161:	89 e5                	mov    %esp,%ebp
80101163:	53                   	push   %ebx
80101164:	83 ec 04             	sub    $0x4,%esp
80101167:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
8010116a:	83 3b 02             	cmpl   $0x2,(%ebx)
8010116d:	75 31                	jne    801011a0 <filestat+0x40>
    ilock(f->ip);
8010116f:	83 ec 0c             	sub    $0xc,%esp
80101172:	ff 73 10             	pushl  0x10(%ebx)
80101175:	e8 46 07 00 00       	call   801018c0 <ilock>
    stati(f->ip, st);
8010117a:	58                   	pop    %eax
8010117b:	5a                   	pop    %edx
8010117c:	ff 75 0c             	pushl  0xc(%ebp)
8010117f:	ff 73 10             	pushl  0x10(%ebx)
80101182:	e8 e9 09 00 00       	call   80101b70 <stati>
    iunlock(f->ip);
80101187:	59                   	pop    %ecx
80101188:	ff 73 10             	pushl  0x10(%ebx)
8010118b:	e8 10 08 00 00       	call   801019a0 <iunlock>
    return 0;
80101190:	83 c4 10             	add    $0x10,%esp
80101193:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80101195:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101198:	c9                   	leave  
80101199:	c3                   	ret    
8010119a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    ilock(f->ip);
    stati(f->ip, st);
    iunlock(f->ip);
    return 0;
  }
  return -1;
801011a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801011a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801011a8:	c9                   	leave  
801011a9:	c3                   	ret    
801011aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801011b0 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
801011b0:	55                   	push   %ebp
801011b1:	89 e5                	mov    %esp,%ebp
801011b3:	57                   	push   %edi
801011b4:	56                   	push   %esi
801011b5:	53                   	push   %ebx
801011b6:	83 ec 0c             	sub    $0xc,%esp
801011b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801011bc:	8b 75 0c             	mov    0xc(%ebp),%esi
801011bf:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
801011c2:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
801011c6:	74 60                	je     80101228 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
801011c8:	8b 03                	mov    (%ebx),%eax
801011ca:	83 f8 01             	cmp    $0x1,%eax
801011cd:	74 41                	je     80101210 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
801011cf:	83 f8 02             	cmp    $0x2,%eax
801011d2:	75 5b                	jne    8010122f <fileread+0x7f>
    ilock(f->ip);
801011d4:	83 ec 0c             	sub    $0xc,%esp
801011d7:	ff 73 10             	pushl  0x10(%ebx)
801011da:	e8 e1 06 00 00       	call   801018c0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
801011df:	57                   	push   %edi
801011e0:	ff 73 14             	pushl  0x14(%ebx)
801011e3:	56                   	push   %esi
801011e4:	ff 73 10             	pushl  0x10(%ebx)
801011e7:	e8 b4 09 00 00       	call   80101ba0 <readi>
801011ec:	83 c4 20             	add    $0x20,%esp
801011ef:	85 c0                	test   %eax,%eax
801011f1:	89 c6                	mov    %eax,%esi
801011f3:	7e 03                	jle    801011f8 <fileread+0x48>
      f->off += r;
801011f5:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
801011f8:	83 ec 0c             	sub    $0xc,%esp
801011fb:	ff 73 10             	pushl  0x10(%ebx)
801011fe:	e8 9d 07 00 00       	call   801019a0 <iunlock>
    return r;
80101203:	83 c4 10             	add    $0x10,%esp
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
    ilock(f->ip);
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80101206:	89 f0                	mov    %esi,%eax
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
80101208:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010120b:	5b                   	pop    %ebx
8010120c:	5e                   	pop    %esi
8010120d:	5f                   	pop    %edi
8010120e:	5d                   	pop    %ebp
8010120f:	c3                   	ret    
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
80101210:	8b 43 0c             	mov    0xc(%ebx),%eax
80101213:	89 45 08             	mov    %eax,0x8(%ebp)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
80101216:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101219:	5b                   	pop    %ebx
8010121a:	5e                   	pop    %esi
8010121b:	5f                   	pop    %edi
8010121c:	5d                   	pop    %ebp
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
8010121d:	e9 be 24 00 00       	jmp    801036e0 <piperead>
80101222:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
fileread(struct file *f, char *addr, int n)
{
  int r;

  if(f->readable == 0)
    return -1;
80101228:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010122d:	eb d9                	jmp    80101208 <fileread+0x58>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
8010122f:	83 ec 0c             	sub    $0xc,%esp
80101232:	68 06 81 10 80       	push   $0x80108106
80101237:	e8 34 f1 ff ff       	call   80100370 <panic>
8010123c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101240 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101240:	55                   	push   %ebp
80101241:	89 e5                	mov    %esp,%ebp
80101243:	57                   	push   %edi
80101244:	56                   	push   %esi
80101245:	53                   	push   %ebx
80101246:	83 ec 1c             	sub    $0x1c,%esp
80101249:	8b 75 08             	mov    0x8(%ebp),%esi
8010124c:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
8010124f:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101253:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101256:	8b 45 10             	mov    0x10(%ebp),%eax
80101259:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int r;

  if(f->writable == 0)
8010125c:	0f 84 aa 00 00 00    	je     8010130c <filewrite+0xcc>
    return -1;
  if(f->type == FD_PIPE)
80101262:	8b 06                	mov    (%esi),%eax
80101264:	83 f8 01             	cmp    $0x1,%eax
80101267:	0f 84 c2 00 00 00    	je     8010132f <filewrite+0xef>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010126d:	83 f8 02             	cmp    $0x2,%eax
80101270:	0f 85 d8 00 00 00    	jne    8010134e <filewrite+0x10e>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101276:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101279:	31 ff                	xor    %edi,%edi
8010127b:	85 c0                	test   %eax,%eax
8010127d:	7f 34                	jg     801012b3 <filewrite+0x73>
8010127f:	e9 9c 00 00 00       	jmp    80101320 <filewrite+0xe0>
80101284:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101288:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
8010128b:	83 ec 0c             	sub    $0xc,%esp
8010128e:	ff 76 10             	pushl  0x10(%esi)
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101291:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101294:	e8 07 07 00 00       	call   801019a0 <iunlock>
      end_op();
80101299:	e8 72 1b 00 00       	call   80102e10 <end_op>
8010129e:	8b 45 e0             	mov    -0x20(%ebp),%eax
801012a1:	83 c4 10             	add    $0x10,%esp

      if(r < 0)
        break;
      if(r != n1)
801012a4:	39 d8                	cmp    %ebx,%eax
801012a6:	0f 85 95 00 00 00    	jne    80101341 <filewrite+0x101>
        panic("short filewrite");
      i += r;
801012ac:	01 c7                	add    %eax,%edi
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801012ae:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801012b1:	7e 6d                	jle    80101320 <filewrite+0xe0>
      int n1 = n - i;
801012b3:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801012b6:	b8 00 06 00 00       	mov    $0x600,%eax
801012bb:	29 fb                	sub    %edi,%ebx
801012bd:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
801012c3:	0f 4f d8             	cmovg  %eax,%ebx
      if(n1 > max)
        n1 = max;

      begin_op();
801012c6:	e8 d5 1a 00 00       	call   80102da0 <begin_op>
      ilock(f->ip);
801012cb:	83 ec 0c             	sub    $0xc,%esp
801012ce:	ff 76 10             	pushl  0x10(%esi)
801012d1:	e8 ea 05 00 00       	call   801018c0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
801012d6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801012d9:	53                   	push   %ebx
801012da:	ff 76 14             	pushl  0x14(%esi)
801012dd:	01 f8                	add    %edi,%eax
801012df:	50                   	push   %eax
801012e0:	ff 76 10             	pushl  0x10(%esi)
801012e3:	e8 b8 09 00 00       	call   80101ca0 <writei>
801012e8:	83 c4 20             	add    $0x20,%esp
801012eb:	85 c0                	test   %eax,%eax
801012ed:	7f 99                	jg     80101288 <filewrite+0x48>
        f->off += r;
      iunlock(f->ip);
801012ef:	83 ec 0c             	sub    $0xc,%esp
801012f2:	ff 76 10             	pushl  0x10(%esi)
801012f5:	89 45 e0             	mov    %eax,-0x20(%ebp)
801012f8:	e8 a3 06 00 00       	call   801019a0 <iunlock>
      end_op();
801012fd:	e8 0e 1b 00 00       	call   80102e10 <end_op>

      if(r < 0)
80101302:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101305:	83 c4 10             	add    $0x10,%esp
80101308:	85 c0                	test   %eax,%eax
8010130a:	74 98                	je     801012a4 <filewrite+0x64>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
8010130c:	8d 65 f4             	lea    -0xc(%ebp),%esp
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
8010130f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
80101314:	5b                   	pop    %ebx
80101315:	5e                   	pop    %esi
80101316:	5f                   	pop    %edi
80101317:	5d                   	pop    %ebp
80101318:	c3                   	ret    
80101319:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
80101320:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
80101323:	75 e7                	jne    8010130c <filewrite+0xcc>
  }
  panic("filewrite");
}
80101325:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101328:	89 f8                	mov    %edi,%eax
8010132a:	5b                   	pop    %ebx
8010132b:	5e                   	pop    %esi
8010132c:	5f                   	pop    %edi
8010132d:	5d                   	pop    %ebp
8010132e:	c3                   	ret    
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
8010132f:	8b 46 0c             	mov    0xc(%esi),%eax
80101332:	89 45 08             	mov    %eax,0x8(%ebp)
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
80101335:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101338:	5b                   	pop    %ebx
80101339:	5e                   	pop    %esi
8010133a:	5f                   	pop    %edi
8010133b:	5d                   	pop    %ebp
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
8010133c:	e9 9f 22 00 00       	jmp    801035e0 <pipewrite>
      end_op();

      if(r < 0)
        break;
      if(r != n1)
        panic("short filewrite");
80101341:	83 ec 0c             	sub    $0xc,%esp
80101344:	68 0f 81 10 80       	push   $0x8010810f
80101349:	e8 22 f0 ff ff       	call   80100370 <panic>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
8010134e:	83 ec 0c             	sub    $0xc,%esp
80101351:	68 15 81 10 80       	push   $0x80108115
80101356:	e8 15 f0 ff ff       	call   80100370 <panic>
8010135b:	66 90                	xchg   %ax,%ax
8010135d:	66 90                	xchg   %ax,%ax
8010135f:	90                   	nop

80101360 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101360:	55                   	push   %ebp
80101361:	89 e5                	mov    %esp,%ebp
80101363:	56                   	push   %esi
80101364:	53                   	push   %ebx
80101365:	89 d3                	mov    %edx,%ebx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
80101367:	c1 ea 0c             	shr    $0xc,%edx
8010136a:	03 15 58 1a 11 80    	add    0x80111a58,%edx
80101370:	83 ec 08             	sub    $0x8,%esp
80101373:	52                   	push   %edx
80101374:	50                   	push   %eax
80101375:	e8 56 ed ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
8010137a:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
8010137c:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
80101382:	ba 01 00 00 00       	mov    $0x1,%edx
80101387:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
8010138a:	c1 fb 03             	sar    $0x3,%ebx
8010138d:	83 c4 10             	add    $0x10,%esp
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
80101390:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101392:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
80101397:	85 d1                	test   %edx,%ecx
80101399:	74 27                	je     801013c2 <bfree+0x62>
8010139b:	89 c6                	mov    %eax,%esi
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
8010139d:	f7 d2                	not    %edx
8010139f:	89 c8                	mov    %ecx,%eax
  log_write(bp);
801013a1:	83 ec 0c             	sub    $0xc,%esp
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
801013a4:	21 d0                	and    %edx,%eax
801013a6:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
801013aa:	56                   	push   %esi
801013ab:	e8 d0 1b 00 00       	call   80102f80 <log_write>
  brelse(bp);
801013b0:	89 34 24             	mov    %esi,(%esp)
801013b3:	e8 28 ee ff ff       	call   801001e0 <brelse>
}
801013b8:	83 c4 10             	add    $0x10,%esp
801013bb:	8d 65 f8             	lea    -0x8(%ebp),%esp
801013be:	5b                   	pop    %ebx
801013bf:	5e                   	pop    %esi
801013c0:	5d                   	pop    %ebp
801013c1:	c3                   	ret    

  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
    panic("freeing free block");
801013c2:	83 ec 0c             	sub    $0xc,%esp
801013c5:	68 1f 81 10 80       	push   $0x8010811f
801013ca:	e8 a1 ef ff ff       	call   80100370 <panic>
801013cf:	90                   	nop

801013d0 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801013d0:	55                   	push   %ebp
801013d1:	89 e5                	mov    %esp,%ebp
801013d3:	57                   	push   %edi
801013d4:	56                   	push   %esi
801013d5:	53                   	push   %ebx
801013d6:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
801013d9:	8b 0d 40 1a 11 80    	mov    0x80111a40,%ecx
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801013df:	89 45 d8             	mov    %eax,-0x28(%ebp)
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
801013e2:	85 c9                	test   %ecx,%ecx
801013e4:	0f 84 85 00 00 00    	je     8010146f <balloc+0x9f>
801013ea:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
801013f1:	8b 75 dc             	mov    -0x24(%ebp),%esi
801013f4:	83 ec 08             	sub    $0x8,%esp
801013f7:	89 f0                	mov    %esi,%eax
801013f9:	c1 f8 0c             	sar    $0xc,%eax
801013fc:	03 05 58 1a 11 80    	add    0x80111a58,%eax
80101402:	50                   	push   %eax
80101403:	ff 75 d8             	pushl  -0x28(%ebp)
80101406:	e8 c5 ec ff ff       	call   801000d0 <bread>
8010140b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010140e:	a1 40 1a 11 80       	mov    0x80111a40,%eax
80101413:	83 c4 10             	add    $0x10,%esp
80101416:	89 45 e0             	mov    %eax,-0x20(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101419:	31 c0                	xor    %eax,%eax
8010141b:	eb 2d                	jmp    8010144a <balloc+0x7a>
8010141d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101420:	89 c1                	mov    %eax,%ecx
80101422:	ba 01 00 00 00       	mov    $0x1,%edx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101427:	8b 5d e4             	mov    -0x1c(%ebp),%ebx

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
8010142a:	83 e1 07             	and    $0x7,%ecx
8010142d:	d3 e2                	shl    %cl,%edx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010142f:	89 c1                	mov    %eax,%ecx
80101431:	c1 f9 03             	sar    $0x3,%ecx
80101434:	0f b6 7c 0b 5c       	movzbl 0x5c(%ebx,%ecx,1),%edi
80101439:	85 d7                	test   %edx,%edi
8010143b:	74 43                	je     80101480 <balloc+0xb0>
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010143d:	83 c0 01             	add    $0x1,%eax
80101440:	83 c6 01             	add    $0x1,%esi
80101443:	3d 00 10 00 00       	cmp    $0x1000,%eax
80101448:	74 05                	je     8010144f <balloc+0x7f>
8010144a:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010144d:	72 d1                	jb     80101420 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
8010144f:	83 ec 0c             	sub    $0xc,%esp
80101452:	ff 75 e4             	pushl  -0x1c(%ebp)
80101455:	e8 86 ed ff ff       	call   801001e0 <brelse>
{
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
8010145a:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101461:	83 c4 10             	add    $0x10,%esp
80101464:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101467:	39 05 40 1a 11 80    	cmp    %eax,0x80111a40
8010146d:	77 82                	ja     801013f1 <balloc+0x21>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
8010146f:	83 ec 0c             	sub    $0xc,%esp
80101472:	68 32 81 10 80       	push   $0x80108132
80101477:	e8 f4 ee ff ff       	call   80100370 <panic>
8010147c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
        bp->data[bi/8] |= m;  // Mark block in use.
80101480:	09 fa                	or     %edi,%edx
80101482:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101485:	83 ec 0c             	sub    $0xc,%esp
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
        bp->data[bi/8] |= m;  // Mark block in use.
80101488:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010148c:	57                   	push   %edi
8010148d:	e8 ee 1a 00 00       	call   80102f80 <log_write>
        brelse(bp);
80101492:	89 3c 24             	mov    %edi,(%esp)
80101495:	e8 46 ed ff ff       	call   801001e0 <brelse>
static void
bzero(int dev, int bno)
{
  struct buf *bp;

  bp = bread(dev, bno);
8010149a:	58                   	pop    %eax
8010149b:	5a                   	pop    %edx
8010149c:	56                   	push   %esi
8010149d:	ff 75 d8             	pushl  -0x28(%ebp)
801014a0:	e8 2b ec ff ff       	call   801000d0 <bread>
801014a5:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801014a7:	8d 40 5c             	lea    0x5c(%eax),%eax
801014aa:	83 c4 0c             	add    $0xc,%esp
801014ad:	68 00 02 00 00       	push   $0x200
801014b2:	6a 00                	push   $0x0
801014b4:	50                   	push   %eax
801014b5:	e8 76 3d 00 00       	call   80105230 <memset>
  log_write(bp);
801014ba:	89 1c 24             	mov    %ebx,(%esp)
801014bd:	e8 be 1a 00 00       	call   80102f80 <log_write>
  brelse(bp);
801014c2:	89 1c 24             	mov    %ebx,(%esp)
801014c5:	e8 16 ed ff ff       	call   801001e0 <brelse>
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
}
801014ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014cd:	89 f0                	mov    %esi,%eax
801014cf:	5b                   	pop    %ebx
801014d0:	5e                   	pop    %esi
801014d1:	5f                   	pop    %edi
801014d2:	5d                   	pop    %ebp
801014d3:	c3                   	ret    
801014d4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801014da:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801014e0 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801014e0:	55                   	push   %ebp
801014e1:	89 e5                	mov    %esp,%ebp
801014e3:	57                   	push   %edi
801014e4:	56                   	push   %esi
801014e5:	53                   	push   %ebx
801014e6:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
801014e8:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801014ea:	bb 94 1a 11 80       	mov    $0x80111a94,%ebx
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801014ef:	83 ec 28             	sub    $0x28,%esp
801014f2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  struct inode *ip, *empty;

  acquire(&icache.lock);
801014f5:	68 60 1a 11 80       	push   $0x80111a60
801014fa:	e8 31 3c 00 00       	call   80105130 <acquire>
801014ff:	83 c4 10             	add    $0x10,%esp

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101502:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101505:	eb 1b                	jmp    80101522 <iget+0x42>
80101507:	89 f6                	mov    %esi,%esi
80101509:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101510:	85 f6                	test   %esi,%esi
80101512:	74 44                	je     80101558 <iget+0x78>

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101514:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010151a:	81 fb b4 36 11 80    	cmp    $0x801136b4,%ebx
80101520:	74 4e                	je     80101570 <iget+0x90>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101522:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101525:	85 c9                	test   %ecx,%ecx
80101527:	7e e7                	jle    80101510 <iget+0x30>
80101529:	39 3b                	cmp    %edi,(%ebx)
8010152b:	75 e3                	jne    80101510 <iget+0x30>
8010152d:	39 53 04             	cmp    %edx,0x4(%ebx)
80101530:	75 de                	jne    80101510 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
80101532:	83 ec 0c             	sub    $0xc,%esp

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
80101535:	83 c1 01             	add    $0x1,%ecx
      release(&icache.lock);
      return ip;
80101538:	89 de                	mov    %ebx,%esi
  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
8010153a:	68 60 1a 11 80       	push   $0x80111a60

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
8010153f:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
80101542:	e8 99 3c 00 00       	call   801051e0 <release>
      return ip;
80101547:	83 c4 10             	add    $0x10,%esp
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);

  return ip;
}
8010154a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010154d:	89 f0                	mov    %esi,%eax
8010154f:	5b                   	pop    %ebx
80101550:	5e                   	pop    %esi
80101551:	5f                   	pop    %edi
80101552:	5d                   	pop    %ebp
80101553:	c3                   	ret    
80101554:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101558:	85 c9                	test   %ecx,%ecx
8010155a:	0f 44 f3             	cmove  %ebx,%esi

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010155d:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101563:	81 fb b4 36 11 80    	cmp    $0x801136b4,%ebx
80101569:	75 b7                	jne    80101522 <iget+0x42>
8010156b:	90                   	nop
8010156c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101570:	85 f6                	test   %esi,%esi
80101572:	74 2d                	je     801015a1 <iget+0xc1>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
80101574:	83 ec 0c             	sub    $0xc,%esp
  // Recycle an inode cache entry.
  if(empty == 0)
    panic("iget: no inodes");

  ip = empty;
  ip->dev = dev;
80101577:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101579:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
8010157c:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
80101583:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
8010158a:	68 60 1a 11 80       	push   $0x80111a60
8010158f:	e8 4c 3c 00 00       	call   801051e0 <release>

  return ip;
80101594:	83 c4 10             	add    $0x10,%esp
}
80101597:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010159a:	89 f0                	mov    %esi,%eax
8010159c:	5b                   	pop    %ebx
8010159d:	5e                   	pop    %esi
8010159e:	5f                   	pop    %edi
8010159f:	5d                   	pop    %ebp
801015a0:	c3                   	ret    
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
    panic("iget: no inodes");
801015a1:	83 ec 0c             	sub    $0xc,%esp
801015a4:	68 48 81 10 80       	push   $0x80108148
801015a9:	e8 c2 ed ff ff       	call   80100370 <panic>
801015ae:	66 90                	xchg   %ax,%ax

801015b0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801015b0:	55                   	push   %ebp
801015b1:	89 e5                	mov    %esp,%ebp
801015b3:	57                   	push   %edi
801015b4:	56                   	push   %esi
801015b5:	53                   	push   %ebx
801015b6:	89 c6                	mov    %eax,%esi
801015b8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801015bb:	83 fa 0b             	cmp    $0xb,%edx
801015be:	77 18                	ja     801015d8 <bmap+0x28>
801015c0:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
    if((addr = ip->addrs[bn]) == 0)
801015c3:	8b 43 5c             	mov    0x5c(%ebx),%eax
801015c6:	85 c0                	test   %eax,%eax
801015c8:	74 76                	je     80101640 <bmap+0x90>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
801015ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
801015cd:	5b                   	pop    %ebx
801015ce:	5e                   	pop    %esi
801015cf:	5f                   	pop    %edi
801015d0:	5d                   	pop    %ebp
801015d1:	c3                   	ret    
801015d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
801015d8:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
801015db:	83 fb 7f             	cmp    $0x7f,%ebx
801015de:	0f 87 83 00 00 00    	ja     80101667 <bmap+0xb7>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
801015e4:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
801015ea:	85 c0                	test   %eax,%eax
801015ec:	74 6a                	je     80101658 <bmap+0xa8>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
801015ee:	83 ec 08             	sub    $0x8,%esp
801015f1:	50                   	push   %eax
801015f2:	ff 36                	pushl  (%esi)
801015f4:	e8 d7 ea ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
801015f9:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
801015fd:	83 c4 10             	add    $0x10,%esp

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
80101600:	89 c7                	mov    %eax,%edi
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101602:	8b 1a                	mov    (%edx),%ebx
80101604:	85 db                	test   %ebx,%ebx
80101606:	75 1d                	jne    80101625 <bmap+0x75>
      a[bn] = addr = balloc(ip->dev);
80101608:	8b 06                	mov    (%esi),%eax
8010160a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010160d:	e8 be fd ff ff       	call   801013d0 <balloc>
80101612:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
80101615:	83 ec 0c             	sub    $0xc,%esp
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
      a[bn] = addr = balloc(ip->dev);
80101618:	89 c3                	mov    %eax,%ebx
8010161a:	89 02                	mov    %eax,(%edx)
      log_write(bp);
8010161c:	57                   	push   %edi
8010161d:	e8 5e 19 00 00       	call   80102f80 <log_write>
80101622:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
80101625:	83 ec 0c             	sub    $0xc,%esp
80101628:	57                   	push   %edi
80101629:	e8 b2 eb ff ff       	call   801001e0 <brelse>
8010162e:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
80101631:	8d 65 f4             	lea    -0xc(%ebp),%esp
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101634:	89 d8                	mov    %ebx,%eax
    return addr;
  }

  panic("bmap: out of range");
}
80101636:	5b                   	pop    %ebx
80101637:	5e                   	pop    %esi
80101638:	5f                   	pop    %edi
80101639:	5d                   	pop    %ebp
8010163a:	c3                   	ret    
8010163b:	90                   	nop
8010163c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
80101640:	8b 06                	mov    (%esi),%eax
80101642:	e8 89 fd ff ff       	call   801013d0 <balloc>
80101647:	89 43 5c             	mov    %eax,0x5c(%ebx)
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010164a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010164d:	5b                   	pop    %ebx
8010164e:	5e                   	pop    %esi
8010164f:	5f                   	pop    %edi
80101650:	5d                   	pop    %ebp
80101651:	c3                   	ret    
80101652:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  bn -= NDIRECT;

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101658:	8b 06                	mov    (%esi),%eax
8010165a:	e8 71 fd ff ff       	call   801013d0 <balloc>
8010165f:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
80101665:	eb 87                	jmp    801015ee <bmap+0x3e>
    }
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
80101667:	83 ec 0c             	sub    $0xc,%esp
8010166a:	68 58 81 10 80       	push   $0x80108158
8010166f:	e8 fc ec ff ff       	call   80100370 <panic>
80101674:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010167a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101680 <readsb>:
struct superblock sb; 

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
80101680:	55                   	push   %ebp
80101681:	89 e5                	mov    %esp,%ebp
80101683:	56                   	push   %esi
80101684:	53                   	push   %ebx
80101685:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct buf *bp;

  bp = bread(dev, 1);
80101688:	83 ec 08             	sub    $0x8,%esp
8010168b:	6a 01                	push   $0x1
8010168d:	ff 75 08             	pushl  0x8(%ebp)
80101690:	e8 3b ea ff ff       	call   801000d0 <bread>
80101695:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101697:	8d 40 5c             	lea    0x5c(%eax),%eax
8010169a:	83 c4 0c             	add    $0xc,%esp
8010169d:	6a 1c                	push   $0x1c
8010169f:	50                   	push   %eax
801016a0:	56                   	push   %esi
801016a1:	e8 3a 3c 00 00       	call   801052e0 <memmove>
  brelse(bp);
801016a6:	89 5d 08             	mov    %ebx,0x8(%ebp)
801016a9:	83 c4 10             	add    $0x10,%esp
}
801016ac:	8d 65 f8             	lea    -0x8(%ebp),%esp
801016af:	5b                   	pop    %ebx
801016b0:	5e                   	pop    %esi
801016b1:	5d                   	pop    %ebp
{
  struct buf *bp;

  bp = bread(dev, 1);
  memmove(sb, bp->data, sizeof(*sb));
  brelse(bp);
801016b2:	e9 29 eb ff ff       	jmp    801001e0 <brelse>
801016b7:	89 f6                	mov    %esi,%esi
801016b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801016c0 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
801016c0:	55                   	push   %ebp
801016c1:	89 e5                	mov    %esp,%ebp
801016c3:	53                   	push   %ebx
801016c4:	bb a0 1a 11 80       	mov    $0x80111aa0,%ebx
801016c9:	83 ec 0c             	sub    $0xc,%esp
  int i = 0;
  
  initlock(&icache.lock, "icache");
801016cc:	68 6b 81 10 80       	push   $0x8010816b
801016d1:	68 60 1a 11 80       	push   $0x80111a60
801016d6:	e8 f5 38 00 00       	call   80104fd0 <initlock>
801016db:	83 c4 10             	add    $0x10,%esp
801016de:	66 90                	xchg   %ax,%ax
  for(i = 0; i < NINODE; i++) {
    initsleeplock(&icache.inode[i].lock, "inode");
801016e0:	83 ec 08             	sub    $0x8,%esp
801016e3:	68 72 81 10 80       	push   $0x80108172
801016e8:	53                   	push   %ebx
801016e9:	81 c3 90 00 00 00    	add    $0x90,%ebx
801016ef:	e8 ac 37 00 00       	call   80104ea0 <initsleeplock>
iinit(int dev)
{
  int i = 0;
  
  initlock(&icache.lock, "icache");
  for(i = 0; i < NINODE; i++) {
801016f4:	83 c4 10             	add    $0x10,%esp
801016f7:	81 fb c0 36 11 80    	cmp    $0x801136c0,%ebx
801016fd:	75 e1                	jne    801016e0 <iinit+0x20>
    initsleeplock(&icache.inode[i].lock, "inode");
  }

  readsb(dev, &sb);
801016ff:	83 ec 08             	sub    $0x8,%esp
80101702:	68 40 1a 11 80       	push   $0x80111a40
80101707:	ff 75 08             	pushl  0x8(%ebp)
8010170a:	e8 71 ff ff ff       	call   80101680 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
8010170f:	ff 35 58 1a 11 80    	pushl  0x80111a58
80101715:	ff 35 54 1a 11 80    	pushl  0x80111a54
8010171b:	ff 35 50 1a 11 80    	pushl  0x80111a50
80101721:	ff 35 4c 1a 11 80    	pushl  0x80111a4c
80101727:	ff 35 48 1a 11 80    	pushl  0x80111a48
8010172d:	ff 35 44 1a 11 80    	pushl  0x80111a44
80101733:	ff 35 40 1a 11 80    	pushl  0x80111a40
80101739:	68 d8 81 10 80       	push   $0x801081d8
8010173e:	e8 1d ef ff ff       	call   80100660 <cprintf>
 inodestart %d bmap start %d\n", sb.size, sb.nblocks,
          sb.ninodes, sb.nlog, sb.logstart, sb.inodestart,
          sb.bmapstart);
}
80101743:	83 c4 30             	add    $0x30,%esp
80101746:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101749:	c9                   	leave  
8010174a:	c3                   	ret    
8010174b:	90                   	nop
8010174c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101750 <ialloc>:
// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode.
struct inode*
ialloc(uint dev, short type)
{
80101750:	55                   	push   %ebp
80101751:	89 e5                	mov    %esp,%ebp
80101753:	57                   	push   %edi
80101754:	56                   	push   %esi
80101755:	53                   	push   %ebx
80101756:	83 ec 1c             	sub    $0x1c,%esp
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101759:	83 3d 48 1a 11 80 01 	cmpl   $0x1,0x80111a48
// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode.
struct inode*
ialloc(uint dev, short type)
{
80101760:	8b 45 0c             	mov    0xc(%ebp),%eax
80101763:	8b 75 08             	mov    0x8(%ebp),%esi
80101766:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101769:	0f 86 91 00 00 00    	jbe    80101800 <ialloc+0xb0>
8010176f:	bb 01 00 00 00       	mov    $0x1,%ebx
80101774:	eb 21                	jmp    80101797 <ialloc+0x47>
80101776:	8d 76 00             	lea    0x0(%esi),%esi
80101779:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
80101780:	83 ec 0c             	sub    $0xc,%esp
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101783:	83 c3 01             	add    $0x1,%ebx
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
80101786:	57                   	push   %edi
80101787:	e8 54 ea ff ff       	call   801001e0 <brelse>
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
8010178c:	83 c4 10             	add    $0x10,%esp
8010178f:	39 1d 48 1a 11 80    	cmp    %ebx,0x80111a48
80101795:	76 69                	jbe    80101800 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101797:	89 d8                	mov    %ebx,%eax
80101799:	83 ec 08             	sub    $0x8,%esp
8010179c:	c1 e8 03             	shr    $0x3,%eax
8010179f:	03 05 54 1a 11 80    	add    0x80111a54,%eax
801017a5:	50                   	push   %eax
801017a6:	56                   	push   %esi
801017a7:	e8 24 e9 ff ff       	call   801000d0 <bread>
801017ac:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
801017ae:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
801017b0:	83 c4 10             	add    $0x10,%esp
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
    bp = bread(dev, IBLOCK(inum, sb));
    dip = (struct dinode*)bp->data + inum%IPB;
801017b3:	83 e0 07             	and    $0x7,%eax
801017b6:	c1 e0 06             	shl    $0x6,%eax
801017b9:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
801017bd:	66 83 39 00          	cmpw   $0x0,(%ecx)
801017c1:	75 bd                	jne    80101780 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
801017c3:	83 ec 04             	sub    $0x4,%esp
801017c6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801017c9:	6a 40                	push   $0x40
801017cb:	6a 00                	push   $0x0
801017cd:	51                   	push   %ecx
801017ce:	e8 5d 3a 00 00       	call   80105230 <memset>
      dip->type = type;
801017d3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801017d7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801017da:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801017dd:	89 3c 24             	mov    %edi,(%esp)
801017e0:	e8 9b 17 00 00       	call   80102f80 <log_write>
      brelse(bp);
801017e5:	89 3c 24             	mov    %edi,(%esp)
801017e8:	e8 f3 e9 ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
801017ed:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
801017f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
801017f3:	89 da                	mov    %ebx,%edx
801017f5:	89 f0                	mov    %esi,%eax
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
801017f7:	5b                   	pop    %ebx
801017f8:	5e                   	pop    %esi
801017f9:	5f                   	pop    %edi
801017fa:	5d                   	pop    %ebp
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
801017fb:	e9 e0 fc ff ff       	jmp    801014e0 <iget>
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
80101800:	83 ec 0c             	sub    $0xc,%esp
80101803:	68 78 81 10 80       	push   $0x80108178
80101808:	e8 63 eb ff ff       	call   80100370 <panic>
8010180d:	8d 76 00             	lea    0x0(%esi),%esi

80101810 <iupdate>:
// Must be called after every change to an ip->xxx field
// that lives on disk, since i-node cache is write-through.
// Caller must hold ip->lock.
void
iupdate(struct inode *ip)
{
80101810:	55                   	push   %ebp
80101811:	89 e5                	mov    %esp,%ebp
80101813:	56                   	push   %esi
80101814:	53                   	push   %ebx
80101815:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101818:	83 ec 08             	sub    $0x8,%esp
8010181b:	8b 43 04             	mov    0x4(%ebx),%eax
  dip->type = ip->type;
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010181e:	83 c3 5c             	add    $0x5c,%ebx
iupdate(struct inode *ip)
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101821:	c1 e8 03             	shr    $0x3,%eax
80101824:	03 05 54 1a 11 80    	add    0x80111a54,%eax
8010182a:	50                   	push   %eax
8010182b:	ff 73 a4             	pushl  -0x5c(%ebx)
8010182e:	e8 9d e8 ff ff       	call   801000d0 <bread>
80101833:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101835:	8b 43 a8             	mov    -0x58(%ebx),%eax
  dip->type = ip->type;
80101838:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010183c:	83 c4 0c             	add    $0xc,%esp
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010183f:	83 e0 07             	and    $0x7,%eax
80101842:	c1 e0 06             	shl    $0x6,%eax
80101845:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101849:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010184c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101850:	83 c0 0c             	add    $0xc,%eax
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
  dip = (struct dinode*)bp->data + ip->inum%IPB;
  dip->type = ip->type;
  dip->major = ip->major;
80101853:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101857:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010185b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010185f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101863:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101867:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010186a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010186d:	6a 34                	push   $0x34
8010186f:	53                   	push   %ebx
80101870:	50                   	push   %eax
80101871:	e8 6a 3a 00 00       	call   801052e0 <memmove>
  log_write(bp);
80101876:	89 34 24             	mov    %esi,(%esp)
80101879:	e8 02 17 00 00       	call   80102f80 <log_write>
  brelse(bp);
8010187e:	89 75 08             	mov    %esi,0x8(%ebp)
80101881:	83 c4 10             	add    $0x10,%esp
}
80101884:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101887:	5b                   	pop    %ebx
80101888:	5e                   	pop    %esi
80101889:	5d                   	pop    %ebp
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
  log_write(bp);
  brelse(bp);
8010188a:	e9 51 e9 ff ff       	jmp    801001e0 <brelse>
8010188f:	90                   	nop

80101890 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
80101890:	55                   	push   %ebp
80101891:	89 e5                	mov    %esp,%ebp
80101893:	53                   	push   %ebx
80101894:	83 ec 10             	sub    $0x10,%esp
80101897:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010189a:	68 60 1a 11 80       	push   $0x80111a60
8010189f:	e8 8c 38 00 00       	call   80105130 <acquire>
  ip->ref++;
801018a4:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
801018a8:	c7 04 24 60 1a 11 80 	movl   $0x80111a60,(%esp)
801018af:	e8 2c 39 00 00       	call   801051e0 <release>
  return ip;
}
801018b4:	89 d8                	mov    %ebx,%eax
801018b6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801018b9:	c9                   	leave  
801018ba:	c3                   	ret    
801018bb:	90                   	nop
801018bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801018c0 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
801018c0:	55                   	push   %ebp
801018c1:	89 e5                	mov    %esp,%ebp
801018c3:	56                   	push   %esi
801018c4:	53                   	push   %ebx
801018c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
801018c8:	85 db                	test   %ebx,%ebx
801018ca:	0f 84 b7 00 00 00    	je     80101987 <ilock+0xc7>
801018d0:	8b 53 08             	mov    0x8(%ebx),%edx
801018d3:	85 d2                	test   %edx,%edx
801018d5:	0f 8e ac 00 00 00    	jle    80101987 <ilock+0xc7>
    panic("ilock");

  acquiresleep(&ip->lock);
801018db:	8d 43 0c             	lea    0xc(%ebx),%eax
801018de:	83 ec 0c             	sub    $0xc,%esp
801018e1:	50                   	push   %eax
801018e2:	e8 f9 35 00 00       	call   80104ee0 <acquiresleep>

  if(ip->valid == 0){
801018e7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801018ea:	83 c4 10             	add    $0x10,%esp
801018ed:	85 c0                	test   %eax,%eax
801018ef:	74 0f                	je     80101900 <ilock+0x40>
    brelse(bp);
    ip->valid = 1;
    if(ip->type == 0)
      panic("ilock: no type");
  }
}
801018f1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801018f4:	5b                   	pop    %ebx
801018f5:	5e                   	pop    %esi
801018f6:	5d                   	pop    %ebp
801018f7:	c3                   	ret    
801018f8:	90                   	nop
801018f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    panic("ilock");

  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101900:	8b 43 04             	mov    0x4(%ebx),%eax
80101903:	83 ec 08             	sub    $0x8,%esp
80101906:	c1 e8 03             	shr    $0x3,%eax
80101909:	03 05 54 1a 11 80    	add    0x80111a54,%eax
8010190f:	50                   	push   %eax
80101910:	ff 33                	pushl  (%ebx)
80101912:	e8 b9 e7 ff ff       	call   801000d0 <bread>
80101917:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101919:	8b 43 04             	mov    0x4(%ebx),%eax
    ip->type = dip->type;
    ip->major = dip->major;
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010191c:	83 c4 0c             	add    $0xc,%esp

  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    dip = (struct dinode*)bp->data + ip->inum%IPB;
8010191f:	83 e0 07             	and    $0x7,%eax
80101922:	c1 e0 06             	shl    $0x6,%eax
80101925:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101929:	0f b7 10             	movzwl (%eax),%edx
    ip->major = dip->major;
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010192c:	83 c0 0c             	add    $0xc,%eax
  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    ip->type = dip->type;
8010192f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101933:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101937:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010193b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010193f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101943:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101947:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010194b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010194e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101951:	6a 34                	push   $0x34
80101953:	50                   	push   %eax
80101954:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101957:	50                   	push   %eax
80101958:	e8 83 39 00 00       	call   801052e0 <memmove>
    brelse(bp);
8010195d:	89 34 24             	mov    %esi,(%esp)
80101960:	e8 7b e8 ff ff       	call   801001e0 <brelse>
    ip->valid = 1;
    if(ip->type == 0)
80101965:	83 c4 10             	add    $0x10,%esp
80101968:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    brelse(bp);
    ip->valid = 1;
8010196d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101974:	0f 85 77 ff ff ff    	jne    801018f1 <ilock+0x31>
      panic("ilock: no type");
8010197a:	83 ec 0c             	sub    $0xc,%esp
8010197d:	68 90 81 10 80       	push   $0x80108190
80101982:	e8 e9 e9 ff ff       	call   80100370 <panic>
{
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
    panic("ilock");
80101987:	83 ec 0c             	sub    $0xc,%esp
8010198a:	68 8a 81 10 80       	push   $0x8010818a
8010198f:	e8 dc e9 ff ff       	call   80100370 <panic>
80101994:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010199a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801019a0 <iunlock>:
}

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
801019a0:	55                   	push   %ebp
801019a1:	89 e5                	mov    %esp,%ebp
801019a3:	56                   	push   %esi
801019a4:	53                   	push   %ebx
801019a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801019a8:	85 db                	test   %ebx,%ebx
801019aa:	74 28                	je     801019d4 <iunlock+0x34>
801019ac:	8d 73 0c             	lea    0xc(%ebx),%esi
801019af:	83 ec 0c             	sub    $0xc,%esp
801019b2:	56                   	push   %esi
801019b3:	e8 c8 35 00 00       	call   80104f80 <holdingsleep>
801019b8:	83 c4 10             	add    $0x10,%esp
801019bb:	85 c0                	test   %eax,%eax
801019bd:	74 15                	je     801019d4 <iunlock+0x34>
801019bf:	8b 43 08             	mov    0x8(%ebx),%eax
801019c2:	85 c0                	test   %eax,%eax
801019c4:	7e 0e                	jle    801019d4 <iunlock+0x34>
    panic("iunlock");

  releasesleep(&ip->lock);
801019c6:	89 75 08             	mov    %esi,0x8(%ebp)
}
801019c9:	8d 65 f8             	lea    -0x8(%ebp),%esp
801019cc:	5b                   	pop    %ebx
801019cd:	5e                   	pop    %esi
801019ce:	5d                   	pop    %ebp
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");

  releasesleep(&ip->lock);
801019cf:	e9 6c 35 00 00       	jmp    80104f40 <releasesleep>
// Unlock the given inode.
void
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");
801019d4:	83 ec 0c             	sub    $0xc,%esp
801019d7:	68 9f 81 10 80       	push   $0x8010819f
801019dc:	e8 8f e9 ff ff       	call   80100370 <panic>
801019e1:	eb 0d                	jmp    801019f0 <iput>
801019e3:	90                   	nop
801019e4:	90                   	nop
801019e5:	90                   	nop
801019e6:	90                   	nop
801019e7:	90                   	nop
801019e8:	90                   	nop
801019e9:	90                   	nop
801019ea:	90                   	nop
801019eb:	90                   	nop
801019ec:	90                   	nop
801019ed:	90                   	nop
801019ee:	90                   	nop
801019ef:	90                   	nop

801019f0 <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
801019f0:	55                   	push   %ebp
801019f1:	89 e5                	mov    %esp,%ebp
801019f3:	57                   	push   %edi
801019f4:	56                   	push   %esi
801019f5:	53                   	push   %ebx
801019f6:	83 ec 28             	sub    $0x28,%esp
801019f9:	8b 75 08             	mov    0x8(%ebp),%esi
  acquiresleep(&ip->lock);
801019fc:	8d 7e 0c             	lea    0xc(%esi),%edi
801019ff:	57                   	push   %edi
80101a00:	e8 db 34 00 00       	call   80104ee0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101a05:	8b 56 4c             	mov    0x4c(%esi),%edx
80101a08:	83 c4 10             	add    $0x10,%esp
80101a0b:	85 d2                	test   %edx,%edx
80101a0d:	74 07                	je     80101a16 <iput+0x26>
80101a0f:	66 83 7e 56 00       	cmpw   $0x0,0x56(%esi)
80101a14:	74 32                	je     80101a48 <iput+0x58>
      ip->type = 0;
      iupdate(ip);
      ip->valid = 0;
    }
  }
  releasesleep(&ip->lock);
80101a16:	83 ec 0c             	sub    $0xc,%esp
80101a19:	57                   	push   %edi
80101a1a:	e8 21 35 00 00       	call   80104f40 <releasesleep>

  acquire(&icache.lock);
80101a1f:	c7 04 24 60 1a 11 80 	movl   $0x80111a60,(%esp)
80101a26:	e8 05 37 00 00       	call   80105130 <acquire>
  ip->ref--;
80101a2b:	83 6e 08 01          	subl   $0x1,0x8(%esi)
  release(&icache.lock);
80101a2f:	83 c4 10             	add    $0x10,%esp
80101a32:	c7 45 08 60 1a 11 80 	movl   $0x80111a60,0x8(%ebp)
}
80101a39:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a3c:	5b                   	pop    %ebx
80101a3d:	5e                   	pop    %esi
80101a3e:	5f                   	pop    %edi
80101a3f:	5d                   	pop    %ebp
  }
  releasesleep(&ip->lock);

  acquire(&icache.lock);
  ip->ref--;
  release(&icache.lock);
80101a40:	e9 9b 37 00 00       	jmp    801051e0 <release>
80101a45:	8d 76 00             	lea    0x0(%esi),%esi
void
iput(struct inode *ip)
{
  acquiresleep(&ip->lock);
  if(ip->valid && ip->nlink == 0){
    acquire(&icache.lock);
80101a48:	83 ec 0c             	sub    $0xc,%esp
80101a4b:	68 60 1a 11 80       	push   $0x80111a60
80101a50:	e8 db 36 00 00       	call   80105130 <acquire>
    int r = ip->ref;
80101a55:	8b 5e 08             	mov    0x8(%esi),%ebx
    release(&icache.lock);
80101a58:	c7 04 24 60 1a 11 80 	movl   $0x80111a60,(%esp)
80101a5f:	e8 7c 37 00 00       	call   801051e0 <release>
    if(r == 1){
80101a64:	83 c4 10             	add    $0x10,%esp
80101a67:	83 fb 01             	cmp    $0x1,%ebx
80101a6a:	75 aa                	jne    80101a16 <iput+0x26>
80101a6c:	8d 8e 8c 00 00 00    	lea    0x8c(%esi),%ecx
80101a72:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101a75:	8d 5e 5c             	lea    0x5c(%esi),%ebx
80101a78:	89 cf                	mov    %ecx,%edi
80101a7a:	eb 0b                	jmp    80101a87 <iput+0x97>
80101a7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101a80:	83 c3 04             	add    $0x4,%ebx
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101a83:	39 fb                	cmp    %edi,%ebx
80101a85:	74 19                	je     80101aa0 <iput+0xb0>
    if(ip->addrs[i]){
80101a87:	8b 13                	mov    (%ebx),%edx
80101a89:	85 d2                	test   %edx,%edx
80101a8b:	74 f3                	je     80101a80 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
80101a8d:	8b 06                	mov    (%esi),%eax
80101a8f:	e8 cc f8 ff ff       	call   80101360 <bfree>
      ip->addrs[i] = 0;
80101a94:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80101a9a:	eb e4                	jmp    80101a80 <iput+0x90>
80101a9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101aa0:	8b 86 8c 00 00 00    	mov    0x8c(%esi),%eax
80101aa6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101aa9:	85 c0                	test   %eax,%eax
80101aab:	75 33                	jne    80101ae0 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80101aad:	83 ec 0c             	sub    $0xc,%esp
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
80101ab0:	c7 46 58 00 00 00 00 	movl   $0x0,0x58(%esi)
  iupdate(ip);
80101ab7:	56                   	push   %esi
80101ab8:	e8 53 fd ff ff       	call   80101810 <iupdate>
    int r = ip->ref;
    release(&icache.lock);
    if(r == 1){
      // inode has no links and no other references: truncate and free.
      itrunc(ip);
      ip->type = 0;
80101abd:	31 c0                	xor    %eax,%eax
80101abf:	66 89 46 50          	mov    %ax,0x50(%esi)
      iupdate(ip);
80101ac3:	89 34 24             	mov    %esi,(%esp)
80101ac6:	e8 45 fd ff ff       	call   80101810 <iupdate>
      ip->valid = 0;
80101acb:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
80101ad2:	83 c4 10             	add    $0x10,%esp
80101ad5:	e9 3c ff ff ff       	jmp    80101a16 <iput+0x26>
80101ada:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[i] = 0;
    }
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101ae0:	83 ec 08             	sub    $0x8,%esp
80101ae3:	50                   	push   %eax
80101ae4:	ff 36                	pushl  (%esi)
80101ae6:	e8 e5 e5 ff ff       	call   801000d0 <bread>
80101aeb:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101af1:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101af4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
80101af7:	8d 58 5c             	lea    0x5c(%eax),%ebx
80101afa:	83 c4 10             	add    $0x10,%esp
80101afd:	89 cf                	mov    %ecx,%edi
80101aff:	eb 0e                	jmp    80101b0f <iput+0x11f>
80101b01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b08:	83 c3 04             	add    $0x4,%ebx
    for(j = 0; j < NINDIRECT; j++){
80101b0b:	39 fb                	cmp    %edi,%ebx
80101b0d:	74 0f                	je     80101b1e <iput+0x12e>
      if(a[j])
80101b0f:	8b 13                	mov    (%ebx),%edx
80101b11:	85 d2                	test   %edx,%edx
80101b13:	74 f3                	je     80101b08 <iput+0x118>
        bfree(ip->dev, a[j]);
80101b15:	8b 06                	mov    (%esi),%eax
80101b17:	e8 44 f8 ff ff       	call   80101360 <bfree>
80101b1c:	eb ea                	jmp    80101b08 <iput+0x118>
    }
    brelse(bp);
80101b1e:	83 ec 0c             	sub    $0xc,%esp
80101b21:	ff 75 e4             	pushl  -0x1c(%ebp)
80101b24:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101b27:	e8 b4 e6 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101b2c:	8b 96 8c 00 00 00    	mov    0x8c(%esi),%edx
80101b32:	8b 06                	mov    (%esi),%eax
80101b34:	e8 27 f8 ff ff       	call   80101360 <bfree>
    ip->addrs[NDIRECT] = 0;
80101b39:	c7 86 8c 00 00 00 00 	movl   $0x0,0x8c(%esi)
80101b40:	00 00 00 
80101b43:	83 c4 10             	add    $0x10,%esp
80101b46:	e9 62 ff ff ff       	jmp    80101aad <iput+0xbd>
80101b4b:	90                   	nop
80101b4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101b50 <iunlockput>:
}

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101b50:	55                   	push   %ebp
80101b51:	89 e5                	mov    %esp,%ebp
80101b53:	53                   	push   %ebx
80101b54:	83 ec 10             	sub    $0x10,%esp
80101b57:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
80101b5a:	53                   	push   %ebx
80101b5b:	e8 40 fe ff ff       	call   801019a0 <iunlock>
  iput(ip);
80101b60:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101b63:	83 c4 10             	add    $0x10,%esp
}
80101b66:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101b69:	c9                   	leave  
// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
  iput(ip);
80101b6a:	e9 81 fe ff ff       	jmp    801019f0 <iput>
80101b6f:	90                   	nop

80101b70 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101b70:	55                   	push   %ebp
80101b71:	89 e5                	mov    %esp,%ebp
80101b73:	8b 55 08             	mov    0x8(%ebp),%edx
80101b76:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101b79:	8b 0a                	mov    (%edx),%ecx
80101b7b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101b7e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101b81:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101b84:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101b88:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101b8b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101b8f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101b93:	8b 52 58             	mov    0x58(%edx),%edx
80101b96:	89 50 10             	mov    %edx,0x10(%eax)
}
80101b99:	5d                   	pop    %ebp
80101b9a:	c3                   	ret    
80101b9b:	90                   	nop
80101b9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101ba0 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101ba0:	55                   	push   %ebp
80101ba1:	89 e5                	mov    %esp,%ebp
80101ba3:	57                   	push   %edi
80101ba4:	56                   	push   %esi
80101ba5:	53                   	push   %ebx
80101ba6:	83 ec 1c             	sub    $0x1c,%esp
80101ba9:	8b 45 08             	mov    0x8(%ebp),%eax
80101bac:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101baf:	8b 75 10             	mov    0x10(%ebp),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101bb2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101bb7:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101bba:	8b 7d 14             	mov    0x14(%ebp),%edi
80101bbd:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101bc0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101bc3:	0f 84 a7 00 00 00    	je     80101c70 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101bc9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101bcc:	8b 40 58             	mov    0x58(%eax),%eax
80101bcf:	39 f0                	cmp    %esi,%eax
80101bd1:	0f 82 c1 00 00 00    	jb     80101c98 <readi+0xf8>
80101bd7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101bda:	89 fa                	mov    %edi,%edx
80101bdc:	01 f2                	add    %esi,%edx
80101bde:	0f 82 b4 00 00 00    	jb     80101c98 <readi+0xf8>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101be4:	89 c1                	mov    %eax,%ecx
80101be6:	29 f1                	sub    %esi,%ecx
80101be8:	39 d0                	cmp    %edx,%eax
80101bea:	0f 43 cf             	cmovae %edi,%ecx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101bed:	31 ff                	xor    %edi,%edi
80101bef:	85 c9                	test   %ecx,%ecx
  }

  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101bf1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101bf4:	74 6d                	je     80101c63 <readi+0xc3>
80101bf6:	8d 76 00             	lea    0x0(%esi),%esi
80101bf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c00:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101c03:	89 f2                	mov    %esi,%edx
80101c05:	c1 ea 09             	shr    $0x9,%edx
80101c08:	89 d8                	mov    %ebx,%eax
80101c0a:	e8 a1 f9 ff ff       	call   801015b0 <bmap>
80101c0f:	83 ec 08             	sub    $0x8,%esp
80101c12:	50                   	push   %eax
80101c13:	ff 33                	pushl  (%ebx)
    m = min(n - tot, BSIZE - off%BSIZE);
80101c15:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c1a:	e8 b1 e4 ff ff       	call   801000d0 <bread>
80101c1f:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101c21:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101c24:	89 f1                	mov    %esi,%ecx
80101c26:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
80101c2c:	83 c4 0c             	add    $0xc,%esp
    memmove(dst, bp->data + off%BSIZE, m);
80101c2f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80101c32:	29 cb                	sub    %ecx,%ebx
80101c34:	29 f8                	sub    %edi,%eax
80101c36:	39 c3                	cmp    %eax,%ebx
80101c38:	0f 47 d8             	cmova  %eax,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101c3b:	8d 44 0a 5c          	lea    0x5c(%edx,%ecx,1),%eax
80101c3f:	53                   	push   %ebx
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101c40:	01 df                	add    %ebx,%edi
80101c42:	01 de                	add    %ebx,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
80101c44:	50                   	push   %eax
80101c45:	ff 75 e0             	pushl  -0x20(%ebp)
80101c48:	e8 93 36 00 00       	call   801052e0 <memmove>
    brelse(bp);
80101c4d:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101c50:	89 14 24             	mov    %edx,(%esp)
80101c53:	e8 88 e5 ff ff       	call   801001e0 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101c58:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101c5b:	83 c4 10             	add    $0x10,%esp
80101c5e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101c61:	77 9d                	ja     80101c00 <readi+0x60>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
80101c63:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101c66:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c69:	5b                   	pop    %ebx
80101c6a:	5e                   	pop    %esi
80101c6b:	5f                   	pop    %edi
80101c6c:	5d                   	pop    %ebp
80101c6d:	c3                   	ret    
80101c6e:	66 90                	xchg   %ax,%ax
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101c70:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101c74:	66 83 f8 09          	cmp    $0x9,%ax
80101c78:	77 1e                	ja     80101c98 <readi+0xf8>
80101c7a:	8b 04 c5 e0 19 11 80 	mov    -0x7feee620(,%eax,8),%eax
80101c81:	85 c0                	test   %eax,%eax
80101c83:	74 13                	je     80101c98 <readi+0xf8>
      return -1;
    return devsw[ip->major].read(ip, dst, n);
80101c85:	89 7d 10             	mov    %edi,0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
}
80101c88:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c8b:	5b                   	pop    %ebx
80101c8c:	5e                   	pop    %esi
80101c8d:	5f                   	pop    %edi
80101c8e:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
80101c8f:	ff e0                	jmp    *%eax
80101c91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
80101c98:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101c9d:	eb c7                	jmp    80101c66 <readi+0xc6>
80101c9f:	90                   	nop

80101ca0 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101ca0:	55                   	push   %ebp
80101ca1:	89 e5                	mov    %esp,%ebp
80101ca3:	57                   	push   %edi
80101ca4:	56                   	push   %esi
80101ca5:	53                   	push   %ebx
80101ca6:	83 ec 1c             	sub    $0x1c,%esp
80101ca9:	8b 45 08             	mov    0x8(%ebp),%eax
80101cac:	8b 75 0c             	mov    0xc(%ebp),%esi
80101caf:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101cb2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101cb7:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101cba:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101cbd:	8b 75 10             	mov    0x10(%ebp),%esi
80101cc0:	89 7d e0             	mov    %edi,-0x20(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101cc3:	0f 84 b7 00 00 00    	je     80101d80 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101cc9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101ccc:	39 70 58             	cmp    %esi,0x58(%eax)
80101ccf:	0f 82 eb 00 00 00    	jb     80101dc0 <writei+0x120>
80101cd5:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101cd8:	89 f8                	mov    %edi,%eax
80101cda:	01 f0                	add    %esi,%eax
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101cdc:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101ce1:	0f 87 d9 00 00 00    	ja     80101dc0 <writei+0x120>
80101ce7:	39 c6                	cmp    %eax,%esi
80101ce9:	0f 87 d1 00 00 00    	ja     80101dc0 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101cef:	85 ff                	test   %edi,%edi
80101cf1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101cf8:	74 78                	je     80101d72 <writei+0xd2>
80101cfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101d00:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101d03:	89 f2                	mov    %esi,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101d05:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101d0a:	c1 ea 09             	shr    $0x9,%edx
80101d0d:	89 f8                	mov    %edi,%eax
80101d0f:	e8 9c f8 ff ff       	call   801015b0 <bmap>
80101d14:	83 ec 08             	sub    $0x8,%esp
80101d17:	50                   	push   %eax
80101d18:	ff 37                	pushl  (%edi)
80101d1a:	e8 b1 e3 ff ff       	call   801000d0 <bread>
80101d1f:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101d21:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101d24:	2b 45 e4             	sub    -0x1c(%ebp),%eax
80101d27:	89 f1                	mov    %esi,%ecx
80101d29:	83 c4 0c             	add    $0xc,%esp
80101d2c:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
80101d32:	29 cb                	sub    %ecx,%ebx
80101d34:	39 c3                	cmp    %eax,%ebx
80101d36:	0f 47 d8             	cmova  %eax,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101d39:	8d 44 0f 5c          	lea    0x5c(%edi,%ecx,1),%eax
80101d3d:	53                   	push   %ebx
80101d3e:	ff 75 dc             	pushl  -0x24(%ebp)
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101d41:	01 de                	add    %ebx,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(bp->data + off%BSIZE, src, m);
80101d43:	50                   	push   %eax
80101d44:	e8 97 35 00 00       	call   801052e0 <memmove>
    log_write(bp);
80101d49:	89 3c 24             	mov    %edi,(%esp)
80101d4c:	e8 2f 12 00 00       	call   80102f80 <log_write>
    brelse(bp);
80101d51:	89 3c 24             	mov    %edi,(%esp)
80101d54:	e8 87 e4 ff ff       	call   801001e0 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101d59:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101d5c:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101d5f:	83 c4 10             	add    $0x10,%esp
80101d62:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101d65:	39 55 e0             	cmp    %edx,-0x20(%ebp)
80101d68:	77 96                	ja     80101d00 <writei+0x60>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
80101d6a:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101d6d:	3b 70 58             	cmp    0x58(%eax),%esi
80101d70:	77 36                	ja     80101da8 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101d72:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101d75:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d78:	5b                   	pop    %ebx
80101d79:	5e                   	pop    %esi
80101d7a:	5f                   	pop    %edi
80101d7b:	5d                   	pop    %ebp
80101d7c:	c3                   	ret    
80101d7d:	8d 76 00             	lea    0x0(%esi),%esi
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101d80:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101d84:	66 83 f8 09          	cmp    $0x9,%ax
80101d88:	77 36                	ja     80101dc0 <writei+0x120>
80101d8a:	8b 04 c5 e4 19 11 80 	mov    -0x7feee61c(,%eax,8),%eax
80101d91:	85 c0                	test   %eax,%eax
80101d93:	74 2b                	je     80101dc0 <writei+0x120>
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101d95:	89 7d 10             	mov    %edi,0x10(%ebp)
  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
}
80101d98:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d9b:	5b                   	pop    %ebx
80101d9c:	5e                   	pop    %esi
80101d9d:	5f                   	pop    %edi
80101d9e:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101d9f:	ff e0                	jmp    *%eax
80101da1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
    ip->size = off;
80101da8:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101dab:	83 ec 0c             	sub    $0xc,%esp
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
    ip->size = off;
80101dae:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101db1:	50                   	push   %eax
80101db2:	e8 59 fa ff ff       	call   80101810 <iupdate>
80101db7:	83 c4 10             	add    $0x10,%esp
80101dba:	eb b6                	jmp    80101d72 <writei+0xd2>
80101dbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
80101dc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101dc5:	eb ae                	jmp    80101d75 <writei+0xd5>
80101dc7:	89 f6                	mov    %esi,%esi
80101dc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101dd0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101dd0:	55                   	push   %ebp
80101dd1:	89 e5                	mov    %esp,%ebp
80101dd3:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101dd6:	6a 0e                	push   $0xe
80101dd8:	ff 75 0c             	pushl  0xc(%ebp)
80101ddb:	ff 75 08             	pushl  0x8(%ebp)
80101dde:	e8 7d 35 00 00       	call   80105360 <strncmp>
}
80101de3:	c9                   	leave  
80101de4:	c3                   	ret    
80101de5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101de9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101df0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101df0:	55                   	push   %ebp
80101df1:	89 e5                	mov    %esp,%ebp
80101df3:	57                   	push   %edi
80101df4:	56                   	push   %esi
80101df5:	53                   	push   %ebx
80101df6:	83 ec 1c             	sub    $0x1c,%esp
80101df9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101dfc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101e01:	0f 85 80 00 00 00    	jne    80101e87 <dirlookup+0x97>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101e07:	8b 53 58             	mov    0x58(%ebx),%edx
80101e0a:	31 ff                	xor    %edi,%edi
80101e0c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e0f:	85 d2                	test   %edx,%edx
80101e11:	75 0d                	jne    80101e20 <dirlookup+0x30>
80101e13:	eb 5b                	jmp    80101e70 <dirlookup+0x80>
80101e15:	8d 76 00             	lea    0x0(%esi),%esi
80101e18:	83 c7 10             	add    $0x10,%edi
80101e1b:	39 7b 58             	cmp    %edi,0x58(%ebx)
80101e1e:	76 50                	jbe    80101e70 <dirlookup+0x80>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e20:	6a 10                	push   $0x10
80101e22:	57                   	push   %edi
80101e23:	56                   	push   %esi
80101e24:	53                   	push   %ebx
80101e25:	e8 76 fd ff ff       	call   80101ba0 <readi>
80101e2a:	83 c4 10             	add    $0x10,%esp
80101e2d:	83 f8 10             	cmp    $0x10,%eax
80101e30:	75 48                	jne    80101e7a <dirlookup+0x8a>
      panic("dirlookup read");
    if(de.inum == 0)
80101e32:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101e37:	74 df                	je     80101e18 <dirlookup+0x28>
// Directories

int
namecmp(const char *s, const char *t)
{
  return strncmp(s, t, DIRSIZ);
80101e39:	8d 45 da             	lea    -0x26(%ebp),%eax
80101e3c:	83 ec 04             	sub    $0x4,%esp
80101e3f:	6a 0e                	push   $0xe
80101e41:	50                   	push   %eax
80101e42:	ff 75 0c             	pushl  0xc(%ebp)
80101e45:	e8 16 35 00 00       	call   80105360 <strncmp>
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlookup read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
80101e4a:	83 c4 10             	add    $0x10,%esp
80101e4d:	85 c0                	test   %eax,%eax
80101e4f:	75 c7                	jne    80101e18 <dirlookup+0x28>
      // entry matches path element
      if(poff)
80101e51:	8b 45 10             	mov    0x10(%ebp),%eax
80101e54:	85 c0                	test   %eax,%eax
80101e56:	74 05                	je     80101e5d <dirlookup+0x6d>
        *poff = off;
80101e58:	8b 45 10             	mov    0x10(%ebp),%eax
80101e5b:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
      return iget(dp->dev, inum);
80101e5d:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
80101e61:	8b 03                	mov    (%ebx),%eax
80101e63:	e8 78 f6 ff ff       	call   801014e0 <iget>
    }
  }

  return 0;
}
80101e68:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e6b:	5b                   	pop    %ebx
80101e6c:	5e                   	pop    %esi
80101e6d:	5f                   	pop    %edi
80101e6e:	5d                   	pop    %ebp
80101e6f:	c3                   	ret    
80101e70:	8d 65 f4             	lea    -0xc(%ebp),%esp
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
80101e73:	31 c0                	xor    %eax,%eax
}
80101e75:	5b                   	pop    %ebx
80101e76:	5e                   	pop    %esi
80101e77:	5f                   	pop    %edi
80101e78:	5d                   	pop    %ebp
80101e79:	c3                   	ret    
  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlookup read");
80101e7a:	83 ec 0c             	sub    $0xc,%esp
80101e7d:	68 b9 81 10 80       	push   $0x801081b9
80101e82:	e8 e9 e4 ff ff       	call   80100370 <panic>
{
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");
80101e87:	83 ec 0c             	sub    $0xc,%esp
80101e8a:	68 a7 81 10 80       	push   $0x801081a7
80101e8f:	e8 dc e4 ff ff       	call   80100370 <panic>
80101e94:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101e9a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101ea0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101ea0:	55                   	push   %ebp
80101ea1:	89 e5                	mov    %esp,%ebp
80101ea3:	57                   	push   %edi
80101ea4:	56                   	push   %esi
80101ea5:	53                   	push   %ebx
80101ea6:	89 cf                	mov    %ecx,%edi
80101ea8:	89 c3                	mov    %eax,%ebx
80101eaa:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101ead:	80 38 2f             	cmpb   $0x2f,(%eax)
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101eb0:	89 55 e0             	mov    %edx,-0x20(%ebp)
  struct inode *ip, *next;

  if(*path == '/')
80101eb3:	0f 84 53 01 00 00    	je     8010200c <namex+0x16c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101eb9:	e8 72 1b 00 00       	call   80103a30 <myproc>
// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
  acquire(&icache.lock);
80101ebe:	83 ec 0c             	sub    $0xc,%esp
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101ec1:	8b 70 68             	mov    0x68(%eax),%esi
// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
  acquire(&icache.lock);
80101ec4:	68 60 1a 11 80       	push   $0x80111a60
80101ec9:	e8 62 32 00 00       	call   80105130 <acquire>
  ip->ref++;
80101ece:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101ed2:	c7 04 24 60 1a 11 80 	movl   $0x80111a60,(%esp)
80101ed9:	e8 02 33 00 00       	call   801051e0 <release>
80101ede:	83 c4 10             	add    $0x10,%esp
80101ee1:	eb 08                	jmp    80101eeb <namex+0x4b>
80101ee3:	90                   	nop
80101ee4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  char *s;
  int len;

  while(*path == '/')
    path++;
80101ee8:	83 c3 01             	add    $0x1,%ebx
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
80101eeb:	0f b6 03             	movzbl (%ebx),%eax
80101eee:	3c 2f                	cmp    $0x2f,%al
80101ef0:	74 f6                	je     80101ee8 <namex+0x48>
    path++;
  if(*path == 0)
80101ef2:	84 c0                	test   %al,%al
80101ef4:	0f 84 e3 00 00 00    	je     80101fdd <namex+0x13d>
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101efa:	0f b6 03             	movzbl (%ebx),%eax
80101efd:	89 da                	mov    %ebx,%edx
80101eff:	84 c0                	test   %al,%al
80101f01:	0f 84 ac 00 00 00    	je     80101fb3 <namex+0x113>
80101f07:	3c 2f                	cmp    $0x2f,%al
80101f09:	75 09                	jne    80101f14 <namex+0x74>
80101f0b:	e9 a3 00 00 00       	jmp    80101fb3 <namex+0x113>
80101f10:	84 c0                	test   %al,%al
80101f12:	74 0a                	je     80101f1e <namex+0x7e>
    path++;
80101f14:	83 c2 01             	add    $0x1,%edx
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101f17:	0f b6 02             	movzbl (%edx),%eax
80101f1a:	3c 2f                	cmp    $0x2f,%al
80101f1c:	75 f2                	jne    80101f10 <namex+0x70>
80101f1e:	89 d1                	mov    %edx,%ecx
80101f20:	29 d9                	sub    %ebx,%ecx
    path++;
  len = path - s;
  if(len >= DIRSIZ)
80101f22:	83 f9 0d             	cmp    $0xd,%ecx
80101f25:	0f 8e 8d 00 00 00    	jle    80101fb8 <namex+0x118>
    memmove(name, s, DIRSIZ);
80101f2b:	83 ec 04             	sub    $0x4,%esp
80101f2e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101f31:	6a 0e                	push   $0xe
80101f33:	53                   	push   %ebx
80101f34:	57                   	push   %edi
80101f35:	e8 a6 33 00 00       	call   801052e0 <memmove>
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
80101f3a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
80101f3d:	83 c4 10             	add    $0x10,%esp
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
80101f40:	89 d3                	mov    %edx,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80101f42:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101f45:	75 11                	jne    80101f58 <namex+0xb8>
80101f47:	89 f6                	mov    %esi,%esi
80101f49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80101f50:	83 c3 01             	add    $0x1,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80101f53:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101f56:	74 f8                	je     80101f50 <namex+0xb0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101f58:	83 ec 0c             	sub    $0xc,%esp
80101f5b:	56                   	push   %esi
80101f5c:	e8 5f f9 ff ff       	call   801018c0 <ilock>
    if(ip->type != T_DIR){
80101f61:	83 c4 10             	add    $0x10,%esp
80101f64:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101f69:	0f 85 7f 00 00 00    	jne    80101fee <namex+0x14e>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101f6f:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101f72:	85 d2                	test   %edx,%edx
80101f74:	74 09                	je     80101f7f <namex+0xdf>
80101f76:	80 3b 00             	cmpb   $0x0,(%ebx)
80101f79:	0f 84 a3 00 00 00    	je     80102022 <namex+0x182>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101f7f:	83 ec 04             	sub    $0x4,%esp
80101f82:	6a 00                	push   $0x0
80101f84:	57                   	push   %edi
80101f85:	56                   	push   %esi
80101f86:	e8 65 fe ff ff       	call   80101df0 <dirlookup>
80101f8b:	83 c4 10             	add    $0x10,%esp
80101f8e:	85 c0                	test   %eax,%eax
80101f90:	74 5c                	je     80101fee <namex+0x14e>

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80101f92:	83 ec 0c             	sub    $0xc,%esp
80101f95:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101f98:	56                   	push   %esi
80101f99:	e8 02 fa ff ff       	call   801019a0 <iunlock>
  iput(ip);
80101f9e:	89 34 24             	mov    %esi,(%esp)
80101fa1:	e8 4a fa ff ff       	call   801019f0 <iput>
80101fa6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101fa9:	83 c4 10             	add    $0x10,%esp
80101fac:	89 c6                	mov    %eax,%esi
80101fae:	e9 38 ff ff ff       	jmp    80101eeb <namex+0x4b>
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101fb3:	31 c9                	xor    %ecx,%ecx
80101fb5:	8d 76 00             	lea    0x0(%esi),%esi
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
80101fb8:	83 ec 04             	sub    $0x4,%esp
80101fbb:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101fbe:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101fc1:	51                   	push   %ecx
80101fc2:	53                   	push   %ebx
80101fc3:	57                   	push   %edi
80101fc4:	e8 17 33 00 00       	call   801052e0 <memmove>
    name[len] = 0;
80101fc9:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101fcc:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101fcf:	83 c4 10             	add    $0x10,%esp
80101fd2:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101fd6:	89 d3                	mov    %edx,%ebx
80101fd8:	e9 65 ff ff ff       	jmp    80101f42 <namex+0xa2>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101fdd:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101fe0:	85 c0                	test   %eax,%eax
80101fe2:	75 54                	jne    80102038 <namex+0x198>
80101fe4:	89 f0                	mov    %esi,%eax
    iput(ip);
    return 0;
  }
  return ip;
}
80101fe6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fe9:	5b                   	pop    %ebx
80101fea:	5e                   	pop    %esi
80101feb:	5f                   	pop    %edi
80101fec:	5d                   	pop    %ebp
80101fed:	c3                   	ret    

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80101fee:	83 ec 0c             	sub    $0xc,%esp
80101ff1:	56                   	push   %esi
80101ff2:	e8 a9 f9 ff ff       	call   801019a0 <iunlock>
  iput(ip);
80101ff7:	89 34 24             	mov    %esi,(%esp)
80101ffa:	e8 f1 f9 ff ff       	call   801019f0 <iput>
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
80101fff:	83 c4 10             	add    $0x10,%esp
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80102002:	8d 65 f4             	lea    -0xc(%ebp),%esp
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
80102005:	31 c0                	xor    %eax,%eax
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80102007:	5b                   	pop    %ebx
80102008:	5e                   	pop    %esi
80102009:	5f                   	pop    %edi
8010200a:	5d                   	pop    %ebp
8010200b:	c3                   	ret    
namex(char *path, int nameiparent, char *name)
{
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
8010200c:	ba 01 00 00 00       	mov    $0x1,%edx
80102011:	b8 01 00 00 00       	mov    $0x1,%eax
80102016:	e8 c5 f4 ff ff       	call   801014e0 <iget>
8010201b:	89 c6                	mov    %eax,%esi
8010201d:	e9 c9 fe ff ff       	jmp    80101eeb <namex+0x4b>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
80102022:	83 ec 0c             	sub    $0xc,%esp
80102025:	56                   	push   %esi
80102026:	e8 75 f9 ff ff       	call   801019a0 <iunlock>
      return ip;
8010202b:	83 c4 10             	add    $0x10,%esp
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
8010202e:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
      return ip;
80102031:	89 f0                	mov    %esi,%eax
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80102033:	5b                   	pop    %ebx
80102034:	5e                   	pop    %esi
80102035:	5f                   	pop    %edi
80102036:	5d                   	pop    %ebp
80102037:	c3                   	ret    
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
    iput(ip);
80102038:	83 ec 0c             	sub    $0xc,%esp
8010203b:	56                   	push   %esi
8010203c:	e8 af f9 ff ff       	call   801019f0 <iput>
    return 0;
80102041:	83 c4 10             	add    $0x10,%esp
80102044:	31 c0                	xor    %eax,%eax
80102046:	eb 9e                	jmp    80101fe6 <namex+0x146>
80102048:	90                   	nop
80102049:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102050 <dirlink>:
}

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
80102050:	55                   	push   %ebp
80102051:	89 e5                	mov    %esp,%ebp
80102053:	57                   	push   %edi
80102054:	56                   	push   %esi
80102055:	53                   	push   %ebx
80102056:	83 ec 20             	sub    $0x20,%esp
80102059:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
8010205c:	6a 00                	push   $0x0
8010205e:	ff 75 0c             	pushl  0xc(%ebp)
80102061:	53                   	push   %ebx
80102062:	e8 89 fd ff ff       	call   80101df0 <dirlookup>
80102067:	83 c4 10             	add    $0x10,%esp
8010206a:	85 c0                	test   %eax,%eax
8010206c:	75 67                	jne    801020d5 <dirlink+0x85>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
8010206e:	8b 7b 58             	mov    0x58(%ebx),%edi
80102071:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102074:	85 ff                	test   %edi,%edi
80102076:	74 29                	je     801020a1 <dirlink+0x51>
80102078:	31 ff                	xor    %edi,%edi
8010207a:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010207d:	eb 09                	jmp    80102088 <dirlink+0x38>
8010207f:	90                   	nop
80102080:	83 c7 10             	add    $0x10,%edi
80102083:	39 7b 58             	cmp    %edi,0x58(%ebx)
80102086:	76 19                	jbe    801020a1 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102088:	6a 10                	push   $0x10
8010208a:	57                   	push   %edi
8010208b:	56                   	push   %esi
8010208c:	53                   	push   %ebx
8010208d:	e8 0e fb ff ff       	call   80101ba0 <readi>
80102092:	83 c4 10             	add    $0x10,%esp
80102095:	83 f8 10             	cmp    $0x10,%eax
80102098:	75 4e                	jne    801020e8 <dirlink+0x98>
      panic("dirlink read");
    if(de.inum == 0)
8010209a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010209f:	75 df                	jne    80102080 <dirlink+0x30>
      break;
  }

  strncpy(de.name, name, DIRSIZ);
801020a1:	8d 45 da             	lea    -0x26(%ebp),%eax
801020a4:	83 ec 04             	sub    $0x4,%esp
801020a7:	6a 0e                	push   $0xe
801020a9:	ff 75 0c             	pushl  0xc(%ebp)
801020ac:	50                   	push   %eax
801020ad:	e8 1e 33 00 00       	call   801053d0 <strncpy>
  de.inum = inum;
801020b2:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801020b5:	6a 10                	push   $0x10
801020b7:	57                   	push   %edi
801020b8:	56                   	push   %esi
801020b9:	53                   	push   %ebx
    if(de.inum == 0)
      break;
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
801020ba:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801020be:	e8 dd fb ff ff       	call   80101ca0 <writei>
801020c3:	83 c4 20             	add    $0x20,%esp
801020c6:	83 f8 10             	cmp    $0x10,%eax
801020c9:	75 2a                	jne    801020f5 <dirlink+0xa5>
    panic("dirlink");

  return 0;
801020cb:	31 c0                	xor    %eax,%eax
}
801020cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801020d0:	5b                   	pop    %ebx
801020d1:	5e                   	pop    %esi
801020d2:	5f                   	pop    %edi
801020d3:	5d                   	pop    %ebp
801020d4:	c3                   	ret    
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
    iput(ip);
801020d5:	83 ec 0c             	sub    $0xc,%esp
801020d8:	50                   	push   %eax
801020d9:	e8 12 f9 ff ff       	call   801019f0 <iput>
    return -1;
801020de:	83 c4 10             	add    $0x10,%esp
801020e1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801020e6:	eb e5                	jmp    801020cd <dirlink+0x7d>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
801020e8:	83 ec 0c             	sub    $0xc,%esp
801020eb:	68 c8 81 10 80       	push   $0x801081c8
801020f0:	e8 7b e2 ff ff       	call   80100370 <panic>
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("dirlink");
801020f5:	83 ec 0c             	sub    $0xc,%esp
801020f8:	68 46 89 10 80       	push   $0x80108946
801020fd:	e8 6e e2 ff ff       	call   80100370 <panic>
80102102:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102109:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102110 <namei>:
  return ip;
}

struct inode*
namei(char *path)
{
80102110:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102111:	31 d2                	xor    %edx,%edx
  return ip;
}

struct inode*
namei(char *path)
{
80102113:	89 e5                	mov    %esp,%ebp
80102115:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102118:	8b 45 08             	mov    0x8(%ebp),%eax
8010211b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
8010211e:	e8 7d fd ff ff       	call   80101ea0 <namex>
}
80102123:	c9                   	leave  
80102124:	c3                   	ret    
80102125:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102129:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102130 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102130:	55                   	push   %ebp
  return namex(path, 1, name);
80102131:	ba 01 00 00 00       	mov    $0x1,%edx
  return namex(path, 0, name);
}

struct inode*
nameiparent(char *path, char *name)
{
80102136:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80102138:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010213b:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010213e:	5d                   	pop    %ebp
}

struct inode*
nameiparent(char *path, char *name)
{
  return namex(path, 1, name);
8010213f:	e9 5c fd ff ff       	jmp    80101ea0 <namex>
80102144:	66 90                	xchg   %ax,%ax
80102146:	66 90                	xchg   %ax,%ax
80102148:	66 90                	xchg   %ax,%ax
8010214a:	66 90                	xchg   %ax,%ax
8010214c:	66 90                	xchg   %ax,%ax
8010214e:	66 90                	xchg   %ax,%ax

80102150 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102150:	55                   	push   %ebp
  if(b == 0)
80102151:	85 c0                	test   %eax,%eax
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102153:	89 e5                	mov    %esp,%ebp
80102155:	56                   	push   %esi
80102156:	53                   	push   %ebx
  if(b == 0)
80102157:	0f 84 ad 00 00 00    	je     8010220a <idestart+0xba>
    panic("idestart");
  if(b->blockno >= FSSIZE)
8010215d:	8b 58 08             	mov    0x8(%eax),%ebx
80102160:	89 c1                	mov    %eax,%ecx
80102162:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
80102168:	0f 87 8f 00 00 00    	ja     801021fd <idestart+0xad>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010216e:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102173:	90                   	nop
80102174:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102178:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102179:	83 e0 c0             	and    $0xffffffc0,%eax
8010217c:	3c 40                	cmp    $0x40,%al
8010217e:	75 f8                	jne    80102178 <idestart+0x28>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102180:	31 f6                	xor    %esi,%esi
80102182:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102187:	89 f0                	mov    %esi,%eax
80102189:	ee                   	out    %al,(%dx)
8010218a:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010218f:	b8 01 00 00 00       	mov    $0x1,%eax
80102194:	ee                   	out    %al,(%dx)
80102195:	ba f3 01 00 00       	mov    $0x1f3,%edx
8010219a:	89 d8                	mov    %ebx,%eax
8010219c:	ee                   	out    %al,(%dx)
8010219d:	89 d8                	mov    %ebx,%eax
8010219f:	ba f4 01 00 00       	mov    $0x1f4,%edx
801021a4:	c1 f8 08             	sar    $0x8,%eax
801021a7:	ee                   	out    %al,(%dx)
801021a8:	ba f5 01 00 00       	mov    $0x1f5,%edx
801021ad:	89 f0                	mov    %esi,%eax
801021af:	ee                   	out    %al,(%dx)
801021b0:	0f b6 41 04          	movzbl 0x4(%ecx),%eax
801021b4:	ba f6 01 00 00       	mov    $0x1f6,%edx
801021b9:	83 e0 01             	and    $0x1,%eax
801021bc:	c1 e0 04             	shl    $0x4,%eax
801021bf:	83 c8 e0             	or     $0xffffffe0,%eax
801021c2:	ee                   	out    %al,(%dx)
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
801021c3:	f6 01 04             	testb  $0x4,(%ecx)
801021c6:	ba f7 01 00 00       	mov    $0x1f7,%edx
801021cb:	75 13                	jne    801021e0 <idestart+0x90>
801021cd:	b8 20 00 00 00       	mov    $0x20,%eax
801021d2:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
801021d3:	8d 65 f8             	lea    -0x8(%ebp),%esp
801021d6:	5b                   	pop    %ebx
801021d7:	5e                   	pop    %esi
801021d8:	5d                   	pop    %ebp
801021d9:	c3                   	ret    
801021da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801021e0:	b8 30 00 00 00       	mov    $0x30,%eax
801021e5:	ee                   	out    %al,(%dx)
}

static inline void
outsl(int port, const void *addr, int cnt)
{
  asm volatile("cld; rep outsl" :
801021e6:	ba f0 01 00 00       	mov    $0x1f0,%edx
  outb(0x1f4, (sector >> 8) & 0xff);
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
801021eb:	8d 71 5c             	lea    0x5c(%ecx),%esi
801021ee:	b9 80 00 00 00       	mov    $0x80,%ecx
801021f3:	fc                   	cld    
801021f4:	f3 6f                	rep outsl %ds:(%esi),(%dx)
  } else {
    outb(0x1f7, read_cmd);
  }
}
801021f6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801021f9:	5b                   	pop    %ebx
801021fa:	5e                   	pop    %esi
801021fb:	5d                   	pop    %ebp
801021fc:	c3                   	ret    
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
  if(b->blockno >= FSSIZE)
    panic("incorrect blockno");
801021fd:	83 ec 0c             	sub    $0xc,%esp
80102200:	68 34 82 10 80       	push   $0x80108234
80102205:	e8 66 e1 ff ff       	call   80100370 <panic>
// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
8010220a:	83 ec 0c             	sub    $0xc,%esp
8010220d:	68 2b 82 10 80       	push   $0x8010822b
80102212:	e8 59 e1 ff ff       	call   80100370 <panic>
80102217:	89 f6                	mov    %esi,%esi
80102219:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102220 <ideinit>:
  return 0;
}

void
ideinit(void)
{
80102220:	55                   	push   %ebp
80102221:	89 e5                	mov    %esp,%ebp
80102223:	83 ec 10             	sub    $0x10,%esp
  int i;

  initlock(&idelock, "ide");
80102226:	68 46 82 10 80       	push   $0x80108246
8010222b:	68 80 b5 10 80       	push   $0x8010b580
80102230:	e8 9b 2d 00 00       	call   80104fd0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102235:	58                   	pop    %eax
80102236:	a1 b0 38 11 80       	mov    0x801138b0,%eax
8010223b:	5a                   	pop    %edx
8010223c:	83 e8 01             	sub    $0x1,%eax
8010223f:	50                   	push   %eax
80102240:	6a 0e                	push   $0xe
80102242:	e8 a9 02 00 00       	call   801024f0 <ioapicenable>
80102247:	83 c4 10             	add    $0x10,%esp
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010224a:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010224f:	90                   	nop
80102250:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102251:	83 e0 c0             	and    $0xffffffc0,%eax
80102254:	3c 40                	cmp    $0x40,%al
80102256:	75 f8                	jne    80102250 <ideinit+0x30>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102258:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010225d:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
80102262:	ee                   	out    %al,(%dx)
80102263:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102268:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010226d:	eb 06                	jmp    80102275 <ideinit+0x55>
8010226f:	90                   	nop
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);

  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
80102270:	83 e9 01             	sub    $0x1,%ecx
80102273:	74 0f                	je     80102284 <ideinit+0x64>
80102275:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102276:	84 c0                	test   %al,%al
80102278:	74 f6                	je     80102270 <ideinit+0x50>
      havedisk1 = 1;
8010227a:	c7 05 60 b5 10 80 01 	movl   $0x1,0x8010b560
80102281:	00 00 00 
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102284:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102289:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
8010228e:	ee                   	out    %al,(%dx)
    }
  }

  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
}
8010228f:	c9                   	leave  
80102290:	c3                   	ret    
80102291:	eb 0d                	jmp    801022a0 <ideintr>
80102293:	90                   	nop
80102294:	90                   	nop
80102295:	90                   	nop
80102296:	90                   	nop
80102297:	90                   	nop
80102298:	90                   	nop
80102299:	90                   	nop
8010229a:	90                   	nop
8010229b:	90                   	nop
8010229c:	90                   	nop
8010229d:	90                   	nop
8010229e:	90                   	nop
8010229f:	90                   	nop

801022a0 <ideintr>:
}

// Interrupt handler.
void
ideintr(void)
{
801022a0:	55                   	push   %ebp
801022a1:	89 e5                	mov    %esp,%ebp
801022a3:	57                   	push   %edi
801022a4:	56                   	push   %esi
801022a5:	53                   	push   %ebx
801022a6:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801022a9:	68 80 b5 10 80       	push   $0x8010b580
801022ae:	e8 7d 2e 00 00       	call   80105130 <acquire>

  if((b = idequeue) == 0){
801022b3:	8b 1d 64 b5 10 80    	mov    0x8010b564,%ebx
801022b9:	83 c4 10             	add    $0x10,%esp
801022bc:	85 db                	test   %ebx,%ebx
801022be:	74 34                	je     801022f4 <ideintr+0x54>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
801022c0:	8b 43 58             	mov    0x58(%ebx),%eax
801022c3:	a3 64 b5 10 80       	mov    %eax,0x8010b564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801022c8:	8b 33                	mov    (%ebx),%esi
801022ca:	f7 c6 04 00 00 00    	test   $0x4,%esi
801022d0:	74 3e                	je     80102310 <ideintr+0x70>
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
801022d2:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
801022d5:	83 ec 0c             	sub    $0xc,%esp
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
801022d8:	83 ce 02             	or     $0x2,%esi
801022db:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
801022dd:	53                   	push   %ebx
801022de:	e8 ad 22 00 00       	call   80104590 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801022e3:	a1 64 b5 10 80       	mov    0x8010b564,%eax
801022e8:	83 c4 10             	add    $0x10,%esp
801022eb:	85 c0                	test   %eax,%eax
801022ed:	74 05                	je     801022f4 <ideintr+0x54>
    idestart(idequeue);
801022ef:	e8 5c fe ff ff       	call   80102150 <idestart>

  // First queued buffer is the active request.
  acquire(&idelock);

  if((b = idequeue) == 0){
    release(&idelock);
801022f4:	83 ec 0c             	sub    $0xc,%esp
801022f7:	68 80 b5 10 80       	push   $0x8010b580
801022fc:	e8 df 2e 00 00       	call   801051e0 <release>
  // Start disk on next buf in queue.
  if(idequeue != 0)
    idestart(idequeue);

  release(&idelock);
}
80102301:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102304:	5b                   	pop    %ebx
80102305:	5e                   	pop    %esi
80102306:	5f                   	pop    %edi
80102307:	5d                   	pop    %ebp
80102308:	c3                   	ret    
80102309:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102310:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102315:	8d 76 00             	lea    0x0(%esi),%esi
80102318:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102319:	89 c1                	mov    %eax,%ecx
8010231b:	83 e1 c0             	and    $0xffffffc0,%ecx
8010231e:	80 f9 40             	cmp    $0x40,%cl
80102321:	75 f5                	jne    80102318 <ideintr+0x78>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
80102323:	a8 21                	test   $0x21,%al
80102325:	75 ab                	jne    801022d2 <ideintr+0x32>
  }
  idequeue = b->qnext;

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
    insl(0x1f0, b->data, BSIZE/4);
80102327:	8d 7b 5c             	lea    0x5c(%ebx),%edi
}

static inline void
insl(int port, void *addr, int cnt)
{
  asm volatile("cld; rep insl" :
8010232a:	b9 80 00 00 00       	mov    $0x80,%ecx
8010232f:	ba f0 01 00 00       	mov    $0x1f0,%edx
80102334:	fc                   	cld    
80102335:	f3 6d                	rep insl (%dx),%es:(%edi)
80102337:	8b 33                	mov    (%ebx),%esi
80102339:	eb 97                	jmp    801022d2 <ideintr+0x32>
8010233b:	90                   	nop
8010233c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102340 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102340:	55                   	push   %ebp
80102341:	89 e5                	mov    %esp,%ebp
80102343:	53                   	push   %ebx
80102344:	83 ec 10             	sub    $0x10,%esp
80102347:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010234a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010234d:	50                   	push   %eax
8010234e:	e8 2d 2c 00 00       	call   80104f80 <holdingsleep>
80102353:	83 c4 10             	add    $0x10,%esp
80102356:	85 c0                	test   %eax,%eax
80102358:	0f 84 ad 00 00 00    	je     8010240b <iderw+0xcb>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010235e:	8b 03                	mov    (%ebx),%eax
80102360:	83 e0 06             	and    $0x6,%eax
80102363:	83 f8 02             	cmp    $0x2,%eax
80102366:	0f 84 b9 00 00 00    	je     80102425 <iderw+0xe5>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010236c:	8b 53 04             	mov    0x4(%ebx),%edx
8010236f:	85 d2                	test   %edx,%edx
80102371:	74 0d                	je     80102380 <iderw+0x40>
80102373:	a1 60 b5 10 80       	mov    0x8010b560,%eax
80102378:	85 c0                	test   %eax,%eax
8010237a:	0f 84 98 00 00 00    	je     80102418 <iderw+0xd8>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102380:	83 ec 0c             	sub    $0xc,%esp
80102383:	68 80 b5 10 80       	push   $0x8010b580
80102388:	e8 a3 2d 00 00       	call   80105130 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010238d:	8b 15 64 b5 10 80    	mov    0x8010b564,%edx
80102393:	83 c4 10             	add    $0x10,%esp
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
80102396:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010239d:	85 d2                	test   %edx,%edx
8010239f:	75 09                	jne    801023aa <iderw+0x6a>
801023a1:	eb 58                	jmp    801023fb <iderw+0xbb>
801023a3:	90                   	nop
801023a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801023a8:	89 c2                	mov    %eax,%edx
801023aa:	8b 42 58             	mov    0x58(%edx),%eax
801023ad:	85 c0                	test   %eax,%eax
801023af:	75 f7                	jne    801023a8 <iderw+0x68>
801023b1:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
801023b4:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
801023b6:	3b 1d 64 b5 10 80    	cmp    0x8010b564,%ebx
801023bc:	74 44                	je     80102402 <iderw+0xc2>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801023be:	8b 03                	mov    (%ebx),%eax
801023c0:	83 e0 06             	and    $0x6,%eax
801023c3:	83 f8 02             	cmp    $0x2,%eax
801023c6:	74 23                	je     801023eb <iderw+0xab>
801023c8:	90                   	nop
801023c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
801023d0:	83 ec 08             	sub    $0x8,%esp
801023d3:	68 80 b5 10 80       	push   $0x8010b580
801023d8:	53                   	push   %ebx
801023d9:	e8 f2 1f 00 00       	call   801043d0 <sleep>
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801023de:	8b 03                	mov    (%ebx),%eax
801023e0:	83 c4 10             	add    $0x10,%esp
801023e3:	83 e0 06             	and    $0x6,%eax
801023e6:	83 f8 02             	cmp    $0x2,%eax
801023e9:	75 e5                	jne    801023d0 <iderw+0x90>
    sleep(b, &idelock);
  }


  release(&idelock);
801023eb:	c7 45 08 80 b5 10 80 	movl   $0x8010b580,0x8(%ebp)
}
801023f2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801023f5:	c9                   	leave  
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
    sleep(b, &idelock);
  }


  release(&idelock);
801023f6:	e9 e5 2d 00 00       	jmp    801051e0 <release>

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801023fb:	ba 64 b5 10 80       	mov    $0x8010b564,%edx
80102400:	eb b2                	jmp    801023b4 <iderw+0x74>
    ;
  *pp = b;

  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
80102402:	89 d8                	mov    %ebx,%eax
80102404:	e8 47 fd ff ff       	call   80102150 <idestart>
80102409:	eb b3                	jmp    801023be <iderw+0x7e>
iderw(struct buf *b)
{
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
8010240b:	83 ec 0c             	sub    $0xc,%esp
8010240e:	68 4a 82 10 80       	push   $0x8010824a
80102413:	e8 58 df ff ff       	call   80100370 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
    panic("iderw: ide disk 1 not present");
80102418:	83 ec 0c             	sub    $0xc,%esp
8010241b:	68 75 82 10 80       	push   $0x80108275
80102420:	e8 4b df ff ff       	call   80100370 <panic>
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
80102425:	83 ec 0c             	sub    $0xc,%esp
80102428:	68 60 82 10 80       	push   $0x80108260
8010242d:	e8 3e df ff ff       	call   80100370 <panic>
80102432:	66 90                	xchg   %ax,%ax
80102434:	66 90                	xchg   %ax,%ax
80102436:	66 90                	xchg   %ax,%ax
80102438:	66 90                	xchg   %ax,%ax
8010243a:	66 90                	xchg   %ax,%ax
8010243c:	66 90                	xchg   %ax,%ax
8010243e:	66 90                	xchg   %ax,%ax

80102440 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102440:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102441:	c7 05 b4 36 11 80 00 	movl   $0xfec00000,0x801136b4
80102448:	00 c0 fe 
  ioapic->data = data;
}

void
ioapicinit(void)
{
8010244b:	89 e5                	mov    %esp,%ebp
8010244d:	56                   	push   %esi
8010244e:	53                   	push   %ebx
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
8010244f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102456:	00 00 00 
  return ioapic->data;
80102459:	8b 15 b4 36 11 80    	mov    0x801136b4,%edx
8010245f:	8b 72 10             	mov    0x10(%edx),%esi
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
80102462:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80102468:	8b 0d b4 36 11 80    	mov    0x801136b4,%ecx
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010246e:	0f b6 15 e0 37 11 80 	movzbl 0x801137e0,%edx
ioapicinit(void)
{
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102475:	89 f0                	mov    %esi,%eax
80102477:	c1 e8 10             	shr    $0x10,%eax
8010247a:	0f b6 f0             	movzbl %al,%esi

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
  return ioapic->data;
8010247d:	8b 41 10             	mov    0x10(%ecx),%eax
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
80102480:	c1 e8 18             	shr    $0x18,%eax
80102483:	39 d0                	cmp    %edx,%eax
80102485:	74 16                	je     8010249d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102487:	83 ec 0c             	sub    $0xc,%esp
8010248a:	68 94 82 10 80       	push   $0x80108294
8010248f:	e8 cc e1 ff ff       	call   80100660 <cprintf>
80102494:	8b 0d b4 36 11 80    	mov    0x801136b4,%ecx
8010249a:	83 c4 10             	add    $0x10,%esp
8010249d:	83 c6 21             	add    $0x21,%esi
  ioapic->data = data;
}

void
ioapicinit(void)
{
801024a0:	ba 10 00 00 00       	mov    $0x10,%edx
801024a5:	b8 20 00 00 00       	mov    $0x20,%eax
801024aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801024b0:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
801024b2:	8b 0d b4 36 11 80    	mov    0x801136b4,%ecx
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801024b8:	89 c3                	mov    %eax,%ebx
801024ba:	81 cb 00 00 01 00    	or     $0x10000,%ebx
801024c0:	83 c0 01             	add    $0x1,%eax

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
801024c3:	89 59 10             	mov    %ebx,0x10(%ecx)
801024c6:	8d 5a 01             	lea    0x1(%edx),%ebx
801024c9:	83 c2 02             	add    $0x2,%edx
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
801024cc:	39 f0                	cmp    %esi,%eax
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801024ce:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
801024d0:	8b 0d b4 36 11 80    	mov    0x801136b4,%ecx
801024d6:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
801024dd:	75 d1                	jne    801024b0 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801024df:	8d 65 f8             	lea    -0x8(%ebp),%esp
801024e2:	5b                   	pop    %ebx
801024e3:	5e                   	pop    %esi
801024e4:	5d                   	pop    %ebp
801024e5:	c3                   	ret    
801024e6:	8d 76 00             	lea    0x0(%esi),%esi
801024e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801024f0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801024f0:	55                   	push   %ebp
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801024f1:	8b 0d b4 36 11 80    	mov    0x801136b4,%ecx
  }
}

void
ioapicenable(int irq, int cpunum)
{
801024f7:	89 e5                	mov    %esp,%ebp
801024f9:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801024fc:	8d 50 20             	lea    0x20(%eax),%edx
801024ff:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102503:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102505:	8b 0d b4 36 11 80    	mov    0x801136b4,%ecx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
8010250b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010250e:	89 51 10             	mov    %edx,0x10(%ecx)
{
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102511:	8b 55 0c             	mov    0xc(%ebp),%edx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102514:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102516:	a1 b4 36 11 80       	mov    0x801136b4,%eax
{
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010251b:	c1 e2 18             	shl    $0x18,%edx

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
8010251e:	89 50 10             	mov    %edx,0x10(%eax)
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
}
80102521:	5d                   	pop    %ebp
80102522:	c3                   	ret    
80102523:	66 90                	xchg   %ax,%ax
80102525:	66 90                	xchg   %ax,%ax
80102527:	66 90                	xchg   %ax,%ax
80102529:	66 90                	xchg   %ax,%ax
8010252b:	66 90                	xchg   %ax,%ax
8010252d:	66 90                	xchg   %ax,%ax
8010252f:	90                   	nop

80102530 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102530:	55                   	push   %ebp
80102531:	89 e5                	mov    %esp,%ebp
80102533:	53                   	push   %ebx
80102534:	83 ec 04             	sub    $0x4,%esp
80102537:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010253a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102540:	75 70                	jne    801025b2 <kfree+0x82>
80102542:	81 fb 68 66 11 80    	cmp    $0x80116668,%ebx
80102548:	72 68                	jb     801025b2 <kfree+0x82>
8010254a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102550:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102555:	77 5b                	ja     801025b2 <kfree+0x82>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102557:	83 ec 04             	sub    $0x4,%esp
8010255a:	68 00 10 00 00       	push   $0x1000
8010255f:	6a 01                	push   $0x1
80102561:	53                   	push   %ebx
80102562:	e8 c9 2c 00 00       	call   80105230 <memset>

  if(kmem.use_lock)
80102567:	8b 15 f4 36 11 80    	mov    0x801136f4,%edx
8010256d:	83 c4 10             	add    $0x10,%esp
80102570:	85 d2                	test   %edx,%edx
80102572:	75 2c                	jne    801025a0 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102574:	a1 f8 36 11 80       	mov    0x801136f8,%eax
80102579:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010257b:	a1 f4 36 11 80       	mov    0x801136f4,%eax

  if(kmem.use_lock)
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
80102580:	89 1d f8 36 11 80    	mov    %ebx,0x801136f8
  if(kmem.use_lock)
80102586:	85 c0                	test   %eax,%eax
80102588:	75 06                	jne    80102590 <kfree+0x60>
    release(&kmem.lock);
}
8010258a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010258d:	c9                   	leave  
8010258e:	c3                   	ret    
8010258f:	90                   	nop
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
80102590:	c7 45 08 c0 36 11 80 	movl   $0x801136c0,0x8(%ebp)
}
80102597:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010259a:	c9                   	leave  
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
8010259b:	e9 40 2c 00 00       	jmp    801051e0 <release>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);

  if(kmem.use_lock)
    acquire(&kmem.lock);
801025a0:	83 ec 0c             	sub    $0xc,%esp
801025a3:	68 c0 36 11 80       	push   $0x801136c0
801025a8:	e8 83 2b 00 00       	call   80105130 <acquire>
801025ad:	83 c4 10             	add    $0x10,%esp
801025b0:	eb c2                	jmp    80102574 <kfree+0x44>
kfree(char *v)
{
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
    panic("kfree");
801025b2:	83 ec 0c             	sub    $0xc,%esp
801025b5:	68 c6 82 10 80       	push   $0x801082c6
801025ba:	e8 b1 dd ff ff       	call   80100370 <panic>
801025bf:	90                   	nop

801025c0 <freerange>:
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
801025c0:	55                   	push   %ebp
801025c1:	89 e5                	mov    %esp,%ebp
801025c3:	56                   	push   %esi
801025c4:	53                   	push   %ebx
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801025c5:	8b 45 08             	mov    0x8(%ebp),%eax
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
801025c8:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801025cb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801025d1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025d7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801025dd:	39 de                	cmp    %ebx,%esi
801025df:	72 23                	jb     80102604 <freerange+0x44>
801025e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801025e8:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801025ee:	83 ec 0c             	sub    $0xc,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025f1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801025f7:	50                   	push   %eax
801025f8:	e8 33 ff ff ff       	call   80102530 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025fd:	83 c4 10             	add    $0x10,%esp
80102600:	39 f3                	cmp    %esi,%ebx
80102602:	76 e4                	jbe    801025e8 <freerange+0x28>
    kfree(p);
}
80102604:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102607:	5b                   	pop    %ebx
80102608:	5e                   	pop    %esi
80102609:	5d                   	pop    %ebp
8010260a:	c3                   	ret    
8010260b:	90                   	nop
8010260c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102610 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
80102610:	55                   	push   %ebp
80102611:	89 e5                	mov    %esp,%ebp
80102613:	56                   	push   %esi
80102614:	53                   	push   %ebx
80102615:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102618:	83 ec 08             	sub    $0x8,%esp
8010261b:	68 cc 82 10 80       	push   $0x801082cc
80102620:	68 c0 36 11 80       	push   $0x801136c0
80102625:	e8 a6 29 00 00       	call   80104fd0 <initlock>

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010262a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010262d:	83 c4 10             	add    $0x10,%esp
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
80102630:	c7 05 f4 36 11 80 00 	movl   $0x0,0x801136f4
80102637:	00 00 00 

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010263a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102640:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102646:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010264c:	39 de                	cmp    %ebx,%esi
8010264e:	72 1c                	jb     8010266c <kinit1+0x5c>
    kfree(p);
80102650:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102656:	83 ec 0c             	sub    $0xc,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102659:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010265f:	50                   	push   %eax
80102660:	e8 cb fe ff ff       	call   80102530 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102665:	83 c4 10             	add    $0x10,%esp
80102668:	39 de                	cmp    %ebx,%esi
8010266a:	73 e4                	jae    80102650 <kinit1+0x40>
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
  freerange(vstart, vend);
}
8010266c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010266f:	5b                   	pop    %ebx
80102670:	5e                   	pop    %esi
80102671:	5d                   	pop    %ebp
80102672:	c3                   	ret    
80102673:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102679:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102680 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102680:	55                   	push   %ebp
80102681:	89 e5                	mov    %esp,%ebp
80102683:	56                   	push   %esi
80102684:	53                   	push   %ebx

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102685:	8b 45 08             	mov    0x8(%ebp),%eax
  freerange(vstart, vend);
}

void
kinit2(void *vstart, void *vend)
{
80102688:	8b 75 0c             	mov    0xc(%ebp),%esi

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010268b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102691:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102697:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010269d:	39 de                	cmp    %ebx,%esi
8010269f:	72 23                	jb     801026c4 <kinit2+0x44>
801026a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801026a8:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801026ae:	83 ec 0c             	sub    $0xc,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026b1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801026b7:	50                   	push   %eax
801026b8:	e8 73 fe ff ff       	call   80102530 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026bd:	83 c4 10             	add    $0x10,%esp
801026c0:	39 de                	cmp    %ebx,%esi
801026c2:	73 e4                	jae    801026a8 <kinit2+0x28>

void
kinit2(void *vstart, void *vend)
{
  freerange(vstart, vend);
  kmem.use_lock = 1;
801026c4:	c7 05 f4 36 11 80 01 	movl   $0x1,0x801136f4
801026cb:	00 00 00 
}
801026ce:	8d 65 f8             	lea    -0x8(%ebp),%esp
801026d1:	5b                   	pop    %ebx
801026d2:	5e                   	pop    %esi
801026d3:	5d                   	pop    %ebp
801026d4:	c3                   	ret    
801026d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801026d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801026e0 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
801026e0:	55                   	push   %ebp
801026e1:	89 e5                	mov    %esp,%ebp
801026e3:	53                   	push   %ebx
801026e4:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
801026e7:	a1 f4 36 11 80       	mov    0x801136f4,%eax
801026ec:	85 c0                	test   %eax,%eax
801026ee:	75 30                	jne    80102720 <kalloc+0x40>
    acquire(&kmem.lock);
  r = kmem.freelist;
801026f0:	8b 1d f8 36 11 80    	mov    0x801136f8,%ebx
  if(r)
801026f6:	85 db                	test   %ebx,%ebx
801026f8:	74 1c                	je     80102716 <kalloc+0x36>
    kmem.freelist = r->next;
801026fa:	8b 13                	mov    (%ebx),%edx
801026fc:	89 15 f8 36 11 80    	mov    %edx,0x801136f8
  if(kmem.use_lock)
80102702:	85 c0                	test   %eax,%eax
80102704:	74 10                	je     80102716 <kalloc+0x36>
    release(&kmem.lock);
80102706:	83 ec 0c             	sub    $0xc,%esp
80102709:	68 c0 36 11 80       	push   $0x801136c0
8010270e:	e8 cd 2a 00 00       	call   801051e0 <release>
80102713:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
}
80102716:	89 d8                	mov    %ebx,%eax
80102718:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010271b:	c9                   	leave  
8010271c:	c3                   	ret    
8010271d:	8d 76 00             	lea    0x0(%esi),%esi
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
    acquire(&kmem.lock);
80102720:	83 ec 0c             	sub    $0xc,%esp
80102723:	68 c0 36 11 80       	push   $0x801136c0
80102728:	e8 03 2a 00 00       	call   80105130 <acquire>
  r = kmem.freelist;
8010272d:	8b 1d f8 36 11 80    	mov    0x801136f8,%ebx
  if(r)
80102733:	83 c4 10             	add    $0x10,%esp
80102736:	a1 f4 36 11 80       	mov    0x801136f4,%eax
8010273b:	85 db                	test   %ebx,%ebx
8010273d:	75 bb                	jne    801026fa <kalloc+0x1a>
8010273f:	eb c1                	jmp    80102702 <kalloc+0x22>
80102741:	66 90                	xchg   %ax,%ax
80102743:	66 90                	xchg   %ax,%ax
80102745:	66 90                	xchg   %ax,%ax
80102747:	66 90                	xchg   %ax,%ax
80102749:	66 90                	xchg   %ax,%ax
8010274b:	66 90                	xchg   %ax,%ax
8010274d:	66 90                	xchg   %ax,%ax
8010274f:	90                   	nop

80102750 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102750:	55                   	push   %ebp
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102751:	ba 64 00 00 00       	mov    $0x64,%edx
80102756:	89 e5                	mov    %esp,%ebp
80102758:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102759:	a8 01                	test   $0x1,%al
8010275b:	0f 84 af 00 00 00    	je     80102810 <kbdgetc+0xc0>
80102761:	ba 60 00 00 00       	mov    $0x60,%edx
80102766:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102767:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
8010276a:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
80102770:	74 7e                	je     801027f0 <kbdgetc+0xa0>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102772:	84 c0                	test   %al,%al
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102774:	8b 0d b4 b5 10 80    	mov    0x8010b5b4,%ecx
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
8010277a:	79 24                	jns    801027a0 <kbdgetc+0x50>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
8010277c:	f6 c1 40             	test   $0x40,%cl
8010277f:	75 05                	jne    80102786 <kbdgetc+0x36>
80102781:	89 c2                	mov    %eax,%edx
80102783:	83 e2 7f             	and    $0x7f,%edx
    shift &= ~(shiftcode[data] | E0ESC);
80102786:	0f b6 82 00 84 10 80 	movzbl -0x7fef7c00(%edx),%eax
8010278d:	83 c8 40             	or     $0x40,%eax
80102790:	0f b6 c0             	movzbl %al,%eax
80102793:	f7 d0                	not    %eax
80102795:	21 c8                	and    %ecx,%eax
80102797:	a3 b4 b5 10 80       	mov    %eax,0x8010b5b4
    return 0;
8010279c:	31 c0                	xor    %eax,%eax
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
8010279e:	5d                   	pop    %ebp
8010279f:	c3                   	ret    
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
801027a0:	f6 c1 40             	test   $0x40,%cl
801027a3:	74 09                	je     801027ae <kbdgetc+0x5e>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801027a5:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
801027a8:	83 e1 bf             	and    $0xffffffbf,%ecx
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801027ab:	0f b6 d0             	movzbl %al,%edx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
801027ae:	0f b6 82 00 84 10 80 	movzbl -0x7fef7c00(%edx),%eax
801027b5:	09 c1                	or     %eax,%ecx
801027b7:	0f b6 82 00 83 10 80 	movzbl -0x7fef7d00(%edx),%eax
801027be:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
801027c0:	89 c8                	mov    %ecx,%eax
    data |= 0x80;
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
801027c2:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
  c = charcode[shift & (CTL | SHIFT)][data];
801027c8:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
801027cb:	83 e1 08             	and    $0x8,%ecx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
801027ce:	8b 04 85 e0 82 10 80 	mov    -0x7fef7d20(,%eax,4),%eax
801027d5:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
801027d9:	74 c3                	je     8010279e <kbdgetc+0x4e>
    if('a' <= c && c <= 'z')
801027db:	8d 50 9f             	lea    -0x61(%eax),%edx
801027de:	83 fa 19             	cmp    $0x19,%edx
801027e1:	77 1d                	ja     80102800 <kbdgetc+0xb0>
      c += 'A' - 'a';
801027e3:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801027e6:	5d                   	pop    %ebp
801027e7:	c3                   	ret    
801027e8:	90                   	nop
801027e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
    return 0;
801027f0:	31 c0                	xor    %eax,%eax
  if((st & KBS_DIB) == 0)
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
801027f2:	83 0d b4 b5 10 80 40 	orl    $0x40,0x8010b5b4
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801027f9:	5d                   	pop    %ebp
801027fa:	c3                   	ret    
801027fb:	90                   	nop
801027fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
80102800:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
80102803:	8d 50 20             	lea    0x20(%eax),%edx
  }
  return c;
}
80102806:	5d                   	pop    %ebp
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
80102807:	83 f9 19             	cmp    $0x19,%ecx
8010280a:	0f 46 c2             	cmovbe %edx,%eax
  }
  return c;
}
8010280d:	c3                   	ret    
8010280e:	66 90                	xchg   %ax,%ax
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
    return -1;
80102810:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102815:	5d                   	pop    %ebp
80102816:	c3                   	ret    
80102817:	89 f6                	mov    %esi,%esi
80102819:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102820 <kbdintr>:

void
kbdintr(void)
{
80102820:	55                   	push   %ebp
80102821:	89 e5                	mov    %esp,%ebp
80102823:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102826:	68 50 27 10 80       	push   $0x80102750
8010282b:	e8 c0 df ff ff       	call   801007f0 <consoleintr>
}
80102830:	83 c4 10             	add    $0x10,%esp
80102833:	c9                   	leave  
80102834:	c3                   	ret    
80102835:	66 90                	xchg   %ax,%ax
80102837:	66 90                	xchg   %ax,%ax
80102839:	66 90                	xchg   %ax,%ax
8010283b:	66 90                	xchg   %ax,%ax
8010283d:	66 90                	xchg   %ax,%ax
8010283f:	90                   	nop

80102840 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102840:	a1 fc 36 11 80       	mov    0x801136fc,%eax
  lapic[ID];  // wait for write to finish, by reading
}

void
lapicinit(void)
{
80102845:	55                   	push   %ebp
80102846:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102848:	85 c0                	test   %eax,%eax
8010284a:	0f 84 c8 00 00 00    	je     80102918 <lapicinit+0xd8>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102850:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102857:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010285a:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010285d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102864:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102867:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010286a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102871:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102874:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102877:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010287e:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102881:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102884:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
8010288b:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010288e:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102891:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102898:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010289b:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010289e:	8b 50 30             	mov    0x30(%eax),%edx
801028a1:	c1 ea 10             	shr    $0x10,%edx
801028a4:	80 fa 03             	cmp    $0x3,%dl
801028a7:	77 77                	ja     80102920 <lapicinit+0xe0>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801028a9:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
801028b0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028b3:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801028b6:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801028bd:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028c0:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801028c3:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801028ca:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028cd:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801028d0:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801028d7:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028da:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801028dd:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
801028e4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028e7:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801028ea:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
801028f1:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
801028f4:	8b 50 20             	mov    0x20(%eax),%edx
801028f7:	89 f6                	mov    %esi,%esi
801028f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102900:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102906:	80 e6 10             	and    $0x10,%dh
80102909:	75 f5                	jne    80102900 <lapicinit+0xc0>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010290b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102912:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102915:	8b 40 20             	mov    0x20(%eax),%eax
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102918:	5d                   	pop    %ebp
80102919:	c3                   	ret    
8010291a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102920:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102927:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010292a:	8b 50 20             	mov    0x20(%eax),%edx
8010292d:	e9 77 ff ff ff       	jmp    801028a9 <lapicinit+0x69>
80102932:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102939:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102940 <lapicid>:
}

int
lapicid(void)
{
  if (!lapic)
80102940:	a1 fc 36 11 80       	mov    0x801136fc,%eax
  lapicw(TPR, 0);
}

int
lapicid(void)
{
80102945:	55                   	push   %ebp
80102946:	89 e5                	mov    %esp,%ebp
  if (!lapic)
80102948:	85 c0                	test   %eax,%eax
8010294a:	74 0c                	je     80102958 <lapicid+0x18>
    return 0;
  return lapic[ID] >> 24;
8010294c:	8b 40 20             	mov    0x20(%eax),%eax
}
8010294f:	5d                   	pop    %ebp
int
lapicid(void)
{
  if (!lapic)
    return 0;
  return lapic[ID] >> 24;
80102950:	c1 e8 18             	shr    $0x18,%eax
}
80102953:	c3                   	ret    
80102954:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

int
lapicid(void)
{
  if (!lapic)
    return 0;
80102958:	31 c0                	xor    %eax,%eax
  return lapic[ID] >> 24;
}
8010295a:	5d                   	pop    %ebp
8010295b:	c3                   	ret    
8010295c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102960 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102960:	a1 fc 36 11 80       	mov    0x801136fc,%eax
}

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102965:	55                   	push   %ebp
80102966:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102968:	85 c0                	test   %eax,%eax
8010296a:	74 0d                	je     80102979 <lapiceoi+0x19>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010296c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102973:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102976:	8b 40 20             	mov    0x20(%eax),%eax
void
lapiceoi(void)
{
  if(lapic)
    lapicw(EOI, 0);
}
80102979:	5d                   	pop    %ebp
8010297a:	c3                   	ret    
8010297b:	90                   	nop
8010297c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102980 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102980:	55                   	push   %ebp
80102981:	89 e5                	mov    %esp,%ebp
}
80102983:	5d                   	pop    %ebp
80102984:	c3                   	ret    
80102985:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102990 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102990:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102991:	ba 70 00 00 00       	mov    $0x70,%edx
80102996:	b8 0f 00 00 00       	mov    $0xf,%eax
8010299b:	89 e5                	mov    %esp,%ebp
8010299d:	53                   	push   %ebx
8010299e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801029a1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801029a4:	ee                   	out    %al,(%dx)
801029a5:	ba 71 00 00 00       	mov    $0x71,%edx
801029aa:	b8 0a 00 00 00       	mov    $0xa,%eax
801029af:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
801029b0:	31 c0                	xor    %eax,%eax

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801029b2:	c1 e3 18             	shl    $0x18,%ebx
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
801029b5:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
801029bb:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
801029bd:	c1 e9 0c             	shr    $0xc,%ecx
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
  wrv[1] = addr >> 4;
801029c0:	c1 e8 04             	shr    $0x4,%eax

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801029c3:	89 da                	mov    %ebx,%edx
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
801029c5:	80 cd 06             	or     $0x6,%ch
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
  wrv[1] = addr >> 4;
801029c8:	66 a3 69 04 00 80    	mov    %ax,0x80000469

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801029ce:	a1 fc 36 11 80       	mov    0x801136fc,%eax
801029d3:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029d9:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801029dc:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
801029e3:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029e6:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801029e9:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
801029f0:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029f3:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801029f6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029fc:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801029ff:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a05:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102a08:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a0e:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102a11:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a17:	8b 40 20             	mov    0x20(%eax),%eax
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
80102a1a:	5b                   	pop    %ebx
80102a1b:	5d                   	pop    %ebp
80102a1c:	c3                   	ret    
80102a1d:	8d 76 00             	lea    0x0(%esi),%esi

80102a20 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102a20:	55                   	push   %ebp
80102a21:	ba 70 00 00 00       	mov    $0x70,%edx
80102a26:	b8 0b 00 00 00       	mov    $0xb,%eax
80102a2b:	89 e5                	mov    %esp,%ebp
80102a2d:	57                   	push   %edi
80102a2e:	56                   	push   %esi
80102a2f:	53                   	push   %ebx
80102a30:	83 ec 4c             	sub    $0x4c,%esp
80102a33:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a34:	ba 71 00 00 00       	mov    $0x71,%edx
80102a39:	ec                   	in     (%dx),%al
80102a3a:	83 e0 04             	and    $0x4,%eax
80102a3d:	8d 75 d0             	lea    -0x30(%ebp),%esi
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a40:	31 db                	xor    %ebx,%ebx
80102a42:	88 45 b7             	mov    %al,-0x49(%ebp)
80102a45:	bf 70 00 00 00       	mov    $0x70,%edi
80102a4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102a50:	89 d8                	mov    %ebx,%eax
80102a52:	89 fa                	mov    %edi,%edx
80102a54:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a55:	b9 71 00 00 00       	mov    $0x71,%ecx
80102a5a:	89 ca                	mov    %ecx,%edx
80102a5c:	ec                   	in     (%dx),%al
}

static void
fill_rtcdate(struct rtcdate *r)
{
  r->second = cmos_read(SECS);
80102a5d:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a60:	89 fa                	mov    %edi,%edx
80102a62:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102a65:	b8 02 00 00 00       	mov    $0x2,%eax
80102a6a:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a6b:	89 ca                	mov    %ecx,%edx
80102a6d:	ec                   	in     (%dx),%al
  r->minute = cmos_read(MINS);
80102a6e:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a71:	89 fa                	mov    %edi,%edx
80102a73:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102a76:	b8 04 00 00 00       	mov    $0x4,%eax
80102a7b:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a7c:	89 ca                	mov    %ecx,%edx
80102a7e:	ec                   	in     (%dx),%al
  r->hour   = cmos_read(HOURS);
80102a7f:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a82:	89 fa                	mov    %edi,%edx
80102a84:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102a87:	b8 07 00 00 00       	mov    $0x7,%eax
80102a8c:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a8d:	89 ca                	mov    %ecx,%edx
80102a8f:	ec                   	in     (%dx),%al
  r->day    = cmos_read(DAY);
80102a90:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a93:	89 fa                	mov    %edi,%edx
80102a95:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102a98:	b8 08 00 00 00       	mov    $0x8,%eax
80102a9d:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a9e:	89 ca                	mov    %ecx,%edx
80102aa0:	ec                   	in     (%dx),%al
  r->month  = cmos_read(MONTH);
80102aa1:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102aa4:	89 fa                	mov    %edi,%edx
80102aa6:	89 45 c8             	mov    %eax,-0x38(%ebp)
80102aa9:	b8 09 00 00 00       	mov    $0x9,%eax
80102aae:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102aaf:	89 ca                	mov    %ecx,%edx
80102ab1:	ec                   	in     (%dx),%al
  r->year   = cmos_read(YEAR);
80102ab2:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ab5:	89 fa                	mov    %edi,%edx
80102ab7:	89 45 cc             	mov    %eax,-0x34(%ebp)
80102aba:	b8 0a 00 00 00       	mov    $0xa,%eax
80102abf:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ac0:	89 ca                	mov    %ecx,%edx
80102ac2:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102ac3:	84 c0                	test   %al,%al
80102ac5:	78 89                	js     80102a50 <cmostime+0x30>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ac7:	89 d8                	mov    %ebx,%eax
80102ac9:	89 fa                	mov    %edi,%edx
80102acb:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102acc:	89 ca                	mov    %ecx,%edx
80102ace:	ec                   	in     (%dx),%al
}

static void
fill_rtcdate(struct rtcdate *r)
{
  r->second = cmos_read(SECS);
80102acf:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ad2:	89 fa                	mov    %edi,%edx
80102ad4:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102ad7:	b8 02 00 00 00       	mov    $0x2,%eax
80102adc:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102add:	89 ca                	mov    %ecx,%edx
80102adf:	ec                   	in     (%dx),%al
  r->minute = cmos_read(MINS);
80102ae0:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ae3:	89 fa                	mov    %edi,%edx
80102ae5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102ae8:	b8 04 00 00 00       	mov    $0x4,%eax
80102aed:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102aee:	89 ca                	mov    %ecx,%edx
80102af0:	ec                   	in     (%dx),%al
  r->hour   = cmos_read(HOURS);
80102af1:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102af4:	89 fa                	mov    %edi,%edx
80102af6:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102af9:	b8 07 00 00 00       	mov    $0x7,%eax
80102afe:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102aff:	89 ca                	mov    %ecx,%edx
80102b01:	ec                   	in     (%dx),%al
  r->day    = cmos_read(DAY);
80102b02:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b05:	89 fa                	mov    %edi,%edx
80102b07:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102b0a:	b8 08 00 00 00       	mov    $0x8,%eax
80102b0f:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b10:	89 ca                	mov    %ecx,%edx
80102b12:	ec                   	in     (%dx),%al
  r->month  = cmos_read(MONTH);
80102b13:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b16:	89 fa                	mov    %edi,%edx
80102b18:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102b1b:	b8 09 00 00 00       	mov    $0x9,%eax
80102b20:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b21:	89 ca                	mov    %ecx,%edx
80102b23:	ec                   	in     (%dx),%al
  r->year   = cmos_read(YEAR);
80102b24:	0f b6 c0             	movzbl %al,%eax
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102b27:	83 ec 04             	sub    $0x4,%esp
  r->second = cmos_read(SECS);
  r->minute = cmos_read(MINS);
  r->hour   = cmos_read(HOURS);
  r->day    = cmos_read(DAY);
  r->month  = cmos_read(MONTH);
  r->year   = cmos_read(YEAR);
80102b2a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102b2d:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102b30:	6a 18                	push   $0x18
80102b32:	56                   	push   %esi
80102b33:	50                   	push   %eax
80102b34:	e8 47 27 00 00       	call   80105280 <memcmp>
80102b39:	83 c4 10             	add    $0x10,%esp
80102b3c:	85 c0                	test   %eax,%eax
80102b3e:	0f 85 0c ff ff ff    	jne    80102a50 <cmostime+0x30>
      break;
  }

  // convert
  if(bcd) {
80102b44:	80 7d b7 00          	cmpb   $0x0,-0x49(%ebp)
80102b48:	75 78                	jne    80102bc2 <cmostime+0x1a2>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102b4a:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102b4d:	89 c2                	mov    %eax,%edx
80102b4f:	83 e0 0f             	and    $0xf,%eax
80102b52:	c1 ea 04             	shr    $0x4,%edx
80102b55:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b58:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b5b:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102b5e:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102b61:	89 c2                	mov    %eax,%edx
80102b63:	83 e0 0f             	and    $0xf,%eax
80102b66:	c1 ea 04             	shr    $0x4,%edx
80102b69:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b6c:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b6f:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102b72:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b75:	89 c2                	mov    %eax,%edx
80102b77:	83 e0 0f             	and    $0xf,%eax
80102b7a:	c1 ea 04             	shr    $0x4,%edx
80102b7d:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b80:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b83:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102b86:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b89:	89 c2                	mov    %eax,%edx
80102b8b:	83 e0 0f             	and    $0xf,%eax
80102b8e:	c1 ea 04             	shr    $0x4,%edx
80102b91:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b94:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b97:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102b9a:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102b9d:	89 c2                	mov    %eax,%edx
80102b9f:	83 e0 0f             	and    $0xf,%eax
80102ba2:	c1 ea 04             	shr    $0x4,%edx
80102ba5:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102ba8:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102bab:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102bae:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102bb1:	89 c2                	mov    %eax,%edx
80102bb3:	83 e0 0f             	and    $0xf,%eax
80102bb6:	c1 ea 04             	shr    $0x4,%edx
80102bb9:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102bbc:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102bbf:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102bc2:	8b 75 08             	mov    0x8(%ebp),%esi
80102bc5:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102bc8:	89 06                	mov    %eax,(%esi)
80102bca:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102bcd:	89 46 04             	mov    %eax,0x4(%esi)
80102bd0:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102bd3:	89 46 08             	mov    %eax,0x8(%esi)
80102bd6:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102bd9:	89 46 0c             	mov    %eax,0xc(%esi)
80102bdc:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102bdf:	89 46 10             	mov    %eax,0x10(%esi)
80102be2:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102be5:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102be8:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102bef:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102bf2:	5b                   	pop    %ebx
80102bf3:	5e                   	pop    %esi
80102bf4:	5f                   	pop    %edi
80102bf5:	5d                   	pop    %ebp
80102bf6:	c3                   	ret    
80102bf7:	66 90                	xchg   %ax,%ax
80102bf9:	66 90                	xchg   %ax,%ax
80102bfb:	66 90                	xchg   %ax,%ax
80102bfd:	66 90                	xchg   %ax,%ax
80102bff:	90                   	nop

80102c00 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102c00:	8b 0d 48 37 11 80    	mov    0x80113748,%ecx
80102c06:	85 c9                	test   %ecx,%ecx
80102c08:	0f 8e 85 00 00 00    	jle    80102c93 <install_trans+0x93>
}

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
80102c0e:	55                   	push   %ebp
80102c0f:	89 e5                	mov    %esp,%ebp
80102c11:	57                   	push   %edi
80102c12:	56                   	push   %esi
80102c13:	53                   	push   %ebx
80102c14:	31 db                	xor    %ebx,%ebx
80102c16:	83 ec 0c             	sub    $0xc,%esp
80102c19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102c20:	a1 34 37 11 80       	mov    0x80113734,%eax
80102c25:	83 ec 08             	sub    $0x8,%esp
80102c28:	01 d8                	add    %ebx,%eax
80102c2a:	83 c0 01             	add    $0x1,%eax
80102c2d:	50                   	push   %eax
80102c2e:	ff 35 44 37 11 80    	pushl  0x80113744
80102c34:	e8 97 d4 ff ff       	call   801000d0 <bread>
80102c39:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c3b:	58                   	pop    %eax
80102c3c:	5a                   	pop    %edx
80102c3d:	ff 34 9d 4c 37 11 80 	pushl  -0x7feec8b4(,%ebx,4)
80102c44:	ff 35 44 37 11 80    	pushl  0x80113744
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102c4a:	83 c3 01             	add    $0x1,%ebx
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c4d:	e8 7e d4 ff ff       	call   801000d0 <bread>
80102c52:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102c54:	8d 47 5c             	lea    0x5c(%edi),%eax
80102c57:	83 c4 0c             	add    $0xc,%esp
80102c5a:	68 00 02 00 00       	push   $0x200
80102c5f:	50                   	push   %eax
80102c60:	8d 46 5c             	lea    0x5c(%esi),%eax
80102c63:	50                   	push   %eax
80102c64:	e8 77 26 00 00       	call   801052e0 <memmove>
    bwrite(dbuf);  // write dst to disk
80102c69:	89 34 24             	mov    %esi,(%esp)
80102c6c:	e8 2f d5 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102c71:	89 3c 24             	mov    %edi,(%esp)
80102c74:	e8 67 d5 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102c79:	89 34 24             	mov    %esi,(%esp)
80102c7c:	e8 5f d5 ff ff       	call   801001e0 <brelse>
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102c81:	83 c4 10             	add    $0x10,%esp
80102c84:	39 1d 48 37 11 80    	cmp    %ebx,0x80113748
80102c8a:	7f 94                	jg     80102c20 <install_trans+0x20>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf);
    brelse(dbuf);
  }
}
80102c8c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c8f:	5b                   	pop    %ebx
80102c90:	5e                   	pop    %esi
80102c91:	5f                   	pop    %edi
80102c92:	5d                   	pop    %ebp
80102c93:	f3 c3                	repz ret 
80102c95:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102ca0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102ca0:	55                   	push   %ebp
80102ca1:	89 e5                	mov    %esp,%ebp
80102ca3:	53                   	push   %ebx
80102ca4:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102ca7:	ff 35 34 37 11 80    	pushl  0x80113734
80102cad:	ff 35 44 37 11 80    	pushl  0x80113744
80102cb3:	e8 18 d4 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102cb8:	8b 0d 48 37 11 80    	mov    0x80113748,%ecx
  for (i = 0; i < log.lh.n; i++) {
80102cbe:	83 c4 10             	add    $0x10,%esp
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102cc1:	89 c3                	mov    %eax,%ebx
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102cc3:	85 c9                	test   %ecx,%ecx
write_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102cc5:	89 48 5c             	mov    %ecx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102cc8:	7e 1f                	jle    80102ce9 <write_head+0x49>
80102cca:	8d 04 8d 00 00 00 00 	lea    0x0(,%ecx,4),%eax
80102cd1:	31 d2                	xor    %edx,%edx
80102cd3:	90                   	nop
80102cd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
80102cd8:	8b 8a 4c 37 11 80    	mov    -0x7feec8b4(%edx),%ecx
80102cde:	89 4c 13 60          	mov    %ecx,0x60(%ebx,%edx,1)
80102ce2:	83 c2 04             	add    $0x4,%edx
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102ce5:	39 c2                	cmp    %eax,%edx
80102ce7:	75 ef                	jne    80102cd8 <write_head+0x38>
    hb->block[i] = log.lh.block[i];
  }
  bwrite(buf);
80102ce9:	83 ec 0c             	sub    $0xc,%esp
80102cec:	53                   	push   %ebx
80102ced:	e8 ae d4 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102cf2:	89 1c 24             	mov    %ebx,(%esp)
80102cf5:	e8 e6 d4 ff ff       	call   801001e0 <brelse>
}
80102cfa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102cfd:	c9                   	leave  
80102cfe:	c3                   	ret    
80102cff:	90                   	nop

80102d00 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
80102d00:	55                   	push   %ebp
80102d01:	89 e5                	mov    %esp,%ebp
80102d03:	53                   	push   %ebx
80102d04:	83 ec 2c             	sub    $0x2c,%esp
80102d07:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
80102d0a:	68 00 85 10 80       	push   $0x80108500
80102d0f:	68 00 37 11 80       	push   $0x80113700
80102d14:	e8 b7 22 00 00       	call   80104fd0 <initlock>
  readsb(dev, &sb);
80102d19:	58                   	pop    %eax
80102d1a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102d1d:	5a                   	pop    %edx
80102d1e:	50                   	push   %eax
80102d1f:	53                   	push   %ebx
80102d20:	e8 5b e9 ff ff       	call   80101680 <readsb>
  log.start = sb.logstart;
  log.size = sb.nlog;
80102d25:	8b 55 e8             	mov    -0x18(%ebp),%edx
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
80102d28:	8b 45 ec             	mov    -0x14(%ebp),%eax

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102d2b:	59                   	pop    %ecx
  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
80102d2c:	89 1d 44 37 11 80    	mov    %ebx,0x80113744

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
80102d32:	89 15 38 37 11 80    	mov    %edx,0x80113738
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
80102d38:	a3 34 37 11 80       	mov    %eax,0x80113734

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102d3d:	5a                   	pop    %edx
80102d3e:	50                   	push   %eax
80102d3f:	53                   	push   %ebx
80102d40:	e8 8b d3 ff ff       	call   801000d0 <bread>
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102d45:	8b 48 5c             	mov    0x5c(%eax),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102d48:	83 c4 10             	add    $0x10,%esp
80102d4b:	85 c9                	test   %ecx,%ecx
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102d4d:	89 0d 48 37 11 80    	mov    %ecx,0x80113748
  for (i = 0; i < log.lh.n; i++) {
80102d53:	7e 1c                	jle    80102d71 <initlog+0x71>
80102d55:	8d 1c 8d 00 00 00 00 	lea    0x0(,%ecx,4),%ebx
80102d5c:	31 d2                	xor    %edx,%edx
80102d5e:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80102d60:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80102d64:	83 c2 04             	add    $0x4,%edx
80102d67:	89 8a 48 37 11 80    	mov    %ecx,-0x7feec8b8(%edx)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
80102d6d:	39 da                	cmp    %ebx,%edx
80102d6f:	75 ef                	jne    80102d60 <initlog+0x60>
    log.lh.block[i] = lh->block[i];
  }
  brelse(buf);
80102d71:	83 ec 0c             	sub    $0xc,%esp
80102d74:	50                   	push   %eax
80102d75:	e8 66 d4 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102d7a:	e8 81 fe ff ff       	call   80102c00 <install_trans>
  log.lh.n = 0;
80102d7f:	c7 05 48 37 11 80 00 	movl   $0x0,0x80113748
80102d86:	00 00 00 
  write_head(); // clear the log
80102d89:	e8 12 ff ff ff       	call   80102ca0 <write_head>
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
  recover_from_log();
}
80102d8e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d91:	c9                   	leave  
80102d92:	c3                   	ret    
80102d93:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102d99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102da0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102da0:	55                   	push   %ebp
80102da1:	89 e5                	mov    %esp,%ebp
80102da3:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102da6:	68 00 37 11 80       	push   $0x80113700
80102dab:	e8 80 23 00 00       	call   80105130 <acquire>
80102db0:	83 c4 10             	add    $0x10,%esp
80102db3:	eb 18                	jmp    80102dcd <begin_op+0x2d>
80102db5:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102db8:	83 ec 08             	sub    $0x8,%esp
80102dbb:	68 00 37 11 80       	push   $0x80113700
80102dc0:	68 00 37 11 80       	push   $0x80113700
80102dc5:	e8 06 16 00 00       	call   801043d0 <sleep>
80102dca:	83 c4 10             	add    $0x10,%esp
void
begin_op(void)
{
  acquire(&log.lock);
  while(1){
    if(log.committing){
80102dcd:	a1 40 37 11 80       	mov    0x80113740,%eax
80102dd2:	85 c0                	test   %eax,%eax
80102dd4:	75 e2                	jne    80102db8 <begin_op+0x18>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102dd6:	a1 3c 37 11 80       	mov    0x8011373c,%eax
80102ddb:	8b 15 48 37 11 80    	mov    0x80113748,%edx
80102de1:	83 c0 01             	add    $0x1,%eax
80102de4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102de7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102dea:	83 fa 1e             	cmp    $0x1e,%edx
80102ded:	7f c9                	jg     80102db8 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102def:	83 ec 0c             	sub    $0xc,%esp
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
80102df2:	a3 3c 37 11 80       	mov    %eax,0x8011373c
      release(&log.lock);
80102df7:	68 00 37 11 80       	push   $0x80113700
80102dfc:	e8 df 23 00 00       	call   801051e0 <release>
      break;
    }
  }
}
80102e01:	83 c4 10             	add    $0x10,%esp
80102e04:	c9                   	leave  
80102e05:	c3                   	ret    
80102e06:	8d 76 00             	lea    0x0(%esi),%esi
80102e09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102e10 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102e10:	55                   	push   %ebp
80102e11:	89 e5                	mov    %esp,%ebp
80102e13:	57                   	push   %edi
80102e14:	56                   	push   %esi
80102e15:	53                   	push   %ebx
80102e16:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102e19:	68 00 37 11 80       	push   $0x80113700
80102e1e:	e8 0d 23 00 00       	call   80105130 <acquire>
  log.outstanding -= 1;
80102e23:	a1 3c 37 11 80       	mov    0x8011373c,%eax
  if(log.committing)
80102e28:	8b 1d 40 37 11 80    	mov    0x80113740,%ebx
80102e2e:	83 c4 10             	add    $0x10,%esp
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80102e31:	83 e8 01             	sub    $0x1,%eax
  if(log.committing)
80102e34:	85 db                	test   %ebx,%ebx
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80102e36:	a3 3c 37 11 80       	mov    %eax,0x8011373c
  if(log.committing)
80102e3b:	0f 85 23 01 00 00    	jne    80102f64 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102e41:	85 c0                	test   %eax,%eax
80102e43:	0f 85 f7 00 00 00    	jne    80102f40 <end_op+0x130>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102e49:	83 ec 0c             	sub    $0xc,%esp
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
  if(log.outstanding == 0){
    do_commit = 1;
    log.committing = 1;
80102e4c:	c7 05 40 37 11 80 01 	movl   $0x1,0x80113740
80102e53:	00 00 00 
}

static void
commit()
{
  if (log.lh.n > 0) {
80102e56:	31 db                	xor    %ebx,%ebx
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102e58:	68 00 37 11 80       	push   $0x80113700
80102e5d:	e8 7e 23 00 00       	call   801051e0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102e62:	8b 0d 48 37 11 80    	mov    0x80113748,%ecx
80102e68:	83 c4 10             	add    $0x10,%esp
80102e6b:	85 c9                	test   %ecx,%ecx
80102e6d:	0f 8e 8a 00 00 00    	jle    80102efd <end_op+0xed>
80102e73:	90                   	nop
80102e74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102e78:	a1 34 37 11 80       	mov    0x80113734,%eax
80102e7d:	83 ec 08             	sub    $0x8,%esp
80102e80:	01 d8                	add    %ebx,%eax
80102e82:	83 c0 01             	add    $0x1,%eax
80102e85:	50                   	push   %eax
80102e86:	ff 35 44 37 11 80    	pushl  0x80113744
80102e8c:	e8 3f d2 ff ff       	call   801000d0 <bread>
80102e91:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e93:	58                   	pop    %eax
80102e94:	5a                   	pop    %edx
80102e95:	ff 34 9d 4c 37 11 80 	pushl  -0x7feec8b4(,%ebx,4)
80102e9c:	ff 35 44 37 11 80    	pushl  0x80113744
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102ea2:	83 c3 01             	add    $0x1,%ebx
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102ea5:	e8 26 d2 ff ff       	call   801000d0 <bread>
80102eaa:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102eac:	8d 40 5c             	lea    0x5c(%eax),%eax
80102eaf:	83 c4 0c             	add    $0xc,%esp
80102eb2:	68 00 02 00 00       	push   $0x200
80102eb7:	50                   	push   %eax
80102eb8:	8d 46 5c             	lea    0x5c(%esi),%eax
80102ebb:	50                   	push   %eax
80102ebc:	e8 1f 24 00 00       	call   801052e0 <memmove>
    bwrite(to);  // write the log
80102ec1:	89 34 24             	mov    %esi,(%esp)
80102ec4:	e8 d7 d2 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102ec9:	89 3c 24             	mov    %edi,(%esp)
80102ecc:	e8 0f d3 ff ff       	call   801001e0 <brelse>
    brelse(to);
80102ed1:	89 34 24             	mov    %esi,(%esp)
80102ed4:	e8 07 d3 ff ff       	call   801001e0 <brelse>
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102ed9:	83 c4 10             	add    $0x10,%esp
80102edc:	3b 1d 48 37 11 80    	cmp    0x80113748,%ebx
80102ee2:	7c 94                	jl     80102e78 <end_op+0x68>
static void
commit()
{
  if (log.lh.n > 0) {
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102ee4:	e8 b7 fd ff ff       	call   80102ca0 <write_head>
    install_trans(); // Now install writes to home locations
80102ee9:	e8 12 fd ff ff       	call   80102c00 <install_trans>
    log.lh.n = 0;
80102eee:	c7 05 48 37 11 80 00 	movl   $0x0,0x80113748
80102ef5:	00 00 00 
    write_head();    // Erase the transaction from the log
80102ef8:	e8 a3 fd ff ff       	call   80102ca0 <write_head>

  if(do_commit){
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
    acquire(&log.lock);
80102efd:	83 ec 0c             	sub    $0xc,%esp
80102f00:	68 00 37 11 80       	push   $0x80113700
80102f05:	e8 26 22 00 00       	call   80105130 <acquire>
    log.committing = 0;
    wakeup(&log);
80102f0a:	c7 04 24 00 37 11 80 	movl   $0x80113700,(%esp)
  if(do_commit){
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
    acquire(&log.lock);
    log.committing = 0;
80102f11:	c7 05 40 37 11 80 00 	movl   $0x0,0x80113740
80102f18:	00 00 00 
    wakeup(&log);
80102f1b:	e8 70 16 00 00       	call   80104590 <wakeup>
    release(&log.lock);
80102f20:	c7 04 24 00 37 11 80 	movl   $0x80113700,(%esp)
80102f27:	e8 b4 22 00 00       	call   801051e0 <release>
80102f2c:	83 c4 10             	add    $0x10,%esp
  }
}
80102f2f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f32:	5b                   	pop    %ebx
80102f33:	5e                   	pop    %esi
80102f34:	5f                   	pop    %edi
80102f35:	5d                   	pop    %ebp
80102f36:	c3                   	ret    
80102f37:	89 f6                	mov    %esi,%esi
80102f39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    log.committing = 1;
  } else {
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
80102f40:	83 ec 0c             	sub    $0xc,%esp
80102f43:	68 00 37 11 80       	push   $0x80113700
80102f48:	e8 43 16 00 00       	call   80104590 <wakeup>
  }
  release(&log.lock);
80102f4d:	c7 04 24 00 37 11 80 	movl   $0x80113700,(%esp)
80102f54:	e8 87 22 00 00       	call   801051e0 <release>
80102f59:	83 c4 10             	add    $0x10,%esp
    acquire(&log.lock);
    log.committing = 0;
    wakeup(&log);
    release(&log.lock);
  }
}
80102f5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f5f:	5b                   	pop    %ebx
80102f60:	5e                   	pop    %esi
80102f61:	5f                   	pop    %edi
80102f62:	5d                   	pop    %ebp
80102f63:	c3                   	ret    
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
80102f64:	83 ec 0c             	sub    $0xc,%esp
80102f67:	68 04 85 10 80       	push   $0x80108504
80102f6c:	e8 ff d3 ff ff       	call   80100370 <panic>
80102f71:	eb 0d                	jmp    80102f80 <log_write>
80102f73:	90                   	nop
80102f74:	90                   	nop
80102f75:	90                   	nop
80102f76:	90                   	nop
80102f77:	90                   	nop
80102f78:	90                   	nop
80102f79:	90                   	nop
80102f7a:	90                   	nop
80102f7b:	90                   	nop
80102f7c:	90                   	nop
80102f7d:	90                   	nop
80102f7e:	90                   	nop
80102f7f:	90                   	nop

80102f80 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102f80:	55                   	push   %ebp
80102f81:	89 e5                	mov    %esp,%ebp
80102f83:	53                   	push   %ebx
80102f84:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f87:	8b 15 48 37 11 80    	mov    0x80113748,%edx
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102f8d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f90:	83 fa 1d             	cmp    $0x1d,%edx
80102f93:	0f 8f 97 00 00 00    	jg     80103030 <log_write+0xb0>
80102f99:	a1 38 37 11 80       	mov    0x80113738,%eax
80102f9e:	83 e8 01             	sub    $0x1,%eax
80102fa1:	39 c2                	cmp    %eax,%edx
80102fa3:	0f 8d 87 00 00 00    	jge    80103030 <log_write+0xb0>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102fa9:	a1 3c 37 11 80       	mov    0x8011373c,%eax
80102fae:	85 c0                	test   %eax,%eax
80102fb0:	0f 8e 87 00 00 00    	jle    8010303d <log_write+0xbd>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102fb6:	83 ec 0c             	sub    $0xc,%esp
80102fb9:	68 00 37 11 80       	push   $0x80113700
80102fbe:	e8 6d 21 00 00       	call   80105130 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102fc3:	8b 15 48 37 11 80    	mov    0x80113748,%edx
80102fc9:	83 c4 10             	add    $0x10,%esp
80102fcc:	83 fa 00             	cmp    $0x0,%edx
80102fcf:	7e 50                	jle    80103021 <log_write+0xa1>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102fd1:	8b 4b 08             	mov    0x8(%ebx),%ecx
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80102fd4:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102fd6:	3b 0d 4c 37 11 80    	cmp    0x8011374c,%ecx
80102fdc:	75 0b                	jne    80102fe9 <log_write+0x69>
80102fde:	eb 38                	jmp    80103018 <log_write+0x98>
80102fe0:	39 0c 85 4c 37 11 80 	cmp    %ecx,-0x7feec8b4(,%eax,4)
80102fe7:	74 2f                	je     80103018 <log_write+0x98>
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80102fe9:	83 c0 01             	add    $0x1,%eax
80102fec:	39 d0                	cmp    %edx,%eax
80102fee:	75 f0                	jne    80102fe0 <log_write+0x60>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80102ff0:	89 0c 95 4c 37 11 80 	mov    %ecx,-0x7feec8b4(,%edx,4)
  if (i == log.lh.n)
    log.lh.n++;
80102ff7:	83 c2 01             	add    $0x1,%edx
80102ffa:	89 15 48 37 11 80    	mov    %edx,0x80113748
  b->flags |= B_DIRTY; // prevent eviction
80103000:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80103003:	c7 45 08 00 37 11 80 	movl   $0x80113700,0x8(%ebp)
}
8010300a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010300d:	c9                   	leave  
  }
  log.lh.block[i] = b->blockno;
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
  release(&log.lock);
8010300e:	e9 cd 21 00 00       	jmp    801051e0 <release>
80103013:	90                   	nop
80103014:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80103018:	89 0c 85 4c 37 11 80 	mov    %ecx,-0x7feec8b4(,%eax,4)
8010301f:	eb df                	jmp    80103000 <log_write+0x80>
80103021:	8b 43 08             	mov    0x8(%ebx),%eax
80103024:	a3 4c 37 11 80       	mov    %eax,0x8011374c
  if (i == log.lh.n)
80103029:	75 d5                	jne    80103000 <log_write+0x80>
8010302b:	eb ca                	jmp    80102ff7 <log_write+0x77>
8010302d:	8d 76 00             	lea    0x0(%esi),%esi
log_write(struct buf *b)
{
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    panic("too big a transaction");
80103030:	83 ec 0c             	sub    $0xc,%esp
80103033:	68 13 85 10 80       	push   $0x80108513
80103038:	e8 33 d3 ff ff       	call   80100370 <panic>
  if (log.outstanding < 1)
    panic("log_write outside of trans");
8010303d:	83 ec 0c             	sub    $0xc,%esp
80103040:	68 29 85 10 80       	push   $0x80108529
80103045:	e8 26 d3 ff ff       	call   80100370 <panic>
8010304a:	66 90                	xchg   %ax,%ax
8010304c:	66 90                	xchg   %ax,%ax
8010304e:	66 90                	xchg   %ax,%ax

80103050 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103050:	55                   	push   %ebp
80103051:	89 e5                	mov    %esp,%ebp
80103053:	53                   	push   %ebx
80103054:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103057:	e8 b4 09 00 00       	call   80103a10 <cpuid>
8010305c:	89 c3                	mov    %eax,%ebx
8010305e:	e8 ad 09 00 00       	call   80103a10 <cpuid>
80103063:	83 ec 04             	sub    $0x4,%esp
80103066:	53                   	push   %ebx
80103067:	50                   	push   %eax
80103068:	68 44 85 10 80       	push   $0x80108544
8010306d:	e8 ee d5 ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
80103072:	e8 e9 37 00 00       	call   80106860 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103077:	e8 44 09 00 00       	call   801039c0 <mycpu>
8010307c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010307e:	b8 01 00 00 00       	mov    $0x1,%eax
80103083:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010308a:	e8 41 0f 00 00       	call   80103fd0 <scheduler>
8010308f:	90                   	nop

80103090 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
80103090:	55                   	push   %ebp
80103091:	89 e5                	mov    %esp,%ebp
80103093:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103096:	e8 f5 48 00 00       	call   80107990 <switchkvm>
  seginit();
8010309b:	e8 f0 47 00 00       	call   80107890 <seginit>
  lapicinit();
801030a0:	e8 9b f7 ff ff       	call   80102840 <lapicinit>
  mpmain();
801030a5:	e8 a6 ff ff ff       	call   80103050 <mpmain>
801030aa:	66 90                	xchg   %ax,%ax
801030ac:	66 90                	xchg   %ax,%ax
801030ae:	66 90                	xchg   %ax,%ax

801030b0 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
801030b0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
801030b4:	83 e4 f0             	and    $0xfffffff0,%esp
801030b7:	ff 71 fc             	pushl  -0x4(%ecx)
801030ba:	55                   	push   %ebp
801030bb:	89 e5                	mov    %esp,%ebp
801030bd:	53                   	push   %ebx
801030be:	51                   	push   %ecx
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
801030bf:	bb 00 38 11 80       	mov    $0x80113800,%ebx
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
801030c4:	83 ec 08             	sub    $0x8,%esp
801030c7:	68 00 00 40 80       	push   $0x80400000
801030cc:	68 68 66 11 80       	push   $0x80116668
801030d1:	e8 3a f5 ff ff       	call   80102610 <kinit1>
  kvmalloc();      // kernel page table
801030d6:	e8 55 4d 00 00       	call   80107e30 <kvmalloc>
  mpinit();        // detect other processors
801030db:	e8 70 01 00 00       	call   80103250 <mpinit>
  lapicinit();     // interrupt controller
801030e0:	e8 5b f7 ff ff       	call   80102840 <lapicinit>
  seginit();       // segment descriptors
801030e5:	e8 a6 47 00 00       	call   80107890 <seginit>
  picinit();       // disable pic
801030ea:	e8 31 03 00 00       	call   80103420 <picinit>
  ioapicinit();    // another interrupt controller
801030ef:	e8 4c f3 ff ff       	call   80102440 <ioapicinit>
  consoleinit();   // console hardware
801030f4:	e8 a7 d8 ff ff       	call   801009a0 <consoleinit>
  uartinit();      // serial port
801030f9:	e8 62 3a 00 00       	call   80106b60 <uartinit>
  pinit();         // process table
801030fe:	e8 9d 08 00 00       	call   801039a0 <pinit>
  tvinit();        // trap vectors
80103103:	e8 b8 36 00 00       	call   801067c0 <tvinit>
  binit();         // buffer cache
80103108:	e8 33 cf ff ff       	call   80100040 <binit>
  fileinit();      // file table
8010310d:	e8 9e de ff ff       	call   80100fb0 <fileinit>
  ideinit();       // disk 
80103112:	e8 09 f1 ff ff       	call   80102220 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103117:	83 c4 0c             	add    $0xc,%esp
8010311a:	68 8a 00 00 00       	push   $0x8a
8010311f:	68 8c b4 10 80       	push   $0x8010b48c
80103124:	68 00 70 00 80       	push   $0x80007000
80103129:	e8 b2 21 00 00       	call   801052e0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
8010312e:	69 05 b0 38 11 80 b0 	imul   $0xb0,0x801138b0,%eax
80103135:	00 00 00 
80103138:	83 c4 10             	add    $0x10,%esp
8010313b:	05 00 38 11 80       	add    $0x80113800,%eax
80103140:	39 d8                	cmp    %ebx,%eax
80103142:	76 6f                	jbe    801031b3 <main+0x103>
80103144:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(c == mycpu())  // We've started already.
80103148:	e8 73 08 00 00       	call   801039c0 <mycpu>
8010314d:	39 d8                	cmp    %ebx,%eax
8010314f:	74 49                	je     8010319a <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103151:	e8 8a f5 ff ff       	call   801026e0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
80103156:	05 00 10 00 00       	add    $0x1000,%eax
    *(void(**)(void))(code-8) = mpenter;
8010315b:	c7 05 f8 6f 00 80 90 	movl   $0x80103090,0x80006ff8
80103162:	30 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103165:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
8010316c:	a0 10 00 

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
    *(void**)(code-4) = stack + KSTACKSIZE;
8010316f:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103174:	0f b6 03             	movzbl (%ebx),%eax
80103177:	83 ec 08             	sub    $0x8,%esp
8010317a:	68 00 70 00 00       	push   $0x7000
8010317f:	50                   	push   %eax
80103180:	e8 0b f8 ff ff       	call   80102990 <lapicstartap>
80103185:	83 c4 10             	add    $0x10,%esp
80103188:	90                   	nop
80103189:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103190:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103196:	85 c0                	test   %eax,%eax
80103198:	74 f6                	je     80103190 <main+0xe0>
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
8010319a:	69 05 b0 38 11 80 b0 	imul   $0xb0,0x801138b0,%eax
801031a1:	00 00 00 
801031a4:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
801031aa:	05 00 38 11 80       	add    $0x80113800,%eax
801031af:	39 c3                	cmp    %eax,%ebx
801031b1:	72 95                	jb     80103148 <main+0x98>
  tvinit();        // trap vectors
  binit();         // buffer cache
  fileinit();      // file table
  ideinit();       // disk 
  startothers();   // start other processors
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801031b3:	83 ec 08             	sub    $0x8,%esp
801031b6:	68 00 00 00 8e       	push   $0x8e000000
801031bb:	68 00 00 40 80       	push   $0x80400000
801031c0:	e8 bb f4 ff ff       	call   80102680 <kinit2>
  userinit();      // first user process
801031c5:	e8 96 08 00 00       	call   80103a60 <userinit>
  mpmain();        // finish this processor's setup
801031ca:	e8 81 fe ff ff       	call   80103050 <mpmain>
801031cf:	90                   	nop

801031d0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801031d0:	55                   	push   %ebp
801031d1:	89 e5                	mov    %esp,%ebp
801031d3:	57                   	push   %edi
801031d4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
801031d5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801031db:	53                   	push   %ebx
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
801031dc:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801031df:	83 ec 0c             	sub    $0xc,%esp
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
801031e2:	39 de                	cmp    %ebx,%esi
801031e4:	73 48                	jae    8010322e <mpsearch1+0x5e>
801031e6:	8d 76 00             	lea    0x0(%esi),%esi
801031e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801031f0:	83 ec 04             	sub    $0x4,%esp
801031f3:	8d 7e 10             	lea    0x10(%esi),%edi
801031f6:	6a 04                	push   $0x4
801031f8:	68 58 85 10 80       	push   $0x80108558
801031fd:	56                   	push   %esi
801031fe:	e8 7d 20 00 00       	call   80105280 <memcmp>
80103203:	83 c4 10             	add    $0x10,%esp
80103206:	85 c0                	test   %eax,%eax
80103208:	75 1e                	jne    80103228 <mpsearch1+0x58>
8010320a:	8d 7e 10             	lea    0x10(%esi),%edi
8010320d:	89 f2                	mov    %esi,%edx
8010320f:	31 c9                	xor    %ecx,%ecx
80103211:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
    sum += addr[i];
80103218:	0f b6 02             	movzbl (%edx),%eax
8010321b:	83 c2 01             	add    $0x1,%edx
8010321e:	01 c1                	add    %eax,%ecx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80103220:	39 fa                	cmp    %edi,%edx
80103222:	75 f4                	jne    80103218 <mpsearch1+0x48>
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103224:	84 c9                	test   %cl,%cl
80103226:	74 10                	je     80103238 <mpsearch1+0x68>
{
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80103228:	39 fb                	cmp    %edi,%ebx
8010322a:	89 fe                	mov    %edi,%esi
8010322c:	77 c2                	ja     801031f0 <mpsearch1+0x20>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
}
8010322e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80103231:	31 c0                	xor    %eax,%eax
}
80103233:	5b                   	pop    %ebx
80103234:	5e                   	pop    %esi
80103235:	5f                   	pop    %edi
80103236:	5d                   	pop    %ebp
80103237:	c3                   	ret    
80103238:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010323b:	89 f0                	mov    %esi,%eax
8010323d:	5b                   	pop    %ebx
8010323e:	5e                   	pop    %esi
8010323f:	5f                   	pop    %edi
80103240:	5d                   	pop    %ebp
80103241:	c3                   	ret    
80103242:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103249:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103250 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103250:	55                   	push   %ebp
80103251:	89 e5                	mov    %esp,%ebp
80103253:	57                   	push   %edi
80103254:	56                   	push   %esi
80103255:	53                   	push   %ebx
80103256:	83 ec 1c             	sub    $0x1c,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103259:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103260:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103267:	c1 e0 08             	shl    $0x8,%eax
8010326a:	09 d0                	or     %edx,%eax
8010326c:	c1 e0 04             	shl    $0x4,%eax
8010326f:	85 c0                	test   %eax,%eax
80103271:	75 1b                	jne    8010328e <mpinit+0x3e>
    if((mp = mpsearch1(p, 1024)))
      return mp;
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
80103273:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010327a:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103281:	c1 e0 08             	shl    $0x8,%eax
80103284:	09 d0                	or     %edx,%eax
80103286:	c1 e0 0a             	shl    $0xa,%eax
80103289:	2d 00 04 00 00       	sub    $0x400,%eax
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
    if((mp = mpsearch1(p, 1024)))
8010328e:	ba 00 04 00 00       	mov    $0x400,%edx
80103293:	e8 38 ff ff ff       	call   801031d0 <mpsearch1>
80103298:	85 c0                	test   %eax,%eax
8010329a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010329d:	0f 84 38 01 00 00    	je     801033db <mpinit+0x18b>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801032a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801032a6:	8b 58 04             	mov    0x4(%eax),%ebx
801032a9:	85 db                	test   %ebx,%ebx
801032ab:	0f 84 44 01 00 00    	je     801033f5 <mpinit+0x1a5>
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801032b1:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
801032b7:	83 ec 04             	sub    $0x4,%esp
801032ba:	6a 04                	push   $0x4
801032bc:	68 5d 85 10 80       	push   $0x8010855d
801032c1:	56                   	push   %esi
801032c2:	e8 b9 1f 00 00       	call   80105280 <memcmp>
801032c7:	83 c4 10             	add    $0x10,%esp
801032ca:	85 c0                	test   %eax,%eax
801032cc:	0f 85 23 01 00 00    	jne    801033f5 <mpinit+0x1a5>
    return 0;
  if(conf->version != 1 && conf->version != 4)
801032d2:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
801032d9:	3c 01                	cmp    $0x1,%al
801032db:	74 08                	je     801032e5 <mpinit+0x95>
801032dd:	3c 04                	cmp    $0x4,%al
801032df:	0f 85 10 01 00 00    	jne    801033f5 <mpinit+0x1a5>
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
801032e5:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
801032ec:	85 ff                	test   %edi,%edi
801032ee:	74 21                	je     80103311 <mpinit+0xc1>
801032f0:	31 d2                	xor    %edx,%edx
801032f2:	31 c0                	xor    %eax,%eax
801032f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
801032f8:	0f b6 8c 03 00 00 00 	movzbl -0x80000000(%ebx,%eax,1),%ecx
801032ff:	80 
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80103300:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
80103303:	01 ca                	add    %ecx,%edx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80103305:	39 c7                	cmp    %eax,%edi
80103307:	75 ef                	jne    801032f8 <mpinit+0xa8>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
  if(memcmp(conf, "PCMP", 4) != 0)
    return 0;
  if(conf->version != 1 && conf->version != 4)
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
80103309:	84 d2                	test   %dl,%dl
8010330b:	0f 85 e4 00 00 00    	jne    801033f5 <mpinit+0x1a5>
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103311:	85 f6                	test   %esi,%esi
80103313:	0f 84 dc 00 00 00    	je     801033f5 <mpinit+0x1a5>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103319:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
8010331f:	a3 fc 36 11 80       	mov    %eax,0x801136fc
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103324:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
8010332b:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
80103331:	bb 01 00 00 00       	mov    $0x1,%ebx
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103336:	01 d6                	add    %edx,%esi
80103338:	90                   	nop
80103339:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103340:	39 c6                	cmp    %eax,%esi
80103342:	76 23                	jbe    80103367 <mpinit+0x117>
80103344:	0f b6 10             	movzbl (%eax),%edx
    switch(*p){
80103347:	80 fa 04             	cmp    $0x4,%dl
8010334a:	0f 87 c0 00 00 00    	ja     80103410 <mpinit+0x1c0>
80103350:	ff 24 95 9c 85 10 80 	jmp    *-0x7fef7a64(,%edx,4)
80103357:	89 f6                	mov    %esi,%esi
80103359:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103360:	83 c0 08             	add    $0x8,%eax

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103363:	39 c6                	cmp    %eax,%esi
80103365:	77 dd                	ja     80103344 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103367:	85 db                	test   %ebx,%ebx
80103369:	0f 84 93 00 00 00    	je     80103402 <mpinit+0x1b2>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010336f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103372:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
80103376:	74 15                	je     8010338d <mpinit+0x13d>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103378:	ba 22 00 00 00       	mov    $0x22,%edx
8010337d:	b8 70 00 00 00       	mov    $0x70,%eax
80103382:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103383:	ba 23 00 00 00       	mov    $0x23,%edx
80103388:	ec                   	in     (%dx),%al
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103389:	83 c8 01             	or     $0x1,%eax
8010338c:	ee                   	out    %al,(%dx)
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
8010338d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103390:	5b                   	pop    %ebx
80103391:	5e                   	pop    %esi
80103392:	5f                   	pop    %edi
80103393:	5d                   	pop    %ebp
80103394:	c3                   	ret    
80103395:	8d 76 00             	lea    0x0(%esi),%esi
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
80103398:	8b 0d b0 38 11 80    	mov    0x801138b0,%ecx
8010339e:	85 c9                	test   %ecx,%ecx
801033a0:	7e 1e                	jle    801033c0 <mpinit+0x170>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
        ncpu++;
      }
      p += sizeof(struct mpproc);
801033a2:	83 c0 14             	add    $0x14,%eax
      continue;
801033a5:	eb 99                	jmp    80103340 <mpinit+0xf0>
801033a7:	89 f6                	mov    %esi,%esi
801033a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
801033b0:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
801033b4:	83 c0 08             	add    $0x8,%eax
      }
      p += sizeof(struct mpproc);
      continue;
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
801033b7:	88 15 e0 37 11 80    	mov    %dl,0x801137e0
      p += sizeof(struct mpioapic);
      continue;
801033bd:	eb 81                	jmp    80103340 <mpinit+0xf0>
801033bf:	90                   	nop
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801033c0:	0f b6 50 01          	movzbl 0x1(%eax),%edx
801033c4:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
801033ca:	83 c1 01             	add    $0x1,%ecx
801033cd:	89 0d b0 38 11 80    	mov    %ecx,0x801138b0
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801033d3:	88 97 00 38 11 80    	mov    %dl,-0x7feec800(%edi)
801033d9:	eb c7                	jmp    801033a2 <mpinit+0x152>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
801033db:	ba 00 00 01 00       	mov    $0x10000,%edx
801033e0:	b8 00 00 0f 00       	mov    $0xf0000,%eax
801033e5:	e8 e6 fd ff ff       	call   801031d0 <mpsearch1>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801033ea:	85 c0                	test   %eax,%eax
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
801033ec:	89 45 e4             	mov    %eax,-0x1c(%ebp)
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801033ef:	0f 85 ae fe ff ff    	jne    801032a3 <mpinit+0x53>
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
801033f5:	83 ec 0c             	sub    $0xc,%esp
801033f8:	68 62 85 10 80       	push   $0x80108562
801033fd:	e8 6e cf ff ff       	call   80100370 <panic>
      ismp = 0;
      break;
    }
  }
  if(!ismp)
    panic("Didn't find a suitable machine");
80103402:	83 ec 0c             	sub    $0xc,%esp
80103405:	68 7c 85 10 80       	push   $0x8010857c
8010340a:	e8 61 cf ff ff       	call   80100370 <panic>
8010340f:	90                   	nop
    case MPIOINTR:
    case MPLINTR:
      p += 8;
      continue;
    default:
      ismp = 0;
80103410:	31 db                	xor    %ebx,%ebx
80103412:	e9 30 ff ff ff       	jmp    80103347 <mpinit+0xf7>
80103417:	66 90                	xchg   %ax,%ax
80103419:	66 90                	xchg   %ax,%ax
8010341b:	66 90                	xchg   %ax,%ax
8010341d:	66 90                	xchg   %ax,%ax
8010341f:	90                   	nop

80103420 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103420:	55                   	push   %ebp
80103421:	ba 21 00 00 00       	mov    $0x21,%edx
80103426:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010342b:	89 e5                	mov    %esp,%ebp
8010342d:	ee                   	out    %al,(%dx)
8010342e:	ba a1 00 00 00       	mov    $0xa1,%edx
80103433:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103434:	5d                   	pop    %ebp
80103435:	c3                   	ret    
80103436:	66 90                	xchg   %ax,%ax
80103438:	66 90                	xchg   %ax,%ax
8010343a:	66 90                	xchg   %ax,%ax
8010343c:	66 90                	xchg   %ax,%ax
8010343e:	66 90                	xchg   %ax,%ax

80103440 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103440:	55                   	push   %ebp
80103441:	89 e5                	mov    %esp,%ebp
80103443:	57                   	push   %edi
80103444:	56                   	push   %esi
80103445:	53                   	push   %ebx
80103446:	83 ec 0c             	sub    $0xc,%esp
80103449:	8b 75 08             	mov    0x8(%ebp),%esi
8010344c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010344f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103455:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010345b:	e8 70 db ff ff       	call   80100fd0 <filealloc>
80103460:	85 c0                	test   %eax,%eax
80103462:	89 06                	mov    %eax,(%esi)
80103464:	0f 84 a8 00 00 00    	je     80103512 <pipealloc+0xd2>
8010346a:	e8 61 db ff ff       	call   80100fd0 <filealloc>
8010346f:	85 c0                	test   %eax,%eax
80103471:	89 03                	mov    %eax,(%ebx)
80103473:	0f 84 87 00 00 00    	je     80103500 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103479:	e8 62 f2 ff ff       	call   801026e0 <kalloc>
8010347e:	85 c0                	test   %eax,%eax
80103480:	89 c7                	mov    %eax,%edi
80103482:	0f 84 b0 00 00 00    	je     80103538 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103488:	83 ec 08             	sub    $0x8,%esp
  *f0 = *f1 = 0;
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
    goto bad;
  p->readopen = 1;
8010348b:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103492:	00 00 00 
  p->writeopen = 1;
80103495:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010349c:	00 00 00 
  p->nwrite = 0;
8010349f:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801034a6:	00 00 00 
  p->nread = 0;
801034a9:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801034b0:	00 00 00 
  initlock(&p->lock, "pipe");
801034b3:	68 b0 85 10 80       	push   $0x801085b0
801034b8:	50                   	push   %eax
801034b9:	e8 12 1b 00 00       	call   80104fd0 <initlock>
  (*f0)->type = FD_PIPE;
801034be:	8b 06                	mov    (%esi),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
801034c0:	83 c4 10             	add    $0x10,%esp
  p->readopen = 1;
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
  (*f0)->type = FD_PIPE;
801034c3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801034c9:	8b 06                	mov    (%esi),%eax
801034cb:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801034cf:	8b 06                	mov    (%esi),%eax
801034d1:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801034d5:	8b 06                	mov    (%esi),%eax
801034d7:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
801034da:	8b 03                	mov    (%ebx),%eax
801034dc:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801034e2:	8b 03                	mov    (%ebx),%eax
801034e4:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801034e8:	8b 03                	mov    (%ebx),%eax
801034ea:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801034ee:	8b 03                	mov    (%ebx),%eax
801034f0:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801034f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
801034f6:	31 c0                	xor    %eax,%eax
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801034f8:	5b                   	pop    %ebx
801034f9:	5e                   	pop    %esi
801034fa:	5f                   	pop    %edi
801034fb:	5d                   	pop    %ebp
801034fc:	c3                   	ret    
801034fd:	8d 76 00             	lea    0x0(%esi),%esi

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
80103500:	8b 06                	mov    (%esi),%eax
80103502:	85 c0                	test   %eax,%eax
80103504:	74 1e                	je     80103524 <pipealloc+0xe4>
    fileclose(*f0);
80103506:	83 ec 0c             	sub    $0xc,%esp
80103509:	50                   	push   %eax
8010350a:	e8 81 db ff ff       	call   80101090 <fileclose>
8010350f:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103512:	8b 03                	mov    (%ebx),%eax
80103514:	85 c0                	test   %eax,%eax
80103516:	74 0c                	je     80103524 <pipealloc+0xe4>
    fileclose(*f1);
80103518:	83 ec 0c             	sub    $0xc,%esp
8010351b:	50                   	push   %eax
8010351c:	e8 6f db ff ff       	call   80101090 <fileclose>
80103521:	83 c4 10             	add    $0x10,%esp
  return -1;
}
80103524:	8d 65 f4             	lea    -0xc(%ebp),%esp
    kfree((char*)p);
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
80103527:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010352c:	5b                   	pop    %ebx
8010352d:	5e                   	pop    %esi
8010352e:	5f                   	pop    %edi
8010352f:	5d                   	pop    %ebp
80103530:	c3                   	ret    
80103531:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
80103538:	8b 06                	mov    (%esi),%eax
8010353a:	85 c0                	test   %eax,%eax
8010353c:	75 c8                	jne    80103506 <pipealloc+0xc6>
8010353e:	eb d2                	jmp    80103512 <pipealloc+0xd2>

80103540 <pipeclose>:
  return -1;
}

void
pipeclose(struct pipe *p, int writable)
{
80103540:	55                   	push   %ebp
80103541:	89 e5                	mov    %esp,%ebp
80103543:	56                   	push   %esi
80103544:	53                   	push   %ebx
80103545:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103548:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010354b:	83 ec 0c             	sub    $0xc,%esp
8010354e:	53                   	push   %ebx
8010354f:	e8 dc 1b 00 00       	call   80105130 <acquire>
  if(writable){
80103554:	83 c4 10             	add    $0x10,%esp
80103557:	85 f6                	test   %esi,%esi
80103559:	74 45                	je     801035a0 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
8010355b:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103561:	83 ec 0c             	sub    $0xc,%esp
void
pipeclose(struct pipe *p, int writable)
{
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
80103564:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010356b:	00 00 00 
    wakeup(&p->nread);
8010356e:	50                   	push   %eax
8010356f:	e8 1c 10 00 00       	call   80104590 <wakeup>
80103574:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103577:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010357d:	85 d2                	test   %edx,%edx
8010357f:	75 0a                	jne    8010358b <pipeclose+0x4b>
80103581:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103587:	85 c0                	test   %eax,%eax
80103589:	74 35                	je     801035c0 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010358b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010358e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103591:	5b                   	pop    %ebx
80103592:	5e                   	pop    %esi
80103593:	5d                   	pop    %ebp
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80103594:	e9 47 1c 00 00       	jmp    801051e0 <release>
80103599:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
801035a0:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
801035a6:	83 ec 0c             	sub    $0xc,%esp
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
801035a9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801035b0:	00 00 00 
    wakeup(&p->nwrite);
801035b3:	50                   	push   %eax
801035b4:	e8 d7 0f 00 00       	call   80104590 <wakeup>
801035b9:	83 c4 10             	add    $0x10,%esp
801035bc:	eb b9                	jmp    80103577 <pipeclose+0x37>
801035be:	66 90                	xchg   %ax,%ax
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
801035c0:	83 ec 0c             	sub    $0xc,%esp
801035c3:	53                   	push   %ebx
801035c4:	e8 17 1c 00 00       	call   801051e0 <release>
    kfree((char*)p);
801035c9:	89 5d 08             	mov    %ebx,0x8(%ebp)
801035cc:	83 c4 10             	add    $0x10,%esp
  } else
    release(&p->lock);
}
801035cf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801035d2:	5b                   	pop    %ebx
801035d3:	5e                   	pop    %esi
801035d4:	5d                   	pop    %ebp
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
801035d5:	e9 56 ef ff ff       	jmp    80102530 <kfree>
801035da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801035e0 <pipewrite>:
}

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801035e0:	55                   	push   %ebp
801035e1:	89 e5                	mov    %esp,%ebp
801035e3:	57                   	push   %edi
801035e4:	56                   	push   %esi
801035e5:	53                   	push   %ebx
801035e6:	83 ec 28             	sub    $0x28,%esp
801035e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801035ec:	53                   	push   %ebx
801035ed:	e8 3e 1b 00 00       	call   80105130 <acquire>
  for(i = 0; i < n; i++){
801035f2:	8b 45 10             	mov    0x10(%ebp),%eax
801035f5:	83 c4 10             	add    $0x10,%esp
801035f8:	85 c0                	test   %eax,%eax
801035fa:	0f 8e b9 00 00 00    	jle    801036b9 <pipewrite+0xd9>
80103600:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103603:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103609:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010360f:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103615:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103618:	03 4d 10             	add    0x10(%ebp),%ecx
8010361b:	89 4d e0             	mov    %ecx,-0x20(%ebp)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010361e:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
80103624:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
8010362a:	39 d0                	cmp    %edx,%eax
8010362c:	74 38                	je     80103666 <pipewrite+0x86>
8010362e:	eb 59                	jmp    80103689 <pipewrite+0xa9>
      if(p->readopen == 0 || myproc()->killed){
80103630:	e8 fb 03 00 00       	call   80103a30 <myproc>
80103635:	8b 48 24             	mov    0x24(%eax),%ecx
80103638:	85 c9                	test   %ecx,%ecx
8010363a:	75 34                	jne    80103670 <pipewrite+0x90>
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
8010363c:	83 ec 0c             	sub    $0xc,%esp
8010363f:	57                   	push   %edi
80103640:	e8 4b 0f 00 00       	call   80104590 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103645:	58                   	pop    %eax
80103646:	5a                   	pop    %edx
80103647:	53                   	push   %ebx
80103648:	56                   	push   %esi
80103649:	e8 82 0d 00 00       	call   801043d0 <sleep>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010364e:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103654:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010365a:	83 c4 10             	add    $0x10,%esp
8010365d:	05 00 02 00 00       	add    $0x200,%eax
80103662:	39 c2                	cmp    %eax,%edx
80103664:	75 2a                	jne    80103690 <pipewrite+0xb0>
      if(p->readopen == 0 || myproc()->killed){
80103666:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
8010366c:	85 c0                	test   %eax,%eax
8010366e:	75 c0                	jne    80103630 <pipewrite+0x50>
        release(&p->lock);
80103670:	83 ec 0c             	sub    $0xc,%esp
80103673:	53                   	push   %ebx
80103674:	e8 67 1b 00 00       	call   801051e0 <release>
        return -1;
80103679:	83 c4 10             	add    $0x10,%esp
8010367c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103681:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103684:	5b                   	pop    %ebx
80103685:	5e                   	pop    %esi
80103686:	5f                   	pop    %edi
80103687:	5d                   	pop    %ebp
80103688:	c3                   	ret    
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103689:	89 c2                	mov    %eax,%edx
8010368b:	90                   	nop
8010368c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103690:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103693:	8d 42 01             	lea    0x1(%edx),%eax
80103696:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
8010369a:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801036a0:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
801036a6:	0f b6 09             	movzbl (%ecx),%ecx
801036a9:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
801036ad:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
801036b0:	3b 4d e0             	cmp    -0x20(%ebp),%ecx
801036b3:	0f 85 65 ff ff ff    	jne    8010361e <pipewrite+0x3e>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801036b9:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801036bf:	83 ec 0c             	sub    $0xc,%esp
801036c2:	50                   	push   %eax
801036c3:	e8 c8 0e 00 00       	call   80104590 <wakeup>
  release(&p->lock);
801036c8:	89 1c 24             	mov    %ebx,(%esp)
801036cb:	e8 10 1b 00 00       	call   801051e0 <release>
  return n;
801036d0:	83 c4 10             	add    $0x10,%esp
801036d3:	8b 45 10             	mov    0x10(%ebp),%eax
801036d6:	eb a9                	jmp    80103681 <pipewrite+0xa1>
801036d8:	90                   	nop
801036d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801036e0 <piperead>:
}

int
piperead(struct pipe *p, char *addr, int n)
{
801036e0:	55                   	push   %ebp
801036e1:	89 e5                	mov    %esp,%ebp
801036e3:	57                   	push   %edi
801036e4:	56                   	push   %esi
801036e5:	53                   	push   %ebx
801036e6:	83 ec 18             	sub    $0x18,%esp
801036e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801036ec:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801036ef:	53                   	push   %ebx
801036f0:	e8 3b 1a 00 00       	call   80105130 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801036f5:	83 c4 10             	add    $0x10,%esp
801036f8:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801036fe:	39 83 38 02 00 00    	cmp    %eax,0x238(%ebx)
80103704:	75 6a                	jne    80103770 <piperead+0x90>
80103706:	8b b3 40 02 00 00    	mov    0x240(%ebx),%esi
8010370c:	85 f6                	test   %esi,%esi
8010370e:	0f 84 cc 00 00 00    	je     801037e0 <piperead+0x100>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103714:	8d b3 34 02 00 00    	lea    0x234(%ebx),%esi
8010371a:	eb 2d                	jmp    80103749 <piperead+0x69>
8010371c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103720:	83 ec 08             	sub    $0x8,%esp
80103723:	53                   	push   %ebx
80103724:	56                   	push   %esi
80103725:	e8 a6 0c 00 00       	call   801043d0 <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010372a:	83 c4 10             	add    $0x10,%esp
8010372d:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
80103733:	39 83 34 02 00 00    	cmp    %eax,0x234(%ebx)
80103739:	75 35                	jne    80103770 <piperead+0x90>
8010373b:	8b 93 40 02 00 00    	mov    0x240(%ebx),%edx
80103741:	85 d2                	test   %edx,%edx
80103743:	0f 84 97 00 00 00    	je     801037e0 <piperead+0x100>
    if(myproc()->killed){
80103749:	e8 e2 02 00 00       	call   80103a30 <myproc>
8010374e:	8b 48 24             	mov    0x24(%eax),%ecx
80103751:	85 c9                	test   %ecx,%ecx
80103753:	74 cb                	je     80103720 <piperead+0x40>
      release(&p->lock);
80103755:	83 ec 0c             	sub    $0xc,%esp
80103758:	53                   	push   %ebx
80103759:	e8 82 1a 00 00       	call   801051e0 <release>
      return -1;
8010375e:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103761:	8d 65 f4             	lea    -0xc(%ebp),%esp

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
    if(myproc()->killed){
      release(&p->lock);
      return -1;
80103764:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103769:	5b                   	pop    %ebx
8010376a:	5e                   	pop    %esi
8010376b:	5f                   	pop    %edi
8010376c:	5d                   	pop    %ebp
8010376d:	c3                   	ret    
8010376e:	66 90                	xchg   %ax,%ax
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103770:	8b 45 10             	mov    0x10(%ebp),%eax
80103773:	85 c0                	test   %eax,%eax
80103775:	7e 69                	jle    801037e0 <piperead+0x100>
    if(p->nread == p->nwrite)
80103777:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010377d:	31 c9                	xor    %ecx,%ecx
8010377f:	eb 15                	jmp    80103796 <piperead+0xb6>
80103781:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103788:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010378e:	3b 83 38 02 00 00    	cmp    0x238(%ebx),%eax
80103794:	74 5a                	je     801037f0 <piperead+0x110>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103796:	8d 70 01             	lea    0x1(%eax),%esi
80103799:	25 ff 01 00 00       	and    $0x1ff,%eax
8010379e:	89 b3 34 02 00 00    	mov    %esi,0x234(%ebx)
801037a4:	0f b6 44 03 34       	movzbl 0x34(%ebx,%eax,1),%eax
801037a9:	88 04 0f             	mov    %al,(%edi,%ecx,1)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801037ac:	83 c1 01             	add    $0x1,%ecx
801037af:	39 4d 10             	cmp    %ecx,0x10(%ebp)
801037b2:	75 d4                	jne    80103788 <piperead+0xa8>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801037b4:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
801037ba:	83 ec 0c             	sub    $0xc,%esp
801037bd:	50                   	push   %eax
801037be:	e8 cd 0d 00 00       	call   80104590 <wakeup>
  release(&p->lock);
801037c3:	89 1c 24             	mov    %ebx,(%esp)
801037c6:	e8 15 1a 00 00       	call   801051e0 <release>
  return i;
801037cb:	8b 45 10             	mov    0x10(%ebp),%eax
801037ce:	83 c4 10             	add    $0x10,%esp
}
801037d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801037d4:	5b                   	pop    %ebx
801037d5:	5e                   	pop    %esi
801037d6:	5f                   	pop    %edi
801037d7:	5d                   	pop    %ebp
801037d8:	c3                   	ret    
801037d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801037e0:	c7 45 10 00 00 00 00 	movl   $0x0,0x10(%ebp)
801037e7:	eb cb                	jmp    801037b4 <piperead+0xd4>
801037e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801037f0:	89 4d 10             	mov    %ecx,0x10(%ebp)
801037f3:	eb bf                	jmp    801037b4 <piperead+0xd4>
801037f5:	66 90                	xchg   %ax,%ax
801037f7:	66 90                	xchg   %ax,%ax
801037f9:	66 90                	xchg   %ax,%ax
801037fb:	66 90                	xchg   %ax,%ax
801037fd:	66 90                	xchg   %ax,%ax
801037ff:	90                   	nop

80103800 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103800:	55                   	push   %ebp
80103801:	89 e5                	mov    %esp,%ebp
80103803:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103804:	bb 14 39 11 80       	mov    $0x80113914,%ebx
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103809:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
8010380c:	68 e0 38 11 80       	push   $0x801138e0
80103811:	e8 1a 19 00 00       	call   80105130 <acquire>
80103816:	83 c4 10             	add    $0x10,%esp
80103819:	eb 17                	jmp    80103832 <allocproc+0x32>
8010381b:	90                   	nop
8010381c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103820:	81 c3 94 00 00 00    	add    $0x94,%ebx
80103826:	81 fb 14 5e 11 80    	cmp    $0x80115e14,%ebx
8010382c:	0f 84 c6 00 00 00    	je     801038f8 <allocproc+0xf8>
    if(p->state == UNUSED)
80103832:	8b 43 0c             	mov    0xc(%ebx),%eax
80103835:	85 c0                	test   %eax,%eax
80103837:	75 e7                	jne    80103820 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103839:	a1 04 b0 10 80       	mov    0x8010b004,%eax
    p->tickets = 1000000;
  }
  p->tickets=10;
  p->priority = 0.01;
  p->executionCycle = 1;
  acquire(&tickslock);
8010383e:	83 ec 0c             	sub    $0xc,%esp

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
80103841:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
    p->tickets = 1000000;
  }
  p->tickets=10;
  p->priority = 0.01;
  p->executionCycle = 1;
  acquire(&tickslock);
80103848:	68 20 5e 11 80       	push   $0x80115e20

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
  ///////////////////////focus/////////////////////////
  p->queuenum = 1;
8010384d:	c7 83 80 00 00 00 01 	movl   $0x1,0x80(%ebx)
80103854:	00 00 00 
  //////////////////shell///////////////////
  if(p->pid == 2){
    p->tickets = 1000000;
  }
  p->tickets=10;
80103857:	c7 83 84 00 00 00 0a 	movl   $0xa,0x84(%ebx)
8010385e:	00 00 00 
  p->priority = 0.01;
80103861:	c7 83 88 00 00 00 0a 	movl   $0x3c23d70a,0x88(%ebx)
80103868:	d7 23 3c 
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
8010386b:	8d 50 01             	lea    0x1(%eax),%edx
8010386e:	89 43 10             	mov    %eax,0x10(%ebx)
  if(p->pid == 2){
    p->tickets = 1000000;
  }
  p->tickets=10;
  p->priority = 0.01;
  p->executionCycle = 1;
80103871:	c7 83 90 00 00 00 01 	movl   $0x1,0x90(%ebx)
80103878:	00 00 00 
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
8010387b:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
    p->tickets = 1000000;
  }
  p->tickets=10;
  p->priority = 0.01;
  p->executionCycle = 1;
  acquire(&tickslock);
80103881:	e8 aa 18 00 00       	call   80105130 <acquire>
  p->createTime = ticks;
80103886:	a1 60 66 11 80       	mov    0x80116660,%eax
  release(&tickslock);
8010388b:	c7 04 24 20 5e 11 80 	movl   $0x80115e20,(%esp)
  }
  p->tickets=10;
  p->priority = 0.01;
  p->executionCycle = 1;
  acquire(&tickslock);
  p->createTime = ticks;
80103892:	89 83 8c 00 00 00    	mov    %eax,0x8c(%ebx)
  release(&tickslock);
80103898:	e8 43 19 00 00       	call   801051e0 <release>

  release(&ptable.lock);
8010389d:	c7 04 24 e0 38 11 80 	movl   $0x801138e0,(%esp)
801038a4:	e8 37 19 00 00       	call   801051e0 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
801038a9:	e8 32 ee ff ff       	call   801026e0 <kalloc>
801038ae:	83 c4 10             	add    $0x10,%esp
801038b1:	85 c0                	test   %eax,%eax
801038b3:	89 43 08             	mov    %eax,0x8(%ebx)
801038b6:	74 57                	je     8010390f <allocproc+0x10f>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801038b8:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
801038be:	83 ec 04             	sub    $0x4,%esp
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
801038c1:	05 9c 0f 00 00       	add    $0xf9c,%eax
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801038c6:	89 53 18             	mov    %edx,0x18(%ebx)
  p->tf = (struct trapframe*)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;
801038c9:	c7 40 14 b1 67 10 80 	movl   $0x801067b1,0x14(%eax)

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
801038d0:	6a 14                	push   $0x14
801038d2:	6a 00                	push   $0x0
801038d4:	50                   	push   %eax
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
801038d5:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
801038d8:	e8 53 19 00 00       	call   80105230 <memset>
  p->context->eip = (uint)forkret;
801038dd:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
801038e0:	83 c4 10             	add    $0x10,%esp
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;
801038e3:	c7 40 10 20 39 10 80 	movl   $0x80103920,0x10(%eax)

  return p;
801038ea:	89 d8                	mov    %ebx,%eax
}
801038ec:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801038ef:	c9                   	leave  
801038f0:	c3                   	ret    
801038f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
801038f8:	83 ec 0c             	sub    $0xc,%esp
801038fb:	68 e0 38 11 80       	push   $0x801138e0
80103900:	e8 db 18 00 00       	call   801051e0 <release>
  return 0;
80103905:	83 c4 10             	add    $0x10,%esp
80103908:	31 c0                	xor    %eax,%eax
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  return p;
}
8010390a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010390d:	c9                   	leave  
8010390e:	c3                   	ret    

  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
8010390f:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103916:	eb d4                	jmp    801038ec <allocproc+0xec>
80103918:	90                   	nop
80103919:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103920 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103920:	55                   	push   %ebp
80103921:	89 e5                	mov    %esp,%ebp
80103923:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103926:	68 e0 38 11 80       	push   $0x801138e0
8010392b:	e8 b0 18 00 00       	call   801051e0 <release>

  if (first) {
80103930:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103935:	83 c4 10             	add    $0x10,%esp
80103938:	85 c0                	test   %eax,%eax
8010393a:	75 04                	jne    80103940 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
8010393c:	c9                   	leave  
8010393d:	c3                   	ret    
8010393e:	66 90                	xchg   %ax,%ax
  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
    iinit(ROOTDEV);
80103940:	83 ec 0c             	sub    $0xc,%esp

  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
80103943:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
8010394a:	00 00 00 
    iinit(ROOTDEV);
8010394d:	6a 01                	push   $0x1
8010394f:	e8 6c dd ff ff       	call   801016c0 <iinit>
    initlog(ROOTDEV);
80103954:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010395b:	e8 a0 f3 ff ff       	call   80102d00 <initlog>
80103960:	83 c4 10             	add    $0x10,%esp
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103963:	c9                   	leave  
80103964:	c3                   	ret    
80103965:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103969:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103970 <rand>:


static unsigned long int next = 1;
int rand(void)    /* RAND_MAX assumed to be 32767 */
{
    next = next * 1103515245 + 12345;
80103970:	69 05 08 b0 10 80 6d 	imul   $0x41c64e6d,0x8010b008,%eax
80103977:	4e c6 41 
#include "spinlock.h"


static unsigned long int next = 1;
int rand(void)    /* RAND_MAX assumed to be 32767 */
{
8010397a:	55                   	push   %ebp
8010397b:	89 e5                	mov    %esp,%ebp
    next = next * 1103515245 + 12345;
    return((unsigned int)(next/65536) % 32768);
}
8010397d:	5d                   	pop    %ebp


static unsigned long int next = 1;
int rand(void)    /* RAND_MAX assumed to be 32767 */
{
    next = next * 1103515245 + 12345;
8010397e:	05 39 30 00 00       	add    $0x3039,%eax
80103983:	a3 08 b0 10 80       	mov    %eax,0x8010b008
    return((unsigned int)(next/65536) % 32768);
80103988:	c1 e8 10             	shr    $0x10,%eax
8010398b:	25 ff 7f 00 00       	and    $0x7fff,%eax
}
80103990:	c3                   	ret    
80103991:	eb 0d                	jmp    801039a0 <pinit>
80103993:	90                   	nop
80103994:	90                   	nop
80103995:	90                   	nop
80103996:	90                   	nop
80103997:	90                   	nop
80103998:	90                   	nop
80103999:	90                   	nop
8010399a:	90                   	nop
8010399b:	90                   	nop
8010399c:	90                   	nop
8010399d:	90                   	nop
8010399e:	90                   	nop
8010399f:	90                   	nop

801039a0 <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
801039a0:	55                   	push   %ebp
801039a1:	89 e5                	mov    %esp,%ebp
801039a3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
801039a6:	68 b5 85 10 80       	push   $0x801085b5
801039ab:	68 e0 38 11 80       	push   $0x801138e0
801039b0:	e8 1b 16 00 00       	call   80104fd0 <initlock>
}
801039b5:	83 c4 10             	add    $0x10,%esp
801039b8:	c9                   	leave  
801039b9:	c3                   	ret    
801039ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801039c0 <mycpu>:

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void)
{
801039c0:	55                   	push   %ebp
801039c1:	89 e5                	mov    %esp,%ebp
801039c3:	83 ec 08             	sub    $0x8,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801039c6:	9c                   	pushf  
801039c7:	58                   	pop    %eax
  int apicid, i;
  
  if(readeflags()&FL_IF)
801039c8:	f6 c4 02             	test   $0x2,%ah
801039cb:	75 32                	jne    801039ff <mycpu+0x3f>
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
801039cd:	e8 6e ef ff ff       	call   80102940 <lapicid>
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
801039d2:	8b 15 b0 38 11 80    	mov    0x801138b0,%edx
801039d8:	85 d2                	test   %edx,%edx
801039da:	7e 0b                	jle    801039e7 <mycpu+0x27>
    if (cpus[i].apicid == apicid)
801039dc:	0f b6 15 00 38 11 80 	movzbl 0x80113800,%edx
801039e3:	39 d0                	cmp    %edx,%eax
801039e5:	74 11                	je     801039f8 <mycpu+0x38>
      return &cpus[i];
  }
  panic("unknown apicid\n");
801039e7:	83 ec 0c             	sub    $0xc,%esp
801039ea:	68 bc 85 10 80       	push   $0x801085bc
801039ef:	e8 7c c9 ff ff       	call   80100370 <panic>
801039f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
}
801039f8:	b8 00 38 11 80       	mov    $0x80113800,%eax
801039fd:	c9                   	leave  
801039fe:	c3                   	ret    
mycpu(void)
{
  int apicid, i;
  
  if(readeflags()&FL_IF)
    panic("mycpu called with interrupts enabled\n");
801039ff:	83 ec 0c             	sub    $0xc,%esp
80103a02:	68 bc 86 10 80       	push   $0x801086bc
80103a07:	e8 64 c9 ff ff       	call   80100370 <panic>
80103a0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103a10 <cpuid>:
  initlock(&ptable.lock, "ptable");
}

// Must be called with interrupts disabled
int
cpuid() {
80103a10:	55                   	push   %ebp
80103a11:	89 e5                	mov    %esp,%ebp
80103a13:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103a16:	e8 a5 ff ff ff       	call   801039c0 <mycpu>
80103a1b:	2d 00 38 11 80       	sub    $0x80113800,%eax
}
80103a20:	c9                   	leave  
}

// Must be called with interrupts disabled
int
cpuid() {
  return mycpu()-cpus;
80103a21:	c1 f8 04             	sar    $0x4,%eax
80103a24:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103a2a:	c3                   	ret    
80103a2b:	90                   	nop
80103a2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103a30 <myproc>:
}

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc*
myproc(void) {
80103a30:	55                   	push   %ebp
80103a31:	89 e5                	mov    %esp,%ebp
80103a33:	53                   	push   %ebx
80103a34:	83 ec 04             	sub    $0x4,%esp
  struct cpu *c;
  struct proc *p;
  pushcli();
80103a37:	e8 14 16 00 00       	call   80105050 <pushcli>
  c = mycpu();
80103a3c:	e8 7f ff ff ff       	call   801039c0 <mycpu>
  p = c->proc;
80103a41:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103a47:	e8 44 16 00 00       	call   80105090 <popcli>
  return p;
}
80103a4c:	83 c4 04             	add    $0x4,%esp
80103a4f:	89 d8                	mov    %ebx,%eax
80103a51:	5b                   	pop    %ebx
80103a52:	5d                   	pop    %ebp
80103a53:	c3                   	ret    
80103a54:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103a5a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103a60 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
80103a60:	55                   	push   %ebp
80103a61:	89 e5                	mov    %esp,%ebp
80103a63:	53                   	push   %ebx
80103a64:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];
  cprintf("init p\n");
80103a67:	68 cc 85 10 80       	push   $0x801085cc
80103a6c:	e8 ef cb ff ff       	call   80100660 <cprintf>
  p = allocproc();
80103a71:	e8 8a fd ff ff       	call   80103800 <allocproc>
80103a76:	89 c3                	mov    %eax,%ebx
  
  initproc = p;
80103a78:	a3 b8 b5 10 80       	mov    %eax,0x8010b5b8
  if((p->pgdir = setupkvm()) == 0)
80103a7d:	e8 2e 43 00 00       	call   80107db0 <setupkvm>
80103a82:	83 c4 10             	add    $0x10,%esp
80103a85:	85 c0                	test   %eax,%eax
80103a87:	89 43 04             	mov    %eax,0x4(%ebx)
80103a8a:	0f 84 bd 00 00 00    	je     80103b4d <userinit+0xed>
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103a90:	83 ec 04             	sub    $0x4,%esp
80103a93:	68 2c 00 00 00       	push   $0x2c
80103a98:	68 60 b4 10 80       	push   $0x8010b460
80103a9d:	50                   	push   %eax
80103a9e:	e8 1d 40 00 00       	call   80107ac0 <inituvm>
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
80103aa3:	83 c4 0c             	add    $0xc,%esp
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
80103aa6:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103aac:	6a 4c                	push   $0x4c
80103aae:	6a 00                	push   $0x0
80103ab0:	ff 73 18             	pushl  0x18(%ebx)
80103ab3:	e8 78 17 00 00       	call   80105230 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103ab8:	8b 43 18             	mov    0x18(%ebx),%eax
80103abb:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103ac0:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0;  // beginning of initcode.S

  safestrcpy(p->name, "initcode", sizeof(p->name));
80103ac5:	83 c4 0c             	add    $0xc,%esp
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103ac8:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103acc:	8b 43 18             	mov    0x18(%ebx),%eax
80103acf:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103ad3:	8b 43 18             	mov    0x18(%ebx),%eax
80103ad6:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103ada:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103ade:	8b 43 18             	mov    0x18(%ebx),%eax
80103ae1:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103ae5:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103ae9:	8b 43 18             	mov    0x18(%ebx),%eax
80103aec:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103af3:	8b 43 18             	mov    0x18(%ebx),%eax
80103af6:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103afd:	8b 43 18             	mov    0x18(%ebx),%eax
80103b00:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
80103b07:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103b0a:	6a 10                	push   $0x10
80103b0c:	68 ed 85 10 80       	push   $0x801085ed
80103b11:	50                   	push   %eax
80103b12:	e8 19 19 00 00       	call   80105430 <safestrcpy>
  p->cwd = namei("/");
80103b17:	c7 04 24 f6 85 10 80 	movl   $0x801085f6,(%esp)
80103b1e:	e8 ed e5 ff ff       	call   80102110 <namei>
80103b23:	89 43 68             	mov    %eax,0x68(%ebx)

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);
80103b26:	c7 04 24 e0 38 11 80 	movl   $0x801138e0,(%esp)
80103b2d:	e8 fe 15 00 00       	call   80105130 <acquire>

  p->state = RUNNABLE;
80103b32:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)

  release(&ptable.lock);
80103b39:	c7 04 24 e0 38 11 80 	movl   $0x801138e0,(%esp)
80103b40:	e8 9b 16 00 00       	call   801051e0 <release>
}
80103b45:	83 c4 10             	add    $0x10,%esp
80103b48:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103b4b:	c9                   	leave  
80103b4c:	c3                   	ret    
  cprintf("init p\n");
  p = allocproc();
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
80103b4d:	83 ec 0c             	sub    $0xc,%esp
80103b50:	68 d4 85 10 80       	push   $0x801085d4
80103b55:	e8 16 c8 ff ff       	call   80100370 <panic>
80103b5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103b60 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
80103b60:	55                   	push   %ebp
80103b61:	89 e5                	mov    %esp,%ebp
80103b63:	56                   	push   %esi
80103b64:	53                   	push   %ebx
80103b65:	8b 75 08             	mov    0x8(%ebp),%esi
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103b68:	e8 e3 14 00 00       	call   80105050 <pushcli>
  c = mycpu();
80103b6d:	e8 4e fe ff ff       	call   801039c0 <mycpu>
  p = c->proc;
80103b72:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b78:	e8 13 15 00 00       	call   80105090 <popcli>
{
  uint sz;
  struct proc *curproc = myproc();

  sz = curproc->sz;
  if(n > 0){
80103b7d:	83 fe 00             	cmp    $0x0,%esi
growproc(int n)
{
  uint sz;
  struct proc *curproc = myproc();

  sz = curproc->sz;
80103b80:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103b82:	7e 34                	jle    80103bb8 <growproc+0x58>
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103b84:	83 ec 04             	sub    $0x4,%esp
80103b87:	01 c6                	add    %eax,%esi
80103b89:	56                   	push   %esi
80103b8a:	50                   	push   %eax
80103b8b:	ff 73 04             	pushl  0x4(%ebx)
80103b8e:	e8 6d 40 00 00       	call   80107c00 <allocuvm>
80103b93:	83 c4 10             	add    $0x10,%esp
80103b96:	85 c0                	test   %eax,%eax
80103b98:	74 36                	je     80103bd0 <growproc+0x70>
  } else if(n < 0){
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  curproc->sz = sz;
  switchuvm(curproc);
80103b9a:	83 ec 0c             	sub    $0xc,%esp
      return -1;
  } else if(n < 0){
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  curproc->sz = sz;
80103b9d:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103b9f:	53                   	push   %ebx
80103ba0:	e8 0b 3e 00 00       	call   801079b0 <switchuvm>
  return 0;
80103ba5:	83 c4 10             	add    $0x10,%esp
80103ba8:	31 c0                	xor    %eax,%eax
}
80103baa:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103bad:	5b                   	pop    %ebx
80103bae:	5e                   	pop    %esi
80103baf:	5d                   	pop    %ebp
80103bb0:	c3                   	ret    
80103bb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  sz = curproc->sz;
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
80103bb8:	74 e0                	je     80103b9a <growproc+0x3a>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103bba:	83 ec 04             	sub    $0x4,%esp
80103bbd:	01 c6                	add    %eax,%esi
80103bbf:	56                   	push   %esi
80103bc0:	50                   	push   %eax
80103bc1:	ff 73 04             	pushl  0x4(%ebx)
80103bc4:	e8 37 41 00 00       	call   80107d00 <deallocuvm>
80103bc9:	83 c4 10             	add    $0x10,%esp
80103bcc:	85 c0                	test   %eax,%eax
80103bce:	75 ca                	jne    80103b9a <growproc+0x3a>
  struct proc *curproc = myproc();

  sz = curproc->sz;
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
80103bd0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103bd5:	eb d3                	jmp    80103baa <growproc+0x4a>
80103bd7:	89 f6                	mov    %esi,%esi
80103bd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103be0 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
80103be0:	55                   	push   %ebp
80103be1:	89 e5                	mov    %esp,%ebp
80103be3:	57                   	push   %edi
80103be4:	56                   	push   %esi
80103be5:	53                   	push   %ebx
80103be6:	83 ec 1c             	sub    $0x1c,%esp
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103be9:	e8 62 14 00 00       	call   80105050 <pushcli>
  c = mycpu();
80103bee:	e8 cd fd ff ff       	call   801039c0 <mycpu>
  p = c->proc;
80103bf3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103bf9:	e8 92 14 00 00       	call   80105090 <popcli>
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
80103bfe:	e8 fd fb ff ff       	call   80103800 <allocproc>
80103c03:	85 c0                	test   %eax,%eax
80103c05:	89 c7                	mov    %eax,%edi
80103c07:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103c0a:	0f 84 b5 00 00 00    	je     80103cc5 <fork+0xe5>
    return -1;
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103c10:	83 ec 08             	sub    $0x8,%esp
80103c13:	ff 33                	pushl  (%ebx)
80103c15:	ff 73 04             	pushl  0x4(%ebx)
80103c18:	e8 63 42 00 00       	call   80107e80 <copyuvm>
80103c1d:	83 c4 10             	add    $0x10,%esp
80103c20:	85 c0                	test   %eax,%eax
80103c22:	89 47 04             	mov    %eax,0x4(%edi)
80103c25:	0f 84 a1 00 00 00    	je     80103ccc <fork+0xec>
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = curproc->sz;
80103c2b:	8b 03                	mov    (%ebx),%eax
80103c2d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103c30:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
80103c32:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103c35:	89 c8                	mov    %ecx,%eax
80103c37:	8b 79 18             	mov    0x18(%ecx),%edi
80103c3a:	8b 73 18             	mov    0x18(%ebx),%esi
80103c3d:	b9 13 00 00 00       	mov    $0x13,%ecx
80103c42:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80103c44:	31 f6                	xor    %esi,%esi
  np->sz = curproc->sz;
  np->parent = curproc;
  *np->tf = *curproc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
80103c46:	8b 40 18             	mov    0x18(%eax),%eax
80103c49:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
80103c50:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103c54:	85 c0                	test   %eax,%eax
80103c56:	74 13                	je     80103c6b <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103c58:	83 ec 0c             	sub    $0xc,%esp
80103c5b:	50                   	push   %eax
80103c5c:	e8 df d3 ff ff       	call   80101040 <filedup>
80103c61:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103c64:	83 c4 10             	add    $0x10,%esp
80103c67:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  *np->tf = *curproc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80103c6b:	83 c6 01             	add    $0x1,%esi
80103c6e:	83 fe 10             	cmp    $0x10,%esi
80103c71:	75 dd                	jne    80103c50 <fork+0x70>
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
80103c73:	83 ec 0c             	sub    $0xc,%esp
80103c76:	ff 73 68             	pushl  0x68(%ebx)

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103c79:	83 c3 6c             	add    $0x6c,%ebx
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
80103c7c:	e8 0f dc ff ff       	call   80101890 <idup>
80103c81:	8b 7d e4             	mov    -0x1c(%ebp),%edi

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103c84:	83 c4 0c             	add    $0xc,%esp
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
80103c87:	89 47 68             	mov    %eax,0x68(%edi)

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103c8a:	8d 47 6c             	lea    0x6c(%edi),%eax
80103c8d:	6a 10                	push   $0x10
80103c8f:	53                   	push   %ebx
80103c90:	50                   	push   %eax
80103c91:	e8 9a 17 00 00       	call   80105430 <safestrcpy>

  pid = np->pid;
80103c96:	8b 5f 10             	mov    0x10(%edi),%ebx

  acquire(&ptable.lock);
80103c99:	c7 04 24 e0 38 11 80 	movl   $0x801138e0,(%esp)
80103ca0:	e8 8b 14 00 00       	call   80105130 <acquire>


  np->state = RUNNABLE;
80103ca5:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)

  release(&ptable.lock);
80103cac:	c7 04 24 e0 38 11 80 	movl   $0x801138e0,(%esp)
80103cb3:	e8 28 15 00 00       	call   801051e0 <release>

  return pid;
80103cb8:	83 c4 10             	add    $0x10,%esp
80103cbb:	89 d8                	mov    %ebx,%eax
}
80103cbd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103cc0:	5b                   	pop    %ebx
80103cc1:	5e                   	pop    %esi
80103cc2:	5f                   	pop    %edi
80103cc3:	5d                   	pop    %ebp
80103cc4:	c3                   	ret    
  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
    return -1;
80103cc5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103cca:	eb f1                	jmp    80103cbd <fork+0xdd>
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
    kfree(np->kstack);
80103ccc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103ccf:	83 ec 0c             	sub    $0xc,%esp
80103cd2:	ff 77 08             	pushl  0x8(%edi)
80103cd5:	e8 56 e8 ff ff       	call   80102530 <kfree>
    np->kstack = 0;
80103cda:	c7 47 08 00 00 00 00 	movl   $0x0,0x8(%edi)
    np->state = UNUSED;
80103ce1:	c7 47 0c 00 00 00 00 	movl   $0x0,0xc(%edi)
    return -1;
80103ce8:	83 c4 10             	add    $0x10,%esp
80103ceb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103cf0:	eb cb                	jmp    80103cbd <fork+0xdd>
80103cf2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103cf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103d00 <checkNotEmpty>:
//  - choose a process to run
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.

int checkNotEmpty(int queueNum){
80103d00:	55                   	push   %ebp
  struct proc *p;
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d01:	b8 14 39 11 80       	mov    $0x80113914,%eax
//  - choose a process to run
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.

int checkNotEmpty(int queueNum){
80103d06:	89 e5                	mov    %esp,%ebp
80103d08:	8b 55 08             	mov    0x8(%ebp),%edx
80103d0b:	eb 0f                	jmp    80103d1c <checkNotEmpty+0x1c>
80103d0d:	8d 76 00             	lea    0x0(%esi),%esi
  struct proc *p;
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d10:	05 94 00 00 00       	add    $0x94,%eax
80103d15:	3d 14 5e 11 80       	cmp    $0x80115e14,%eax
80103d1a:	74 1c                	je     80103d38 <checkNotEmpty+0x38>
    //cprintf("jj\n");
    //cprintf("%d",p->queuenum);
    if(p->queuenum == queueNum && (p->state == RUNNABLE)){
80103d1c:	39 90 80 00 00 00    	cmp    %edx,0x80(%eax)
80103d22:	75 ec                	jne    80103d10 <checkNotEmpty+0x10>
80103d24:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80103d28:	75 e6                	jne    80103d10 <checkNotEmpty+0x10>
      //cprintf("samin\n");
      //cprintf("%d",p->pid);
      return 1;
80103d2a:	b8 01 00 00 00       	mov    $0x1,%eax
    }
  }
  return 0;
}
80103d2f:	5d                   	pop    %ebp
80103d30:	c3                   	ret    
80103d31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      //cprintf("samin\n");
      //cprintf("%d",p->pid);
      return 1;
    }
  }
  return 0;
80103d38:	31 c0                	xor    %eax,%eax
}
80103d3a:	5d                   	pop    %ebp
80103d3b:	c3                   	ret    
80103d3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103d40 <lottery_range>:

int lottery_range(void){
80103d40:	55                   	push   %ebp
    struct proc *p;
    int ticket_number=0;
80103d41:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d43:	ba 14 39 11 80       	mov    $0x80113914,%edx
    }
  }
  return 0;
}

int lottery_range(void){
80103d48:	89 e5                	mov    %esp,%ebp
80103d4a:	eb 12                	jmp    80103d5e <lottery_range+0x1e>
80103d4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    struct proc *p;
    int ticket_number=0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d50:	81 c2 94 00 00 00    	add    $0x94,%edx
80103d56:	81 fa 14 5e 11 80    	cmp    $0x80115e14,%edx
80103d5c:	74 23                	je     80103d81 <lottery_range+0x41>
        if(p->state == RUNNABLE && p->queuenum==1){
80103d5e:	83 7a 0c 03          	cmpl   $0x3,0xc(%edx)
80103d62:	75 ec                	jne    80103d50 <lottery_range+0x10>
80103d64:	83 ba 80 00 00 00 01 	cmpl   $0x1,0x80(%edx)
80103d6b:	75 e3                	jne    80103d50 <lottery_range+0x10>
           ticket_number+=p->tickets;
80103d6d:	03 82 84 00 00 00    	add    0x84(%edx),%eax
}

int lottery_range(void){
    struct proc *p;
    int ticket_number=0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d73:	81 c2 94 00 00 00    	add    $0x94,%edx
80103d79:	81 fa 14 5e 11 80    	cmp    $0x80115e14,%edx
80103d7f:	75 dd                	jne    80103d5e <lottery_range+0x1e>
        if(p->state == RUNNABLE && p->queuenum==1){
           ticket_number+=p->tickets;
        }
     }
    return ticket_number;          // returning total number of tickets for runnable processes
}
80103d81:	5d                   	pop    %ebp
80103d82:	c3                   	ret    
80103d83:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103d89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103d90 <foundTicket>:


struct proc* foundTicket(int goldenTicket){
80103d90:	55                   	push   %ebp
  struct proc *p;
  int count=0;
80103d91:	31 d2                	xor    %edx,%edx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103d93:	b8 14 39 11 80       	mov    $0x80113914,%eax
     }
    return ticket_number;          // returning total number of tickets for runnable processes
}


struct proc* foundTicket(int goldenTicket){
80103d98:	89 e5                	mov    %esp,%ebp
80103d9a:	8b 4d 08             	mov    0x8(%ebp),%ecx
80103d9d:	eb 0d                	jmp    80103dac <foundTicket+0x1c>
80103d9f:	90                   	nop
  struct proc *p;
  int count=0;
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103da0:	05 94 00 00 00       	add    $0x94,%eax
80103da5:	3d 14 5e 11 80       	cmp    $0x80115e14,%eax
80103daa:	74 24                	je     80103dd0 <foundTicket+0x40>
      if (p->state == RUNNABLE && p->queuenum == 1) {
80103dac:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80103db0:	75 ee                	jne    80103da0 <foundTicket+0x10>
80103db2:	83 b8 80 00 00 00 01 	cmpl   $0x1,0x80(%eax)
80103db9:	75 e5                	jne    80103da0 <foundTicket+0x10>
          if (count + p->tickets < goldenTicket)
80103dbb:	03 90 84 00 00 00    	add    0x84(%eax),%edx
80103dc1:	39 ca                	cmp    %ecx,%edx
80103dc3:	7c db                	jl     80103da0 <foundTicket+0x10>
          else
              return p;
      }
  }
  return '\0';
}
80103dc5:	5d                   	pop    %ebp
80103dc6:	c3                   	ret    
80103dc7:	89 f6                	mov    %esi,%esi
80103dc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
              count += p->tickets;
          else
              return p;
      }
  }
  return '\0';
80103dd0:	31 c0                	xor    %eax,%eax
}
80103dd2:	5d                   	pop    %ebp
80103dd3:	c3                   	ret    
80103dd4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103dda:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103de0 <processWithMaxPriority>:

/////2/////

struct proc* processWithMaxPriority(){
80103de0:	55                   	push   %ebp
80103de1:	89 e5                	mov    %esp,%ebp
80103de3:	53                   	push   %ebx
80103de4:	83 ec 20             	sub    $0x20,%esp
  struct proc* p;
  struct proc* pmax = '\0';
  float _maxHRRN=-1;
  uint currentTick;
  acquire(&tickslock);
80103de7:	68 20 5e 11 80       	push   $0x80115e20
80103dec:	e8 3f 13 00 00       	call   80105130 <acquire>
  currentTick = ticks;
  release(&tickslock);
80103df1:	c7 04 24 20 5e 11 80 	movl   $0x80115e20,(%esp)
  struct proc* p;
  struct proc* pmax = '\0';
  float _maxHRRN=-1;
  uint currentTick;
  acquire(&tickslock);
  currentTick = ticks;
80103df8:	8b 1d 60 66 11 80    	mov    0x80116660,%ebx
  release(&tickslock);
80103dfe:	e8 dd 13 00 00       	call   801051e0 <release>
/////2/////

struct proc* processWithMaxPriority(){
  struct proc* p;
  struct proc* pmax = '\0';
  float _maxHRRN=-1;
80103e03:	d9 e8                	fld1   
  uint currentTick;
  acquire(&tickslock);
  currentTick = ticks;
  release(&tickslock);
80103e05:	83 c4 10             	add    $0x10,%esp

/////2/////

struct proc* processWithMaxPriority(){
  struct proc* p;
  struct proc* pmax = '\0';
80103e08:	31 c0                	xor    %eax,%eax
  float _maxHRRN=-1;
  uint currentTick;
  acquire(&tickslock);
  currentTick = ticks;
  release(&tickslock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e0a:	ba 14 39 11 80       	mov    $0x80113914,%edx
/////2/////

struct proc* processWithMaxPriority(){
  struct proc* p;
  struct proc* pmax = '\0';
  float _maxHRRN=-1;
80103e0f:	d9 e0                	fchs   
80103e11:	eb 1b                	jmp    80103e2e <processWithMaxPriority+0x4e>
80103e13:	90                   	nop
80103e14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103e18:	dd d8                	fstp   %st(0)
80103e1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  uint currentTick;
  acquire(&tickslock);
  currentTick = ticks;
  release(&tickslock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e20:	81 c2 94 00 00 00    	add    $0x94,%edx
80103e26:	81 fa 14 5e 11 80    	cmp    $0x80115e14,%edx
80103e2c:	74 4a                	je     80103e78 <processWithMaxPriority+0x98>
    if((p->queuenum == 2) && (((float)(currentTick - p->createTime) /(float) p->executionCycle) > _maxHRRN) && p->state == RUNNABLE){
80103e2e:	83 ba 80 00 00 00 02 	cmpl   $0x2,0x80(%edx)
80103e35:	75 e9                	jne    80103e20 <processWithMaxPriority+0x40>
80103e37:	89 d9                	mov    %ebx,%ecx
80103e39:	2b 8a 8c 00 00 00    	sub    0x8c(%edx),%ecx
80103e3f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80103e46:	89 4d e8             	mov    %ecx,-0x18(%ebp)
80103e49:	df 6d e8             	fildll -0x18(%ebp)
80103e4c:	db 82 90 00 00 00    	fildl  0x90(%edx)
80103e52:	de f9                	fdivrp %st,%st(1)
80103e54:	db e9                	fucomi %st(1),%st
80103e56:	76 c0                	jbe    80103e18 <processWithMaxPriority+0x38>
      _maxHRRN = (float)((float)(currentTick - p->createTime) / (float)p->executionCycle);
80103e58:	83 7a 0c 03          	cmpl   $0x3,0xc(%edx)
80103e5c:	db c9                	fcmovne %st(1),%st
80103e5e:	dd d9                	fstp   %st(1)
80103e60:	0f 44 c2             	cmove  %edx,%eax
  float _maxHRRN=-1;
  uint currentTick;
  acquire(&tickslock);
  currentTick = ticks;
  release(&tickslock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e63:	81 c2 94 00 00 00    	add    $0x94,%edx
80103e69:	81 fa 14 5e 11 80    	cmp    $0x80115e14,%edx
80103e6f:	75 bd                	jne    80103e2e <processWithMaxPriority+0x4e>
80103e71:	dd d8                	fstp   %st(0)
80103e73:	eb 05                	jmp    80103e7a <processWithMaxPriority+0x9a>
80103e75:	8d 76 00             	lea    0x0(%esi),%esi
80103e78:	dd d8                	fstp   %st(0)
    }
  }

  return pmax;

}
80103e7a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103e7d:	c9                   	leave  
80103e7e:	c3                   	ret    
80103e7f:	90                   	nop

80103e80 <choseWithSRTF>:
  struct proc* samepr[1000];
  int count_samepr = 0;
  struct proc* p;
  struct proc* minp='\0';
  float _min = -1;
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e80:	b8 14 39 11 80       	mov    $0x80113914,%eax
80103e85:	eb 15                	jmp    80103e9c <choseWithSRTF+0x1c>
80103e87:	89 f6                	mov    %esi,%esi
80103e89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80103e90:	05 94 00 00 00       	add    $0x94,%eax
80103e95:	3d 14 5e 11 80       	cmp    $0x80115e14,%eax
80103e9a:	74 17                	je     80103eb3 <choseWithSRTF+0x33>
    if((p->queuenum == 3) && (p->state == RUNNABLE)){
80103e9c:	83 b8 80 00 00 00 03 	cmpl   $0x3,0x80(%eax)
80103ea3:	75 eb                	jne    80103e90 <choseWithSRTF+0x10>
80103ea5:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80103ea9:	75 e5                	jne    80103e90 <choseWithSRTF+0x10>
      _min = p->priority;
80103eab:	d9 80 88 00 00 00    	flds   0x88(%eax)
      minp = p;
      break;
80103eb1:	eb 06                	jmp    80103eb9 <choseWithSRTF+0x39>
  int randNum;
  struct proc* samepr[1000];
  int count_samepr = 0;
  struct proc* p;
  struct proc* minp='\0';
  float _min = -1;
80103eb3:	d9 e8                	fld1   
struct proc* choseWithSRTF(){
  int randNum;
  struct proc* samepr[1000];
  int count_samepr = 0;
  struct proc* p;
  struct proc* minp='\0';
80103eb5:	31 c0                	xor    %eax,%eax
  float _min = -1;
80103eb7:	d9 e0                	fchs   
struct proc* choseWithSRTF(){
  int randNum;
  struct proc* samepr[1000];
  int count_samepr = 0;
  struct proc* p;
  struct proc* minp='\0';
80103eb9:	ba 14 39 11 80       	mov    $0x80113914,%edx
80103ebe:	eb 16                	jmp    80103ed6 <choseWithSRTF+0x56>
80103ec0:	dd d9                	fstp   %st(1)
80103ec2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      _min = p->priority;
      minp = p;
      break;
    }
  }
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ec8:	81 c2 94 00 00 00    	add    $0x94,%edx
80103ece:	81 fa 14 5e 11 80    	cmp    $0x80115e14,%edx
80103ed4:	74 32                	je     80103f08 <choseWithSRTF+0x88>
    if((p->queuenum == 3) && (p->state == RUNNABLE) && (p->priority < _min)){
80103ed6:	83 ba 80 00 00 00 03 	cmpl   $0x3,0x80(%edx)
80103edd:	75 e9                	jne    80103ec8 <choseWithSRTF+0x48>
80103edf:	83 7a 0c 03          	cmpl   $0x3,0xc(%edx)
80103ee3:	75 e3                	jne    80103ec8 <choseWithSRTF+0x48>
80103ee5:	d9 82 88 00 00 00    	flds   0x88(%edx)
80103eeb:	d9 c9                	fxch   %st(1)
80103eed:	db e9                	fucomi %st(1),%st
80103eef:	76 cf                	jbe    80103ec0 <choseWithSRTF+0x40>
80103ef1:	dd d8                	fstp   %st(0)
80103ef3:	89 d0                	mov    %edx,%eax
      _min = p->priority;
      minp = p;
      break;
    }
  }
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ef5:	81 c2 94 00 00 00    	add    $0x94,%edx
80103efb:	81 fa 14 5e 11 80    	cmp    $0x80115e14,%edx
80103f01:	75 d3                	jne    80103ed6 <choseWithSRTF+0x56>
80103f03:	90                   	nop
80103f04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return pmax;

}

////////3////////
struct proc* choseWithSRTF(){
80103f08:	55                   	push   %ebp
80103f09:	ba 14 39 11 80       	mov    $0x80113914,%edx
80103f0e:	31 c9                	xor    %ecx,%ecx
80103f10:	89 e5                	mov    %esp,%ebp
80103f12:	81 ec a8 0f 00 00    	sub    $0xfa8,%esp
80103f18:	eb 14                	jmp    80103f2e <choseWithSRTF+0xae>
80103f1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      _min = p->priority;
      minp = p;
    }
  }
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f20:	81 c2 94 00 00 00    	add    $0x94,%edx
80103f26:	81 fa 14 5e 11 80    	cmp    $0x80115e14,%edx
80103f2c:	74 42                	je     80103f70 <choseWithSRTF+0xf0>
    if((p->queuenum == 3) && (p->state == RUNNABLE) && (p->priority == _min)){
80103f2e:	83 ba 80 00 00 00 03 	cmpl   $0x3,0x80(%edx)
80103f35:	75 e9                	jne    80103f20 <choseWithSRTF+0xa0>
80103f37:	83 7a 0c 03          	cmpl   $0x3,0xc(%edx)
80103f3b:	75 e3                	jne    80103f20 <choseWithSRTF+0xa0>
80103f3d:	d9 82 88 00 00 00    	flds   0x88(%edx)
80103f43:	d9 c9                	fxch   %st(1)
80103f45:	db e9                	fucomi %st(1),%st
80103f47:	dd d9                	fstp   %st(1)
80103f49:	7a d5                	jp     80103f20 <choseWithSRTF+0xa0>
80103f4b:	75 d3                	jne    80103f20 <choseWithSRTF+0xa0>
      samepr[count_samepr]=p;
80103f4d:	89 94 8d 60 f0 ff ff 	mov    %edx,-0xfa0(%ebp,%ecx,4)
      _min = p->priority;
      minp = p;
    }
  }
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f54:	81 c2 94 00 00 00    	add    $0x94,%edx
    if((p->queuenum == 3) && (p->state == RUNNABLE) && (p->priority == _min)){
      samepr[count_samepr]=p;
      count_samepr++;
80103f5a:	83 c1 01             	add    $0x1,%ecx
      _min = p->priority;
      minp = p;
    }
  }
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f5d:	81 fa 14 5e 11 80    	cmp    $0x80115e14,%edx
80103f63:	75 c9                	jne    80103f2e <choseWithSRTF+0xae>
80103f65:	dd d8                	fstp   %st(0)
80103f67:	eb 09                	jmp    80103f72 <choseWithSRTF+0xf2>
80103f69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f70:	dd d8                	fstp   %st(0)


static unsigned long int next = 1;
int rand(void)    /* RAND_MAX assumed to be 32767 */
{
    next = next * 1103515245 + 12345;
80103f72:	69 15 08 b0 10 80 6d 	imul   $0x41c64e6d,0x8010b008,%edx
80103f79:	4e c6 41 
80103f7c:	81 c2 39 30 00 00    	add    $0x3039,%edx
      count_samepr++;
    }
  }
  randNum = rand() % count_samepr;
  
  if(count_samepr == 1){
80103f82:	83 f9 01             	cmp    $0x1,%ecx


static unsigned long int next = 1;
int rand(void)    /* RAND_MAX assumed to be 32767 */
{
    next = next * 1103515245 + 12345;
80103f85:	89 15 08 b0 10 80    	mov    %edx,0x8010b008
      count_samepr++;
    }
  }
  randNum = rand() % count_samepr;
  
  if(count_samepr == 1){
80103f8b:	74 14                	je     80103fa1 <choseWithSRTF+0x121>
    if(minp->priority >= 0.1)
      minp->priority -= 0.1;
    return minp;
  }
  else{
    if(samepr[randNum]->priority >= 0.1)
80103f8d:	89 d0                	mov    %edx,%eax
80103f8f:	c1 e8 10             	shr    $0x10,%eax
80103f92:	25 ff 7f 00 00       	and    $0x7fff,%eax
80103f97:	99                   	cltd   
80103f98:	f7 f9                	idiv   %ecx
80103f9a:	8b 84 95 60 f0 ff ff 	mov    -0xfa0(%ebp,%edx,4),%eax
80103fa1:	d9 80 88 00 00 00    	flds   0x88(%eax)
80103fa7:	dd 05 40 88 10 80    	fldl   0x80108840
80103fad:	d9 c9                	fxch   %st(1)
80103faf:	db e9                	fucomi %st(1),%st
80103fb1:	72 0a                	jb     80103fbd <choseWithSRTF+0x13d>
      samepr[randNum]->priority -= 0.1;
80103fb3:	de e1                	fsubp  %st,%st(1)
80103fb5:	d9 98 88 00 00 00    	fstps  0x88(%eax)
80103fbb:	eb 04                	jmp    80103fc1 <choseWithSRTF+0x141>
80103fbd:	dd d8                	fstp   %st(0)
80103fbf:	dd d8                	fstp   %st(0)
    return samepr[randNum];
  }

}
80103fc1:	c9                   	leave  
80103fc2:	c3                   	ret    
80103fc3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103fc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103fd0 <scheduler>:

void
scheduler(void)
{
80103fd0:	55                   	push   %ebp
80103fd1:	89 e5                	mov    %esp,%ebp
80103fd3:	57                   	push   %edi
80103fd4:	56                   	push   %esi
80103fd5:	53                   	push   %ebx
  //cprintf("1\n");
  //struct proc *p;
  //struct proc *p1;
  struct proc *chosen = '\0';
80103fd6:	31 ff                	xor    %edi,%edi

}

void
scheduler(void)
{
80103fd8:	83 ec 0c             	sub    $0xc,%esp
  //cprintf("1\n");
  //struct proc *p;
  //struct proc *p1;
  struct proc *chosen = '\0';
  struct cpu *c = mycpu();
80103fdb:	e8 e0 f9 ff ff       	call   801039c0 <mycpu>
      //cprintf("#####%s\n",chosen->name);
      chosen->executionCycle += 1;
      c->proc = chosen;
      switchuvm(chosen);
      chosen->state = RUNNING;
      swtch(&(c->scheduler), chosen->context);
80103fe0:	8d 70 04             	lea    0x4(%eax),%esi
{
  //cprintf("1\n");
  //struct proc *p;
  //struct proc *p1;
  struct proc *chosen = '\0';
  struct cpu *c = mycpu();
80103fe3:	89 c3                	mov    %eax,%ebx
  c->proc = 0;
80103fe5:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103fec:	00 00 00 
80103fef:	90                   	nop
}

static inline void
sti(void)
{
  asm volatile("sti");
80103ff0:	fb                   	sti    
  int total_no_tickets=0;
  for(;;){
     // cprintf("3\n");
      sti();
    // Loop over process table looking for process to run.
      acquire(&ptable.lock);
80103ff1:	83 ec 0c             	sub    $0xc,%esp
80103ff4:	68 e0 38 11 80       	push   $0x801138e0
80103ff9:	e8 32 11 00 00       	call   80105130 <acquire>
80103ffe:	83 c4 10             	add    $0x10,%esp
//  - eventually that process transfers control
//      via swtch back to the scheduler.

int checkNotEmpty(int queueNum){
  struct proc *p;
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104001:	ba 14 39 11 80       	mov    $0x80113914,%edx
80104006:	eb 1a                	jmp    80104022 <scheduler+0x52>
80104008:	90                   	nop
80104009:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104010:	81 c2 94 00 00 00    	add    $0x94,%edx
80104016:	81 fa 14 5e 11 80    	cmp    $0x80115e14,%edx
8010401c:	0f 84 be 00 00 00    	je     801040e0 <scheduler+0x110>
    //cprintf("jj\n");
    //cprintf("%d",p->queuenum);
    if(p->queuenum == queueNum && (p->state == RUNNABLE)){
80104022:	83 ba 80 00 00 00 01 	cmpl   $0x1,0x80(%edx)
80104029:	75 e5                	jne    80104010 <scheduler+0x40>
8010402b:	83 7a 0c 03          	cmpl   $0x3,0xc(%edx)
8010402f:	75 df                	jne    80104010 <scheduler+0x40>
80104031:	31 c9                	xor    %ecx,%ecx
80104033:	b8 14 39 11 80       	mov    $0x80113914,%eax
80104038:	eb 12                	jmp    8010404c <scheduler+0x7c>
8010403a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
}

int lottery_range(void){
    struct proc *p;
    int ticket_number=0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104040:	05 94 00 00 00       	add    $0x94,%eax
80104045:	3d 14 5e 11 80       	cmp    $0x80115e14,%eax
8010404a:	74 24                	je     80104070 <scheduler+0xa0>
        if(p->state == RUNNABLE && p->queuenum==1){
8010404c:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80104050:	75 ee                	jne    80104040 <scheduler+0x70>
80104052:	83 b8 80 00 00 00 01 	cmpl   $0x1,0x80(%eax)
80104059:	75 e5                	jne    80104040 <scheduler+0x70>
           ticket_number+=p->tickets;
8010405b:	03 88 84 00 00 00    	add    0x84(%eax),%ecx
}

int lottery_range(void){
    struct proc *p;
    int ticket_number=0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104061:	05 94 00 00 00       	add    $0x94,%eax
80104066:	3d 14 5e 11 80       	cmp    $0x80115e14,%eax
8010406b:	75 df                	jne    8010404c <scheduler+0x7c>
8010406d:	8d 76 00             	lea    0x0(%esi),%esi


static unsigned long int next = 1;
int rand(void)    /* RAND_MAX assumed to be 32767 */
{
    next = next * 1103515245 + 12345;
80104070:	69 05 08 b0 10 80 6d 	imul   $0x41c64e6d,0x8010b008,%eax
80104077:	4e c6 41 


struct proc* foundTicket(int goldenTicket){
  struct proc *p;
  int count=0;
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
8010407a:	bf 14 39 11 80       	mov    $0x80113914,%edi


static unsigned long int next = 1;
int rand(void)    /* RAND_MAX assumed to be 32767 */
{
    next = next * 1103515245 + 12345;
8010407f:	05 39 30 00 00       	add    $0x3039,%eax
80104084:	a3 08 b0 10 80       	mov    %eax,0x8010b008
        //if(p->state != RUNNABLE)
          //continue;
      //chosen = '\0';
      if(checkNotEmpty(1)){
          total_no_tickets = lottery_range();
          golden_ticket=rand()%total_no_tickets;
80104089:	c1 e8 10             	shr    $0x10,%eax
8010408c:	25 ff 7f 00 00       	and    $0x7fff,%eax
80104091:	99                   	cltd   
80104092:	f7 f9                	idiv   %ecx
}


struct proc* foundTicket(int goldenTicket){
  struct proc *p;
  int count=0;
80104094:	31 c0                	xor    %eax,%eax
80104096:	eb 16                	jmp    801040ae <scheduler+0xde>
80104098:	90                   	nop
80104099:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801040a0:	81 c7 94 00 00 00    	add    $0x94,%edi
801040a6:	81 ff 14 5e 11 80    	cmp    $0x80115e14,%edi
801040ac:	74 2a                	je     801040d8 <scheduler+0x108>
      if (p->state == RUNNABLE && p->queuenum == 1) {
801040ae:	83 7f 0c 03          	cmpl   $0x3,0xc(%edi)
801040b2:	75 ec                	jne    801040a0 <scheduler+0xd0>
801040b4:	83 bf 80 00 00 00 01 	cmpl   $0x1,0x80(%edi)
801040bb:	75 e3                	jne    801040a0 <scheduler+0xd0>
          if (count + p->tickets < goldenTicket)
801040bd:	03 87 84 00 00 00    	add    0x84(%edi),%eax
801040c3:	39 c2                	cmp    %eax,%edx
801040c5:	7e 4b                	jle    80104112 <scheduler+0x142>


struct proc* foundTicket(int goldenTicket){
  struct proc *p;
  int count=0;
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801040c7:	81 c7 94 00 00 00    	add    $0x94,%edi
801040cd:	81 ff 14 5e 11 80    	cmp    $0x80115e14,%edi
801040d3:	75 d9                	jne    801040ae <scheduler+0xde>
801040d5:	8d 76 00             	lea    0x0(%esi),%esi

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      //cprintf("#####%s\n",chosen->name);
      chosen->executionCycle += 1;
801040d8:	a1 90 00 00 00       	mov    0x90,%eax
801040dd:	0f 0b                	ud2    
801040df:	90                   	nop
//  - eventually that process transfers control
//      via swtch back to the scheduler.

int checkNotEmpty(int queueNum){
  struct proc *p;
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040e0:	b8 14 39 11 80       	mov    $0x80113914,%eax
801040e5:	eb 15                	jmp    801040fc <scheduler+0x12c>
801040e7:	89 f6                	mov    %esi,%esi
801040e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801040f0:	05 94 00 00 00       	add    $0x94,%eax
801040f5:	3d 14 5e 11 80       	cmp    $0x80115e14,%eax
801040fa:	74 61                	je     8010415d <scheduler+0x18d>
    //cprintf("jj\n");
    //cprintf("%d",p->queuenum);
    if(p->queuenum == queueNum && (p->state == RUNNABLE)){
801040fc:	83 b8 80 00 00 00 02 	cmpl   $0x2,0x80(%eax)
80104103:	75 eb                	jne    801040f0 <scheduler+0x120>
80104105:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80104109:	75 e5                	jne    801040f0 <scheduler+0x120>
          total_no_tickets = lottery_range();
          golden_ticket=rand()%total_no_tickets;
          chosen = foundTicket(golden_ticket);
      }
      else if(checkNotEmpty(2)){
        chosen = processWithMaxPriority();
8010410b:	e8 d0 fc ff ff       	call   80103de0 <processWithMaxPriority>
80104110:	89 c7                	mov    %eax,%edi

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      //cprintf("#####%s\n",chosen->name);
      chosen->executionCycle += 1;
80104112:	83 87 90 00 00 00 01 	addl   $0x1,0x90(%edi)
      c->proc = chosen;
      switchuvm(chosen);
80104119:	83 ec 0c             	sub    $0xc,%esp
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      //cprintf("#####%s\n",chosen->name);
      chosen->executionCycle += 1;
      c->proc = chosen;
8010411c:	89 bb ac 00 00 00    	mov    %edi,0xac(%ebx)
      switchuvm(chosen);
80104122:	57                   	push   %edi
80104123:	e8 88 38 00 00       	call   801079b0 <switchuvm>
      chosen->state = RUNNING;
80104128:	c7 47 0c 04 00 00 00 	movl   $0x4,0xc(%edi)
      swtch(&(c->scheduler), chosen->context);
8010412f:	58                   	pop    %eax
80104130:	5a                   	pop    %edx
80104131:	ff 77 1c             	pushl  0x1c(%edi)
80104134:	56                   	push   %esi
80104135:	e8 51 13 00 00       	call   8010548b <swtch>
      switchkvm();
8010413a:	e8 51 38 00 00       	call   80107990 <switchkvm>
      
      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
8010413f:	c7 83 ac 00 00 00 00 	movl   $0x0,0xac(%ebx)
80104146:	00 00 00 
      release(&ptable.lock);
80104149:	c7 04 24 e0 38 11 80 	movl   $0x801138e0,(%esp)
80104150:	e8 8b 10 00 00       	call   801051e0 <release>
      
    //}


  }
80104155:	83 c4 10             	add    $0x10,%esp
80104158:	e9 93 fe ff ff       	jmp    80103ff0 <scheduler+0x20>
//  - eventually that process transfers control
//      via swtch back to the scheduler.

int checkNotEmpty(int queueNum){
  struct proc *p;
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010415d:	b8 14 39 11 80       	mov    $0x80113914,%eax
80104162:	eb 10                	jmp    80104174 <scheduler+0x1a4>
80104164:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104168:	05 94 00 00 00       	add    $0x94,%eax
8010416d:	3d 14 5e 11 80       	cmp    $0x80115e14,%eax
80104172:	74 9e                	je     80104112 <scheduler+0x142>
    //cprintf("jj\n");
    //cprintf("%d",p->queuenum);
    if(p->queuenum == queueNum && (p->state == RUNNABLE)){
80104174:	83 b8 80 00 00 00 03 	cmpl   $0x3,0x80(%eax)
8010417b:	75 eb                	jne    80104168 <scheduler+0x198>
8010417d:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80104181:	75 e5                	jne    80104168 <scheduler+0x198>
      }
      else if(checkNotEmpty(2)){
        chosen = processWithMaxPriority();
      }
      else if(checkNotEmpty(3)){
        chosen = choseWithSRTF();
80104183:	e8 f8 fc ff ff       	call   80103e80 <choseWithSRTF>
80104188:	89 c7                	mov    %eax,%edi
8010418a:	eb 86                	jmp    80104112 <scheduler+0x142>
8010418c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104190 <sched>:
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
80104190:	55                   	push   %ebp
80104191:	89 e5                	mov    %esp,%ebp
80104193:	56                   	push   %esi
80104194:	53                   	push   %ebx
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80104195:	e8 b6 0e 00 00       	call   80105050 <pushcli>
  c = mycpu();
8010419a:	e8 21 f8 ff ff       	call   801039c0 <mycpu>
  p = c->proc;
8010419f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801041a5:	e8 e6 0e 00 00       	call   80105090 <popcli>
sched(void)
{

  int intena;
  struct proc *p = myproc();
  if(!holding(&ptable.lock))
801041aa:	83 ec 0c             	sub    $0xc,%esp
801041ad:	68 e0 38 11 80       	push   $0x801138e0
801041b2:	e8 49 0f 00 00       	call   80105100 <holding>
801041b7:	83 c4 10             	add    $0x10,%esp
801041ba:	85 c0                	test   %eax,%eax
801041bc:	74 4f                	je     8010420d <sched+0x7d>
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
801041be:	e8 fd f7 ff ff       	call   801039c0 <mycpu>
801041c3:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
801041ca:	75 68                	jne    80104234 <sched+0xa4>
    panic("sched locks");
  if(p->state == RUNNING)
801041cc:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
801041d0:	74 55                	je     80104227 <sched+0x97>

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801041d2:	9c                   	pushf  
801041d3:	58                   	pop    %eax
    panic("sched running");
  if(readeflags()&FL_IF)
801041d4:	f6 c4 02             	test   $0x2,%ah
801041d7:	75 41                	jne    8010421a <sched+0x8a>
    panic("sched interruptible");
  intena = mycpu()->intena;
801041d9:	e8 e2 f7 ff ff       	call   801039c0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
801041de:	83 c3 1c             	add    $0x1c,%ebx
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
801041e1:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
801041e7:	e8 d4 f7 ff ff       	call   801039c0 <mycpu>
801041ec:	83 ec 08             	sub    $0x8,%esp
801041ef:	ff 70 04             	pushl  0x4(%eax)
801041f2:	53                   	push   %ebx
801041f3:	e8 93 12 00 00       	call   8010548b <swtch>
  mycpu()->intena = intena;
801041f8:	e8 c3 f7 ff ff       	call   801039c0 <mycpu>
}
801041fd:	83 c4 10             	add    $0x10,%esp
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
  swtch(&p->context, mycpu()->scheduler);
  mycpu()->intena = intena;
80104200:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80104206:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104209:	5b                   	pop    %ebx
8010420a:	5e                   	pop    %esi
8010420b:	5d                   	pop    %ebp
8010420c:	c3                   	ret    
{

  int intena;
  struct proc *p = myproc();
  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
8010420d:	83 ec 0c             	sub    $0xc,%esp
80104210:	68 f8 85 10 80       	push   $0x801085f8
80104215:	e8 56 c1 ff ff       	call   80100370 <panic>
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
8010421a:	83 ec 0c             	sub    $0xc,%esp
8010421d:	68 24 86 10 80       	push   $0x80108624
80104222:	e8 49 c1 ff ff       	call   80100370 <panic>
  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
80104227:	83 ec 0c             	sub    $0xc,%esp
8010422a:	68 16 86 10 80       	push   $0x80108616
8010422f:	e8 3c c1 ff ff       	call   80100370 <panic>
  int intena;
  struct proc *p = myproc();
  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
80104234:	83 ec 0c             	sub    $0xc,%esp
80104237:	68 0a 86 10 80       	push   $0x8010860a
8010423c:	e8 2f c1 ff ff       	call   80100370 <panic>
80104241:	eb 0d                	jmp    80104250 <exit>
80104243:	90                   	nop
80104244:	90                   	nop
80104245:	90                   	nop
80104246:	90                   	nop
80104247:	90                   	nop
80104248:	90                   	nop
80104249:	90                   	nop
8010424a:	90                   	nop
8010424b:	90                   	nop
8010424c:	90                   	nop
8010424d:	90                   	nop
8010424e:	90                   	nop
8010424f:	90                   	nop

80104250 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80104250:	55                   	push   %ebp
80104251:	89 e5                	mov    %esp,%ebp
80104253:	57                   	push   %edi
80104254:	56                   	push   %esi
80104255:	53                   	push   %ebx
80104256:	83 ec 0c             	sub    $0xc,%esp
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80104259:	e8 f2 0d 00 00       	call   80105050 <pushcli>
  c = mycpu();
8010425e:	e8 5d f7 ff ff       	call   801039c0 <mycpu>
  p = c->proc;
80104263:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104269:	e8 22 0e 00 00       	call   80105090 <popcli>
{
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
8010426e:	39 35 b8 b5 10 80    	cmp    %esi,0x8010b5b8
80104274:	8d 5e 28             	lea    0x28(%esi),%ebx
80104277:	8d 7e 68             	lea    0x68(%esi),%edi
8010427a:	0f 84 f1 00 00 00    	je     80104371 <exit+0x121>
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd]){
80104280:	8b 03                	mov    (%ebx),%eax
80104282:	85 c0                	test   %eax,%eax
80104284:	74 12                	je     80104298 <exit+0x48>
      fileclose(curproc->ofile[fd]);
80104286:	83 ec 0c             	sub    $0xc,%esp
80104289:	50                   	push   %eax
8010428a:	e8 01 ce ff ff       	call   80101090 <fileclose>
      curproc->ofile[fd] = 0;
8010428f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80104295:	83 c4 10             	add    $0x10,%esp
80104298:	83 c3 04             	add    $0x4,%ebx

  if(curproc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
8010429b:	39 df                	cmp    %ebx,%edi
8010429d:	75 e1                	jne    80104280 <exit+0x30>
      fileclose(curproc->ofile[fd]);
      curproc->ofile[fd] = 0;
    }
  }

  begin_op();
8010429f:	e8 fc ea ff ff       	call   80102da0 <begin_op>
  iput(curproc->cwd);
801042a4:	83 ec 0c             	sub    $0xc,%esp
801042a7:	ff 76 68             	pushl  0x68(%esi)
801042aa:	e8 41 d7 ff ff       	call   801019f0 <iput>
  end_op();
801042af:	e8 5c eb ff ff       	call   80102e10 <end_op>
  curproc->cwd = 0;
801042b4:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)

  acquire(&ptable.lock);
801042bb:	c7 04 24 e0 38 11 80 	movl   $0x801138e0,(%esp)
801042c2:	e8 69 0e 00 00       	call   80105130 <acquire>

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);
801042c7:	8b 56 14             	mov    0x14(%esi),%edx
801042ca:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801042cd:	b8 14 39 11 80       	mov    $0x80113914,%eax
801042d2:	eb 10                	jmp    801042e4 <exit+0x94>
801042d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801042d8:	05 94 00 00 00       	add    $0x94,%eax
801042dd:	3d 14 5e 11 80       	cmp    $0x80115e14,%eax
801042e2:	74 1e                	je     80104302 <exit+0xb2>
    if(p->state == SLEEPING && p->chan == chan)
801042e4:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801042e8:	75 ee                	jne    801042d8 <exit+0x88>
801042ea:	3b 50 20             	cmp    0x20(%eax),%edx
801042ed:	75 e9                	jne    801042d8 <exit+0x88>
      p->state = RUNNABLE;
801042ef:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801042f6:	05 94 00 00 00       	add    $0x94,%eax
801042fb:	3d 14 5e 11 80       	cmp    $0x80115e14,%eax
80104300:	75 e2                	jne    801042e4 <exit+0x94>
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
80104302:	8b 0d b8 b5 10 80    	mov    0x8010b5b8,%ecx
80104308:	ba 14 39 11 80       	mov    $0x80113914,%edx
8010430d:	eb 0f                	jmp    8010431e <exit+0xce>
8010430f:	90                   	nop

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104310:	81 c2 94 00 00 00    	add    $0x94,%edx
80104316:	81 fa 14 5e 11 80    	cmp    $0x80115e14,%edx
8010431c:	74 3a                	je     80104358 <exit+0x108>
    if(p->parent == curproc){
8010431e:	39 72 14             	cmp    %esi,0x14(%edx)
80104321:	75 ed                	jne    80104310 <exit+0xc0>
      p->parent = initproc;
      if(p->state == ZOMBIE)
80104323:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
80104327:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
8010432a:	75 e4                	jne    80104310 <exit+0xc0>
8010432c:	b8 14 39 11 80       	mov    $0x80113914,%eax
80104331:	eb 11                	jmp    80104344 <exit+0xf4>
80104333:	90                   	nop
80104334:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104338:	05 94 00 00 00       	add    $0x94,%eax
8010433d:	3d 14 5e 11 80       	cmp    $0x80115e14,%eax
80104342:	74 cc                	je     80104310 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
80104344:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104348:	75 ee                	jne    80104338 <exit+0xe8>
8010434a:	3b 48 20             	cmp    0x20(%eax),%ecx
8010434d:	75 e9                	jne    80104338 <exit+0xe8>
      p->state = RUNNABLE;
8010434f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80104356:	eb e0                	jmp    80104338 <exit+0xe8>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
80104358:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
8010435f:	e8 2c fe ff ff       	call   80104190 <sched>
  panic("zombie exit");
80104364:	83 ec 0c             	sub    $0xc,%esp
80104367:	68 45 86 10 80       	push   $0x80108645
8010436c:	e8 ff bf ff ff       	call   80100370 <panic>
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
    panic("init exiting");
80104371:	83 ec 0c             	sub    $0xc,%esp
80104374:	68 38 86 10 80       	push   $0x80108638
80104379:	e8 f2 bf ff ff       	call   80100370 <panic>
8010437e:	66 90                	xchg   %ax,%ax

80104380 <yield>:
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
80104380:	55                   	push   %ebp
80104381:	89 e5                	mov    %esp,%ebp
80104383:	53                   	push   %ebx
80104384:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104387:	68 e0 38 11 80       	push   $0x801138e0
8010438c:	e8 9f 0d 00 00       	call   80105130 <acquire>
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80104391:	e8 ba 0c 00 00       	call   80105050 <pushcli>
  c = mycpu();
80104396:	e8 25 f6 ff ff       	call   801039c0 <mycpu>
  p = c->proc;
8010439b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801043a1:	e8 ea 0c 00 00       	call   80105090 <popcli>
// Give up the CPU for one scheduling round.
void
yield(void)
{
  acquire(&ptable.lock);  //DOC: yieldlock
  myproc()->state = RUNNABLE;
801043a6:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
801043ad:	e8 de fd ff ff       	call   80104190 <sched>
  release(&ptable.lock);
801043b2:	c7 04 24 e0 38 11 80 	movl   $0x801138e0,(%esp)
801043b9:	e8 22 0e 00 00       	call   801051e0 <release>
}
801043be:	83 c4 10             	add    $0x10,%esp
801043c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801043c4:	c9                   	leave  
801043c5:	c3                   	ret    
801043c6:	8d 76 00             	lea    0x0(%esi),%esi
801043c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801043d0 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
801043d0:	55                   	push   %ebp
801043d1:	89 e5                	mov    %esp,%ebp
801043d3:	57                   	push   %edi
801043d4:	56                   	push   %esi
801043d5:	53                   	push   %ebx
801043d6:	83 ec 0c             	sub    $0xc,%esp
801043d9:	8b 7d 08             	mov    0x8(%ebp),%edi
801043dc:	8b 75 0c             	mov    0xc(%ebp),%esi
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
801043df:	e8 6c 0c 00 00       	call   80105050 <pushcli>
  c = mycpu();
801043e4:	e8 d7 f5 ff ff       	call   801039c0 <mycpu>
  p = c->proc;
801043e9:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801043ef:	e8 9c 0c 00 00       	call   80105090 <popcli>
void
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
  
  if(p == 0)
801043f4:	85 db                	test   %ebx,%ebx
801043f6:	0f 84 87 00 00 00    	je     80104483 <sleep+0xb3>
    panic("sleep");

  if(lk == 0)
801043fc:	85 f6                	test   %esi,%esi
801043fe:	74 76                	je     80104476 <sleep+0xa6>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104400:	81 fe e0 38 11 80    	cmp    $0x801138e0,%esi
80104406:	74 50                	je     80104458 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104408:	83 ec 0c             	sub    $0xc,%esp
8010440b:	68 e0 38 11 80       	push   $0x801138e0
80104410:	e8 1b 0d 00 00       	call   80105130 <acquire>
    release(lk);
80104415:	89 34 24             	mov    %esi,(%esp)
80104418:	e8 c3 0d 00 00       	call   801051e0 <release>
  }
  // Go to sleep.
  p->chan = chan;
8010441d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104420:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)

  sched();
80104427:	e8 64 fd ff ff       	call   80104190 <sched>

  // Tidy up.
  p->chan = 0;
8010442c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
80104433:	c7 04 24 e0 38 11 80 	movl   $0x801138e0,(%esp)
8010443a:	e8 a1 0d 00 00       	call   801051e0 <release>
    acquire(lk);
8010443f:	89 75 08             	mov    %esi,0x8(%ebp)
80104442:	83 c4 10             	add    $0x10,%esp
  }
}
80104445:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104448:	5b                   	pop    %ebx
80104449:	5e                   	pop    %esi
8010444a:	5f                   	pop    %edi
8010444b:	5d                   	pop    %ebp
  p->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
8010444c:	e9 df 0c 00 00       	jmp    80105130 <acquire>
80104451:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(lk != &ptable.lock){  //DOC: sleeplock0
    acquire(&ptable.lock);  //DOC: sleeplock1
    release(lk);
  }
  // Go to sleep.
  p->chan = chan;
80104458:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010445b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)

  sched();
80104462:	e8 29 fd ff ff       	call   80104190 <sched>

  // Tidy up.
  p->chan = 0;
80104467:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  }
}
8010446e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104471:	5b                   	pop    %ebx
80104472:	5e                   	pop    %esi
80104473:	5f                   	pop    %edi
80104474:	5d                   	pop    %ebp
80104475:	c3                   	ret    
  
  if(p == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");
80104476:	83 ec 0c             	sub    $0xc,%esp
80104479:	68 57 86 10 80       	push   $0x80108657
8010447e:	e8 ed be ff ff       	call   80100370 <panic>
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
  
  if(p == 0)
    panic("sleep");
80104483:	83 ec 0c             	sub    $0xc,%esp
80104486:	68 51 86 10 80       	push   $0x80108651
8010448b:	e8 e0 be ff ff       	call   80100370 <panic>

80104490 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
80104490:	55                   	push   %ebp
80104491:	89 e5                	mov    %esp,%ebp
80104493:	56                   	push   %esi
80104494:	53                   	push   %ebx
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80104495:	e8 b6 0b 00 00       	call   80105050 <pushcli>
  c = mycpu();
8010449a:	e8 21 f5 ff ff       	call   801039c0 <mycpu>
  p = c->proc;
8010449f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801044a5:	e8 e6 0b 00 00       	call   80105090 <popcli>
{
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
  
  acquire(&ptable.lock);
801044aa:	83 ec 0c             	sub    $0xc,%esp
801044ad:	68 e0 38 11 80       	push   $0x801138e0
801044b2:	e8 79 0c 00 00       	call   80105130 <acquire>
801044b7:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
801044ba:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801044bc:	bb 14 39 11 80       	mov    $0x80113914,%ebx
801044c1:	eb 13                	jmp    801044d6 <wait+0x46>
801044c3:	90                   	nop
801044c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801044c8:	81 c3 94 00 00 00    	add    $0x94,%ebx
801044ce:	81 fb 14 5e 11 80    	cmp    $0x80115e14,%ebx
801044d4:	74 22                	je     801044f8 <wait+0x68>
      if(p->parent != curproc)
801044d6:	39 73 14             	cmp    %esi,0x14(%ebx)
801044d9:	75 ed                	jne    801044c8 <wait+0x38>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
801044db:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
801044df:	74 35                	je     80104516 <wait+0x86>
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801044e1:	81 c3 94 00 00 00    	add    $0x94,%ebx
      if(p->parent != curproc)
        continue;
      havekids = 1;
801044e7:	b8 01 00 00 00       	mov    $0x1,%eax
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801044ec:	81 fb 14 5e 11 80    	cmp    $0x80115e14,%ebx
801044f2:	75 e2                	jne    801044d6 <wait+0x46>
801044f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
801044f8:	85 c0                	test   %eax,%eax
801044fa:	74 70                	je     8010456c <wait+0xdc>
801044fc:	8b 46 24             	mov    0x24(%esi),%eax
801044ff:	85 c0                	test   %eax,%eax
80104501:	75 69                	jne    8010456c <wait+0xdc>
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80104503:	83 ec 08             	sub    $0x8,%esp
80104506:	68 e0 38 11 80       	push   $0x801138e0
8010450b:	56                   	push   %esi
8010450c:	e8 bf fe ff ff       	call   801043d0 <sleep>
  }
80104511:	83 c4 10             	add    $0x10,%esp
80104514:	eb a4                	jmp    801044ba <wait+0x2a>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
80104516:	83 ec 0c             	sub    $0xc,%esp
80104519:	ff 73 08             	pushl  0x8(%ebx)
      if(p->parent != curproc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
8010451c:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
8010451f:	e8 0c e0 ff ff       	call   80102530 <kfree>
        p->kstack = 0;
        freevm(p->pgdir);
80104524:	5a                   	pop    %edx
80104525:	ff 73 04             	pushl  0x4(%ebx)
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
80104528:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
8010452f:	e8 fc 37 00 00       	call   80107d30 <freevm>
        p->pid = 0;
80104534:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
8010453b:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80104542:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104546:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
8010454d:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80104554:	c7 04 24 e0 38 11 80 	movl   $0x801138e0,(%esp)
8010455b:	e8 80 0c 00 00       	call   801051e0 <release>
        return pid;
80104560:	83 c4 10             	add    $0x10,%esp
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80104563:	8d 65 f8             	lea    -0x8(%ebp),%esp
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
        release(&ptable.lock);
        return pid;
80104566:	89 f0                	mov    %esi,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80104568:	5b                   	pop    %ebx
80104569:	5e                   	pop    %esi
8010456a:	5d                   	pop    %ebp
8010456b:	c3                   	ret    
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
8010456c:	83 ec 0c             	sub    $0xc,%esp
8010456f:	68 e0 38 11 80       	push   $0x801138e0
80104574:	e8 67 0c 00 00       	call   801051e0 <release>
      return -1;
80104579:	83 c4 10             	add    $0x10,%esp
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
8010457c:	8d 65 f8             	lea    -0x8(%ebp),%esp
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
      return -1;
8010457f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80104584:	5b                   	pop    %ebx
80104585:	5e                   	pop    %esi
80104586:	5d                   	pop    %ebp
80104587:	c3                   	ret    
80104588:	90                   	nop
80104589:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104590 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104590:	55                   	push   %ebp
80104591:	89 e5                	mov    %esp,%ebp
80104593:	53                   	push   %ebx
80104594:	83 ec 10             	sub    $0x10,%esp
80104597:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010459a:	68 e0 38 11 80       	push   $0x801138e0
8010459f:	e8 8c 0b 00 00       	call   80105130 <acquire>
801045a4:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801045a7:	b8 14 39 11 80       	mov    $0x80113914,%eax
801045ac:	eb 0e                	jmp    801045bc <wakeup+0x2c>
801045ae:	66 90                	xchg   %ax,%ax
801045b0:	05 94 00 00 00       	add    $0x94,%eax
801045b5:	3d 14 5e 11 80       	cmp    $0x80115e14,%eax
801045ba:	74 1e                	je     801045da <wakeup+0x4a>
    if(p->state == SLEEPING && p->chan == chan)
801045bc:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801045c0:	75 ee                	jne    801045b0 <wakeup+0x20>
801045c2:	3b 58 20             	cmp    0x20(%eax),%ebx
801045c5:	75 e9                	jne    801045b0 <wakeup+0x20>
      p->state = RUNNABLE;
801045c7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801045ce:	05 94 00 00 00       	add    $0x94,%eax
801045d3:	3d 14 5e 11 80       	cmp    $0x80115e14,%eax
801045d8:	75 e2                	jne    801045bc <wakeup+0x2c>
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
801045da:	c7 45 08 e0 38 11 80 	movl   $0x801138e0,0x8(%ebp)
}
801045e1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801045e4:	c9                   	leave  
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
801045e5:	e9 f6 0b 00 00       	jmp    801051e0 <release>
801045ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801045f0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
801045f0:	55                   	push   %ebp
801045f1:	89 e5                	mov    %esp,%ebp
801045f3:	53                   	push   %ebx
801045f4:	83 ec 10             	sub    $0x10,%esp
801045f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
801045fa:	68 e0 38 11 80       	push   $0x801138e0
801045ff:	e8 2c 0b 00 00       	call   80105130 <acquire>
80104604:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104607:	b8 14 39 11 80       	mov    $0x80113914,%eax
8010460c:	eb 0e                	jmp    8010461c <kill+0x2c>
8010460e:	66 90                	xchg   %ax,%ax
80104610:	05 94 00 00 00       	add    $0x94,%eax
80104615:	3d 14 5e 11 80       	cmp    $0x80115e14,%eax
8010461a:	74 3c                	je     80104658 <kill+0x68>
    if(p->pid == pid){
8010461c:	39 58 10             	cmp    %ebx,0x10(%eax)
8010461f:	75 ef                	jne    80104610 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104621:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
80104625:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
8010462c:	74 1a                	je     80104648 <kill+0x58>
        p->state = RUNNABLE;
      release(&ptable.lock);
8010462e:	83 ec 0c             	sub    $0xc,%esp
80104631:	68 e0 38 11 80       	push   $0x801138e0
80104636:	e8 a5 0b 00 00       	call   801051e0 <release>
      return 0;
8010463b:	83 c4 10             	add    $0x10,%esp
8010463e:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
80104640:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104643:	c9                   	leave  
80104644:	c3                   	ret    
80104645:	8d 76 00             	lea    0x0(%esi),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
80104648:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
8010464f:	eb dd                	jmp    8010462e <kill+0x3e>
80104651:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
80104658:	83 ec 0c             	sub    $0xc,%esp
8010465b:	68 e0 38 11 80       	push   $0x801138e0
80104660:	e8 7b 0b 00 00       	call   801051e0 <release>
  return -1;
80104665:	83 c4 10             	add    $0x10,%esp
80104668:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010466d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104670:	c9                   	leave  
80104671:	c3                   	ret    
80104672:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104679:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104680 <findch>:

    return chname;
}


int findch(int pid){
80104680:	55                   	push   %ebp
80104681:	89 e5                	mov    %esp,%ebp
80104683:	57                   	push   %edi
80104684:	56                   	push   %esi
80104685:	53                   	push   %ebx
  r2 = 1;
  int i = 0;
80104686:	31 db                	xor    %ebx,%ebx

    return chname;
}


int findch(int pid){
80104688:	83 ec 28             	sub    $0x28,%esp
  r2 = 1;
8010468b:	c7 05 c0 38 11 80 01 	movl   $0x1,0x801138c0
80104692:	00 00 00 

    return chname;
}


int findch(int pid){
80104695:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i = 0;
  int j = 0;
  int r = 1;
  struct proc *p;
  int name = 0;
  acquire(&ptable.lock);
80104698:	68 e0 38 11 80       	push   $0x801138e0
8010469d:	e8 8e 0a 00 00       	call   80105130 <acquire>
801046a2:	8b 35 c0 38 11 80    	mov    0x801138c0,%esi
801046a8:	83 c4 10             	add    $0x10,%esp
801046ab:	31 d2                	xor    %edx,%edx
  r2 = 1;
  int i = 0;
  int j = 0;
  int r = 1;
  struct proc *p;
  int name = 0;
801046ad:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801046b4:	b9 14 39 11 80       	mov    $0x80113914,%ecx
801046b9:	eb 13                	jmp    801046ce <findch+0x4e>
801046bb:	90                   	nop
801046bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801046c0:	81 c1 94 00 00 00    	add    $0x94,%ecx
801046c6:	81 f9 14 5e 11 80    	cmp    $0x80115e14,%ecx
801046cc:	74 48                	je     80104716 <findch+0x96>
    if(p->parent->pid == pid){
801046ce:	8b 41 14             	mov    0x14(%ecx),%eax
801046d1:	39 78 10             	cmp    %edi,0x10(%eax)
801046d4:	75 ea                	jne    801046c0 <findch+0x40>
       for(j=0;j<i;j++){
801046d6:	85 db                	test   %ebx,%ebx
801046d8:	b8 01 00 00 00       	mov    $0x1,%eax
801046dd:	74 15                	je     801046f4 <findch+0x74>
801046df:	31 d2                	xor    %edx,%edx
801046e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
           r *= 10;
801046e8:	8d 04 80             	lea    (%eax,%eax,4),%eax
  struct proc *p;
  int name = 0;
  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent->pid == pid){
       for(j=0;j<i;j++){
801046eb:	83 c2 01             	add    $0x1,%edx
           r *= 10;
801046ee:	01 c0                	add    %eax,%eax
  struct proc *p;
  int name = 0;
  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent->pid == pid){
       for(j=0;j<i;j++){
801046f0:	39 da                	cmp    %ebx,%edx
801046f2:	75 f4                	jne    801046e8 <findch+0x68>
           r *= 10;
       }
       r2 *= 10;
       name += r * p->pid;
801046f4:	0f af 41 10          	imul   0x10(%ecx),%eax
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent->pid == pid){
       for(j=0;j<i;j++){
           r *= 10;
       }
       r2 *= 10;
801046f8:	8d 34 b6             	lea    (%esi,%esi,4),%esi
  int j = 0;
  int r = 1;
  struct proc *p;
  int name = 0;
  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801046fb:	81 c1 94 00 00 00    	add    $0x94,%ecx
       for(j=0;j<i;j++){
           r *= 10;
       }
       r2 *= 10;
       name += r * p->pid;
       i = i + 1;
80104701:	83 c3 01             	add    $0x1,%ebx
80104704:	ba 01 00 00 00       	mov    $0x1,%edx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent->pid == pid){
       for(j=0;j<i;j++){
           r *= 10;
       }
       r2 *= 10;
80104709:	01 f6                	add    %esi,%esi
       name += r * p->pid;
8010470b:	01 45 e4             	add    %eax,-0x1c(%ebp)
  int j = 0;
  int r = 1;
  struct proc *p;
  int name = 0;
  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010470e:	81 f9 14 5e 11 80    	cmp    $0x80115e14,%ecx
80104714:	75 b8                	jne    801046ce <findch+0x4e>
80104716:	84 d2                	test   %dl,%dl
80104718:	75 18                	jne    80104732 <findch+0xb2>
       name += r * p->pid;
       i = i + 1;
       r = 1;
    }
  }
  release(&ptable.lock);
8010471a:	83 ec 0c             	sub    $0xc,%esp
8010471d:	68 e0 38 11 80       	push   $0x801138e0
80104722:	e8 b9 0a 00 00       	call   801051e0 <release>
  return name;

}
80104727:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010472a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010472d:	5b                   	pop    %ebx
8010472e:	5e                   	pop    %esi
8010472f:	5f                   	pop    %edi
80104730:	5d                   	pop    %ebp
80104731:	c3                   	ret    
80104732:	89 35 c0 38 11 80    	mov    %esi,0x801138c0
80104738:	eb e0                	jmp    8010471a <findch+0x9a>
8010473a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104740 <getchildren>:

//getchildren of a parent
////////////////////////////////////////////////////////////////////////PART 3///////////////////////////////////////////////////////////////////////

int r2;
int getchildren(int pid) {
80104740:	55                   	push   %ebp
80104741:	89 e5                	mov    %esp,%ebp
80104743:	57                   	push   %edi
80104744:	56                   	push   %esi
80104745:	53                   	push   %ebx
80104746:	81 ec 28 01 00 00    	sub    $0x128,%esp
8010474c:	8b 7d 08             	mov    0x8(%ebp),%edi

    int chname = 0;
    struct proc *p;
    int queue[NPROC], front = -1,rear = -1;
    int delete_item;
    acquire(&ptable.lock);
8010474f:	68 e0 38 11 80       	push   $0x801138e0
80104754:	e8 d7 09 00 00       	call   80105130 <acquire>
80104759:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010475c:	b8 14 39 11 80       	mov    $0x80113914,%eax
80104761:	eb 11                	jmp    80104774 <getchildren+0x34>
80104763:	90                   	nop
80104764:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104768:	05 94 00 00 00       	add    $0x94,%eax
8010476d:	3d 14 5e 11 80       	cmp    $0x80115e14,%eax
80104772:	74 18                	je     8010478c <getchildren+0x4c>
       if(p->pid == pid)
80104774:	39 78 10             	cmp    %edi,0x10(%eax)
80104777:	75 ef                	jne    80104768 <getchildren+0x28>
	  p->visited = 1;
80104779:	c7 40 7c 01 00 00 00 	movl   $0x1,0x7c(%eax)
    int chname = 0;
    struct proc *p;
    int queue[NPROC], front = -1,rear = -1;
    int delete_item;
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104780:	05 94 00 00 00       	add    $0x94,%eax
80104785:	3d 14 5e 11 80       	cmp    $0x80115e14,%eax
8010478a:	75 e8                	jne    80104774 <getchildren+0x34>
       if(p->pid == pid)
	  p->visited = 1;
    }
    release(&ptable.lock);
8010478c:	83 ec 0c             	sub    $0xc,%esp
    if(rear != NPROC - 1)
    {
       if(front == -1) 
	  front = 0;
       rear = rear+1;
       queue[rear] = pid;
8010478f:	31 f6                	xor    %esi,%esi
80104791:	31 db                	xor    %ebx,%ebx
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
       if(p->pid == pid)
	  p->visited = 1;
    }
    release(&ptable.lock);
80104793:	68 e0 38 11 80       	push   $0x801138e0
80104798:	e8 43 0a 00 00       	call   801051e0 <release>
    if(rear != NPROC - 1)
    {
       if(front == -1) 
	  front = 0;
       rear = rear+1;
       queue[rear] = pid;
8010479d:	89 bd e8 fe ff ff    	mov    %edi,-0x118(%ebp)
801047a3:	83 c4 10             	add    $0x10,%esp
801047a6:	c7 85 e4 fe ff ff 00 	movl   $0x0,-0x11c(%ebp)
801047ad:	00 00 00 
    }

    while((front != -1) && (front <= rear)){
        delete_item = queue[front];
	front = front+1;
        chname = findch(delete_item) + (chname * r2);
801047b0:	83 ec 0c             	sub    $0xc,%esp
       queue[rear] = pid;
    }

    while((front != -1) && (front <= rear)){
        delete_item = queue[front];
	front = front+1;
801047b3:	83 85 e4 fe ff ff 01 	addl   $0x1,-0x11c(%ebp)
        chname = findch(delete_item) + (chname * r2);
801047ba:	57                   	push   %edi
801047bb:	e8 c0 fe ff ff       	call   80104680 <findch>
801047c0:	0f af 1d c0 38 11 80 	imul   0x801138c0,%ebx
        acquire(&ptable.lock);
801047c7:	c7 04 24 e0 38 11 80 	movl   $0x801138e0,(%esp)
    }

    while((front != -1) && (front <= rear)){
        delete_item = queue[front];
	front = front+1;
        chname = findch(delete_item) + (chname * r2);
801047ce:	01 c3                	add    %eax,%ebx
        acquire(&ptable.lock);
801047d0:	e8 5b 09 00 00       	call   80105130 <acquire>
801047d5:	83 c4 10             	add    $0x10,%esp
        for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801047d8:	b8 14 39 11 80       	mov    $0x80113914,%eax
801047dd:	eb 0d                	jmp    801047ec <getchildren+0xac>
801047df:	90                   	nop
801047e0:	05 94 00 00 00       	add    $0x94,%eax
801047e5:	3d 14 5e 11 80       	cmp    $0x80115e14,%eax
801047ea:	74 33                	je     8010481f <getchildren+0xdf>
          if((p->parent->pid == delete_item) && (p->visited != 1)){
801047ec:	8b 48 14             	mov    0x14(%eax),%ecx
801047ef:	39 79 10             	cmp    %edi,0x10(%ecx)
801047f2:	75 ec                	jne    801047e0 <getchildren+0xa0>
801047f4:	83 78 7c 01          	cmpl   $0x1,0x7c(%eax)
801047f8:	74 e6                	je     801047e0 <getchildren+0xa0>
             if(rear != NPROC - 1)
801047fa:	83 fe 3f             	cmp    $0x3f,%esi
801047fd:	74 0d                	je     8010480c <getchildren+0xcc>
             {
                if(front == -1) 
	           front = 0;
                rear = rear+1;
                queue[rear] = p->pid;
801047ff:	8b 48 10             	mov    0x10(%eax),%ecx
          if((p->parent->pid == delete_item) && (p->visited != 1)){
             if(rear != NPROC - 1)
             {
                if(front == -1) 
	           front = 0;
                rear = rear+1;
80104802:	83 c6 01             	add    $0x1,%esi
                queue[rear] = p->pid;
80104805:	89 8c b5 e8 fe ff ff 	mov    %ecx,-0x118(%ebp,%esi,4)
             }
             p->visited = 1;
8010480c:	c7 40 7c 01 00 00 00 	movl   $0x1,0x7c(%eax)
    while((front != -1) && (front <= rear)){
        delete_item = queue[front];
	front = front+1;
        chname = findch(delete_item) + (chname * r2);
        acquire(&ptable.lock);
        for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104813:	05 94 00 00 00       	add    $0x94,%eax
80104818:	3d 14 5e 11 80       	cmp    $0x80115e14,%eax
8010481d:	75 cd                	jne    801047ec <getchildren+0xac>
             }
             p->visited = 1;

          }
        }
        release(&ptable.lock);
8010481f:	83 ec 0c             	sub    $0xc,%esp
80104822:	68 e0 38 11 80       	push   $0x801138e0
80104827:	e8 b4 09 00 00       	call   801051e0 <release>
	  front = 0;
       rear = rear+1;
       queue[rear] = pid;
    }

    while((front != -1) && (front <= rear)){
8010482c:	8b 85 e4 fe ff ff    	mov    -0x11c(%ebp),%eax
80104832:	83 c4 10             	add    $0x10,%esp
80104835:	39 c6                	cmp    %eax,%esi
80104837:	7c 0c                	jl     80104845 <getchildren+0x105>
80104839:	8b bc 85 e8 fe ff ff 	mov    -0x118(%ebp,%eax,4),%edi
80104840:	e9 6b ff ff ff       	jmp    801047b0 <getchildren+0x70>
        }
        release(&ptable.lock);
    }

    return chname;
}
80104845:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104848:	89 d8                	mov    %ebx,%eax
8010484a:	5b                   	pop    %ebx
8010484b:	5e                   	pop    %esi
8010484c:	5f                   	pop    %edi
8010484d:	5d                   	pop    %ebp
8010484e:	c3                   	ret    
8010484f:	90                   	nop

80104850 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104850:	55                   	push   %ebp
80104851:	89 e5                	mov    %esp,%ebp
80104853:	57                   	push   %edi
80104854:	56                   	push   %esi
80104855:	53                   	push   %ebx
80104856:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104859:	bb 80 39 11 80       	mov    $0x80113980,%ebx
8010485e:	83 ec 3c             	sub    $0x3c,%esp
80104861:	eb 27                	jmp    8010488a <procdump+0x3a>
80104863:	90                   	nop
80104864:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104868:	83 ec 0c             	sub    $0xc,%esp
8010486b:	68 90 86 10 80       	push   $0x80108690
80104870:	e8 eb bd ff ff       	call   80100660 <cprintf>
80104875:	83 c4 10             	add    $0x10,%esp
80104878:	81 c3 94 00 00 00    	add    $0x94,%ebx
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010487e:	81 fb 80 5e 11 80    	cmp    $0x80115e80,%ebx
80104884:	0f 84 7e 00 00 00    	je     80104908 <procdump+0xb8>
    if(p->state == UNUSED)
8010488a:	8b 43 a0             	mov    -0x60(%ebx),%eax
8010488d:	85 c0                	test   %eax,%eax
8010488f:	74 e7                	je     80104878 <procdump+0x28>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104891:	83 f8 05             	cmp    $0x5,%eax
      state = states[p->state];
    else
      state = "???";
80104894:	ba 68 86 10 80       	mov    $0x80108668,%edx
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104899:	77 11                	ja     801048ac <procdump+0x5c>
8010489b:	8b 14 85 24 88 10 80 	mov    -0x7fef77dc(,%eax,4),%edx
      state = states[p->state];
    else
      state = "???";
801048a2:	b8 68 86 10 80       	mov    $0x80108668,%eax
801048a7:	85 d2                	test   %edx,%edx
801048a9:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
801048ac:	53                   	push   %ebx
801048ad:	52                   	push   %edx
801048ae:	ff 73 a4             	pushl  -0x5c(%ebx)
801048b1:	68 6c 86 10 80       	push   $0x8010866c
801048b6:	e8 a5 bd ff ff       	call   80100660 <cprintf>
    if(p->state == SLEEPING){
801048bb:	83 c4 10             	add    $0x10,%esp
801048be:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
801048c2:	75 a4                	jne    80104868 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
801048c4:	8d 45 c0             	lea    -0x40(%ebp),%eax
801048c7:	83 ec 08             	sub    $0x8,%esp
801048ca:	8d 7d c0             	lea    -0x40(%ebp),%edi
801048cd:	50                   	push   %eax
801048ce:	8b 43 b0             	mov    -0x50(%ebx),%eax
801048d1:	8b 40 0c             	mov    0xc(%eax),%eax
801048d4:	83 c0 08             	add    $0x8,%eax
801048d7:	50                   	push   %eax
801048d8:	e8 13 07 00 00       	call   80104ff0 <getcallerpcs>
801048dd:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
801048e0:	8b 17                	mov    (%edi),%edx
801048e2:	85 d2                	test   %edx,%edx
801048e4:	74 82                	je     80104868 <procdump+0x18>
        cprintf(" %p", pc[i]);
801048e6:	83 ec 08             	sub    $0x8,%esp
801048e9:	83 c7 04             	add    $0x4,%edi
801048ec:	52                   	push   %edx
801048ed:	68 a1 80 10 80       	push   $0x801080a1
801048f2:	e8 69 bd ff ff       	call   80100660 <cprintf>
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
801048f7:	83 c4 10             	add    $0x10,%esp
801048fa:	39 f7                	cmp    %esi,%edi
801048fc:	75 e2                	jne    801048e0 <procdump+0x90>
801048fe:	e9 65 ff ff ff       	jmp    80104868 <procdump+0x18>
80104903:	90                   	nop
80104904:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
80104908:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010490b:	5b                   	pop    %ebx
8010490c:	5e                   	pop    %esi
8010490d:	5f                   	pop    %edi
8010490e:	5d                   	pop    %ebp
8010490f:	c3                   	ret    

80104910 <set>:

int
set(char * path)
{ 
80104910:	55                   	push   %ebp
    int i=0;
    int j;
    char temp[100];
    struct inode *ip;
    int size;
    while(path[i]!='\0'){
80104911:	31 c0                	xor    %eax,%eax
  }
}

int
set(char * path)
{ 
80104913:	89 e5                	mov    %esp,%ebp
80104915:	57                   	push   %edi
80104916:	56                   	push   %esi
80104917:	53                   	push   %ebx
80104918:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
8010491e:	8b 4d 08             	mov    0x8(%ebp),%ecx
    int i=0;
    int j;
    char temp[100];
    struct inode *ip;
    int size;
    while(path[i]!='\0'){
80104921:	0f b6 11             	movzbl (%ecx),%edx
80104924:	84 d2                	test   %dl,%dl
80104926:	74 19                	je     80104941 <set+0x31>
80104928:	90                   	nop
80104929:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      add_path[i]=path[i];
80104930:	88 90 20 0f 11 80    	mov    %dl,-0x7feef0e0(%eax)
      i++;
80104936:	83 c0 01             	add    $0x1,%eax
    int i=0;
    int j;
    char temp[100];
    struct inode *ip;
    int size;
    while(path[i]!='\0'){
80104939:	0f b6 14 01          	movzbl (%ecx,%eax,1),%edx
8010493d:	84 d2                	test   %dl,%dl
8010493f:	75 ef                	jne    80104930 <set+0x20>
      add_path[i]=path[i];
      i++;
    }
    add_path[i]='\0';
    size=get_size_string(add_path);
80104941:	83 ec 0c             	sub    $0xc,%esp
    int size;
    while(path[i]!='\0'){
      add_path[i]=path[i];
      i++;
    }
    add_path[i]='\0';
80104944:	c6 80 20 0f 11 80 00 	movb   $0x0,-0x7feef0e0(%eax)
8010494b:	8d 7d 84             	lea    -0x7c(%ebp),%edi
    size=get_size_string(add_path);
8010494e:	68 20 0f 11 80       	push   $0x80110f20
80104953:	e8 98 c0 ff ff       	call   801009f0 <get_size_string>
    for(j=0;j<size;j++){
80104958:	83 c4 10             	add    $0x10,%esp
8010495b:	31 c9                	xor    %ecx,%ecx
8010495d:	85 c0                	test   %eax,%eax
    while(path[i]!='\0'){
      add_path[i]=path[i];
      i++;
    }
    add_path[i]='\0';
    size=get_size_string(add_path);
8010495f:	89 c6                	mov    %eax,%esi
    for(j=0;j<size;j++){
80104961:	c7 85 74 ff ff ff 00 	movl   $0x0,-0x8c(%ebp)
80104968:	00 00 00 
8010496b:	7e 53                	jle    801049c0 <set+0xb0>
8010496d:	8d 76 00             	lea    0x0(%esi),%esi
80104970:	89 cb                	mov    %ecx,%ebx
80104972:	31 c0                	xor    %eax,%eax
80104974:	eb 17                	jmp    8010498d <set+0x7d>
80104976:	8d 76 00             	lea    0x0(%esi),%esi
80104979:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
     while(add_path[j]!=':'){
       	temp[ii]=add_path[j];
        ii++;
        j++; 
80104980:	83 c3 01             	add    $0x1,%ebx
    }
    add_path[i]='\0';
    size=get_size_string(add_path);
    for(j=0;j<size;j++){
     while(add_path[j]!=':'){
       	temp[ii]=add_path[j];
80104983:	88 14 07             	mov    %dl,(%edi,%eax,1)
        ii++;
80104986:	83 c0 01             	add    $0x1,%eax
        j++; 
        if(j>=size)
80104989:	39 de                	cmp    %ebx,%esi
8010498b:	7e 0d                	jle    8010499a <set+0x8a>
      i++;
    }
    add_path[i]='\0';
    size=get_size_string(add_path);
    for(j=0;j<size;j++){
     while(add_path[j]!=':'){
8010498d:	0f b6 94 01 20 0f 11 	movzbl -0x7feef0e0(%ecx,%eax,1),%edx
80104994:	80 
80104995:	80 fa 3a             	cmp    $0x3a,%dl
80104998:	75 e6                	jne    80104980 <set+0x70>
            break;
     }
     temp[ii]='\0';
       ii++;
       ii=0;
       ip=namei(temp);
8010499a:	83 ec 0c             	sub    $0xc,%esp
        ii++;
        j++; 
        if(j>=size)
            break;
     }
     temp[ii]='\0';
8010499d:	c6 44 05 84 00       	movb   $0x0,-0x7c(%ebp,%eax,1)
       ii++;
       ii=0;
       ip=namei(temp);
801049a2:	57                   	push   %edi
801049a3:	e8 68 d7 ff ff       	call   80102110 <namei>
       if(ip == 0){
801049a8:	83 c4 10             	add    $0x10,%esp
801049ab:	85 c0                	test   %eax,%eax
801049ad:	74 1b                	je     801049ca <set+0xba>
      add_path[i]=path[i];
      i++;
    }
    add_path[i]='\0';
    size=get_size_string(add_path);
    for(j=0;j<size;j++){
801049af:	8d 4b 01             	lea    0x1(%ebx),%ecx
801049b2:	39 ce                	cmp    %ecx,%esi
801049b4:	7f ba                	jg     80104970 <set+0x60>
       if(ip == 0){
	 cprintf("%s directory doesn't exist!\n",temp);
         error=1;
       }
     }
     if(error)
801049b6:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
801049bc:	85 c0                	test   %eax,%eax
801049be:	75 27                	jne    801049e7 <set+0xd7>
	exit();
    return 0;
}
801049c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801049c3:	31 c0                	xor    %eax,%eax
801049c5:	5b                   	pop    %ebx
801049c6:	5e                   	pop    %esi
801049c7:	5f                   	pop    %edi
801049c8:	5d                   	pop    %ebp
801049c9:	c3                   	ret    
     temp[ii]='\0';
       ii++;
       ii=0;
       ip=namei(temp);
       if(ip == 0){
	 cprintf("%s directory doesn't exist!\n",temp);
801049ca:	83 ec 08             	sub    $0x8,%esp
801049cd:	57                   	push   %edi
801049ce:	68 75 86 10 80       	push   $0x80108675
801049d3:	e8 88 bc ff ff       	call   80100660 <cprintf>
801049d8:	83 c4 10             	add    $0x10,%esp
         error=1;
801049db:	c7 85 74 ff ff ff 01 	movl   $0x1,-0x8c(%ebp)
801049e2:	00 00 00 
801049e5:	eb c8                	jmp    801049af <set+0x9f>
       }
     }
     if(error)
	exit();
801049e7:	e8 64 f8 ff ff       	call   80104250 <exit>
801049ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801049f0 <count>:
    return 0;
}
int
count(int num)
{
801049f0:	55                   	push   %ebp
801049f1:	89 e5                	mov    %esp,%ebp
801049f3:	56                   	push   %esi
801049f4:	53                   	push   %ebx
801049f5:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int c=0;
	while(num/10 > 0){
801049f8:	83 f9 09             	cmp    $0x9,%ecx
801049fb:	7e 32                	jle    80104a2f <count+0x3f>
801049fd:	31 db                	xor    %ebx,%ebx
                  num = num / 10;
801049ff:	be 67 66 66 66       	mov    $0x66666667,%esi
80104a04:	eb 0c                	jmp    80104a12 <count+0x22>
80104a06:	8d 76 00             	lea    0x0(%esi),%esi
80104a09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
                  c += 1;
80104a10:	89 c3                	mov    %eax,%ebx
int
count(int num)
{
	int c=0;
	while(num/10 > 0){
                  num = num / 10;
80104a12:	89 c8                	mov    %ecx,%eax
80104a14:	c1 f9 1f             	sar    $0x1f,%ecx
80104a17:	f7 ee                	imul   %esi
                  c += 1;
80104a19:	8d 43 01             	lea    0x1(%ebx),%eax
int
count(int num)
{
	int c=0;
	while(num/10 > 0){
                  num = num / 10;
80104a1c:	c1 fa 02             	sar    $0x2,%edx
80104a1f:	29 ca                	sub    %ecx,%edx
}
int
count(int num)
{
	int c=0;
	while(num/10 > 0){
80104a21:	83 fa 09             	cmp    $0x9,%edx
                  num = num / 10;
80104a24:	89 d1                	mov    %edx,%ecx
}
int
count(int num)
{
	int c=0;
	while(num/10 > 0){
80104a26:	7f e8                	jg     80104a10 <count+0x20>
80104a28:	8d 43 02             	lea    0x2(%ebx),%eax
                  num = num / 10;
                  c += 1;
        }

	return c+1;
}
80104a2b:	5b                   	pop    %ebx
80104a2c:	5e                   	pop    %esi
80104a2d:	5d                   	pop    %ebp
80104a2e:	c3                   	ret    
}
int
count(int num)
{
	int c=0;
	while(num/10 > 0){
80104a2f:	b8 01 00 00 00       	mov    $0x1,%eax
80104a34:	eb f5                	jmp    80104a2b <count+0x3b>
80104a36:	8d 76 00             	lea    0x0(%esi),%esi
80104a39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104a40 <chqueue>:

	return c+1;
}


int chqueue(int pid,int queuenum){
80104a40:	55                   	push   %ebp
80104a41:	89 e5                	mov    %esp,%ebp
80104a43:	53                   	push   %ebx
80104a44:	83 ec 10             	sub    $0x10,%esp
80104a47:	8b 5d 08             	mov    0x8(%ebp),%ebx

  struct proc *p;
	acquire(&ptable.lock);
80104a4a:	68 e0 38 11 80       	push   $0x801138e0
80104a4f:	e8 dc 06 00 00       	call   80105130 <acquire>
80104a54:	83 c4 10             	add    $0x10,%esp
	for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104a57:	b8 14 39 11 80       	mov    $0x80113914,%eax
80104a5c:	eb 0e                	jmp    80104a6c <chqueue+0x2c>
80104a5e:	66 90                	xchg   %ax,%ax
80104a60:	05 94 00 00 00       	add    $0x94,%eax
80104a65:	3d 14 5e 11 80       	cmp    $0x80115e14,%eax
80104a6a:	74 0e                	je     80104a7a <chqueue+0x3a>
      if(p->pid == pid){
80104a6c:	39 58 10             	cmp    %ebx,0x10(%eax)
80104a6f:	75 ef                	jne    80104a60 <chqueue+0x20>
        p->queuenum = queuenum;
80104a71:	8b 55 0c             	mov    0xc(%ebp),%edx
80104a74:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
        break;
	    }
  }
  release(&ptable.lock);
80104a7a:	83 ec 0c             	sub    $0xc,%esp
80104a7d:	68 e0 38 11 80       	push   $0x801138e0
80104a82:	e8 59 07 00 00       	call   801051e0 <release>
  return 0;	

}
80104a87:	31 c0                	xor    %eax,%eax
80104a89:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a8c:	c9                   	leave  
80104a8d:	c3                   	ret    
80104a8e:	66 90                	xchg   %ax,%ax

80104a90 <setLottery>:


int setLottery(int pid,int tickets){
80104a90:	55                   	push   %ebp
80104a91:	89 e5                	mov    %esp,%ebp
80104a93:	53                   	push   %ebx
80104a94:	83 ec 10             	sub    $0x10,%esp
80104a97:	8b 5d 08             	mov    0x8(%ebp),%ebx

  struct proc *p;
	acquire(&ptable.lock);
80104a9a:	68 e0 38 11 80       	push   $0x801138e0
80104a9f:	e8 8c 06 00 00       	call   80105130 <acquire>
80104aa4:	83 c4 10             	add    $0x10,%esp
	for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104aa7:	b8 14 39 11 80       	mov    $0x80113914,%eax
80104aac:	eb 0e                	jmp    80104abc <setLottery+0x2c>
80104aae:	66 90                	xchg   %ax,%ax
80104ab0:	05 94 00 00 00       	add    $0x94,%eax
80104ab5:	3d 14 5e 11 80       	cmp    $0x80115e14,%eax
80104aba:	74 0e                	je     80104aca <setLottery+0x3a>
           if(p->pid == pid){
80104abc:	39 58 10             	cmp    %ebx,0x10(%eax)
80104abf:	75 ef                	jne    80104ab0 <setLottery+0x20>
             p->tickets =tickets;
80104ac1:	8b 55 0c             	mov    0xc(%ebp),%edx
80104ac4:	89 90 84 00 00 00    	mov    %edx,0x84(%eax)
             break;
	   }
    }
  release(&ptable.lock);
80104aca:	83 ec 0c             	sub    $0xc,%esp
80104acd:	68 e0 38 11 80       	push   $0x801138e0
80104ad2:	e8 09 07 00 00       	call   801051e0 <release>

	return 0;

}
80104ad7:	31 c0                	xor    %eax,%eax
80104ad9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104adc:	c9                   	leave  
80104add:	c3                   	ret    
80104ade:	66 90                	xchg   %ax,%ax

80104ae0 <reverse>:

void reverse(char* str, int len) 
{ 
80104ae0:	55                   	push   %ebp
80104ae1:	89 e5                	mov    %esp,%ebp
80104ae3:	56                   	push   %esi
80104ae4:	53                   	push   %ebx
    int i = 0, j = len - 1, temp; 
80104ae5:	8b 45 0c             	mov    0xc(%ebp),%eax
	return 0;

}

void reverse(char* str, int len) 
{ 
80104ae8:	8b 4d 08             	mov    0x8(%ebp),%ecx
    int i = 0, j = len - 1, temp; 
80104aeb:	83 e8 01             	sub    $0x1,%eax
    while (i < j) { 
80104aee:	85 c0                	test   %eax,%eax
80104af0:	7e 20                	jle    80104b12 <reverse+0x32>
80104af2:	31 d2                	xor    %edx,%edx
80104af4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        temp = str[i]; 
80104af8:	0f b6 34 11          	movzbl (%ecx,%edx,1),%esi
        str[i] = str[j]; 
80104afc:	0f b6 1c 01          	movzbl (%ecx,%eax,1),%ebx
80104b00:	88 1c 11             	mov    %bl,(%ecx,%edx,1)
        str[j] = temp; 
80104b03:	89 f3                	mov    %esi,%ebx
        i++; 
80104b05:	83 c2 01             	add    $0x1,%edx
{ 
    int i = 0, j = len - 1, temp; 
    while (i < j) { 
        temp = str[i]; 
        str[i] = str[j]; 
        str[j] = temp; 
80104b08:	88 1c 01             	mov    %bl,(%ecx,%eax,1)
        i++; 
        j--; 
80104b0b:	83 e8 01             	sub    $0x1,%eax
}

void reverse(char* str, int len) 
{ 
    int i = 0, j = len - 1, temp; 
    while (i < j) { 
80104b0e:	39 c2                	cmp    %eax,%edx
80104b10:	7c e6                	jl     80104af8 <reverse+0x18>
        str[i] = str[j]; 
        str[j] = temp; 
        i++; 
        j--; 
    } 
} 
80104b12:	5b                   	pop    %ebx
80104b13:	5e                   	pop    %esi
80104b14:	5d                   	pop    %ebp
80104b15:	c3                   	ret    
80104b16:	8d 76 00             	lea    0x0(%esi),%esi
80104b19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104b20 <intToStr>:
// Converts a given integer x to string str[].  
// d is the number of digits required in the output.  
// If d is more than the number of digits in x,  
// then 0s are added at the beginning. 
int intToStr(int x, char str[], int d) 
{ 
80104b20:	55                   	push   %ebp
80104b21:	89 e5                	mov    %esp,%ebp
80104b23:	57                   	push   %edi
80104b24:	56                   	push   %esi
80104b25:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104b28:	53                   	push   %ebx
    int i = 0; 
    while (x) { 
80104b29:	31 db                	xor    %ebx,%ebx
// Converts a given integer x to string str[].  
// d is the number of digits required in the output.  
// If d is more than the number of digits in x,  
// then 0s are added at the beginning. 
int intToStr(int x, char str[], int d) 
{ 
80104b2b:	8b 75 0c             	mov    0xc(%ebp),%esi
    int i = 0; 
    while (x) { 
80104b2e:	85 c9                	test   %ecx,%ecx
80104b30:	0f 84 81 00 00 00    	je     80104bb7 <intToStr+0x97>
        str[i++] = (x % 10) + '0'; 
80104b36:	bf 67 66 66 66       	mov    $0x66666667,%edi
80104b3b:	90                   	nop
80104b3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104b40:	89 c8                	mov    %ecx,%eax
80104b42:	83 c3 01             	add    $0x1,%ebx
80104b45:	f7 ef                	imul   %edi
80104b47:	89 c8                	mov    %ecx,%eax
80104b49:	c1 f8 1f             	sar    $0x1f,%eax
80104b4c:	c1 fa 02             	sar    $0x2,%edx
80104b4f:	29 c2                	sub    %eax,%edx
80104b51:	8d 04 92             	lea    (%edx,%edx,4),%eax
80104b54:	01 c0                	add    %eax,%eax
80104b56:	29 c1                	sub    %eax,%ecx
80104b58:	83 c1 30             	add    $0x30,%ecx
// If d is more than the number of digits in x,  
// then 0s are added at the beginning. 
int intToStr(int x, char str[], int d) 
{ 
    int i = 0; 
    while (x) { 
80104b5b:	85 d2                	test   %edx,%edx
        str[i++] = (x % 10) + '0'; 
80104b5d:	88 4c 1e ff          	mov    %cl,-0x1(%esi,%ebx,1)
        x = x / 10; 
80104b61:	89 d1                	mov    %edx,%ecx
// If d is more than the number of digits in x,  
// then 0s are added at the beginning. 
int intToStr(int x, char str[], int d) 
{ 
    int i = 0; 
    while (x) { 
80104b63:	75 db                	jne    80104b40 <intToStr+0x20>
        x = x / 10; 
    } 
  
    // If number of digits required is more, then 
    // add 0s at the beginning 
    while (i < d) 
80104b65:	3b 5d 10             	cmp    0x10(%ebp),%ebx
80104b68:	7d 12                	jge    80104b7c <intToStr+0x5c>
80104b6a:	8b 45 10             	mov    0x10(%ebp),%eax
80104b6d:	8d 76 00             	lea    0x0(%esi),%esi
        str[i++] = '0'; 
80104b70:	83 c3 01             	add    $0x1,%ebx
        x = x / 10; 
    } 
  
    // If number of digits required is more, then 
    // add 0s at the beginning 
    while (i < d) 
80104b73:	39 d8                	cmp    %ebx,%eax
        str[i++] = '0'; 
80104b75:	c6 44 1e ff 30       	movb   $0x30,-0x1(%esi,%ebx,1)
        x = x / 10; 
    } 
  
    // If number of digits required is more, then 
    // add 0s at the beginning 
    while (i < d) 
80104b7a:	7f f4                	jg     80104b70 <intToStr+0x50>

}

void reverse(char* str, int len) 
{ 
    int i = 0, j = len - 1, temp; 
80104b7c:	8d 43 ff             	lea    -0x1(%ebx),%eax
    while (i < j) { 
80104b7f:	31 c9                	xor    %ecx,%ecx
80104b81:	85 c0                	test   %eax,%eax
80104b83:	7e 25                	jle    80104baa <intToStr+0x8a>
80104b85:	89 df                	mov    %ebx,%edi
80104b87:	89 f6                	mov    %esi,%esi
80104b89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        temp = str[i]; 
80104b90:	0f b6 1c 0e          	movzbl (%esi,%ecx,1),%ebx
        str[i] = str[j]; 
80104b94:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
80104b98:	88 14 0e             	mov    %dl,(%esi,%ecx,1)
        str[j] = temp; 
80104b9b:	88 1c 06             	mov    %bl,(%esi,%eax,1)
        i++; 
80104b9e:	83 c1 01             	add    $0x1,%ecx
        j--; 
80104ba1:	83 e8 01             	sub    $0x1,%eax
}

void reverse(char* str, int len) 
{ 
    int i = 0, j = len - 1, temp; 
    while (i < j) { 
80104ba4:	39 c1                	cmp    %eax,%ecx
80104ba6:	7c e8                	jl     80104b90 <intToStr+0x70>
80104ba8:	89 fb                	mov    %edi,%ebx
80104baa:	89 d8                	mov    %ebx,%eax
    // add 0s at the beginning 
    while (i < d) 
        str[i++] = '0'; 
  
    reverse(str, i); 
    str[i] = '\0'; 
80104bac:	c6 04 06 00          	movb   $0x0,(%esi,%eax,1)
    return i; 
} 
80104bb0:	89 d8                	mov    %ebx,%eax
80104bb2:	5b                   	pop    %ebx
80104bb3:	5e                   	pop    %esi
80104bb4:	5f                   	pop    %edi
80104bb5:	5d                   	pop    %ebp
80104bb6:	c3                   	ret    
        x = x / 10; 
    } 
  
    // If number of digits required is more, then 
    // add 0s at the beginning 
    while (i < d) 
80104bb7:	8b 45 10             	mov    0x10(%ebp),%eax
80104bba:	85 c0                	test   %eax,%eax
80104bbc:	7f ac                	jg     80104b6a <intToStr+0x4a>
80104bbe:	31 c0                	xor    %eax,%eax
80104bc0:	eb ea                	jmp    80104bac <intToStr+0x8c>
80104bc2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104bd0 <power>:
    str[i] = '\0'; 
    return i; 
} 

int power(int x, unsigned int y) 
{ 
80104bd0:	55                   	push   %ebp
80104bd1:	89 e5                	mov    %esp,%ebp
80104bd3:	57                   	push   %edi
80104bd4:	56                   	push   %esi
80104bd5:	53                   	push   %ebx
    if (y == 0) 
80104bd6:	be 01 00 00 00       	mov    $0x1,%esi
    str[i] = '\0'; 
    return i; 
} 

int power(int x, unsigned int y) 
{ 
80104bdb:	83 ec 0c             	sub    $0xc,%esp
80104bde:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104be1:	8b 7d 08             	mov    0x8(%ebp),%edi
    if (y == 0) 
80104be4:	85 db                	test   %ebx,%ebx
80104be6:	75 1e                	jne    80104c06 <power+0x36>
80104be8:	eb 3a                	jmp    80104c24 <power+0x54>
80104bea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        return 1; 
    else if (y%2 == 0) 
        return power(x, y/2)*power(x, y/2); 
80104bf0:	83 ec 08             	sub    $0x8,%esp
80104bf3:	d1 eb                	shr    %ebx
80104bf5:	53                   	push   %ebx
80104bf6:	57                   	push   %edi
80104bf7:	e8 d4 ff ff ff       	call   80104bd0 <power>
80104bfc:	83 c4 10             	add    $0x10,%esp
80104bff:	0f af f0             	imul   %eax,%esi
    return i; 
} 

int power(int x, unsigned int y) 
{ 
    if (y == 0) 
80104c02:	85 db                	test   %ebx,%ebx
80104c04:	74 1e                	je     80104c24 <power+0x54>
        return 1; 
    else if (y%2 == 0) 
80104c06:	f6 c3 01             	test   $0x1,%bl
80104c09:	74 e5                	je     80104bf0 <power+0x20>
        return power(x, y/2)*power(x, y/2); 
    else
        return x*power(x, y/2)*power(x, y/2); 
80104c0b:	83 ec 08             	sub    $0x8,%esp
80104c0e:	d1 eb                	shr    %ebx
80104c10:	53                   	push   %ebx
80104c11:	57                   	push   %edi
80104c12:	e8 b9 ff ff ff       	call   80104bd0 <power>
80104c17:	0f af c7             	imul   %edi,%eax
80104c1a:	83 c4 10             	add    $0x10,%esp
80104c1d:	0f af f0             	imul   %eax,%esi
    return i; 
} 

int power(int x, unsigned int y) 
{ 
    if (y == 0) 
80104c20:	85 db                	test   %ebx,%ebx
80104c22:	75 e2                	jne    80104c06 <power+0x36>
        return 1; 
    else if (y%2 == 0) 
        return power(x, y/2)*power(x, y/2); 
    else
        return x*power(x, y/2)*power(x, y/2); 
} 
80104c24:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104c27:	89 f0                	mov    %esi,%eax
80104c29:	5b                   	pop    %ebx
80104c2a:	5e                   	pop    %esi
80104c2b:	5f                   	pop    %edi
80104c2c:	5d                   	pop    %ebp
80104c2d:	c3                   	ret    
80104c2e:	66 90                	xchg   %ax,%ax

80104c30 <ftoa>:
  
// Converts a floating-point/double number to a string. 
void ftoa(float n, char* res, int afterpoint) 
{ 
80104c30:	55                   	push   %ebp
80104c31:	89 e5                	mov    %esp,%ebp
80104c33:	57                   	push   %edi
80104c34:	56                   	push   %esi
80104c35:	53                   	push   %ebx
80104c36:	83 ec 2c             	sub    $0x2c,%esp
    // Extract integer part 
    int ipart = (int)n; 
80104c39:	d9 7d e6             	fnstcw -0x1a(%ebp)
80104c3c:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
        return x*power(x, y/2)*power(x, y/2); 
} 
  
// Converts a floating-point/double number to a string. 
void ftoa(float n, char* res, int afterpoint) 
{ 
80104c40:	d9 45 08             	flds   0x8(%ebp)
80104c43:	8b 75 0c             	mov    0xc(%ebp),%esi
80104c46:	8b 7d 10             	mov    0x10(%ebp),%edi
  
    // Extract floating part 
    float fpart = n - (float)ipart; 
  
    // convert integer part to string 
    int i = intToStr(ipart, res, 0); 
80104c49:	6a 00                	push   $0x0
        return x*power(x, y/2)*power(x, y/2); 
} 
  
// Converts a floating-point/double number to a string. 
void ftoa(float n, char* res, int afterpoint) 
{ 
80104c4b:	d9 55 dc             	fsts   -0x24(%ebp)
    // Extract integer part 
    int ipart = (int)n; 
80104c4e:	b4 0c                	mov    $0xc,%ah
  
    // Extract floating part 
    float fpart = n - (float)ipart; 
  
    // convert integer part to string 
    int i = intToStr(ipart, res, 0); 
80104c50:	56                   	push   %esi
  
// Converts a floating-point/double number to a string. 
void ftoa(float n, char* res, int afterpoint) 
{ 
    // Extract integer part 
    int ipart = (int)n; 
80104c51:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
80104c55:	d9 6d e4             	fldcw  -0x1c(%ebp)
80104c58:	db 5d e0             	fistpl -0x20(%ebp)
80104c5b:	d9 6d e6             	fldcw  -0x1a(%ebp)
80104c5e:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  
    // Extract floating part 
    float fpart = n - (float)ipart; 
  
    // convert integer part to string 
    int i = intToStr(ipart, res, 0); 
80104c61:	53                   	push   %ebx
80104c62:	e8 b9 fe ff ff       	call   80104b20 <intToStr>
  
    // check for display option after point 
    if (afterpoint != 0) { 
80104c67:	83 c4 0c             	add    $0xc,%esp
80104c6a:	85 ff                	test   %edi,%edi
80104c6c:	75 12                	jne    80104c80 <ftoa+0x50>
        // is needed to handle cases like 233.007 
        fpart = fpart * power(10, afterpoint); 
  
        intToStr((int)fpart, res + i + 1, afterpoint); 
    } 
} 
80104c6e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104c71:	5b                   	pop    %ebx
80104c72:	5e                   	pop    %esi
80104c73:	5f                   	pop    %edi
80104c74:	5d                   	pop    %ebp
80104c75:	c3                   	ret    
80104c76:	8d 76 00             	lea    0x0(%esi),%esi
80104c79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        res[i] = '.'; // add dot 
  
        // Get the value of fraction part upto given no. 
        // of points after dot. The third parameter  
        // is needed to handle cases like 233.007 
        fpart = fpart * power(10, afterpoint); 
80104c80:	83 ec 08             	sub    $0x8,%esp
    // convert integer part to string 
    int i = intToStr(ipart, res, 0); 
  
    // check for display option after point 
    if (afterpoint != 0) { 
        res[i] = '.'; // add dot 
80104c83:	c6 04 06 2e          	movb   $0x2e,(%esi,%eax,1)
80104c87:	89 c2                	mov    %eax,%edx
  
        // Get the value of fraction part upto given no. 
        // of points after dot. The third parameter  
        // is needed to handle cases like 233.007 
        fpart = fpart * power(10, afterpoint); 
80104c89:	57                   	push   %edi
80104c8a:	6a 0a                	push   $0xa
80104c8c:	e8 3f ff ff ff       	call   80104bd0 <power>
  
        intToStr((int)fpart, res + i + 1, afterpoint); 
80104c91:	d9 7d e6             	fnstcw -0x1a(%ebp)
{ 
    // Extract integer part 
    int ipart = (int)n; 
  
    // Extract floating part 
    float fpart = n - (float)ipart; 
80104c94:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
        res[i] = '.'; // add dot 
  
        // Get the value of fraction part upto given no. 
        // of points after dot. The third parameter  
        // is needed to handle cases like 233.007 
        fpart = fpart * power(10, afterpoint); 
80104c97:	89 45 d8             	mov    %eax,-0x28(%ebp)
  
        intToStr((int)fpart, res + i + 1, afterpoint); 
80104c9a:	8d 44 16 01          	lea    0x1(%esi,%edx,1),%eax
{ 
    // Extract integer part 
    int ipart = (int)n; 
  
    // Extract floating part 
    float fpart = n - (float)ipart; 
80104c9e:	db 45 d4             	fildl  -0x2c(%ebp)
        // Get the value of fraction part upto given no. 
        // of points after dot. The third parameter  
        // is needed to handle cases like 233.007 
        fpart = fpart * power(10, afterpoint); 
  
        intToStr((int)fpart, res + i + 1, afterpoint); 
80104ca1:	89 7d 10             	mov    %edi,0x10(%ebp)
        res[i] = '.'; // add dot 
  
        // Get the value of fraction part upto given no. 
        // of points after dot. The third parameter  
        // is needed to handle cases like 233.007 
        fpart = fpart * power(10, afterpoint); 
80104ca4:	83 c4 10             	add    $0x10,%esp
  
        intToStr((int)fpart, res + i + 1, afterpoint); 
80104ca7:	89 45 0c             	mov    %eax,0xc(%ebp)
80104caa:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
{ 
    // Extract integer part 
    int ipart = (int)n; 
  
    // Extract floating part 
    float fpart = n - (float)ipart; 
80104cae:	d8 6d dc             	fsubrs -0x24(%ebp)
        // Get the value of fraction part upto given no. 
        // of points after dot. The third parameter  
        // is needed to handle cases like 233.007 
        fpart = fpart * power(10, afterpoint); 
  
        intToStr((int)fpart, res + i + 1, afterpoint); 
80104cb1:	b4 0c                	mov    $0xc,%ah
80104cb3:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
80104cb7:	db 45 d8             	fildl  -0x28(%ebp)
80104cba:	de c9                	fmulp  %st,%st(1)
80104cbc:	d9 6d e4             	fldcw  -0x1c(%ebp)
80104cbf:	db 5d 08             	fistpl 0x8(%ebp)
80104cc2:	d9 6d e6             	fldcw  -0x1a(%ebp)
    } 
} 
80104cc5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104cc8:	5b                   	pop    %ebx
80104cc9:	5e                   	pop    %esi
80104cca:	5f                   	pop    %edi
80104ccb:	5d                   	pop    %ebp
        // Get the value of fraction part upto given no. 
        // of points after dot. The third parameter  
        // is needed to handle cases like 233.007 
        fpart = fpart * power(10, afterpoint); 
  
        intToStr((int)fpart, res + i + 1, afterpoint); 
80104ccc:	e9 4f fe ff ff       	jmp    80104b20 <intToStr>
80104cd1:	eb 0d                	jmp    80104ce0 <chprSRPF>
80104cd3:	90                   	nop
80104cd4:	90                   	nop
80104cd5:	90                   	nop
80104cd6:	90                   	nop
80104cd7:	90                   	nop
80104cd8:	90                   	nop
80104cd9:	90                   	nop
80104cda:	90                   	nop
80104cdb:	90                   	nop
80104cdc:	90                   	nop
80104cdd:	90                   	nop
80104cde:	90                   	nop
80104cdf:	90                   	nop

80104ce0 <chprSRPF>:
    } 
} 


int chprSRPF(int pid,int priority){
80104ce0:	55                   	push   %ebp
80104ce1:	89 e5                	mov    %esp,%ebp
80104ce3:	53                   	push   %ebx
80104ce4:	83 ec 10             	sub    $0x10,%esp
80104ce7:	8b 5d 08             	mov    0x8(%ebp),%ebx

  struct proc *p;
	acquire(&ptable.lock);
80104cea:	68 e0 38 11 80       	push   $0x801138e0
80104cef:	e8 3c 04 00 00       	call   80105130 <acquire>
80104cf4:	83 c4 10             	add    $0x10,%esp
	for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104cf7:	b8 14 39 11 80       	mov    $0x80113914,%eax
80104cfc:	eb 0e                	jmp    80104d0c <chprSRPF+0x2c>
80104cfe:	66 90                	xchg   %ax,%ax
80104d00:	05 94 00 00 00       	add    $0x94,%eax
80104d05:	3d 14 5e 11 80       	cmp    $0x80115e14,%eax
80104d0a:	74 0e                	je     80104d1a <chprSRPF+0x3a>
           if(p->pid == pid){
80104d0c:	39 58 10             	cmp    %ebx,0x10(%eax)
80104d0f:	75 ef                	jne    80104d00 <chprSRPF+0x20>
             p->priority = priority;
80104d11:	db 45 0c             	fildl  0xc(%ebp)
80104d14:	d9 98 88 00 00 00    	fstps  0x88(%eax)
             break;
	   }

        }
        release(&ptable.lock);
80104d1a:	83 ec 0c             	sub    $0xc,%esp
80104d1d:	68 e0 38 11 80       	push   $0x801138e0
80104d22:	e8 b9 04 00 00       	call   801051e0 <release>

	return 0;


}
80104d27:	31 c0                	xor    %eax,%eax
80104d29:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104d2c:	c9                   	leave  
80104d2d:	c3                   	ret    
80104d2e:	66 90                	xchg   %ax,%ax

80104d30 <printinfo>:


int printinfo(void){
80104d30:	55                   	push   %ebp
80104d31:	89 e5                	mov    %esp,%ebp
80104d33:	57                   	push   %edi
80104d34:	56                   	push   %esi
80104d35:	53                   	push   %ebx
80104d36:	83 ec 58             	sub    $0x58,%esp
}

static inline void
sti(void)
{
  asm volatile("sti");
80104d39:	fb                   	sti    
	struct proc *p;
	sti();
	cprintf("name \t \t pid \t \t state \t \t priority \t \t createTime \t \t lotteryTicket \t \t executionCycle \t \t HRRN \t \t queueNum\n");
80104d3a:	68 e4 86 10 80       	push   $0x801086e4
80104d3f:	bb 80 39 11 80       	mov    $0x80113980,%ebx
80104d44:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104d47:	8d 75 d4             	lea    -0x2c(%ebp),%esi
80104d4a:	e8 11 b9 ff ff       	call   80100660 <cprintf>
  float currentTime;
  acquire(&tickslock);
80104d4f:	c7 04 24 20 5e 11 80 	movl   $0x80115e20,(%esp)
80104d56:	e8 d5 03 00 00       	call   80105130 <acquire>
  currentTime = ticks;
80104d5b:	a1 60 66 11 80       	mov    0x80116660,%eax
80104d60:	31 d2                	xor    %edx,%edx
  release(&tickslock);
80104d62:	c7 04 24 20 5e 11 80 	movl   $0x80115e20,(%esp)
	struct proc *p;
	sti();
	cprintf("name \t \t pid \t \t state \t \t priority \t \t createTime \t \t lotteryTicket \t \t executionCycle \t \t HRRN \t \t queueNum\n");
  float currentTime;
  acquire(&tickslock);
  currentTime = ticks;
80104d69:	89 55 ac             	mov    %edx,-0x54(%ebp)
80104d6c:	89 45 a8             	mov    %eax,-0x58(%ebp)
80104d6f:	df 6d a8             	fildll -0x58(%ebp)
80104d72:	d9 5d b0             	fstps  -0x50(%ebp)
  release(&tickslock);
80104d75:	e8 66 04 00 00       	call   801051e0 <release>
  acquire(&ptable.lock);
80104d7a:	c7 04 24 e0 38 11 80 	movl   $0x801138e0,(%esp)
80104d81:	e8 aa 03 00 00       	call   80105130 <acquire>
80104d86:	83 c4 10             	add    $0x10,%esp
80104d89:	eb 25                	jmp    80104db0 <printinfo+0x80>
80104d8b:	90                   	nop
80104d8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ftoa((float)((currentTime - p->createTime) / (p->executionCycle)),buffer2, 2);            
   	  if ( p->state == SLEEPING )
                /////////////////////////////////////////hrrn////////////////////////////////////////////
     		  cprintf("%s \t \t %d  \t \t SLEEPING \t \t %s \t \t %d \t \t %d \t \t %d \t \t %s \t \t %d \n", p->name, p->pid, buffer1, p->createTime, p->tickets, p->executionCycle,
          buffer2, p->queuenum);
	    else if ( p->state == RUNNING )
80104d90:	83 f8 04             	cmp    $0x4,%eax
80104d93:	0f 84 a7 00 00 00    	je     80104e40 <printinfo+0x110>
     		  cprintf("%s \t \t %d  \t \t RUNNING \t \t  %s \t \t %d \t \t %d \t \t %d \t \t %s \t \t %d \n", p->name, p->pid, buffer1, p->createTime, p->tickets, p->executionCycle,
          buffer2, p->queuenum);
      
      else if ( p->state == RUNNABLE )
80104d99:	83 f8 03             	cmp    $0x3,%eax
80104d9c:	0f 84 ce 00 00 00    	je     80104e70 <printinfo+0x140>
80104da2:	81 c3 94 00 00 00    	add    $0x94,%ebx
  float currentTime;
  acquire(&tickslock);
  currentTime = ticks;
  release(&tickslock);
  acquire(&ptable.lock);
	for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104da8:	81 fb 80 5e 11 80    	cmp    $0x80115e80,%ebx
80104dae:	74 70                	je     80104e20 <printinfo+0xf0>
      char buffer1[20]; 
      char buffer2[20];
      ftoa(p->priority, buffer1, 2);
80104db0:	83 ec 04             	sub    $0x4,%esp
80104db3:	6a 02                	push   $0x2
80104db5:	57                   	push   %edi
80104db6:	ff 73 1c             	pushl  0x1c(%ebx)
80104db9:	e8 72 fe ff ff       	call   80104c30 <ftoa>
      ftoa((float)((currentTime - p->createTime) / (p->executionCycle)),buffer2, 2);            
80104dbe:	8b 43 20             	mov    0x20(%ebx),%eax
80104dc1:	31 d2                	xor    %edx,%edx
80104dc3:	83 c4 0c             	add    $0xc,%esp
80104dc6:	89 55 ac             	mov    %edx,-0x54(%ebp)
80104dc9:	6a 02                	push   $0x2
80104dcb:	56                   	push   %esi
80104dcc:	89 45 a8             	mov    %eax,-0x58(%ebp)
80104dcf:	df 6d a8             	fildll -0x58(%ebp)
80104dd2:	83 ec 04             	sub    $0x4,%esp
80104dd5:	d8 6d b0             	fsubrs -0x50(%ebp)
80104dd8:	db 43 24             	fildl  0x24(%ebx)
80104ddb:	de f9                	fdivrp %st,%st(1)
80104ddd:	d9 1c 24             	fstps  (%esp)
80104de0:	e8 4b fe ff ff       	call   80104c30 <ftoa>
   	  if ( p->state == SLEEPING )
80104de5:	8b 43 a0             	mov    -0x60(%ebx),%eax
80104de8:	83 c4 10             	add    $0x10,%esp
80104deb:	83 f8 02             	cmp    $0x2,%eax
80104dee:	75 a0                	jne    80104d90 <printinfo+0x60>
                /////////////////////////////////////////hrrn////////////////////////////////////////////
     		  cprintf("%s \t \t %d  \t \t SLEEPING \t \t %s \t \t %d \t \t %d \t \t %d \t \t %s \t \t %d \n", p->name, p->pid, buffer1, p->createTime, p->tickets, p->executionCycle,
80104df0:	83 ec 0c             	sub    $0xc,%esp
80104df3:	ff 73 14             	pushl  0x14(%ebx)
80104df6:	56                   	push   %esi
80104df7:	ff 73 24             	pushl  0x24(%ebx)
80104dfa:	ff 73 18             	pushl  0x18(%ebx)
80104dfd:	ff 73 20             	pushl  0x20(%ebx)
80104e00:	57                   	push   %edi
80104e01:	ff 73 a4             	pushl  -0x5c(%ebx)
80104e04:	53                   	push   %ebx
80104e05:	68 54 87 10 80       	push   $0x80108754
80104e0a:	81 c3 94 00 00 00    	add    $0x94,%ebx
80104e10:	e8 4b b8 ff ff       	call   80100660 <cprintf>
80104e15:	83 c4 30             	add    $0x30,%esp
  float currentTime;
  acquire(&tickslock);
  currentTime = ticks;
  release(&tickslock);
  acquire(&ptable.lock);
	for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104e18:	81 fb 80 5e 11 80    	cmp    $0x80115e80,%ebx
80104e1e:	75 90                	jne    80104db0 <printinfo+0x80>
      else if ( p->state == RUNNABLE )
     		  cprintf("%s \t \t %d  \t \t RUNNABLE \t \t  %s \t \t %d \t \t %d \t \t %d \t \t %s \t \t %d \n", p->name, p->pid, buffer1, p->createTime, p->tickets, p->executionCycle,
          buffer2, p->queuenum);
  }

  release(&ptable.lock);
80104e20:	83 ec 0c             	sub    $0xc,%esp
80104e23:	68 e0 38 11 80       	push   $0x801138e0
80104e28:	e8 b3 03 00 00       	call   801051e0 <release>

	return 0;

}
80104e2d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104e30:	31 c0                	xor    %eax,%eax
80104e32:	5b                   	pop    %ebx
80104e33:	5e                   	pop    %esi
80104e34:	5f                   	pop    %edi
80104e35:	5d                   	pop    %ebp
80104e36:	c3                   	ret    
80104e37:	89 f6                	mov    %esi,%esi
80104e39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
   	  if ( p->state == SLEEPING )
                /////////////////////////////////////////hrrn////////////////////////////////////////////
     		  cprintf("%s \t \t %d  \t \t SLEEPING \t \t %s \t \t %d \t \t %d \t \t %d \t \t %s \t \t %d \n", p->name, p->pid, buffer1, p->createTime, p->tickets, p->executionCycle,
          buffer2, p->queuenum);
	    else if ( p->state == RUNNING )
     		  cprintf("%s \t \t %d  \t \t RUNNING \t \t  %s \t \t %d \t \t %d \t \t %d \t \t %s \t \t %d \n", p->name, p->pid, buffer1, p->createTime, p->tickets, p->executionCycle,
80104e40:	83 ec 0c             	sub    $0xc,%esp
80104e43:	ff 73 14             	pushl  0x14(%ebx)
80104e46:	56                   	push   %esi
80104e47:	ff 73 24             	pushl  0x24(%ebx)
80104e4a:	ff 73 18             	pushl  0x18(%ebx)
80104e4d:	ff 73 20             	pushl  0x20(%ebx)
80104e50:	57                   	push   %edi
80104e51:	ff 73 a4             	pushl  -0x5c(%ebx)
80104e54:	53                   	push   %ebx
80104e55:	68 98 87 10 80       	push   $0x80108798
80104e5a:	e8 01 b8 ff ff       	call   80100660 <cprintf>
80104e5f:	83 c4 30             	add    $0x30,%esp
80104e62:	e9 3b ff ff ff       	jmp    80104da2 <printinfo+0x72>
80104e67:	89 f6                	mov    %esi,%esi
80104e69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
          buffer2, p->queuenum);
      
      else if ( p->state == RUNNABLE )
     		  cprintf("%s \t \t %d  \t \t RUNNABLE \t \t  %s \t \t %d \t \t %d \t \t %d \t \t %s \t \t %d \n", p->name, p->pid, buffer1, p->createTime, p->tickets, p->executionCycle,
80104e70:	83 ec 0c             	sub    $0xc,%esp
80104e73:	ff 73 14             	pushl  0x14(%ebx)
80104e76:	56                   	push   %esi
80104e77:	ff 73 24             	pushl  0x24(%ebx)
80104e7a:	ff 73 18             	pushl  0x18(%ebx)
80104e7d:	ff 73 20             	pushl  0x20(%ebx)
80104e80:	57                   	push   %edi
80104e81:	ff 73 a4             	pushl  -0x5c(%ebx)
80104e84:	53                   	push   %ebx
80104e85:	68 dc 87 10 80       	push   $0x801087dc
80104e8a:	e8 d1 b7 ff ff       	call   80100660 <cprintf>
80104e8f:	83 c4 30             	add    $0x30,%esp
80104e92:	e9 0b ff ff ff       	jmp    80104da2 <printinfo+0x72>
80104e97:	66 90                	xchg   %ax,%ax
80104e99:	66 90                	xchg   %ax,%ax
80104e9b:	66 90                	xchg   %ax,%ax
80104e9d:	66 90                	xchg   %ax,%ax
80104e9f:	90                   	nop

80104ea0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104ea0:	55                   	push   %ebp
80104ea1:	89 e5                	mov    %esp,%ebp
80104ea3:	53                   	push   %ebx
80104ea4:	83 ec 0c             	sub    $0xc,%esp
80104ea7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80104eaa:	68 48 88 10 80       	push   $0x80108848
80104eaf:	8d 43 04             	lea    0x4(%ebx),%eax
80104eb2:	50                   	push   %eax
80104eb3:	e8 18 01 00 00       	call   80104fd0 <initlock>
  lk->name = name;
80104eb8:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80104ebb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104ec1:	83 c4 10             	add    $0x10,%esp
initsleeplock(struct sleeplock *lk, char *name)
{
  initlock(&lk->lk, "sleep lock");
  lk->name = name;
  lk->locked = 0;
  lk->pid = 0;
80104ec4:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)

void
initsleeplock(struct sleeplock *lk, char *name)
{
  initlock(&lk->lk, "sleep lock");
  lk->name = name;
80104ecb:	89 43 38             	mov    %eax,0x38(%ebx)
  lk->locked = 0;
  lk->pid = 0;
}
80104ece:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ed1:	c9                   	leave  
80104ed2:	c3                   	ret    
80104ed3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104ed9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ee0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104ee0:	55                   	push   %ebp
80104ee1:	89 e5                	mov    %esp,%ebp
80104ee3:	56                   	push   %esi
80104ee4:	53                   	push   %ebx
80104ee5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104ee8:	83 ec 0c             	sub    $0xc,%esp
80104eeb:	8d 73 04             	lea    0x4(%ebx),%esi
80104eee:	56                   	push   %esi
80104eef:	e8 3c 02 00 00       	call   80105130 <acquire>
  while (lk->locked) {
80104ef4:	8b 13                	mov    (%ebx),%edx
80104ef6:	83 c4 10             	add    $0x10,%esp
80104ef9:	85 d2                	test   %edx,%edx
80104efb:	74 16                	je     80104f13 <acquiresleep+0x33>
80104efd:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104f00:	83 ec 08             	sub    $0x8,%esp
80104f03:	56                   	push   %esi
80104f04:	53                   	push   %ebx
80104f05:	e8 c6 f4 ff ff       	call   801043d0 <sleep>

void
acquiresleep(struct sleeplock *lk)
{
  acquire(&lk->lk);
  while (lk->locked) {
80104f0a:	8b 03                	mov    (%ebx),%eax
80104f0c:	83 c4 10             	add    $0x10,%esp
80104f0f:	85 c0                	test   %eax,%eax
80104f11:	75 ed                	jne    80104f00 <acquiresleep+0x20>
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
80104f13:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104f19:	e8 12 eb ff ff       	call   80103a30 <myproc>
80104f1e:	8b 40 10             	mov    0x10(%eax),%eax
80104f21:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104f24:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104f27:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f2a:	5b                   	pop    %ebx
80104f2b:	5e                   	pop    %esi
80104f2c:	5d                   	pop    %ebp
  while (lk->locked) {
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
  lk->pid = myproc()->pid;
  release(&lk->lk);
80104f2d:	e9 ae 02 00 00       	jmp    801051e0 <release>
80104f32:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104f40 <releasesleep>:
}

void
releasesleep(struct sleeplock *lk)
{
80104f40:	55                   	push   %ebp
80104f41:	89 e5                	mov    %esp,%ebp
80104f43:	56                   	push   %esi
80104f44:	53                   	push   %ebx
80104f45:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104f48:	83 ec 0c             	sub    $0xc,%esp
80104f4b:	8d 73 04             	lea    0x4(%ebx),%esi
80104f4e:	56                   	push   %esi
80104f4f:	e8 dc 01 00 00       	call   80105130 <acquire>
  lk->locked = 0;
80104f54:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104f5a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104f61:	89 1c 24             	mov    %ebx,(%esp)
80104f64:	e8 27 f6 ff ff       	call   80104590 <wakeup>
  release(&lk->lk);
80104f69:	89 75 08             	mov    %esi,0x8(%ebp)
80104f6c:	83 c4 10             	add    $0x10,%esp
}
80104f6f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f72:	5b                   	pop    %ebx
80104f73:	5e                   	pop    %esi
80104f74:	5d                   	pop    %ebp
{
  acquire(&lk->lk);
  lk->locked = 0;
  lk->pid = 0;
  wakeup(lk);
  release(&lk->lk);
80104f75:	e9 66 02 00 00       	jmp    801051e0 <release>
80104f7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104f80 <holdingsleep>:
}

int
holdingsleep(struct sleeplock *lk)
{
80104f80:	55                   	push   %ebp
80104f81:	89 e5                	mov    %esp,%ebp
80104f83:	57                   	push   %edi
80104f84:	56                   	push   %esi
80104f85:	53                   	push   %ebx
80104f86:	31 ff                	xor    %edi,%edi
80104f88:	83 ec 18             	sub    $0x18,%esp
80104f8b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80104f8e:	8d 73 04             	lea    0x4(%ebx),%esi
80104f91:	56                   	push   %esi
80104f92:	e8 99 01 00 00       	call   80105130 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104f97:	8b 03                	mov    (%ebx),%eax
80104f99:	83 c4 10             	add    $0x10,%esp
80104f9c:	85 c0                	test   %eax,%eax
80104f9e:	74 13                	je     80104fb3 <holdingsleep+0x33>
80104fa0:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104fa3:	e8 88 ea ff ff       	call   80103a30 <myproc>
80104fa8:	39 58 10             	cmp    %ebx,0x10(%eax)
80104fab:	0f 94 c0             	sete   %al
80104fae:	0f b6 c0             	movzbl %al,%eax
80104fb1:	89 c7                	mov    %eax,%edi
  release(&lk->lk);
80104fb3:	83 ec 0c             	sub    $0xc,%esp
80104fb6:	56                   	push   %esi
80104fb7:	e8 24 02 00 00       	call   801051e0 <release>
  return r;
}
80104fbc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104fbf:	89 f8                	mov    %edi,%eax
80104fc1:	5b                   	pop    %ebx
80104fc2:	5e                   	pop    %esi
80104fc3:	5f                   	pop    %edi
80104fc4:	5d                   	pop    %ebp
80104fc5:	c3                   	ret    
80104fc6:	66 90                	xchg   %ax,%ax
80104fc8:	66 90                	xchg   %ax,%ax
80104fca:	66 90                	xchg   %ax,%ax
80104fcc:	66 90                	xchg   %ax,%ax
80104fce:	66 90                	xchg   %ax,%ax

80104fd0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104fd0:	55                   	push   %ebp
80104fd1:	89 e5                	mov    %esp,%ebp
80104fd3:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104fd6:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104fd9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
  lk->name = name;
80104fdf:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
  lk->cpu = 0;
80104fe2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104fe9:	5d                   	pop    %ebp
80104fea:	c3                   	ret    
80104feb:	90                   	nop
80104fec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104ff0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104ff0:	55                   	push   %ebp
80104ff1:	89 e5                	mov    %esp,%ebp
80104ff3:	53                   	push   %ebx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104ff4:	8b 45 08             	mov    0x8(%ebp),%eax
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104ff7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104ffa:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
80104ffd:	31 c0                	xor    %eax,%eax
80104fff:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105000:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80105006:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010500c:	77 1a                	ja     80105028 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010500e:	8b 5a 04             	mov    0x4(%edx),%ebx
80105011:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80105014:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
80105017:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80105019:	83 f8 0a             	cmp    $0xa,%eax
8010501c:	75 e2                	jne    80105000 <getcallerpcs+0x10>
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010501e:	5b                   	pop    %ebx
8010501f:	5d                   	pop    %ebp
80105020:	c3                   	ret    
80105021:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
80105028:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
8010502f:	83 c0 01             	add    $0x1,%eax
80105032:	83 f8 0a             	cmp    $0xa,%eax
80105035:	74 e7                	je     8010501e <getcallerpcs+0x2e>
    pcs[i] = 0;
80105037:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
8010503e:	83 c0 01             	add    $0x1,%eax
80105041:	83 f8 0a             	cmp    $0xa,%eax
80105044:	75 e2                	jne    80105028 <getcallerpcs+0x38>
80105046:	eb d6                	jmp    8010501e <getcallerpcs+0x2e>
80105048:	90                   	nop
80105049:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105050 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80105050:	55                   	push   %ebp
80105051:	89 e5                	mov    %esp,%ebp
80105053:	53                   	push   %ebx
80105054:	83 ec 04             	sub    $0x4,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80105057:	9c                   	pushf  
80105058:	5b                   	pop    %ebx
}

static inline void
cli(void)
{
  asm volatile("cli");
80105059:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010505a:	e8 61 e9 ff ff       	call   801039c0 <mycpu>
8010505f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80105065:	85 c0                	test   %eax,%eax
80105067:	75 11                	jne    8010507a <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80105069:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010506f:	e8 4c e9 ff ff       	call   801039c0 <mycpu>
80105074:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
8010507a:	e8 41 e9 ff ff       	call   801039c0 <mycpu>
8010507f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80105086:	83 c4 04             	add    $0x4,%esp
80105089:	5b                   	pop    %ebx
8010508a:	5d                   	pop    %ebp
8010508b:	c3                   	ret    
8010508c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105090 <popcli>:

void
popcli(void)
{
80105090:	55                   	push   %ebp
80105091:	89 e5                	mov    %esp,%ebp
80105093:	83 ec 08             	sub    $0x8,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80105096:	9c                   	pushf  
80105097:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80105098:	f6 c4 02             	test   $0x2,%ah
8010509b:	75 52                	jne    801050ef <popcli+0x5f>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010509d:	e8 1e e9 ff ff       	call   801039c0 <mycpu>
801050a2:	8b 88 a4 00 00 00    	mov    0xa4(%eax),%ecx
801050a8:	8d 51 ff             	lea    -0x1(%ecx),%edx
801050ab:	85 d2                	test   %edx,%edx
801050ad:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
801050b3:	78 2d                	js     801050e2 <popcli+0x52>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801050b5:	e8 06 e9 ff ff       	call   801039c0 <mycpu>
801050ba:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801050c0:	85 d2                	test   %edx,%edx
801050c2:	74 0c                	je     801050d0 <popcli+0x40>
    sti();
}
801050c4:	c9                   	leave  
801050c5:	c3                   	ret    
801050c6:	8d 76 00             	lea    0x0(%esi),%esi
801050c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801050d0:	e8 eb e8 ff ff       	call   801039c0 <mycpu>
801050d5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801050db:	85 c0                	test   %eax,%eax
801050dd:	74 e5                	je     801050c4 <popcli+0x34>
}

static inline void
sti(void)
{
  asm volatile("sti");
801050df:	fb                   	sti    
    sti();
}
801050e0:	c9                   	leave  
801050e1:	c3                   	ret    
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
    panic("popcli");
801050e2:	83 ec 0c             	sub    $0xc,%esp
801050e5:	68 6a 88 10 80       	push   $0x8010886a
801050ea:	e8 81 b2 ff ff       	call   80100370 <panic>

void
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
801050ef:	83 ec 0c             	sub    $0xc,%esp
801050f2:	68 53 88 10 80       	push   $0x80108853
801050f7:	e8 74 b2 ff ff       	call   80100370 <panic>
801050fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105100 <holding>:
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80105100:	55                   	push   %ebp
80105101:	89 e5                	mov    %esp,%ebp
80105103:	56                   	push   %esi
80105104:	53                   	push   %ebx
80105105:	8b 75 08             	mov    0x8(%ebp),%esi
80105108:	31 db                	xor    %ebx,%ebx
  int r;
  pushcli();
8010510a:	e8 41 ff ff ff       	call   80105050 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010510f:	8b 06                	mov    (%esi),%eax
80105111:	85 c0                	test   %eax,%eax
80105113:	74 10                	je     80105125 <holding+0x25>
80105115:	8b 5e 08             	mov    0x8(%esi),%ebx
80105118:	e8 a3 e8 ff ff       	call   801039c0 <mycpu>
8010511d:	39 c3                	cmp    %eax,%ebx
8010511f:	0f 94 c3             	sete   %bl
80105122:	0f b6 db             	movzbl %bl,%ebx
  popcli();
80105125:	e8 66 ff ff ff       	call   80105090 <popcli>
  return r;
}
8010512a:	89 d8                	mov    %ebx,%eax
8010512c:	5b                   	pop    %ebx
8010512d:	5e                   	pop    %esi
8010512e:	5d                   	pop    %ebp
8010512f:	c3                   	ret    

80105130 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80105130:	55                   	push   %ebp
80105131:	89 e5                	mov    %esp,%ebp
80105133:	53                   	push   %ebx
80105134:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80105137:	e8 14 ff ff ff       	call   80105050 <pushcli>
  if(holding(lk))
8010513c:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010513f:	83 ec 0c             	sub    $0xc,%esp
80105142:	53                   	push   %ebx
80105143:	e8 b8 ff ff ff       	call   80105100 <holding>
80105148:	83 c4 10             	add    $0x10,%esp
8010514b:	85 c0                	test   %eax,%eax
8010514d:	0f 85 7d 00 00 00    	jne    801051d0 <acquire+0xa0>
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80105153:	ba 01 00 00 00       	mov    $0x1,%edx
80105158:	eb 09                	jmp    80105163 <acquire+0x33>
8010515a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105160:	8b 5d 08             	mov    0x8(%ebp),%ebx
80105163:	89 d0                	mov    %edx,%eax
80105165:	f0 87 03             	lock xchg %eax,(%ebx)
    panic("acquire");

  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
80105168:	85 c0                	test   %eax,%eax
8010516a:	75 f4                	jne    80105160 <acquire+0x30>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
8010516c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
80105171:	8b 5d 08             	mov    0x8(%ebp),%ebx
80105174:	e8 47 e8 ff ff       	call   801039c0 <mycpu>
getcallerpcs(void *v, uint pcs[])
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80105179:	89 ea                	mov    %ebp,%edx
  // references happen after the lock is acquired.
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
  getcallerpcs(&lk, lk->pcs);
8010517b:	8d 4b 0c             	lea    0xc(%ebx),%ecx
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
8010517e:	89 43 08             	mov    %eax,0x8(%ebx)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80105181:	31 c0                	xor    %eax,%eax
80105183:	90                   	nop
80105184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105188:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
8010518e:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80105194:	77 1a                	ja     801051b0 <acquire+0x80>
      break;
    pcs[i] = ebp[1];     // saved %eip
80105196:	8b 5a 04             	mov    0x4(%edx),%ebx
80105199:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
8010519c:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
8010519f:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801051a1:	83 f8 0a             	cmp    $0xa,%eax
801051a4:	75 e2                	jne    80105188 <acquire+0x58>
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
  getcallerpcs(&lk, lk->pcs);
}
801051a6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801051a9:	c9                   	leave  
801051aa:	c3                   	ret    
801051ab:	90                   	nop
801051ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
801051b0:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801051b7:	83 c0 01             	add    $0x1,%eax
801051ba:	83 f8 0a             	cmp    $0xa,%eax
801051bd:	74 e7                	je     801051a6 <acquire+0x76>
    pcs[i] = 0;
801051bf:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801051c6:	83 c0 01             	add    $0x1,%eax
801051c9:	83 f8 0a             	cmp    $0xa,%eax
801051cc:	75 e2                	jne    801051b0 <acquire+0x80>
801051ce:	eb d6                	jmp    801051a6 <acquire+0x76>
void
acquire(struct spinlock *lk)
{
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
    panic("acquire");
801051d0:	83 ec 0c             	sub    $0xc,%esp
801051d3:	68 71 88 10 80       	push   $0x80108871
801051d8:	e8 93 b1 ff ff       	call   80100370 <panic>
801051dd:	8d 76 00             	lea    0x0(%esi),%esi

801051e0 <release>:
}

// Release the lock.
void
release(struct spinlock *lk)
{
801051e0:	55                   	push   %ebp
801051e1:	89 e5                	mov    %esp,%ebp
801051e3:	53                   	push   %ebx
801051e4:	83 ec 10             	sub    $0x10,%esp
801051e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
801051ea:	53                   	push   %ebx
801051eb:	e8 10 ff ff ff       	call   80105100 <holding>
801051f0:	83 c4 10             	add    $0x10,%esp
801051f3:	85 c0                	test   %eax,%eax
801051f5:	74 22                	je     80105219 <release+0x39>
    panic("release");

  lk->pcs[0] = 0;
801051f7:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
801051fe:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that all the stores in the critical
  // section are visible to other cores before the lock is released.
  // Both the C compiler and the hardware may re-order loads and
  // stores; __sync_synchronize() tells them both not to.
  __sync_synchronize();
80105205:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010520a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)

  popcli();
}
80105210:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105213:	c9                   	leave  
  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );

  popcli();
80105214:	e9 77 fe ff ff       	jmp    80105090 <popcli>
// Release the lock.
void
release(struct spinlock *lk)
{
  if(!holding(lk))
    panic("release");
80105219:	83 ec 0c             	sub    $0xc,%esp
8010521c:	68 79 88 10 80       	push   $0x80108879
80105221:	e8 4a b1 ff ff       	call   80100370 <panic>
80105226:	66 90                	xchg   %ax,%ax
80105228:	66 90                	xchg   %ax,%ax
8010522a:	66 90                	xchg   %ax,%ax
8010522c:	66 90                	xchg   %ax,%ax
8010522e:	66 90                	xchg   %ax,%ax

80105230 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80105230:	55                   	push   %ebp
80105231:	89 e5                	mov    %esp,%ebp
80105233:	57                   	push   %edi
80105234:	53                   	push   %ebx
80105235:	8b 55 08             	mov    0x8(%ebp),%edx
80105238:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
8010523b:	f6 c2 03             	test   $0x3,%dl
8010523e:	75 05                	jne    80105245 <memset+0x15>
80105240:	f6 c1 03             	test   $0x3,%cl
80105243:	74 13                	je     80105258 <memset+0x28>
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
80105245:	89 d7                	mov    %edx,%edi
80105247:	8b 45 0c             	mov    0xc(%ebp),%eax
8010524a:	fc                   	cld    
8010524b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
8010524d:	5b                   	pop    %ebx
8010524e:	89 d0                	mov    %edx,%eax
80105250:	5f                   	pop    %edi
80105251:	5d                   	pop    %ebp
80105252:	c3                   	ret    
80105253:	90                   	nop
80105254:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

void*
memset(void *dst, int c, uint n)
{
  if ((int)dst%4 == 0 && n%4 == 0){
    c &= 0xFF;
80105258:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
}

static inline void
stosl(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosl" :
8010525c:	c1 e9 02             	shr    $0x2,%ecx
8010525f:	89 fb                	mov    %edi,%ebx
80105261:	89 f8                	mov    %edi,%eax
80105263:	c1 e3 18             	shl    $0x18,%ebx
80105266:	c1 e0 10             	shl    $0x10,%eax
80105269:	09 d8                	or     %ebx,%eax
8010526b:	09 f8                	or     %edi,%eax
8010526d:	c1 e7 08             	shl    $0x8,%edi
80105270:	09 f8                	or     %edi,%eax
80105272:	89 d7                	mov    %edx,%edi
80105274:	fc                   	cld    
80105275:	f3 ab                	rep stos %eax,%es:(%edi)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
80105277:	5b                   	pop    %ebx
80105278:	89 d0                	mov    %edx,%eax
8010527a:	5f                   	pop    %edi
8010527b:	5d                   	pop    %ebp
8010527c:	c3                   	ret    
8010527d:	8d 76 00             	lea    0x0(%esi),%esi

80105280 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80105280:	55                   	push   %ebp
80105281:	89 e5                	mov    %esp,%ebp
80105283:	57                   	push   %edi
80105284:	56                   	push   %esi
80105285:	8b 45 10             	mov    0x10(%ebp),%eax
80105288:	53                   	push   %ebx
80105289:	8b 75 0c             	mov    0xc(%ebp),%esi
8010528c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010528f:	85 c0                	test   %eax,%eax
80105291:	74 29                	je     801052bc <memcmp+0x3c>
    if(*s1 != *s2)
80105293:	0f b6 13             	movzbl (%ebx),%edx
80105296:	0f b6 0e             	movzbl (%esi),%ecx
80105299:	38 d1                	cmp    %dl,%cl
8010529b:	75 2b                	jne    801052c8 <memcmp+0x48>
8010529d:	8d 78 ff             	lea    -0x1(%eax),%edi
801052a0:	31 c0                	xor    %eax,%eax
801052a2:	eb 14                	jmp    801052b8 <memcmp+0x38>
801052a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801052a8:	0f b6 54 03 01       	movzbl 0x1(%ebx,%eax,1),%edx
801052ad:	83 c0 01             	add    $0x1,%eax
801052b0:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
801052b4:	38 ca                	cmp    %cl,%dl
801052b6:	75 10                	jne    801052c8 <memcmp+0x48>
{
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801052b8:	39 f8                	cmp    %edi,%eax
801052ba:	75 ec                	jne    801052a8 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
801052bc:	5b                   	pop    %ebx
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
801052bd:	31 c0                	xor    %eax,%eax
}
801052bf:	5e                   	pop    %esi
801052c0:	5f                   	pop    %edi
801052c1:	5d                   	pop    %ebp
801052c2:	c3                   	ret    
801052c3:	90                   	nop
801052c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
801052c8:	0f b6 c2             	movzbl %dl,%eax
    s1++, s2++;
  }

  return 0;
}
801052cb:	5b                   	pop    %ebx

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
801052cc:	29 c8                	sub    %ecx,%eax
    s1++, s2++;
  }

  return 0;
}
801052ce:	5e                   	pop    %esi
801052cf:	5f                   	pop    %edi
801052d0:	5d                   	pop    %ebp
801052d1:	c3                   	ret    
801052d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801052d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801052e0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801052e0:	55                   	push   %ebp
801052e1:	89 e5                	mov    %esp,%ebp
801052e3:	56                   	push   %esi
801052e4:	53                   	push   %ebx
801052e5:	8b 45 08             	mov    0x8(%ebp),%eax
801052e8:	8b 75 0c             	mov    0xc(%ebp),%esi
801052eb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801052ee:	39 c6                	cmp    %eax,%esi
801052f0:	73 2e                	jae    80105320 <memmove+0x40>
801052f2:	8d 0c 1e             	lea    (%esi,%ebx,1),%ecx
801052f5:	39 c8                	cmp    %ecx,%eax
801052f7:	73 27                	jae    80105320 <memmove+0x40>
    s += n;
    d += n;
    while(n-- > 0)
801052f9:	85 db                	test   %ebx,%ebx
801052fb:	8d 53 ff             	lea    -0x1(%ebx),%edx
801052fe:	74 17                	je     80105317 <memmove+0x37>
      *--d = *--s;
80105300:	29 d9                	sub    %ebx,%ecx
80105302:	89 cb                	mov    %ecx,%ebx
80105304:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105308:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
8010530c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
8010530f:	83 ea 01             	sub    $0x1,%edx
80105312:	83 fa ff             	cmp    $0xffffffff,%edx
80105315:	75 f1                	jne    80105308 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80105317:	5b                   	pop    %ebx
80105318:	5e                   	pop    %esi
80105319:	5d                   	pop    %ebp
8010531a:	c3                   	ret    
8010531b:	90                   	nop
8010531c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80105320:	31 d2                	xor    %edx,%edx
80105322:	85 db                	test   %ebx,%ebx
80105324:	74 f1                	je     80105317 <memmove+0x37>
80105326:	8d 76 00             	lea    0x0(%esi),%esi
80105329:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      *d++ = *s++;
80105330:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80105334:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80105337:	83 c2 01             	add    $0x1,%edx
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
8010533a:	39 d3                	cmp    %edx,%ebx
8010533c:	75 f2                	jne    80105330 <memmove+0x50>
      *d++ = *s++;

  return dst;
}
8010533e:	5b                   	pop    %ebx
8010533f:	5e                   	pop    %esi
80105340:	5d                   	pop    %ebp
80105341:	c3                   	ret    
80105342:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105349:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105350 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80105350:	55                   	push   %ebp
80105351:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80105353:	5d                   	pop    %ebp

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80105354:	eb 8a                	jmp    801052e0 <memmove>
80105356:	8d 76 00             	lea    0x0(%esi),%esi
80105359:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105360 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80105360:	55                   	push   %ebp
80105361:	89 e5                	mov    %esp,%ebp
80105363:	57                   	push   %edi
80105364:	56                   	push   %esi
80105365:	8b 4d 10             	mov    0x10(%ebp),%ecx
80105368:	53                   	push   %ebx
80105369:	8b 7d 08             	mov    0x8(%ebp),%edi
8010536c:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
8010536f:	85 c9                	test   %ecx,%ecx
80105371:	74 37                	je     801053aa <strncmp+0x4a>
80105373:	0f b6 17             	movzbl (%edi),%edx
80105376:	0f b6 1e             	movzbl (%esi),%ebx
80105379:	84 d2                	test   %dl,%dl
8010537b:	74 3f                	je     801053bc <strncmp+0x5c>
8010537d:	38 d3                	cmp    %dl,%bl
8010537f:	75 3b                	jne    801053bc <strncmp+0x5c>
80105381:	8d 47 01             	lea    0x1(%edi),%eax
80105384:	01 cf                	add    %ecx,%edi
80105386:	eb 1b                	jmp    801053a3 <strncmp+0x43>
80105388:	90                   	nop
80105389:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105390:	0f b6 10             	movzbl (%eax),%edx
80105393:	84 d2                	test   %dl,%dl
80105395:	74 21                	je     801053b8 <strncmp+0x58>
80105397:	0f b6 19             	movzbl (%ecx),%ebx
8010539a:	83 c0 01             	add    $0x1,%eax
8010539d:	89 ce                	mov    %ecx,%esi
8010539f:	38 da                	cmp    %bl,%dl
801053a1:	75 19                	jne    801053bc <strncmp+0x5c>
801053a3:	39 c7                	cmp    %eax,%edi
    n--, p++, q++;
801053a5:	8d 4e 01             	lea    0x1(%esi),%ecx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
801053a8:	75 e6                	jne    80105390 <strncmp+0x30>
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
801053aa:	5b                   	pop    %ebx
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
801053ab:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}
801053ad:	5e                   	pop    %esi
801053ae:	5f                   	pop    %edi
801053af:	5d                   	pop    %ebp
801053b0:	c3                   	ret    
801053b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801053b8:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
801053bc:	0f b6 c2             	movzbl %dl,%eax
801053bf:	29 d8                	sub    %ebx,%eax
}
801053c1:	5b                   	pop    %ebx
801053c2:	5e                   	pop    %esi
801053c3:	5f                   	pop    %edi
801053c4:	5d                   	pop    %ebp
801053c5:	c3                   	ret    
801053c6:	8d 76 00             	lea    0x0(%esi),%esi
801053c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801053d0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801053d0:	55                   	push   %ebp
801053d1:	89 e5                	mov    %esp,%ebp
801053d3:	56                   	push   %esi
801053d4:	53                   	push   %ebx
801053d5:	8b 45 08             	mov    0x8(%ebp),%eax
801053d8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801053db:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
801053de:	89 c2                	mov    %eax,%edx
801053e0:	eb 19                	jmp    801053fb <strncpy+0x2b>
801053e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801053e8:	83 c3 01             	add    $0x1,%ebx
801053eb:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
801053ef:	83 c2 01             	add    $0x1,%edx
801053f2:	84 c9                	test   %cl,%cl
801053f4:	88 4a ff             	mov    %cl,-0x1(%edx)
801053f7:	74 09                	je     80105402 <strncpy+0x32>
801053f9:	89 f1                	mov    %esi,%ecx
801053fb:	85 c9                	test   %ecx,%ecx
801053fd:	8d 71 ff             	lea    -0x1(%ecx),%esi
80105400:	7f e6                	jg     801053e8 <strncpy+0x18>
    ;
  while(n-- > 0)
80105402:	31 c9                	xor    %ecx,%ecx
80105404:	85 f6                	test   %esi,%esi
80105406:	7e 17                	jle    8010541f <strncpy+0x4f>
80105408:	90                   	nop
80105409:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80105410:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80105414:	89 f3                	mov    %esi,%ebx
80105416:	83 c1 01             	add    $0x1,%ecx
80105419:	29 cb                	sub    %ecx,%ebx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
8010541b:	85 db                	test   %ebx,%ebx
8010541d:	7f f1                	jg     80105410 <strncpy+0x40>
    *s++ = 0;
  return os;
}
8010541f:	5b                   	pop    %ebx
80105420:	5e                   	pop    %esi
80105421:	5d                   	pop    %ebp
80105422:	c3                   	ret    
80105423:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105429:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105430 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105430:	55                   	push   %ebp
80105431:	89 e5                	mov    %esp,%ebp
80105433:	56                   	push   %esi
80105434:	53                   	push   %ebx
80105435:	8b 4d 10             	mov    0x10(%ebp),%ecx
80105438:	8b 45 08             	mov    0x8(%ebp),%eax
8010543b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
8010543e:	85 c9                	test   %ecx,%ecx
80105440:	7e 26                	jle    80105468 <safestrcpy+0x38>
80105442:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80105446:	89 c1                	mov    %eax,%ecx
80105448:	eb 17                	jmp    80105461 <safestrcpy+0x31>
8010544a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80105450:	83 c2 01             	add    $0x1,%edx
80105453:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80105457:	83 c1 01             	add    $0x1,%ecx
8010545a:	84 db                	test   %bl,%bl
8010545c:	88 59 ff             	mov    %bl,-0x1(%ecx)
8010545f:	74 04                	je     80105465 <safestrcpy+0x35>
80105461:	39 f2                	cmp    %esi,%edx
80105463:	75 eb                	jne    80105450 <safestrcpy+0x20>
    ;
  *s = 0;
80105465:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80105468:	5b                   	pop    %ebx
80105469:	5e                   	pop    %esi
8010546a:	5d                   	pop    %ebp
8010546b:	c3                   	ret    
8010546c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105470 <strlen>:

int
strlen(const char *s)
{
80105470:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80105471:	31 c0                	xor    %eax,%eax
  return os;
}

int
strlen(const char *s)
{
80105473:	89 e5                	mov    %esp,%ebp
80105475:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
80105478:	80 3a 00             	cmpb   $0x0,(%edx)
8010547b:	74 0c                	je     80105489 <strlen+0x19>
8010547d:	8d 76 00             	lea    0x0(%esi),%esi
80105480:	83 c0 01             	add    $0x1,%eax
80105483:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80105487:	75 f7                	jne    80105480 <strlen+0x10>
    ;
  return n;
}
80105489:	5d                   	pop    %ebp
8010548a:	c3                   	ret    

8010548b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010548b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010548f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80105493:	55                   	push   %ebp
  pushl %ebx
80105494:	53                   	push   %ebx
  pushl %esi
80105495:	56                   	push   %esi
  pushl %edi
80105496:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80105497:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105499:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
8010549b:	5f                   	pop    %edi
  popl %esi
8010549c:	5e                   	pop    %esi
  popl %ebx
8010549d:	5b                   	pop    %ebx
  popl %ebp
8010549e:	5d                   	pop    %ebp
  ret
8010549f:	c3                   	ret    

801054a0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801054a0:	55                   	push   %ebp
801054a1:	89 e5                	mov    %esp,%ebp
801054a3:	53                   	push   %ebx
801054a4:	83 ec 04             	sub    $0x4,%esp
801054a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
801054aa:	e8 81 e5 ff ff       	call   80103a30 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
801054af:	8b 00                	mov    (%eax),%eax
801054b1:	39 d8                	cmp    %ebx,%eax
801054b3:	76 1b                	jbe    801054d0 <fetchint+0x30>
801054b5:	8d 53 04             	lea    0x4(%ebx),%edx
801054b8:	39 d0                	cmp    %edx,%eax
801054ba:	72 14                	jb     801054d0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
801054bc:	8b 45 0c             	mov    0xc(%ebp),%eax
801054bf:	8b 13                	mov    (%ebx),%edx
801054c1:	89 10                	mov    %edx,(%eax)
  return 0;
801054c3:	31 c0                	xor    %eax,%eax
}
801054c5:	83 c4 04             	add    $0x4,%esp
801054c8:	5b                   	pop    %ebx
801054c9:	5d                   	pop    %ebp
801054ca:	c3                   	ret    
801054cb:	90                   	nop
801054cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();

  if(addr >= curproc->sz || addr+4 > curproc->sz)
    return -1;
801054d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054d5:	eb ee                	jmp    801054c5 <fetchint+0x25>
801054d7:	89 f6                	mov    %esi,%esi
801054d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801054e0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
801054e0:	55                   	push   %ebp
801054e1:	89 e5                	mov    %esp,%ebp
801054e3:	53                   	push   %ebx
801054e4:	83 ec 04             	sub    $0x4,%esp
801054e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
801054ea:	e8 41 e5 ff ff       	call   80103a30 <myproc>

  if(addr >= curproc->sz)
801054ef:	39 18                	cmp    %ebx,(%eax)
801054f1:	76 29                	jbe    8010551c <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
801054f3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801054f6:	89 da                	mov    %ebx,%edx
801054f8:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
801054fa:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
801054fc:	39 c3                	cmp    %eax,%ebx
801054fe:	73 1c                	jae    8010551c <fetchstr+0x3c>
    if(*s == 0)
80105500:	80 3b 00             	cmpb   $0x0,(%ebx)
80105503:	75 10                	jne    80105515 <fetchstr+0x35>
80105505:	eb 29                	jmp    80105530 <fetchstr+0x50>
80105507:	89 f6                	mov    %esi,%esi
80105509:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105510:	80 3a 00             	cmpb   $0x0,(%edx)
80105513:	74 1b                	je     80105530 <fetchstr+0x50>

  if(addr >= curproc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
80105515:	83 c2 01             	add    $0x1,%edx
80105518:	39 d0                	cmp    %edx,%eax
8010551a:	77 f4                	ja     80105510 <fetchstr+0x30>
    if(*s == 0)
      return s - *pp;
  }
  return -1;
}
8010551c:	83 c4 04             	add    $0x4,%esp
{
  char *s, *ep;
  struct proc *curproc = myproc();

  if(addr >= curproc->sz)
    return -1;
8010551f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  for(s = *pp; s < ep; s++){
    if(*s == 0)
      return s - *pp;
  }
  return -1;
}
80105524:	5b                   	pop    %ebx
80105525:	5d                   	pop    %ebp
80105526:	c3                   	ret    
80105527:	89 f6                	mov    %esi,%esi
80105529:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105530:	83 c4 04             	add    $0x4,%esp
    return -1;
  *pp = (char*)addr;
  ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
    if(*s == 0)
      return s - *pp;
80105533:	89 d0                	mov    %edx,%eax
80105535:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80105537:	5b                   	pop    %ebx
80105538:	5d                   	pop    %ebp
80105539:	c3                   	ret    
8010553a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105540 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105540:	55                   	push   %ebp
80105541:	89 e5                	mov    %esp,%ebp
80105543:	56                   	push   %esi
80105544:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105545:	e8 e6 e4 ff ff       	call   80103a30 <myproc>
8010554a:	8b 40 18             	mov    0x18(%eax),%eax
8010554d:	8b 55 08             	mov    0x8(%ebp),%edx
80105550:	8b 40 44             	mov    0x44(%eax),%eax
80105553:	8d 1c 90             	lea    (%eax,%edx,4),%ebx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();
80105556:	e8 d5 e4 ff ff       	call   80103a30 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010555b:	8b 00                	mov    (%eax),%eax

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010555d:	8d 73 04             	lea    0x4(%ebx),%esi
int
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105560:	39 c6                	cmp    %eax,%esi
80105562:	73 1c                	jae    80105580 <argint+0x40>
80105564:	8d 53 08             	lea    0x8(%ebx),%edx
80105567:	39 d0                	cmp    %edx,%eax
80105569:	72 15                	jb     80105580 <argint+0x40>
    return -1;
  *ip = *(int*)(addr);
8010556b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010556e:	8b 53 04             	mov    0x4(%ebx),%edx
80105571:	89 10                	mov    %edx,(%eax)
  return 0;
80105573:	31 c0                	xor    %eax,%eax
// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
}
80105575:	5b                   	pop    %ebx
80105576:	5e                   	pop    %esi
80105577:	5d                   	pop    %ebp
80105578:	c3                   	ret    
80105579:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();

  if(addr >= curproc->sz || addr+4 > curproc->sz)
    return -1;
80105580:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105585:	eb ee                	jmp    80105575 <argint+0x35>
80105587:	89 f6                	mov    %esi,%esi
80105589:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105590 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105590:	55                   	push   %ebp
80105591:	89 e5                	mov    %esp,%ebp
80105593:	56                   	push   %esi
80105594:	53                   	push   %ebx
80105595:	83 ec 10             	sub    $0x10,%esp
80105598:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
8010559b:	e8 90 e4 ff ff       	call   80103a30 <myproc>
801055a0:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
801055a2:	8d 45 f4             	lea    -0xc(%ebp),%eax
801055a5:	83 ec 08             	sub    $0x8,%esp
801055a8:	50                   	push   %eax
801055a9:	ff 75 08             	pushl  0x8(%ebp)
801055ac:	e8 8f ff ff ff       	call   80105540 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
801055b1:	c1 e8 1f             	shr    $0x1f,%eax
801055b4:	83 c4 10             	add    $0x10,%esp
801055b7:	84 c0                	test   %al,%al
801055b9:	75 2d                	jne    801055e8 <argptr+0x58>
801055bb:	89 d8                	mov    %ebx,%eax
801055bd:	c1 e8 1f             	shr    $0x1f,%eax
801055c0:	84 c0                	test   %al,%al
801055c2:	75 24                	jne    801055e8 <argptr+0x58>
801055c4:	8b 16                	mov    (%esi),%edx
801055c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055c9:	39 c2                	cmp    %eax,%edx
801055cb:	76 1b                	jbe    801055e8 <argptr+0x58>
801055cd:	01 c3                	add    %eax,%ebx
801055cf:	39 da                	cmp    %ebx,%edx
801055d1:	72 15                	jb     801055e8 <argptr+0x58>
    return -1;
  *pp = (char*)i;
801055d3:	8b 55 0c             	mov    0xc(%ebp),%edx
801055d6:	89 02                	mov    %eax,(%edx)
  return 0;
801055d8:	31 c0                	xor    %eax,%eax
}
801055da:	8d 65 f8             	lea    -0x8(%ebp),%esp
801055dd:	5b                   	pop    %ebx
801055de:	5e                   	pop    %esi
801055df:	5d                   	pop    %ebp
801055e0:	c3                   	ret    
801055e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  struct proc *curproc = myproc();
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
    return -1;
801055e8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055ed:	eb eb                	jmp    801055da <argptr+0x4a>
801055ef:	90                   	nop

801055f0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801055f0:	55                   	push   %ebp
801055f1:	89 e5                	mov    %esp,%ebp
801055f3:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
801055f6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801055f9:	50                   	push   %eax
801055fa:	ff 75 08             	pushl  0x8(%ebp)
801055fd:	e8 3e ff ff ff       	call   80105540 <argint>
80105602:	83 c4 10             	add    $0x10,%esp
80105605:	85 c0                	test   %eax,%eax
80105607:	78 17                	js     80105620 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80105609:	83 ec 08             	sub    $0x8,%esp
8010560c:	ff 75 0c             	pushl  0xc(%ebp)
8010560f:	ff 75 f4             	pushl  -0xc(%ebp)
80105612:	e8 c9 fe ff ff       	call   801054e0 <fetchstr>
80105617:	83 c4 10             	add    $0x10,%esp
}
8010561a:	c9                   	leave  
8010561b:	c3                   	ret    
8010561c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
int
argstr(int n, char **pp)
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
80105620:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchstr(addr, pp);
}
80105625:	c9                   	leave  
80105626:	c3                   	ret    
80105627:	89 f6                	mov    %esi,%esi
80105629:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105630 <syscall>:
[SYS_printinfo]    sys_printinfo,
};

void
syscall(void)
{
80105630:	55                   	push   %ebp
80105631:	89 e5                	mov    %esp,%ebp
80105633:	56                   	push   %esi
80105634:	53                   	push   %ebx
  int num;
  struct proc *curproc = myproc();
80105635:	e8 f6 e3 ff ff       	call   80103a30 <myproc>

  num = curproc->tf->eax;
8010563a:	8b 70 18             	mov    0x18(%eax),%esi

void
syscall(void)
{
  int num;
  struct proc *curproc = myproc();
8010563d:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
8010563f:	8b 46 1c             	mov    0x1c(%esi),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105642:	8d 50 ff             	lea    -0x1(%eax),%edx
80105645:	83 fa 1e             	cmp    $0x1e,%edx
80105648:	77 1e                	ja     80105668 <syscall+0x38>
8010564a:	8b 14 85 a0 88 10 80 	mov    -0x7fef7760(,%eax,4),%edx
80105651:	85 d2                	test   %edx,%edx
80105653:	74 13                	je     80105668 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
80105655:	ff d2                	call   *%edx
80105657:	89 46 1c             	mov    %eax,0x1c(%esi)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
8010565a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010565d:	5b                   	pop    %ebx
8010565e:	5e                   	pop    %esi
8010565f:	5d                   	pop    %ebp
80105660:	c3                   	ret    
80105661:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  num = curproc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    curproc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80105668:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80105669:	8d 43 6c             	lea    0x6c(%ebx),%eax

  num = curproc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    curproc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
8010566c:	50                   	push   %eax
8010566d:	ff 73 10             	pushl  0x10(%ebx)
80105670:	68 81 88 10 80       	push   $0x80108881
80105675:	e8 e6 af ff ff       	call   80100660 <cprintf>
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
8010567a:	8b 43 18             	mov    0x18(%ebx),%eax
8010567d:	83 c4 10             	add    $0x10,%esp
80105680:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
80105687:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010568a:	5b                   	pop    %ebx
8010568b:	5e                   	pop    %esi
8010568c:	5d                   	pop    %ebp
8010568d:	c3                   	ret    
8010568e:	66 90                	xchg   %ax,%ax

80105690 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80105690:	55                   	push   %ebp
80105691:	89 e5                	mov    %esp,%ebp
80105693:	57                   	push   %edi
80105694:	56                   	push   %esi
80105695:	53                   	push   %ebx
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105696:	8d 75 da             	lea    -0x26(%ebp),%esi
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80105699:	83 ec 34             	sub    $0x34,%esp
8010569c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
8010569f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801056a2:	56                   	push   %esi
801056a3:	50                   	push   %eax
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
801056a4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
801056a7:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801056aa:	e8 81 ca ff ff       	call   80102130 <nameiparent>
801056af:	83 c4 10             	add    $0x10,%esp
801056b2:	85 c0                	test   %eax,%eax
801056b4:	0f 84 f6 00 00 00    	je     801057b0 <create+0x120>
    return 0;
  ilock(dp);
801056ba:	83 ec 0c             	sub    $0xc,%esp
801056bd:	89 c7                	mov    %eax,%edi
801056bf:	50                   	push   %eax
801056c0:	e8 fb c1 ff ff       	call   801018c0 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
801056c5:	83 c4 0c             	add    $0xc,%esp
801056c8:	6a 00                	push   $0x0
801056ca:	56                   	push   %esi
801056cb:	57                   	push   %edi
801056cc:	e8 1f c7 ff ff       	call   80101df0 <dirlookup>
801056d1:	83 c4 10             	add    $0x10,%esp
801056d4:	85 c0                	test   %eax,%eax
801056d6:	89 c3                	mov    %eax,%ebx
801056d8:	74 56                	je     80105730 <create+0xa0>
    iunlockput(dp);
801056da:	83 ec 0c             	sub    $0xc,%esp
801056dd:	57                   	push   %edi
801056de:	e8 6d c4 ff ff       	call   80101b50 <iunlockput>
    ilock(ip);
801056e3:	89 1c 24             	mov    %ebx,(%esp)
801056e6:	e8 d5 c1 ff ff       	call   801018c0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
801056eb:	83 c4 10             	add    $0x10,%esp
801056ee:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
801056f3:	75 1b                	jne    80105710 <create+0x80>
801056f5:	66 83 7b 50 02       	cmpw   $0x2,0x50(%ebx)
801056fa:	89 d8                	mov    %ebx,%eax
801056fc:	75 12                	jne    80105710 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801056fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105701:	5b                   	pop    %ebx
80105702:	5e                   	pop    %esi
80105703:	5f                   	pop    %edi
80105704:	5d                   	pop    %ebp
80105705:	c3                   	ret    
80105706:	8d 76 00             	lea    0x0(%esi),%esi
80105709:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if((ip = dirlookup(dp, name, 0)) != 0){
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
80105710:	83 ec 0c             	sub    $0xc,%esp
80105713:	53                   	push   %ebx
80105714:	e8 37 c4 ff ff       	call   80101b50 <iunlockput>
    return 0;
80105719:	83 c4 10             	add    $0x10,%esp
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
8010571c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
    return 0;
8010571f:	31 c0                	xor    %eax,%eax
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80105721:	5b                   	pop    %ebx
80105722:	5e                   	pop    %esi
80105723:	5f                   	pop    %edi
80105724:	5d                   	pop    %ebp
80105725:	c3                   	ret    
80105726:	8d 76 00             	lea    0x0(%esi),%esi
80105729:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      return ip;
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80105730:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80105734:	83 ec 08             	sub    $0x8,%esp
80105737:	50                   	push   %eax
80105738:	ff 37                	pushl  (%edi)
8010573a:	e8 11 c0 ff ff       	call   80101750 <ialloc>
8010573f:	83 c4 10             	add    $0x10,%esp
80105742:	85 c0                	test   %eax,%eax
80105744:	89 c3                	mov    %eax,%ebx
80105746:	0f 84 cc 00 00 00    	je     80105818 <create+0x188>
    panic("create: ialloc");

  ilock(ip);
8010574c:	83 ec 0c             	sub    $0xc,%esp
8010574f:	50                   	push   %eax
80105750:	e8 6b c1 ff ff       	call   801018c0 <ilock>
  ip->major = major;
80105755:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80105759:	66 89 43 52          	mov    %ax,0x52(%ebx)
  ip->minor = minor;
8010575d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80105761:	66 89 43 54          	mov    %ax,0x54(%ebx)
  ip->nlink = 1;
80105765:	b8 01 00 00 00       	mov    $0x1,%eax
8010576a:	66 89 43 56          	mov    %ax,0x56(%ebx)
  iupdate(ip);
8010576e:	89 1c 24             	mov    %ebx,(%esp)
80105771:	e8 9a c0 ff ff       	call   80101810 <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
80105776:	83 c4 10             	add    $0x10,%esp
80105779:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
8010577e:	74 40                	je     801057c0 <create+0x130>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }

  if(dirlink(dp, name, ip->inum) < 0)
80105780:	83 ec 04             	sub    $0x4,%esp
80105783:	ff 73 04             	pushl  0x4(%ebx)
80105786:	56                   	push   %esi
80105787:	57                   	push   %edi
80105788:	e8 c3 c8 ff ff       	call   80102050 <dirlink>
8010578d:	83 c4 10             	add    $0x10,%esp
80105790:	85 c0                	test   %eax,%eax
80105792:	78 77                	js     8010580b <create+0x17b>
    panic("create: dirlink");

  iunlockput(dp);
80105794:	83 ec 0c             	sub    $0xc,%esp
80105797:	57                   	push   %edi
80105798:	e8 b3 c3 ff ff       	call   80101b50 <iunlockput>

  return ip;
8010579d:	83 c4 10             	add    $0x10,%esp
}
801057a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
801057a3:	89 d8                	mov    %ebx,%eax
}
801057a5:	5b                   	pop    %ebx
801057a6:	5e                   	pop    %esi
801057a7:	5f                   	pop    %edi
801057a8:	5d                   	pop    %ebp
801057a9:	c3                   	ret    
801057aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    return 0;
801057b0:	31 c0                	xor    %eax,%eax
801057b2:	e9 47 ff ff ff       	jmp    801056fe <create+0x6e>
801057b7:	89 f6                	mov    %esi,%esi
801057b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ip->minor = minor;
  ip->nlink = 1;
  iupdate(ip);

  if(type == T_DIR){  // Create . and .. entries.
    dp->nlink++;  // for ".."
801057c0:	66 83 47 56 01       	addw   $0x1,0x56(%edi)
    iupdate(dp);
801057c5:	83 ec 0c             	sub    $0xc,%esp
801057c8:	57                   	push   %edi
801057c9:	e8 42 c0 ff ff       	call   80101810 <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801057ce:	83 c4 0c             	add    $0xc,%esp
801057d1:	ff 73 04             	pushl  0x4(%ebx)
801057d4:	68 3c 89 10 80       	push   $0x8010893c
801057d9:	53                   	push   %ebx
801057da:	e8 71 c8 ff ff       	call   80102050 <dirlink>
801057df:	83 c4 10             	add    $0x10,%esp
801057e2:	85 c0                	test   %eax,%eax
801057e4:	78 18                	js     801057fe <create+0x16e>
801057e6:	83 ec 04             	sub    $0x4,%esp
801057e9:	ff 77 04             	pushl  0x4(%edi)
801057ec:	68 3b 89 10 80       	push   $0x8010893b
801057f1:	53                   	push   %ebx
801057f2:	e8 59 c8 ff ff       	call   80102050 <dirlink>
801057f7:	83 c4 10             	add    $0x10,%esp
801057fa:	85 c0                	test   %eax,%eax
801057fc:	79 82                	jns    80105780 <create+0xf0>
      panic("create dots");
801057fe:	83 ec 0c             	sub    $0xc,%esp
80105801:	68 2f 89 10 80       	push   $0x8010892f
80105806:	e8 65 ab ff ff       	call   80100370 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");
8010580b:	83 ec 0c             	sub    $0xc,%esp
8010580e:	68 3e 89 10 80       	push   $0x8010893e
80105813:	e8 58 ab ff ff       	call   80100370 <panic>
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
    panic("create: ialloc");
80105818:	83 ec 0c             	sub    $0xc,%esp
8010581b:	68 20 89 10 80       	push   $0x80108920
80105820:	e8 4b ab ff ff       	call   80100370 <panic>
80105825:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105829:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105830 <argfd.constprop.0>:
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
80105830:	55                   	push   %ebp
80105831:	89 e5                	mov    %esp,%ebp
80105833:	56                   	push   %esi
80105834:	53                   	push   %ebx
80105835:	89 c6                	mov    %eax,%esi
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80105837:	8d 45 f4             	lea    -0xc(%ebp),%eax
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
8010583a:	89 d3                	mov    %edx,%ebx
8010583c:	83 ec 18             	sub    $0x18,%esp
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
8010583f:	50                   	push   %eax
80105840:	6a 00                	push   $0x0
80105842:	e8 f9 fc ff ff       	call   80105540 <argint>
80105847:	83 c4 10             	add    $0x10,%esp
8010584a:	85 c0                	test   %eax,%eax
8010584c:	78 32                	js     80105880 <argfd.constprop.0+0x50>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010584e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105852:	77 2c                	ja     80105880 <argfd.constprop.0+0x50>
80105854:	e8 d7 e1 ff ff       	call   80103a30 <myproc>
80105859:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010585c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80105860:	85 c0                	test   %eax,%eax
80105862:	74 1c                	je     80105880 <argfd.constprop.0+0x50>
    return -1;
  if(pfd)
80105864:	85 f6                	test   %esi,%esi
80105866:	74 02                	je     8010586a <argfd.constprop.0+0x3a>
    *pfd = fd;
80105868:	89 16                	mov    %edx,(%esi)
  if(pf)
8010586a:	85 db                	test   %ebx,%ebx
8010586c:	74 22                	je     80105890 <argfd.constprop.0+0x60>
    *pf = f;
8010586e:	89 03                	mov    %eax,(%ebx)
  return 0;
80105870:	31 c0                	xor    %eax,%eax
}
80105872:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105875:	5b                   	pop    %ebx
80105876:	5e                   	pop    %esi
80105877:	5d                   	pop    %ebp
80105878:	c3                   	ret    
80105879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105880:	8d 65 f8             	lea    -0x8(%ebp),%esp
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    return -1;
80105883:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  return 0;
}
80105888:	5b                   	pop    %ebx
80105889:	5e                   	pop    %esi
8010588a:	5d                   	pop    %ebp
8010588b:	c3                   	ret    
8010588c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  return 0;
80105890:	31 c0                	xor    %eax,%eax
80105892:	eb de                	jmp    80105872 <argfd.constprop.0+0x42>
80105894:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010589a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801058a0 <sys_dup>:
  return -1;
}

int
sys_dup(void)
{
801058a0:	55                   	push   %ebp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
801058a1:	31 c0                	xor    %eax,%eax
  return -1;
}

int
sys_dup(void)
{
801058a3:	89 e5                	mov    %esp,%ebp
801058a5:	56                   	push   %esi
801058a6:	53                   	push   %ebx
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
801058a7:	8d 55 f4             	lea    -0xc(%ebp),%edx
  return -1;
}

int
sys_dup(void)
{
801058aa:	83 ec 10             	sub    $0x10,%esp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
801058ad:	e8 7e ff ff ff       	call   80105830 <argfd.constprop.0>
801058b2:	85 c0                	test   %eax,%eax
801058b4:	78 1a                	js     801058d0 <sys_dup+0x30>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
801058b6:	31 db                	xor    %ebx,%ebx
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
801058b8:	8b 75 f4             	mov    -0xc(%ebp),%esi
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
801058bb:	e8 70 e1 ff ff       	call   80103a30 <myproc>

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
801058c0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801058c4:	85 d2                	test   %edx,%edx
801058c6:	74 18                	je     801058e0 <sys_dup+0x40>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
801058c8:	83 c3 01             	add    $0x1,%ebx
801058cb:	83 fb 10             	cmp    $0x10,%ebx
801058ce:	75 f0                	jne    801058c0 <sys_dup+0x20>
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
}
801058d0:	8d 65 f8             	lea    -0x8(%ebp),%esp
{
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
    return -1;
801058d3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
}
801058d8:	5b                   	pop    %ebx
801058d9:	5e                   	pop    %esi
801058da:	5d                   	pop    %ebp
801058db:	c3                   	ret    
801058dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
801058e0:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)

  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
801058e4:	83 ec 0c             	sub    $0xc,%esp
801058e7:	ff 75 f4             	pushl  -0xc(%ebp)
801058ea:	e8 51 b7 ff ff       	call   80101040 <filedup>
  return fd;
801058ef:	83 c4 10             	add    $0x10,%esp
}
801058f2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
801058f5:	89 d8                	mov    %ebx,%eax
}
801058f7:	5b                   	pop    %ebx
801058f8:	5e                   	pop    %esi
801058f9:	5d                   	pop    %ebp
801058fa:	c3                   	ret    
801058fb:	90                   	nop
801058fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105900 <sys_read>:

int
sys_read(void)
{
80105900:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105901:	31 c0                	xor    %eax,%eax
  return fd;
}

int
sys_read(void)
{
80105903:	89 e5                	mov    %esp,%ebp
80105905:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105908:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010590b:	e8 20 ff ff ff       	call   80105830 <argfd.constprop.0>
80105910:	85 c0                	test   %eax,%eax
80105912:	78 4c                	js     80105960 <sys_read+0x60>
80105914:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105917:	83 ec 08             	sub    $0x8,%esp
8010591a:	50                   	push   %eax
8010591b:	6a 02                	push   $0x2
8010591d:	e8 1e fc ff ff       	call   80105540 <argint>
80105922:	83 c4 10             	add    $0x10,%esp
80105925:	85 c0                	test   %eax,%eax
80105927:	78 37                	js     80105960 <sys_read+0x60>
80105929:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010592c:	83 ec 04             	sub    $0x4,%esp
8010592f:	ff 75 f0             	pushl  -0x10(%ebp)
80105932:	50                   	push   %eax
80105933:	6a 01                	push   $0x1
80105935:	e8 56 fc ff ff       	call   80105590 <argptr>
8010593a:	83 c4 10             	add    $0x10,%esp
8010593d:	85 c0                	test   %eax,%eax
8010593f:	78 1f                	js     80105960 <sys_read+0x60>
    return -1;
  return fileread(f, p, n);
80105941:	83 ec 04             	sub    $0x4,%esp
80105944:	ff 75 f0             	pushl  -0x10(%ebp)
80105947:	ff 75 f4             	pushl  -0xc(%ebp)
8010594a:	ff 75 ec             	pushl  -0x14(%ebp)
8010594d:	e8 5e b8 ff ff       	call   801011b0 <fileread>
80105952:	83 c4 10             	add    $0x10,%esp
}
80105955:	c9                   	leave  
80105956:	c3                   	ret    
80105957:	89 f6                	mov    %esi,%esi
80105959:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
80105960:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fileread(f, p, n);
}
80105965:	c9                   	leave  
80105966:	c3                   	ret    
80105967:	89 f6                	mov    %esi,%esi
80105969:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105970 <sys_write>:

int
sys_write(void)
{
80105970:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105971:	31 c0                	xor    %eax,%eax
  return fileread(f, p, n);
}

int
sys_write(void)
{
80105973:	89 e5                	mov    %esp,%ebp
80105975:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105978:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010597b:	e8 b0 fe ff ff       	call   80105830 <argfd.constprop.0>
80105980:	85 c0                	test   %eax,%eax
80105982:	78 4c                	js     801059d0 <sys_write+0x60>
80105984:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105987:	83 ec 08             	sub    $0x8,%esp
8010598a:	50                   	push   %eax
8010598b:	6a 02                	push   $0x2
8010598d:	e8 ae fb ff ff       	call   80105540 <argint>
80105992:	83 c4 10             	add    $0x10,%esp
80105995:	85 c0                	test   %eax,%eax
80105997:	78 37                	js     801059d0 <sys_write+0x60>
80105999:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010599c:	83 ec 04             	sub    $0x4,%esp
8010599f:	ff 75 f0             	pushl  -0x10(%ebp)
801059a2:	50                   	push   %eax
801059a3:	6a 01                	push   $0x1
801059a5:	e8 e6 fb ff ff       	call   80105590 <argptr>
801059aa:	83 c4 10             	add    $0x10,%esp
801059ad:	85 c0                	test   %eax,%eax
801059af:	78 1f                	js     801059d0 <sys_write+0x60>
    return -1;
  return filewrite(f, p, n);
801059b1:	83 ec 04             	sub    $0x4,%esp
801059b4:	ff 75 f0             	pushl  -0x10(%ebp)
801059b7:	ff 75 f4             	pushl  -0xc(%ebp)
801059ba:	ff 75 ec             	pushl  -0x14(%ebp)
801059bd:	e8 7e b8 ff ff       	call   80101240 <filewrite>
801059c2:	83 c4 10             	add    $0x10,%esp
}
801059c5:	c9                   	leave  
801059c6:	c3                   	ret    
801059c7:	89 f6                	mov    %esi,%esi
801059c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
801059d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filewrite(f, p, n);
}
801059d5:	c9                   	leave  
801059d6:	c3                   	ret    
801059d7:	89 f6                	mov    %esi,%esi
801059d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801059e0 <sys_close>:

int
sys_close(void)
{
801059e0:	55                   	push   %ebp
801059e1:	89 e5                	mov    %esp,%ebp
801059e3:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
801059e6:	8d 55 f4             	lea    -0xc(%ebp),%edx
801059e9:	8d 45 f0             	lea    -0x10(%ebp),%eax
801059ec:	e8 3f fe ff ff       	call   80105830 <argfd.constprop.0>
801059f1:	85 c0                	test   %eax,%eax
801059f3:	78 2b                	js     80105a20 <sys_close+0x40>
    return -1;
  myproc()->ofile[fd] = 0;
801059f5:	e8 36 e0 ff ff       	call   80103a30 <myproc>
801059fa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
801059fd:	83 ec 0c             	sub    $0xc,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    return -1;
  myproc()->ofile[fd] = 0;
80105a00:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80105a07:	00 
  fileclose(f);
80105a08:	ff 75 f4             	pushl  -0xc(%ebp)
80105a0b:	e8 80 b6 ff ff       	call   80101090 <fileclose>
  return 0;
80105a10:	83 c4 10             	add    $0x10,%esp
80105a13:	31 c0                	xor    %eax,%eax
}
80105a15:	c9                   	leave  
80105a16:	c3                   	ret    
80105a17:	89 f6                	mov    %esi,%esi
80105a19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
{
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    return -1;
80105a20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  myproc()->ofile[fd] = 0;
  fileclose(f);
  return 0;
}
80105a25:	c9                   	leave  
80105a26:	c3                   	ret    
80105a27:	89 f6                	mov    %esi,%esi
80105a29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105a30 <sys_fstat>:

int
sys_fstat(void)
{
80105a30:	55                   	push   %ebp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105a31:	31 c0                	xor    %eax,%eax
  return 0;
}

int
sys_fstat(void)
{
80105a33:	89 e5                	mov    %esp,%ebp
80105a35:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105a38:	8d 55 f0             	lea    -0x10(%ebp),%edx
80105a3b:	e8 f0 fd ff ff       	call   80105830 <argfd.constprop.0>
80105a40:	85 c0                	test   %eax,%eax
80105a42:	78 2c                	js     80105a70 <sys_fstat+0x40>
80105a44:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a47:	83 ec 04             	sub    $0x4,%esp
80105a4a:	6a 14                	push   $0x14
80105a4c:	50                   	push   %eax
80105a4d:	6a 01                	push   $0x1
80105a4f:	e8 3c fb ff ff       	call   80105590 <argptr>
80105a54:	83 c4 10             	add    $0x10,%esp
80105a57:	85 c0                	test   %eax,%eax
80105a59:	78 15                	js     80105a70 <sys_fstat+0x40>
    return -1;
  return filestat(f, st);
80105a5b:	83 ec 08             	sub    $0x8,%esp
80105a5e:	ff 75 f4             	pushl  -0xc(%ebp)
80105a61:	ff 75 f0             	pushl  -0x10(%ebp)
80105a64:	e8 f7 b6 ff ff       	call   80101160 <filestat>
80105a69:	83 c4 10             	add    $0x10,%esp
}
80105a6c:	c9                   	leave  
80105a6d:	c3                   	ret    
80105a6e:	66 90                	xchg   %ax,%ax
{
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
    return -1;
80105a70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filestat(f, st);
}
80105a75:	c9                   	leave  
80105a76:	c3                   	ret    
80105a77:	89 f6                	mov    %esi,%esi
80105a79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105a80 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105a80:	55                   	push   %ebp
80105a81:	89 e5                	mov    %esp,%ebp
80105a83:	57                   	push   %edi
80105a84:	56                   	push   %esi
80105a85:	53                   	push   %ebx
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105a86:	8d 45 d4             	lea    -0x2c(%ebp),%eax
}

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105a89:	83 ec 34             	sub    $0x34,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105a8c:	50                   	push   %eax
80105a8d:	6a 00                	push   $0x0
80105a8f:	e8 5c fb ff ff       	call   801055f0 <argstr>
80105a94:	83 c4 10             	add    $0x10,%esp
80105a97:	85 c0                	test   %eax,%eax
80105a99:	0f 88 fb 00 00 00    	js     80105b9a <sys_link+0x11a>
80105a9f:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105aa2:	83 ec 08             	sub    $0x8,%esp
80105aa5:	50                   	push   %eax
80105aa6:	6a 01                	push   $0x1
80105aa8:	e8 43 fb ff ff       	call   801055f0 <argstr>
80105aad:	83 c4 10             	add    $0x10,%esp
80105ab0:	85 c0                	test   %eax,%eax
80105ab2:	0f 88 e2 00 00 00    	js     80105b9a <sys_link+0x11a>
    return -1;

  begin_op();
80105ab8:	e8 e3 d2 ff ff       	call   80102da0 <begin_op>
  if((ip = namei(old)) == 0){
80105abd:	83 ec 0c             	sub    $0xc,%esp
80105ac0:	ff 75 d4             	pushl  -0x2c(%ebp)
80105ac3:	e8 48 c6 ff ff       	call   80102110 <namei>
80105ac8:	83 c4 10             	add    $0x10,%esp
80105acb:	85 c0                	test   %eax,%eax
80105acd:	89 c3                	mov    %eax,%ebx
80105acf:	0f 84 f3 00 00 00    	je     80105bc8 <sys_link+0x148>
    end_op();
    return -1;
  }

  ilock(ip);
80105ad5:	83 ec 0c             	sub    $0xc,%esp
80105ad8:	50                   	push   %eax
80105ad9:	e8 e2 bd ff ff       	call   801018c0 <ilock>
  if(ip->type == T_DIR){
80105ade:	83 c4 10             	add    $0x10,%esp
80105ae1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105ae6:	0f 84 c4 00 00 00    	je     80105bb0 <sys_link+0x130>
    iunlockput(ip);
    end_op();
    return -1;
  }

  ip->nlink++;
80105aec:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
80105af1:	83 ec 0c             	sub    $0xc,%esp
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
80105af4:	8d 7d da             	lea    -0x26(%ebp),%edi
    end_op();
    return -1;
  }

  ip->nlink++;
  iupdate(ip);
80105af7:	53                   	push   %ebx
80105af8:	e8 13 bd ff ff       	call   80101810 <iupdate>
  iunlock(ip);
80105afd:	89 1c 24             	mov    %ebx,(%esp)
80105b00:	e8 9b be ff ff       	call   801019a0 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
80105b05:	58                   	pop    %eax
80105b06:	5a                   	pop    %edx
80105b07:	57                   	push   %edi
80105b08:	ff 75 d0             	pushl  -0x30(%ebp)
80105b0b:	e8 20 c6 ff ff       	call   80102130 <nameiparent>
80105b10:	83 c4 10             	add    $0x10,%esp
80105b13:	85 c0                	test   %eax,%eax
80105b15:	89 c6                	mov    %eax,%esi
80105b17:	74 5b                	je     80105b74 <sys_link+0xf4>
    goto bad;
  ilock(dp);
80105b19:	83 ec 0c             	sub    $0xc,%esp
80105b1c:	50                   	push   %eax
80105b1d:	e8 9e bd ff ff       	call   801018c0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105b22:	83 c4 10             	add    $0x10,%esp
80105b25:	8b 03                	mov    (%ebx),%eax
80105b27:	39 06                	cmp    %eax,(%esi)
80105b29:	75 3d                	jne    80105b68 <sys_link+0xe8>
80105b2b:	83 ec 04             	sub    $0x4,%esp
80105b2e:	ff 73 04             	pushl  0x4(%ebx)
80105b31:	57                   	push   %edi
80105b32:	56                   	push   %esi
80105b33:	e8 18 c5 ff ff       	call   80102050 <dirlink>
80105b38:	83 c4 10             	add    $0x10,%esp
80105b3b:	85 c0                	test   %eax,%eax
80105b3d:	78 29                	js     80105b68 <sys_link+0xe8>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
80105b3f:	83 ec 0c             	sub    $0xc,%esp
80105b42:	56                   	push   %esi
80105b43:	e8 08 c0 ff ff       	call   80101b50 <iunlockput>
  iput(ip);
80105b48:	89 1c 24             	mov    %ebx,(%esp)
80105b4b:	e8 a0 be ff ff       	call   801019f0 <iput>

  end_op();
80105b50:	e8 bb d2 ff ff       	call   80102e10 <end_op>

  return 0;
80105b55:	83 c4 10             	add    $0x10,%esp
80105b58:	31 c0                	xor    %eax,%eax
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
80105b5a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b5d:	5b                   	pop    %ebx
80105b5e:	5e                   	pop    %esi
80105b5f:	5f                   	pop    %edi
80105b60:	5d                   	pop    %ebp
80105b61:	c3                   	ret    
80105b62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
  ilock(dp);
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    iunlockput(dp);
80105b68:	83 ec 0c             	sub    $0xc,%esp
80105b6b:	56                   	push   %esi
80105b6c:	e8 df bf ff ff       	call   80101b50 <iunlockput>
    goto bad;
80105b71:	83 c4 10             	add    $0x10,%esp
  end_op();

  return 0;

bad:
  ilock(ip);
80105b74:	83 ec 0c             	sub    $0xc,%esp
80105b77:	53                   	push   %ebx
80105b78:	e8 43 bd ff ff       	call   801018c0 <ilock>
  ip->nlink--;
80105b7d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105b82:	89 1c 24             	mov    %ebx,(%esp)
80105b85:	e8 86 bc ff ff       	call   80101810 <iupdate>
  iunlockput(ip);
80105b8a:	89 1c 24             	mov    %ebx,(%esp)
80105b8d:	e8 be bf ff ff       	call   80101b50 <iunlockput>
  end_op();
80105b92:	e8 79 d2 ff ff       	call   80102e10 <end_op>
  return -1;
80105b97:	83 c4 10             	add    $0x10,%esp
}
80105b9a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  ilock(ip);
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
80105b9d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ba2:	5b                   	pop    %ebx
80105ba3:	5e                   	pop    %esi
80105ba4:	5f                   	pop    %edi
80105ba5:	5d                   	pop    %ebp
80105ba6:	c3                   	ret    
80105ba7:	89 f6                	mov    %esi,%esi
80105ba9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
  }

  ilock(ip);
  if(ip->type == T_DIR){
    iunlockput(ip);
80105bb0:	83 ec 0c             	sub    $0xc,%esp
80105bb3:	53                   	push   %ebx
80105bb4:	e8 97 bf ff ff       	call   80101b50 <iunlockput>
    end_op();
80105bb9:	e8 52 d2 ff ff       	call   80102e10 <end_op>
    return -1;
80105bbe:	83 c4 10             	add    $0x10,%esp
80105bc1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bc6:	eb 92                	jmp    80105b5a <sys_link+0xda>
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
    return -1;

  begin_op();
  if((ip = namei(old)) == 0){
    end_op();
80105bc8:	e8 43 d2 ff ff       	call   80102e10 <end_op>
    return -1;
80105bcd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bd2:	eb 86                	jmp    80105b5a <sys_link+0xda>
80105bd4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105bda:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105be0 <sys_unlink>:
}

//PAGEBREAK!
int
sys_unlink(void)
{
80105be0:	55                   	push   %ebp
80105be1:	89 e5                	mov    %esp,%ebp
80105be3:	57                   	push   %edi
80105be4:	56                   	push   %esi
80105be5:	53                   	push   %ebx
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105be6:	8d 45 c0             	lea    -0x40(%ebp),%eax
}

//PAGEBREAK!
int
sys_unlink(void)
{
80105be9:	83 ec 54             	sub    $0x54,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105bec:	50                   	push   %eax
80105bed:	6a 00                	push   $0x0
80105bef:	e8 fc f9 ff ff       	call   801055f0 <argstr>
80105bf4:	83 c4 10             	add    $0x10,%esp
80105bf7:	85 c0                	test   %eax,%eax
80105bf9:	0f 88 82 01 00 00    	js     80105d81 <sys_unlink+0x1a1>
    return -1;

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
80105bff:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  uint off;

  if(argstr(0, &path) < 0)
    return -1;

  begin_op();
80105c02:	e8 99 d1 ff ff       	call   80102da0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105c07:	83 ec 08             	sub    $0x8,%esp
80105c0a:	53                   	push   %ebx
80105c0b:	ff 75 c0             	pushl  -0x40(%ebp)
80105c0e:	e8 1d c5 ff ff       	call   80102130 <nameiparent>
80105c13:	83 c4 10             	add    $0x10,%esp
80105c16:	85 c0                	test   %eax,%eax
80105c18:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80105c1b:	0f 84 6a 01 00 00    	je     80105d8b <sys_unlink+0x1ab>
    end_op();
    return -1;
  }

  ilock(dp);
80105c21:	8b 75 b4             	mov    -0x4c(%ebp),%esi
80105c24:	83 ec 0c             	sub    $0xc,%esp
80105c27:	56                   	push   %esi
80105c28:	e8 93 bc ff ff       	call   801018c0 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105c2d:	58                   	pop    %eax
80105c2e:	5a                   	pop    %edx
80105c2f:	68 3c 89 10 80       	push   $0x8010893c
80105c34:	53                   	push   %ebx
80105c35:	e8 96 c1 ff ff       	call   80101dd0 <namecmp>
80105c3a:	83 c4 10             	add    $0x10,%esp
80105c3d:	85 c0                	test   %eax,%eax
80105c3f:	0f 84 fc 00 00 00    	je     80105d41 <sys_unlink+0x161>
80105c45:	83 ec 08             	sub    $0x8,%esp
80105c48:	68 3b 89 10 80       	push   $0x8010893b
80105c4d:	53                   	push   %ebx
80105c4e:	e8 7d c1 ff ff       	call   80101dd0 <namecmp>
80105c53:	83 c4 10             	add    $0x10,%esp
80105c56:	85 c0                	test   %eax,%eax
80105c58:	0f 84 e3 00 00 00    	je     80105d41 <sys_unlink+0x161>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80105c5e:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105c61:	83 ec 04             	sub    $0x4,%esp
80105c64:	50                   	push   %eax
80105c65:	53                   	push   %ebx
80105c66:	56                   	push   %esi
80105c67:	e8 84 c1 ff ff       	call   80101df0 <dirlookup>
80105c6c:	83 c4 10             	add    $0x10,%esp
80105c6f:	85 c0                	test   %eax,%eax
80105c71:	89 c3                	mov    %eax,%ebx
80105c73:	0f 84 c8 00 00 00    	je     80105d41 <sys_unlink+0x161>
    goto bad;
  ilock(ip);
80105c79:	83 ec 0c             	sub    $0xc,%esp
80105c7c:	50                   	push   %eax
80105c7d:	e8 3e bc ff ff       	call   801018c0 <ilock>

  if(ip->nlink < 1)
80105c82:	83 c4 10             	add    $0x10,%esp
80105c85:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80105c8a:	0f 8e 24 01 00 00    	jle    80105db4 <sys_unlink+0x1d4>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
80105c90:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105c95:	8d 75 d8             	lea    -0x28(%ebp),%esi
80105c98:	74 66                	je     80105d00 <sys_unlink+0x120>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
80105c9a:	83 ec 04             	sub    $0x4,%esp
80105c9d:	6a 10                	push   $0x10
80105c9f:	6a 00                	push   $0x0
80105ca1:	56                   	push   %esi
80105ca2:	e8 89 f5 ff ff       	call   80105230 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105ca7:	6a 10                	push   $0x10
80105ca9:	ff 75 c4             	pushl  -0x3c(%ebp)
80105cac:	56                   	push   %esi
80105cad:	ff 75 b4             	pushl  -0x4c(%ebp)
80105cb0:	e8 eb bf ff ff       	call   80101ca0 <writei>
80105cb5:	83 c4 20             	add    $0x20,%esp
80105cb8:	83 f8 10             	cmp    $0x10,%eax
80105cbb:	0f 85 e6 00 00 00    	jne    80105da7 <sys_unlink+0x1c7>
    panic("unlink: writei");
  if(ip->type == T_DIR){
80105cc1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105cc6:	0f 84 9c 00 00 00    	je     80105d68 <sys_unlink+0x188>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);
80105ccc:	83 ec 0c             	sub    $0xc,%esp
80105ccf:	ff 75 b4             	pushl  -0x4c(%ebp)
80105cd2:	e8 79 be ff ff       	call   80101b50 <iunlockput>

  ip->nlink--;
80105cd7:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105cdc:	89 1c 24             	mov    %ebx,(%esp)
80105cdf:	e8 2c bb ff ff       	call   80101810 <iupdate>
  iunlockput(ip);
80105ce4:	89 1c 24             	mov    %ebx,(%esp)
80105ce7:	e8 64 be ff ff       	call   80101b50 <iunlockput>

  end_op();
80105cec:	e8 1f d1 ff ff       	call   80102e10 <end_op>

  return 0;
80105cf1:	83 c4 10             	add    $0x10,%esp
80105cf4:	31 c0                	xor    %eax,%eax

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
80105cf6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105cf9:	5b                   	pop    %ebx
80105cfa:	5e                   	pop    %esi
80105cfb:	5f                   	pop    %edi
80105cfc:	5d                   	pop    %ebp
80105cfd:	c3                   	ret    
80105cfe:	66 90                	xchg   %ax,%ax
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105d00:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105d04:	76 94                	jbe    80105c9a <sys_unlink+0xba>
80105d06:	bf 20 00 00 00       	mov    $0x20,%edi
80105d0b:	eb 0f                	jmp    80105d1c <sys_unlink+0x13c>
80105d0d:	8d 76 00             	lea    0x0(%esi),%esi
80105d10:	83 c7 10             	add    $0x10,%edi
80105d13:	3b 7b 58             	cmp    0x58(%ebx),%edi
80105d16:	0f 83 7e ff ff ff    	jae    80105c9a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105d1c:	6a 10                	push   $0x10
80105d1e:	57                   	push   %edi
80105d1f:	56                   	push   %esi
80105d20:	53                   	push   %ebx
80105d21:	e8 7a be ff ff       	call   80101ba0 <readi>
80105d26:	83 c4 10             	add    $0x10,%esp
80105d29:	83 f8 10             	cmp    $0x10,%eax
80105d2c:	75 6c                	jne    80105d9a <sys_unlink+0x1ba>
      panic("isdirempty: readi");
    if(de.inum != 0)
80105d2e:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105d33:	74 db                	je     80105d10 <sys_unlink+0x130>
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
    iunlockput(ip);
80105d35:	83 ec 0c             	sub    $0xc,%esp
80105d38:	53                   	push   %ebx
80105d39:	e8 12 be ff ff       	call   80101b50 <iunlockput>
    goto bad;
80105d3e:	83 c4 10             	add    $0x10,%esp
  end_op();

  return 0;

bad:
  iunlockput(dp);
80105d41:	83 ec 0c             	sub    $0xc,%esp
80105d44:	ff 75 b4             	pushl  -0x4c(%ebp)
80105d47:	e8 04 be ff ff       	call   80101b50 <iunlockput>
  end_op();
80105d4c:	e8 bf d0 ff ff       	call   80102e10 <end_op>
  return -1;
80105d51:	83 c4 10             	add    $0x10,%esp
}
80105d54:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;

bad:
  iunlockput(dp);
  end_op();
  return -1;
80105d57:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105d5c:	5b                   	pop    %ebx
80105d5d:	5e                   	pop    %esi
80105d5e:	5f                   	pop    %edi
80105d5f:	5d                   	pop    %ebp
80105d60:	c3                   	ret    
80105d61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
80105d68:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
80105d6b:	83 ec 0c             	sub    $0xc,%esp

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
80105d6e:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
80105d73:	50                   	push   %eax
80105d74:	e8 97 ba ff ff       	call   80101810 <iupdate>
80105d79:	83 c4 10             	add    $0x10,%esp
80105d7c:	e9 4b ff ff ff       	jmp    80105ccc <sys_unlink+0xec>
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
    return -1;
80105d81:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d86:	e9 6b ff ff ff       	jmp    80105cf6 <sys_unlink+0x116>

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
    end_op();
80105d8b:	e8 80 d0 ff ff       	call   80102e10 <end_op>
    return -1;
80105d90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d95:	e9 5c ff ff ff       	jmp    80105cf6 <sys_unlink+0x116>
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
80105d9a:	83 ec 0c             	sub    $0xc,%esp
80105d9d:	68 60 89 10 80       	push   $0x80108960
80105da2:	e8 c9 a5 ff ff       	call   80100370 <panic>
    goto bad;
  }

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
80105da7:	83 ec 0c             	sub    $0xc,%esp
80105daa:	68 72 89 10 80       	push   $0x80108972
80105daf:	e8 bc a5 ff ff       	call   80100370 <panic>
  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
80105db4:	83 ec 0c             	sub    $0xc,%esp
80105db7:	68 4e 89 10 80       	push   $0x8010894e
80105dbc:	e8 af a5 ff ff       	call   80100370 <panic>
80105dc1:	eb 0d                	jmp    80105dd0 <sys_open>
80105dc3:	90                   	nop
80105dc4:	90                   	nop
80105dc5:	90                   	nop
80105dc6:	90                   	nop
80105dc7:	90                   	nop
80105dc8:	90                   	nop
80105dc9:	90                   	nop
80105dca:	90                   	nop
80105dcb:	90                   	nop
80105dcc:	90                   	nop
80105dcd:	90                   	nop
80105dce:	90                   	nop
80105dcf:	90                   	nop

80105dd0 <sys_open>:
  return ip;
}

int
sys_open(void)
{
80105dd0:	55                   	push   %ebp
80105dd1:	89 e5                	mov    %esp,%ebp
80105dd3:	57                   	push   %edi
80105dd4:	56                   	push   %esi
80105dd5:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105dd6:	8d 45 e0             	lea    -0x20(%ebp),%eax
  return ip;
}

int
sys_open(void)
{
80105dd9:	83 ec 24             	sub    $0x24,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105ddc:	50                   	push   %eax
80105ddd:	6a 00                	push   $0x0
80105ddf:	e8 0c f8 ff ff       	call   801055f0 <argstr>
80105de4:	83 c4 10             	add    $0x10,%esp
80105de7:	85 c0                	test   %eax,%eax
80105de9:	0f 88 9e 00 00 00    	js     80105e8d <sys_open+0xbd>
80105def:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105df2:	83 ec 08             	sub    $0x8,%esp
80105df5:	50                   	push   %eax
80105df6:	6a 01                	push   $0x1
80105df8:	e8 43 f7 ff ff       	call   80105540 <argint>
80105dfd:	83 c4 10             	add    $0x10,%esp
80105e00:	85 c0                	test   %eax,%eax
80105e02:	0f 88 85 00 00 00    	js     80105e8d <sys_open+0xbd>
    return -1;

  begin_op();
80105e08:	e8 93 cf ff ff       	call   80102da0 <begin_op>

  if(omode & O_CREATE){
80105e0d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105e11:	0f 85 89 00 00 00    	jne    80105ea0 <sys_open+0xd0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105e17:	83 ec 0c             	sub    $0xc,%esp
80105e1a:	ff 75 e0             	pushl  -0x20(%ebp)
80105e1d:	e8 ee c2 ff ff       	call   80102110 <namei>
80105e22:	83 c4 10             	add    $0x10,%esp
80105e25:	85 c0                	test   %eax,%eax
80105e27:	89 c6                	mov    %eax,%esi
80105e29:	0f 84 8e 00 00 00    	je     80105ebd <sys_open+0xed>
      end_op();
      return -1;
    }
    ilock(ip);
80105e2f:	83 ec 0c             	sub    $0xc,%esp
80105e32:	50                   	push   %eax
80105e33:	e8 88 ba ff ff       	call   801018c0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105e38:	83 c4 10             	add    $0x10,%esp
80105e3b:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105e40:	0f 84 d2 00 00 00    	je     80105f18 <sys_open+0x148>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105e46:	e8 85 b1 ff ff       	call   80100fd0 <filealloc>
80105e4b:	85 c0                	test   %eax,%eax
80105e4d:	89 c7                	mov    %eax,%edi
80105e4f:	74 2b                	je     80105e7c <sys_open+0xac>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105e51:	31 db                	xor    %ebx,%ebx
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
80105e53:	e8 d8 db ff ff       	call   80103a30 <myproc>
80105e58:	90                   	nop
80105e59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
80105e60:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105e64:	85 d2                	test   %edx,%edx
80105e66:	74 68                	je     80105ed0 <sys_open+0x100>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105e68:	83 c3 01             	add    $0x1,%ebx
80105e6b:	83 fb 10             	cmp    $0x10,%ebx
80105e6e:	75 f0                	jne    80105e60 <sys_open+0x90>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
80105e70:	83 ec 0c             	sub    $0xc,%esp
80105e73:	57                   	push   %edi
80105e74:	e8 17 b2 ff ff       	call   80101090 <fileclose>
80105e79:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80105e7c:	83 ec 0c             	sub    $0xc,%esp
80105e7f:	56                   	push   %esi
80105e80:	e8 cb bc ff ff       	call   80101b50 <iunlockput>
    end_op();
80105e85:	e8 86 cf ff ff       	call   80102e10 <end_op>
    return -1;
80105e8a:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
80105e8d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
80105e90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
80105e95:	5b                   	pop    %ebx
80105e96:	5e                   	pop    %esi
80105e97:	5f                   	pop    %edi
80105e98:	5d                   	pop    %ebp
80105e99:	c3                   	ret    
80105e9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
80105ea0:	83 ec 0c             	sub    $0xc,%esp
80105ea3:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105ea6:	31 c9                	xor    %ecx,%ecx
80105ea8:	6a 00                	push   $0x0
80105eaa:	ba 02 00 00 00       	mov    $0x2,%edx
80105eaf:	e8 dc f7 ff ff       	call   80105690 <create>
    if(ip == 0){
80105eb4:	83 c4 10             	add    $0x10,%esp
80105eb7:	85 c0                	test   %eax,%eax
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
80105eb9:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105ebb:	75 89                	jne    80105e46 <sys_open+0x76>
      end_op();
80105ebd:	e8 4e cf ff ff       	call   80102e10 <end_op>
      return -1;
80105ec2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ec7:	eb 43                	jmp    80105f0c <sys_open+0x13c>
80105ec9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105ed0:	83 ec 0c             	sub    $0xc,%esp
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80105ed3:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105ed7:	56                   	push   %esi
80105ed8:	e8 c3 ba ff ff       	call   801019a0 <iunlock>
  end_op();
80105edd:	e8 2e cf ff ff       	call   80102e10 <end_op>

  f->type = FD_INODE;
80105ee2:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105ee8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105eeb:	83 c4 10             	add    $0x10,%esp
  }
  iunlock(ip);
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
80105eee:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
80105ef1:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105ef8:	89 d0                	mov    %edx,%eax
80105efa:	83 e0 01             	and    $0x1,%eax
80105efd:	83 f0 01             	xor    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105f00:	83 e2 03             	and    $0x3,%edx
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105f03:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105f06:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
80105f0a:	89 d8                	mov    %ebx,%eax
}
80105f0c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105f0f:	5b                   	pop    %ebx
80105f10:	5e                   	pop    %esi
80105f11:	5f                   	pop    %edi
80105f12:	5d                   	pop    %ebp
80105f13:	c3                   	ret    
80105f14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((ip = namei(path)) == 0){
      end_op();
      return -1;
    }
    ilock(ip);
    if(ip->type == T_DIR && omode != O_RDONLY){
80105f18:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105f1b:	85 c9                	test   %ecx,%ecx
80105f1d:	0f 84 23 ff ff ff    	je     80105e46 <sys_open+0x76>
80105f23:	e9 54 ff ff ff       	jmp    80105e7c <sys_open+0xac>
80105f28:	90                   	nop
80105f29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105f30 <sys_mkdir>:
  return fd;
}

int
sys_mkdir(void)
{
80105f30:	55                   	push   %ebp
80105f31:	89 e5                	mov    %esp,%ebp
80105f33:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105f36:	e8 65 ce ff ff       	call   80102da0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80105f3b:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105f3e:	83 ec 08             	sub    $0x8,%esp
80105f41:	50                   	push   %eax
80105f42:	6a 00                	push   $0x0
80105f44:	e8 a7 f6 ff ff       	call   801055f0 <argstr>
80105f49:	83 c4 10             	add    $0x10,%esp
80105f4c:	85 c0                	test   %eax,%eax
80105f4e:	78 30                	js     80105f80 <sys_mkdir+0x50>
80105f50:	83 ec 0c             	sub    $0xc,%esp
80105f53:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f56:	31 c9                	xor    %ecx,%ecx
80105f58:	6a 00                	push   $0x0
80105f5a:	ba 01 00 00 00       	mov    $0x1,%edx
80105f5f:	e8 2c f7 ff ff       	call   80105690 <create>
80105f64:	83 c4 10             	add    $0x10,%esp
80105f67:	85 c0                	test   %eax,%eax
80105f69:	74 15                	je     80105f80 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105f6b:	83 ec 0c             	sub    $0xc,%esp
80105f6e:	50                   	push   %eax
80105f6f:	e8 dc bb ff ff       	call   80101b50 <iunlockput>
  end_op();
80105f74:	e8 97 ce ff ff       	call   80102e10 <end_op>
  return 0;
80105f79:	83 c4 10             	add    $0x10,%esp
80105f7c:	31 c0                	xor    %eax,%eax
}
80105f7e:	c9                   	leave  
80105f7f:	c3                   	ret    
  char *path;
  struct inode *ip;

  begin_op();
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    end_op();
80105f80:	e8 8b ce ff ff       	call   80102e10 <end_op>
    return -1;
80105f85:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
80105f8a:	c9                   	leave  
80105f8b:	c3                   	ret    
80105f8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105f90 <sys_mknod>:

int
sys_mknod(void)
{
80105f90:	55                   	push   %ebp
80105f91:	89 e5                	mov    %esp,%ebp
80105f93:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105f96:	e8 05 ce ff ff       	call   80102da0 <begin_op>
  if((argstr(0, &path)) < 0 ||
80105f9b:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105f9e:	83 ec 08             	sub    $0x8,%esp
80105fa1:	50                   	push   %eax
80105fa2:	6a 00                	push   $0x0
80105fa4:	e8 47 f6 ff ff       	call   801055f0 <argstr>
80105fa9:	83 c4 10             	add    $0x10,%esp
80105fac:	85 c0                	test   %eax,%eax
80105fae:	78 60                	js     80106010 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105fb0:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105fb3:	83 ec 08             	sub    $0x8,%esp
80105fb6:	50                   	push   %eax
80105fb7:	6a 01                	push   $0x1
80105fb9:	e8 82 f5 ff ff       	call   80105540 <argint>
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
80105fbe:	83 c4 10             	add    $0x10,%esp
80105fc1:	85 c0                	test   %eax,%eax
80105fc3:	78 4b                	js     80106010 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80105fc5:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105fc8:	83 ec 08             	sub    $0x8,%esp
80105fcb:	50                   	push   %eax
80105fcc:	6a 02                	push   $0x2
80105fce:	e8 6d f5 ff ff       	call   80105540 <argint>
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
80105fd3:	83 c4 10             	add    $0x10,%esp
80105fd6:	85 c0                	test   %eax,%eax
80105fd8:	78 36                	js     80106010 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105fda:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
80105fde:	83 ec 0c             	sub    $0xc,%esp
80105fe1:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105fe5:	ba 03 00 00 00       	mov    $0x3,%edx
80105fea:	50                   	push   %eax
80105feb:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105fee:	e8 9d f6 ff ff       	call   80105690 <create>
80105ff3:	83 c4 10             	add    $0x10,%esp
80105ff6:	85 c0                	test   %eax,%eax
80105ff8:	74 16                	je     80106010 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
    return -1;
  }
  iunlockput(ip);
80105ffa:	83 ec 0c             	sub    $0xc,%esp
80105ffd:	50                   	push   %eax
80105ffe:	e8 4d bb ff ff       	call   80101b50 <iunlockput>
  end_op();
80106003:	e8 08 ce ff ff       	call   80102e10 <end_op>
  return 0;
80106008:	83 c4 10             	add    $0x10,%esp
8010600b:	31 c0                	xor    %eax,%eax
}
8010600d:	c9                   	leave  
8010600e:	c3                   	ret    
8010600f:	90                   	nop
  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
80106010:	e8 fb cd ff ff       	call   80102e10 <end_op>
    return -1;
80106015:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
8010601a:	c9                   	leave  
8010601b:	c3                   	ret    
8010601c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106020 <sys_chdir>:

int
sys_chdir(void)
{
80106020:	55                   	push   %ebp
80106021:	89 e5                	mov    %esp,%ebp
80106023:	56                   	push   %esi
80106024:	53                   	push   %ebx
80106025:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80106028:	e8 03 da ff ff       	call   80103a30 <myproc>
8010602d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010602f:	e8 6c cd ff ff       	call   80102da0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80106034:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106037:	83 ec 08             	sub    $0x8,%esp
8010603a:	50                   	push   %eax
8010603b:	6a 00                	push   $0x0
8010603d:	e8 ae f5 ff ff       	call   801055f0 <argstr>
80106042:	83 c4 10             	add    $0x10,%esp
80106045:	85 c0                	test   %eax,%eax
80106047:	78 77                	js     801060c0 <sys_chdir+0xa0>
80106049:	83 ec 0c             	sub    $0xc,%esp
8010604c:	ff 75 f4             	pushl  -0xc(%ebp)
8010604f:	e8 bc c0 ff ff       	call   80102110 <namei>
80106054:	83 c4 10             	add    $0x10,%esp
80106057:	85 c0                	test   %eax,%eax
80106059:	89 c3                	mov    %eax,%ebx
8010605b:	74 63                	je     801060c0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010605d:	83 ec 0c             	sub    $0xc,%esp
80106060:	50                   	push   %eax
80106061:	e8 5a b8 ff ff       	call   801018c0 <ilock>
  if(ip->type != T_DIR){
80106066:	83 c4 10             	add    $0x10,%esp
80106069:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010606e:	75 30                	jne    801060a0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80106070:	83 ec 0c             	sub    $0xc,%esp
80106073:	53                   	push   %ebx
80106074:	e8 27 b9 ff ff       	call   801019a0 <iunlock>
  iput(curproc->cwd);
80106079:	58                   	pop    %eax
8010607a:	ff 76 68             	pushl  0x68(%esi)
8010607d:	e8 6e b9 ff ff       	call   801019f0 <iput>
  end_op();
80106082:	e8 89 cd ff ff       	call   80102e10 <end_op>
  curproc->cwd = ip;
80106087:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010608a:	83 c4 10             	add    $0x10,%esp
8010608d:	31 c0                	xor    %eax,%eax
}
8010608f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106092:	5b                   	pop    %ebx
80106093:	5e                   	pop    %esi
80106094:	5d                   	pop    %ebp
80106095:	c3                   	ret    
80106096:	8d 76 00             	lea    0x0(%esi),%esi
80106099:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    end_op();
    return -1;
  }
  ilock(ip);
  if(ip->type != T_DIR){
    iunlockput(ip);
801060a0:	83 ec 0c             	sub    $0xc,%esp
801060a3:	53                   	push   %ebx
801060a4:	e8 a7 ba ff ff       	call   80101b50 <iunlockput>
    end_op();
801060a9:	e8 62 cd ff ff       	call   80102e10 <end_op>
    return -1;
801060ae:	83 c4 10             	add    $0x10,%esp
801060b1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801060b6:	eb d7                	jmp    8010608f <sys_chdir+0x6f>
801060b8:	90                   	nop
801060b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  struct inode *ip;
  struct proc *curproc = myproc();
  
  begin_op();
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
    end_op();
801060c0:	e8 4b cd ff ff       	call   80102e10 <end_op>
    return -1;
801060c5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801060ca:	eb c3                	jmp    8010608f <sys_chdir+0x6f>
801060cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801060d0 <sys_exec>:
  return 0;
}

int
sys_exec(void)
{
801060d0:	55                   	push   %ebp
801060d1:	89 e5                	mov    %esp,%ebp
801060d3:	57                   	push   %edi
801060d4:	56                   	push   %esi
801060d5:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801060d6:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
  return 0;
}

int
sys_exec(void)
{
801060dc:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801060e2:	50                   	push   %eax
801060e3:	6a 00                	push   $0x0
801060e5:	e8 06 f5 ff ff       	call   801055f0 <argstr>
801060ea:	83 c4 10             	add    $0x10,%esp
801060ed:	85 c0                	test   %eax,%eax
801060ef:	0f 88 ab 00 00 00    	js     801061a0 <sys_exec+0xd0>
801060f5:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801060fb:	83 ec 08             	sub    $0x8,%esp
801060fe:	50                   	push   %eax
801060ff:	6a 01                	push   $0x1
80106101:	e8 3a f4 ff ff       	call   80105540 <argint>
80106106:	83 c4 10             	add    $0x10,%esp
80106109:	85 c0                	test   %eax,%eax
8010610b:	0f 88 8f 00 00 00    	js     801061a0 <sys_exec+0xd0>
    return -1;
  }
  cprintf("1\n");
80106111:	83 ec 0c             	sub    $0xc,%esp
80106114:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
8010611a:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80106120:	68 81 89 10 80       	push   $0x80108981
  cprintf("%s\n",path);
  memset(argv, 0, sizeof(argv));
80106125:	31 db                	xor    %ebx,%ebx
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  cprintf("1\n");
80106127:	e8 34 a5 ff ff       	call   80100660 <cprintf>
  cprintf("%s\n",path);
8010612c:	58                   	pop    %eax
8010612d:	5a                   	pop    %edx
8010612e:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80106134:	68 84 89 10 80       	push   $0x80108984
80106139:	e8 22 a5 ff ff       	call   80100660 <cprintf>
  memset(argv, 0, sizeof(argv));
8010613e:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80106144:	83 c4 0c             	add    $0xc,%esp
80106147:	68 80 00 00 00       	push   $0x80
8010614c:	6a 00                	push   $0x0
8010614e:	50                   	push   %eax
8010614f:	e8 dc f0 ff ff       	call   80105230 <memset>
80106154:	83 c4 10             	add    $0x10,%esp
80106157:	89 f6                	mov    %esi,%esi
80106159:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  for(i=0;; i++){
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80106160:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80106166:	83 ec 08             	sub    $0x8,%esp
80106169:	57                   	push   %edi
8010616a:	8d 04 98             	lea    (%eax,%ebx,4),%eax
8010616d:	50                   	push   %eax
8010616e:	e8 2d f3 ff ff       	call   801054a0 <fetchint>
80106173:	83 c4 10             	add    $0x10,%esp
80106176:	85 c0                	test   %eax,%eax
80106178:	78 26                	js     801061a0 <sys_exec+0xd0>
      return -1;
    if(uarg == 0){
8010617a:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80106180:	85 c0                	test   %eax,%eax
80106182:	74 2c                	je     801061b0 <sys_exec+0xe0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80106184:	83 ec 08             	sub    $0x8,%esp
80106187:	56                   	push   %esi
80106188:	50                   	push   %eax
80106189:	e8 52 f3 ff ff       	call   801054e0 <fetchstr>
8010618e:	83 c4 10             	add    $0x10,%esp
80106191:	85 c0                	test   %eax,%eax
80106193:	78 0b                	js     801061a0 <sys_exec+0xd0>
    return -1;
  }
  cprintf("1\n");
  cprintf("%s\n",path);
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
80106195:	83 c3 01             	add    $0x1,%ebx
80106198:	83 c6 04             	add    $0x4,%esi
    if(i >= NELEM(argv))
8010619b:	83 fb 20             	cmp    $0x20,%ebx
8010619e:	75 c0                	jne    80106160 <sys_exec+0x90>
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
801061a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
801061a3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
801061a8:	5b                   	pop    %ebx
801061a9:	5e                   	pop    %esi
801061aa:	5f                   	pop    %edi
801061ab:	5d                   	pop    %ebp
801061ac:	c3                   	ret    
801061ad:	8d 76 00             	lea    0x0(%esi),%esi
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
801061b0:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801061b6:	83 ec 08             	sub    $0x8,%esp
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
      argv[i] = 0;
801061b9:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
801061c0:	00 00 00 00 
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
801061c4:	50                   	push   %eax
801061c5:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
801061cb:	e8 40 a8 ff ff       	call   80100a10 <exec>
801061d0:	83 c4 10             	add    $0x10,%esp
}
801061d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801061d6:	5b                   	pop    %ebx
801061d7:	5e                   	pop    %esi
801061d8:	5f                   	pop    %edi
801061d9:	5d                   	pop    %ebp
801061da:	c3                   	ret    
801061db:	90                   	nop
801061dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801061e0 <sys_pipe>:

int
sys_pipe(void)
{
801061e0:	55                   	push   %ebp
801061e1:	89 e5                	mov    %esp,%ebp
801061e3:	57                   	push   %edi
801061e4:	56                   	push   %esi
801061e5:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801061e6:	8d 45 dc             	lea    -0x24(%ebp),%eax
  return exec(path, argv);
}

int
sys_pipe(void)
{
801061e9:	83 ec 20             	sub    $0x20,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801061ec:	6a 08                	push   $0x8
801061ee:	50                   	push   %eax
801061ef:	6a 00                	push   $0x0
801061f1:	e8 9a f3 ff ff       	call   80105590 <argptr>
801061f6:	83 c4 10             	add    $0x10,%esp
801061f9:	85 c0                	test   %eax,%eax
801061fb:	78 4a                	js     80106247 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
801061fd:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106200:	83 ec 08             	sub    $0x8,%esp
80106203:	50                   	push   %eax
80106204:	8d 45 e0             	lea    -0x20(%ebp),%eax
80106207:	50                   	push   %eax
80106208:	e8 33 d2 ff ff       	call   80103440 <pipealloc>
8010620d:	83 c4 10             	add    $0x10,%esp
80106210:	85 c0                	test   %eax,%eax
80106212:	78 33                	js     80106247 <sys_pipe+0x67>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80106214:	31 db                	xor    %ebx,%ebx
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80106216:	8b 7d e0             	mov    -0x20(%ebp),%edi
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
80106219:	e8 12 d8 ff ff       	call   80103a30 <myproc>
8010621e:	66 90                	xchg   %ax,%ax

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
80106220:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80106224:	85 f6                	test   %esi,%esi
80106226:	74 30                	je     80106258 <sys_pipe+0x78>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80106228:	83 c3 01             	add    $0x1,%ebx
8010622b:	83 fb 10             	cmp    $0x10,%ebx
8010622e:	75 f0                	jne    80106220 <sys_pipe+0x40>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80106230:	83 ec 0c             	sub    $0xc,%esp
80106233:	ff 75 e0             	pushl  -0x20(%ebp)
80106236:	e8 55 ae ff ff       	call   80101090 <fileclose>
    fileclose(wf);
8010623b:	58                   	pop    %eax
8010623c:	ff 75 e4             	pushl  -0x1c(%ebp)
8010623f:	e8 4c ae ff ff       	call   80101090 <fileclose>
    return -1;
80106244:	83 c4 10             	add    $0x10,%esp
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
80106247:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
8010624a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
8010624f:	5b                   	pop    %ebx
80106250:	5e                   	pop    %esi
80106251:	5f                   	pop    %edi
80106252:	5d                   	pop    %ebp
80106253:	c3                   	ret    
80106254:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80106258:	8d 73 08             	lea    0x8(%ebx),%esi
8010625b:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
8010625f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
80106262:	e8 c9 d7 ff ff       	call   80103a30 <myproc>

  for(fd = 0; fd < NOFILE; fd++){
80106267:	31 d2                	xor    %edx,%edx
80106269:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80106270:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80106274:	85 c9                	test   %ecx,%ecx
80106276:	74 18                	je     80106290 <sys_pipe+0xb0>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80106278:	83 c2 01             	add    $0x1,%edx
8010627b:	83 fa 10             	cmp    $0x10,%edx
8010627e:	75 f0                	jne    80106270 <sys_pipe+0x90>
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
80106280:	e8 ab d7 ff ff       	call   80103a30 <myproc>
80106285:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
8010628c:	00 
8010628d:	eb a1                	jmp    80106230 <sys_pipe+0x50>
8010628f:	90                   	nop
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80106290:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80106294:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106297:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80106299:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010629c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
}
8010629f:	8d 65 f4             	lea    -0xc(%ebp),%esp
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
801062a2:	31 c0                	xor    %eax,%eax
}
801062a4:	5b                   	pop    %ebx
801062a5:	5e                   	pop    %esi
801062a6:	5f                   	pop    %edi
801062a7:	5d                   	pop    %ebp
801062a8:	c3                   	ret    
801062a9:	66 90                	xchg   %ax,%ax
801062ab:	66 90                	xchg   %ax,%ax
801062ad:	66 90                	xchg   %ax,%ax
801062af:	90                   	nop

801062b0 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
801062b0:	55                   	push   %ebp
801062b1:	89 e5                	mov    %esp,%ebp
  return fork();
}
801062b3:	5d                   	pop    %ebp
#include "proc.h"

int
sys_fork(void)
{
  return fork();
801062b4:	e9 27 d9 ff ff       	jmp    80103be0 <fork>
801062b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801062c0 <sys_exit>:
}

int
sys_exit(void)
{
801062c0:	55                   	push   %ebp
801062c1:	89 e5                	mov    %esp,%ebp
801062c3:	83 ec 08             	sub    $0x8,%esp
  exit();
801062c6:	e8 85 df ff ff       	call   80104250 <exit>
  return 0;  // not reached
}
801062cb:	31 c0                	xor    %eax,%eax
801062cd:	c9                   	leave  
801062ce:	c3                   	ret    
801062cf:	90                   	nop

801062d0 <sys_wait>:

int
sys_wait(void)
{
801062d0:	55                   	push   %ebp
801062d1:	89 e5                	mov    %esp,%ebp
  return wait();
}
801062d3:	5d                   	pop    %ebp
}

int
sys_wait(void)
{
  return wait();
801062d4:	e9 b7 e1 ff ff       	jmp    80104490 <wait>
801062d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801062e0 <sys_kill>:
}

int
sys_kill(void)
{
801062e0:	55                   	push   %ebp
801062e1:	89 e5                	mov    %esp,%ebp
801062e3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
801062e6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801062e9:	50                   	push   %eax
801062ea:	6a 00                	push   $0x0
801062ec:	e8 4f f2 ff ff       	call   80105540 <argint>
801062f1:	83 c4 10             	add    $0x10,%esp
801062f4:	85 c0                	test   %eax,%eax
801062f6:	78 18                	js     80106310 <sys_kill+0x30>
    return -1;
  return kill(pid);
801062f8:	83 ec 0c             	sub    $0xc,%esp
801062fb:	ff 75 f4             	pushl  -0xc(%ebp)
801062fe:	e8 ed e2 ff ff       	call   801045f0 <kill>
80106303:	83 c4 10             	add    $0x10,%esp
}
80106306:	c9                   	leave  
80106307:	c3                   	ret    
80106308:	90                   	nop
80106309:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
80106310:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return kill(pid);
}
80106315:	c9                   	leave  
80106316:	c3                   	ret    
80106317:	89 f6                	mov    %esi,%esi
80106319:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106320 <sys_getpid>:

int
sys_getpid(void)
{
80106320:	55                   	push   %ebp
80106321:	89 e5                	mov    %esp,%ebp
80106323:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80106326:	e8 05 d7 ff ff       	call   80103a30 <myproc>
8010632b:	8b 40 10             	mov    0x10(%eax),%eax
}
8010632e:	c9                   	leave  
8010632f:	c3                   	ret    

80106330 <sys_get_parent_id>:

int
sys_get_parent_id(void)
{
80106330:	55                   	push   %ebp
80106331:	89 e5                	mov    %esp,%ebp
80106333:	83 ec 08             	sub    $0x8,%esp
  return myproc()->queuenum;
80106336:	e8 f5 d6 ff ff       	call   80103a30 <myproc>
8010633b:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
}
80106341:	c9                   	leave  
80106342:	c3                   	ret    
80106343:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106349:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106350 <sys_getchildren>:

int
sys_getchildren(void)
{
80106350:	55                   	push   %ebp
80106351:	89 e5                	mov    %esp,%ebp
80106353:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80106356:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106359:	50                   	push   %eax
8010635a:	6a 00                	push   $0x0
8010635c:	e8 df f1 ff ff       	call   80105540 <argint>
80106361:	83 c4 10             	add    $0x10,%esp
80106364:	85 c0                	test   %eax,%eax
80106366:	78 18                	js     80106380 <sys_getchildren+0x30>
    return -1;
  return getchildren(pid);
80106368:	83 ec 0c             	sub    $0xc,%esp
8010636b:	ff 75 f4             	pushl  -0xc(%ebp)
8010636e:	e8 cd e3 ff ff       	call   80104740 <getchildren>
80106373:	83 c4 10             	add    $0x10,%esp
}
80106376:	c9                   	leave  
80106377:	c3                   	ret    
80106378:	90                   	nop
80106379:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
sys_getchildren(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
80106380:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return getchildren(pid);
}
80106385:	c9                   	leave  
80106386:	c3                   	ret    
80106387:	89 f6                	mov    %esi,%esi
80106389:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106390 <sys_sbrk>:


int
sys_sbrk(void)
{
80106390:	55                   	push   %ebp
80106391:	89 e5                	mov    %esp,%ebp
80106393:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80106394:	8d 45 f4             	lea    -0xc(%ebp),%eax
}


int
sys_sbrk(void)
{
80106397:	83 ec 1c             	sub    $0x1c,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
8010639a:	50                   	push   %eax
8010639b:	6a 00                	push   $0x0
8010639d:	e8 9e f1 ff ff       	call   80105540 <argint>
801063a2:	83 c4 10             	add    $0x10,%esp
801063a5:	85 c0                	test   %eax,%eax
801063a7:	78 27                	js     801063d0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
801063a9:	e8 82 d6 ff ff       	call   80103a30 <myproc>
  if(growproc(n) < 0)
801063ae:	83 ec 0c             	sub    $0xc,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
801063b1:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
801063b3:	ff 75 f4             	pushl  -0xc(%ebp)
801063b6:	e8 a5 d7 ff ff       	call   80103b60 <growproc>
801063bb:	83 c4 10             	add    $0x10,%esp
801063be:	85 c0                	test   %eax,%eax
801063c0:	78 0e                	js     801063d0 <sys_sbrk+0x40>
    return -1;
  return addr;
801063c2:	89 d8                	mov    %ebx,%eax
}
801063c4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801063c7:	c9                   	leave  
801063c8:	c3                   	ret    
801063c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
801063d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801063d5:	eb ed                	jmp    801063c4 <sys_sbrk+0x34>
801063d7:	89 f6                	mov    %esi,%esi
801063d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801063e0 <sys_sleep>:
  return addr;
}

int
sys_sleep(void)
{
801063e0:	55                   	push   %ebp
801063e1:	89 e5                	mov    %esp,%ebp
801063e3:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
801063e4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  return addr;
}

int
sys_sleep(void)
{
801063e7:	83 ec 1c             	sub    $0x1c,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
801063ea:	50                   	push   %eax
801063eb:	6a 00                	push   $0x0
801063ed:	e8 4e f1 ff ff       	call   80105540 <argint>
801063f2:	83 c4 10             	add    $0x10,%esp
801063f5:	85 c0                	test   %eax,%eax
801063f7:	0f 88 8a 00 00 00    	js     80106487 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
801063fd:	83 ec 0c             	sub    $0xc,%esp
80106400:	68 20 5e 11 80       	push   $0x80115e20
80106405:	e8 26 ed ff ff       	call   80105130 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010640a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010640d:	83 c4 10             	add    $0x10,%esp
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
80106410:	8b 1d 60 66 11 80    	mov    0x80116660,%ebx
  while(ticks - ticks0 < n){
80106416:	85 d2                	test   %edx,%edx
80106418:	75 27                	jne    80106441 <sys_sleep+0x61>
8010641a:	eb 54                	jmp    80106470 <sys_sleep+0x90>
8010641c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80106420:	83 ec 08             	sub    $0x8,%esp
80106423:	68 20 5e 11 80       	push   $0x80115e20
80106428:	68 60 66 11 80       	push   $0x80116660
8010642d:	e8 9e df ff ff       	call   801043d0 <sleep>

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80106432:	a1 60 66 11 80       	mov    0x80116660,%eax
80106437:	83 c4 10             	add    $0x10,%esp
8010643a:	29 d8                	sub    %ebx,%eax
8010643c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010643f:	73 2f                	jae    80106470 <sys_sleep+0x90>
    if(myproc()->killed){
80106441:	e8 ea d5 ff ff       	call   80103a30 <myproc>
80106446:	8b 40 24             	mov    0x24(%eax),%eax
80106449:	85 c0                	test   %eax,%eax
8010644b:	74 d3                	je     80106420 <sys_sleep+0x40>
      release(&tickslock);
8010644d:	83 ec 0c             	sub    $0xc,%esp
80106450:	68 20 5e 11 80       	push   $0x80115e20
80106455:	e8 86 ed ff ff       	call   801051e0 <release>
      return -1;
8010645a:	83 c4 10             	add    $0x10,%esp
8010645d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}
80106462:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106465:	c9                   	leave  
80106466:	c3                   	ret    
80106467:	89 f6                	mov    %esi,%esi
80106469:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
80106470:	83 ec 0c             	sub    $0xc,%esp
80106473:	68 20 5e 11 80       	push   $0x80115e20
80106478:	e8 63 ed ff ff       	call   801051e0 <release>
  return 0;
8010647d:	83 c4 10             	add    $0x10,%esp
80106480:	31 c0                	xor    %eax,%eax
}
80106482:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106485:	c9                   	leave  
80106486:	c3                   	ret    
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
80106487:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010648c:	eb d4                	jmp    80106462 <sys_sleep+0x82>
8010648e:	66 90                	xchg   %ax,%ax

80106490 <sys_sleepp>:
  return 0;
}

int
sys_sleepp(void)
{
80106490:	55                   	push   %ebp
80106491:	89 e5                	mov    %esp,%ebp
80106493:	53                   	push   %ebx
  struct rtcdate r1;
struct rtcdate r2;
  int n=10;
  argint(0 , &n);
80106494:	8d 45 c4             	lea    -0x3c(%ebp),%eax
  return 0;
}

int
sys_sleepp(void)
{
80106497:	83 ec 4c             	sub    $0x4c,%esp
  struct rtcdate r1;
struct rtcdate r2;
  int n=10;
8010649a:	c7 45 c4 0a 00 00 00 	movl   $0xa,-0x3c(%ebp)
  argint(0 , &n);
801064a1:	50                   	push   %eax
801064a2:	6a 00                	push   $0x0
801064a4:	e8 97 f0 ff ff       	call   80105540 <argint>
  
  uint ticks0;
  cmostime(&r1);
801064a9:	8d 45 c8             	lea    -0x38(%ebp),%eax
801064ac:	89 04 24             	mov    %eax,(%esp)
801064af:	e8 6c c5 ff ff       	call   80102a20 <cmostime>
  cprintf("start second:%d\n" , r1.second);
801064b4:	58                   	pop    %eax
801064b5:	5a                   	pop    %edx
801064b6:	ff 75 c8             	pushl  -0x38(%ebp)
801064b9:	68 88 89 10 80       	push   $0x80108988
801064be:	e8 9d a1 ff ff       	call   80100660 <cprintf>
  cprintf("start mintute:%d\n" , r1.minute);
801064c3:	59                   	pop    %ecx
801064c4:	5b                   	pop    %ebx
801064c5:	ff 75 cc             	pushl  -0x34(%ebp)
801064c8:	68 99 89 10 80       	push   $0x80108999
801064cd:	e8 8e a1 ff ff       	call   80100660 <cprintf>
 
  acquire(&tickslock);
801064d2:	c7 04 24 20 5e 11 80 	movl   $0x80115e20,(%esp)
801064d9:	e8 52 ec ff ff       	call   80105130 <acquire>
  ticks0 = ticks;
 
  
  while(ticks - ticks0 < 100*n){
801064de:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801064e1:	83 c4 10             	add    $0x10,%esp
  cmostime(&r1);
  cprintf("start second:%d\n" , r1.second);
  cprintf("start mintute:%d\n" , r1.minute);
 
  acquire(&tickslock);
  ticks0 = ticks;
801064e4:	8b 1d 60 66 11 80    	mov    0x80116660,%ebx
 
  
  while(ticks - ticks0 < 100*n){
801064ea:	85 c0                	test   %eax,%eax
801064ec:	75 2d                	jne    8010651b <sys_sleepp+0x8b>
801064ee:	eb 58                	jmp    80106548 <sys_sleepp+0xb8>
 
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    release(&tickslock);
801064f0:	83 ec 0c             	sub    $0xc,%esp
801064f3:	68 20 5e 11 80       	push   $0x80115e20
801064f8:	e8 e3 ec ff ff       	call   801051e0 <release>
    acquire(&tickslock);
801064fd:	c7 04 24 20 5e 11 80 	movl   $0x80115e20,(%esp)
80106504:	e8 27 ec ff ff       	call   80105130 <acquire>
 
  acquire(&tickslock);
  ticks0 = ticks;
 
  
  while(ticks - ticks0 < 100*n){
80106509:	6b 55 c4 64          	imul   $0x64,-0x3c(%ebp),%edx
8010650d:	a1 60 66 11 80       	mov    0x80116660,%eax
80106512:	83 c4 10             	add    $0x10,%esp
80106515:	29 d8                	sub    %ebx,%eax
80106517:	39 d0                	cmp    %edx,%eax
80106519:	73 2d                	jae    80106548 <sys_sleepp+0xb8>
 
    if(myproc()->killed){
8010651b:	e8 10 d5 ff ff       	call   80103a30 <myproc>
80106520:	8b 40 24             	mov    0x24(%eax),%eax
80106523:	85 c0                	test   %eax,%eax
80106525:	74 c9                	je     801064f0 <sys_sleepp+0x60>
      release(&tickslock);
80106527:	83 ec 0c             	sub    $0xc,%esp
8010652a:	68 20 5e 11 80       	push   $0x80115e20
8010652f:	e8 ac ec ff ff       	call   801051e0 <release>
      return -1;
80106534:	83 c4 10             	add    $0x10,%esp
80106537:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 }
  else{
   cprintf("ekhtelaf daqiqe:%d sanie:%d\n" , r2.minute - r1.minute -1 ,60 + ( r2.second - r1.second));
 }
  return 0;
}
8010653c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010653f:	c9                   	leave  
80106540:	c3                   	ret    
80106541:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      return -1;
    }
    release(&tickslock);
    acquire(&tickslock);
  }
  release(&tickslock);
80106548:	83 ec 0c             	sub    $0xc,%esp
8010654b:	68 20 5e 11 80       	push   $0x80115e20
80106550:	e8 8b ec ff ff       	call   801051e0 <release>
  cmostime(&r2);
80106555:	8d 45 e0             	lea    -0x20(%ebp),%eax
80106558:	89 04 24             	mov    %eax,(%esp)
8010655b:	e8 c0 c4 ff ff       	call   80102a20 <cmostime>
  cprintf("end second:%d\n" , r2.second);
80106560:	5a                   	pop    %edx
80106561:	59                   	pop    %ecx
80106562:	ff 75 e0             	pushl  -0x20(%ebp)
80106565:	68 ab 89 10 80       	push   $0x801089ab
8010656a:	e8 f1 a0 ff ff       	call   80100660 <cprintf>
  cprintf("end mintute:%d\n" , r2.minute);
8010656f:	5b                   	pop    %ebx
80106570:	58                   	pop    %eax
80106571:	ff 75 e4             	pushl  -0x1c(%ebp)
80106574:	68 ba 89 10 80       	push   $0x801089ba
80106579:	e8 e2 a0 ff ff       	call   80100660 <cprintf>
  if( r2.second >= r1.second){
8010657e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106581:	8b 55 c8             	mov    -0x38(%ebp),%edx
80106584:	83 c4 10             	add    $0x10,%esp
80106587:	39 d0                	cmp    %edx,%eax
80106589:	73 2d                	jae    801065b8 <sys_sleepp+0x128>
   cprintf("ekhtelaf daqiqe:%d sanie:%d\n" , r2.minute - r1.minute , r2.second - r1.second);
 }
  else{
   cprintf("ekhtelaf daqiqe:%d sanie:%d\n" , r2.minute - r1.minute -1 ,60 + ( r2.second - r1.second));
8010658b:	83 c0 3c             	add    $0x3c,%eax
8010658e:	83 ec 04             	sub    $0x4,%esp
80106591:	29 d0                	sub    %edx,%eax
80106593:	50                   	push   %eax
80106594:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106597:	83 e8 01             	sub    $0x1,%eax
8010659a:	2b 45 cc             	sub    -0x34(%ebp),%eax
8010659d:	50                   	push   %eax
8010659e:	68 ca 89 10 80       	push   $0x801089ca
801065a3:	e8 b8 a0 ff ff       	call   80100660 <cprintf>
801065a8:	83 c4 10             	add    $0x10,%esp
 }
  return 0;
801065ab:	31 c0                	xor    %eax,%eax
}
801065ad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801065b0:	c9                   	leave  
801065b1:	c3                   	ret    
801065b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&tickslock);
  cmostime(&r2);
  cprintf("end second:%d\n" , r2.second);
  cprintf("end mintute:%d\n" , r2.minute);
  if( r2.second >= r1.second){
   cprintf("ekhtelaf daqiqe:%d sanie:%d\n" , r2.minute - r1.minute , r2.second - r1.second);
801065b8:	29 d0                	sub    %edx,%eax
801065ba:	83 ec 04             	sub    $0x4,%esp
801065bd:	50                   	push   %eax
801065be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801065c1:	eb d7                	jmp    8010659a <sys_sleepp+0x10a>
801065c3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801065c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801065d0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801065d0:	55                   	push   %ebp
801065d1:	89 e5                	mov    %esp,%ebp
801065d3:	53                   	push   %ebx
801065d4:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
801065d7:	68 20 5e 11 80       	push   $0x80115e20
801065dc:	e8 4f eb ff ff       	call   80105130 <acquire>
  xticks = ticks;
801065e1:	8b 1d 60 66 11 80    	mov    0x80116660,%ebx
  release(&tickslock);
801065e7:	c7 04 24 20 5e 11 80 	movl   $0x80115e20,(%esp)
801065ee:	e8 ed eb ff ff       	call   801051e0 <release>
  return xticks;
}
801065f3:	89 d8                	mov    %ebx,%eax
801065f5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801065f8:	c9                   	leave  
801065f9:	c3                   	ret    
801065fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106600 <sys_cmos>:
void
sys_cmos(void)
{
80106600:	55                   	push   %ebp
80106601:	89 e5                	mov    %esp,%ebp
80106603:	83 ec 34             	sub    $0x34,%esp
  struct rtcdate r;
  cmostime(&r);
80106606:	8d 45 e0             	lea    -0x20(%ebp),%eax
80106609:	50                   	push   %eax
8010660a:	e8 11 c4 ff ff       	call   80102a20 <cmostime>
  cprintf("second:%d\n" , r.second);
8010660f:	58                   	pop    %eax
80106610:	5a                   	pop    %edx
80106611:	ff 75 e0             	pushl  -0x20(%ebp)
80106614:	68 af 89 10 80       	push   $0x801089af
80106619:	e8 42 a0 ff ff       	call   80100660 <cprintf>
  cprintf("mintute:%d\n" , r.minute);
8010661e:	59                   	pop    %ecx
8010661f:	58                   	pop    %eax
80106620:	ff 75 e4             	pushl  -0x1c(%ebp)
80106623:	68 be 89 10 80       	push   $0x801089be
80106628:	e8 33 a0 ff ff       	call   80100660 <cprintf>
}
8010662d:	83 c4 10             	add    $0x10,%esp
80106630:	c9                   	leave  
80106631:	c3                   	ret    
80106632:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106639:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106640 <sys_set>:


int
sys_set(void)
{       
80106640:	55                   	push   %ebp
80106641:	89 e5                	mov    %esp,%ebp
80106643:	83 ec 10             	sub    $0x10,%esp
        argstr(0,&spath);
80106646:	68 18 0f 11 80       	push   $0x80110f18
8010664b:	6a 00                	push   $0x0
8010664d:	e8 9e ef ff ff       	call   801055f0 <argstr>
	return set(spath);
80106652:	58                   	pop    %eax
80106653:	ff 35 18 0f 11 80    	pushl  0x80110f18
80106659:	e8 b2 e2 ff ff       	call   80104910 <set>
}
8010665e:	c9                   	leave  
8010665f:	c3                   	ret    

80106660 <sys_count>:

int sys_count(void)
{
80106660:	55                   	push   %ebp
80106661:	89 e5                	mov    %esp,%ebp
80106663:	83 ec 08             	sub    $0x8,%esp
	int num,m;
	num=myproc()->tf->esi;
80106666:	e8 c5 d3 ff ff       	call   80103a30 <myproc>
8010666b:	8b 40 18             	mov    0x18(%eax),%eax
	m=count(num);
8010666e:	83 ec 0c             	sub    $0xc,%esp
80106671:	ff 70 04             	pushl  0x4(%eax)
80106674:	e8 77 e3 ff ff       	call   801049f0 <count>
	return m;

}
80106679:	c9                   	leave  
8010667a:	c3                   	ret    
8010667b:	90                   	nop
8010667c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106680 <sys_chqueue>:

int sys_chqueue(void){
80106680:	55                   	push   %ebp
80106681:	89 e5                	mov    %esp,%ebp
80106683:	53                   	push   %ebx

        int pid,queuenum;

	if(argint(0, &pid) < 0)
80106684:	8d 45 f0             	lea    -0x10(%ebp),%eax
	m=count(num);
	return m;

}

int sys_chqueue(void){
80106687:	83 ec 1c             	sub    $0x1c,%esp

        int pid,queuenum;

	if(argint(0, &pid) < 0)
8010668a:	50                   	push   %eax
8010668b:	6a 00                	push   $0x0
8010668d:	e8 ae ee ff ff       	call   80105540 <argint>
80106692:	83 c4 10             	add    $0x10,%esp
80106695:	85 c0                	test   %eax,%eax
80106697:	78 42                	js     801066db <sys_chqueue+0x5b>
	   return -1;

        if((argint(1, &queuenum) < 1) && (argint(1, &queuenum) > 3))
80106699:	8d 5d f4             	lea    -0xc(%ebp),%ebx
8010669c:	83 ec 08             	sub    $0x8,%esp
8010669f:	53                   	push   %ebx
801066a0:	6a 01                	push   $0x1
801066a2:	e8 99 ee ff ff       	call   80105540 <argint>
801066a7:	83 c4 10             	add    $0x10,%esp
801066aa:	85 c0                	test   %eax,%eax
801066ac:	7e 1a                	jle    801066c8 <sys_chqueue+0x48>
           return -1;
	 
        return chqueue(pid,queuenum);      
801066ae:	83 ec 08             	sub    $0x8,%esp
801066b1:	ff 75 f4             	pushl  -0xc(%ebp)
801066b4:	ff 75 f0             	pushl  -0x10(%ebp)
801066b7:	e8 84 e3 ff ff       	call   80104a40 <chqueue>
801066bc:	83 c4 10             	add    $0x10,%esp


}
801066bf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801066c2:	c9                   	leave  
801066c3:	c3                   	ret    
801066c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        int pid,queuenum;

	if(argint(0, &pid) < 0)
	   return -1;

        if((argint(1, &queuenum) < 1) && (argint(1, &queuenum) > 3))
801066c8:	83 ec 08             	sub    $0x8,%esp
801066cb:	53                   	push   %ebx
801066cc:	6a 01                	push   $0x1
801066ce:	e8 6d ee ff ff       	call   80105540 <argint>
801066d3:	83 c4 10             	add    $0x10,%esp
801066d6:	83 f8 03             	cmp    $0x3,%eax
801066d9:	7e d3                	jle    801066ae <sys_chqueue+0x2e>
int sys_chqueue(void){

        int pid,queuenum;

	if(argint(0, &pid) < 0)
	   return -1;
801066db:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801066e0:	eb dd                	jmp    801066bf <sys_chqueue+0x3f>
801066e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801066e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801066f0 <sys_setLottery>:


}


int sys_setLottery(void){
801066f0:	55                   	push   %ebp
801066f1:	89 e5                	mov    %esp,%ebp
801066f3:	83 ec 20             	sub    $0x20,%esp

        int pid,tickets;
	if(argint(0, &pid) < 0)
801066f6:	8d 45 f0             	lea    -0x10(%ebp),%eax
801066f9:	50                   	push   %eax
801066fa:	6a 00                	push   $0x0
801066fc:	e8 3f ee ff ff       	call   80105540 <argint>
80106701:	83 c4 10             	add    $0x10,%esp
80106704:	85 c0                	test   %eax,%eax
80106706:	78 28                	js     80106730 <sys_setLottery+0x40>
	   return -1;

        argint(1, &tickets);
80106708:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010670b:	83 ec 08             	sub    $0x8,%esp
8010670e:	50                   	push   %eax
8010670f:	6a 01                	push   $0x1
80106711:	e8 2a ee ff ff       	call   80105540 <argint>


	 
        return setLottery(pid,tickets);
80106716:	58                   	pop    %eax
80106717:	5a                   	pop    %edx
80106718:	ff 75 f4             	pushl  -0xc(%ebp)
8010671b:	ff 75 f0             	pushl  -0x10(%ebp)
8010671e:	e8 6d e3 ff ff       	call   80104a90 <setLottery>
80106723:	83 c4 10             	add    $0x10,%esp


}
80106726:	c9                   	leave  
80106727:	c3                   	ret    
80106728:	90                   	nop
80106729:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

int sys_setLottery(void){

        int pid,tickets;
	if(argint(0, &pid) < 0)
	   return -1;
80106730:	b8 ff ff ff ff       	mov    $0xffffffff,%eax

	 
        return setLottery(pid,tickets);


}
80106735:	c9                   	leave  
80106736:	c3                   	ret    
80106737:	89 f6                	mov    %esi,%esi
80106739:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106740 <sys_chprSRPF>:


int sys_chprSRPF(void){
80106740:	55                   	push   %ebp
80106741:	89 e5                	mov    %esp,%ebp
80106743:	83 ec 20             	sub    $0x20,%esp

        int pid,priority;
	if(argint(0, &pid) < 0)
80106746:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106749:	50                   	push   %eax
8010674a:	6a 00                	push   $0x0
8010674c:	e8 ef ed ff ff       	call   80105540 <argint>
80106751:	83 c4 10             	add    $0x10,%esp
80106754:	85 c0                	test   %eax,%eax
80106756:	78 28                	js     80106780 <sys_chprSRPF+0x40>
	   return -1;

        argint(1, &priority);
80106758:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010675b:	83 ec 08             	sub    $0x8,%esp
8010675e:	50                   	push   %eax
8010675f:	6a 01                	push   $0x1
80106761:	e8 da ed ff ff       	call   80105540 <argint>
	 
        return chprSRPF(pid,priority);      
80106766:	58                   	pop    %eax
80106767:	5a                   	pop    %edx
80106768:	ff 75 f4             	pushl  -0xc(%ebp)
8010676b:	ff 75 f0             	pushl  -0x10(%ebp)
8010676e:	e8 6d e5 ff ff       	call   80104ce0 <chprSRPF>
80106773:	83 c4 10             	add    $0x10,%esp


}
80106776:	c9                   	leave  
80106777:	c3                   	ret    
80106778:	90                   	nop
80106779:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

int sys_chprSRPF(void){

        int pid,priority;
	if(argint(0, &pid) < 0)
	   return -1;
80106780:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
        argint(1, &priority);
	 
        return chprSRPF(pid,priority);      


}
80106785:	c9                   	leave  
80106786:	c3                   	ret    
80106787:	89 f6                	mov    %esi,%esi
80106789:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106790 <sys_printinfo>:


int sys_printinfo(void){
80106790:	55                   	push   %ebp
80106791:	89 e5                	mov    %esp,%ebp
	 
        return printinfo();      

}
80106793:	5d                   	pop    %ebp
}


int sys_printinfo(void){
	 
        return printinfo();      
80106794:	e9 97 e5 ff ff       	jmp    80104d30 <printinfo>

80106799 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80106799:	1e                   	push   %ds
  pushl %es
8010679a:	06                   	push   %es
  pushl %fs
8010679b:	0f a0                	push   %fs
  pushl %gs
8010679d:	0f a8                	push   %gs
  pushal
8010679f:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
801067a0:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
801067a4:	8e d8                	mov    %eax,%ds
  movw %ax, %es
801067a6:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
801067a8:	54                   	push   %esp
  call trap
801067a9:	e8 e2 00 00 00       	call   80106890 <trap>
  addl $4, %esp
801067ae:	83 c4 04             	add    $0x4,%esp

801067b1 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
801067b1:	61                   	popa   
  popl %gs
801067b2:	0f a9                	pop    %gs
  popl %fs
801067b4:	0f a1                	pop    %fs
  popl %es
801067b6:	07                   	pop    %es
  popl %ds
801067b7:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
801067b8:	83 c4 08             	add    $0x8,%esp
  iret
801067bb:	cf                   	iret   
801067bc:	66 90                	xchg   %ax,%ax
801067be:	66 90                	xchg   %ax,%ax

801067c0 <tvinit>:
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
801067c0:	31 c0                	xor    %eax,%eax
801067c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
801067c8:	8b 14 85 0c b0 10 80 	mov    -0x7fef4ff4(,%eax,4),%edx
801067cf:	b9 08 00 00 00       	mov    $0x8,%ecx
801067d4:	c6 04 c5 64 5e 11 80 	movb   $0x0,-0x7feea19c(,%eax,8)
801067db:	00 
801067dc:	66 89 0c c5 62 5e 11 	mov    %cx,-0x7feea19e(,%eax,8)
801067e3:	80 
801067e4:	c6 04 c5 65 5e 11 80 	movb   $0x8e,-0x7feea19b(,%eax,8)
801067eb:	8e 
801067ec:	66 89 14 c5 60 5e 11 	mov    %dx,-0x7feea1a0(,%eax,8)
801067f3:	80 
801067f4:	c1 ea 10             	shr    $0x10,%edx
801067f7:	66 89 14 c5 66 5e 11 	mov    %dx,-0x7feea19a(,%eax,8)
801067fe:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
801067ff:	83 c0 01             	add    $0x1,%eax
80106802:	3d 00 01 00 00       	cmp    $0x100,%eax
80106807:	75 bf                	jne    801067c8 <tvinit+0x8>
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106809:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010680a:	ba 08 00 00 00       	mov    $0x8,%edx
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
8010680f:	89 e5                	mov    %esp,%ebp
80106811:	83 ec 10             	sub    $0x10,%esp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106814:	a1 0c b1 10 80       	mov    0x8010b10c,%eax

  initlock(&tickslock, "time");
80106819:	68 e7 89 10 80       	push   $0x801089e7
8010681e:	68 20 5e 11 80       	push   $0x80115e20
{
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106823:	66 89 15 62 60 11 80 	mov    %dx,0x80116062
8010682a:	c6 05 64 60 11 80 00 	movb   $0x0,0x80116064
80106831:	66 a3 60 60 11 80    	mov    %ax,0x80116060
80106837:	c1 e8 10             	shr    $0x10,%eax
8010683a:	c6 05 65 60 11 80 ef 	movb   $0xef,0x80116065
80106841:	66 a3 66 60 11 80    	mov    %ax,0x80116066

  initlock(&tickslock, "time");
80106847:	e8 84 e7 ff ff       	call   80104fd0 <initlock>
}
8010684c:	83 c4 10             	add    $0x10,%esp
8010684f:	c9                   	leave  
80106850:	c3                   	ret    
80106851:	eb 0d                	jmp    80106860 <idtinit>
80106853:	90                   	nop
80106854:	90                   	nop
80106855:	90                   	nop
80106856:	90                   	nop
80106857:	90                   	nop
80106858:	90                   	nop
80106859:	90                   	nop
8010685a:	90                   	nop
8010685b:	90                   	nop
8010685c:	90                   	nop
8010685d:	90                   	nop
8010685e:	90                   	nop
8010685f:	90                   	nop

80106860 <idtinit>:

void
idtinit(void)
{
80106860:	55                   	push   %ebp
static inline void
lidt(struct gatedesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
80106861:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80106866:	89 e5                	mov    %esp,%ebp
80106868:	83 ec 10             	sub    $0x10,%esp
8010686b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010686f:	b8 60 5e 11 80       	mov    $0x80115e60,%eax
80106874:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106878:	c1 e8 10             	shr    $0x10,%eax
8010687b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
8010687f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106882:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80106885:	c9                   	leave  
80106886:	c3                   	ret    
80106887:	89 f6                	mov    %esi,%esi
80106889:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106890 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106890:	55                   	push   %ebp
80106891:	89 e5                	mov    %esp,%ebp
80106893:	57                   	push   %edi
80106894:	56                   	push   %esi
80106895:	53                   	push   %ebx
80106896:	83 ec 1c             	sub    $0x1c,%esp
80106899:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
8010689c:	8b 47 30             	mov    0x30(%edi),%eax
8010689f:	83 f8 40             	cmp    $0x40,%eax
801068a2:	0f 84 98 01 00 00    	je     80106a40 <trap+0x1b0>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
801068a8:	83 e8 20             	sub    $0x20,%eax
801068ab:	83 f8 1f             	cmp    $0x1f,%eax
801068ae:	77 10                	ja     801068c0 <trap+0x30>
801068b0:	ff 24 85 b0 8a 10 80 	jmp    *-0x7fef7550(,%eax,4)
801068b7:	89 f6                	mov    %esi,%esi
801068b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    cprintf("hiiiiiiiiiiiiiiiiiiiiiiiiiiii\n");
801068c0:	83 ec 0c             	sub    $0xc,%esp
801068c3:	68 18 8a 10 80       	push   $0x80108a18
801068c8:	e8 93 9d ff ff       	call   80100660 <cprintf>
    if(myproc() == 0 || (tf->cs&3) == 0){
801068cd:	e8 5e d1 ff ff       	call   80103a30 <myproc>
801068d2:	83 c4 10             	add    $0x10,%esp
801068d5:	85 c0                	test   %eax,%eax
801068d7:	0f 84 d7 01 00 00    	je     80106ab4 <trap+0x224>
801068dd:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
801068e1:	0f 84 cd 01 00 00    	je     80106ab4 <trap+0x224>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
801068e7:	0f 20 d1             	mov    %cr2,%ecx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801068ea:	8b 57 38             	mov    0x38(%edi),%edx
801068ed:	89 4d d8             	mov    %ecx,-0x28(%ebp)
801068f0:	89 55 dc             	mov    %edx,-0x24(%ebp)
801068f3:	e8 18 d1 ff ff       	call   80103a10 <cpuid>
801068f8:	8b 77 34             	mov    0x34(%edi),%esi
801068fb:	8b 5f 30             	mov    0x30(%edi),%ebx
801068fe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80106901:	e8 2a d1 ff ff       	call   80103a30 <myproc>
80106906:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106909:	e8 22 d1 ff ff       	call   80103a30 <myproc>
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010690e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80106911:	8b 55 dc             	mov    -0x24(%ebp),%edx
80106914:	51                   	push   %ecx
80106915:	52                   	push   %edx
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80106916:	8b 55 e0             	mov    -0x20(%ebp),%edx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106919:	ff 75 e4             	pushl  -0x1c(%ebp)
8010691c:	56                   	push   %esi
8010691d:	53                   	push   %ebx
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
8010691e:	83 c2 6c             	add    $0x6c,%edx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106921:	52                   	push   %edx
80106922:	ff 70 10             	pushl  0x10(%eax)
80106925:	68 6c 8a 10 80       	push   $0x80108a6c
8010692a:	e8 31 9d ff ff       	call   80100660 <cprintf>
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
8010692f:	83 c4 20             	add    $0x20,%esp
80106932:	e8 f9 d0 ff ff       	call   80103a30 <myproc>
80106937:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
8010693e:	66 90                	xchg   %ax,%ax
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106940:	e8 eb d0 ff ff       	call   80103a30 <myproc>
80106945:	85 c0                	test   %eax,%eax
80106947:	74 0c                	je     80106955 <trap+0xc5>
80106949:	e8 e2 d0 ff ff       	call   80103a30 <myproc>
8010694e:	8b 50 24             	mov    0x24(%eax),%edx
80106951:	85 d2                	test   %edx,%edx
80106953:	75 4b                	jne    801069a0 <trap+0x110>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80106955:	e8 d6 d0 ff ff       	call   80103a30 <myproc>
8010695a:	85 c0                	test   %eax,%eax
8010695c:	74 0b                	je     80106969 <trap+0xd9>
8010695e:	e8 cd d0 ff ff       	call   80103a30 <myproc>
80106963:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80106967:	74 4f                	je     801069b8 <trap+0x128>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106969:	e8 c2 d0 ff ff       	call   80103a30 <myproc>
8010696e:	85 c0                	test   %eax,%eax
80106970:	74 1d                	je     8010698f <trap+0xff>
80106972:	e8 b9 d0 ff ff       	call   80103a30 <myproc>
80106977:	8b 40 24             	mov    0x24(%eax),%eax
8010697a:	85 c0                	test   %eax,%eax
8010697c:	74 11                	je     8010698f <trap+0xff>
8010697e:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80106982:	83 e0 03             	and    $0x3,%eax
80106985:	66 83 f8 03          	cmp    $0x3,%ax
80106989:	0f 84 da 00 00 00    	je     80106a69 <trap+0x1d9>
    exit();
}
8010698f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106992:	5b                   	pop    %ebx
80106993:	5e                   	pop    %esi
80106994:	5f                   	pop    %edi
80106995:	5d                   	pop    %ebp
80106996:	c3                   	ret    
80106997:	89 f6                	mov    %esi,%esi
80106999:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801069a0:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
801069a4:	83 e0 03             	and    $0x3,%eax
801069a7:	66 83 f8 03          	cmp    $0x3,%ax
801069ab:	75 a8                	jne    80106955 <trap+0xc5>
    exit();
801069ad:	e8 9e d8 ff ff       	call   80104250 <exit>
801069b2:	eb a1                	jmp    80106955 <trap+0xc5>
801069b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
801069b8:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
801069bc:	75 ab                	jne    80106969 <trap+0xd9>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();
801069be:	e8 bd d9 ff ff       	call   80104380 <yield>
801069c3:	eb a4                	jmp    80106969 <trap+0xd9>
801069c5:	8d 76 00             	lea    0x0(%esi),%esi
    return;
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
801069c8:	e8 43 d0 ff ff       	call   80103a10 <cpuid>
801069cd:	85 c0                	test   %eax,%eax
801069cf:	0f 84 ab 00 00 00    	je     80106a80 <trap+0x1f0>
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
    lapiceoi();
801069d5:	e8 86 bf ff ff       	call   80102960 <lapiceoi>
    break;
801069da:	e9 61 ff ff ff       	jmp    80106940 <trap+0xb0>
801069df:	90                   	nop
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
801069e0:	e8 3b be ff ff       	call   80102820 <kbdintr>
    lapiceoi();
801069e5:	e8 76 bf ff ff       	call   80102960 <lapiceoi>
    break;
801069ea:	e9 51 ff ff ff       	jmp    80106940 <trap+0xb0>
801069ef:	90                   	nop
  case T_IRQ0 + IRQ_COM1:
    uartintr();
801069f0:	e8 5b 02 00 00       	call   80106c50 <uartintr>
    lapiceoi();
801069f5:	e8 66 bf ff ff       	call   80102960 <lapiceoi>
    break;
801069fa:	e9 41 ff ff ff       	jmp    80106940 <trap+0xb0>
801069ff:	90                   	nop
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106a00:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
80106a04:	8b 77 38             	mov    0x38(%edi),%esi
80106a07:	e8 04 d0 ff ff       	call   80103a10 <cpuid>
80106a0c:	56                   	push   %esi
80106a0d:	53                   	push   %ebx
80106a0e:	50                   	push   %eax
80106a0f:	68 f4 89 10 80       	push   $0x801089f4
80106a14:	e8 47 9c ff ff       	call   80100660 <cprintf>
            cpuid(), tf->cs, tf->eip);
    lapiceoi();
80106a19:	e8 42 bf ff ff       	call   80102960 <lapiceoi>
    break;
80106a1e:	83 c4 10             	add    $0x10,%esp
80106a21:	e9 1a ff ff ff       	jmp    80106940 <trap+0xb0>
80106a26:	8d 76 00             	lea    0x0(%esi),%esi
80106a29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80106a30:	e8 6b b8 ff ff       	call   801022a0 <ideintr>
80106a35:	eb 9e                	jmp    801069d5 <trap+0x145>
80106a37:	89 f6                	mov    %esi,%esi
80106a39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(myproc()->killed)
80106a40:	e8 eb cf ff ff       	call   80103a30 <myproc>
80106a45:	8b 58 24             	mov    0x24(%eax),%ebx
80106a48:	85 db                	test   %ebx,%ebx
80106a4a:	75 2c                	jne    80106a78 <trap+0x1e8>
      exit();
    myproc()->tf = tf;
80106a4c:	e8 df cf ff ff       	call   80103a30 <myproc>
80106a51:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
80106a54:	e8 d7 eb ff ff       	call   80105630 <syscall>
    if(myproc()->killed)
80106a59:	e8 d2 cf ff ff       	call   80103a30 <myproc>
80106a5e:	8b 48 24             	mov    0x24(%eax),%ecx
80106a61:	85 c9                	test   %ecx,%ecx
80106a63:	0f 84 26 ff ff ff    	je     8010698f <trap+0xff>
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
    exit();
}
80106a69:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106a6c:	5b                   	pop    %ebx
80106a6d:	5e                   	pop    %esi
80106a6e:	5f                   	pop    %edi
80106a6f:	5d                   	pop    %ebp
    if(myproc()->killed)
      exit();
    myproc()->tf = tf;
    syscall();
    if(myproc()->killed)
      exit();
80106a70:	e9 db d7 ff ff       	jmp    80104250 <exit>
80106a75:	8d 76 00             	lea    0x0(%esi),%esi
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(myproc()->killed)
      exit();
80106a78:	e8 d3 d7 ff ff       	call   80104250 <exit>
80106a7d:	eb cd                	jmp    80106a4c <trap+0x1bc>
80106a7f:	90                   	nop
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
      acquire(&tickslock);
80106a80:	83 ec 0c             	sub    $0xc,%esp
80106a83:	68 20 5e 11 80       	push   $0x80115e20
80106a88:	e8 a3 e6 ff ff       	call   80105130 <acquire>
      ticks++;
      wakeup(&ticks);
80106a8d:	c7 04 24 60 66 11 80 	movl   $0x80116660,(%esp)

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
      acquire(&tickslock);
      ticks++;
80106a94:	83 05 60 66 11 80 01 	addl   $0x1,0x80116660
      wakeup(&ticks);
80106a9b:	e8 f0 da ff ff       	call   80104590 <wakeup>
      release(&tickslock);
80106aa0:	c7 04 24 20 5e 11 80 	movl   $0x80115e20,(%esp)
80106aa7:	e8 34 e7 ff ff       	call   801051e0 <release>
80106aac:	83 c4 10             	add    $0x10,%esp
80106aaf:	e9 21 ff ff ff       	jmp    801069d5 <trap+0x145>
80106ab4:	0f 20 d6             	mov    %cr2,%esi
  //PAGEBREAK: 13
  default:
    cprintf("hiiiiiiiiiiiiiiiiiiiiiiiiiiii\n");
    if(myproc() == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106ab7:	8b 5f 38             	mov    0x38(%edi),%ebx
80106aba:	e8 51 cf ff ff       	call   80103a10 <cpuid>
80106abf:	83 ec 0c             	sub    $0xc,%esp
80106ac2:	56                   	push   %esi
80106ac3:	53                   	push   %ebx
80106ac4:	50                   	push   %eax
80106ac5:	ff 77 30             	pushl  0x30(%edi)
80106ac8:	68 38 8a 10 80       	push   $0x80108a38
80106acd:	e8 8e 9b ff ff       	call   80100660 <cprintf>
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
80106ad2:	83 c4 14             	add    $0x14,%esp
80106ad5:	68 ec 89 10 80       	push   $0x801089ec
80106ada:	e8 91 98 ff ff       	call   80100370 <panic>
80106adf:	90                   	nop

80106ae0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80106ae0:	a1 bc b5 10 80       	mov    0x8010b5bc,%eax
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
80106ae5:	55                   	push   %ebp
80106ae6:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106ae8:	85 c0                	test   %eax,%eax
80106aea:	74 1c                	je     80106b08 <uartgetc+0x28>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106aec:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106af1:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80106af2:	a8 01                	test   $0x1,%al
80106af4:	74 12                	je     80106b08 <uartgetc+0x28>
80106af6:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106afb:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80106afc:	0f b6 c0             	movzbl %al,%eax
}
80106aff:	5d                   	pop    %ebp
80106b00:	c3                   	ret    
80106b01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

static int
uartgetc(void)
{
  if(!uart)
    return -1;
80106b08:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(!(inb(COM1+5) & 0x01))
    return -1;
  return inb(COM1+0);
}
80106b0d:	5d                   	pop    %ebp
80106b0e:	c3                   	ret    
80106b0f:	90                   	nop

80106b10 <uartputc.part.0>:
  for(p="xv6...\n"; *p; p++)
    uartputc(*p);
}

void
uartputc(int c)
80106b10:	55                   	push   %ebp
80106b11:	89 e5                	mov    %esp,%ebp
80106b13:	57                   	push   %edi
80106b14:	56                   	push   %esi
80106b15:	53                   	push   %ebx
80106b16:	89 c7                	mov    %eax,%edi
80106b18:	bb 80 00 00 00       	mov    $0x80,%ebx
80106b1d:	be fd 03 00 00       	mov    $0x3fd,%esi
80106b22:	83 ec 0c             	sub    $0xc,%esp
80106b25:	eb 1b                	jmp    80106b42 <uartputc.part.0+0x32>
80106b27:	89 f6                	mov    %esi,%esi
80106b29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
80106b30:	83 ec 0c             	sub    $0xc,%esp
80106b33:	6a 0a                	push   $0xa
80106b35:	e8 46 be ff ff       	call   80102980 <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106b3a:	83 c4 10             	add    $0x10,%esp
80106b3d:	83 eb 01             	sub    $0x1,%ebx
80106b40:	74 07                	je     80106b49 <uartputc.part.0+0x39>
80106b42:	89 f2                	mov    %esi,%edx
80106b44:	ec                   	in     (%dx),%al
80106b45:	a8 20                	test   $0x20,%al
80106b47:	74 e7                	je     80106b30 <uartputc.part.0+0x20>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106b49:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106b4e:	89 f8                	mov    %edi,%eax
80106b50:	ee                   	out    %al,(%dx)
    microdelay(10);
  outb(COM1+0, c);
}
80106b51:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106b54:	5b                   	pop    %ebx
80106b55:	5e                   	pop    %esi
80106b56:	5f                   	pop    %edi
80106b57:	5d                   	pop    %ebp
80106b58:	c3                   	ret    
80106b59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106b60 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80106b60:	55                   	push   %ebp
80106b61:	31 c9                	xor    %ecx,%ecx
80106b63:	89 c8                	mov    %ecx,%eax
80106b65:	89 e5                	mov    %esp,%ebp
80106b67:	57                   	push   %edi
80106b68:	56                   	push   %esi
80106b69:	53                   	push   %ebx
80106b6a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80106b6f:	89 da                	mov    %ebx,%edx
80106b71:	83 ec 0c             	sub    $0xc,%esp
80106b74:	ee                   	out    %al,(%dx)
80106b75:	bf fb 03 00 00       	mov    $0x3fb,%edi
80106b7a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80106b7f:	89 fa                	mov    %edi,%edx
80106b81:	ee                   	out    %al,(%dx)
80106b82:	b8 0c 00 00 00       	mov    $0xc,%eax
80106b87:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106b8c:	ee                   	out    %al,(%dx)
80106b8d:	be f9 03 00 00       	mov    $0x3f9,%esi
80106b92:	89 c8                	mov    %ecx,%eax
80106b94:	89 f2                	mov    %esi,%edx
80106b96:	ee                   	out    %al,(%dx)
80106b97:	b8 03 00 00 00       	mov    $0x3,%eax
80106b9c:	89 fa                	mov    %edi,%edx
80106b9e:	ee                   	out    %al,(%dx)
80106b9f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106ba4:	89 c8                	mov    %ecx,%eax
80106ba6:	ee                   	out    %al,(%dx)
80106ba7:	b8 01 00 00 00       	mov    $0x1,%eax
80106bac:	89 f2                	mov    %esi,%edx
80106bae:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106baf:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106bb4:	ec                   	in     (%dx),%al
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80106bb5:	3c ff                	cmp    $0xff,%al
80106bb7:	74 5a                	je     80106c13 <uartinit+0xb3>
    return;
  uart = 1;
80106bb9:	c7 05 bc b5 10 80 01 	movl   $0x1,0x8010b5bc
80106bc0:	00 00 00 
80106bc3:	89 da                	mov    %ebx,%edx
80106bc5:	ec                   	in     (%dx),%al
80106bc6:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106bcb:	ec                   	in     (%dx),%al

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);
80106bcc:	83 ec 08             	sub    $0x8,%esp
80106bcf:	bb 30 8b 10 80       	mov    $0x80108b30,%ebx
80106bd4:	6a 00                	push   $0x0
80106bd6:	6a 04                	push   $0x4
80106bd8:	e8 13 b9 ff ff       	call   801024f0 <ioapicenable>
80106bdd:	83 c4 10             	add    $0x10,%esp
80106be0:	b8 78 00 00 00       	mov    $0x78,%eax
80106be5:	eb 13                	jmp    80106bfa <uartinit+0x9a>
80106be7:	89 f6                	mov    %esi,%esi
80106be9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80106bf0:	83 c3 01             	add    $0x1,%ebx
80106bf3:	0f be 03             	movsbl (%ebx),%eax
80106bf6:	84 c0                	test   %al,%al
80106bf8:	74 19                	je     80106c13 <uartinit+0xb3>
void
uartputc(int c)
{
  int i;

  if(!uart)
80106bfa:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
80106c00:	85 d2                	test   %edx,%edx
80106c02:	74 ec                	je     80106bf0 <uartinit+0x90>
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80106c04:	83 c3 01             	add    $0x1,%ebx
80106c07:	e8 04 ff ff ff       	call   80106b10 <uartputc.part.0>
80106c0c:	0f be 03             	movsbl (%ebx),%eax
80106c0f:	84 c0                	test   %al,%al
80106c11:	75 e7                	jne    80106bfa <uartinit+0x9a>
    uartputc(*p);
}
80106c13:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c16:	5b                   	pop    %ebx
80106c17:	5e                   	pop    %esi
80106c18:	5f                   	pop    %edi
80106c19:	5d                   	pop    %ebp
80106c1a:	c3                   	ret    
80106c1b:	90                   	nop
80106c1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106c20 <uartputc>:
void
uartputc(int c)
{
  int i;

  if(!uart)
80106c20:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
    uartputc(*p);
}

void
uartputc(int c)
{
80106c26:	55                   	push   %ebp
80106c27:	89 e5                	mov    %esp,%ebp
  int i;

  if(!uart)
80106c29:	85 d2                	test   %edx,%edx
    uartputc(*p);
}

void
uartputc(int c)
{
80106c2b:	8b 45 08             	mov    0x8(%ebp),%eax
  int i;

  if(!uart)
80106c2e:	74 10                	je     80106c40 <uartputc+0x20>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
  outb(COM1+0, c);
}
80106c30:	5d                   	pop    %ebp
80106c31:	e9 da fe ff ff       	jmp    80106b10 <uartputc.part.0>
80106c36:	8d 76 00             	lea    0x0(%esi),%esi
80106c39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106c40:	5d                   	pop    %ebp
80106c41:	c3                   	ret    
80106c42:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106c49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106c50 <uartintr>:
  return inb(COM1+0);
}

void
uartintr(void)
{
80106c50:	55                   	push   %ebp
80106c51:	89 e5                	mov    %esp,%ebp
80106c53:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106c56:	68 e0 6a 10 80       	push   $0x80106ae0
80106c5b:	e8 90 9b ff ff       	call   801007f0 <consoleintr>
}
80106c60:	83 c4 10             	add    $0x10,%esp
80106c63:	c9                   	leave  
80106c64:	c3                   	ret    

80106c65 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106c65:	6a 00                	push   $0x0
  pushl $0
80106c67:	6a 00                	push   $0x0
  jmp alltraps
80106c69:	e9 2b fb ff ff       	jmp    80106799 <alltraps>

80106c6e <vector1>:
.globl vector1
vector1:
  pushl $0
80106c6e:	6a 00                	push   $0x0
  pushl $1
80106c70:	6a 01                	push   $0x1
  jmp alltraps
80106c72:	e9 22 fb ff ff       	jmp    80106799 <alltraps>

80106c77 <vector2>:
.globl vector2
vector2:
  pushl $0
80106c77:	6a 00                	push   $0x0
  pushl $2
80106c79:	6a 02                	push   $0x2
  jmp alltraps
80106c7b:	e9 19 fb ff ff       	jmp    80106799 <alltraps>

80106c80 <vector3>:
.globl vector3
vector3:
  pushl $0
80106c80:	6a 00                	push   $0x0
  pushl $3
80106c82:	6a 03                	push   $0x3
  jmp alltraps
80106c84:	e9 10 fb ff ff       	jmp    80106799 <alltraps>

80106c89 <vector4>:
.globl vector4
vector4:
  pushl $0
80106c89:	6a 00                	push   $0x0
  pushl $4
80106c8b:	6a 04                	push   $0x4
  jmp alltraps
80106c8d:	e9 07 fb ff ff       	jmp    80106799 <alltraps>

80106c92 <vector5>:
.globl vector5
vector5:
  pushl $0
80106c92:	6a 00                	push   $0x0
  pushl $5
80106c94:	6a 05                	push   $0x5
  jmp alltraps
80106c96:	e9 fe fa ff ff       	jmp    80106799 <alltraps>

80106c9b <vector6>:
.globl vector6
vector6:
  pushl $0
80106c9b:	6a 00                	push   $0x0
  pushl $6
80106c9d:	6a 06                	push   $0x6
  jmp alltraps
80106c9f:	e9 f5 fa ff ff       	jmp    80106799 <alltraps>

80106ca4 <vector7>:
.globl vector7
vector7:
  pushl $0
80106ca4:	6a 00                	push   $0x0
  pushl $7
80106ca6:	6a 07                	push   $0x7
  jmp alltraps
80106ca8:	e9 ec fa ff ff       	jmp    80106799 <alltraps>

80106cad <vector8>:
.globl vector8
vector8:
  pushl $8
80106cad:	6a 08                	push   $0x8
  jmp alltraps
80106caf:	e9 e5 fa ff ff       	jmp    80106799 <alltraps>

80106cb4 <vector9>:
.globl vector9
vector9:
  pushl $0
80106cb4:	6a 00                	push   $0x0
  pushl $9
80106cb6:	6a 09                	push   $0x9
  jmp alltraps
80106cb8:	e9 dc fa ff ff       	jmp    80106799 <alltraps>

80106cbd <vector10>:
.globl vector10
vector10:
  pushl $10
80106cbd:	6a 0a                	push   $0xa
  jmp alltraps
80106cbf:	e9 d5 fa ff ff       	jmp    80106799 <alltraps>

80106cc4 <vector11>:
.globl vector11
vector11:
  pushl $11
80106cc4:	6a 0b                	push   $0xb
  jmp alltraps
80106cc6:	e9 ce fa ff ff       	jmp    80106799 <alltraps>

80106ccb <vector12>:
.globl vector12
vector12:
  pushl $12
80106ccb:	6a 0c                	push   $0xc
  jmp alltraps
80106ccd:	e9 c7 fa ff ff       	jmp    80106799 <alltraps>

80106cd2 <vector13>:
.globl vector13
vector13:
  pushl $13
80106cd2:	6a 0d                	push   $0xd
  jmp alltraps
80106cd4:	e9 c0 fa ff ff       	jmp    80106799 <alltraps>

80106cd9 <vector14>:
.globl vector14
vector14:
  pushl $14
80106cd9:	6a 0e                	push   $0xe
  jmp alltraps
80106cdb:	e9 b9 fa ff ff       	jmp    80106799 <alltraps>

80106ce0 <vector15>:
.globl vector15
vector15:
  pushl $0
80106ce0:	6a 00                	push   $0x0
  pushl $15
80106ce2:	6a 0f                	push   $0xf
  jmp alltraps
80106ce4:	e9 b0 fa ff ff       	jmp    80106799 <alltraps>

80106ce9 <vector16>:
.globl vector16
vector16:
  pushl $0
80106ce9:	6a 00                	push   $0x0
  pushl $16
80106ceb:	6a 10                	push   $0x10
  jmp alltraps
80106ced:	e9 a7 fa ff ff       	jmp    80106799 <alltraps>

80106cf2 <vector17>:
.globl vector17
vector17:
  pushl $17
80106cf2:	6a 11                	push   $0x11
  jmp alltraps
80106cf4:	e9 a0 fa ff ff       	jmp    80106799 <alltraps>

80106cf9 <vector18>:
.globl vector18
vector18:
  pushl $0
80106cf9:	6a 00                	push   $0x0
  pushl $18
80106cfb:	6a 12                	push   $0x12
  jmp alltraps
80106cfd:	e9 97 fa ff ff       	jmp    80106799 <alltraps>

80106d02 <vector19>:
.globl vector19
vector19:
  pushl $0
80106d02:	6a 00                	push   $0x0
  pushl $19
80106d04:	6a 13                	push   $0x13
  jmp alltraps
80106d06:	e9 8e fa ff ff       	jmp    80106799 <alltraps>

80106d0b <vector20>:
.globl vector20
vector20:
  pushl $0
80106d0b:	6a 00                	push   $0x0
  pushl $20
80106d0d:	6a 14                	push   $0x14
  jmp alltraps
80106d0f:	e9 85 fa ff ff       	jmp    80106799 <alltraps>

80106d14 <vector21>:
.globl vector21
vector21:
  pushl $0
80106d14:	6a 00                	push   $0x0
  pushl $21
80106d16:	6a 15                	push   $0x15
  jmp alltraps
80106d18:	e9 7c fa ff ff       	jmp    80106799 <alltraps>

80106d1d <vector22>:
.globl vector22
vector22:
  pushl $0
80106d1d:	6a 00                	push   $0x0
  pushl $22
80106d1f:	6a 16                	push   $0x16
  jmp alltraps
80106d21:	e9 73 fa ff ff       	jmp    80106799 <alltraps>

80106d26 <vector23>:
.globl vector23
vector23:
  pushl $0
80106d26:	6a 00                	push   $0x0
  pushl $23
80106d28:	6a 17                	push   $0x17
  jmp alltraps
80106d2a:	e9 6a fa ff ff       	jmp    80106799 <alltraps>

80106d2f <vector24>:
.globl vector24
vector24:
  pushl $0
80106d2f:	6a 00                	push   $0x0
  pushl $24
80106d31:	6a 18                	push   $0x18
  jmp alltraps
80106d33:	e9 61 fa ff ff       	jmp    80106799 <alltraps>

80106d38 <vector25>:
.globl vector25
vector25:
  pushl $0
80106d38:	6a 00                	push   $0x0
  pushl $25
80106d3a:	6a 19                	push   $0x19
  jmp alltraps
80106d3c:	e9 58 fa ff ff       	jmp    80106799 <alltraps>

80106d41 <vector26>:
.globl vector26
vector26:
  pushl $0
80106d41:	6a 00                	push   $0x0
  pushl $26
80106d43:	6a 1a                	push   $0x1a
  jmp alltraps
80106d45:	e9 4f fa ff ff       	jmp    80106799 <alltraps>

80106d4a <vector27>:
.globl vector27
vector27:
  pushl $0
80106d4a:	6a 00                	push   $0x0
  pushl $27
80106d4c:	6a 1b                	push   $0x1b
  jmp alltraps
80106d4e:	e9 46 fa ff ff       	jmp    80106799 <alltraps>

80106d53 <vector28>:
.globl vector28
vector28:
  pushl $0
80106d53:	6a 00                	push   $0x0
  pushl $28
80106d55:	6a 1c                	push   $0x1c
  jmp alltraps
80106d57:	e9 3d fa ff ff       	jmp    80106799 <alltraps>

80106d5c <vector29>:
.globl vector29
vector29:
  pushl $0
80106d5c:	6a 00                	push   $0x0
  pushl $29
80106d5e:	6a 1d                	push   $0x1d
  jmp alltraps
80106d60:	e9 34 fa ff ff       	jmp    80106799 <alltraps>

80106d65 <vector30>:
.globl vector30
vector30:
  pushl $0
80106d65:	6a 00                	push   $0x0
  pushl $30
80106d67:	6a 1e                	push   $0x1e
  jmp alltraps
80106d69:	e9 2b fa ff ff       	jmp    80106799 <alltraps>

80106d6e <vector31>:
.globl vector31
vector31:
  pushl $0
80106d6e:	6a 00                	push   $0x0
  pushl $31
80106d70:	6a 1f                	push   $0x1f
  jmp alltraps
80106d72:	e9 22 fa ff ff       	jmp    80106799 <alltraps>

80106d77 <vector32>:
.globl vector32
vector32:
  pushl $0
80106d77:	6a 00                	push   $0x0
  pushl $32
80106d79:	6a 20                	push   $0x20
  jmp alltraps
80106d7b:	e9 19 fa ff ff       	jmp    80106799 <alltraps>

80106d80 <vector33>:
.globl vector33
vector33:
  pushl $0
80106d80:	6a 00                	push   $0x0
  pushl $33
80106d82:	6a 21                	push   $0x21
  jmp alltraps
80106d84:	e9 10 fa ff ff       	jmp    80106799 <alltraps>

80106d89 <vector34>:
.globl vector34
vector34:
  pushl $0
80106d89:	6a 00                	push   $0x0
  pushl $34
80106d8b:	6a 22                	push   $0x22
  jmp alltraps
80106d8d:	e9 07 fa ff ff       	jmp    80106799 <alltraps>

80106d92 <vector35>:
.globl vector35
vector35:
  pushl $0
80106d92:	6a 00                	push   $0x0
  pushl $35
80106d94:	6a 23                	push   $0x23
  jmp alltraps
80106d96:	e9 fe f9 ff ff       	jmp    80106799 <alltraps>

80106d9b <vector36>:
.globl vector36
vector36:
  pushl $0
80106d9b:	6a 00                	push   $0x0
  pushl $36
80106d9d:	6a 24                	push   $0x24
  jmp alltraps
80106d9f:	e9 f5 f9 ff ff       	jmp    80106799 <alltraps>

80106da4 <vector37>:
.globl vector37
vector37:
  pushl $0
80106da4:	6a 00                	push   $0x0
  pushl $37
80106da6:	6a 25                	push   $0x25
  jmp alltraps
80106da8:	e9 ec f9 ff ff       	jmp    80106799 <alltraps>

80106dad <vector38>:
.globl vector38
vector38:
  pushl $0
80106dad:	6a 00                	push   $0x0
  pushl $38
80106daf:	6a 26                	push   $0x26
  jmp alltraps
80106db1:	e9 e3 f9 ff ff       	jmp    80106799 <alltraps>

80106db6 <vector39>:
.globl vector39
vector39:
  pushl $0
80106db6:	6a 00                	push   $0x0
  pushl $39
80106db8:	6a 27                	push   $0x27
  jmp alltraps
80106dba:	e9 da f9 ff ff       	jmp    80106799 <alltraps>

80106dbf <vector40>:
.globl vector40
vector40:
  pushl $0
80106dbf:	6a 00                	push   $0x0
  pushl $40
80106dc1:	6a 28                	push   $0x28
  jmp alltraps
80106dc3:	e9 d1 f9 ff ff       	jmp    80106799 <alltraps>

80106dc8 <vector41>:
.globl vector41
vector41:
  pushl $0
80106dc8:	6a 00                	push   $0x0
  pushl $41
80106dca:	6a 29                	push   $0x29
  jmp alltraps
80106dcc:	e9 c8 f9 ff ff       	jmp    80106799 <alltraps>

80106dd1 <vector42>:
.globl vector42
vector42:
  pushl $0
80106dd1:	6a 00                	push   $0x0
  pushl $42
80106dd3:	6a 2a                	push   $0x2a
  jmp alltraps
80106dd5:	e9 bf f9 ff ff       	jmp    80106799 <alltraps>

80106dda <vector43>:
.globl vector43
vector43:
  pushl $0
80106dda:	6a 00                	push   $0x0
  pushl $43
80106ddc:	6a 2b                	push   $0x2b
  jmp alltraps
80106dde:	e9 b6 f9 ff ff       	jmp    80106799 <alltraps>

80106de3 <vector44>:
.globl vector44
vector44:
  pushl $0
80106de3:	6a 00                	push   $0x0
  pushl $44
80106de5:	6a 2c                	push   $0x2c
  jmp alltraps
80106de7:	e9 ad f9 ff ff       	jmp    80106799 <alltraps>

80106dec <vector45>:
.globl vector45
vector45:
  pushl $0
80106dec:	6a 00                	push   $0x0
  pushl $45
80106dee:	6a 2d                	push   $0x2d
  jmp alltraps
80106df0:	e9 a4 f9 ff ff       	jmp    80106799 <alltraps>

80106df5 <vector46>:
.globl vector46
vector46:
  pushl $0
80106df5:	6a 00                	push   $0x0
  pushl $46
80106df7:	6a 2e                	push   $0x2e
  jmp alltraps
80106df9:	e9 9b f9 ff ff       	jmp    80106799 <alltraps>

80106dfe <vector47>:
.globl vector47
vector47:
  pushl $0
80106dfe:	6a 00                	push   $0x0
  pushl $47
80106e00:	6a 2f                	push   $0x2f
  jmp alltraps
80106e02:	e9 92 f9 ff ff       	jmp    80106799 <alltraps>

80106e07 <vector48>:
.globl vector48
vector48:
  pushl $0
80106e07:	6a 00                	push   $0x0
  pushl $48
80106e09:	6a 30                	push   $0x30
  jmp alltraps
80106e0b:	e9 89 f9 ff ff       	jmp    80106799 <alltraps>

80106e10 <vector49>:
.globl vector49
vector49:
  pushl $0
80106e10:	6a 00                	push   $0x0
  pushl $49
80106e12:	6a 31                	push   $0x31
  jmp alltraps
80106e14:	e9 80 f9 ff ff       	jmp    80106799 <alltraps>

80106e19 <vector50>:
.globl vector50
vector50:
  pushl $0
80106e19:	6a 00                	push   $0x0
  pushl $50
80106e1b:	6a 32                	push   $0x32
  jmp alltraps
80106e1d:	e9 77 f9 ff ff       	jmp    80106799 <alltraps>

80106e22 <vector51>:
.globl vector51
vector51:
  pushl $0
80106e22:	6a 00                	push   $0x0
  pushl $51
80106e24:	6a 33                	push   $0x33
  jmp alltraps
80106e26:	e9 6e f9 ff ff       	jmp    80106799 <alltraps>

80106e2b <vector52>:
.globl vector52
vector52:
  pushl $0
80106e2b:	6a 00                	push   $0x0
  pushl $52
80106e2d:	6a 34                	push   $0x34
  jmp alltraps
80106e2f:	e9 65 f9 ff ff       	jmp    80106799 <alltraps>

80106e34 <vector53>:
.globl vector53
vector53:
  pushl $0
80106e34:	6a 00                	push   $0x0
  pushl $53
80106e36:	6a 35                	push   $0x35
  jmp alltraps
80106e38:	e9 5c f9 ff ff       	jmp    80106799 <alltraps>

80106e3d <vector54>:
.globl vector54
vector54:
  pushl $0
80106e3d:	6a 00                	push   $0x0
  pushl $54
80106e3f:	6a 36                	push   $0x36
  jmp alltraps
80106e41:	e9 53 f9 ff ff       	jmp    80106799 <alltraps>

80106e46 <vector55>:
.globl vector55
vector55:
  pushl $0
80106e46:	6a 00                	push   $0x0
  pushl $55
80106e48:	6a 37                	push   $0x37
  jmp alltraps
80106e4a:	e9 4a f9 ff ff       	jmp    80106799 <alltraps>

80106e4f <vector56>:
.globl vector56
vector56:
  pushl $0
80106e4f:	6a 00                	push   $0x0
  pushl $56
80106e51:	6a 38                	push   $0x38
  jmp alltraps
80106e53:	e9 41 f9 ff ff       	jmp    80106799 <alltraps>

80106e58 <vector57>:
.globl vector57
vector57:
  pushl $0
80106e58:	6a 00                	push   $0x0
  pushl $57
80106e5a:	6a 39                	push   $0x39
  jmp alltraps
80106e5c:	e9 38 f9 ff ff       	jmp    80106799 <alltraps>

80106e61 <vector58>:
.globl vector58
vector58:
  pushl $0
80106e61:	6a 00                	push   $0x0
  pushl $58
80106e63:	6a 3a                	push   $0x3a
  jmp alltraps
80106e65:	e9 2f f9 ff ff       	jmp    80106799 <alltraps>

80106e6a <vector59>:
.globl vector59
vector59:
  pushl $0
80106e6a:	6a 00                	push   $0x0
  pushl $59
80106e6c:	6a 3b                	push   $0x3b
  jmp alltraps
80106e6e:	e9 26 f9 ff ff       	jmp    80106799 <alltraps>

80106e73 <vector60>:
.globl vector60
vector60:
  pushl $0
80106e73:	6a 00                	push   $0x0
  pushl $60
80106e75:	6a 3c                	push   $0x3c
  jmp alltraps
80106e77:	e9 1d f9 ff ff       	jmp    80106799 <alltraps>

80106e7c <vector61>:
.globl vector61
vector61:
  pushl $0
80106e7c:	6a 00                	push   $0x0
  pushl $61
80106e7e:	6a 3d                	push   $0x3d
  jmp alltraps
80106e80:	e9 14 f9 ff ff       	jmp    80106799 <alltraps>

80106e85 <vector62>:
.globl vector62
vector62:
  pushl $0
80106e85:	6a 00                	push   $0x0
  pushl $62
80106e87:	6a 3e                	push   $0x3e
  jmp alltraps
80106e89:	e9 0b f9 ff ff       	jmp    80106799 <alltraps>

80106e8e <vector63>:
.globl vector63
vector63:
  pushl $0
80106e8e:	6a 00                	push   $0x0
  pushl $63
80106e90:	6a 3f                	push   $0x3f
  jmp alltraps
80106e92:	e9 02 f9 ff ff       	jmp    80106799 <alltraps>

80106e97 <vector64>:
.globl vector64
vector64:
  pushl $0
80106e97:	6a 00                	push   $0x0
  pushl $64
80106e99:	6a 40                	push   $0x40
  jmp alltraps
80106e9b:	e9 f9 f8 ff ff       	jmp    80106799 <alltraps>

80106ea0 <vector65>:
.globl vector65
vector65:
  pushl $0
80106ea0:	6a 00                	push   $0x0
  pushl $65
80106ea2:	6a 41                	push   $0x41
  jmp alltraps
80106ea4:	e9 f0 f8 ff ff       	jmp    80106799 <alltraps>

80106ea9 <vector66>:
.globl vector66
vector66:
  pushl $0
80106ea9:	6a 00                	push   $0x0
  pushl $66
80106eab:	6a 42                	push   $0x42
  jmp alltraps
80106ead:	e9 e7 f8 ff ff       	jmp    80106799 <alltraps>

80106eb2 <vector67>:
.globl vector67
vector67:
  pushl $0
80106eb2:	6a 00                	push   $0x0
  pushl $67
80106eb4:	6a 43                	push   $0x43
  jmp alltraps
80106eb6:	e9 de f8 ff ff       	jmp    80106799 <alltraps>

80106ebb <vector68>:
.globl vector68
vector68:
  pushl $0
80106ebb:	6a 00                	push   $0x0
  pushl $68
80106ebd:	6a 44                	push   $0x44
  jmp alltraps
80106ebf:	e9 d5 f8 ff ff       	jmp    80106799 <alltraps>

80106ec4 <vector69>:
.globl vector69
vector69:
  pushl $0
80106ec4:	6a 00                	push   $0x0
  pushl $69
80106ec6:	6a 45                	push   $0x45
  jmp alltraps
80106ec8:	e9 cc f8 ff ff       	jmp    80106799 <alltraps>

80106ecd <vector70>:
.globl vector70
vector70:
  pushl $0
80106ecd:	6a 00                	push   $0x0
  pushl $70
80106ecf:	6a 46                	push   $0x46
  jmp alltraps
80106ed1:	e9 c3 f8 ff ff       	jmp    80106799 <alltraps>

80106ed6 <vector71>:
.globl vector71
vector71:
  pushl $0
80106ed6:	6a 00                	push   $0x0
  pushl $71
80106ed8:	6a 47                	push   $0x47
  jmp alltraps
80106eda:	e9 ba f8 ff ff       	jmp    80106799 <alltraps>

80106edf <vector72>:
.globl vector72
vector72:
  pushl $0
80106edf:	6a 00                	push   $0x0
  pushl $72
80106ee1:	6a 48                	push   $0x48
  jmp alltraps
80106ee3:	e9 b1 f8 ff ff       	jmp    80106799 <alltraps>

80106ee8 <vector73>:
.globl vector73
vector73:
  pushl $0
80106ee8:	6a 00                	push   $0x0
  pushl $73
80106eea:	6a 49                	push   $0x49
  jmp alltraps
80106eec:	e9 a8 f8 ff ff       	jmp    80106799 <alltraps>

80106ef1 <vector74>:
.globl vector74
vector74:
  pushl $0
80106ef1:	6a 00                	push   $0x0
  pushl $74
80106ef3:	6a 4a                	push   $0x4a
  jmp alltraps
80106ef5:	e9 9f f8 ff ff       	jmp    80106799 <alltraps>

80106efa <vector75>:
.globl vector75
vector75:
  pushl $0
80106efa:	6a 00                	push   $0x0
  pushl $75
80106efc:	6a 4b                	push   $0x4b
  jmp alltraps
80106efe:	e9 96 f8 ff ff       	jmp    80106799 <alltraps>

80106f03 <vector76>:
.globl vector76
vector76:
  pushl $0
80106f03:	6a 00                	push   $0x0
  pushl $76
80106f05:	6a 4c                	push   $0x4c
  jmp alltraps
80106f07:	e9 8d f8 ff ff       	jmp    80106799 <alltraps>

80106f0c <vector77>:
.globl vector77
vector77:
  pushl $0
80106f0c:	6a 00                	push   $0x0
  pushl $77
80106f0e:	6a 4d                	push   $0x4d
  jmp alltraps
80106f10:	e9 84 f8 ff ff       	jmp    80106799 <alltraps>

80106f15 <vector78>:
.globl vector78
vector78:
  pushl $0
80106f15:	6a 00                	push   $0x0
  pushl $78
80106f17:	6a 4e                	push   $0x4e
  jmp alltraps
80106f19:	e9 7b f8 ff ff       	jmp    80106799 <alltraps>

80106f1e <vector79>:
.globl vector79
vector79:
  pushl $0
80106f1e:	6a 00                	push   $0x0
  pushl $79
80106f20:	6a 4f                	push   $0x4f
  jmp alltraps
80106f22:	e9 72 f8 ff ff       	jmp    80106799 <alltraps>

80106f27 <vector80>:
.globl vector80
vector80:
  pushl $0
80106f27:	6a 00                	push   $0x0
  pushl $80
80106f29:	6a 50                	push   $0x50
  jmp alltraps
80106f2b:	e9 69 f8 ff ff       	jmp    80106799 <alltraps>

80106f30 <vector81>:
.globl vector81
vector81:
  pushl $0
80106f30:	6a 00                	push   $0x0
  pushl $81
80106f32:	6a 51                	push   $0x51
  jmp alltraps
80106f34:	e9 60 f8 ff ff       	jmp    80106799 <alltraps>

80106f39 <vector82>:
.globl vector82
vector82:
  pushl $0
80106f39:	6a 00                	push   $0x0
  pushl $82
80106f3b:	6a 52                	push   $0x52
  jmp alltraps
80106f3d:	e9 57 f8 ff ff       	jmp    80106799 <alltraps>

80106f42 <vector83>:
.globl vector83
vector83:
  pushl $0
80106f42:	6a 00                	push   $0x0
  pushl $83
80106f44:	6a 53                	push   $0x53
  jmp alltraps
80106f46:	e9 4e f8 ff ff       	jmp    80106799 <alltraps>

80106f4b <vector84>:
.globl vector84
vector84:
  pushl $0
80106f4b:	6a 00                	push   $0x0
  pushl $84
80106f4d:	6a 54                	push   $0x54
  jmp alltraps
80106f4f:	e9 45 f8 ff ff       	jmp    80106799 <alltraps>

80106f54 <vector85>:
.globl vector85
vector85:
  pushl $0
80106f54:	6a 00                	push   $0x0
  pushl $85
80106f56:	6a 55                	push   $0x55
  jmp alltraps
80106f58:	e9 3c f8 ff ff       	jmp    80106799 <alltraps>

80106f5d <vector86>:
.globl vector86
vector86:
  pushl $0
80106f5d:	6a 00                	push   $0x0
  pushl $86
80106f5f:	6a 56                	push   $0x56
  jmp alltraps
80106f61:	e9 33 f8 ff ff       	jmp    80106799 <alltraps>

80106f66 <vector87>:
.globl vector87
vector87:
  pushl $0
80106f66:	6a 00                	push   $0x0
  pushl $87
80106f68:	6a 57                	push   $0x57
  jmp alltraps
80106f6a:	e9 2a f8 ff ff       	jmp    80106799 <alltraps>

80106f6f <vector88>:
.globl vector88
vector88:
  pushl $0
80106f6f:	6a 00                	push   $0x0
  pushl $88
80106f71:	6a 58                	push   $0x58
  jmp alltraps
80106f73:	e9 21 f8 ff ff       	jmp    80106799 <alltraps>

80106f78 <vector89>:
.globl vector89
vector89:
  pushl $0
80106f78:	6a 00                	push   $0x0
  pushl $89
80106f7a:	6a 59                	push   $0x59
  jmp alltraps
80106f7c:	e9 18 f8 ff ff       	jmp    80106799 <alltraps>

80106f81 <vector90>:
.globl vector90
vector90:
  pushl $0
80106f81:	6a 00                	push   $0x0
  pushl $90
80106f83:	6a 5a                	push   $0x5a
  jmp alltraps
80106f85:	e9 0f f8 ff ff       	jmp    80106799 <alltraps>

80106f8a <vector91>:
.globl vector91
vector91:
  pushl $0
80106f8a:	6a 00                	push   $0x0
  pushl $91
80106f8c:	6a 5b                	push   $0x5b
  jmp alltraps
80106f8e:	e9 06 f8 ff ff       	jmp    80106799 <alltraps>

80106f93 <vector92>:
.globl vector92
vector92:
  pushl $0
80106f93:	6a 00                	push   $0x0
  pushl $92
80106f95:	6a 5c                	push   $0x5c
  jmp alltraps
80106f97:	e9 fd f7 ff ff       	jmp    80106799 <alltraps>

80106f9c <vector93>:
.globl vector93
vector93:
  pushl $0
80106f9c:	6a 00                	push   $0x0
  pushl $93
80106f9e:	6a 5d                	push   $0x5d
  jmp alltraps
80106fa0:	e9 f4 f7 ff ff       	jmp    80106799 <alltraps>

80106fa5 <vector94>:
.globl vector94
vector94:
  pushl $0
80106fa5:	6a 00                	push   $0x0
  pushl $94
80106fa7:	6a 5e                	push   $0x5e
  jmp alltraps
80106fa9:	e9 eb f7 ff ff       	jmp    80106799 <alltraps>

80106fae <vector95>:
.globl vector95
vector95:
  pushl $0
80106fae:	6a 00                	push   $0x0
  pushl $95
80106fb0:	6a 5f                	push   $0x5f
  jmp alltraps
80106fb2:	e9 e2 f7 ff ff       	jmp    80106799 <alltraps>

80106fb7 <vector96>:
.globl vector96
vector96:
  pushl $0
80106fb7:	6a 00                	push   $0x0
  pushl $96
80106fb9:	6a 60                	push   $0x60
  jmp alltraps
80106fbb:	e9 d9 f7 ff ff       	jmp    80106799 <alltraps>

80106fc0 <vector97>:
.globl vector97
vector97:
  pushl $0
80106fc0:	6a 00                	push   $0x0
  pushl $97
80106fc2:	6a 61                	push   $0x61
  jmp alltraps
80106fc4:	e9 d0 f7 ff ff       	jmp    80106799 <alltraps>

80106fc9 <vector98>:
.globl vector98
vector98:
  pushl $0
80106fc9:	6a 00                	push   $0x0
  pushl $98
80106fcb:	6a 62                	push   $0x62
  jmp alltraps
80106fcd:	e9 c7 f7 ff ff       	jmp    80106799 <alltraps>

80106fd2 <vector99>:
.globl vector99
vector99:
  pushl $0
80106fd2:	6a 00                	push   $0x0
  pushl $99
80106fd4:	6a 63                	push   $0x63
  jmp alltraps
80106fd6:	e9 be f7 ff ff       	jmp    80106799 <alltraps>

80106fdb <vector100>:
.globl vector100
vector100:
  pushl $0
80106fdb:	6a 00                	push   $0x0
  pushl $100
80106fdd:	6a 64                	push   $0x64
  jmp alltraps
80106fdf:	e9 b5 f7 ff ff       	jmp    80106799 <alltraps>

80106fe4 <vector101>:
.globl vector101
vector101:
  pushl $0
80106fe4:	6a 00                	push   $0x0
  pushl $101
80106fe6:	6a 65                	push   $0x65
  jmp alltraps
80106fe8:	e9 ac f7 ff ff       	jmp    80106799 <alltraps>

80106fed <vector102>:
.globl vector102
vector102:
  pushl $0
80106fed:	6a 00                	push   $0x0
  pushl $102
80106fef:	6a 66                	push   $0x66
  jmp alltraps
80106ff1:	e9 a3 f7 ff ff       	jmp    80106799 <alltraps>

80106ff6 <vector103>:
.globl vector103
vector103:
  pushl $0
80106ff6:	6a 00                	push   $0x0
  pushl $103
80106ff8:	6a 67                	push   $0x67
  jmp alltraps
80106ffa:	e9 9a f7 ff ff       	jmp    80106799 <alltraps>

80106fff <vector104>:
.globl vector104
vector104:
  pushl $0
80106fff:	6a 00                	push   $0x0
  pushl $104
80107001:	6a 68                	push   $0x68
  jmp alltraps
80107003:	e9 91 f7 ff ff       	jmp    80106799 <alltraps>

80107008 <vector105>:
.globl vector105
vector105:
  pushl $0
80107008:	6a 00                	push   $0x0
  pushl $105
8010700a:	6a 69                	push   $0x69
  jmp alltraps
8010700c:	e9 88 f7 ff ff       	jmp    80106799 <alltraps>

80107011 <vector106>:
.globl vector106
vector106:
  pushl $0
80107011:	6a 00                	push   $0x0
  pushl $106
80107013:	6a 6a                	push   $0x6a
  jmp alltraps
80107015:	e9 7f f7 ff ff       	jmp    80106799 <alltraps>

8010701a <vector107>:
.globl vector107
vector107:
  pushl $0
8010701a:	6a 00                	push   $0x0
  pushl $107
8010701c:	6a 6b                	push   $0x6b
  jmp alltraps
8010701e:	e9 76 f7 ff ff       	jmp    80106799 <alltraps>

80107023 <vector108>:
.globl vector108
vector108:
  pushl $0
80107023:	6a 00                	push   $0x0
  pushl $108
80107025:	6a 6c                	push   $0x6c
  jmp alltraps
80107027:	e9 6d f7 ff ff       	jmp    80106799 <alltraps>

8010702c <vector109>:
.globl vector109
vector109:
  pushl $0
8010702c:	6a 00                	push   $0x0
  pushl $109
8010702e:	6a 6d                	push   $0x6d
  jmp alltraps
80107030:	e9 64 f7 ff ff       	jmp    80106799 <alltraps>

80107035 <vector110>:
.globl vector110
vector110:
  pushl $0
80107035:	6a 00                	push   $0x0
  pushl $110
80107037:	6a 6e                	push   $0x6e
  jmp alltraps
80107039:	e9 5b f7 ff ff       	jmp    80106799 <alltraps>

8010703e <vector111>:
.globl vector111
vector111:
  pushl $0
8010703e:	6a 00                	push   $0x0
  pushl $111
80107040:	6a 6f                	push   $0x6f
  jmp alltraps
80107042:	e9 52 f7 ff ff       	jmp    80106799 <alltraps>

80107047 <vector112>:
.globl vector112
vector112:
  pushl $0
80107047:	6a 00                	push   $0x0
  pushl $112
80107049:	6a 70                	push   $0x70
  jmp alltraps
8010704b:	e9 49 f7 ff ff       	jmp    80106799 <alltraps>

80107050 <vector113>:
.globl vector113
vector113:
  pushl $0
80107050:	6a 00                	push   $0x0
  pushl $113
80107052:	6a 71                	push   $0x71
  jmp alltraps
80107054:	e9 40 f7 ff ff       	jmp    80106799 <alltraps>

80107059 <vector114>:
.globl vector114
vector114:
  pushl $0
80107059:	6a 00                	push   $0x0
  pushl $114
8010705b:	6a 72                	push   $0x72
  jmp alltraps
8010705d:	e9 37 f7 ff ff       	jmp    80106799 <alltraps>

80107062 <vector115>:
.globl vector115
vector115:
  pushl $0
80107062:	6a 00                	push   $0x0
  pushl $115
80107064:	6a 73                	push   $0x73
  jmp alltraps
80107066:	e9 2e f7 ff ff       	jmp    80106799 <alltraps>

8010706b <vector116>:
.globl vector116
vector116:
  pushl $0
8010706b:	6a 00                	push   $0x0
  pushl $116
8010706d:	6a 74                	push   $0x74
  jmp alltraps
8010706f:	e9 25 f7 ff ff       	jmp    80106799 <alltraps>

80107074 <vector117>:
.globl vector117
vector117:
  pushl $0
80107074:	6a 00                	push   $0x0
  pushl $117
80107076:	6a 75                	push   $0x75
  jmp alltraps
80107078:	e9 1c f7 ff ff       	jmp    80106799 <alltraps>

8010707d <vector118>:
.globl vector118
vector118:
  pushl $0
8010707d:	6a 00                	push   $0x0
  pushl $118
8010707f:	6a 76                	push   $0x76
  jmp alltraps
80107081:	e9 13 f7 ff ff       	jmp    80106799 <alltraps>

80107086 <vector119>:
.globl vector119
vector119:
  pushl $0
80107086:	6a 00                	push   $0x0
  pushl $119
80107088:	6a 77                	push   $0x77
  jmp alltraps
8010708a:	e9 0a f7 ff ff       	jmp    80106799 <alltraps>

8010708f <vector120>:
.globl vector120
vector120:
  pushl $0
8010708f:	6a 00                	push   $0x0
  pushl $120
80107091:	6a 78                	push   $0x78
  jmp alltraps
80107093:	e9 01 f7 ff ff       	jmp    80106799 <alltraps>

80107098 <vector121>:
.globl vector121
vector121:
  pushl $0
80107098:	6a 00                	push   $0x0
  pushl $121
8010709a:	6a 79                	push   $0x79
  jmp alltraps
8010709c:	e9 f8 f6 ff ff       	jmp    80106799 <alltraps>

801070a1 <vector122>:
.globl vector122
vector122:
  pushl $0
801070a1:	6a 00                	push   $0x0
  pushl $122
801070a3:	6a 7a                	push   $0x7a
  jmp alltraps
801070a5:	e9 ef f6 ff ff       	jmp    80106799 <alltraps>

801070aa <vector123>:
.globl vector123
vector123:
  pushl $0
801070aa:	6a 00                	push   $0x0
  pushl $123
801070ac:	6a 7b                	push   $0x7b
  jmp alltraps
801070ae:	e9 e6 f6 ff ff       	jmp    80106799 <alltraps>

801070b3 <vector124>:
.globl vector124
vector124:
  pushl $0
801070b3:	6a 00                	push   $0x0
  pushl $124
801070b5:	6a 7c                	push   $0x7c
  jmp alltraps
801070b7:	e9 dd f6 ff ff       	jmp    80106799 <alltraps>

801070bc <vector125>:
.globl vector125
vector125:
  pushl $0
801070bc:	6a 00                	push   $0x0
  pushl $125
801070be:	6a 7d                	push   $0x7d
  jmp alltraps
801070c0:	e9 d4 f6 ff ff       	jmp    80106799 <alltraps>

801070c5 <vector126>:
.globl vector126
vector126:
  pushl $0
801070c5:	6a 00                	push   $0x0
  pushl $126
801070c7:	6a 7e                	push   $0x7e
  jmp alltraps
801070c9:	e9 cb f6 ff ff       	jmp    80106799 <alltraps>

801070ce <vector127>:
.globl vector127
vector127:
  pushl $0
801070ce:	6a 00                	push   $0x0
  pushl $127
801070d0:	6a 7f                	push   $0x7f
  jmp alltraps
801070d2:	e9 c2 f6 ff ff       	jmp    80106799 <alltraps>

801070d7 <vector128>:
.globl vector128
vector128:
  pushl $0
801070d7:	6a 00                	push   $0x0
  pushl $128
801070d9:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801070de:	e9 b6 f6 ff ff       	jmp    80106799 <alltraps>

801070e3 <vector129>:
.globl vector129
vector129:
  pushl $0
801070e3:	6a 00                	push   $0x0
  pushl $129
801070e5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801070ea:	e9 aa f6 ff ff       	jmp    80106799 <alltraps>

801070ef <vector130>:
.globl vector130
vector130:
  pushl $0
801070ef:	6a 00                	push   $0x0
  pushl $130
801070f1:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801070f6:	e9 9e f6 ff ff       	jmp    80106799 <alltraps>

801070fb <vector131>:
.globl vector131
vector131:
  pushl $0
801070fb:	6a 00                	push   $0x0
  pushl $131
801070fd:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80107102:	e9 92 f6 ff ff       	jmp    80106799 <alltraps>

80107107 <vector132>:
.globl vector132
vector132:
  pushl $0
80107107:	6a 00                	push   $0x0
  pushl $132
80107109:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010710e:	e9 86 f6 ff ff       	jmp    80106799 <alltraps>

80107113 <vector133>:
.globl vector133
vector133:
  pushl $0
80107113:	6a 00                	push   $0x0
  pushl $133
80107115:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010711a:	e9 7a f6 ff ff       	jmp    80106799 <alltraps>

8010711f <vector134>:
.globl vector134
vector134:
  pushl $0
8010711f:	6a 00                	push   $0x0
  pushl $134
80107121:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80107126:	e9 6e f6 ff ff       	jmp    80106799 <alltraps>

8010712b <vector135>:
.globl vector135
vector135:
  pushl $0
8010712b:	6a 00                	push   $0x0
  pushl $135
8010712d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80107132:	e9 62 f6 ff ff       	jmp    80106799 <alltraps>

80107137 <vector136>:
.globl vector136
vector136:
  pushl $0
80107137:	6a 00                	push   $0x0
  pushl $136
80107139:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010713e:	e9 56 f6 ff ff       	jmp    80106799 <alltraps>

80107143 <vector137>:
.globl vector137
vector137:
  pushl $0
80107143:	6a 00                	push   $0x0
  pushl $137
80107145:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010714a:	e9 4a f6 ff ff       	jmp    80106799 <alltraps>

8010714f <vector138>:
.globl vector138
vector138:
  pushl $0
8010714f:	6a 00                	push   $0x0
  pushl $138
80107151:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80107156:	e9 3e f6 ff ff       	jmp    80106799 <alltraps>

8010715b <vector139>:
.globl vector139
vector139:
  pushl $0
8010715b:	6a 00                	push   $0x0
  pushl $139
8010715d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80107162:	e9 32 f6 ff ff       	jmp    80106799 <alltraps>

80107167 <vector140>:
.globl vector140
vector140:
  pushl $0
80107167:	6a 00                	push   $0x0
  pushl $140
80107169:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010716e:	e9 26 f6 ff ff       	jmp    80106799 <alltraps>

80107173 <vector141>:
.globl vector141
vector141:
  pushl $0
80107173:	6a 00                	push   $0x0
  pushl $141
80107175:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010717a:	e9 1a f6 ff ff       	jmp    80106799 <alltraps>

8010717f <vector142>:
.globl vector142
vector142:
  pushl $0
8010717f:	6a 00                	push   $0x0
  pushl $142
80107181:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80107186:	e9 0e f6 ff ff       	jmp    80106799 <alltraps>

8010718b <vector143>:
.globl vector143
vector143:
  pushl $0
8010718b:	6a 00                	push   $0x0
  pushl $143
8010718d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80107192:	e9 02 f6 ff ff       	jmp    80106799 <alltraps>

80107197 <vector144>:
.globl vector144
vector144:
  pushl $0
80107197:	6a 00                	push   $0x0
  pushl $144
80107199:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010719e:	e9 f6 f5 ff ff       	jmp    80106799 <alltraps>

801071a3 <vector145>:
.globl vector145
vector145:
  pushl $0
801071a3:	6a 00                	push   $0x0
  pushl $145
801071a5:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801071aa:	e9 ea f5 ff ff       	jmp    80106799 <alltraps>

801071af <vector146>:
.globl vector146
vector146:
  pushl $0
801071af:	6a 00                	push   $0x0
  pushl $146
801071b1:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801071b6:	e9 de f5 ff ff       	jmp    80106799 <alltraps>

801071bb <vector147>:
.globl vector147
vector147:
  pushl $0
801071bb:	6a 00                	push   $0x0
  pushl $147
801071bd:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801071c2:	e9 d2 f5 ff ff       	jmp    80106799 <alltraps>

801071c7 <vector148>:
.globl vector148
vector148:
  pushl $0
801071c7:	6a 00                	push   $0x0
  pushl $148
801071c9:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801071ce:	e9 c6 f5 ff ff       	jmp    80106799 <alltraps>

801071d3 <vector149>:
.globl vector149
vector149:
  pushl $0
801071d3:	6a 00                	push   $0x0
  pushl $149
801071d5:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801071da:	e9 ba f5 ff ff       	jmp    80106799 <alltraps>

801071df <vector150>:
.globl vector150
vector150:
  pushl $0
801071df:	6a 00                	push   $0x0
  pushl $150
801071e1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801071e6:	e9 ae f5 ff ff       	jmp    80106799 <alltraps>

801071eb <vector151>:
.globl vector151
vector151:
  pushl $0
801071eb:	6a 00                	push   $0x0
  pushl $151
801071ed:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801071f2:	e9 a2 f5 ff ff       	jmp    80106799 <alltraps>

801071f7 <vector152>:
.globl vector152
vector152:
  pushl $0
801071f7:	6a 00                	push   $0x0
  pushl $152
801071f9:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801071fe:	e9 96 f5 ff ff       	jmp    80106799 <alltraps>

80107203 <vector153>:
.globl vector153
vector153:
  pushl $0
80107203:	6a 00                	push   $0x0
  pushl $153
80107205:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010720a:	e9 8a f5 ff ff       	jmp    80106799 <alltraps>

8010720f <vector154>:
.globl vector154
vector154:
  pushl $0
8010720f:	6a 00                	push   $0x0
  pushl $154
80107211:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80107216:	e9 7e f5 ff ff       	jmp    80106799 <alltraps>

8010721b <vector155>:
.globl vector155
vector155:
  pushl $0
8010721b:	6a 00                	push   $0x0
  pushl $155
8010721d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80107222:	e9 72 f5 ff ff       	jmp    80106799 <alltraps>

80107227 <vector156>:
.globl vector156
vector156:
  pushl $0
80107227:	6a 00                	push   $0x0
  pushl $156
80107229:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010722e:	e9 66 f5 ff ff       	jmp    80106799 <alltraps>

80107233 <vector157>:
.globl vector157
vector157:
  pushl $0
80107233:	6a 00                	push   $0x0
  pushl $157
80107235:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010723a:	e9 5a f5 ff ff       	jmp    80106799 <alltraps>

8010723f <vector158>:
.globl vector158
vector158:
  pushl $0
8010723f:	6a 00                	push   $0x0
  pushl $158
80107241:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80107246:	e9 4e f5 ff ff       	jmp    80106799 <alltraps>

8010724b <vector159>:
.globl vector159
vector159:
  pushl $0
8010724b:	6a 00                	push   $0x0
  pushl $159
8010724d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80107252:	e9 42 f5 ff ff       	jmp    80106799 <alltraps>

80107257 <vector160>:
.globl vector160
vector160:
  pushl $0
80107257:	6a 00                	push   $0x0
  pushl $160
80107259:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010725e:	e9 36 f5 ff ff       	jmp    80106799 <alltraps>

80107263 <vector161>:
.globl vector161
vector161:
  pushl $0
80107263:	6a 00                	push   $0x0
  pushl $161
80107265:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010726a:	e9 2a f5 ff ff       	jmp    80106799 <alltraps>

8010726f <vector162>:
.globl vector162
vector162:
  pushl $0
8010726f:	6a 00                	push   $0x0
  pushl $162
80107271:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80107276:	e9 1e f5 ff ff       	jmp    80106799 <alltraps>

8010727b <vector163>:
.globl vector163
vector163:
  pushl $0
8010727b:	6a 00                	push   $0x0
  pushl $163
8010727d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80107282:	e9 12 f5 ff ff       	jmp    80106799 <alltraps>

80107287 <vector164>:
.globl vector164
vector164:
  pushl $0
80107287:	6a 00                	push   $0x0
  pushl $164
80107289:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010728e:	e9 06 f5 ff ff       	jmp    80106799 <alltraps>

80107293 <vector165>:
.globl vector165
vector165:
  pushl $0
80107293:	6a 00                	push   $0x0
  pushl $165
80107295:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010729a:	e9 fa f4 ff ff       	jmp    80106799 <alltraps>

8010729f <vector166>:
.globl vector166
vector166:
  pushl $0
8010729f:	6a 00                	push   $0x0
  pushl $166
801072a1:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801072a6:	e9 ee f4 ff ff       	jmp    80106799 <alltraps>

801072ab <vector167>:
.globl vector167
vector167:
  pushl $0
801072ab:	6a 00                	push   $0x0
  pushl $167
801072ad:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801072b2:	e9 e2 f4 ff ff       	jmp    80106799 <alltraps>

801072b7 <vector168>:
.globl vector168
vector168:
  pushl $0
801072b7:	6a 00                	push   $0x0
  pushl $168
801072b9:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801072be:	e9 d6 f4 ff ff       	jmp    80106799 <alltraps>

801072c3 <vector169>:
.globl vector169
vector169:
  pushl $0
801072c3:	6a 00                	push   $0x0
  pushl $169
801072c5:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801072ca:	e9 ca f4 ff ff       	jmp    80106799 <alltraps>

801072cf <vector170>:
.globl vector170
vector170:
  pushl $0
801072cf:	6a 00                	push   $0x0
  pushl $170
801072d1:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801072d6:	e9 be f4 ff ff       	jmp    80106799 <alltraps>

801072db <vector171>:
.globl vector171
vector171:
  pushl $0
801072db:	6a 00                	push   $0x0
  pushl $171
801072dd:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801072e2:	e9 b2 f4 ff ff       	jmp    80106799 <alltraps>

801072e7 <vector172>:
.globl vector172
vector172:
  pushl $0
801072e7:	6a 00                	push   $0x0
  pushl $172
801072e9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801072ee:	e9 a6 f4 ff ff       	jmp    80106799 <alltraps>

801072f3 <vector173>:
.globl vector173
vector173:
  pushl $0
801072f3:	6a 00                	push   $0x0
  pushl $173
801072f5:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801072fa:	e9 9a f4 ff ff       	jmp    80106799 <alltraps>

801072ff <vector174>:
.globl vector174
vector174:
  pushl $0
801072ff:	6a 00                	push   $0x0
  pushl $174
80107301:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80107306:	e9 8e f4 ff ff       	jmp    80106799 <alltraps>

8010730b <vector175>:
.globl vector175
vector175:
  pushl $0
8010730b:	6a 00                	push   $0x0
  pushl $175
8010730d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80107312:	e9 82 f4 ff ff       	jmp    80106799 <alltraps>

80107317 <vector176>:
.globl vector176
vector176:
  pushl $0
80107317:	6a 00                	push   $0x0
  pushl $176
80107319:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010731e:	e9 76 f4 ff ff       	jmp    80106799 <alltraps>

80107323 <vector177>:
.globl vector177
vector177:
  pushl $0
80107323:	6a 00                	push   $0x0
  pushl $177
80107325:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010732a:	e9 6a f4 ff ff       	jmp    80106799 <alltraps>

8010732f <vector178>:
.globl vector178
vector178:
  pushl $0
8010732f:	6a 00                	push   $0x0
  pushl $178
80107331:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80107336:	e9 5e f4 ff ff       	jmp    80106799 <alltraps>

8010733b <vector179>:
.globl vector179
vector179:
  pushl $0
8010733b:	6a 00                	push   $0x0
  pushl $179
8010733d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80107342:	e9 52 f4 ff ff       	jmp    80106799 <alltraps>

80107347 <vector180>:
.globl vector180
vector180:
  pushl $0
80107347:	6a 00                	push   $0x0
  pushl $180
80107349:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010734e:	e9 46 f4 ff ff       	jmp    80106799 <alltraps>

80107353 <vector181>:
.globl vector181
vector181:
  pushl $0
80107353:	6a 00                	push   $0x0
  pushl $181
80107355:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010735a:	e9 3a f4 ff ff       	jmp    80106799 <alltraps>

8010735f <vector182>:
.globl vector182
vector182:
  pushl $0
8010735f:	6a 00                	push   $0x0
  pushl $182
80107361:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80107366:	e9 2e f4 ff ff       	jmp    80106799 <alltraps>

8010736b <vector183>:
.globl vector183
vector183:
  pushl $0
8010736b:	6a 00                	push   $0x0
  pushl $183
8010736d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80107372:	e9 22 f4 ff ff       	jmp    80106799 <alltraps>

80107377 <vector184>:
.globl vector184
vector184:
  pushl $0
80107377:	6a 00                	push   $0x0
  pushl $184
80107379:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010737e:	e9 16 f4 ff ff       	jmp    80106799 <alltraps>

80107383 <vector185>:
.globl vector185
vector185:
  pushl $0
80107383:	6a 00                	push   $0x0
  pushl $185
80107385:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010738a:	e9 0a f4 ff ff       	jmp    80106799 <alltraps>

8010738f <vector186>:
.globl vector186
vector186:
  pushl $0
8010738f:	6a 00                	push   $0x0
  pushl $186
80107391:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80107396:	e9 fe f3 ff ff       	jmp    80106799 <alltraps>

8010739b <vector187>:
.globl vector187
vector187:
  pushl $0
8010739b:	6a 00                	push   $0x0
  pushl $187
8010739d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801073a2:	e9 f2 f3 ff ff       	jmp    80106799 <alltraps>

801073a7 <vector188>:
.globl vector188
vector188:
  pushl $0
801073a7:	6a 00                	push   $0x0
  pushl $188
801073a9:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801073ae:	e9 e6 f3 ff ff       	jmp    80106799 <alltraps>

801073b3 <vector189>:
.globl vector189
vector189:
  pushl $0
801073b3:	6a 00                	push   $0x0
  pushl $189
801073b5:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801073ba:	e9 da f3 ff ff       	jmp    80106799 <alltraps>

801073bf <vector190>:
.globl vector190
vector190:
  pushl $0
801073bf:	6a 00                	push   $0x0
  pushl $190
801073c1:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801073c6:	e9 ce f3 ff ff       	jmp    80106799 <alltraps>

801073cb <vector191>:
.globl vector191
vector191:
  pushl $0
801073cb:	6a 00                	push   $0x0
  pushl $191
801073cd:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801073d2:	e9 c2 f3 ff ff       	jmp    80106799 <alltraps>

801073d7 <vector192>:
.globl vector192
vector192:
  pushl $0
801073d7:	6a 00                	push   $0x0
  pushl $192
801073d9:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801073de:	e9 b6 f3 ff ff       	jmp    80106799 <alltraps>

801073e3 <vector193>:
.globl vector193
vector193:
  pushl $0
801073e3:	6a 00                	push   $0x0
  pushl $193
801073e5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801073ea:	e9 aa f3 ff ff       	jmp    80106799 <alltraps>

801073ef <vector194>:
.globl vector194
vector194:
  pushl $0
801073ef:	6a 00                	push   $0x0
  pushl $194
801073f1:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801073f6:	e9 9e f3 ff ff       	jmp    80106799 <alltraps>

801073fb <vector195>:
.globl vector195
vector195:
  pushl $0
801073fb:	6a 00                	push   $0x0
  pushl $195
801073fd:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80107402:	e9 92 f3 ff ff       	jmp    80106799 <alltraps>

80107407 <vector196>:
.globl vector196
vector196:
  pushl $0
80107407:	6a 00                	push   $0x0
  pushl $196
80107409:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010740e:	e9 86 f3 ff ff       	jmp    80106799 <alltraps>

80107413 <vector197>:
.globl vector197
vector197:
  pushl $0
80107413:	6a 00                	push   $0x0
  pushl $197
80107415:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010741a:	e9 7a f3 ff ff       	jmp    80106799 <alltraps>

8010741f <vector198>:
.globl vector198
vector198:
  pushl $0
8010741f:	6a 00                	push   $0x0
  pushl $198
80107421:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80107426:	e9 6e f3 ff ff       	jmp    80106799 <alltraps>

8010742b <vector199>:
.globl vector199
vector199:
  pushl $0
8010742b:	6a 00                	push   $0x0
  pushl $199
8010742d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80107432:	e9 62 f3 ff ff       	jmp    80106799 <alltraps>

80107437 <vector200>:
.globl vector200
vector200:
  pushl $0
80107437:	6a 00                	push   $0x0
  pushl $200
80107439:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010743e:	e9 56 f3 ff ff       	jmp    80106799 <alltraps>

80107443 <vector201>:
.globl vector201
vector201:
  pushl $0
80107443:	6a 00                	push   $0x0
  pushl $201
80107445:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010744a:	e9 4a f3 ff ff       	jmp    80106799 <alltraps>

8010744f <vector202>:
.globl vector202
vector202:
  pushl $0
8010744f:	6a 00                	push   $0x0
  pushl $202
80107451:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80107456:	e9 3e f3 ff ff       	jmp    80106799 <alltraps>

8010745b <vector203>:
.globl vector203
vector203:
  pushl $0
8010745b:	6a 00                	push   $0x0
  pushl $203
8010745d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80107462:	e9 32 f3 ff ff       	jmp    80106799 <alltraps>

80107467 <vector204>:
.globl vector204
vector204:
  pushl $0
80107467:	6a 00                	push   $0x0
  pushl $204
80107469:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010746e:	e9 26 f3 ff ff       	jmp    80106799 <alltraps>

80107473 <vector205>:
.globl vector205
vector205:
  pushl $0
80107473:	6a 00                	push   $0x0
  pushl $205
80107475:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010747a:	e9 1a f3 ff ff       	jmp    80106799 <alltraps>

8010747f <vector206>:
.globl vector206
vector206:
  pushl $0
8010747f:	6a 00                	push   $0x0
  pushl $206
80107481:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80107486:	e9 0e f3 ff ff       	jmp    80106799 <alltraps>

8010748b <vector207>:
.globl vector207
vector207:
  pushl $0
8010748b:	6a 00                	push   $0x0
  pushl $207
8010748d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80107492:	e9 02 f3 ff ff       	jmp    80106799 <alltraps>

80107497 <vector208>:
.globl vector208
vector208:
  pushl $0
80107497:	6a 00                	push   $0x0
  pushl $208
80107499:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010749e:	e9 f6 f2 ff ff       	jmp    80106799 <alltraps>

801074a3 <vector209>:
.globl vector209
vector209:
  pushl $0
801074a3:	6a 00                	push   $0x0
  pushl $209
801074a5:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801074aa:	e9 ea f2 ff ff       	jmp    80106799 <alltraps>

801074af <vector210>:
.globl vector210
vector210:
  pushl $0
801074af:	6a 00                	push   $0x0
  pushl $210
801074b1:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801074b6:	e9 de f2 ff ff       	jmp    80106799 <alltraps>

801074bb <vector211>:
.globl vector211
vector211:
  pushl $0
801074bb:	6a 00                	push   $0x0
  pushl $211
801074bd:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801074c2:	e9 d2 f2 ff ff       	jmp    80106799 <alltraps>

801074c7 <vector212>:
.globl vector212
vector212:
  pushl $0
801074c7:	6a 00                	push   $0x0
  pushl $212
801074c9:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801074ce:	e9 c6 f2 ff ff       	jmp    80106799 <alltraps>

801074d3 <vector213>:
.globl vector213
vector213:
  pushl $0
801074d3:	6a 00                	push   $0x0
  pushl $213
801074d5:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801074da:	e9 ba f2 ff ff       	jmp    80106799 <alltraps>

801074df <vector214>:
.globl vector214
vector214:
  pushl $0
801074df:	6a 00                	push   $0x0
  pushl $214
801074e1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801074e6:	e9 ae f2 ff ff       	jmp    80106799 <alltraps>

801074eb <vector215>:
.globl vector215
vector215:
  pushl $0
801074eb:	6a 00                	push   $0x0
  pushl $215
801074ed:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801074f2:	e9 a2 f2 ff ff       	jmp    80106799 <alltraps>

801074f7 <vector216>:
.globl vector216
vector216:
  pushl $0
801074f7:	6a 00                	push   $0x0
  pushl $216
801074f9:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801074fe:	e9 96 f2 ff ff       	jmp    80106799 <alltraps>

80107503 <vector217>:
.globl vector217
vector217:
  pushl $0
80107503:	6a 00                	push   $0x0
  pushl $217
80107505:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010750a:	e9 8a f2 ff ff       	jmp    80106799 <alltraps>

8010750f <vector218>:
.globl vector218
vector218:
  pushl $0
8010750f:	6a 00                	push   $0x0
  pushl $218
80107511:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80107516:	e9 7e f2 ff ff       	jmp    80106799 <alltraps>

8010751b <vector219>:
.globl vector219
vector219:
  pushl $0
8010751b:	6a 00                	push   $0x0
  pushl $219
8010751d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80107522:	e9 72 f2 ff ff       	jmp    80106799 <alltraps>

80107527 <vector220>:
.globl vector220
vector220:
  pushl $0
80107527:	6a 00                	push   $0x0
  pushl $220
80107529:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010752e:	e9 66 f2 ff ff       	jmp    80106799 <alltraps>

80107533 <vector221>:
.globl vector221
vector221:
  pushl $0
80107533:	6a 00                	push   $0x0
  pushl $221
80107535:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010753a:	e9 5a f2 ff ff       	jmp    80106799 <alltraps>

8010753f <vector222>:
.globl vector222
vector222:
  pushl $0
8010753f:	6a 00                	push   $0x0
  pushl $222
80107541:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80107546:	e9 4e f2 ff ff       	jmp    80106799 <alltraps>

8010754b <vector223>:
.globl vector223
vector223:
  pushl $0
8010754b:	6a 00                	push   $0x0
  pushl $223
8010754d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107552:	e9 42 f2 ff ff       	jmp    80106799 <alltraps>

80107557 <vector224>:
.globl vector224
vector224:
  pushl $0
80107557:	6a 00                	push   $0x0
  pushl $224
80107559:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010755e:	e9 36 f2 ff ff       	jmp    80106799 <alltraps>

80107563 <vector225>:
.globl vector225
vector225:
  pushl $0
80107563:	6a 00                	push   $0x0
  pushl $225
80107565:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010756a:	e9 2a f2 ff ff       	jmp    80106799 <alltraps>

8010756f <vector226>:
.globl vector226
vector226:
  pushl $0
8010756f:	6a 00                	push   $0x0
  pushl $226
80107571:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80107576:	e9 1e f2 ff ff       	jmp    80106799 <alltraps>

8010757b <vector227>:
.globl vector227
vector227:
  pushl $0
8010757b:	6a 00                	push   $0x0
  pushl $227
8010757d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107582:	e9 12 f2 ff ff       	jmp    80106799 <alltraps>

80107587 <vector228>:
.globl vector228
vector228:
  pushl $0
80107587:	6a 00                	push   $0x0
  pushl $228
80107589:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010758e:	e9 06 f2 ff ff       	jmp    80106799 <alltraps>

80107593 <vector229>:
.globl vector229
vector229:
  pushl $0
80107593:	6a 00                	push   $0x0
  pushl $229
80107595:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010759a:	e9 fa f1 ff ff       	jmp    80106799 <alltraps>

8010759f <vector230>:
.globl vector230
vector230:
  pushl $0
8010759f:	6a 00                	push   $0x0
  pushl $230
801075a1:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801075a6:	e9 ee f1 ff ff       	jmp    80106799 <alltraps>

801075ab <vector231>:
.globl vector231
vector231:
  pushl $0
801075ab:	6a 00                	push   $0x0
  pushl $231
801075ad:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801075b2:	e9 e2 f1 ff ff       	jmp    80106799 <alltraps>

801075b7 <vector232>:
.globl vector232
vector232:
  pushl $0
801075b7:	6a 00                	push   $0x0
  pushl $232
801075b9:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801075be:	e9 d6 f1 ff ff       	jmp    80106799 <alltraps>

801075c3 <vector233>:
.globl vector233
vector233:
  pushl $0
801075c3:	6a 00                	push   $0x0
  pushl $233
801075c5:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801075ca:	e9 ca f1 ff ff       	jmp    80106799 <alltraps>

801075cf <vector234>:
.globl vector234
vector234:
  pushl $0
801075cf:	6a 00                	push   $0x0
  pushl $234
801075d1:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801075d6:	e9 be f1 ff ff       	jmp    80106799 <alltraps>

801075db <vector235>:
.globl vector235
vector235:
  pushl $0
801075db:	6a 00                	push   $0x0
  pushl $235
801075dd:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801075e2:	e9 b2 f1 ff ff       	jmp    80106799 <alltraps>

801075e7 <vector236>:
.globl vector236
vector236:
  pushl $0
801075e7:	6a 00                	push   $0x0
  pushl $236
801075e9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801075ee:	e9 a6 f1 ff ff       	jmp    80106799 <alltraps>

801075f3 <vector237>:
.globl vector237
vector237:
  pushl $0
801075f3:	6a 00                	push   $0x0
  pushl $237
801075f5:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801075fa:	e9 9a f1 ff ff       	jmp    80106799 <alltraps>

801075ff <vector238>:
.globl vector238
vector238:
  pushl $0
801075ff:	6a 00                	push   $0x0
  pushl $238
80107601:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80107606:	e9 8e f1 ff ff       	jmp    80106799 <alltraps>

8010760b <vector239>:
.globl vector239
vector239:
  pushl $0
8010760b:	6a 00                	push   $0x0
  pushl $239
8010760d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107612:	e9 82 f1 ff ff       	jmp    80106799 <alltraps>

80107617 <vector240>:
.globl vector240
vector240:
  pushl $0
80107617:	6a 00                	push   $0x0
  pushl $240
80107619:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010761e:	e9 76 f1 ff ff       	jmp    80106799 <alltraps>

80107623 <vector241>:
.globl vector241
vector241:
  pushl $0
80107623:	6a 00                	push   $0x0
  pushl $241
80107625:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010762a:	e9 6a f1 ff ff       	jmp    80106799 <alltraps>

8010762f <vector242>:
.globl vector242
vector242:
  pushl $0
8010762f:	6a 00                	push   $0x0
  pushl $242
80107631:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80107636:	e9 5e f1 ff ff       	jmp    80106799 <alltraps>

8010763b <vector243>:
.globl vector243
vector243:
  pushl $0
8010763b:	6a 00                	push   $0x0
  pushl $243
8010763d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107642:	e9 52 f1 ff ff       	jmp    80106799 <alltraps>

80107647 <vector244>:
.globl vector244
vector244:
  pushl $0
80107647:	6a 00                	push   $0x0
  pushl $244
80107649:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010764e:	e9 46 f1 ff ff       	jmp    80106799 <alltraps>

80107653 <vector245>:
.globl vector245
vector245:
  pushl $0
80107653:	6a 00                	push   $0x0
  pushl $245
80107655:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010765a:	e9 3a f1 ff ff       	jmp    80106799 <alltraps>

8010765f <vector246>:
.globl vector246
vector246:
  pushl $0
8010765f:	6a 00                	push   $0x0
  pushl $246
80107661:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80107666:	e9 2e f1 ff ff       	jmp    80106799 <alltraps>

8010766b <vector247>:
.globl vector247
vector247:
  pushl $0
8010766b:	6a 00                	push   $0x0
  pushl $247
8010766d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107672:	e9 22 f1 ff ff       	jmp    80106799 <alltraps>

80107677 <vector248>:
.globl vector248
vector248:
  pushl $0
80107677:	6a 00                	push   $0x0
  pushl $248
80107679:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010767e:	e9 16 f1 ff ff       	jmp    80106799 <alltraps>

80107683 <vector249>:
.globl vector249
vector249:
  pushl $0
80107683:	6a 00                	push   $0x0
  pushl $249
80107685:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010768a:	e9 0a f1 ff ff       	jmp    80106799 <alltraps>

8010768f <vector250>:
.globl vector250
vector250:
  pushl $0
8010768f:	6a 00                	push   $0x0
  pushl $250
80107691:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107696:	e9 fe f0 ff ff       	jmp    80106799 <alltraps>

8010769b <vector251>:
.globl vector251
vector251:
  pushl $0
8010769b:	6a 00                	push   $0x0
  pushl $251
8010769d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801076a2:	e9 f2 f0 ff ff       	jmp    80106799 <alltraps>

801076a7 <vector252>:
.globl vector252
vector252:
  pushl $0
801076a7:	6a 00                	push   $0x0
  pushl $252
801076a9:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801076ae:	e9 e6 f0 ff ff       	jmp    80106799 <alltraps>

801076b3 <vector253>:
.globl vector253
vector253:
  pushl $0
801076b3:	6a 00                	push   $0x0
  pushl $253
801076b5:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801076ba:	e9 da f0 ff ff       	jmp    80106799 <alltraps>

801076bf <vector254>:
.globl vector254
vector254:
  pushl $0
801076bf:	6a 00                	push   $0x0
  pushl $254
801076c1:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
801076c6:	e9 ce f0 ff ff       	jmp    80106799 <alltraps>

801076cb <vector255>:
.globl vector255
vector255:
  pushl $0
801076cb:	6a 00                	push   $0x0
  pushl $255
801076cd:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801076d2:	e9 c2 f0 ff ff       	jmp    80106799 <alltraps>
801076d7:	66 90                	xchg   %ax,%ax
801076d9:	66 90                	xchg   %ax,%ax
801076db:	66 90                	xchg   %ax,%ax
801076dd:	66 90                	xchg   %ax,%ax
801076df:	90                   	nop

801076e0 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801076e0:	55                   	push   %ebp
801076e1:	89 e5                	mov    %esp,%ebp
801076e3:	57                   	push   %edi
801076e4:	56                   	push   %esi
801076e5:	53                   	push   %ebx
801076e6:	89 d3                	mov    %edx,%ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
801076e8:	c1 ea 16             	shr    $0x16,%edx
801076eb:	8d 3c 90             	lea    (%eax,%edx,4),%edi
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801076ee:	83 ec 0c             	sub    $0xc,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
801076f1:	8b 07                	mov    (%edi),%eax
801076f3:	a8 01                	test   $0x1,%al
801076f5:	74 29                	je     80107720 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801076f7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801076fc:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}
80107702:	8d 65 f4             	lea    -0xc(%ebp),%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80107705:	c1 eb 0a             	shr    $0xa,%ebx
80107708:	81 e3 fc 0f 00 00    	and    $0xffc,%ebx
8010770e:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
}
80107711:	5b                   	pop    %ebx
80107712:	5e                   	pop    %esi
80107713:	5f                   	pop    %edi
80107714:	5d                   	pop    %ebp
80107715:	c3                   	ret    
80107716:	8d 76 00             	lea    0x0(%esi),%esi
80107719:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80107720:	85 c9                	test   %ecx,%ecx
80107722:	74 2c                	je     80107750 <walkpgdir+0x70>
80107724:	e8 b7 af ff ff       	call   801026e0 <kalloc>
80107729:	85 c0                	test   %eax,%eax
8010772b:	89 c6                	mov    %eax,%esi
8010772d:	74 21                	je     80107750 <walkpgdir+0x70>
      return 0;
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
8010772f:	83 ec 04             	sub    $0x4,%esp
80107732:	68 00 10 00 00       	push   $0x1000
80107737:	6a 00                	push   $0x0
80107739:	50                   	push   %eax
8010773a:	e8 f1 da ff ff       	call   80105230 <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010773f:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80107745:	83 c4 10             	add    $0x10,%esp
80107748:	83 c8 07             	or     $0x7,%eax
8010774b:	89 07                	mov    %eax,(%edi)
8010774d:	eb b3                	jmp    80107702 <walkpgdir+0x22>
8010774f:	90                   	nop
  }
  return &pgtab[PTX(va)];
}
80107750:	8d 65 f4             	lea    -0xc(%ebp),%esp
  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
      return 0;
80107753:	31 c0                	xor    %eax,%eax
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}
80107755:	5b                   	pop    %ebx
80107756:	5e                   	pop    %esi
80107757:	5f                   	pop    %edi
80107758:	5d                   	pop    %ebp
80107759:	c3                   	ret    
8010775a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107760 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80107760:	55                   	push   %ebp
80107761:	89 e5                	mov    %esp,%ebp
80107763:	57                   	push   %edi
80107764:	56                   	push   %esi
80107765:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80107766:	89 d3                	mov    %edx,%ebx
80107768:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
8010776e:	83 ec 1c             	sub    $0x1c,%esp
80107771:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107774:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80107778:	8b 7d 08             	mov    0x8(%ebp),%edi
8010777b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107780:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80107783:	8b 45 0c             	mov    0xc(%ebp),%eax
80107786:	29 df                	sub    %ebx,%edi
80107788:	83 c8 01             	or     $0x1,%eax
8010778b:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010778e:	eb 15                	jmp    801077a5 <mappages+0x45>
  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
80107790:	f6 00 01             	testb  $0x1,(%eax)
80107793:	75 45                	jne    801077da <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
80107795:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
80107798:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
8010779b:	89 30                	mov    %esi,(%eax)
    if(a == last)
8010779d:	74 31                	je     801077d0 <mappages+0x70>
      break;
    a += PGSIZE;
8010779f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801077a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801077a8:	b9 01 00 00 00       	mov    $0x1,%ecx
801077ad:	89 da                	mov    %ebx,%edx
801077af:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
801077b2:	e8 29 ff ff ff       	call   801076e0 <walkpgdir>
801077b7:	85 c0                	test   %eax,%eax
801077b9:	75 d5                	jne    80107790 <mappages+0x30>
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
801077bb:	8d 65 f4             	lea    -0xc(%ebp),%esp

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
801077be:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
801077c3:	5b                   	pop    %ebx
801077c4:	5e                   	pop    %esi
801077c5:	5f                   	pop    %edi
801077c6:	5d                   	pop    %ebp
801077c7:	c3                   	ret    
801077c8:	90                   	nop
801077c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801077d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(a == last)
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
801077d3:	31 c0                	xor    %eax,%eax
}
801077d5:	5b                   	pop    %ebx
801077d6:	5e                   	pop    %esi
801077d7:	5f                   	pop    %edi
801077d8:	5d                   	pop    %ebp
801077d9:	c3                   	ret    
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
801077da:	83 ec 0c             	sub    $0xc,%esp
801077dd:	68 38 8b 10 80       	push   $0x80108b38
801077e2:	e8 89 8b ff ff       	call   80100370 <panic>
801077e7:	89 f6                	mov    %esi,%esi
801077e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801077f0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801077f0:	55                   	push   %ebp
801077f1:	89 e5                	mov    %esp,%ebp
801077f3:	57                   	push   %edi
801077f4:	56                   	push   %esi
801077f5:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
801077f6:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801077fc:	89 c7                	mov    %eax,%edi
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
801077fe:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107804:	83 ec 1c             	sub    $0x1c,%esp
80107807:	89 4d e0             	mov    %ecx,-0x20(%ebp)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
8010780a:	39 d3                	cmp    %edx,%ebx
8010780c:	73 66                	jae    80107874 <deallocuvm.part.0+0x84>
8010780e:	89 d6                	mov    %edx,%esi
80107810:	eb 3d                	jmp    8010784f <deallocuvm.part.0+0x5f>
80107812:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80107818:	8b 10                	mov    (%eax),%edx
8010781a:	f6 c2 01             	test   $0x1,%dl
8010781d:	74 26                	je     80107845 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
8010781f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80107825:	74 58                	je     8010787f <deallocuvm.part.0+0x8f>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80107827:	83 ec 0c             	sub    $0xc,%esp
8010782a:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80107830:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107833:	52                   	push   %edx
80107834:	e8 f7 ac ff ff       	call   80102530 <kfree>
      *pte = 0;
80107839:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010783c:	83 c4 10             	add    $0x10,%esp
8010783f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80107845:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010784b:	39 f3                	cmp    %esi,%ebx
8010784d:	73 25                	jae    80107874 <deallocuvm.part.0+0x84>
    pte = walkpgdir(pgdir, (char*)a, 0);
8010784f:	31 c9                	xor    %ecx,%ecx
80107851:	89 da                	mov    %ebx,%edx
80107853:	89 f8                	mov    %edi,%eax
80107855:	e8 86 fe ff ff       	call   801076e0 <walkpgdir>
    if(!pte)
8010785a:	85 c0                	test   %eax,%eax
8010785c:	75 ba                	jne    80107818 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
8010785e:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80107864:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
8010786a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107870:	39 f3                	cmp    %esi,%ebx
80107872:	72 db                	jb     8010784f <deallocuvm.part.0+0x5f>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80107874:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107877:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010787a:	5b                   	pop    %ebx
8010787b:	5e                   	pop    %esi
8010787c:	5f                   	pop    %edi
8010787d:	5d                   	pop    %ebp
8010787e:	c3                   	ret    
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
      pa = PTE_ADDR(*pte);
      if(pa == 0)
        panic("kfree");
8010787f:	83 ec 0c             	sub    $0xc,%esp
80107882:	68 c6 82 10 80       	push   $0x801082c6
80107887:	e8 e4 8a ff ff       	call   80100370 <panic>
8010788c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107890 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80107890:	55                   	push   %ebp
80107891:	89 e5                	mov    %esp,%ebp
80107893:	83 ec 18             	sub    $0x18,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
80107896:	e8 75 c1 ff ff       	call   80103a10 <cpuid>
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010789b:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
801078a1:	31 c9                	xor    %ecx,%ecx
801078a3:	ba ff ff ff ff       	mov    $0xffffffff,%edx
801078a8:	66 89 90 78 38 11 80 	mov    %dx,-0x7feec788(%eax)
801078af:	66 89 88 7a 38 11 80 	mov    %cx,-0x7feec786(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801078b6:	ba ff ff ff ff       	mov    $0xffffffff,%edx
801078bb:	31 c9                	xor    %ecx,%ecx
801078bd:	66 89 90 80 38 11 80 	mov    %dx,-0x7feec780(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801078c4:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801078c9:	66 89 88 82 38 11 80 	mov    %cx,-0x7feec77e(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801078d0:	31 c9                	xor    %ecx,%ecx
801078d2:	66 89 90 88 38 11 80 	mov    %dx,-0x7feec778(%eax)
801078d9:	66 89 88 8a 38 11 80 	mov    %cx,-0x7feec776(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801078e0:	ba ff ff ff ff       	mov    $0xffffffff,%edx
801078e5:	31 c9                	xor    %ecx,%ecx
801078e7:	66 89 90 90 38 11 80 	mov    %dx,-0x7feec770(%eax)
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801078ee:	c6 80 7c 38 11 80 00 	movb   $0x0,-0x7feec784(%eax)
static inline void
lgdt(struct segdesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
801078f5:	ba 2f 00 00 00       	mov    $0x2f,%edx
801078fa:	c6 80 7d 38 11 80 9a 	movb   $0x9a,-0x7feec783(%eax)
80107901:	c6 80 7e 38 11 80 cf 	movb   $0xcf,-0x7feec782(%eax)
80107908:	c6 80 7f 38 11 80 00 	movb   $0x0,-0x7feec781(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010790f:	c6 80 84 38 11 80 00 	movb   $0x0,-0x7feec77c(%eax)
80107916:	c6 80 85 38 11 80 92 	movb   $0x92,-0x7feec77b(%eax)
8010791d:	c6 80 86 38 11 80 cf 	movb   $0xcf,-0x7feec77a(%eax)
80107924:	c6 80 87 38 11 80 00 	movb   $0x0,-0x7feec779(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
8010792b:	c6 80 8c 38 11 80 00 	movb   $0x0,-0x7feec774(%eax)
80107932:	c6 80 8d 38 11 80 fa 	movb   $0xfa,-0x7feec773(%eax)
80107939:	c6 80 8e 38 11 80 cf 	movb   $0xcf,-0x7feec772(%eax)
80107940:	c6 80 8f 38 11 80 00 	movb   $0x0,-0x7feec771(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107947:	66 89 88 92 38 11 80 	mov    %cx,-0x7feec76e(%eax)
8010794e:	c6 80 94 38 11 80 00 	movb   $0x0,-0x7feec76c(%eax)
80107955:	c6 80 95 38 11 80 f2 	movb   $0xf2,-0x7feec76b(%eax)
8010795c:	c6 80 96 38 11 80 cf 	movb   $0xcf,-0x7feec76a(%eax)
80107963:	c6 80 97 38 11 80 00 	movb   $0x0,-0x7feec769(%eax)
  lgdt(c->gdt, sizeof(c->gdt));
8010796a:	05 70 38 11 80       	add    $0x80113870,%eax
8010796f:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  pd[1] = (uint)p;
80107973:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80107977:	c1 e8 10             	shr    $0x10,%eax
8010797a:	66 89 45 f6          	mov    %ax,-0xa(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
8010797e:	8d 45 f2             	lea    -0xe(%ebp),%eax
80107981:	0f 01 10             	lgdtl  (%eax)
}
80107984:	c9                   	leave  
80107985:	c3                   	ret    
80107986:	8d 76 00             	lea    0x0(%esi),%esi
80107989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107990 <switchkvm>:
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107990:	a1 64 66 11 80       	mov    0x80116664,%eax

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80107995:	55                   	push   %ebp
80107996:	89 e5                	mov    %esp,%ebp
80107998:	05 00 00 00 80       	add    $0x80000000,%eax
8010799d:	0f 22 d8             	mov    %eax,%cr3
  lcr3(V2P(kpgdir));   // switch to the kernel page table
}
801079a0:	5d                   	pop    %ebp
801079a1:	c3                   	ret    
801079a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801079a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801079b0 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
801079b0:	55                   	push   %ebp
801079b1:	89 e5                	mov    %esp,%ebp
801079b3:	57                   	push   %edi
801079b4:	56                   	push   %esi
801079b5:	53                   	push   %ebx
801079b6:	83 ec 1c             	sub    $0x1c,%esp
801079b9:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
801079bc:	85 f6                	test   %esi,%esi
801079be:	0f 84 cd 00 00 00    	je     80107a91 <switchuvm+0xe1>
    panic("switchuvm: no process");
  if(p->kstack == 0)
801079c4:	8b 46 08             	mov    0x8(%esi),%eax
801079c7:	85 c0                	test   %eax,%eax
801079c9:	0f 84 dc 00 00 00    	je     80107aab <switchuvm+0xfb>
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
801079cf:	8b 7e 04             	mov    0x4(%esi),%edi
801079d2:	85 ff                	test   %edi,%edi
801079d4:	0f 84 c4 00 00 00    	je     80107a9e <switchuvm+0xee>
    panic("switchuvm: no pgdir");

  pushcli();
801079da:	e8 71 d6 ff ff       	call   80105050 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801079df:	e8 dc bf ff ff       	call   801039c0 <mycpu>
801079e4:	89 c3                	mov    %eax,%ebx
801079e6:	e8 d5 bf ff ff       	call   801039c0 <mycpu>
801079eb:	89 c7                	mov    %eax,%edi
801079ed:	e8 ce bf ff ff       	call   801039c0 <mycpu>
801079f2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801079f5:	83 c7 08             	add    $0x8,%edi
801079f8:	e8 c3 bf ff ff       	call   801039c0 <mycpu>
801079fd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107a00:	83 c0 08             	add    $0x8,%eax
80107a03:	ba 67 00 00 00       	mov    $0x67,%edx
80107a08:	c1 e8 18             	shr    $0x18,%eax
80107a0b:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
80107a12:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80107a19:	c6 83 9d 00 00 00 99 	movb   $0x99,0x9d(%ebx)
80107a20:	c6 83 9e 00 00 00 40 	movb   $0x40,0x9e(%ebx)
80107a27:	83 c1 08             	add    $0x8,%ecx
80107a2a:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80107a30:	c1 e9 10             	shr    $0x10,%ecx
80107a33:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
  mycpu()->gdt[SEG_TSS].s = 0;
  mycpu()->ts.ss0 = SEG_KDATA << 3;
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107a39:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
    panic("switchuvm: no pgdir");

  pushcli();
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
80107a3e:	e8 7d bf ff ff       	call   801039c0 <mycpu>
80107a43:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107a4a:	e8 71 bf ff ff       	call   801039c0 <mycpu>
80107a4f:	b9 10 00 00 00       	mov    $0x10,%ecx
80107a54:	66 89 48 10          	mov    %cx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80107a58:	e8 63 bf ff ff       	call   801039c0 <mycpu>
80107a5d:	8b 56 08             	mov    0x8(%esi),%edx
80107a60:	8d 8a 00 10 00 00    	lea    0x1000(%edx),%ecx
80107a66:	89 48 0c             	mov    %ecx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107a69:	e8 52 bf ff ff       	call   801039c0 <mycpu>
80107a6e:	66 89 58 6e          	mov    %bx,0x6e(%eax)
}

static inline void
ltr(ushort sel)
{
  asm volatile("ltr %0" : : "r" (sel));
80107a72:	b8 28 00 00 00       	mov    $0x28,%eax
80107a77:	0f 00 d8             	ltr    %ax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107a7a:	8b 46 04             	mov    0x4(%esi),%eax
80107a7d:	05 00 00 00 80       	add    $0x80000000,%eax
80107a82:	0f 22 d8             	mov    %eax,%cr3
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
}
80107a85:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107a88:	5b                   	pop    %ebx
80107a89:	5e                   	pop    %esi
80107a8a:	5f                   	pop    %edi
80107a8b:	5d                   	pop    %ebp
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
80107a8c:	e9 ff d5 ff ff       	jmp    80105090 <popcli>
// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
80107a91:	83 ec 0c             	sub    $0xc,%esp
80107a94:	68 3e 8b 10 80       	push   $0x80108b3e
80107a99:	e8 d2 88 ff ff       	call   80100370 <panic>
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
    panic("switchuvm: no pgdir");
80107a9e:	83 ec 0c             	sub    $0xc,%esp
80107aa1:	68 69 8b 10 80       	push   $0x80108b69
80107aa6:	e8 c5 88 ff ff       	call   80100370 <panic>
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
80107aab:	83 ec 0c             	sub    $0xc,%esp
80107aae:	68 54 8b 10 80       	push   $0x80108b54
80107ab3:	e8 b8 88 ff ff       	call   80100370 <panic>
80107ab8:	90                   	nop
80107ab9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107ac0 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80107ac0:	55                   	push   %ebp
80107ac1:	89 e5                	mov    %esp,%ebp
80107ac3:	57                   	push   %edi
80107ac4:	56                   	push   %esi
80107ac5:	53                   	push   %ebx
80107ac6:	83 ec 1c             	sub    $0x1c,%esp
80107ac9:	8b 75 10             	mov    0x10(%ebp),%esi
80107acc:	8b 45 08             	mov    0x8(%ebp),%eax
80107acf:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *mem;

  if(sz >= PGSIZE)
80107ad2:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80107ad8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *mem;

  if(sz >= PGSIZE)
80107adb:	77 49                	ja     80107b26 <inituvm+0x66>
    panic("inituvm: more than a page");
  mem = kalloc();
80107add:	e8 fe ab ff ff       	call   801026e0 <kalloc>
  memset(mem, 0, PGSIZE);
80107ae2:	83 ec 04             	sub    $0x4,%esp
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
80107ae5:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80107ae7:	68 00 10 00 00       	push   $0x1000
80107aec:	6a 00                	push   $0x0
80107aee:	50                   	push   %eax
80107aef:	e8 3c d7 ff ff       	call   80105230 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107af4:	58                   	pop    %eax
80107af5:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107afb:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107b00:	5a                   	pop    %edx
80107b01:	6a 06                	push   $0x6
80107b03:	50                   	push   %eax
80107b04:	31 d2                	xor    %edx,%edx
80107b06:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107b09:	e8 52 fc ff ff       	call   80107760 <mappages>
  memmove(mem, init, sz);
80107b0e:	89 75 10             	mov    %esi,0x10(%ebp)
80107b11:	89 7d 0c             	mov    %edi,0xc(%ebp)
80107b14:	83 c4 10             	add    $0x10,%esp
80107b17:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80107b1a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107b1d:	5b                   	pop    %ebx
80107b1e:	5e                   	pop    %esi
80107b1f:	5f                   	pop    %edi
80107b20:	5d                   	pop    %ebp
  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
  memset(mem, 0, PGSIZE);
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
  memmove(mem, init, sz);
80107b21:	e9 ba d7 ff ff       	jmp    801052e0 <memmove>
inituvm(pde_t *pgdir, char *init, uint sz)
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
80107b26:	83 ec 0c             	sub    $0xc,%esp
80107b29:	68 7d 8b 10 80       	push   $0x80108b7d
80107b2e:	e8 3d 88 ff ff       	call   80100370 <panic>
80107b33:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107b39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107b40 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80107b40:	55                   	push   %ebp
80107b41:	89 e5                	mov    %esp,%ebp
80107b43:	57                   	push   %edi
80107b44:	56                   	push   %esi
80107b45:	53                   	push   %ebx
80107b46:	83 ec 0c             	sub    $0xc,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80107b49:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80107b50:	0f 85 91 00 00 00    	jne    80107be7 <loaduvm+0xa7>
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80107b56:	8b 75 18             	mov    0x18(%ebp),%esi
80107b59:	31 db                	xor    %ebx,%ebx
80107b5b:	85 f6                	test   %esi,%esi
80107b5d:	75 1a                	jne    80107b79 <loaduvm+0x39>
80107b5f:	eb 6f                	jmp    80107bd0 <loaduvm+0x90>
80107b61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107b68:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107b6e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80107b74:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80107b77:	76 57                	jbe    80107bd0 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107b79:	8b 55 0c             	mov    0xc(%ebp),%edx
80107b7c:	8b 45 08             	mov    0x8(%ebp),%eax
80107b7f:	31 c9                	xor    %ecx,%ecx
80107b81:	01 da                	add    %ebx,%edx
80107b83:	e8 58 fb ff ff       	call   801076e0 <walkpgdir>
80107b88:	85 c0                	test   %eax,%eax
80107b8a:	74 4e                	je     80107bda <loaduvm+0x9a>
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
80107b8c:	8b 00                	mov    (%eax),%eax
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107b8e:	8b 4d 14             	mov    0x14(%ebp),%ecx
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
    if(sz - i < PGSIZE)
80107b91:	bf 00 10 00 00       	mov    $0x1000,%edi
  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
80107b96:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80107b9b:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80107ba1:	0f 46 fe             	cmovbe %esi,%edi
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107ba4:	01 d9                	add    %ebx,%ecx
80107ba6:	05 00 00 00 80       	add    $0x80000000,%eax
80107bab:	57                   	push   %edi
80107bac:	51                   	push   %ecx
80107bad:	50                   	push   %eax
80107bae:	ff 75 10             	pushl  0x10(%ebp)
80107bb1:	e8 ea 9f ff ff       	call   80101ba0 <readi>
80107bb6:	83 c4 10             	add    $0x10,%esp
80107bb9:	39 c7                	cmp    %eax,%edi
80107bbb:	74 ab                	je     80107b68 <loaduvm+0x28>
      return -1;
  }
  return 0;
}
80107bbd:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
80107bc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return 0;
}
80107bc5:	5b                   	pop    %ebx
80107bc6:	5e                   	pop    %esi
80107bc7:	5f                   	pop    %edi
80107bc8:	5d                   	pop    %ebp
80107bc9:	c3                   	ret    
80107bca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107bd0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
80107bd3:	31 c0                	xor    %eax,%eax
}
80107bd5:	5b                   	pop    %ebx
80107bd6:	5e                   	pop    %esi
80107bd7:	5f                   	pop    %edi
80107bd8:	5d                   	pop    %ebp
80107bd9:	c3                   	ret    

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
80107bda:	83 ec 0c             	sub    $0xc,%esp
80107bdd:	68 97 8b 10 80       	push   $0x80108b97
80107be2:	e8 89 87 ff ff       	call   80100370 <panic>
{
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
80107be7:	83 ec 0c             	sub    $0xc,%esp
80107bea:	68 38 8c 10 80       	push   $0x80108c38
80107bef:	e8 7c 87 ff ff       	call   80100370 <panic>
80107bf4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107bfa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107c00 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107c00:	55                   	push   %ebp
80107c01:	89 e5                	mov    %esp,%ebp
80107c03:	57                   	push   %edi
80107c04:	56                   	push   %esi
80107c05:	53                   	push   %ebx
80107c06:	83 ec 0c             	sub    $0xc,%esp
80107c09:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
80107c0c:	85 ff                	test   %edi,%edi
80107c0e:	0f 88 ca 00 00 00    	js     80107cde <allocuvm+0xde>
    return 0;
  if(newsz < oldsz)
80107c14:	3b 7d 0c             	cmp    0xc(%ebp),%edi
    return oldsz;
80107c17:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
    return 0;
  if(newsz < oldsz)
80107c1a:	0f 82 82 00 00 00    	jb     80107ca2 <allocuvm+0xa2>
    return oldsz;

  a = PGROUNDUP(oldsz);
80107c20:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80107c26:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
80107c2c:	39 df                	cmp    %ebx,%edi
80107c2e:	77 43                	ja     80107c73 <allocuvm+0x73>
80107c30:	e9 bb 00 00 00       	jmp    80107cf0 <allocuvm+0xf0>
80107c35:	8d 76 00             	lea    0x0(%esi),%esi
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
80107c38:	83 ec 04             	sub    $0x4,%esp
80107c3b:	68 00 10 00 00       	push   $0x1000
80107c40:	6a 00                	push   $0x0
80107c42:	50                   	push   %eax
80107c43:	e8 e8 d5 ff ff       	call   80105230 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107c48:	58                   	pop    %eax
80107c49:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80107c4f:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107c54:	5a                   	pop    %edx
80107c55:	6a 06                	push   $0x6
80107c57:	50                   	push   %eax
80107c58:	89 da                	mov    %ebx,%edx
80107c5a:	8b 45 08             	mov    0x8(%ebp),%eax
80107c5d:	e8 fe fa ff ff       	call   80107760 <mappages>
80107c62:	83 c4 10             	add    $0x10,%esp
80107c65:	85 c0                	test   %eax,%eax
80107c67:	78 47                	js     80107cb0 <allocuvm+0xb0>
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80107c69:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107c6f:	39 df                	cmp    %ebx,%edi
80107c71:	76 7d                	jbe    80107cf0 <allocuvm+0xf0>
    mem = kalloc();
80107c73:	e8 68 aa ff ff       	call   801026e0 <kalloc>
    if(mem == 0){
80107c78:	85 c0                	test   %eax,%eax
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
80107c7a:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80107c7c:	75 ba                	jne    80107c38 <allocuvm+0x38>
      cprintf("allocuvm out of memory\n");
80107c7e:	83 ec 0c             	sub    $0xc,%esp
80107c81:	68 b5 8b 10 80       	push   $0x80108bb5
80107c86:	e8 d5 89 ff ff       	call   80100660 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80107c8b:	83 c4 10             	add    $0x10,%esp
80107c8e:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80107c91:	76 4b                	jbe    80107cde <allocuvm+0xde>
80107c93:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107c96:	8b 45 08             	mov    0x8(%ebp),%eax
80107c99:	89 fa                	mov    %edi,%edx
80107c9b:	e8 50 fb ff ff       	call   801077f0 <deallocuvm.part.0>
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
80107ca0:	31 c0                	xor    %eax,%eax
      kfree(mem);
      return 0;
    }
  }
  return newsz;
}
80107ca2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107ca5:	5b                   	pop    %ebx
80107ca6:	5e                   	pop    %esi
80107ca7:	5f                   	pop    %edi
80107ca8:	5d                   	pop    %ebp
80107ca9:	c3                   	ret    
80107caa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
80107cb0:	83 ec 0c             	sub    $0xc,%esp
80107cb3:	68 cd 8b 10 80       	push   $0x80108bcd
80107cb8:	e8 a3 89 ff ff       	call   80100660 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80107cbd:	83 c4 10             	add    $0x10,%esp
80107cc0:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80107cc3:	76 0d                	jbe    80107cd2 <allocuvm+0xd2>
80107cc5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107cc8:	8b 45 08             	mov    0x8(%ebp),%eax
80107ccb:	89 fa                	mov    %edi,%edx
80107ccd:	e8 1e fb ff ff       	call   801077f0 <deallocuvm.part.0>
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
80107cd2:	83 ec 0c             	sub    $0xc,%esp
80107cd5:	56                   	push   %esi
80107cd6:	e8 55 a8 ff ff       	call   80102530 <kfree>
      return 0;
80107cdb:	83 c4 10             	add    $0x10,%esp
    }
  }
  return newsz;
}
80107cde:	8d 65 f4             	lea    -0xc(%ebp),%esp
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
      return 0;
80107ce1:	31 c0                	xor    %eax,%eax
    }
  }
  return newsz;
}
80107ce3:	5b                   	pop    %ebx
80107ce4:	5e                   	pop    %esi
80107ce5:	5f                   	pop    %edi
80107ce6:	5d                   	pop    %ebp
80107ce7:	c3                   	ret    
80107ce8:	90                   	nop
80107ce9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107cf0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80107cf3:	89 f8                	mov    %edi,%eax
      kfree(mem);
      return 0;
    }
  }
  return newsz;
}
80107cf5:	5b                   	pop    %ebx
80107cf6:	5e                   	pop    %esi
80107cf7:	5f                   	pop    %edi
80107cf8:	5d                   	pop    %ebp
80107cf9:	c3                   	ret    
80107cfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107d00 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107d00:	55                   	push   %ebp
80107d01:	89 e5                	mov    %esp,%ebp
80107d03:	8b 55 0c             	mov    0xc(%ebp),%edx
80107d06:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107d09:	8b 45 08             	mov    0x8(%ebp),%eax
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80107d0c:	39 d1                	cmp    %edx,%ecx
80107d0e:	73 10                	jae    80107d20 <deallocuvm+0x20>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80107d10:	5d                   	pop    %ebp
80107d11:	e9 da fa ff ff       	jmp    801077f0 <deallocuvm.part.0>
80107d16:	8d 76 00             	lea    0x0(%esi),%esi
80107d19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80107d20:	89 d0                	mov    %edx,%eax
80107d22:	5d                   	pop    %ebp
80107d23:	c3                   	ret    
80107d24:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107d2a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107d30 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107d30:	55                   	push   %ebp
80107d31:	89 e5                	mov    %esp,%ebp
80107d33:	57                   	push   %edi
80107d34:	56                   	push   %esi
80107d35:	53                   	push   %ebx
80107d36:	83 ec 0c             	sub    $0xc,%esp
80107d39:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80107d3c:	85 f6                	test   %esi,%esi
80107d3e:	74 59                	je     80107d99 <freevm+0x69>
80107d40:	31 c9                	xor    %ecx,%ecx
80107d42:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107d47:	89 f0                	mov    %esi,%eax
80107d49:	e8 a2 fa ff ff       	call   801077f0 <deallocuvm.part.0>
80107d4e:	89 f3                	mov    %esi,%ebx
80107d50:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107d56:	eb 0f                	jmp    80107d67 <freevm+0x37>
80107d58:	90                   	nop
80107d59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107d60:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107d63:	39 fb                	cmp    %edi,%ebx
80107d65:	74 23                	je     80107d8a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107d67:	8b 03                	mov    (%ebx),%eax
80107d69:	a8 01                	test   $0x1,%al
80107d6b:	74 f3                	je     80107d60 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
80107d6d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107d72:	83 ec 0c             	sub    $0xc,%esp
80107d75:	83 c3 04             	add    $0x4,%ebx
80107d78:	05 00 00 00 80       	add    $0x80000000,%eax
80107d7d:	50                   	push   %eax
80107d7e:	e8 ad a7 ff ff       	call   80102530 <kfree>
80107d83:	83 c4 10             	add    $0x10,%esp
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107d86:	39 fb                	cmp    %edi,%ebx
80107d88:	75 dd                	jne    80107d67 <freevm+0x37>
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80107d8a:	89 75 08             	mov    %esi,0x8(%ebp)
}
80107d8d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107d90:	5b                   	pop    %ebx
80107d91:	5e                   	pop    %esi
80107d92:	5f                   	pop    %edi
80107d93:	5d                   	pop    %ebp
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80107d94:	e9 97 a7 ff ff       	jmp    80102530 <kfree>
freevm(pde_t *pgdir)
{
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
80107d99:	83 ec 0c             	sub    $0xc,%esp
80107d9c:	68 e9 8b 10 80       	push   $0x80108be9
80107da1:	e8 ca 85 ff ff       	call   80100370 <panic>
80107da6:	8d 76 00             	lea    0x0(%esi),%esi
80107da9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107db0 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80107db0:	55                   	push   %ebp
80107db1:	89 e5                	mov    %esp,%ebp
80107db3:	56                   	push   %esi
80107db4:	53                   	push   %ebx
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80107db5:	e8 26 a9 ff ff       	call   801026e0 <kalloc>
80107dba:	85 c0                	test   %eax,%eax
80107dbc:	74 6a                	je     80107e28 <setupkvm+0x78>
    return 0;
  memset(pgdir, 0, PGSIZE);
80107dbe:	83 ec 04             	sub    $0x4,%esp
80107dc1:	89 c6                	mov    %eax,%esi
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107dc3:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
80107dc8:	68 00 10 00 00       	push   $0x1000
80107dcd:	6a 00                	push   $0x0
80107dcf:	50                   	push   %eax
80107dd0:	e8 5b d4 ff ff       	call   80105230 <memset>
80107dd5:	83 c4 10             	add    $0x10,%esp
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80107dd8:	8b 43 04             	mov    0x4(%ebx),%eax
80107ddb:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107dde:	83 ec 08             	sub    $0x8,%esp
80107de1:	8b 13                	mov    (%ebx),%edx
80107de3:	ff 73 0c             	pushl  0xc(%ebx)
80107de6:	50                   	push   %eax
80107de7:	29 c1                	sub    %eax,%ecx
80107de9:	89 f0                	mov    %esi,%eax
80107deb:	e8 70 f9 ff ff       	call   80107760 <mappages>
80107df0:	83 c4 10             	add    $0x10,%esp
80107df3:	85 c0                	test   %eax,%eax
80107df5:	78 19                	js     80107e10 <setupkvm+0x60>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107df7:	83 c3 10             	add    $0x10,%ebx
80107dfa:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107e00:	75 d6                	jne    80107dd8 <setupkvm+0x28>
80107e02:	89 f0                	mov    %esi,%eax
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
    }
  return pgdir;
}
80107e04:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107e07:	5b                   	pop    %ebx
80107e08:	5e                   	pop    %esi
80107e09:	5d                   	pop    %ebp
80107e0a:	c3                   	ret    
80107e0b:	90                   	nop
80107e0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
80107e10:	83 ec 0c             	sub    $0xc,%esp
80107e13:	56                   	push   %esi
80107e14:	e8 17 ff ff ff       	call   80107d30 <freevm>
      return 0;
80107e19:	83 c4 10             	add    $0x10,%esp
    }
  return pgdir;
}
80107e1c:	8d 65 f8             	lea    -0x8(%ebp),%esp
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
80107e1f:	31 c0                	xor    %eax,%eax
    }
  return pgdir;
}
80107e21:	5b                   	pop    %ebx
80107e22:	5e                   	pop    %esi
80107e23:	5d                   	pop    %ebp
80107e24:	c3                   	ret    
80107e25:	8d 76 00             	lea    0x0(%esi),%esi
{
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
80107e28:	31 c0                	xor    %eax,%eax
80107e2a:	eb d8                	jmp    80107e04 <setupkvm+0x54>
80107e2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107e30 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80107e30:	55                   	push   %ebp
80107e31:	89 e5                	mov    %esp,%ebp
80107e33:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107e36:	e8 75 ff ff ff       	call   80107db0 <setupkvm>
80107e3b:	a3 64 66 11 80       	mov    %eax,0x80116664
80107e40:	05 00 00 00 80       	add    $0x80000000,%eax
80107e45:	0f 22 d8             	mov    %eax,%cr3
  switchkvm();
}
80107e48:	c9                   	leave  
80107e49:	c3                   	ret    
80107e4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107e50 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107e50:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107e51:	31 c9                	xor    %ecx,%ecx

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107e53:	89 e5                	mov    %esp,%ebp
80107e55:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107e58:	8b 55 0c             	mov    0xc(%ebp),%edx
80107e5b:	8b 45 08             	mov    0x8(%ebp),%eax
80107e5e:	e8 7d f8 ff ff       	call   801076e0 <walkpgdir>
  if(pte == 0)
80107e63:	85 c0                	test   %eax,%eax
80107e65:	74 05                	je     80107e6c <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80107e67:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80107e6a:	c9                   	leave  
80107e6b:	c3                   	ret    
{
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80107e6c:	83 ec 0c             	sub    $0xc,%esp
80107e6f:	68 fa 8b 10 80       	push   $0x80108bfa
80107e74:	e8 f7 84 ff ff       	call   80100370 <panic>
80107e79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107e80 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107e80:	55                   	push   %ebp
80107e81:	89 e5                	mov    %esp,%ebp
80107e83:	57                   	push   %edi
80107e84:	56                   	push   %esi
80107e85:	53                   	push   %ebx
80107e86:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107e89:	e8 22 ff ff ff       	call   80107db0 <setupkvm>
80107e8e:	85 c0                	test   %eax,%eax
80107e90:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107e93:	0f 84 c5 00 00 00    	je     80107f5e <copyuvm+0xde>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107e99:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107e9c:	85 c9                	test   %ecx,%ecx
80107e9e:	0f 84 9c 00 00 00    	je     80107f40 <copyuvm+0xc0>
80107ea4:	31 ff                	xor    %edi,%edi
80107ea6:	eb 4a                	jmp    80107ef2 <copyuvm+0x72>
80107ea8:	90                   	nop
80107ea9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107eb0:	83 ec 04             	sub    $0x4,%esp
80107eb3:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
80107eb9:	68 00 10 00 00       	push   $0x1000
80107ebe:	53                   	push   %ebx
80107ebf:	50                   	push   %eax
80107ec0:	e8 1b d4 ff ff       	call   801052e0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107ec5:	58                   	pop    %eax
80107ec6:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80107ecc:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107ed1:	5a                   	pop    %edx
80107ed2:	ff 75 e4             	pushl  -0x1c(%ebp)
80107ed5:	50                   	push   %eax
80107ed6:	89 fa                	mov    %edi,%edx
80107ed8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107edb:	e8 80 f8 ff ff       	call   80107760 <mappages>
80107ee0:	83 c4 10             	add    $0x10,%esp
80107ee3:	85 c0                	test   %eax,%eax
80107ee5:	78 69                	js     80107f50 <copyuvm+0xd0>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107ee7:	81 c7 00 10 00 00    	add    $0x1000,%edi
80107eed:	39 7d 0c             	cmp    %edi,0xc(%ebp)
80107ef0:	76 4e                	jbe    80107f40 <copyuvm+0xc0>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107ef2:	8b 45 08             	mov    0x8(%ebp),%eax
80107ef5:	31 c9                	xor    %ecx,%ecx
80107ef7:	89 fa                	mov    %edi,%edx
80107ef9:	e8 e2 f7 ff ff       	call   801076e0 <walkpgdir>
80107efe:	85 c0                	test   %eax,%eax
80107f00:	74 6d                	je     80107f6f <copyuvm+0xef>
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
80107f02:	8b 00                	mov    (%eax),%eax
80107f04:	a8 01                	test   $0x1,%al
80107f06:	74 5a                	je     80107f62 <copyuvm+0xe2>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80107f08:	89 c3                	mov    %eax,%ebx
    flags = PTE_FLAGS(*pte);
80107f0a:	25 ff 0f 00 00       	and    $0xfff,%eax
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80107f0f:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    flags = PTE_FLAGS(*pte);
80107f15:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80107f18:	e8 c3 a7 ff ff       	call   801026e0 <kalloc>
80107f1d:	85 c0                	test   %eax,%eax
80107f1f:	89 c6                	mov    %eax,%esi
80107f21:	75 8d                	jne    80107eb0 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
80107f23:	83 ec 0c             	sub    $0xc,%esp
80107f26:	ff 75 e0             	pushl  -0x20(%ebp)
80107f29:	e8 02 fe ff ff       	call   80107d30 <freevm>
  return 0;
80107f2e:	83 c4 10             	add    $0x10,%esp
80107f31:	31 c0                	xor    %eax,%eax
}
80107f33:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107f36:	5b                   	pop    %ebx
80107f37:	5e                   	pop    %esi
80107f38:	5f                   	pop    %edi
80107f39:	5d                   	pop    %ebp
80107f3a:	c3                   	ret    
80107f3b:	90                   	nop
80107f3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107f40:	8b 45 e0             	mov    -0x20(%ebp),%eax
  return d;

bad:
  freevm(d);
  return 0;
}
80107f43:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107f46:	5b                   	pop    %ebx
80107f47:	5e                   	pop    %esi
80107f48:	5f                   	pop    %edi
80107f49:	5d                   	pop    %ebp
80107f4a:	c3                   	ret    
80107f4b:	90                   	nop
80107f4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
      kfree(mem);
80107f50:	83 ec 0c             	sub    $0xc,%esp
80107f53:	56                   	push   %esi
80107f54:	e8 d7 a5 ff ff       	call   80102530 <kfree>
      goto bad;
80107f59:	83 c4 10             	add    $0x10,%esp
80107f5c:	eb c5                	jmp    80107f23 <copyuvm+0xa3>
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
80107f5e:	31 c0                	xor    %eax,%eax
80107f60:	eb d1                	jmp    80107f33 <copyuvm+0xb3>
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
80107f62:	83 ec 0c             	sub    $0xc,%esp
80107f65:	68 1e 8c 10 80       	push   $0x80108c1e
80107f6a:	e8 01 84 ff ff       	call   80100370 <panic>

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
80107f6f:	83 ec 0c             	sub    $0xc,%esp
80107f72:	68 04 8c 10 80       	push   $0x80108c04
80107f77:	e8 f4 83 ff ff       	call   80100370 <panic>
80107f7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107f80 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107f80:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107f81:	31 c9                	xor    %ecx,%ecx

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107f83:	89 e5                	mov    %esp,%ebp
80107f85:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107f88:	8b 55 0c             	mov    0xc(%ebp),%edx
80107f8b:	8b 45 08             	mov    0x8(%ebp),%eax
80107f8e:	e8 4d f7 ff ff       	call   801076e0 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107f93:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
80107f95:	89 c2                	mov    %eax,%edx
80107f97:	83 e2 05             	and    $0x5,%edx
80107f9a:	83 fa 05             	cmp    $0x5,%edx
80107f9d:	75 11                	jne    80107fb0 <uva2ka+0x30>
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
80107f9f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
}
80107fa4:	c9                   	leave  
  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
80107fa5:	05 00 00 00 80       	add    $0x80000000,%eax
}
80107faa:	c3                   	ret    
80107fab:	90                   	nop
80107fac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
80107fb0:	31 c0                	xor    %eax,%eax
  return (char*)P2V(PTE_ADDR(*pte));
}
80107fb2:	c9                   	leave  
80107fb3:	c3                   	ret    
80107fb4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107fba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107fc0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107fc0:	55                   	push   %ebp
80107fc1:	89 e5                	mov    %esp,%ebp
80107fc3:	57                   	push   %edi
80107fc4:	56                   	push   %esi
80107fc5:	53                   	push   %ebx
80107fc6:	83 ec 1c             	sub    $0x1c,%esp
80107fc9:	8b 5d 14             	mov    0x14(%ebp),%ebx
80107fcc:	8b 55 0c             	mov    0xc(%ebp),%edx
80107fcf:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107fd2:	85 db                	test   %ebx,%ebx
80107fd4:	75 40                	jne    80108016 <copyout+0x56>
80107fd6:	eb 70                	jmp    80108048 <copyout+0x88>
80107fd8:	90                   	nop
80107fd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107fe0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107fe3:	89 f1                	mov    %esi,%ecx
80107fe5:	29 d1                	sub    %edx,%ecx
80107fe7:	81 c1 00 10 00 00    	add    $0x1000,%ecx
80107fed:	39 d9                	cmp    %ebx,%ecx
80107fef:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107ff2:	29 f2                	sub    %esi,%edx
80107ff4:	83 ec 04             	sub    $0x4,%esp
80107ff7:	01 d0                	add    %edx,%eax
80107ff9:	51                   	push   %ecx
80107ffa:	57                   	push   %edi
80107ffb:	50                   	push   %eax
80107ffc:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80107fff:	e8 dc d2 ff ff       	call   801052e0 <memmove>
    len -= n;
    buf += n;
80108004:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80108007:	83 c4 10             	add    $0x10,%esp
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
8010800a:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    n = PGSIZE - (va - va0);
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
80108010:	01 cf                	add    %ecx,%edi
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80108012:	29 cb                	sub    %ecx,%ebx
80108014:	74 32                	je     80108048 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
80108016:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80108018:	83 ec 08             	sub    $0x8,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
8010801b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010801e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80108024:	56                   	push   %esi
80108025:	ff 75 08             	pushl  0x8(%ebp)
80108028:	e8 53 ff ff ff       	call   80107f80 <uva2ka>
    if(pa0 == 0)
8010802d:	83 c4 10             	add    $0x10,%esp
80108030:	85 c0                	test   %eax,%eax
80108032:	75 ac                	jne    80107fe0 <copyout+0x20>
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
80108034:	8d 65 f4             	lea    -0xc(%ebp),%esp
  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
80108037:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
8010803c:	5b                   	pop    %ebx
8010803d:	5e                   	pop    %esi
8010803e:	5f                   	pop    %edi
8010803f:	5d                   	pop    %ebp
80108040:	c3                   	ret    
80108041:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108048:	8d 65 f4             	lea    -0xc(%ebp),%esp
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
8010804b:	31 c0                	xor    %eax,%eax
}
8010804d:	5b                   	pop    %ebx
8010804e:	5e                   	pop    %esi
8010804f:	5f                   	pop    %edi
80108050:	5d                   	pop    %ebp
80108051:	c3                   	ret    
