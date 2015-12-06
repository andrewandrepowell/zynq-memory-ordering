
`timescale 1 ns / 1 ps

`include "axi3_metrics_counter_v1_0_tb_include.vh"

// Burst Size Defines
`define BURST_SIZE_4_BYTES   3'b010

// Lock Type Defines
`define LOCK_TYPE_NORMAL    1'b0

// lite_response Type Defines
`define RESPONSE_OKAY 2'b00
`define RESPONSE_EXOKAY 2'b01
`define RESP_BUS_WIDTH 2
`define BURST_TYPE_INCR  2'b01
`define BURST_TYPE_WRAP  2'b10

// AMBA axi3_monitor AXI4 Range Constants
`define axi3_monitor_MAX_BURST_LENGTH 8'b1111_1111
`define axi3_monitor_MAX_DATA_SIZE (`axi3_monitor_DATA_BUS_WIDTH*(`axi3_monitor_MAX_BURST_LENGTH+1))/8
`define axi3_monitor_DATA_BUS_WIDTH 32
`define axi3_monitor_ADDRESS_BUS_WIDTH 32
`define axi3_monitor_RUSER_BUS_WIDTH 1
`define axi3_monitor_WUSER_BUS_WIDTH 1

module axi3_metrics_counter_v1_0_tb;
	reg tb_ACLK;
	reg tb_ARESETn;

	// Create an instance of the example tb
	`BD_WRAPPER dut (.ACLK(tb_ACLK),
				.ARESETN(tb_ARESETn));

	// Local Variables

	// AMBA axi3_monitor AXI4 Local Reg
	reg [(`axi3_monitor_DATA_BUS_WIDTH*(`axi3_monitor_MAX_BURST_LENGTH+1)/16)-1:0] axi3_monitor_rd_data;
	reg [(`axi3_monitor_DATA_BUS_WIDTH*(`axi3_monitor_MAX_BURST_LENGTH+1)/16)-1:0] axi3_monitor_test_data [2:0];
	reg [(`RESP_BUS_WIDTH*(`axi3_monitor_MAX_BURST_LENGTH+1))-1:0] axi3_monitor_vresponse;
	reg [`axi3_monitor_ADDRESS_BUS_WIDTH-1:0] axi3_monitor_mtestAddress;
	reg [(`axi3_monitor_RUSER_BUS_WIDTH*(`axi3_monitor_MAX_BURST_LENGTH+1))-1:0] axi3_monitor_v_ruser;
	reg [(`axi3_monitor_WUSER_BUS_WIDTH*(`axi3_monitor_MAX_BURST_LENGTH+1))-1:0] axi3_monitor_v_wuser;
	reg [`RESP_BUS_WIDTH-1:0] axi3_monitor_response;
	integer  axi3_monitor_mtestID; // Master side testID
	integer  axi3_monitor_mtestBurstLength;
	integer  axi3_monitor_mtestvector; // Master side testvector
	integer  axi3_monitor_mtestdatasize;
	integer  axi3_monitor_mtestCacheType = 0;
	integer  axi3_monitor_mtestProtectionType = 0;
	integer  axi3_monitor_mtestRegion = 0;
	integer  axi3_monitor_mtestQOS = 0;
	integer  axi3_monitor_mtestAWUSER = 0;
	integer  axi3_monitor_mtestARUSER = 0;
	integer  axi3_monitor_mtestBUSER = 0;
	integer result_slave_full;


	// Simple Reset Generator and test
	initial begin
		tb_ARESETn = 1'b0;
	  #500;
		// Release the reset on the posedge of the clk.
		@(posedge tb_ACLK);
	  tb_ARESETn = 1'b1;
		@(posedge tb_ACLK);
	end

	// Simple Clock Generator
	initial tb_ACLK = 1'b0;
	always #10 tb_ACLK = !tb_ACLK;

	//------------------------------------------------------------------------
	// TEST LEVEL API: CHECK_RESPONSE_OKAY
	//------------------------------------------------------------------------
	// Description:
	// CHECK_RESPONSE_OKAY(lite_response)
	// This task checks if the return lite_response is equal to OKAY
	//------------------------------------------------------------------------
	task automatic CHECK_RESPONSE_OKAY;
		input [`RESP_BUS_WIDTH-1:0] response;
		begin
		  if (response !== `RESPONSE_OKAY) begin
			  $display("TESTBENCH ERROR! lite_response is not OKAY",
				         "\n expected = 0x%h",`RESPONSE_OKAY,
				         "\n actual   = 0x%h",response);
		    $stop;
		  end
		end
	endtask

	//------------------------------------------------------------------------
	// TEST LEVEL API: COMPARE_DATA
	//------------------------------------------------------------------------
	// Description:
	// COMPARE_DATA(expected,actual)
	// This task checks if the actual data is equal to the expected data.
	// X is used as don't care but it is not permitted for the full vector
	// to be don't care.
	//------------------------------------------------------------------------
	task automatic COMPARE_DATA;
		input expected;
		input actual;
		begin
			if (expected === 'hx || actual === 'hx) begin
				$display("TESTBENCH ERROR! COMPARE_DATA cannot be performed with an expected or actual vector that is all 'x'!");
		    result_slave_full = 0;
		    $stop;
		  end

			if (actual != expected) begin
				$display("TESTBENCH ERROR! Data expected is not equal to actual.",
				         "\n expected = 0x%h",expected,
				         "\n actual   = 0x%h",actual);
		    result_slave_full = 0;
		    $stop;
		  end
			else 
			begin
			   $display("TESTBENCH Passed! Data expected is equal to actual.",
			            "\n expected = 0x%h",expected,
			            "\n actual   = 0x%h",actual);
			end
		end
	endtask

	task automatic axi3_monitor_TEST;
		begin
			//---------------------------------------------------------------------
			// EXAMPLE TEST 1:
			// Simple sequential write and read burst transfers example
			// DESCRIPTION:
			// The following master code does a simple write and read burst for
			// each burst transfer type.
			//---------------------------------------------------------------------
			$display("---------------------------------------------------------");
			$display("EXAMPLE TEST axi3_monitor:");
			$display("Simple sequential write and read burst transfers example");
			$display("---------------------------------------------------------");
			
			axi3_monitor_mtestID = 1;
			axi3_monitor_mtestvector = 0;
			axi3_monitor_mtestBurstLength = 15;
			axi3_monitor_mtestAddress = `axi3_monitor_SLAVE_ADDRESS;
			axi3_monitor_mtestCacheType = 0;
			axi3_monitor_mtestProtectionType = 0;
			axi3_monitor_mtestdatasize = `axi3_monitor_MAX_DATA_SIZE;
			axi3_monitor_mtestRegion = 0;
			axi3_monitor_mtestQOS = 0;
			axi3_monitor_mtestAWUSER = 0;
			axi3_monitor_mtestARUSER = 0;
			 result_slave_full = 1;
			
			dut.`BD_INST_NAME.master_0.cdn_axi4_master_bfm_inst.WRITE_BURST_CONCURRENT(axi3_monitor_mtestID,
			                        axi3_monitor_mtestAddress,
			                        axi3_monitor_mtestBurstLength,
			                        `BURST_SIZE_4_BYTES,
			                        `BURST_TYPE_INCR,
			                        `LOCK_TYPE_NORMAL,
			                        axi3_monitor_mtestCacheType,
			                        axi3_monitor_mtestProtectionType,
			                        axi3_monitor_test_data[axi3_monitor_mtestvector],
			                        axi3_monitor_mtestdatasize,
			                        axi3_monitor_mtestRegion,
			                        axi3_monitor_mtestQOS,
			                        axi3_monitor_mtestAWUSER,
			                        axi3_monitor_v_wuser,
			                        axi3_monitor_response,
			                        axi3_monitor_mtestBUSER);
			$display("EXAMPLE TEST 1 : DATA = 0x%h, response = 0x%h",axi3_monitor_test_data[axi3_monitor_mtestvector],axi3_monitor_response);
			CHECK_RESPONSE_OKAY(axi3_monitor_response);
			axi3_monitor_mtestID = axi3_monitor_mtestID+1;
			dut.`BD_INST_NAME.master_0.cdn_axi4_master_bfm_inst.READ_BURST(axi3_monitor_mtestID,
			                       axi3_monitor_mtestAddress,
			                       axi3_monitor_mtestBurstLength,
			                       `BURST_SIZE_4_BYTES,
			                       `BURST_TYPE_WRAP,
			                       `LOCK_TYPE_NORMAL,
			                       axi3_monitor_mtestCacheType,
			                       axi3_monitor_mtestProtectionType,
			                       axi3_monitor_mtestRegion,
			                       axi3_monitor_mtestQOS,
			                       axi3_monitor_mtestARUSER,
			                       axi3_monitor_rd_data,
			                       axi3_monitor_vresponse,
			                       axi3_monitor_v_ruser);
			$display("EXAMPLE TEST 1 : DATA = 0x%h, vresponse = 0x%h",axi3_monitor_rd_data,axi3_monitor_vresponse);
			CHECK_RESPONSE_OKAY(axi3_monitor_vresponse);
			// Check that the data received by the master is the same as the test 
			// vector supplied by the slave.
			COMPARE_DATA(axi3_monitor_test_data[axi3_monitor_mtestvector],axi3_monitor_rd_data);

			$display("EXAMPLE TEST 1 : Sequential write and read FIXED burst transfers complete from the master side.");
			$display("---------------------------------------------------------");
			$display("EXAMPLE TEST axi3_monitor: PTGEN_TEST_FINISHED!");
				if ( result_slave_full ) begin				   
					$display("PTGEN_TEST: PASSED!");                 
				end	else begin                                         
					$display("PTGEN_TEST: FAILED!");                 
				end							   
			$display("---------------------------------------------------------");
		end
	endtask 

	// Create the test vectors
	initial begin
		// When performing debug enable all levels of INFO messages.
		wait(tb_ARESETn === 0) @(posedge tb_ACLK);
		wait(tb_ARESETn === 1) @(posedge tb_ACLK);
		wait(tb_ARESETn === 1) @(posedge tb_ACLK);     
		wait(tb_ARESETn === 1) @(posedge tb_ACLK);     
		wait(tb_ARESETn === 1) @(posedge tb_ACLK);  

		dut.`BD_INST_NAME.master_0.cdn_axi4_master_bfm_inst.set_channel_level_info(1);

		// Create test data vectors
		axi3_monitor_test_data[1] = 512'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
		axi3_monitor_test_data[0] = 512'h00abcdef111111112222222233333333444444445555555566666666777777778888888899999999AAAAAAAABBBBBBBBCCCCCCCCDDDDDDDDEEEEEEEEFFFFFFFF;
		axi3_monitor_test_data[2] = 512'h00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
		axi3_monitor_v_ruser = 0;
		axi3_monitor_v_wuser = 0;
	end

	// Drive the BFM
	initial begin
		// Wait for end of reset
		wait(tb_ARESETn === 0) @(posedge tb_ACLK);
		wait(tb_ARESETn === 1) @(posedge tb_ACLK);
		wait(tb_ARESETn === 1) @(posedge tb_ACLK);     
		wait(tb_ARESETn === 1) @(posedge tb_ACLK);     
		wait(tb_ARESETn === 1) @(posedge tb_ACLK);     

		axi3_monitor_TEST();

	end

endmodule
