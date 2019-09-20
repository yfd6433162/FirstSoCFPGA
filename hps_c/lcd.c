#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/mman.h>
#include "hwlib.h"
#include "soc_cv_av/socal/socal.h"
#include "soc_cv_av/socal/hps.h"
#include "soc_cv_av/socal/alt_gpio.h"
#include "hps_0.h"
#include "lcd_registers.h"

/*#include "sys/alt_stdio.h"*/
/*#include "system.h"*/


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

void LCDReset(void *lw_lcd_clk_addr, void *lw_lcd_data_addr) {
  *(volatile unsigned long *)lw_lcd_clk_addr = 0x13;
  *(volatile unsigned long *)lw_lcd_data_addr = 0x1FF;
  _wait(1000000);
  *(volatile unsigned long *)lw_lcd_data_addr = 0x3FF;
  _wait(500000);
}

void LCDStart(void *lw_lcd_clk_addr, void *lw_lcd_data_addr) {
  *(volatile unsigned long *)lw_lcd_clk_addr = 0x11;
  *(volatile unsigned long *)lw_lcd_data_addr = 0x3FF;
  _wait(500000);
}

void LCDStop(void *lw_lcd_clk_addr, void *lw_lcd_data_addr) {
  *(volatile unsigned long *)lw_lcd_clk_addr = 0x13;
  *(volatile unsigned long *)lw_lcd_data_addr = 0x3FF;
  _wait(500000);
}

void LCDCmdWrite(void *lw_lcd_clk_addr, void *lw_lcd_data_addr, int data) {
  unsigned int i, j;
  /*i = 12;*/
  /*j = 44;*/
  i = 1;
  j = 4;
  *(volatile unsigned long *)lw_lcd_data_addr = 0x200 | data;
  _wait(j);
  *(volatile unsigned long *)lw_lcd_clk_addr = 0x10;
  _wait(i);
  *(volatile unsigned long *)lw_lcd_clk_addr = 0x11;
  _wait(j);
  /**(volatile unsigned long *)lw_lcd_data_addr = 0x3FF;*/
  /*_wait(i);*/
}

void LCDDataWrite(void *lw_lcd_clk_addr, void *lw_lcd_data_addr, int data) {
  unsigned int i, j;
  /*i = 12;*/
  /*j = 44;*/
  i = 1;
  j = 4;
  *(volatile unsigned long *)lw_lcd_data_addr = 0x300 | data;
  _wait(j);
  *(volatile unsigned long *)lw_lcd_clk_addr = 0x10;
  _wait(i);
  *(volatile unsigned long *)lw_lcd_clk_addr = 0x11;
  _wait(j);
  /**(volatile unsigned long *)lw_lcd_data_addr = 0x3FF;*/
  /*_wait(i);*/
}

unsigned int LCDRead(void *lw_lcd_clk_addr, void *lw_lcd_data_addr) {
  unsigned int i, j;
  unsigned int ret;
  /*i = 12;*/
  /*j = 44;*/
  i = 1;
  j = 4;
  *(volatile unsigned long *)lw_lcd_data_addr = 0x300;
  _wait(j);
  *(volatile unsigned long *)lw_lcd_clk_addr = 0x01;
  _wait(i);
  *(volatile unsigned long *)lw_lcd_clk_addr = 0x11;
  _wait(j);
  ret = *(volatile unsigned long *)lw_lcd_data_addr;
  _wait(j);
  return ret;
}

void AddressSet(void *lw_lcd_clk_addr, void *lw_lcd_data_addr, unsigned int x1,unsigned int y1,unsigned int x2,unsigned int y2)
{
  LCDCmdWrite(lw_lcd_clk_addr, lw_lcd_data_addr, ILI9341_COLADDRSET);
  LCDDataWrite(lw_lcd_clk_addr, lw_lcd_data_addr, 0x00FF & (x1>>8));
  LCDDataWrite(lw_lcd_clk_addr, lw_lcd_data_addr, 0x00FF & x1);
  LCDDataWrite(lw_lcd_clk_addr, lw_lcd_data_addr, 0x00FF & (x2>>8));
  LCDDataWrite(lw_lcd_clk_addr, lw_lcd_data_addr, 0x00FF & x2);
  LCDCmdWrite(lw_lcd_clk_addr, lw_lcd_data_addr, ILI9341_PAGEADDRSET);
  LCDDataWrite(lw_lcd_clk_addr, lw_lcd_data_addr, 0x00FF & (y1>>8));
  LCDDataWrite(lw_lcd_clk_addr, lw_lcd_data_addr, 0x00FF & y1);
  LCDDataWrite(lw_lcd_clk_addr, lw_lcd_data_addr, 0x00FF & (y2>>8));
  LCDDataWrite(lw_lcd_clk_addr, lw_lcd_data_addr, 0x00FF & y2);
}

