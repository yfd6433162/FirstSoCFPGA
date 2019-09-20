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

void SCCBSendBit(void *lw_scl_addr, void *lw_sda_addr, int data) {
    *(volatile unsigned long *)(lw_scl_addr + 1*4) = 1; // clock dir is output
    *(volatile unsigned long *)lw_scl_addr = 0;
    *(volatile unsigned long *)(lw_sda_addr + 1*4) = 1; // data dir is output
    *(volatile unsigned long *)lw_sda_addr = 0;
    _wait(10);
    if(data == 0) {
        *(volatile unsigned long *)lw_sda_addr = 0;
    } else {
        *(volatile unsigned long *)lw_sda_addr = 1;
    }
    *(volatile unsigned long *)lw_scl_addr = 1;
    _wait(10);
    *(volatile unsigned long *)lw_scl_addr = 0;
}

int SCCBReceiveBit(void *lw_scl_addr, void *lw_sda_addr) {
    unsigned long res;
    *(volatile unsigned long *)(lw_scl_addr + 1*4) = 1; // clock dir is output
    *(volatile unsigned long *)lw_scl_addr = 0;
    _wait(10);
    *(volatile unsigned long *)lw_scl_addr = 1;
    *(volatile unsigned long *)(lw_sda_addr + 1*4) = 0; // data dir is input
    res = *(volatile unsigned long *)lw_sda_addr;
    _wait(10);
    *(volatile unsigned long *)lw_scl_addr = 0;
    return res;
}

int SCCBSendByte(void *lw_scl_addr, void *lw_sda_addr, int data) {
    unsigned long mask = 1<<7;
    int i;

    for(i = 0; i < 8; i++) {
        SCCBSendBit(lw_scl_addr, lw_sda_addr, data & mask);
        mask = mask >> 1;
    }
    return SCCBReceiveBit(lw_scl_addr, lw_sda_addr);
}

unsigned short SCCBReceiveByte(void *lw_scl_addr, void *lw_sda_addr) {
    unsigned short res = 0;
    int i;
    for(i = 0; i < 8; i++) {
        res = res << 1;
        if(SCCBReceiveBit(lw_scl_addr, lw_sda_addr)) {
            res |= 0x01;
        }
    }
    SCCBSendBit(lw_scl_addr, lw_sda_addr, 1);
    return res;
}

void SCCBStart(void *lw_scl_addr, void *lw_sda_addr) {
    _wait(10);
    *(volatile unsigned long *)(lw_sda_addr + 1*4) = 1; // data dir is output
    *(volatile unsigned long *)lw_sda_addr = 1;
    *(volatile unsigned long *)(lw_scl_addr + 1*4) = 1; // clock dir is output
    *(volatile unsigned long *)lw_scl_addr = 1;
    _wait(10);
    *(volatile unsigned long *)lw_sda_addr = 0;
    _wait(10);
    *(volatile unsigned long *)lw_scl_addr = 0;
}

void SCCBStop(void *lw_scl_addr, void *lw_sda_addr) {
    _wait(10);
    *(volatile unsigned long *)(lw_sda_addr + 1*4) = 1; // data dir is output
    *(volatile unsigned long *)lw_sda_addr = 0;
    *(volatile unsigned long *)(lw_scl_addr + 1*4) = 1; // clock dir is output
    *(volatile unsigned long *)lw_scl_addr = 1;
    _wait(10);
    *(volatile unsigned long *)lw_sda_addr = 1;
    _wait(10);
    *(volatile unsigned long *)(lw_sda_addr + 1*4) = 0; // data dir is input
    *(volatile unsigned long *)(lw_scl_addr + 1*4) = 0; // clock dir is input
    _wait(10000);
}

void SCCBWrite(void *lw_scl_addr, void *lw_sda_addr,int addr, int data) {
    int devID = 0x42;

    SCCBStart(lw_scl_addr, lw_sda_addr);
    SCCBSendByte(lw_scl_addr, lw_sda_addr, devID);
    SCCBSendByte(lw_scl_addr, lw_sda_addr, addr);
    SCCBSendByte(lw_scl_addr, lw_sda_addr, data);
    SCCBStop(lw_scl_addr, lw_sda_addr);
}

unsigned short SCCBRead(void *lw_scl_addr, void *lw_sda_addr, int addr) {
    unsigned short res;
    int devID = 0x42;

    SCCBStart(lw_scl_addr, lw_sda_addr);
    SCCBSendByte(lw_scl_addr, lw_sda_addr, devID);
    SCCBSendByte(lw_scl_addr, lw_sda_addr, addr);

    SCCBStart(lw_scl_addr, lw_sda_addr);
    SCCBSendByte(lw_scl_addr, lw_sda_addr, devID|0x01);
    res = SCCBReceiveByte(lw_scl_addr, lw_sda_addr);
    SCCBStop(lw_scl_addr, lw_sda_addr);
    return res;
}

