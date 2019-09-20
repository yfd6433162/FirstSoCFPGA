
module soc_system (
	clk_clk,
	hps_0_f2h_cold_reset_req_reset_n,
	hps_0_f2h_debug_reset_req_reset_n,
	hps_0_f2h_sdram0_data_araddr,
	hps_0_f2h_sdram0_data_arlen,
	hps_0_f2h_sdram0_data_arid,
	hps_0_f2h_sdram0_data_arsize,
	hps_0_f2h_sdram0_data_arburst,
	hps_0_f2h_sdram0_data_arlock,
	hps_0_f2h_sdram0_data_arprot,
	hps_0_f2h_sdram0_data_arvalid,
	hps_0_f2h_sdram0_data_arcache,
	hps_0_f2h_sdram0_data_awaddr,
	hps_0_f2h_sdram0_data_awlen,
	hps_0_f2h_sdram0_data_awid,
	hps_0_f2h_sdram0_data_awsize,
	hps_0_f2h_sdram0_data_awburst,
	hps_0_f2h_sdram0_data_awlock,
	hps_0_f2h_sdram0_data_awprot,
	hps_0_f2h_sdram0_data_awvalid,
	hps_0_f2h_sdram0_data_awcache,
	hps_0_f2h_sdram0_data_bresp,
	hps_0_f2h_sdram0_data_bid,
	hps_0_f2h_sdram0_data_bvalid,
	hps_0_f2h_sdram0_data_bready,
	hps_0_f2h_sdram0_data_arready,
	hps_0_f2h_sdram0_data_awready,
	hps_0_f2h_sdram0_data_rready,
	hps_0_f2h_sdram0_data_rdata,
	hps_0_f2h_sdram0_data_rresp,
	hps_0_f2h_sdram0_data_rlast,
	hps_0_f2h_sdram0_data_rid,
	hps_0_f2h_sdram0_data_rvalid,
	hps_0_f2h_sdram0_data_wlast,
	hps_0_f2h_sdram0_data_wvalid,
	hps_0_f2h_sdram0_data_wdata,
	hps_0_f2h_sdram0_data_wstrb,
	hps_0_f2h_sdram0_data_wready,
	hps_0_f2h_sdram0_data_wid,
	hps_0_f2h_stm_hw_events_stm_hwevents,
	hps_0_f2h_warm_reset_req_reset_n,
	hps_0_h2f_reset_reset_n,
	hps_0_hps_io_hps_io_emac1_inst_TX_CLK,
	hps_0_hps_io_hps_io_emac1_inst_TXD0,
	hps_0_hps_io_hps_io_emac1_inst_TXD1,
	hps_0_hps_io_hps_io_emac1_inst_TXD2,
	hps_0_hps_io_hps_io_emac1_inst_TXD3,
	hps_0_hps_io_hps_io_emac1_inst_RXD0,
	hps_0_hps_io_hps_io_emac1_inst_MDIO,
	hps_0_hps_io_hps_io_emac1_inst_MDC,
	hps_0_hps_io_hps_io_emac1_inst_RX_CTL,
	hps_0_hps_io_hps_io_emac1_inst_TX_CTL,
	hps_0_hps_io_hps_io_emac1_inst_RX_CLK,
	hps_0_hps_io_hps_io_emac1_inst_RXD1,
	hps_0_hps_io_hps_io_emac1_inst_RXD2,
	hps_0_hps_io_hps_io_emac1_inst_RXD3,
	hps_0_hps_io_hps_io_sdio_inst_CMD,
	hps_0_hps_io_hps_io_sdio_inst_D0,
	hps_0_hps_io_hps_io_sdio_inst_D1,
	hps_0_hps_io_hps_io_sdio_inst_CLK,
	hps_0_hps_io_hps_io_sdio_inst_D2,
	hps_0_hps_io_hps_io_sdio_inst_D3,
	hps_0_hps_io_hps_io_usb1_inst_D0,
	hps_0_hps_io_hps_io_usb1_inst_D1,
	hps_0_hps_io_hps_io_usb1_inst_D2,
	hps_0_hps_io_hps_io_usb1_inst_D3,
	hps_0_hps_io_hps_io_usb1_inst_D4,
	hps_0_hps_io_hps_io_usb1_inst_D5,
	hps_0_hps_io_hps_io_usb1_inst_D6,
	hps_0_hps_io_hps_io_usb1_inst_D7,
	hps_0_hps_io_hps_io_usb1_inst_CLK,
	hps_0_hps_io_hps_io_usb1_inst_STP,
	hps_0_hps_io_hps_io_usb1_inst_DIR,
	hps_0_hps_io_hps_io_usb1_inst_NXT,
	hps_0_hps_io_hps_io_spim1_inst_CLK,
	hps_0_hps_io_hps_io_spim1_inst_MOSI,
	hps_0_hps_io_hps_io_spim1_inst_MISO,
	hps_0_hps_io_hps_io_spim1_inst_SS0,
	hps_0_hps_io_hps_io_uart0_inst_RX,
	hps_0_hps_io_hps_io_uart0_inst_TX,
	hps_0_hps_io_hps_io_i2c0_inst_SDA,
	hps_0_hps_io_hps_io_i2c0_inst_SCL,
	hps_0_hps_io_hps_io_i2c1_inst_SDA,
	hps_0_hps_io_hps_io_i2c1_inst_SCL,
	hps_0_hps_io_hps_io_gpio_inst_GPIO09,
	hps_0_hps_io_hps_io_gpio_inst_GPIO35,
	hps_0_hps_io_hps_io_gpio_inst_GPIO40,
	hps_0_hps_io_hps_io_gpio_inst_GPIO53,
	hps_0_hps_io_hps_io_gpio_inst_GPIO54,
	hps_0_hps_io_hps_io_gpio_inst_GPIO61,
	lcd_clk_external_connection_export,
	lcd_data_external_connection_in_port,
	lcd_data_external_connection_out_port,
	memory_mem_a,
	memory_mem_ba,
	memory_mem_ck,
	memory_mem_ck_n,
	memory_mem_cke,
	memory_mem_cs_n,
	memory_mem_ras_n,
	memory_mem_cas_n,
	memory_mem_we_n,
	memory_mem_reset_n,
	memory_mem_dq,
	memory_mem_dqs,
	memory_mem_dqs_n,
	memory_mem_odt,
	memory_mem_dm,
	memory_oct_rzqin,
	pio_led_external_connection_export,
	reset_reset_n,
	scl_external_connection_export,
	sda_external_connection_export,
	cam_wr_en_external_connection_export,
	cam_frame_num_external_connection_export);	

	input		clk_clk;
	input		hps_0_f2h_cold_reset_req_reset_n;
	input		hps_0_f2h_debug_reset_req_reset_n;
	input	[31:0]	hps_0_f2h_sdram0_data_araddr;
	input	[3:0]	hps_0_f2h_sdram0_data_arlen;
	input	[7:0]	hps_0_f2h_sdram0_data_arid;
	input	[2:0]	hps_0_f2h_sdram0_data_arsize;
	input	[1:0]	hps_0_f2h_sdram0_data_arburst;
	input	[1:0]	hps_0_f2h_sdram0_data_arlock;
	input	[2:0]	hps_0_f2h_sdram0_data_arprot;
	input		hps_0_f2h_sdram0_data_arvalid;
	input	[3:0]	hps_0_f2h_sdram0_data_arcache;
	input	[31:0]	hps_0_f2h_sdram0_data_awaddr;
	input	[3:0]	hps_0_f2h_sdram0_data_awlen;
	input	[7:0]	hps_0_f2h_sdram0_data_awid;
	input	[2:0]	hps_0_f2h_sdram0_data_awsize;
	input	[1:0]	hps_0_f2h_sdram0_data_awburst;
	input	[1:0]	hps_0_f2h_sdram0_data_awlock;
	input	[2:0]	hps_0_f2h_sdram0_data_awprot;
	input		hps_0_f2h_sdram0_data_awvalid;
	input	[3:0]	hps_0_f2h_sdram0_data_awcache;
	output	[1:0]	hps_0_f2h_sdram0_data_bresp;
	output	[7:0]	hps_0_f2h_sdram0_data_bid;
	output		hps_0_f2h_sdram0_data_bvalid;
	input		hps_0_f2h_sdram0_data_bready;
	output		hps_0_f2h_sdram0_data_arready;
	output		hps_0_f2h_sdram0_data_awready;
	input		hps_0_f2h_sdram0_data_rready;
	output	[63:0]	hps_0_f2h_sdram0_data_rdata;
	output	[1:0]	hps_0_f2h_sdram0_data_rresp;
	output		hps_0_f2h_sdram0_data_rlast;
	output	[7:0]	hps_0_f2h_sdram0_data_rid;
	output		hps_0_f2h_sdram0_data_rvalid;
	input		hps_0_f2h_sdram0_data_wlast;
	input		hps_0_f2h_sdram0_data_wvalid;
	input	[63:0]	hps_0_f2h_sdram0_data_wdata;
	input	[7:0]	hps_0_f2h_sdram0_data_wstrb;
	output		hps_0_f2h_sdram0_data_wready;
	input	[7:0]	hps_0_f2h_sdram0_data_wid;
	input	[27:0]	hps_0_f2h_stm_hw_events_stm_hwevents;
	input		hps_0_f2h_warm_reset_req_reset_n;
	output		hps_0_h2f_reset_reset_n;
	output		hps_0_hps_io_hps_io_emac1_inst_TX_CLK;
	output		hps_0_hps_io_hps_io_emac1_inst_TXD0;
	output		hps_0_hps_io_hps_io_emac1_inst_TXD1;
	output		hps_0_hps_io_hps_io_emac1_inst_TXD2;
	output		hps_0_hps_io_hps_io_emac1_inst_TXD3;
	input		hps_0_hps_io_hps_io_emac1_inst_RXD0;
	inout		hps_0_hps_io_hps_io_emac1_inst_MDIO;
	output		hps_0_hps_io_hps_io_emac1_inst_MDC;
	input		hps_0_hps_io_hps_io_emac1_inst_RX_CTL;
	output		hps_0_hps_io_hps_io_emac1_inst_TX_CTL;
	input		hps_0_hps_io_hps_io_emac1_inst_RX_CLK;
	input		hps_0_hps_io_hps_io_emac1_inst_RXD1;
	input		hps_0_hps_io_hps_io_emac1_inst_RXD2;
	input		hps_0_hps_io_hps_io_emac1_inst_RXD3;
	inout		hps_0_hps_io_hps_io_sdio_inst_CMD;
	inout		hps_0_hps_io_hps_io_sdio_inst_D0;
	inout		hps_0_hps_io_hps_io_sdio_inst_D1;
	output		hps_0_hps_io_hps_io_sdio_inst_CLK;
	inout		hps_0_hps_io_hps_io_sdio_inst_D2;
	inout		hps_0_hps_io_hps_io_sdio_inst_D3;
	inout		hps_0_hps_io_hps_io_usb1_inst_D0;
	inout		hps_0_hps_io_hps_io_usb1_inst_D1;
	inout		hps_0_hps_io_hps_io_usb1_inst_D2;
	inout		hps_0_hps_io_hps_io_usb1_inst_D3;
	inout		hps_0_hps_io_hps_io_usb1_inst_D4;
	inout		hps_0_hps_io_hps_io_usb1_inst_D5;
	inout		hps_0_hps_io_hps_io_usb1_inst_D6;
	inout		hps_0_hps_io_hps_io_usb1_inst_D7;
	input		hps_0_hps_io_hps_io_usb1_inst_CLK;
	output		hps_0_hps_io_hps_io_usb1_inst_STP;
	input		hps_0_hps_io_hps_io_usb1_inst_DIR;
	input		hps_0_hps_io_hps_io_usb1_inst_NXT;
	output		hps_0_hps_io_hps_io_spim1_inst_CLK;
	output		hps_0_hps_io_hps_io_spim1_inst_MOSI;
	input		hps_0_hps_io_hps_io_spim1_inst_MISO;
	output		hps_0_hps_io_hps_io_spim1_inst_SS0;
	input		hps_0_hps_io_hps_io_uart0_inst_RX;
	output		hps_0_hps_io_hps_io_uart0_inst_TX;
	inout		hps_0_hps_io_hps_io_i2c0_inst_SDA;
	inout		hps_0_hps_io_hps_io_i2c0_inst_SCL;
	inout		hps_0_hps_io_hps_io_i2c1_inst_SDA;
	inout		hps_0_hps_io_hps_io_i2c1_inst_SCL;
	inout		hps_0_hps_io_hps_io_gpio_inst_GPIO09;
	inout		hps_0_hps_io_hps_io_gpio_inst_GPIO35;
	inout		hps_0_hps_io_hps_io_gpio_inst_GPIO40;
	inout		hps_0_hps_io_hps_io_gpio_inst_GPIO53;
	inout		hps_0_hps_io_hps_io_gpio_inst_GPIO54;
	inout		hps_0_hps_io_hps_io_gpio_inst_GPIO61;
	output	[7:0]	lcd_clk_external_connection_export;
	input	[15:0]	lcd_data_external_connection_in_port;
	output	[15:0]	lcd_data_external_connection_out_port;
	output	[14:0]	memory_mem_a;
	output	[2:0]	memory_mem_ba;
	output		memory_mem_ck;
	output		memory_mem_ck_n;
	output		memory_mem_cke;
	output		memory_mem_cs_n;
	output		memory_mem_ras_n;
	output		memory_mem_cas_n;
	output		memory_mem_we_n;
	output		memory_mem_reset_n;
	inout	[31:0]	memory_mem_dq;
	inout	[3:0]	memory_mem_dqs;
	inout	[3:0]	memory_mem_dqs_n;
	output		memory_mem_odt;
	output	[3:0]	memory_mem_dm;
	input		memory_oct_rzqin;
	output	[7:0]	pio_led_external_connection_export;
	input		reset_reset_n;
	inout		scl_external_connection_export;
	inout		sda_external_connection_export;
	output	[7:0]	cam_wr_en_external_connection_export;
	input	[7:0]	cam_frame_num_external_connection_export;
endmodule
