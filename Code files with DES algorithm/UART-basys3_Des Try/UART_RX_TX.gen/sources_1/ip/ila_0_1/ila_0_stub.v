// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2022.2 (lin64) Build 3671981 Fri Oct 14 04:59:54 MDT 2022
// Date        : Fri Nov  8 14:44:31 2024
// Host        : gourab-Inspiron-15-3511 running 64-bit Ubuntu 24.04 LTS
// Command     : write_verilog -force -mode synth_stub {/home/gourab/FPGA_project/UART-basys3_Des
//               Try/UART_RX_TX.gen/sources_1/ip/ila_0_1/ila_0_stub.v}
// Design      : ila_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a35tcpg236-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "ila,Vivado 2022.2" *)
module ila_0(clk, probe0, probe1, probe2, probe3, probe4)
/* synthesis syn_black_box black_box_pad_pin="clk,probe0[15:0],probe1[15:0],probe2[63:0],probe3[63:0],probe4[63:0]" */;
  input clk;
  input [15:0]probe0;
  input [15:0]probe1;
  input [63:0]probe2;
  input [63:0]probe3;
  input [63:0]probe4;
endmodule