void SCCBInit(void *h2p_lw_scl_addr, void *h2p_lw_sda_addr) {
    SCCBWrite(h2p_lw_scl_addr, h2p_lw_sda_addr, 0x12, 0x80); // reset

    SCCBWrite(h2p_lw_scl_addr, h2p_lw_sda_addr, 0x01, 0x40);
    SCCBWrite(h2p_lw_scl_addr, h2p_lw_sda_addr, 0x02, 0x60);
    SCCBWrite(h2p_lw_scl_addr, h2p_lw_sda_addr, 0x03, 0x0a);
    SCCBWrite(h2p_lw_scl_addr, h2p_lw_sda_addr, 0x0c, 0x00);
    SCCBWrite(h2p_lw_scl_addr, h2p_lw_sda_addr, 0x0e, 0x61);
    SCCBWrite(h2p_lw_scl_addr, h2p_lw_sda_addr, 0x0f, 0x4b);
    SCCBWrite(h2p_lw_scl_addr, h2p_lw_sda_addr, 0x15, 0x00);
    SCCBWrite(h2p_lw_scl_addr, h2p_lw_sda_addr, 0x16, 0x02);
    SCCBWrite(h2p_lw_scl_addr, h2p_lw_sda_addr, 0x17, 0x13);
    SCCBWrite(h2p_lw_scl_addr, h2p_lw_sda_addr, 0x18, 0x01);
    SCCBWrite(h2p_lw_scl_addr, h2p_lw_sda_addr, 0x19, 0x02);
    SCCBWrite(h2p_lw_scl_addr, h2p_lw_sda_addr, 0x1a, 0x7a);
    SCCBWrite(h2p_lw_scl_addr, h2p_lw_sda_addr, 0x1e, 0x37); // from 07 to 37 2012/11/6
    SCCBWrite(h2p_lw_scl_addr, h2p_lw_sda_addr, 0x21, 0x02);
    SCCBWrite(h2p_lw_scl_addr, h2p_lw_sda_addr, 0x22, 0x91);
    SCCBWrite(h2p_lw_scl_addr, h2p_lw_sda_addr, 0x29, 0x07);
    SCCBWrite(h2p_lw_scl_addr, h2p_lw_sda_addr, 0x32, 0xb6);
    SCCBWrite(h2p_lw_scl_addr, h2p_lw_sda_addr, 0x33, 0x0b);
    SCCBWrite(h2p_lw_scl_addr, h2p_lw_sda_addr, 0x34, 0x11);
    SCCBWrite(h2p_lw_scl_addr, h2p_lw_sda_addr, 0x35, 0x0b);
    SCCBWrite(h2p_lw_scl_addr, h2p_lw_sda_addr, 0x37, 0x1d);
    SCCBWrite(h2p_lw_scl_addr, h2p_lw_sda_addr, 0x38, 0x71);
    SCCBWrite(h2p_lw_scl_addr, h2p_lw_sda_addr, 0x39, 0x2a);
    SCCBWrite(h2p_lw_scl_addr, h2p_lw_sda_addr, 0x3b, 0x12);
    SCCBWrite(h2p_lw_scl_addr, h2p_lw_sda_addr, 0x3c, 0x78);
    SCCBWrite(h2p_lw_scl_addr, h2p_lw_sda_addr, 0x3d, 0xc3);
    SCCBWrite(h2p_lw_scl_addr, h2p_lw_sda_addr, 0x3e, 0x00);
    SCCBWrite(h2p_lw_scl_addr, h2p_lw_sda_addr, 0x3f, 0x00);
    SCCBWrite(h2p_lw_scl_addr, h2p_lw_sda_addr, 0x41, 0x08);
    SCCBWrite(h2p_lw_scl_addr, h2p_lw_sda_addr, 0x41, 0x38);
    SCCBWrite(h2p_lw_scl_addr, h2p_lw_sda_addr, 0x43, 0x0a);
    SCCBWrite(h2p_lw_scl_addr, h2p_lw_sda_addr, 0x44, 0xf0);
    SCCBWrite(h2p_lw_scl_addr, h2p_lw_sda_addr, 0x45, 0x34);
    SCCBWrite(h2p_lw_scl_addr, h2p_lw_sda_addr, 0x46, 0x58);
    SCCBWrite(h2p_lw_scl_addr, h2p_lw_sda_addr, 0x47, 0x28);
    SCCBWrite(h2p_lw_scl_addr, h2p_lw_sda_addr, 0x48, 0x3a);
    SCCBWrite(h2p_lw_scl_addr, h2p_lw_sda_addr, 0x4b, 0x09);
    SCCBWrite(h2p_lw_scl_addr, h2p_lw_sda_addr, 0x4c, 0x00);
    SCCBWrite(h2p_lw_scl_addr, h2p_lw_sda_addr, 0x4d, 0x40);
    SCCBWrite(h2p_lw_scl_addr, h2p_lw_sda_addr, 0x4e, 0x20);
    SCCBWrite(h2p_lw_scl_addr, h2p_lw_sda_addr, 0x4f, 0x80);
    SCCBWrite(h2p_lw_scl_addr, h2p_lw_sda_addr, 0x50, 0x80);
    SCCBWrite(h2p_lw_scl_addr, h2p_lw_sda_addr, 0x51, 0x00);
    SCCBWrite(h2p_lw_scl_addr, h2p_lw_sda_addr, 0x52, 0x22);
    SCCBWrite(h2p_lw_scl_addr, h2p_lw_sda_addr, 0x53, 0x5e);
    SCCBWrite(h2p_lw_scl_addr, h2p_lw_sda_addr, 0x54, 0x80);
    SCCBWrite(h2p_lw_scl_addr, h2p_lw_sda_addr, 0x56, 0x40);
    SCCBWrite(h2p_lw_scl_addr, h2p_lw_sda_addr, 0x58, 0x9e);
    SCCBWrite(h2p_lw_scl_addr, h2p_lw_sda_addr, 0x59, 0x88);
    SCCBWrite(h2p_lw_scl_addr, h2p_lw_sda_addr, 0x5a, 0x88);
    SCCBWrite(h2p_lw_scl_addr, h2p_lw_sda_addr, 0x5b, 0x44);
    SCCBWrite(h2p_lw_scl_addr, h2p_lw_sda_addr, 0x5c, 0x67);
    SCCBWrite(h2p_lw_scl_addr, h2p_lw_sda_addr, 0x5d, 0x49);
    SCCBWrite(h2p_lw_scl_addr, h2p_lw_sda_addr, 0x5e, 0x0e);
    SCCBWrite(h2p_lw_scl_addr, h2p_lw_sda_addr, 0x69, 0x00);
    SCCBWrite(h2p_lw_scl_addr, h2p_lw_sda_addr, 0x6a, 0x40);
    SCCBWrite(h2p_lw_scl_addr, h2p_lw_sda_addr, 0x6b, 0x0a);
    SCCBWrite(h2p_lw_scl_addr, h2p_lw_sda_addr, 0x6c, 0x0a);
    SCCBWrite(h2p_lw_scl_addr, h2p_lw_sda_addr, 0x6d, 0x55);
    SCCBWrite(h2p_lw_scl_addr, h2p_lw_sda_addr, 0x6e, 0x11);
    SCCBWrite(h2p_lw_scl_addr, h2p_lw_sda_addr, 0x6f, 0x9f);
    SCCBWrite(h2p_lw_scl_addr, h2p_lw_sda_addr, 0x70, 0x3a);
    SCCBWrite(h2p_lw_scl_addr, h2p_lw_sda_addr, 0x71, 0x35);
    SCCBWrite(h2p_lw_scl_addr, h2p_lw_sda_addr, 0x72, 0x11);
    SCCBWrite(h2p_lw_scl_addr, h2p_lw_sda_addr, 0x73, 0xf0);
    SCCBWrite(h2p_lw_scl_addr, h2p_lw_sda_addr, 0x74, 0x10);
    SCCBWrite(h2p_lw_scl_addr, h2p_lw_sda_addr, 0x75, 0x05);
    SCCBWrite(h2p_lw_scl_addr, h2p_lw_sda_addr, 0x76, 0xe1);
    SCCBWrite(h2p_lw_scl_addr, h2p_lw_sda_addr, 0x77, 0x01);
    SCCBWrite(h2p_lw_scl_addr, h2p_lw_sda_addr, 0x78, 0x04);
    SCCBWrite(h2p_lw_scl_addr, h2p_lw_sda_addr, 0x79, 0x01);
    SCCBWrite(h2p_lw_scl_addr, h2p_lw_sda_addr, 0x8d, 0x4f);
    SCCBWrite(h2p_lw_scl_addr, h2p_lw_sda_addr, 0x8e, 0x00);
    SCCBWrite(h2p_lw_scl_addr, h2p_lw_sda_addr, 0x8f, 0x00);
    SCCBWrite(h2p_lw_scl_addr, h2p_lw_sda_addr, 0x90, 0x00);
    SCCBWrite(h2p_lw_scl_addr, h2p_lw_sda_addr, 0x91, 0x00);
    SCCBWrite(h2p_lw_scl_addr, h2p_lw_sda_addr, 0x96, 0x00);
    SCCBWrite(h2p_lw_scl_addr, h2p_lw_sda_addr, 0x97, 0x30); // from 00 to 30 2012/11/9
    SCCBWrite(h2p_lw_scl_addr, h2p_lw_sda_addr, 0x98, 0x20);
    SCCBWrite(h2p_lw_scl_addr, h2p_lw_sda_addr, 0x99, 0x30);
    SCCBWrite(h2p_lw_scl_addr, h2p_lw_sda_addr, 0x9a, 0x00);
    SCCBWrite(h2p_lw_scl_addr, h2p_lw_sda_addr, 0x9a, 0x84);
    SCCBWrite(h2p_lw_scl_addr, h2p_lw_sda_addr, 0x9b, 0x29);
    SCCBWrite(h2p_lw_scl_addr, h2p_lw_sda_addr, 0x9c, 0x03);
    SCCBWrite(h2p_lw_scl_addr, h2p_lw_sda_addr, 0x9d, 0x4c);
    SCCBWrite(h2p_lw_scl_addr, h2p_lw_sda_addr, 0x9e, 0x3f);
    SCCBWrite(h2p_lw_scl_addr, h2p_lw_sda_addr, 0xa2, 0x02);
    SCCBWrite(h2p_lw_scl_addr, h2p_lw_sda_addr, 0xa4, 0x88);
    SCCBWrite(h2p_lw_scl_addr, h2p_lw_sda_addr, 0xb0, 0x84);
    SCCBWrite(h2p_lw_scl_addr, h2p_lw_sda_addr, 0xb1, 0x0c);
    SCCBWrite(h2p_lw_scl_addr, h2p_lw_sda_addr, 0xb2, 0x0e);
    SCCBWrite(h2p_lw_scl_addr, h2p_lw_sda_addr, 0xb3, 0x82);
    SCCBWrite(h2p_lw_scl_addr, h2p_lw_sda_addr, 0xb8, 0x0a);
    SCCBWrite(h2p_lw_scl_addr, h2p_lw_sda_addr, 0xc8, 0xf0);
    SCCBWrite(h2p_lw_scl_addr, h2p_lw_sda_addr, 0xc9, 0x60);

    SCCBWrite(h2p_lw_scl_addr, h2p_lw_sda_addr, 0x12, 0x04); // RGB
    SCCBWrite(h2p_lw_scl_addr, h2p_lw_sda_addr, 0x8c, 0x00); // RGB444 disable
    SCCBWrite(h2p_lw_scl_addr, h2p_lw_sda_addr, 0x40, 0x10); // RGB565
}

