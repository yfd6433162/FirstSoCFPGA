`timescale 1ns/1ps

module CAM_CTL(
  input wire CLK,
  input wire RST_N,

  input wire CamHsync,
  input wire CamVsync,
  input wire PCLK,
  input wire [7:0] CamData,
  output wire XCLK,

  input wire [9:0] AxiPixCount,
  input wire [8:0] AxiLineCount,
  output wire [15:0] bufRGB,
  output wire VsyncEdge,
  output wire HsyncEdge
);
  wire [9:0] LineWrAddr;
  wire [15:0] LineWrData;
  wire LineWrEn;

  PIX_CAP PIX_CAP_inst(
    .CLK(CLK),
    .RST_N(RST_N),
    .PCLK(PCLK),
    .CamHsync(CamHsync),
    .CamVsync(CamVsync),
    .CamData(CamData),
    .XCLK(XCLK),
    .LineWrAddr(LineWrAddr),
    .LineWrData(LineWrData),
    .LineWrEn(LineWrEn),
    .VsyncEdge(VsyncEdge),
    .HsyncEdge(HsyncEdge)
  );

  LINE_CTL LINE_CTL_inst(
    .CLK(CLK),
    .RST_N(RST_N),
    .LineWrAddr(LineWrAddr),
    .LineWrData(LineWrData),
    .LineWrEn(LineWrEn),
    .AxiPixCount(AxiPixCount[9:0]),
    .AxiLineCount(AxiLineCount[8:0]),
    .bufRGB(bufRGB)
  );

endmodule
