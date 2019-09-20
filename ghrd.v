// ============================================================================
// Copyright (c) 2014 by Terasic Technologies Inc.
// ============================================================================
//
// Permission:
//
//   Terasic grants permission to use and modify this code for use
//   in synthesis for all Terasic Development Boards and Altera Development
//   Kits made by Terasic.  Other use of this code, including the selling
//   ,duplication, or modification of any portion is strictly prohibited.
//
// Disclaimer:
//
//   This VHDL/Verilog or C/C++ source code is intended as a design reference
//   which illustrates how these types of functions can be implemented.
//   It is the user's responsibility to verify their design for
//   consistency and functionality through the use of formal
//   verification methods.  Terasic provides no warranty regarding the use
//   or functionality of this code.
//
// ============================================================================
//
//  Terasic Technologies Inc
//  9F., No.176, Sec.2, Gongdao 5th Rd, East Dist, Hsinchu City, 30070. Taiwan
//
//
//                     web: http://www.terasic.com/
//                     email: support@terasic.com
//
// ============================================================================
//Date:  Tue Dec  2 09:28:38 2014
// ============================================================================

`define ENABLE_HPS
//`define ENABLE_CLK

module ghrd(

      ///////// ADC /////////
      output             ADC_CONVST,
      output             ADC_SCK,
      output             ADC_SDI,
      input              ADC_SDO,

      ///////// ARDUINO /////////
      inout       [15:0] ARDUINO_IO,
      inout              ARDUINO_RESET_N,

`ifdef ENABLE_CLK
      ///////// CLK /////////
      output             CLK_I2C_SCL,
      inout              CLK_I2C_SDA,
`endif /*ENABLE_CLK*/

      ///////// FPGA /////////
      input              FPGA_CLK1_50,
      input              FPGA_CLK2_50,
      input              FPGA_CLK3_50,

      ///////// GPIO /////////
      inout       [35:0] GPIO_0,
      inout       [35:0] GPIO_1,

`ifdef ENABLE_HPS
      ///////// HPS /////////
      inout              HPS_CONV_USB_N,
      output      [14:0] HPS_DDR3_ADDR,
      output      [2:0]  HPS_DDR3_BA,
      output             HPS_DDR3_CAS_N,
      output             HPS_DDR3_CKE,
      output             HPS_DDR3_CK_N,
      output             HPS_DDR3_CK_P,
      output             HPS_DDR3_CS_N,
      output      [3:0]  HPS_DDR3_DM,
      inout       [31:0] HPS_DDR3_DQ,
      inout       [3:0]  HPS_DDR3_DQS_N,
      inout       [3:0]  HPS_DDR3_DQS_P,
      output             HPS_DDR3_ODT,
      output             HPS_DDR3_RAS_N,
      output             HPS_DDR3_RESET_N,
      input              HPS_DDR3_RZQ,
      output             HPS_DDR3_WE_N,
      output             HPS_ENET_GTX_CLK,
      inout              HPS_ENET_INT_N,
      output             HPS_ENET_MDC,
      inout              HPS_ENET_MDIO,
      input              HPS_ENET_RX_CLK,
      input       [3:0]  HPS_ENET_RX_DATA,
      input              HPS_ENET_RX_DV,
      output      [3:0]  HPS_ENET_TX_DATA,
      output             HPS_ENET_TX_EN,
      inout              HPS_GSENSOR_INT,
      inout              HPS_I2C0_SCLK,
      inout              HPS_I2C0_SDAT,
      inout              HPS_I2C1_SCLK,
      inout              HPS_I2C1_SDAT,
      inout              HPS_KEY,
      inout              HPS_LED,
      inout              HPS_LTC_GPIO,
      output             HPS_SD_CLK,
      inout              HPS_SD_CMD,
      inout       [3:0]  HPS_SD_DATA,
      output             HPS_SPIM_CLK,
      input              HPS_SPIM_MISO,
      output             HPS_SPIM_MOSI,
      inout              HPS_SPIM_SS,
      input              HPS_UART_RX,
      output             HPS_UART_TX,
      input              HPS_USB_CLKOUT,
      inout       [7:0]  HPS_USB_DATA,
      input              HPS_USB_DIR,
      input              HPS_USB_NXT,
      output             HPS_USB_STP,
`endif /*ENABLE_HPS*/

      ///////// KEY /////////
      input       [1:0]  KEY,

      ///////// LED /////////
      output      [7:0]  LED,

      ///////// SW /////////
      input       [3:0]  SW
);


