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
		  
	wire Mtens;
	wire Mones;
	wire Stens;
	wire Sones;
	
	wire AMtens;
	wire AMones;
	wire AStens;
	wire ASones;
	
	wire dRun;
	
	wire alarmMatch;
	
	wire alarmOff;
	wire alarmArm;
	wire alarmTrig;

	
	didp dp(
		.di_Mtens(di_Mtens),
		.di_Mones(di_Mones),
		.di_Stens(di_Stens),
		.di_Sones(di_Sones),
		
		.di_AMtens(di_AMtens),
		.di_AMones(di_AMones),
		.di_AStens(di_AStens),
		.di_ASones(di_ASones),
		
		.did_alarmMatch(alarmMatch),
		.L3_led(L3_led),
		.bu_rx_data(bu_rx_data),
		
		.dicLdMtens(Mtens),
		.dicLdMones(Mones),
		.dicLdStens(Stens),
		.dicLdSones(Sones),
		
		.dicLdAMtens(AMtens),
		.dicLdAMones(AMones),
		.dicLdAStens(AStens),
		.dicLdASones(ASones),
		
		.dicRun(dRun),
		.oneSecStrb(oneSecStrb),
		
		.rst(rst),
		.clk(clk)
		);
		
	dictrl dc(
		.dicLdMtens(Mtens),
		.dicLdMones(Mones),
		.dicLdStens(Stens),
		.dicLdSones(Sones),
		
		.dicLdAMtens(AMtens),
		.dicLdAMones(AMones),
		.dicLdAStens(AStens),
		.dicLdASones(ASones),
		
		.dicRun(dRun),
		
		.dicAlarmIdle(alarmOff),
		.dicAlarmArmed(alarmArm),
		.dicAlarmTrig(alarmTrig),
		.did_alarmMatch(alarmMatch),
		
		.bu_rx_data_rdy(bu_rx_data_rdy),
		.bu_rx_data(bu_rx_data),
		
		.rst(rst),
		.clk(clk)
		);



		reg STAT;
	always @(*) begin
		if(alarmOff)
			STAT = 8'b00101110;
		else if(alarmArm & ~alarmTrig)
			STAT = 8'b01100001;
		else if(alarmTrig)
			STAT = 8'b01010100;
	end
	assign b6 = STAT;
	dispString dS(
		.rdy(L3_tx_data_rdy),
		.dOut(L3_tx_data),
		.b0({4'b0010, di_AMtens}),
		.b1({4'b0010, di_AMones}),
		.b2(8'b00111010),
		.b3({4'b0010, di_AStens}),
		.b4({4'b0010, di_AMones}),
		.b5(8'b00100000),
		.b6(b6),
		.b7(8'b00001101),
		
		.go(1),
		.rst(rst),
		.clk(clk));	  	

	wire [6:0] L3_seg1;
	wire [6:0] L3_seg2;
	wire [6:0] L3_seg3;
	wire [6:0] L3_seg4;

	  
	bcd2segment seg1(
		.segment(L3_seg1),
		.num(di_Sones),
		.enable(1));
	
	bcd2segment seg2(
		.segment(L3_seg2),
		.num(di_Stens),
		.enable(1));
	
	bcd2segment seg3(
		.segment(L3_seg3),
		.num(di_Mones),
		.enable(1));
	
	bcd2segment seg4(
		.segment(L3_seg4),
		.num(di_Mtens),
		.enable(1));
	
	always @(*) begin
		L3_segment1 = L3_seg1;
		L3_segment2 = L3_seg2;
		L3_segment3 = L3_seg3;
		L3_segment4 = L3_seg4;
	end


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
	     input 	  dicRun, //clock should  	  
	     input 	  oneSecStrb, // one cycle strobe
	     input 	  rst,
	     input 	  clk 	  
	     );
	
	countrce #(4) ct0(
		.q(di_Sones), 
		.d(bu_rx_data[3:0]),	
		.ld(dicLdSones), 
		.ce(1),
		.rst(rst | (di_Sones == 4'b1001)),
		.clk(clk));
	
	countrce #(4) ct1(
		.q(di_Stens), 
		.d(bu_rx_data[3:0]),	
		.ld(dicLdStens), 
		.ce(dicLdStens | ((di_Sones == 4'b1001) & 1)),
		.rst(rst | ((di_Sones == 4'b1001) & (di_Stens == 4'b0101))),
		.clk(clk));
	
	countrce #(4) ct2(
		.q(di_Mones), 
		.d(bu_rx_data[3:0]),	
		.ld(dicLdMones), 
		.ce(dicLdMones | ((di_Sones == 4'b1001) & (di_Stens == 4'b0101) & 1)),
		.rst(rst | ((di_Sones == 4'b1001) & (di_Stens == 4'b0101) & (di_Mones == 4'b1001))),
		.clk(clk));
	
	countrce #(4) ct3(
		.q(di_Mtens), 
		.d(bu_rx_data[3:0]),	
		.ld(dicLdMtens), 
		.ce(dicLdMtens | ((di_Mones == 4'b1001) & (di_Sones == 4'b1001) & (di_Stens == 4'b0101) & 1)),
		.rst(rst | ((di_Sones == 4'b1001) & (di_Stens == 4'b0101) & (di_Mones == 4'b1001) & 
				(di_Mtens == 4'b0101))),
		.clk(clk));
		
	
	regrce #(4) rg0(
		.q(di_ASones),
		.d(bu_rx_data[3:0]),
		.ce(dicLdASones),
		.rst(rst),
		.clk(clk));
	
	regrce #(4) rg1(
		.q(di_AStens),
		.d(bu_rx_data[3:0]),
		.ce(dicLdAStens),
		.rst(rst),
		.clk(clk));
	
	regrce #(4) rg2(
		.q(di_AMones),
		.d(bu_rx_data[3:0]),
		.ce(dicLdAMones),
		.rst(rst),
		.clk(clk));
	
	regrce #(4) rg3(
		.q(di_AMtens),
		.d(bu_rx_data[3:0]),
		.ce(dicLdAMtens),
		.rst(rst),
		.clk(clk));
		
	assign did_alarmMatch = (di_Mtens == di_AMtens & di_Mones == di_AMones & 
		di_Stens == di_AStens & di_Sones == di_ASones) ? 1 : 0;

		  
		  
   
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
   



	wire esc;
	wire z2n;
	wire z2f;
	wire a;
	wire l;
	wire crrt;
	wire at;
	wire n;
	
	decodeKeys dk(
		.de_esc(esc),
		.de_num(z2n),
		.de_num0to5(z2f),
		.de_cr(crrt),
		.de_atSign(at),
		.de_littleA(a),
		.de_littleL(l),
		.de_littleN(n),
		.charData(bu_rx_data),
		.charDataValid(bu_rx_data_rdy));
	
	//clock FSM
	reg[3:0] cState;
	reg[3:0] nState;
	
	localparam START=0, LDA=1, AMT=2, AMO=3, AST=4, ASO=5, LDT=6, CMT=7, CMO=8, CST=9, CSO=10;
	
	always @(posedge clk) begin
		if(rst)
			cState <= START;
		else
			cState <= nState;
	end
	
	reg dR, dAMT, dAMO, dAST, dASO, dCMT, dCMO, dCST, dCSO;
	always @(*) begin
		nState = cState;
		dCMT = 0;
		dCMO = 0;
		dCST = 0;
		dCSO = 0;
		dAMT = 0;
		dAMO = 0;
		dAST = 0;
		dASO = 0;
		dR = 0;
		case(cState)
			START: begin
				if(a)
					nState = LDA;
				else if(l) begin
					nState = LDT;
					dR = 1;
				end
			end
			LDA: begin
				if(z2f) begin
					nState = AMT;
					dAMT = 1;
				end
				else
					nState = LDA;
			end
			AMT: begin
				if(z2n) begin
					nState = AMO;
					dAMO = 1;
				end
				else
					nState = AMT;
			end
			AMO: begin
				if(z2f) begin
					nState = AST;
					dAST = 1;
				end
				else
					nState = AMO;
			end
			AST: begin
				if(z2n) begin
					nState = ASO;
					dASO = 1;
				end
				else
					nState = AST;
			end
			ASO: begin
				if(crrt)
					nState = START;
				else
					nState = ASO;
			end
			LDT: begin
				if(z2f) begin
					nState = CMT;
					dCMT = 1;
				end
				else
					nState = LDT;
			end
			CMT: begin
				if(z2n) begin
					nState = CMO;
					dCMO = 1;
				end
				else
					nState = CMT;
			end
			CMO: begin
				if(z2f) begin
					nState = CST;
					dCST = 1;
				end
				else
					nState = CMO;
			end
			CST: begin
				if(z2n) begin
					nState = CSO;
					dCSO = 1;
				end
				else
					nState = CST;
			end
			CSO: begin
				if(crrt)
					nState = START;
				else
					nState = CSO;
			end
			default: begin
				dCMT = 0;
				dCMO = 0;
				dCST = 0;
				dCSO = 0;
				dAMT = 0;
				dAMO = 0;
				dAST = 0;
				dASO = 0;
				dR = 0;
			end
		endcase
	end
	
	assign dicLdMtens = dCMT;
	assign dicLdMones = dCMO;
	assign dicLdStens = dCST;
	assign dicLdSones = dCSO;
	assign dicLdAMtens = dAMT;
	assign dicLdAMones = dAMO;
	assign dicLdAStens = dAST;
	assign dicLdASones = dASO;
	assign dicRun = dR;
	
	//alarm FSM
	reg[1:0] cS;
	reg[1:0] nS;
	localparam OFF=0, ARM=1, TRI=2;
	always @(posedge clk) begin
		if(rst)
			cS <= OFF;
		else
			cS <= nS;
	end
	
	reg dAO, dAA, dAT;
	always @(*) begin
		nS = cS;
		dAO = 1;
		dAA = 0;
		dAT = 0;
		case(cS)
			OFF: begin
				if(at)
					nS = ARM;
				else
					nS = OFF;
			end
			ARM: begin
				if(at)
					nS = OFF;
				else if(did_alarmMatch)
					nS = TRI;
				else
					nS = ARM;
			end
			TRI: begin
				if(at)
					nS = OFF;
				else
					nS = TRI;
			end
			default: begin
				dAO = 1;
				dAA = 0;
				dAT = 0;
			end
		endcase
	end
	assign dicAlarmIdle = dAO;
	assign dicAlarmArmed = dAA;
	assign dicAlarmTrig = dAT;
endmodule

		