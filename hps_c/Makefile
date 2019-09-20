#
TARGET = lcd cam_lcd savePic savePic_w_sccb savePic_all

#
CROSS_COMPILE = arm-linux-gnueabihf-
CFLAGS = -static -g -Wall -Dsoc_cv_av -I${SOCEDS_DEST_ROOT}/ip/altera/hps/altera_hps/hwlib/include
LDFLAGS =  -g -Wall  
CC = $(CROSS_COMPILE)gcc
ARCH= arm

all: $(TARGET)

build: $(TARGET)

.c.o:
	$(CC) $(CFLAGS) $(LDFLAGS) $^ $(LDLIBS) -o $@

.PHONY: clean
clean:
	rm -f $(TARGET) *.a *.o *~ 
