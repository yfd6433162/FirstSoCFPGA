// +FHDR------------------------------------------------------------
//                 Copyright (c) 2019 .
//                       ALL RIGHTS RESERVED
// -----------------------------------------------------------------
// Filename      : src/axi_master.v
// Author        :
// Created On    : 2019-06-07 08:50
// Last Modified :
// -----------------------------------------------------------------
// Description:
//
//
// -FHDR------------------------------------------------------------

`timescale 1ns/1ps
module axi_master(/*autoarg*/
    //Inputs
    ACLK, ARESETn, SW, CAM_WR_EN, bufRGB,
    VsyncEdge, HsyncEdge,
    AWREADY,
    WREADY, BVALID, BRESP, BID, ARREADY,
    RDATA, RID, RVALID, RLAST, RRESP,

    //Outputs
    CAM_FRAME_NUM, AxiPixCount, AxiLineCount, AWVALID, AWLEN,
    AWSIZE, AWBURST, AWLOCK, AWCACHE, AWPROT,
    AWUSER, AWADDR, AWID, WDATA, WSTRB, WID,
    WVALID, WLAST, BREADY, ARVALID, ARLEN,
    ARSIZE, ARBURST, ARLOCK, ARCACHE, ARPROT,
    ARUSER, ARADDR, ARID, RREADY
);

  parameter P_DELAY         = 1;
  parameter P_ADDR_BASE     = 32'h3000_0000;

  parameter ST_IDLE         = 8'd0;
  parameter ST_AW_START     = 8'd1;
  parameter ST_AW_WAIT      = 8'd2;
  parameter ST_WDATA_START  = 8'd3;
  parameter ST_WDATA_WAIT   = 8'd4;
  parameter ST_BRESP_WAIT   = 8'd5;
  parameter ST_AR_START     = 8'd6;
  parameter ST_AR_WAIT      = 8'd7;
  parameter ST_RDATA_START  = 8'd8;
  parameter ST_RDATA_WAIT   = 8'd9;
  parameter ST_ACK_WAIT     = 8'd10;

  input   wire       ACLK;    // input        clock_sink.clk
  input   wire       ARESETn; // input        reset_sink.reset_n
  input   wire [1:0] SW;      // input
  input   wire       CAM_WR_EN;// input

  input   wire [15:0] bufRGB; // input

  input   wire VsyncEdge; // input
  input   wire HsyncEdge; // input

  output  wire [2:0] CAM_FRAME_NUM;// input
  output  wire [9:0] AxiPixCount; // output
  output  wire [8:0] AxiLineCount; // output

  output  wire        AWVALID; // input  altera_axi_slave.awvalid
  output  wire [3:0]  AWLEN;   // input                  .awlen
  output  wire [2:0]  AWSIZE;  // input                  .awsize
  output  wire [1:0]  AWBURST; // input                  .awburst
  output  wire [1:0]  AWLOCK;  // input                  .awlock
  output  wire [3:0]  AWCACHE; // input                  .awcache
  output  wire [2:0]  AWPROT;  // input                  .awprot
  input   wire        AWREADY; // output                 .awready
  output  wire [7:0]  AWUSER;  // input                  .awuser
  output  wire [31:0] AWADDR;  // input                  .awaddr
  output  wire [17:0] AWID;    // input                  .awid

  output  wire [63:0] WDATA;   // input                  .wdata
  output  wire [7:0]  WSTRB;   // input                  .wstrb
  output  wire [17:0] WID;     // input                  .wid
  output  wire        WVALID;  // input                  .wvalid
  output  wire        WLAST;   // input                  .wlast
  input   wire        WREADY;  // output                 .wready

  input   wire        BVALID;  // output                 .bvalid
  input   wire [1:0]  BRESP;   // output                 .bresp
  output  wire        BREADY;  // input                  .bready
  input   wire [17:0] BID;    // output                 .bid

  output  wire        ARVALID; // input                  .arvalid
  output  wire [3:0]  ARLEN;   // input                  .arlen
  output  wire [2:0]  ARSIZE;  // input                  .arsize
  output  wire [1:0]  ARBURST; // input                  .arburst
  output  wire [1:0]  ARLOCK;  // input                  .arlock
  output  wire [3:0]  ARCACHE; // input                  .arcache
  output  wire [2:0]  ARPROT;  // input                  .arprot
  input   wire        ARREADY; // output                 .arready
  output  wire [7:0]  ARUSER;  // input                  .aruser
  output  wire [31:0] ARADDR;  // input                  .araddr
  output  wire [17:0] ARID;    // input                  .arid
  input   wire [63:0] RDATA;  // output                 .rdata
  input   wire [17:0] RID;    // output                 .rid

  input   wire       RVALID;  // output                 .rvalid
  input   wire       RLAST;   // output                 .rlast
  input   wire [1:0] RRESP;   // output                 .rresp
  output  wire        RREADY;  // input                  .rready

  reg [31:0]  r_sw_0;
  reg [31:0]  r_sw_1;
  reg         r_sw_0_latch;
  reg         r_sw_1_latch;
  wire        axi_wr_start;
  wire        axi_rd_start;
  reg [7:0]   axi3_state_machine;

  wire [31:0] w_burst_cnt;
  reg [31:0]  r_burst_cnt;
  wire        w_write_end;

  wire [31:0] w_wr_addr;
  reg [31:0]  r_wr_addr;
  wire [63:0] w_wr_data;
  reg [63:0]  r_wr_data;
  reg [31:0]  r_rd_addr;

  reg [2:0]   r_frame_cnt;
  reg [8:0]   r_line_cnt;
  wire        w_line_end;
  wire        w_pix_ready;
  reg [5:0]   r_pix_cnt;
  wire        w_pix_10_end;
  reg [3:0]   r_pix_10_cnt;

  reg [15:0]  r_wdata [0:63];

  always@(posedge ACLK or negedge ARESETn)  begin
    if (~ARESETn)           r_frame_cnt <= #P_DELAY 3'd0;
    else if (~CAM_WR_EN)    r_frame_cnt <= #P_DELAY r_frame_cnt;
    else if (VsyncEdge)     r_frame_cnt <= #P_DELAY r_frame_cnt + 3'd1;
    else                    r_frame_cnt <= #P_DELAY r_frame_cnt;
  end

  assign CAM_FRAME_NUM = r_frame_cnt - 3'd1;

  assign w_line_end = r_line_cnt == 9'd480;

  always@(posedge ACLK or negedge ARESETn)  begin
    if (~ARESETn)                     r_line_cnt <= #P_DELAY 9'd0;
    else if (~CAM_WR_EN)              r_line_cnt <= #P_DELAY 9'd0;
    else if (VsyncEdge)               r_line_cnt <= #P_DELAY 9'd0;
    else if (w_line_end)              r_line_cnt <= #P_DELAY r_line_cnt;
    else if (HsyncEdge)               r_line_cnt <= #P_DELAY r_line_cnt + 9'd1;
    else                              r_line_cnt <= #P_DELAY r_line_cnt;
  end

  assign AxiLineCount = r_line_cnt;

  assign w_pix_10_end = r_pix_10_cnt == 4'd10;

  always@(posedge ACLK or negedge ARESETn)  begin
    if (~ARESETn)                       r_pix_10_cnt <= #P_DELAY 4'd0;
    else if (~CAM_WR_EN)                r_pix_10_cnt <= #P_DELAY 4'd0;
    else if (w_line_end)                r_pix_10_cnt <= #P_DELAY 4'd0;
    else if (HsyncEdge)                 r_pix_10_cnt <= #P_DELAY 4'd0;
    else if (w_pix_10_end)              r_pix_10_cnt <= #P_DELAY r_pix_10_cnt;
    else if (w_write_end)               r_pix_10_cnt <= #P_DELAY r_pix_10_cnt + 4'd1;
    else                                r_pix_10_cnt <= #P_DELAY r_pix_10_cnt;
  end

  assign w_pix_ready = &r_pix_cnt;

  always@(posedge ACLK or negedge ARESETn)  begin
    if (~ARESETn)                     r_pix_cnt <= #P_DELAY 6'd0;
    else if (~CAM_WR_EN)              r_pix_cnt <= #P_DELAY 6'd0;
    else if (w_line_end)              r_pix_cnt <= #P_DELAY 6'd0;
    else if (HsyncEdge)               r_pix_cnt <= #P_DELAY 6'd0;
    else if (w_write_end)             r_pix_cnt <= #P_DELAY 6'd0;
    else if (w_pix_10_end)            r_pix_cnt <= #P_DELAY 6'd0;
    else if (w_pix_ready)             r_pix_cnt <= #P_DELAY r_pix_cnt;
    else                              r_pix_cnt <= #P_DELAY r_pix_cnt + 6'd1;
  end

  assign AxiPixCount = {r_pix_10_cnt, r_pix_cnt};

  integer i;
  initial begin
    for(i=0;i<64;i=i+1)
      r_wdata[i] = 16'd0;
  end

  always@(posedge ACLK)begin
      r_wdata[r_pix_cnt] <= #P_DELAY bufRGB;
  end

  assign axi_wr_start = w_pix_ready & CAM_WR_EN;

  always@(posedge ACLK or negedge ARESETn)begin
    if(~ARESETn)begin
      r_sw_0 <= #P_DELAY 32'd0;
      r_sw_1 <= #P_DELAY 32'd0;
    end
    else begin
      r_sw_0 <= #P_DELAY {r_sw_0[30:0], SW[0]};
      r_sw_1 <= #P_DELAY {r_sw_1[30:0], SW[1]};
    end
  end

  always@(posedge ACLK or negedge ARESETn)begin
    if(~ARESETn)begin
      r_sw_0_latch <= #P_DELAY 1'd0;
      r_sw_1_latch <= #P_DELAY 1'd0;
    end
    else begin
      r_sw_0_latch <= #P_DELAY &r_sw_0;
      r_sw_1_latch <= #P_DELAY &r_sw_1;
    end
  end

  //assign axi_wr_start = ~r_sw_0_latch && (&r_sw_0);
  //assign axi_rd_start = ~r_sw_1_latch && (&r_sw_1);

  always@(posedge ACLK or negedge ARESETn)begin
    if(~ARESETn)begin
      axi3_state_machine <= #P_DELAY ST_IDLE;
    end
    else begin
      case(axi3_state_machine)
        ST_IDLE:        axi3_state_machine <= #P_DELAY (axi_wr_start) ? ST_AW_START :
                                                       (axi_rd_start) ? ST_AR_START : ST_IDLE;
        ST_AW_START,
        ST_AW_WAIT:     axi3_state_machine <= #P_DELAY (AWVALID&AWREADY) ? ST_WDATA_START : ST_AW_WAIT;
        ST_WDATA_START,
        ST_WDATA_WAIT:  axi3_state_machine <= #P_DELAY (WVALID&WREADY&WLAST) ? ST_BRESP_WAIT :
                                                       (WVALID&WREADY) ? ST_WDATA_START : ST_WDATA_WAIT;
        ST_BRESP_WAIT:  axi3_state_machine <= #P_DELAY (BVALID&BREADY) ? ST_IDLE : ST_BRESP_WAIT;
        ST_AR_START,
        ST_AR_WAIT:     axi3_state_machine <= #P_DELAY (ARVALID&ARREADY) ? ST_RDATA_START : ST_AR_WAIT;
        ST_RDATA_START,
        ST_RDATA_WAIT:  axi3_state_machine <= #P_DELAY (RVALID&RREADY&RLAST) ? ST_IDLE :
                                                       (RVALID&RREADY) ? ST_RDATA_START : ST_RDATA_WAIT;
        default:        axi3_state_machine <= #P_DELAY ST_IDLE;
      endcase
    end
  end

  assign w_write_end = (axi3_state_machine == ST_BRESP_WAIT)&(BVALID&BREADY);

  assign w_wr_addr = {9'd0, r_frame_cnt[2:0],  r_line_cnt[8:0], r_pix_10_cnt[3:0], 7'd0};

  assign w_wr_data = (WVALID&WREADY) ? (r_wr_data + 64'd1) : r_wr_data;

  always@(posedge ACLK or negedge ARESETn)begin
    if(~ARESETn)begin
      r_wr_addr <= #P_DELAY 32'd0;
      r_rd_addr <= #P_DELAY 32'd0;
      r_wr_data <= #P_DELAY 64'd0;
    end
    else begin
      r_rd_addr <= #P_DELAY r_rd_addr;
      r_wr_addr <= #P_DELAY w_wr_addr;
      r_wr_data <= #P_DELAY w_wr_data;
    end
  end

  assign w_burst_cnt = (WVALID&WREADY) ? (r_burst_cnt + 32'd1) : r_burst_cnt;

  always@(posedge ACLK or negedge ARESETn)begin
    if(~ARESETn)begin
      r_burst_cnt <= #P_DELAY 32'd0;
    end
    else if((axi3_state_machine == ST_WDATA_START)|(axi3_state_machine == ST_WDATA_WAIT))begin
      r_burst_cnt <= #P_DELAY w_burst_cnt;
    end
    else begin
      r_burst_cnt <= #P_DELAY 32'd0;
    end
  end

  assign AWVALID = ((axi3_state_machine == ST_AW_START)|(axi3_state_machine == ST_AW_WAIT)) ? 1'b1 : 1'b0;
  assign AWLEN   = ((axi3_state_machine == ST_AW_START)|(axi3_state_machine == ST_AW_WAIT)) ? 4'hf : 4'h0;
  assign AWSIZE  = ((axi3_state_machine == ST_AW_START)|(axi3_state_machine == ST_AW_WAIT)) ? 3'h3 : 3'h0;
  assign AWBURST = ((axi3_state_machine == ST_AW_START)|(axi3_state_machine == ST_AW_WAIT)) ? 2'h1 : 2'h0;
  assign AWLOCK  = ((axi3_state_machine == ST_AW_START)|(axi3_state_machine == ST_AW_WAIT)) ? 2'h0 : 2'h0;
  assign AWCACHE = ((axi3_state_machine == ST_AW_START)|(axi3_state_machine == ST_AW_WAIT)) ? 4'h3 : 4'h0;
  assign AWPROT  = ((axi3_state_machine == ST_AW_START)|(axi3_state_machine == ST_AW_WAIT)) ? 3'h0 : 3'h0;
  assign AWUSER  = ((axi3_state_machine == ST_AW_START)|(axi3_state_machine == ST_AW_WAIT)) ? 8'h0 : 8'h0;
  assign AWADDR  = ((axi3_state_machine == ST_AW_START)|(axi3_state_machine == ST_AW_WAIT)) ? (P_ADDR_BASE + w_wr_addr) : 32'h0;
  assign AWID    = ((axi3_state_machine == ST_AW_START)|(axi3_state_machine == ST_AW_WAIT)) ? {5'd0, r_line_cnt[8:0], r_pix_10_cnt[3:0]} : 18'h0;

  wire [63:0] w_wdata;
  wire w_burst_last;

  assign w_burst_last = r_burst_cnt == 32'd15;
  assign w_wdata =  (r_burst_cnt == 32'd0) ?  {r_wdata[3],  r_wdata[2],   r_wdata[1],   r_wdata[0]}:
                    (r_burst_cnt == 32'd1) ?  {r_wdata[7],  r_wdata[6],   r_wdata[5],   r_wdata[4]}:
                    (r_burst_cnt == 32'd2) ?  {r_wdata[11], r_wdata[10],  r_wdata[9],   r_wdata[8]}:
                    (r_burst_cnt == 32'd3) ?  {r_wdata[15], r_wdata[14],  r_wdata[13],  r_wdata[12]}:
                    (r_burst_cnt == 32'd4) ?  {r_wdata[19], r_wdata[18],  r_wdata[17],  r_wdata[16]}:
                    (r_burst_cnt == 32'd5) ?  {r_wdata[23], r_wdata[22],  r_wdata[21],  r_wdata[20]}:
                    (r_burst_cnt == 32'd6) ?  {r_wdata[27], r_wdata[26],  r_wdata[25],  r_wdata[24]}:
                    (r_burst_cnt == 32'd7) ?  {r_wdata[31], r_wdata[30],  r_wdata[29],  r_wdata[28]}:
                    (r_burst_cnt == 32'd8) ?  {r_wdata[35], r_wdata[34],  r_wdata[33],  r_wdata[32]}:
                    (r_burst_cnt == 32'd9) ?  {r_wdata[39], r_wdata[38],  r_wdata[37],  r_wdata[36]}:
                    (r_burst_cnt == 32'd10) ? {r_wdata[43], r_wdata[42],  r_wdata[41],  r_wdata[40]}:
                    (r_burst_cnt == 32'd11) ? {r_wdata[47], r_wdata[46],  r_wdata[45],  r_wdata[44]}:
                    (r_burst_cnt == 32'd12) ? {r_wdata[51], r_wdata[50],  r_wdata[49],  r_wdata[48]}:
                    (r_burst_cnt == 32'd13) ? {r_wdata[55], r_wdata[54],  r_wdata[53],  r_wdata[52]}:
                    (r_burst_cnt == 32'd14) ? {r_wdata[59], r_wdata[58],  r_wdata[57],  r_wdata[56]}:
                    (w_burst_last)          ? {r_wdata[63], r_wdata[62],  r_wdata[61],  r_wdata[60]}:{r_wdata[0],  r_wdata[1],   r_wdata[2],   r_wdata[3]};

  assign WDATA   = ((axi3_state_machine == ST_WDATA_START)|(axi3_state_machine == ST_WDATA_WAIT)) ? w_wdata : 64'h0;
  assign WSTRB   = ((axi3_state_machine == ST_WDATA_START)|(axi3_state_machine == ST_WDATA_WAIT)) ? 8'hff : 8'h0;
  assign WID     = ((axi3_state_machine == ST_WDATA_START)|(axi3_state_machine == ST_WDATA_WAIT)) ? {5'd0, r_line_cnt[8:0], r_pix_10_cnt[3:0]} : 18'h0;
  assign WVALID  = ((axi3_state_machine == ST_WDATA_START)|(axi3_state_machine == ST_WDATA_WAIT)) ? 1'b1 : 1'b0;
  assign WLAST   = ((axi3_state_machine == ST_WDATA_START)|(axi3_state_machine == ST_WDATA_WAIT)) ? w_burst_last : 1'b0;

  assign BREADY  = (axi3_state_machine == ST_BRESP_WAIT) ? 1'b1 : 1'b0;

  assign ARVALID = ((axi3_state_machine == ST_AR_START)|(axi3_state_machine == ST_AR_WAIT)) ? 1'b1 : 1'b0;
  assign ARLEN   = ((axi3_state_machine == ST_AR_START)|(axi3_state_machine == ST_AR_WAIT)) ? 4'hf : 4'h0;
  assign ARSIZE  = ((axi3_state_machine == ST_AR_START)|(axi3_state_machine == ST_AR_WAIT)) ? 3'h3 : 3'h0;
  assign ARBURST = ((axi3_state_machine == ST_AR_START)|(axi3_state_machine == ST_AR_WAIT)) ? 2'h1 : 2'h0;
  assign ARLOCK  = ((axi3_state_machine == ST_AR_START)|(axi3_state_machine == ST_AR_WAIT)) ? 2'h0 : 2'h0;
  assign ARCACHE = ((axi3_state_machine == ST_AR_START)|(axi3_state_machine == ST_AR_WAIT)) ? 4'h3 : 4'h0;
  assign ARPROT  = ((axi3_state_machine == ST_AR_START)|(axi3_state_machine == ST_AR_WAIT)) ? 3'h0 : 3'h0;
  assign ARUSER  = ((axi3_state_machine == ST_AR_START)|(axi3_state_machine == ST_AR_WAIT)) ? 8'h0 : 8'h0;
  assign ARADDR  = ((axi3_state_machine == ST_AR_START)|(axi3_state_machine == ST_AR_WAIT)) ? (P_ADDR_BASE + r_rd_addr) : 32'h0;
  assign ARID    = 18'h0;

  assign RREADY  = ((axi3_state_machine == ST_RDATA_START)|(axi3_state_machine == ST_RDATA_WAIT)) ? 1'b1 : 1'b0;

endmodule
