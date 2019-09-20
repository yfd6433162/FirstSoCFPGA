`timescale 1ns/1ps

module LINE_CTL (
  input wire CLK,
  input wire RST_N,
  input wire [9:0] LineWrAddr,
  input wire [15:0] LineWrData,
  input wire LineWrEn,
  input wire [9:0] AxiPixCount,
  input wire [8:0] AxiLineCount,
  output wire [15:0] bufRGB
);
  parameter P_DELAY = 1;

  wire wren_a;
  wire wren_b;
  reg [9:0] rdaddress;
  wire [15:0] q_a;
  wire [15:0] q_b;

  assign wren_a = (~AxiLineCount[0]) ? LineWrEn : 1'b0;
  assign wren_b = (AxiLineCount[0]) ? LineWrEn : 1'b0;

  always @(posedge CLK or negedge RST_N)begin
    if(~RST_N)
      rdaddress <= #P_DELAY 10'd0;
    else
      rdaddress <= #P_DELAY AxiPixCount;
  end

  RAM SRAM_A (
    .clock(CLK),
    .wren(wren_a),
    .wraddress(LineWrAddr),
    .rdaddress(rdaddress),
    .data(LineWrData),
    .q(q_a)
  );

  RAM SRAM_B (
    .clock(CLK),
    .wren(wren_b),
    .wraddress(LineWrAddr),
    .rdaddress(rdaddress),
    .data(LineWrData),
    .q(q_b)
  );

  assign bufRGB = (AxiLineCount[0]) ? q_a : q_b;

endmodule
