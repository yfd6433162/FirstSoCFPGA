`timescale 1ns/1ps

module PIX_CAP(
  input wire CLK,
  input wire RST_N,

  input wire PCLK,
  input wire CamHsync,
  input wire CamVsync,
  input wire [7:0] CamData,
  output reg XCLK,

  output wire [9:0] LineWrAddr,
  output wire [15:0] LineWrData,
  output wire LineWrEn,

  output wire VsyncEdge,
  output wire HsyncEdge
);

  parameter P_DELAY = 1;

  reg [2:0] CamHsyncLatch;
  wire CamHsyncRise;
  reg [10:0] PixCnt;
  reg [2:0] CamVsyncLatch;
  reg [7:0] CamDataLatch_0;
  reg [7:0] CamDataLatch_1;
  reg [15:0] CamDataRGB;

  reg [2:0] HsyncLatch;
  reg [2:0] VsyncLatch;

  always @(posedge PCLK or negedge RST_N)begin
    if(~RST_N)
      CamHsyncLatch <= #P_DELAY 3'd0;
    else
      CamHsyncLatch <= #P_DELAY {CamHsyncLatch[1:0], CamHsync};
  end

  assign CamHsyncRise = ~CamHsyncLatch[2] && CamHsyncLatch[1];

  always @(posedge PCLK or negedge RST_N)begin
    if(~RST_N)
      PixCnt <= #P_DELAY 11'd0;
    else if(CamHsyncRise)
      PixCnt <= #P_DELAY 11'd0;
    else
      PixCnt <= #P_DELAY PixCnt + 11'd1;
  end

  always @(posedge PCLK or negedge RST_N)begin
    if(~RST_N) begin
      CamDataLatch_0 <= #P_DELAY 8'd0;
      CamDataLatch_1 <= #P_DELAY 8'd0;
    end
    else begin
      CamDataLatch_0 <= #P_DELAY CamData;
      CamDataLatch_1 <= #P_DELAY CamDataLatch_0;
    end
  end

  always @(posedge PCLK or negedge RST_N)begin
    if(~RST_N)
      CamDataRGB <= #P_DELAY 16'd0;
    else
      CamDataRGB <= #P_DELAY (~PixCnt[0]) ? {CamDataLatch_1, CamDataRGB[7:0]}:
                                            {CamDataRGB[15:8], CamDataLatch_1};
  end

  assign LineWrEn = ~PixCnt[0];
  assign LineWrAddr = PixCnt[10:1];
  assign LineWrData = CamDataRGB;

  always @(posedge PCLK or negedge RST_N)begin
    if(~RST_N)
      CamVsyncLatch <= #P_DELAY 3'd0;
    else
      CamVsyncLatch <= #P_DELAY {CamVsyncLatch[1:0], CamVsync};
  end

  always @(posedge CLK or negedge RST_N)begin
    if(~RST_N)
      XCLK <= #P_DELAY 1'd0;
    else
      XCLK <= #P_DELAY ~XCLK;
  end

  always @(posedge CLK or negedge RST_N)begin
    if(~RST_N)
      VsyncLatch <= #P_DELAY 3'd0;
    else
      VsyncLatch <= #P_DELAY {VsyncLatch[1:0], CamVsync};
  end

  always @(posedge CLK or negedge RST_N)begin
    if(~RST_N)
      HsyncLatch <= #P_DELAY 3'd0;
    else
      HsyncLatch <= #P_DELAY {HsyncLatch[1:0], CamHsync};
  end

  assign VsyncEdge = ~VsyncLatch[2] && VsyncLatch[1];
  assign HsyncEdge = ~HsyncLatch[2] && HsyncLatch[1];

endmodule
