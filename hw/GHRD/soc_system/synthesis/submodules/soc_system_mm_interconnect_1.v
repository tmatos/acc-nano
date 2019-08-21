// soc_system_mm_interconnect_1.v

// This file was auto-generated from altera_mm_interconnect_hw.tcl.  If you edit it your changes
// will probably be lost.
// 
// Generated using ACDS version 18.1 646

`timescale 1 ps / 1 ps
module soc_system_mm_interconnect_1 (
		input  wire        clk_0_clk_clk,                                   //                                 clk_0_clk.clk
		input  wire        atax_kernel_0_reset_reset_bridge_in_reset_reset, // atax_kernel_0_reset_reset_bridge_in_reset.reset
		input  wire [7:0]  atax_kernel_0_arg_x_address,                     //                       atax_kernel_0_arg_x.address
		output wire        atax_kernel_0_arg_x_waitrequest,                 //                                          .waitrequest
		input  wire [7:0]  atax_kernel_0_arg_x_byteenable,                  //                                          .byteenable
		input  wire        atax_kernel_0_arg_x_read,                        //                                          .read
		output wire [63:0] atax_kernel_0_arg_x_readdata,                    //                                          .readdata
		input  wire        atax_kernel_0_arg_x_write,                       //                                          .write
		input  wire [63:0] atax_kernel_0_arg_x_writedata,                   //                                          .writedata
		output wire [4:0]  onchip_ram_arg_x_s2_address,                     //                       onchip_ram_arg_x_s2.address
		output wire        onchip_ram_arg_x_s2_write,                       //                                          .write
		input  wire [63:0] onchip_ram_arg_x_s2_readdata,                    //                                          .readdata
		output wire [63:0] onchip_ram_arg_x_s2_writedata,                   //                                          .writedata
		output wire [7:0]  onchip_ram_arg_x_s2_byteenable,                  //                                          .byteenable
		output wire        onchip_ram_arg_x_s2_chipselect,                  //                                          .chipselect
		output wire        onchip_ram_arg_x_s2_clken                        //                                          .clken
	);

	wire         atax_kernel_0_arg_x_translator_avalon_universal_master_0_waitrequest;   // onchip_ram_arg_x_s2_translator:uav_waitrequest -> atax_kernel_0_arg_x_translator:uav_waitrequest
	wire  [63:0] atax_kernel_0_arg_x_translator_avalon_universal_master_0_readdata;      // onchip_ram_arg_x_s2_translator:uav_readdata -> atax_kernel_0_arg_x_translator:uav_readdata
	wire         atax_kernel_0_arg_x_translator_avalon_universal_master_0_debugaccess;   // atax_kernel_0_arg_x_translator:uav_debugaccess -> onchip_ram_arg_x_s2_translator:uav_debugaccess
	wire   [7:0] atax_kernel_0_arg_x_translator_avalon_universal_master_0_address;       // atax_kernel_0_arg_x_translator:uav_address -> onchip_ram_arg_x_s2_translator:uav_address
	wire         atax_kernel_0_arg_x_translator_avalon_universal_master_0_read;          // atax_kernel_0_arg_x_translator:uav_read -> onchip_ram_arg_x_s2_translator:uav_read
	wire   [7:0] atax_kernel_0_arg_x_translator_avalon_universal_master_0_byteenable;    // atax_kernel_0_arg_x_translator:uav_byteenable -> onchip_ram_arg_x_s2_translator:uav_byteenable
	wire         atax_kernel_0_arg_x_translator_avalon_universal_master_0_readdatavalid; // onchip_ram_arg_x_s2_translator:uav_readdatavalid -> atax_kernel_0_arg_x_translator:uav_readdatavalid
	wire         atax_kernel_0_arg_x_translator_avalon_universal_master_0_lock;          // atax_kernel_0_arg_x_translator:uav_lock -> onchip_ram_arg_x_s2_translator:uav_lock
	wire         atax_kernel_0_arg_x_translator_avalon_universal_master_0_write;         // atax_kernel_0_arg_x_translator:uav_write -> onchip_ram_arg_x_s2_translator:uav_write
	wire  [63:0] atax_kernel_0_arg_x_translator_avalon_universal_master_0_writedata;     // atax_kernel_0_arg_x_translator:uav_writedata -> onchip_ram_arg_x_s2_translator:uav_writedata
	wire   [3:0] atax_kernel_0_arg_x_translator_avalon_universal_master_0_burstcount;    // atax_kernel_0_arg_x_translator:uav_burstcount -> onchip_ram_arg_x_s2_translator:uav_burstcount

	altera_merlin_master_translator #(
		.AV_ADDRESS_W                (8),
		.AV_DATA_W                   (64),
		.AV_BURSTCOUNT_W             (1),
		.AV_BYTEENABLE_W             (8),
		.UAV_ADDRESS_W               (8),
		.UAV_BURSTCOUNT_W            (4),
		.USE_READ                    (1),
		.USE_WRITE                   (1),
		.USE_BEGINBURSTTRANSFER      (0),
		.USE_BEGINTRANSFER           (0),
		.USE_CHIPSELECT              (0),
		.USE_BURSTCOUNT              (0),
		.USE_READDATAVALID           (0),
		.USE_WAITREQUEST             (1),
		.USE_READRESPONSE            (0),
		.USE_WRITERESPONSE           (0),
		.AV_SYMBOLS_PER_WORD         (8),
		.AV_ADDRESS_SYMBOLS          (1),
		.AV_BURSTCOUNT_SYMBOLS       (0),
		.AV_CONSTANT_BURST_BEHAVIOR  (0),
		.UAV_CONSTANT_BURST_BEHAVIOR (0),
		.AV_LINEWRAPBURSTS           (0),
		.AV_REGISTERINCOMINGSIGNALS  (0)
	) atax_kernel_0_arg_x_translator (
		.clk                    (clk_0_clk_clk),                                                          //                       clk.clk
		.reset                  (atax_kernel_0_reset_reset_bridge_in_reset_reset),                        //                     reset.reset
		.uav_address            (atax_kernel_0_arg_x_translator_avalon_universal_master_0_address),       // avalon_universal_master_0.address
		.uav_burstcount         (atax_kernel_0_arg_x_translator_avalon_universal_master_0_burstcount),    //                          .burstcount
		.uav_read               (atax_kernel_0_arg_x_translator_avalon_universal_master_0_read),          //                          .read
		.uav_write              (atax_kernel_0_arg_x_translator_avalon_universal_master_0_write),         //                          .write
		.uav_waitrequest        (atax_kernel_0_arg_x_translator_avalon_universal_master_0_waitrequest),   //                          .waitrequest
		.uav_readdatavalid      (atax_kernel_0_arg_x_translator_avalon_universal_master_0_readdatavalid), //                          .readdatavalid
		.uav_byteenable         (atax_kernel_0_arg_x_translator_avalon_universal_master_0_byteenable),    //                          .byteenable
		.uav_readdata           (atax_kernel_0_arg_x_translator_avalon_universal_master_0_readdata),      //                          .readdata
		.uav_writedata          (atax_kernel_0_arg_x_translator_avalon_universal_master_0_writedata),     //                          .writedata
		.uav_lock               (atax_kernel_0_arg_x_translator_avalon_universal_master_0_lock),          //                          .lock
		.uav_debugaccess        (atax_kernel_0_arg_x_translator_avalon_universal_master_0_debugaccess),   //                          .debugaccess
		.av_address             (atax_kernel_0_arg_x_address),                                            //      avalon_anti_master_0.address
		.av_waitrequest         (atax_kernel_0_arg_x_waitrequest),                                        //                          .waitrequest
		.av_byteenable          (atax_kernel_0_arg_x_byteenable),                                         //                          .byteenable
		.av_read                (atax_kernel_0_arg_x_read),                                               //                          .read
		.av_readdata            (atax_kernel_0_arg_x_readdata),                                           //                          .readdata
		.av_write               (atax_kernel_0_arg_x_write),                                              //                          .write
		.av_writedata           (atax_kernel_0_arg_x_writedata),                                          //                          .writedata
		.av_burstcount          (1'b1),                                                                   //               (terminated)
		.av_beginbursttransfer  (1'b0),                                                                   //               (terminated)
		.av_begintransfer       (1'b0),                                                                   //               (terminated)
		.av_chipselect          (1'b0),                                                                   //               (terminated)
		.av_readdatavalid       (),                                                                       //               (terminated)
		.av_lock                (1'b0),                                                                   //               (terminated)
		.av_debugaccess         (1'b0),                                                                   //               (terminated)
		.uav_clken              (),                                                                       //               (terminated)
		.av_clken               (1'b1),                                                                   //               (terminated)
		.uav_response           (2'b00),                                                                  //               (terminated)
		.av_response            (),                                                                       //               (terminated)
		.uav_writeresponsevalid (1'b0),                                                                   //               (terminated)
		.av_writeresponsevalid  ()                                                                        //               (terminated)
	);

	altera_merlin_slave_translator #(
		.AV_ADDRESS_W                   (5),
		.AV_DATA_W                      (64),
		.UAV_DATA_W                     (64),
		.AV_BURSTCOUNT_W                (1),
		.AV_BYTEENABLE_W                (8),
		.UAV_BYTEENABLE_W               (8),
		.UAV_ADDRESS_W                  (8),
		.UAV_BURSTCOUNT_W               (4),
		.AV_READLATENCY                 (1),
		.USE_READDATAVALID              (0),
		.USE_WAITREQUEST                (0),
		.USE_UAV_CLKEN                  (0),
		.USE_READRESPONSE               (0),
		.USE_WRITERESPONSE              (0),
		.AV_SYMBOLS_PER_WORD            (8),
		.AV_ADDRESS_SYMBOLS             (0),
		.AV_BURSTCOUNT_SYMBOLS          (0),
		.AV_CONSTANT_BURST_BEHAVIOR     (0),
		.UAV_CONSTANT_BURST_BEHAVIOR    (0),
		.AV_REQUIRE_UNALIGNED_ADDRESSES (0),
		.CHIPSELECT_THROUGH_READLATENCY (0),
		.AV_READ_WAIT_CYCLES            (0),
		.AV_WRITE_WAIT_CYCLES           (0),
		.AV_SETUP_WAIT_CYCLES           (0),
		.AV_DATA_HOLD_CYCLES            (0)
	) onchip_ram_arg_x_s2_translator (
		.clk                    (clk_0_clk_clk),                                                          //                      clk.clk
		.reset                  (atax_kernel_0_reset_reset_bridge_in_reset_reset),                        //                    reset.reset
		.uav_address            (atax_kernel_0_arg_x_translator_avalon_universal_master_0_address),       // avalon_universal_slave_0.address
		.uav_burstcount         (atax_kernel_0_arg_x_translator_avalon_universal_master_0_burstcount),    //                         .burstcount
		.uav_read               (atax_kernel_0_arg_x_translator_avalon_universal_master_0_read),          //                         .read
		.uav_write              (atax_kernel_0_arg_x_translator_avalon_universal_master_0_write),         //                         .write
		.uav_waitrequest        (atax_kernel_0_arg_x_translator_avalon_universal_master_0_waitrequest),   //                         .waitrequest
		.uav_readdatavalid      (atax_kernel_0_arg_x_translator_avalon_universal_master_0_readdatavalid), //                         .readdatavalid
		.uav_byteenable         (atax_kernel_0_arg_x_translator_avalon_universal_master_0_byteenable),    //                         .byteenable
		.uav_readdata           (atax_kernel_0_arg_x_translator_avalon_universal_master_0_readdata),      //                         .readdata
		.uav_writedata          (atax_kernel_0_arg_x_translator_avalon_universal_master_0_writedata),     //                         .writedata
		.uav_lock               (atax_kernel_0_arg_x_translator_avalon_universal_master_0_lock),          //                         .lock
		.uav_debugaccess        (atax_kernel_0_arg_x_translator_avalon_universal_master_0_debugaccess),   //                         .debugaccess
		.av_address             (onchip_ram_arg_x_s2_address),                                            //      avalon_anti_slave_0.address
		.av_write               (onchip_ram_arg_x_s2_write),                                              //                         .write
		.av_readdata            (onchip_ram_arg_x_s2_readdata),                                           //                         .readdata
		.av_writedata           (onchip_ram_arg_x_s2_writedata),                                          //                         .writedata
		.av_byteenable          (onchip_ram_arg_x_s2_byteenable),                                         //                         .byteenable
		.av_chipselect          (onchip_ram_arg_x_s2_chipselect),                                         //                         .chipselect
		.av_clken               (onchip_ram_arg_x_s2_clken),                                              //                         .clken
		.av_read                (),                                                                       //              (terminated)
		.av_begintransfer       (),                                                                       //              (terminated)
		.av_beginbursttransfer  (),                                                                       //              (terminated)
		.av_burstcount          (),                                                                       //              (terminated)
		.av_readdatavalid       (1'b0),                                                                   //              (terminated)
		.av_waitrequest         (1'b0),                                                                   //              (terminated)
		.av_writebyteenable     (),                                                                       //              (terminated)
		.av_lock                (),                                                                       //              (terminated)
		.uav_clken              (1'b0),                                                                   //              (terminated)
		.av_debugaccess         (),                                                                       //              (terminated)
		.av_outputenable        (),                                                                       //              (terminated)
		.uav_response           (),                                                                       //              (terminated)
		.av_response            (2'b00),                                                                  //              (terminated)
		.uav_writeresponsevalid (),                                                                       //              (terminated)
		.av_writeresponsevalid  (1'b0)                                                                    //              (terminated)
	);

endmodule
