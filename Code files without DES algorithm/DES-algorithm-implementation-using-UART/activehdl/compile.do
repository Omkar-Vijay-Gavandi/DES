vlib work
vlib activehdl

vlib activehdl/xpm
vlib activehdl/xil_defaultlib

vmap xpm activehdl/xpm
vmap xil_defaultlib activehdl/xil_defaultlib

vlog -work xpm  -sv2k12 \
"/home/gourab/Xilinx/Vivado/2022.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
"/home/gourab/Xilinx/Vivado/2022.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -93  \
"/home/gourab/Xilinx/Vivado/2022.2/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work xil_defaultlib  -v2k5 \
"../../UART-basys3_Des Try/UART_RX_TX.srcs/sources_1/imports/DES verilog files/Des_Top.v" \
"../../UART-basys3_Des Try/UART_RX_TX.srcs/sources_1/imports/DES verilog files/Expansion_P.v" \
"../../UART-basys3_Des Try/UART_RX_TX.srcs/sources_1/imports/DES verilog files/Permutation.v" \
"../../UART-basys3_Des Try/UART_RX_TX.srcs/sources_1/imports/DES verilog files/Permuted_Choice2.v" \
"../../UART-basys3_Des Try/UART_RX_TX.srcs/sources_1/imports/DES verilog files/Reg32.v" \
"../../UART-basys3_Des Try/UART_RX_TX.srcs/sources_1/imports/DES verilog files/Round1.v" \
"../../UART-basys3_Des Try/UART_RX_TX.srcs/sources_1/imports/DES verilog files/Sbox_Rom2.v" \
"../../UART-basys3_Des Try/UART_RX_TX.srcs/sources_1/imports/DES verilog files/Sbox_Rom3.v" \
"../../UART-basys3_Des Try/UART_RX_TX.srcs/sources_1/imports/DES verilog files/Sbox_Rom4.v" \
"../../UART-basys3_Des Try/UART_RX_TX.srcs/sources_1/imports/DES verilog files/Sbox_Rom5.v" \
"../../UART-basys3_Des Try/UART_RX_TX.srcs/sources_1/imports/DES verilog files/Sbox_Rom6.v" \
"../../UART-basys3_Des Try/UART_RX_TX.srcs/sources_1/imports/DES verilog files/Sbox_Rom7.v" \
"../../UART-basys3_Des Try/UART_RX_TX.srcs/sources_1/imports/DES verilog files/Sbox_Rom8.v" \
"../../UART-basys3_Des Try/UART_RX_TX.srcs/sources_1/imports/DES verilog files/Sbox_output.v" \
"../../UART-basys3_Des Try/UART_RX_TX.srcs/sources_1/imports/DES verilog files/Swap.v" \
"../../UART-basys3_Des Try/UART_RX_TX.srcs/sources_1/imports/DES verilog files/Xor_operation.v" \
"../../UART-basys3_Des Try/UART_RX_TX.srcs/sources_1/imports/DES verilog files/Xor_permutation.v" \
"../../UART-basys3_Des Try/UART_RX_TX.srcs/sources_1/new/controller.v" \
"../../UART-basys3_Des Try/UART_RX_TX.srcs/sources_1/imports/DES verilog files/initial_Perm.v" \
"../../UART-basys3_Des Try/UART_RX_TX.srcs/sources_1/imports/DES verilog files/inverse_initial_perm.v" \
"../../UART-basys3_Des Try/UART_RX_TX.srcs/sources_1/imports/DES verilog files/key_gen.v" \
"../../UART-basys3_Des Try/UART_RX_TX.srcs/sources_1/imports/DES verilog files/key_top.v" \
"../../UART-basys3_Des Try/UART_RX_TX.srcs/sources_1/imports/DES verilog files/s1.v" \
"../../UART-basys3_Des Try/UART_RX_TX.srcs/sources_1/imports/UART_RX/uart_rx.v" \
"../../UART-basys3_Des Try/UART_RX_TX.srcs/sources_1/new/uart_tx.v" \
"../../UART-basys3_Des Try/UART_RX_TX.srcs/controller_sim/new/tb_controller.v" \

vlog -work xil_defaultlib \
"glbl.v"