//=======================================================
//  REG/WIRE declarations
//=======================================================
// internal wires and registers declaration
  wire [1:0]  fpga_debounced_buttons;
  wire [7:0]  fpga_led_internal;
  wire        hps_fpga_reset_n;
  wire [2:0]  hps_reset_req;
  wire        hps_cold_reset;
  wire        hps_warm_reset;
  wire        hps_debug_reset;
  wire [27:0] stm_hw_events;

// connection of internal logics
  assign stm_hw_events    = {{13{1'b0}},SW, fpga_led_internal, fpga_debounced_buttons};

  //---Wire
  wire SIO_D;
  wire SIO_CLK;

  wire HsyncEdge;
  wire VsyncEdge;
  wire [15:0] bufRGB;

  wire        AWVALID; // input  altera_axi_slave.awvalid
  wire [3:0]  AWLEN;   // input                  .awlen
  wire [2:0]  AWSIZE;  // input                  .awsize
  wire [1:0]  AWBURST; // input                  .awburst
  wire [1:0]  AWLOCK;  // input                  .awlock
  wire [3:0]  AWCACHE; // input                  .awcache
  wire [2:0]  AWPROT;  // input                  .awprot
  wire        AWREADY; // output                 .awready
  wire [7:0]  AWUSER;  // input                  .awuser
  wire [31:0] AWADDR;  // input                  .awaddr
  wire [17:0] AWID;    // input                  .awid

  wire [63:0] WDATA;   // input                  .wdata
  wire [7:0]  WSTRB;   // input                  .wstrb
  wire [17:0] WID;     // input                  .wid
  wire        WVALID;  // input                  .wvalid
  wire        WLAST;   // input                  .wlast
  wire        WREADY;  // output                 .wready

  wire        BVALID;  // output                 .bvalid
  wire [1:0]  BRESP;   // output                 .bresp
  wire        BREADY;  // input                  .bready
  wire [17:0] BID;     // output                 .bid

  wire        ARVALID; // input                  .arvalid
  wire [3:0]  ARLEN;   // input                  .arlen
  wire [2:0]  ARSIZE;  // input                  .arsize
  wire [1:0]  ARBURST; // input                  .arburst
  wire [1:0]  ARLOCK;  // input                  .arlock
  wire [3:0]  ARCACHE; // input                  .arcache
  wire [2:0]  ARPROT;  // input                  .arprot
  wire        ARREADY; // output                 .arready
  wire [7:0]  ARUSER;  // input                  .aruser
  wire [31:0] ARADDR;  // input                  .araddr
  wire [17:0] ARID;    // input                  .arid
  wire [63:0] RDATA;   // output                 .rdata
  wire [17:0] RID;     // output                 .rid

  wire        RVALID;  // output                 .rvalid
  wire        RLAST;   // output                 .rlast
  wire [1:0]  RRESP;   // output                 .rresp
  wire        RREADY;  // input                  .rready

  wire [9:0] AxiPixCount;
  wire [8:0] AxiLineCount;
  wire [7:0] w_led;

  wire RD_X;
  wire WR_X;
  wire D_CX;
  wire CS_X;
  wire RST_X;
  wire [7:0] LCD_D;
  wire CAM_WR_EN;
  wire [2:0] CAM_FRAME_NUM;

  assign LED = {~w_led[7], ~w_led[6], ~w_led[5], ~w_led[4], ~w_led[3], ~w_led[2], ~w_led[1], ~w_led[0]};


//=======================================================
//  Structural coding
//=======================================================

axi_master axi_master_inst(/*autoinst*/
  .ACLK                           (FPGA_CLK1_50                               ), // input
  .ARESETn                        (1'b1                                       ), // input
  .SW                             (SW[3:2]                                    ), // input
  .CAM_WR_EN                      (CAM_WR_EN                                  ), // input

  .bufRGB                         (bufRGB[15:0]                               ), // input
  .VsyncEdge                      (VsyncEdge                                  ), // input
  .HsyncEdge                      (HsyncEdge                                  ), // input

  .CAM_FRAME_NUM                  (CAM_FRAME_NUM[2:0]                         ), // output
  .AxiPixCount                    (AxiPixCount[9:0]                           ), // output
  .AxiLineCount                   (AxiLineCount[8:0]                          ), // output

  .AWVALID                        (AWVALID                                    ), // output
  .AWLEN                          (AWLEN[3:0]                                 ), // output
  .AWSIZE                         (AWSIZE[2:0]                                ), // output
  .AWBURST                        (AWBURST[1:0]                               ), // output
  .AWLOCK                         (AWLOCK[1:0]                                ), // output
  .AWCACHE                        (AWCACHE[3:0]                               ), // output
  .AWPROT                         (AWPROT[2:0]                                ), // output
  .AWREADY                        (AWREADY                                    ), // input
  .AWUSER                         (AWUSER[7:0]                                ), // output
  .AWADDR                         (AWADDR[31:0]                               ), // output
  .AWID                           (AWID[17:0]                                 ), // output

  .WDATA                          (WDATA[63:0]                                ), // output
  .WSTRB                          (WSTRB[7:0]                                 ), // output
  .WID                            (WID[17:0]                                  ), // output
  .WVALID                         (WVALID                                     ), // output
  .WLAST                          (WLAST                                      ), // output
  .WREADY                         (WREADY                                     ), // input

  .BVALID                         (BVALID                                     ), // input
  .BRESP                          (BRESP[1:0]                                 ), // input
  .BREADY                         (BREADY                                     ), // output
  .BID                            (BID[17:0]                                  ), // input

  .ARVALID                        (ARVALID                                    ), // output
  .ARLEN                          (ARLEN[3:0]                                 ), // output
  .ARSIZE                         (ARSIZE[2:0]                                ), // output
  .ARBURST                        (ARBURST[1:0]                               ), // output
  .ARLOCK                         (ARLOCK[1:0]                                ), // output
  .ARCACHE                        (ARCACHE[3:0]                               ), // output
  .ARPROT                         (ARPROT[2:0]                                ), // output
  .ARREADY                        (ARREADY                                    ), // input
  .ARUSER                         (ARUSER[7:0]                                ), // output
  .ARADDR                         (ARADDR[31:0]                               ), // output
  .ARID                           (ARID[17:0]                                 ), // output
  .RDATA                          (RDATA[63:0]                                ), // input
  .RID                            (RID[17:0]                                  ), // input

  .RVALID                         (RVALID                                     ), // input
  .RLAST                          (RLAST                                      ), // input
  .RRESP                          (RRESP[1:0]                                 ), // input
  .RREADY                         (RREADY                                     )  // output
);


// Source/Probe megawizard instance
hps_reset hps_reset_inst (
  .source_clk (FPGA_CLK1_50),
  .source     (hps_reset_req)
);

altera_edge_detector pulse_cold_reset (
  .clk       (FPGA_CLK1_50),
  .rst_n     (hps_fpga_reset_n),
  .signal_in (hps_reset_req[0]),
  .pulse_out (hps_cold_reset)
);
  defparam pulse_cold_reset.PULSE_EXT = 6;
  defparam pulse_cold_reset.EDGE_TYPE = 1;
  defparam pulse_cold_reset.IGNORE_RST_WHILE_BUSY = 1;

altera_edge_detector pulse_warm_reset (
  .clk       (FPGA_CLK1_50),
  .rst_n     (hps_fpga_reset_n),
  .signal_in (hps_reset_req[1]),
  .pulse_out (hps_warm_reset)
);
  defparam pulse_warm_reset.PULSE_EXT = 2;
  defparam pulse_warm_reset.EDGE_TYPE = 1;
  defparam pulse_warm_reset.IGNORE_RST_WHILE_BUSY = 1;

altera_edge_detector pulse_debug_reset (
  .clk       (FPGA_CLK1_50),
  .rst_n     (hps_fpga_reset_n),
  .signal_in (hps_reset_req[2]),
  .pulse_out (hps_debug_reset)
);
  defparam pulse_debug_reset.PULSE_EXT = 32;
  defparam pulse_debug_reset.EDGE_TYPE = 1;
  defparam pulse_debug_reset.IGNORE_RST_WHILE_BUSY = 1;

//---Logic

CAM_CTL CAM_CTL_inst(
  .CLK(FPGA_CLK1_50),
  .RST_N(1'b1),

  .CamHsync(GPIO_0[32]),
  .CamVsync(GPIO_0[33]),
  .PCLK(GPIO_0[31]),
  .CamData(GPIO_0[29:22]),
  .XCLK(GPIO_0[30]),

  .AxiPixCount(AxiPixCount[9:0]),
  .AxiLineCount(AxiLineCount[8:0]),

  .bufRGB(bufRGB[15:0]),
  .VsyncEdge(VsyncEdge),
  .HsyncEdge(HsyncEdge)
);

  assign GPIO_0[21] = 1'b1; //RESET_X
  assign GPIO_0[20] = 1'b0; //PWON

  assign GPIO_0[34] = SIO_D; //SIO_D
  assign GPIO_0[35] = SIO_CLK; //SIO_CLK

  assign GPIO_1[0] = RD_X; // LCD RD X
  assign GPIO_1[1] = WR_X; // LCD WR_X
  assign GPIO_1[2] = D_CX; // LCD D/CX
  assign GPIO_1[3] = CS_X; // LCD CS_X
  assign GPIO_1[4] = RST_X; // LCD RESET_X
  assign {ARDUINO_IO[7:2], ARDUINO_IO[9:8]} = LCD_D;
  //assign LCD_D = {ARDUINO_IO[7:2], ARDUINO_IO[9], ARDUINO_IO[8]};

 soc_system u0 (
    //Clock&Reset
    .clk_clk                               (FPGA_CLK1_50 ),                        //  clk.clk
    .reset_reset_n                         (1'b1         ),                        //  reset.reset_n
    //HPS ddr
    .memory_mem_a                          ( HPS_DDR3_ADDR),                       //  memory.mem_a
    .memory_mem_ba                         ( HPS_DDR3_BA),                         // .mem_ba
    .memory_mem_ck                         ( HPS_DDR3_CK_P),                       // .mem_ck
    .memory_mem_ck_n                       ( HPS_DDR3_CK_N),                       // .mem_ck_n
    .memory_mem_cke                        ( HPS_DDR3_CKE),                        // .mem_cke
    .memory_mem_cs_n                       ( HPS_DDR3_CS_N),                       // .mem_cs_n
    .memory_mem_ras_n                      ( HPS_DDR3_RAS_N),                      // .mem_ras_n
    .memory_mem_cas_n                      ( HPS_DDR3_CAS_N),                      // .mem_cas_n
    .memory_mem_we_n                       ( HPS_DDR3_WE_N),                       // .mem_we_n
    .memory_mem_reset_n                    ( HPS_DDR3_RESET_N),                    // .mem_reset_n
    .memory_mem_dq                         ( HPS_DDR3_DQ),                         // .mem_dq
    .memory_mem_dqs                        ( HPS_DDR3_DQS_P),                      // .mem_dqs
    .memory_mem_dqs_n                      ( HPS_DDR3_DQS_N),                      // .mem_dqs_n
    .memory_mem_odt                        ( HPS_DDR3_ODT),                        // .mem_odt
    .memory_mem_dm                         ( HPS_DDR3_DM),                         // .mem_dm
    .memory_oct_rzqin                      ( HPS_DDR3_RZQ),                        // .oct_rzqin
    //HPS ethernet
    .hps_0_hps_io_hps_io_emac1_inst_TX_CLK ( HPS_ENET_GTX_CLK),                 //  hps_0_hps_io.hps_io_emac1_inst_TX_CLK
    .hps_0_hps_io_hps_io_emac1_inst_TXD0   ( HPS_ENET_TX_DATA[0] ),             // .hps_io_emac1_inst_TXD0
    .hps_0_hps_io_hps_io_emac1_inst_TXD1   ( HPS_ENET_TX_DATA[1] ),           // .hps_io_emac1_inst_TXD1
    .hps_0_hps_io_hps_io_emac1_inst_TXD2   ( HPS_ENET_TX_DATA[2] ),             // .hps_io_emac1_inst_TXD2
    .hps_0_hps_io_hps_io_emac1_inst_TXD3   ( HPS_ENET_TX_DATA[3] ),             // .hps_io_emac1_inst_TXD3
    .hps_0_hps_io_hps_io_emac1_inst_RXD0   ( HPS_ENET_RX_DATA[0] ),             // .hps_io_emac1_inst_RXD0
    .hps_0_hps_io_hps_io_emac1_inst_MDIO   ( HPS_ENET_MDIO ),                   // .hps_io_emac1_inst_MDIO
    .hps_0_hps_io_hps_io_emac1_inst_MDC    ( HPS_ENET_MDC  ),                   // .hps_io_emac1_inst_MDC
    .hps_0_hps_io_hps_io_emac1_inst_RX_CTL ( HPS_ENET_RX_DV),                   // .hps_io_emac1_inst_RX_CTL
    .hps_0_hps_io_hps_io_emac1_inst_TX_CTL ( HPS_ENET_TX_EN),                   // .hps_io_emac1_inst_TX_CTL
    .hps_0_hps_io_hps_io_emac1_inst_RX_CLK ( HPS_ENET_RX_CLK),                  // .hps_io_emac1_inst_RX_CLK
    .hps_0_hps_io_hps_io_emac1_inst_RXD1   ( HPS_ENET_RX_DATA[1] ),             // .hps_io_emac1_inst_RXD1
    .hps_0_hps_io_hps_io_emac1_inst_RXD2   ( HPS_ENET_RX_DATA[2] ),             // .hps_io_emac1_inst_RXD2
    .hps_0_hps_io_hps_io_emac1_inst_RXD3   ( HPS_ENET_RX_DATA[3] ),             // .hps_io_emac1_inst_RXD3
    //HPS SD card
    .hps_0_hps_io_hps_io_sdio_inst_CMD     ( HPS_SD_CMD    ),                   // .hps_io_sdio_inst_CMD
    .hps_0_hps_io_hps_io_sdio_inst_D0      ( HPS_SD_DATA[0]     ),              // .hps_io_sdio_inst_D0
    .hps_0_hps_io_hps_io_sdio_inst_D1      ( HPS_SD_DATA[1]     ),              // .hps_io_sdio_inst_D1
    .hps_0_hps_io_hps_io_sdio_inst_CLK     ( HPS_SD_CLK   ),                    // .hps_io_sdio_inst_CLK
    .hps_0_hps_io_hps_io_sdio_inst_D2      ( HPS_SD_DATA[2]     ),              // .hps_io_sdio_inst_D2
    .hps_0_hps_io_hps_io_sdio_inst_D3      ( HPS_SD_DATA[3]     ),              // .hps_io_sdio_inst_D3
    //HPS USB
    .hps_0_hps_io_hps_io_usb1_inst_D0      ( HPS_USB_DATA[0]    ),              // .hps_io_usb1_inst_D0
    .hps_0_hps_io_hps_io_usb1_inst_D1      ( HPS_USB_DATA[1]    ),              // .hps_io_usb1_inst_D1
    .hps_0_hps_io_hps_io_usb1_inst_D2      ( HPS_USB_DATA[2]    ),              // .hps_io_usb1_inst_D2
    .hps_0_hps_io_hps_io_usb1_inst_D3      ( HPS_USB_DATA[3]    ),              // .hps_io_usb1_inst_D3
    .hps_0_hps_io_hps_io_usb1_inst_D4      ( HPS_USB_DATA[4]    ),              // .hps_io_usb1_inst_D4
    .hps_0_hps_io_hps_io_usb1_inst_D5      ( HPS_USB_DATA[5]    ),              // .hps_io_usb1_inst_D5
    .hps_0_hps_io_hps_io_usb1_inst_D6      ( HPS_USB_DATA[6]    ),              // .hps_io_usb1_inst_D6
    .hps_0_hps_io_hps_io_usb1_inst_D7      ( HPS_USB_DATA[7]    ),              // .hps_io_usb1_inst_D7
    .hps_0_hps_io_hps_io_usb1_inst_CLK     ( HPS_USB_CLKOUT    ),               // .hps_io_usb1_inst_CLK
    .hps_0_hps_io_hps_io_usb1_inst_STP     ( HPS_USB_STP    ),                  // .hps_io_usb1_inst_STP
    .hps_0_hps_io_hps_io_usb1_inst_DIR     ( HPS_USB_DIR    ),                  // .hps_io_usb1_inst_DIR
    .hps_0_hps_io_hps_io_usb1_inst_NXT     ( HPS_USB_NXT    ),                  // .hps_io_usb1_inst_NXT
    //HPS SPI
    .hps_0_hps_io_hps_io_spim1_inst_CLK    ( HPS_SPIM_CLK  ),                   // .hps_io_spim1_inst_CLK
    .hps_0_hps_io_hps_io_spim1_inst_MOSI   ( HPS_SPIM_MOSI ),                   // .hps_io_spim1_inst_MOSI
    .hps_0_hps_io_hps_io_spim1_inst_MISO   ( HPS_SPIM_MISO ),                   // .hps_io_spim1_inst_MISO
    .hps_0_hps_io_hps_io_spim1_inst_SS0    ( HPS_SPIM_SS   ),                   // .hps_io_spim1_inst_SS0
    //HPS UART
    .hps_0_hps_io_hps_io_uart0_inst_RX     ( HPS_UART_RX   ),                 // .hps_io_uart0_inst_RX
    .hps_0_hps_io_hps_io_uart0_inst_TX     ( HPS_UART_TX   ),                 // .hps_io_uart0_inst_TX
    //HPS I2C1
    .hps_0_hps_io_hps_io_i2c0_inst_SDA     ( HPS_I2C0_SDAT  ),                  //  .hps_io_i2c0_inst_SDA
    .hps_0_hps_io_hps_io_i2c0_inst_SCL     ( HPS_I2C0_SCLK  ),                  // .hps_io_i2c0_inst_SCL
    //HPS I2C2
    .hps_0_hps_io_hps_io_i2c1_inst_SDA     ( HPS_I2C1_SDAT  ),                  // .hps_io_i2c1_inst_SDA
    .hps_0_hps_io_hps_io_i2c1_inst_SCL     ( HPS_I2C1_SCLK  ),                  // .hps_io_i2c1_inst_SCL
    //GPIO
    .hps_0_hps_io_hps_io_gpio_inst_GPIO09  ( HPS_CONV_USB_N ),                // .hps_io_gpio_inst_GPIO09
    .hps_0_hps_io_hps_io_gpio_inst_GPIO35  ( HPS_ENET_INT_N ),                // .hps_io_gpio_inst_GPIO35
    .hps_0_hps_io_hps_io_gpio_inst_GPIO40  ( HPS_LTC_GPIO   ),                // .hps_io_gpio_inst_GPIO40
    .hps_0_hps_io_hps_io_gpio_inst_GPIO53  ( HPS_LED   ),                 // .hps_io_gpio_inst_GPIO53
    .hps_0_hps_io_hps_io_gpio_inst_GPIO54  ( HPS_KEY   ),                 // .hps_io_gpio_inst_GPIO54
    .hps_0_hps_io_hps_io_gpio_inst_GPIO61  ( HPS_GSENSOR_INT ),             // .hps_io_gpio_inst_GPIO61

    .hps_0_f2h_stm_hw_events_stm_hwevents  (stm_hw_events),                 //  hps_0_f2h_stm_hw_events.stm_hwevents
    .hps_0_h2f_reset_reset_n               (hps_fpga_reset_n),                //  hps_0_h2f_reset.reset_n
    .hps_0_f2h_warm_reset_req_reset_n      (~hps_warm_reset),                 //  hps_0_f2h_warm_reset_req.reset_n
    .hps_0_f2h_debug_reset_req_reset_n     (~hps_debug_reset),                //  hps_0_f2h_debug_reset_req.reset_n
    .hps_0_f2h_cold_reset_req_reset_n      (~hps_cold_reset),                 //  hps_0_f2h_cold_reset_req.reset_n
    .pio_led_external_connection_export    (w_led),
    .sda_external_connection_export        (SIO_D),           //     sda_external_connection.export
    .scl_external_connection_export        (SIO_CLK),         //     scl_external_connection.export
    .lcd_clk_external_connection_export    ({3'd0, RD_X, 2'd0, CS_X, WR_X}),     //  lcd_clk_external_connection.export
    .lcd_data_external_connection_in_port  ({8'd0, LCD_D}),  // lcd_data_external_connection.in_port
    .lcd_data_external_connection_out_port ({6'd0, RST_X, D_CX, LCD_D}), //                             .out_port
    .cam_wr_en_external_connection_export     ({7'd0, CAM_WR_EN}),     //     cam_wr_en_external_connection.export
    .cam_frame_num_external_connection_export ({5'd0, CAM_FRAME_NUM}),  // cam_frame_num_external_connection.export


    .hps_0_f2h_sdram0_data_araddr          (ARADDR  ),        //       hps_0_f2h_sdram0_data.araddr
    .hps_0_f2h_sdram0_data_arlen           (ARLEN   ),        //                            .arlen
    .hps_0_f2h_sdram0_data_arid            (ARID    ),        //                            .arid
    .hps_0_f2h_sdram0_data_arsize          (ARSIZE  ),        //                            .arsize
    .hps_0_f2h_sdram0_data_arburst         (ARBURST ),        //                            .arburst
    .hps_0_f2h_sdram0_data_arlock          (ARLOCK  ),        //                            .arlock
    .hps_0_f2h_sdram0_data_arprot          (ARPROT  ),        //                            .arprot
    .hps_0_f2h_sdram0_data_arvalid         (ARVALID ),        //                            .arvalid
    .hps_0_f2h_sdram0_data_arcache         (ARCACHE ),        //                            .arcache
    .hps_0_f2h_sdram0_data_awaddr          (AWADDR  ),        //                            .awaddr
    .hps_0_f2h_sdram0_data_awlen           (AWLEN   ),        //                            .awlen
    .hps_0_f2h_sdram0_data_awid            (AWID    ),        //                            .awid
    .hps_0_f2h_sdram0_data_awsize          (AWSIZE  ),        //                            .awsize
    .hps_0_f2h_sdram0_data_awburst         (AWBURST ),        //                            .awburst
    .hps_0_f2h_sdram0_data_awlock          (AWLOCK  ),        //                            .awlock
    .hps_0_f2h_sdram0_data_awprot          (AWPROT  ),        //                            .awprot
    .hps_0_f2h_sdram0_data_awvalid         (AWVALID ),        //                            .awvalid
    .hps_0_f2h_sdram0_data_awcache         (AWCACHE ),        //                            .awcache
    .hps_0_f2h_sdram0_data_bresp           (BRESP   ),        //                            .bresp
    .hps_0_f2h_sdram0_data_bid             (BID     ),        //                            .bid
    .hps_0_f2h_sdram0_data_bvalid          (BVALID  ),        //                            .bvalid
    .hps_0_f2h_sdram0_data_bready          (BREADY  ),        //                            .bready
    .hps_0_f2h_sdram0_data_arready         (ARREADY ),        //                            .arready
    .hps_0_f2h_sdram0_data_awready         (AWREADY ),        //                            .awready
    .hps_0_f2h_sdram0_data_rready          (RREADY  ),        //                            .rready
    .hps_0_f2h_sdram0_data_rdata           (RDATA   ),        //                            .rdata
    .hps_0_f2h_sdram0_data_rresp           (RRESP   ),        //                            .rresp
    .hps_0_f2h_sdram0_data_rlast           (RLAST   ),        //                            .rlast
    .hps_0_f2h_sdram0_data_rid             (RID     ),        //                            .rid
    .hps_0_f2h_sdram0_data_rvalid          (RVALID  ),        //                            .rvalid
    .hps_0_f2h_sdram0_data_wlast           (WLAST   ),        //                            .wlast
    .hps_0_f2h_sdram0_data_wvalid          (WVALID  ),        //                            .wvalid
    .hps_0_f2h_sdram0_data_wdata           (WDATA   ),        //                            .wdata
    .hps_0_f2h_sdram0_data_wstrb           (WSTRB   ),        //                            .wstrb
    .hps_0_f2h_sdram0_data_wready          (WREADY  ),        //                            .wready
    .hps_0_f2h_sdram0_data_wid             (WID     )         //                            .wid
  );

endmodule
