#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <errno.h>
#include <signal.h>
#include <fcntl.h>
#include <ctype.h>
#include <termios.h>
#include <sys/types.h>
#include <sys/mman.h>
#include "hwlib.h"
#include "soc_cv_av/socal/socal.h"
#include "soc_cv_av/socal/hps.h"
#include "soc_cv_av/socal/alt_gpio.h"
#include "hps_0.h"

#define FATAL do { fprintf(stderr, "Error at line %d, file %s (%d) [%s]\n", \
  __LINE__, __FILE__, errno, strerror(errno)); exit(1); } while(0)

#define MAP_SIZE 8388608UL
#define MAP_MASK (MAP_SIZE - 1)

#define TARGET 805306368UL

#define HW_REGS_BASE ( ALT_STM_OFST )
#define HW_REGS_SPAN ( 0x04000000 )
#define HW_REGS_MASK ( HW_REGS_SPAN - 1 )

void _wait(loop_count)
int loop_count;
{
    volatile int sum, data;
    sum = 0;
    for (data = 0; data < loop_count; data++) {
        sum = (data << 8);
    }
  return;
}

int main(int argc, char **argv) {
    int fd, fd_cam, fd_save;
    void *map_base, *virt_addr;
    unsigned long read_result;
    off_t target;
    char filename[] = "./im.RAW";

    void *virtual_base;
    int loop_count;

    if( ( fd = open( "/dev/mem", ( O_RDWR | O_SYNC ) ) ) == -1 ) {
      printf( "ERROR: could not open \"/dev/mem\"...\n" );
      return( 1 );
    }

    virtual_base = mmap( NULL, HW_REGS_SPAN, ( PROT_READ | PROT_WRITE ), MAP_SHARED, fd, HW_REGS_BASE );

    if( virtual_base == MAP_FAILED ) {
      printf( "ERROR: mmap() failed...\n" );
      close( fd );
      return( 1 );
    }

    target = (off_t) TARGET;

    if((fd_cam = open("/dev/mem", O_RDONLY | O_SYNC)) == -1) FATAL;
    printf("/dev/mem opened.\n"); 
    fflush(stdout);

    /* Map pages */
    map_base = mmap(0, MAP_SIZE, PROT_READ, MAP_SHARED, fd_cam, target & ~MAP_MASK);
    if(map_base == (void *) -1) FATAL;
    printf("Memory mapped at address %p.\n", map_base); 
    fflush(stdout);

    virt_addr = map_base + (target & MAP_MASK);

    printf("Value at address 0x%lX (%p): 0x%lX\n", target, virt_addr, read_result);
    fflush(stdout);

    if ( remove(filename) == 0 ) {
      printf("%sの削除が完了しました．\n", filename);
    } else {
      printf("stderr, %sの削除に失敗しました．\n", filename);
    }
    if((fd_save = open(filename, O_RDWR | O_CREAT | O_SYNC | S_IRWXU)) == -1) FATAL;
    printf("./im.RAW opened.\n");
    fflush(stdout);
    write(fd_save, (unsigned char *) virt_addr, 1048576UL);
    close(fd_save);

    if(munmap(virtual_base, MAP_SIZE) == -1) FATAL;
    close(fd);
    return 0;

    if(munmap(map_base, MAP_SIZE) == -1) FATAL;
    close(fd_cam);
    return 0;
}