int main(int argc, char **argv) {
    int fd, fd_cam, fd_save;
    void *map_base, *virt_addr;
    unsigned long read_result;
    off_t target;
    char filename[] = "./im.RAW";

    void *virtual_base;
    int loop_count;
    int led_direction;
    int led_mask;

    void *h2p_lw_scl_addr;
    void *h2p_lw_sda_addr;
    void *h2p_lw_cam_wr_en_addr;
    void *h2p_lw_cam_frame_num_addr;

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

    h2p_lw_scl_addr = virtual_base + ( ( unsigned long  )( ALT_LWFPGASLVS_OFST + SCL_BASE ) & ( unsigned long)( HW_REGS_MASK ) );
    h2p_lw_sda_addr = virtual_base + ( ( unsigned long  )( ALT_LWFPGASLVS_OFST + SDA_BASE ) & ( unsigned long)( HW_REGS_MASK ) );
    h2p_lw_cam_wr_en_addr = virtual_base + ( ( unsigned long  )( ALT_LWFPGASLVS_OFST + CAM_WR_EN_BASE ) & ( unsigned long)( HW_REGS_MASK ) );
    h2p_lw_cam_frame_num_addr = virtual_base + ( ( unsigned long  )( ALT_LWFPGASLVS_OFST + CAM_FRAME_NUM_BASE ) & ( unsigned long)( HW_REGS_MASK ) );

    SCCBInit(h2p_lw_scl_addr, h2p_lw_sda_addr);
    *(volatile unsigned long *)h2p_lw_cam_wr_en_addr = 1;
    _wait(100000000);

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