void LCDClear(void *lw_lcd_clk_addr, void *lw_lcd_data_addr, unsigned int j)                   
{	
  unsigned int i;
  AddressSet(lw_lcd_clk_addr, lw_lcd_data_addr, 0,0,240,320);

  LCDCmdWrite(lw_lcd_clk_addr, lw_lcd_data_addr,  ILI9341_MEMORYWRITE);

  for(i=0;i<240*320;i++)
  {
    LCDDataWrite(lw_lcd_clk_addr, lw_lcd_data_addr, 0x00FF & (j>>8));
    LCDDataWrite(lw_lcd_clk_addr, lw_lcd_data_addr, 0x00FF & j);
  }
}

void LCDInit(void *h2p_lw_lcd_clk_addr, void *h2p_lw_lcd_data_addr)
{	
  int loop_count;
  loop_count = 100 * 1000;

  LCDReset(h2p_lw_lcd_clk_addr, h2p_lw_lcd_data_addr);
  _wait(loop_count);
  LCDStop(h2p_lw_lcd_clk_addr, h2p_lw_lcd_data_addr);

  LCDStart(h2p_lw_lcd_clk_addr, h2p_lw_lcd_data_addr);

  // soft reset
  LCDCmdWrite(h2p_lw_lcd_clk_addr, h2p_lw_lcd_data_addr,  ILI9341_SOFTRESET);
  _wait(loop_count);

  // display off
  LCDCmdWrite(h2p_lw_lcd_clk_addr, h2p_lw_lcd_data_addr,  ILI9341_DISPLAYOFF);

  // interface control
  LCDCmdWrite(h2p_lw_lcd_clk_addr, h2p_lw_lcd_data_addr,  ILI9341_INTERFACECONTROL);
  LCDDataWrite(h2p_lw_lcd_clk_addr, h2p_lw_lcd_data_addr, 0x01);
  LCDDataWrite(h2p_lw_lcd_clk_addr, h2p_lw_lcd_data_addr, 0x01);
  LCDDataWrite(h2p_lw_lcd_clk_addr, h2p_lw_lcd_data_addr, 0x00);

  // Power control B
  LCDCmdWrite(h2p_lw_lcd_clk_addr, h2p_lw_lcd_data_addr,  ILI9341_POWERCONTROLB);
  LCDDataWrite(h2p_lw_lcd_clk_addr, h2p_lw_lcd_data_addr, 0x00);
  LCDDataWrite(h2p_lw_lcd_clk_addr, h2p_lw_lcd_data_addr, 0x81);
  LCDDataWrite(h2p_lw_lcd_clk_addr, h2p_lw_lcd_data_addr, 0x30);

  // Power on sequence control
  LCDCmdWrite(h2p_lw_lcd_clk_addr, h2p_lw_lcd_data_addr,  ILI9341_POWERONSEQ);
  LCDDataWrite(h2p_lw_lcd_clk_addr, h2p_lw_lcd_data_addr, 0x64);
  LCDDataWrite(h2p_lw_lcd_clk_addr, h2p_lw_lcd_data_addr, 0x03);
  LCDDataWrite(h2p_lw_lcd_clk_addr, h2p_lw_lcd_data_addr, 0x12);
  LCDDataWrite(h2p_lw_lcd_clk_addr, h2p_lw_lcd_data_addr, 0x81);

  // Driver timing control A
  LCDCmdWrite(h2p_lw_lcd_clk_addr, h2p_lw_lcd_data_addr,  ILI9341_DRIVERTIMINGA);
  LCDDataWrite(h2p_lw_lcd_clk_addr, h2p_lw_lcd_data_addr, 0x85);
  LCDDataWrite(h2p_lw_lcd_clk_addr, h2p_lw_lcd_data_addr, 0x10);
  LCDDataWrite(h2p_lw_lcd_clk_addr, h2p_lw_lcd_data_addr, 0x78);

  // Power control A
  LCDCmdWrite(h2p_lw_lcd_clk_addr, h2p_lw_lcd_data_addr,  ILI9341_POWERCONTROLA);
  LCDDataWrite(h2p_lw_lcd_clk_addr, h2p_lw_lcd_data_addr, 0x39);
  LCDDataWrite(h2p_lw_lcd_clk_addr, h2p_lw_lcd_data_addr, 0x2C);
  LCDDataWrite(h2p_lw_lcd_clk_addr, h2p_lw_lcd_data_addr, 0x00);
  LCDDataWrite(h2p_lw_lcd_clk_addr, h2p_lw_lcd_data_addr, 0x34);
  LCDDataWrite(h2p_lw_lcd_clk_addr, h2p_lw_lcd_data_addr, 0x02);

  // Rump ratio control
  LCDCmdWrite(h2p_lw_lcd_clk_addr, h2p_lw_lcd_data_addr,  ILI9341_RUMPRATIO);
  LCDDataWrite(h2p_lw_lcd_clk_addr, h2p_lw_lcd_data_addr, 0x20);

  // Driver timing control B
  LCDCmdWrite(h2p_lw_lcd_clk_addr, h2p_lw_lcd_data_addr,  ILI9341_DRIVERTIMINGB);
  LCDDataWrite(h2p_lw_lcd_clk_addr, h2p_lw_lcd_data_addr, 0x00);
  LCDDataWrite(h2p_lw_lcd_clk_addr, h2p_lw_lcd_data_addr, 0x00);

  // RGB signal
  LCDCmdWrite(h2p_lw_lcd_clk_addr, h2p_lw_lcd_data_addr,  ILI9341_RGBSIGNAL);
  LCDDataWrite(h2p_lw_lcd_clk_addr, h2p_lw_lcd_data_addr, 0x00);

  // Inverse control
  LCDCmdWrite(h2p_lw_lcd_clk_addr, h2p_lw_lcd_data_addr,  ILI9341_INVERSIONCONRTOL);
  LCDDataWrite(h2p_lw_lcd_clk_addr, h2p_lw_lcd_data_addr, 0x00);

  //Power control
  //VRH[5:0]
  LCDCmdWrite(h2p_lw_lcd_clk_addr, h2p_lw_lcd_data_addr,  ILI9341_POWERCONTROL1);
  LCDDataWrite(h2p_lw_lcd_clk_addr, h2p_lw_lcd_data_addr, 0x21);

  //Power control
  //SAP[2:0];BT[3:0]
  LCDCmdWrite(h2p_lw_lcd_clk_addr, h2p_lw_lcd_data_addr,  ILI9341_POWERCONTROL2);
  LCDDataWrite(h2p_lw_lcd_clk_addr, h2p_lw_lcd_data_addr, 0x11);

  //VCM control
  //Contrast
  LCDCmdWrite(h2p_lw_lcd_clk_addr, h2p_lw_lcd_data_addr,  ILI9341_VCOMCONTROL1);
  LCDDataWrite(h2p_lw_lcd_clk_addr, h2p_lw_lcd_data_addr, 0x3F);
  LCDDataWrite(h2p_lw_lcd_clk_addr, h2p_lw_lcd_data_addr, 0x3C);

  //VCM control2
  LCDCmdWrite(h2p_lw_lcd_clk_addr, h2p_lw_lcd_data_addr,  ILI9341_VCOMCONTROL2);
  LCDDataWrite(h2p_lw_lcd_clk_addr, h2p_lw_lcd_data_addr, 0xB5);

  // Memory Access Control
  LCDCmdWrite(h2p_lw_lcd_clk_addr, h2p_lw_lcd_data_addr,  ILI9341_MEMCONTROL);
  LCDDataWrite(h2p_lw_lcd_clk_addr, h2p_lw_lcd_data_addr, 0x88);

  // COLMOD: Pixel Format Set
  // 16bit/pixel
  LCDCmdWrite(h2p_lw_lcd_clk_addr, h2p_lw_lcd_data_addr,  ILI9341_PIXELFORMAT);
  LCDDataWrite(h2p_lw_lcd_clk_addr, h2p_lw_lcd_data_addr, 0x55);
  
  // Frame Rate Control (In Normal Mode/Full Colors)
  // 79Hz
  LCDCmdWrite(h2p_lw_lcd_clk_addr, h2p_lw_lcd_data_addr,  ILI9341_FRAMECONTROL);
  LCDDataWrite(h2p_lw_lcd_clk_addr, h2p_lw_lcd_data_addr, 0x00);
  LCDDataWrite(h2p_lw_lcd_clk_addr, h2p_lw_lcd_data_addr, 0x1B);

  // Memory Access Control
  LCDCmdWrite(h2p_lw_lcd_clk_addr, h2p_lw_lcd_data_addr,  ILI9341_MEMORYACCESS);
  LCDDataWrite(h2p_lw_lcd_clk_addr, h2p_lw_lcd_data_addr, 0x88);

  // Enable 3G
  LCDCmdWrite(h2p_lw_lcd_clk_addr, h2p_lw_lcd_data_addr,  ILI9341_ENABLE3G);
  LCDDataWrite(h2p_lw_lcd_clk_addr, h2p_lw_lcd_data_addr, 0x00);

  // Gammma set
  LCDCmdWrite(h2p_lw_lcd_clk_addr, h2p_lw_lcd_data_addr,  ILI9341_GAMMASET);
  LCDDataWrite(h2p_lw_lcd_clk_addr, h2p_lw_lcd_data_addr, 0x01);

  // SetGamma 0
  LCDCmdWrite(h2p_lw_lcd_clk_addr, h2p_lw_lcd_data_addr,  ILI9341_UNDEFINE0);
  LCDDataWrite(h2p_lw_lcd_clk_addr, h2p_lw_lcd_data_addr, 0x0F);
  LCDDataWrite(h2p_lw_lcd_clk_addr, h2p_lw_lcd_data_addr, 0x26);
  LCDDataWrite(h2p_lw_lcd_clk_addr, h2p_lw_lcd_data_addr, 0x24);
  LCDDataWrite(h2p_lw_lcd_clk_addr, h2p_lw_lcd_data_addr, 0x0B);
  LCDDataWrite(h2p_lw_lcd_clk_addr, h2p_lw_lcd_data_addr, 0x0E);
  LCDDataWrite(h2p_lw_lcd_clk_addr, h2p_lw_lcd_data_addr, 0x09);
  LCDDataWrite(h2p_lw_lcd_clk_addr, h2p_lw_lcd_data_addr, 0x54);
  LCDDataWrite(h2p_lw_lcd_clk_addr, h2p_lw_lcd_data_addr, 0xA8);
  LCDDataWrite(h2p_lw_lcd_clk_addr, h2p_lw_lcd_data_addr, 0x46);
  LCDDataWrite(h2p_lw_lcd_clk_addr, h2p_lw_lcd_data_addr, 0x0C);
  LCDDataWrite(h2p_lw_lcd_clk_addr, h2p_lw_lcd_data_addr, 0x17);
  LCDDataWrite(h2p_lw_lcd_clk_addr, h2p_lw_lcd_data_addr, 0x09);
  LCDDataWrite(h2p_lw_lcd_clk_addr, h2p_lw_lcd_data_addr, 0x0F);
  LCDDataWrite(h2p_lw_lcd_clk_addr, h2p_lw_lcd_data_addr, 0x07);
  LCDDataWrite(h2p_lw_lcd_clk_addr, h2p_lw_lcd_data_addr, 0x00);

  // SetGamma 1
  LCDCmdWrite(h2p_lw_lcd_clk_addr, h2p_lw_lcd_data_addr,  ILI9341_UNDEFINE1);
  LCDDataWrite(h2p_lw_lcd_clk_addr, h2p_lw_lcd_data_addr, 0x00);
  LCDDataWrite(h2p_lw_lcd_clk_addr, h2p_lw_lcd_data_addr, 0x19);
  LCDDataWrite(h2p_lw_lcd_clk_addr, h2p_lw_lcd_data_addr, 0x1B);
  LCDDataWrite(h2p_lw_lcd_clk_addr, h2p_lw_lcd_data_addr, 0x04);
  LCDDataWrite(h2p_lw_lcd_clk_addr, h2p_lw_lcd_data_addr, 0x10);
  LCDDataWrite(h2p_lw_lcd_clk_addr, h2p_lw_lcd_data_addr, 0x07);
  LCDDataWrite(h2p_lw_lcd_clk_addr, h2p_lw_lcd_data_addr, 0x2A);
  LCDDataWrite(h2p_lw_lcd_clk_addr, h2p_lw_lcd_data_addr, 0x47);
  LCDDataWrite(h2p_lw_lcd_clk_addr, h2p_lw_lcd_data_addr, 0x39);
  LCDDataWrite(h2p_lw_lcd_clk_addr, h2p_lw_lcd_data_addr, 0x03);
  LCDDataWrite(h2p_lw_lcd_clk_addr, h2p_lw_lcd_data_addr, 0x06);
  LCDDataWrite(h2p_lw_lcd_clk_addr, h2p_lw_lcd_data_addr, 0x06);
  LCDDataWrite(h2p_lw_lcd_clk_addr, h2p_lw_lcd_data_addr, 0x30);
  LCDDataWrite(h2p_lw_lcd_clk_addr, h2p_lw_lcd_data_addr, 0x38);
  LCDDataWrite(h2p_lw_lcd_clk_addr, h2p_lw_lcd_data_addr, 0x0F);

  // Entry mode
  LCDCmdWrite(h2p_lw_lcd_clk_addr, h2p_lw_lcd_data_addr,  ILI9341_ENTRYMODE);
  LCDDataWrite(h2p_lw_lcd_clk_addr, h2p_lw_lcd_data_addr, 0x07);

  //Exit Sleep
  LCDCmdWrite(h2p_lw_lcd_clk_addr, h2p_lw_lcd_data_addr,  ILI9341_SLEEPOUT);

  _wait(loop_count);

  //Display on
  LCDCmdWrite(h2p_lw_lcd_clk_addr, h2p_lw_lcd_data_addr,  ILI9341_DISPLAYON);

  _wait(loop_count);
  LCDCmdWrite(h2p_lw_lcd_clk_addr, h2p_lw_lcd_data_addr,  ILI9341_MEMORYWRITE);
  // above koba section

  LCDStop(h2p_lw_lcd_clk_addr, h2p_lw_lcd_data_addr);
  LCDStart(h2p_lw_lcd_clk_addr, h2p_lw_lcd_data_addr);

  LCDClear(h2p_lw_lcd_clk_addr, h2p_lw_lcd_data_addr, 0xAAAA);

  LCDStop(h2p_lw_lcd_clk_addr, h2p_lw_lcd_data_addr);
}

int main() {

  void *virtual_base;
  int fd;
  int loop_count, ret;
  unsigned int i;

  void *h2p_lw_lcd_data_addr;
  void *h2p_lw_lcd_clk_addr;

  // map the address space for the LED registers into user space so we can interact with them.
  // we'll actually map in the entire CSR span of the HPS since we want to access various registers within that span

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
  
  h2p_lw_lcd_data_addr  = virtual_base + ( ( unsigned long  )( ALT_LWFPGASLVS_OFST + LCD_DATA_BASE ) & ( unsigned long)( HW_REGS_MASK ) );
  h2p_lw_lcd_clk_addr   = virtual_base + ( ( unsigned long  )( ALT_LWFPGASLVS_OFST + LCD_CLK_BASE ) & ( unsigned long)( HW_REGS_MASK ) );
  
  LCDInit(h2p_lw_lcd_clk_addr, h2p_lw_lcd_data_addr);

  // clean up our memory mapping and exit
  
  if( munmap( virtual_base, HW_REGS_SPAN ) != 0 ) {
    printf( "ERROR: munmap() failed...\n" );
    close( fd );
    return( 1 );
  }

  close( fd );

  return( 0 );
}
