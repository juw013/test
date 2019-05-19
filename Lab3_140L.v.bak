// >>>>>>>>>>>>>>>>>>>>>>>>> COPYRIGHT NOTICE <<<<<<<<<<<<<<<<<<<<<<<<<
// --------------------------------------------------------------------
// Copyright (c) 2019 by UCSD CSE 140L
// --------------------------------------------------------------------
//
// Permission:
//
//   This code for use in UCSD CSE 140L.
//   It is synthesisable for Lattice iCEstick 40HX.  
//
// Disclaimer:
//
//   This Verilog source code is intended as a design reference
//   which illustrates how these types of functions can be implemented.
//   It is the user's responsibility to verify their design for
//   consistency and functionality through the use of formal
//   verification methods.  
//
// -------------------------------------------------------------------- //           
//                     UCSD CSE Department
//                     9500 Gilman Dr, La Jolla, CA 92093
//                     U.S.A
//
// --------------------------------------------------------------------

module Lab3_140L (
		  input wire 	    rst, // reset signal (active high)
		  input wire 	    clk, // global clock
		  input wire oneSecStrb,  	    
		  input 	    bu_rx_data_rdy, // data from the uart ready
		  input [7:0] 	    bu_rx_data, // data from the uart
		  output wire 	    L3_tx_data_rdy, // data to the alarm display
		  output wire [7:0] L3_tx_data,     // data to the alarm display
		  output [4:0] 	    L3_led,
		  output reg [6:0] 	    L3_segment1, // 1's seconds
		  output reg [6:0] 	    L3_segment2, // 10's seconds
		  output reg [6:0] 	    L3_segment3, // 1's minutes
		  output reg [6:0] 	    L3_segment4, // 10's minutes

		  output [3:0] 	    di_Mtens,
		  output [3:0] 	    di_Mones,
		  output [3:0] 	    di_Stens,
		  output wire [3:0] di_Sones,
		  output [3:0] 	    di_AMtens,
		  output [3:0] 	    di_AMones,
		  output [3:0] 	    di_AStens,
		  output [3:0] 	    di_ASones
		  );




endmodule // Lab3_140L



//
//
// sample interface for clock datpath
//
module didp (
	     output [3:0] di_Mtens, // current 10's minutes
	     output [3:0] di_Mones, // current 1's minutes
	     output [3:0] di_Stens, // current 10's second
	     output [3:0] di_Sones, // current 1's second

	     output [3:0] di_AMtens, // current alarm 10's minutes
	     output [3:0] di_AMones, // current alarm 1's minutes
	     output [3:0] di_AStens, // current alarm 10's second
	     output [3:0] di_ASones, // current alarm 1's second

	     output wire  did_alarmMatch, // one cydie alarm match (raw signal, unqualified)

	     output [4:0] L3_led,

	     input [7:0]  bu_rx_data,
	     input 	  dicLdMtens, // load 10's minute
	     input 	  dicLdMones, // load 1's minute
	     input 	  dicLdStens, // load 10's second
	     input 	  dicLdSones, // load 1's second
	     
	     input 	  dicLdAMtens, // load alarm 10's minute
	     input 	  dicLdAMones, // load alarm 1's minute
	     input 	  dicLdAStens, // load alarm 10's second
	     input 	  dicLdASones, // load alarm 1's second
	     input 	  dicRun, //clock should run 	  
	     input 	  oneSecStrb, // one cycle strobe
	     input 	  rst,
	     input 	  clk 	  
	     );
   
endmodule




//
//
// sample interface for clock control
//
module dictrl(
	      output 	  dicLdMtens, // load the 10's minutes
	      output 	  dicLdMones, // load the 1's minutes
	      output 	  dicLdStens, // load the 10's seconds
	      output 	  dicLdSones, // load the 1's seconds
	      output 	  dicLdAMtens, // load the alarm 10's minutes
	      output 	  dicLdAMones, // load the alarm 1's minutes
	      output 	  dicLdAStens, // load the alarm 10's seconds
	      output 	  dicLdASones, // load the alarm 1's seconds
	      output 	  dicRun, // clock should run

	      output wire dicAlarmIdle, // alarm is off
	      output wire dicAlarmArmed, // alarm is armed
	      output wire dicAlarmTrig, // alarm is triggered

	      input       did_alarmMatch, // raw alarm match

              input 	  bu_rx_data_rdy, // new data from uart rdy
              input [7:0] bu_rx_data, // new data from uart
              input 	  rst,
	      input 	  clk
	      );
   
endmodule

