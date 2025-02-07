	component soc_system is
		port (
			clk_clk                                  : in    std_logic                     := 'X';             -- clk
			hps_0_f2h_cold_reset_req_reset_n         : in    std_logic                     := 'X';             -- reset_n
			hps_0_f2h_debug_reset_req_reset_n        : in    std_logic                     := 'X';             -- reset_n
			hps_0_f2h_sdram0_data_araddr             : in    std_logic_vector(31 downto 0) := (others => 'X'); -- araddr
			hps_0_f2h_sdram0_data_arlen              : in    std_logic_vector(3 downto 0)  := (others => 'X'); -- arlen
			hps_0_f2h_sdram0_data_arid               : in    std_logic_vector(7 downto 0)  := (others => 'X'); -- arid
			hps_0_f2h_sdram0_data_arsize             : in    std_logic_vector(2 downto 0)  := (others => 'X'); -- arsize
			hps_0_f2h_sdram0_data_arburst            : in    std_logic_vector(1 downto 0)  := (others => 'X'); -- arburst
			hps_0_f2h_sdram0_data_arlock             : in    std_logic_vector(1 downto 0)  := (others => 'X'); -- arlock
			hps_0_f2h_sdram0_data_arprot             : in    std_logic_vector(2 downto 0)  := (others => 'X'); -- arprot
			hps_0_f2h_sdram0_data_arvalid            : in    std_logic                     := 'X';             -- arvalid
			hps_0_f2h_sdram0_data_arcache            : in    std_logic_vector(3 downto 0)  := (others => 'X'); -- arcache
			hps_0_f2h_sdram0_data_awaddr             : in    std_logic_vector(31 downto 0) := (others => 'X'); -- awaddr
			hps_0_f2h_sdram0_data_awlen              : in    std_logic_vector(3 downto 0)  := (others => 'X'); -- awlen
			hps_0_f2h_sdram0_data_awid               : in    std_logic_vector(7 downto 0)  := (others => 'X'); -- awid
			hps_0_f2h_sdram0_data_awsize             : in    std_logic_vector(2 downto 0)  := (others => 'X'); -- awsize
			hps_0_f2h_sdram0_data_awburst            : in    std_logic_vector(1 downto 0)  := (others => 'X'); -- awburst
			hps_0_f2h_sdram0_data_awlock             : in    std_logic_vector(1 downto 0)  := (others => 'X'); -- awlock
			hps_0_f2h_sdram0_data_awprot             : in    std_logic_vector(2 downto 0)  := (others => 'X'); -- awprot
			hps_0_f2h_sdram0_data_awvalid            : in    std_logic                     := 'X';             -- awvalid
			hps_0_f2h_sdram0_data_awcache            : in    std_logic_vector(3 downto 0)  := (others => 'X'); -- awcache
			hps_0_f2h_sdram0_data_bresp              : out   std_logic_vector(1 downto 0);                     -- bresp
			hps_0_f2h_sdram0_data_bid                : out   std_logic_vector(7 downto 0);                     -- bid
			hps_0_f2h_sdram0_data_bvalid             : out   std_logic;                                        -- bvalid
			hps_0_f2h_sdram0_data_bready             : in    std_logic                     := 'X';             -- bready
			hps_0_f2h_sdram0_data_arready            : out   std_logic;                                        -- arready
			hps_0_f2h_sdram0_data_awready            : out   std_logic;                                        -- awready
			hps_0_f2h_sdram0_data_rready             : in    std_logic                     := 'X';             -- rready
			hps_0_f2h_sdram0_data_rdata              : out   std_logic_vector(63 downto 0);                    -- rdata
			hps_0_f2h_sdram0_data_rresp              : out   std_logic_vector(1 downto 0);                     -- rresp
			hps_0_f2h_sdram0_data_rlast              : out   std_logic;                                        -- rlast
			hps_0_f2h_sdram0_data_rid                : out   std_logic_vector(7 downto 0);                     -- rid
			hps_0_f2h_sdram0_data_rvalid             : out   std_logic;                                        -- rvalid
			hps_0_f2h_sdram0_data_wlast              : in    std_logic                     := 'X';             -- wlast
			hps_0_f2h_sdram0_data_wvalid             : in    std_logic                     := 'X';             -- wvalid
			hps_0_f2h_sdram0_data_wdata              : in    std_logic_vector(63 downto 0) := (others => 'X'); -- wdata
			hps_0_f2h_sdram0_data_wstrb              : in    std_logic_vector(7 downto 0)  := (others => 'X'); -- wstrb
			hps_0_f2h_sdram0_data_wready             : out   std_logic;                                        -- wready
			hps_0_f2h_sdram0_data_wid                : in    std_logic_vector(7 downto 0)  := (others => 'X'); -- wid
			hps_0_f2h_stm_hw_events_stm_hwevents     : in    std_logic_vector(27 downto 0) := (others => 'X'); -- stm_hwevents
			hps_0_f2h_warm_reset_req_reset_n         : in    std_logic                     := 'X';             -- reset_n
			hps_0_h2f_reset_reset_n                  : out   std_logic;                                        -- reset_n
			hps_0_hps_io_hps_io_emac1_inst_TX_CLK    : out   std_logic;                                        -- hps_io_emac1_inst_TX_CLK
			hps_0_hps_io_hps_io_emac1_inst_TXD0      : out   std_logic;                                        -- hps_io_emac1_inst_TXD0
			hps_0_hps_io_hps_io_emac1_inst_TXD1      : out   std_logic;                                        -- hps_io_emac1_inst_TXD1
			hps_0_hps_io_hps_io_emac1_inst_TXD2      : out   std_logic;                                        -- hps_io_emac1_inst_TXD2
			hps_0_hps_io_hps_io_emac1_inst_TXD3      : out   std_logic;                                        -- hps_io_emac1_inst_TXD3
			hps_0_hps_io_hps_io_emac1_inst_RXD0      : in    std_logic                     := 'X';             -- hps_io_emac1_inst_RXD0
			hps_0_hps_io_hps_io_emac1_inst_MDIO      : inout std_logic                     := 'X';             -- hps_io_emac1_inst_MDIO
			hps_0_hps_io_hps_io_emac1_inst_MDC       : out   std_logic;                                        -- hps_io_emac1_inst_MDC
			hps_0_hps_io_hps_io_emac1_inst_RX_CTL    : in    std_logic                     := 'X';             -- hps_io_emac1_inst_RX_CTL
			hps_0_hps_io_hps_io_emac1_inst_TX_CTL    : out   std_logic;                                        -- hps_io_emac1_inst_TX_CTL
			hps_0_hps_io_hps_io_emac1_inst_RX_CLK    : in    std_logic                     := 'X';             -- hps_io_emac1_inst_RX_CLK
			hps_0_hps_io_hps_io_emac1_inst_RXD1      : in    std_logic                     := 'X';             -- hps_io_emac1_inst_RXD1
			hps_0_hps_io_hps_io_emac1_inst_RXD2      : in    std_logic                     := 'X';             -- hps_io_emac1_inst_RXD2
			hps_0_hps_io_hps_io_emac1_inst_RXD3      : in    std_logic                     := 'X';             -- hps_io_emac1_inst_RXD3
			hps_0_hps_io_hps_io_sdio_inst_CMD        : inout std_logic                     := 'X';             -- hps_io_sdio_inst_CMD
			hps_0_hps_io_hps_io_sdio_inst_D0         : inout std_logic                     := 'X';             -- hps_io_sdio_inst_D0
			hps_0_hps_io_hps_io_sdio_inst_D1         : inout std_logic                     := 'X';             -- hps_io_sdio_inst_D1
			hps_0_hps_io_hps_io_sdio_inst_CLK        : out   std_logic;                                        -- hps_io_sdio_inst_CLK
			hps_0_hps_io_hps_io_sdio_inst_D2         : inout std_logic                     := 'X';             -- hps_io_sdio_inst_D2
			hps_0_hps_io_hps_io_sdio_inst_D3         : inout std_logic                     := 'X';             -- hps_io_sdio_inst_D3
			hps_0_hps_io_hps_io_usb1_inst_D0         : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D0
			hps_0_hps_io_hps_io_usb1_inst_D1         : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D1
			hps_0_hps_io_hps_io_usb1_inst_D2         : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D2
			hps_0_hps_io_hps_io_usb1_inst_D3         : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D3
			hps_0_hps_io_hps_io_usb1_inst_D4         : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D4
			hps_0_hps_io_hps_io_usb1_inst_D5         : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D5
			hps_0_hps_io_hps_io_usb1_inst_D6         : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D6
			hps_0_hps_io_hps_io_usb1_inst_D7         : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D7
			hps_0_hps_io_hps_io_usb1_inst_CLK        : in    std_logic                     := 'X';             -- hps_io_usb1_inst_CLK
			hps_0_hps_io_hps_io_usb1_inst_STP        : out   std_logic;                                        -- hps_io_usb1_inst_STP
			hps_0_hps_io_hps_io_usb1_inst_DIR        : in    std_logic                     := 'X';             -- hps_io_usb1_inst_DIR
			hps_0_hps_io_hps_io_usb1_inst_NXT        : in    std_logic                     := 'X';             -- hps_io_usb1_inst_NXT
			hps_0_hps_io_hps_io_spim1_inst_CLK       : out   std_logic;                                        -- hps_io_spim1_inst_CLK
			hps_0_hps_io_hps_io_spim1_inst_MOSI      : out   std_logic;                                        -- hps_io_spim1_inst_MOSI
			hps_0_hps_io_hps_io_spim1_inst_MISO      : in    std_logic                     := 'X';             -- hps_io_spim1_inst_MISO
			hps_0_hps_io_hps_io_spim1_inst_SS0       : out   std_logic;                                        -- hps_io_spim1_inst_SS0
			hps_0_hps_io_hps_io_uart0_inst_RX        : in    std_logic                     := 'X';             -- hps_io_uart0_inst_RX
			hps_0_hps_io_hps_io_uart0_inst_TX        : out   std_logic;                                        -- hps_io_uart0_inst_TX
			hps_0_hps_io_hps_io_i2c0_inst_SDA        : inout std_logic                     := 'X';             -- hps_io_i2c0_inst_SDA
			hps_0_hps_io_hps_io_i2c0_inst_SCL        : inout std_logic                     := 'X';             -- hps_io_i2c0_inst_SCL
			hps_0_hps_io_hps_io_i2c1_inst_SDA        : inout std_logic                     := 'X';             -- hps_io_i2c1_inst_SDA
			hps_0_hps_io_hps_io_i2c1_inst_SCL        : inout std_logic                     := 'X';             -- hps_io_i2c1_inst_SCL
			hps_0_hps_io_hps_io_gpio_inst_GPIO09     : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO09
			hps_0_hps_io_hps_io_gpio_inst_GPIO35     : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO35
			hps_0_hps_io_hps_io_gpio_inst_GPIO40     : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO40
			hps_0_hps_io_hps_io_gpio_inst_GPIO53     : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO53
			hps_0_hps_io_hps_io_gpio_inst_GPIO54     : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO54
			hps_0_hps_io_hps_io_gpio_inst_GPIO61     : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO61
			lcd_clk_external_connection_export       : out   std_logic_vector(7 downto 0);                     -- export
			lcd_data_external_connection_in_port     : in    std_logic_vector(15 downto 0) := (others => 'X'); -- in_port
			lcd_data_external_connection_out_port    : out   std_logic_vector(15 downto 0);                    -- out_port
			memory_mem_a                             : out   std_logic_vector(14 downto 0);                    -- mem_a
			memory_mem_ba                            : out   std_logic_vector(2 downto 0);                     -- mem_ba
			memory_mem_ck                            : out   std_logic;                                        -- mem_ck
			memory_mem_ck_n                          : out   std_logic;                                        -- mem_ck_n
			memory_mem_cke                           : out   std_logic;                                        -- mem_cke
			memory_mem_cs_n                          : out   std_logic;                                        -- mem_cs_n
			memory_mem_ras_n                         : out   std_logic;                                        -- mem_ras_n
			memory_mem_cas_n                         : out   std_logic;                                        -- mem_cas_n
			memory_mem_we_n                          : out   std_logic;                                        -- mem_we_n
			memory_mem_reset_n                       : out   std_logic;                                        -- mem_reset_n
			memory_mem_dq                            : inout std_logic_vector(31 downto 0) := (others => 'X'); -- mem_dq
			memory_mem_dqs                           : inout std_logic_vector(3 downto 0)  := (others => 'X'); -- mem_dqs
			memory_mem_dqs_n                         : inout std_logic_vector(3 downto 0)  := (others => 'X'); -- mem_dqs_n
			memory_mem_odt                           : out   std_logic;                                        -- mem_odt
			memory_mem_dm                            : out   std_logic_vector(3 downto 0);                     -- mem_dm
			memory_oct_rzqin                         : in    std_logic                     := 'X';             -- oct_rzqin
			pio_led_external_connection_export       : out   std_logic_vector(7 downto 0);                     -- export
			reset_reset_n                            : in    std_logic                     := 'X';             -- reset_n
			scl_external_connection_export           : inout std_logic                     := 'X';             -- export
			sda_external_connection_export           : inout std_logic                     := 'X';             -- export
			cam_wr_en_external_connection_export     : out   std_logic_vector(7 downto 0);                     -- export
			cam_frame_num_external_connection_export : in    std_logic_vector(7 downto 0)  := (others => 'X')  -- export
		);
	end component soc_system;

	u0 : component soc_system
		port map (
			clk_clk                                  => CONNECTED_TO_clk_clk,                                  --                               clk.clk
			hps_0_f2h_cold_reset_req_reset_n         => CONNECTED_TO_hps_0_f2h_cold_reset_req_reset_n,         --          hps_0_f2h_cold_reset_req.reset_n
			hps_0_f2h_debug_reset_req_reset_n        => CONNECTED_TO_hps_0_f2h_debug_reset_req_reset_n,        --         hps_0_f2h_debug_reset_req.reset_n
			hps_0_f2h_sdram0_data_araddr             => CONNECTED_TO_hps_0_f2h_sdram0_data_araddr,             --             hps_0_f2h_sdram0_data.araddr
			hps_0_f2h_sdram0_data_arlen              => CONNECTED_TO_hps_0_f2h_sdram0_data_arlen,              --                                  .arlen
			hps_0_f2h_sdram0_data_arid               => CONNECTED_TO_hps_0_f2h_sdram0_data_arid,               --                                  .arid
			hps_0_f2h_sdram0_data_arsize             => CONNECTED_TO_hps_0_f2h_sdram0_data_arsize,             --                                  .arsize
			hps_0_f2h_sdram0_data_arburst            => CONNECTED_TO_hps_0_f2h_sdram0_data_arburst,            --                                  .arburst
			hps_0_f2h_sdram0_data_arlock             => CONNECTED_TO_hps_0_f2h_sdram0_data_arlock,             --                                  .arlock
			hps_0_f2h_sdram0_data_arprot             => CONNECTED_TO_hps_0_f2h_sdram0_data_arprot,             --                                  .arprot
			hps_0_f2h_sdram0_data_arvalid            => CONNECTED_TO_hps_0_f2h_sdram0_data_arvalid,            --                                  .arvalid
			hps_0_f2h_sdram0_data_arcache            => CONNECTED_TO_hps_0_f2h_sdram0_data_arcache,            --                                  .arcache
			hps_0_f2h_sdram0_data_awaddr             => CONNECTED_TO_hps_0_f2h_sdram0_data_awaddr,             --                                  .awaddr
			hps_0_f2h_sdram0_data_awlen              => CONNECTED_TO_hps_0_f2h_sdram0_data_awlen,              --                                  .awlen
			hps_0_f2h_sdram0_data_awid               => CONNECTED_TO_hps_0_f2h_sdram0_data_awid,               --                                  .awid
			hps_0_f2h_sdram0_data_awsize             => CONNECTED_TO_hps_0_f2h_sdram0_data_awsize,             --                                  .awsize
			hps_0_f2h_sdram0_data_awburst            => CONNECTED_TO_hps_0_f2h_sdram0_data_awburst,            --                                  .awburst
			hps_0_f2h_sdram0_data_awlock             => CONNECTED_TO_hps_0_f2h_sdram0_data_awlock,             --                                  .awlock
			hps_0_f2h_sdram0_data_awprot             => CONNECTED_TO_hps_0_f2h_sdram0_data_awprot,             --                                  .awprot
			hps_0_f2h_sdram0_data_awvalid            => CONNECTED_TO_hps_0_f2h_sdram0_data_awvalid,            --                                  .awvalid
			hps_0_f2h_sdram0_data_awcache            => CONNECTED_TO_hps_0_f2h_sdram0_data_awcache,            --                                  .awcache
			hps_0_f2h_sdram0_data_bresp              => CONNECTED_TO_hps_0_f2h_sdram0_data_bresp,              --                                  .bresp
			hps_0_f2h_sdram0_data_bid                => CONNECTED_TO_hps_0_f2h_sdram0_data_bid,                --                                  .bid
			hps_0_f2h_sdram0_data_bvalid             => CONNECTED_TO_hps_0_f2h_sdram0_data_bvalid,             --                                  .bvalid
			hps_0_f2h_sdram0_data_bready             => CONNECTED_TO_hps_0_f2h_sdram0_data_bready,             --                                  .bready
			hps_0_f2h_sdram0_data_arready            => CONNECTED_TO_hps_0_f2h_sdram0_data_arready,            --                                  .arready
			hps_0_f2h_sdram0_data_awready            => CONNECTED_TO_hps_0_f2h_sdram0_data_awready,            --                                  .awready
			hps_0_f2h_sdram0_data_rready             => CONNECTED_TO_hps_0_f2h_sdram0_data_rready,             --                                  .rready
			hps_0_f2h_sdram0_data_rdata              => CONNECTED_TO_hps_0_f2h_sdram0_data_rdata,              --                                  .rdata
			hps_0_f2h_sdram0_data_rresp              => CONNECTED_TO_hps_0_f2h_sdram0_data_rresp,              --                                  .rresp
			hps_0_f2h_sdram0_data_rlast              => CONNECTED_TO_hps_0_f2h_sdram0_data_rlast,              --                                  .rlast
			hps_0_f2h_sdram0_data_rid                => CONNECTED_TO_hps_0_f2h_sdram0_data_rid,                --                                  .rid
			hps_0_f2h_sdram0_data_rvalid             => CONNECTED_TO_hps_0_f2h_sdram0_data_rvalid,             --                                  .rvalid
			hps_0_f2h_sdram0_data_wlast              => CONNECTED_TO_hps_0_f2h_sdram0_data_wlast,              --                                  .wlast
			hps_0_f2h_sdram0_data_wvalid             => CONNECTED_TO_hps_0_f2h_sdram0_data_wvalid,             --                                  .wvalid
			hps_0_f2h_sdram0_data_wdata              => CONNECTED_TO_hps_0_f2h_sdram0_data_wdata,              --                                  .wdata
			hps_0_f2h_sdram0_data_wstrb              => CONNECTED_TO_hps_0_f2h_sdram0_data_wstrb,              --                                  .wstrb
			hps_0_f2h_sdram0_data_wready             => CONNECTED_TO_hps_0_f2h_sdram0_data_wready,             --                                  .wready
			hps_0_f2h_sdram0_data_wid                => CONNECTED_TO_hps_0_f2h_sdram0_data_wid,                --                                  .wid
			hps_0_f2h_stm_hw_events_stm_hwevents     => CONNECTED_TO_hps_0_f2h_stm_hw_events_stm_hwevents,     --           hps_0_f2h_stm_hw_events.stm_hwevents
			hps_0_f2h_warm_reset_req_reset_n         => CONNECTED_TO_hps_0_f2h_warm_reset_req_reset_n,         --          hps_0_f2h_warm_reset_req.reset_n
			hps_0_h2f_reset_reset_n                  => CONNECTED_TO_hps_0_h2f_reset_reset_n,                  --                   hps_0_h2f_reset.reset_n
			hps_0_hps_io_hps_io_emac1_inst_TX_CLK    => CONNECTED_TO_hps_0_hps_io_hps_io_emac1_inst_TX_CLK,    --                      hps_0_hps_io.hps_io_emac1_inst_TX_CLK
			hps_0_hps_io_hps_io_emac1_inst_TXD0      => CONNECTED_TO_hps_0_hps_io_hps_io_emac1_inst_TXD0,      --                                  .hps_io_emac1_inst_TXD0
			hps_0_hps_io_hps_io_emac1_inst_TXD1      => CONNECTED_TO_hps_0_hps_io_hps_io_emac1_inst_TXD1,      --                                  .hps_io_emac1_inst_TXD1
			hps_0_hps_io_hps_io_emac1_inst_TXD2      => CONNECTED_TO_hps_0_hps_io_hps_io_emac1_inst_TXD2,      --                                  .hps_io_emac1_inst_TXD2
			hps_0_hps_io_hps_io_emac1_inst_TXD3      => CONNECTED_TO_hps_0_hps_io_hps_io_emac1_inst_TXD3,      --                                  .hps_io_emac1_inst_TXD3
			hps_0_hps_io_hps_io_emac1_inst_RXD0      => CONNECTED_TO_hps_0_hps_io_hps_io_emac1_inst_RXD0,      --                                  .hps_io_emac1_inst_RXD0
			hps_0_hps_io_hps_io_emac1_inst_MDIO      => CONNECTED_TO_hps_0_hps_io_hps_io_emac1_inst_MDIO,      --                                  .hps_io_emac1_inst_MDIO
			hps_0_hps_io_hps_io_emac1_inst_MDC       => CONNECTED_TO_hps_0_hps_io_hps_io_emac1_inst_MDC,       --                                  .hps_io_emac1_inst_MDC
			hps_0_hps_io_hps_io_emac1_inst_RX_CTL    => CONNECTED_TO_hps_0_hps_io_hps_io_emac1_inst_RX_CTL,    --                                  .hps_io_emac1_inst_RX_CTL
			hps_0_hps_io_hps_io_emac1_inst_TX_CTL    => CONNECTED_TO_hps_0_hps_io_hps_io_emac1_inst_TX_CTL,    --                                  .hps_io_emac1_inst_TX_CTL
			hps_0_hps_io_hps_io_emac1_inst_RX_CLK    => CONNECTED_TO_hps_0_hps_io_hps_io_emac1_inst_RX_CLK,    --                                  .hps_io_emac1_inst_RX_CLK
			hps_0_hps_io_hps_io_emac1_inst_RXD1      => CONNECTED_TO_hps_0_hps_io_hps_io_emac1_inst_RXD1,      --                                  .hps_io_emac1_inst_RXD1
			hps_0_hps_io_hps_io_emac1_inst_RXD2      => CONNECTED_TO_hps_0_hps_io_hps_io_emac1_inst_RXD2,      --                                  .hps_io_emac1_inst_RXD2
			hps_0_hps_io_hps_io_emac1_inst_RXD3      => CONNECTED_TO_hps_0_hps_io_hps_io_emac1_inst_RXD3,      --                                  .hps_io_emac1_inst_RXD3
			hps_0_hps_io_hps_io_sdio_inst_CMD        => CONNECTED_TO_hps_0_hps_io_hps_io_sdio_inst_CMD,        --                                  .hps_io_sdio_inst_CMD
			hps_0_hps_io_hps_io_sdio_inst_D0         => CONNECTED_TO_hps_0_hps_io_hps_io_sdio_inst_D0,         --                                  .hps_io_sdio_inst_D0
			hps_0_hps_io_hps_io_sdio_inst_D1         => CONNECTED_TO_hps_0_hps_io_hps_io_sdio_inst_D1,         --                                  .hps_io_sdio_inst_D1
			hps_0_hps_io_hps_io_sdio_inst_CLK        => CONNECTED_TO_hps_0_hps_io_hps_io_sdio_inst_CLK,        --                                  .hps_io_sdio_inst_CLK
			hps_0_hps_io_hps_io_sdio_inst_D2         => CONNECTED_TO_hps_0_hps_io_hps_io_sdio_inst_D2,         --                                  .hps_io_sdio_inst_D2
			hps_0_hps_io_hps_io_sdio_inst_D3         => CONNECTED_TO_hps_0_hps_io_hps_io_sdio_inst_D3,         --                                  .hps_io_sdio_inst_D3
			hps_0_hps_io_hps_io_usb1_inst_D0         => CONNECTED_TO_hps_0_hps_io_hps_io_usb1_inst_D0,         --                                  .hps_io_usb1_inst_D0
			hps_0_hps_io_hps_io_usb1_inst_D1         => CONNECTED_TO_hps_0_hps_io_hps_io_usb1_inst_D1,         --                                  .hps_io_usb1_inst_D1
			hps_0_hps_io_hps_io_usb1_inst_D2         => CONNECTED_TO_hps_0_hps_io_hps_io_usb1_inst_D2,         --                                  .hps_io_usb1_inst_D2
			hps_0_hps_io_hps_io_usb1_inst_D3         => CONNECTED_TO_hps_0_hps_io_hps_io_usb1_inst_D3,         --                                  .hps_io_usb1_inst_D3
			hps_0_hps_io_hps_io_usb1_inst_D4         => CONNECTED_TO_hps_0_hps_io_hps_io_usb1_inst_D4,         --                                  .hps_io_usb1_inst_D4
			hps_0_hps_io_hps_io_usb1_inst_D5         => CONNECTED_TO_hps_0_hps_io_hps_io_usb1_inst_D5,         --                                  .hps_io_usb1_inst_D5
			hps_0_hps_io_hps_io_usb1_inst_D6         => CONNECTED_TO_hps_0_hps_io_hps_io_usb1_inst_D6,         --                                  .hps_io_usb1_inst_D6
			hps_0_hps_io_hps_io_usb1_inst_D7         => CONNECTED_TO_hps_0_hps_io_hps_io_usb1_inst_D7,         --                                  .hps_io_usb1_inst_D7
			hps_0_hps_io_hps_io_usb1_inst_CLK        => CONNECTED_TO_hps_0_hps_io_hps_io_usb1_inst_CLK,        --                                  .hps_io_usb1_inst_CLK
			hps_0_hps_io_hps_io_usb1_inst_STP        => CONNECTED_TO_hps_0_hps_io_hps_io_usb1_inst_STP,        --                                  .hps_io_usb1_inst_STP
			hps_0_hps_io_hps_io_usb1_inst_DIR        => CONNECTED_TO_hps_0_hps_io_hps_io_usb1_inst_DIR,        --                                  .hps_io_usb1_inst_DIR
			hps_0_hps_io_hps_io_usb1_inst_NXT        => CONNECTED_TO_hps_0_hps_io_hps_io_usb1_inst_NXT,        --                                  .hps_io_usb1_inst_NXT
			hps_0_hps_io_hps_io_spim1_inst_CLK       => CONNECTED_TO_hps_0_hps_io_hps_io_spim1_inst_CLK,       --                                  .hps_io_spim1_inst_CLK
			hps_0_hps_io_hps_io_spim1_inst_MOSI      => CONNECTED_TO_hps_0_hps_io_hps_io_spim1_inst_MOSI,      --                                  .hps_io_spim1_inst_MOSI
			hps_0_hps_io_hps_io_spim1_inst_MISO      => CONNECTED_TO_hps_0_hps_io_hps_io_spim1_inst_MISO,      --                                  .hps_io_spim1_inst_MISO
			hps_0_hps_io_hps_io_spim1_inst_SS0       => CONNECTED_TO_hps_0_hps_io_hps_io_spim1_inst_SS0,       --                                  .hps_io_spim1_inst_SS0
			hps_0_hps_io_hps_io_uart0_inst_RX        => CONNECTED_TO_hps_0_hps_io_hps_io_uart0_inst_RX,        --                                  .hps_io_uart0_inst_RX
			hps_0_hps_io_hps_io_uart0_inst_TX        => CONNECTED_TO_hps_0_hps_io_hps_io_uart0_inst_TX,        --                                  .hps_io_uart0_inst_TX
			hps_0_hps_io_hps_io_i2c0_inst_SDA        => CONNECTED_TO_hps_0_hps_io_hps_io_i2c0_inst_SDA,        --                                  .hps_io_i2c0_inst_SDA
			hps_0_hps_io_hps_io_i2c0_inst_SCL        => CONNECTED_TO_hps_0_hps_io_hps_io_i2c0_inst_SCL,        --                                  .hps_io_i2c0_inst_SCL
			hps_0_hps_io_hps_io_i2c1_inst_SDA        => CONNECTED_TO_hps_0_hps_io_hps_io_i2c1_inst_SDA,        --                                  .hps_io_i2c1_inst_SDA
			hps_0_hps_io_hps_io_i2c1_inst_SCL        => CONNECTED_TO_hps_0_hps_io_hps_io_i2c1_inst_SCL,        --                                  .hps_io_i2c1_inst_SCL
			hps_0_hps_io_hps_io_gpio_inst_GPIO09     => CONNECTED_TO_hps_0_hps_io_hps_io_gpio_inst_GPIO09,     --                                  .hps_io_gpio_inst_GPIO09
			hps_0_hps_io_hps_io_gpio_inst_GPIO35     => CONNECTED_TO_hps_0_hps_io_hps_io_gpio_inst_GPIO35,     --                                  .hps_io_gpio_inst_GPIO35
			hps_0_hps_io_hps_io_gpio_inst_GPIO40     => CONNECTED_TO_hps_0_hps_io_hps_io_gpio_inst_GPIO40,     --                                  .hps_io_gpio_inst_GPIO40
			hps_0_hps_io_hps_io_gpio_inst_GPIO53     => CONNECTED_TO_hps_0_hps_io_hps_io_gpio_inst_GPIO53,     --                                  .hps_io_gpio_inst_GPIO53
			hps_0_hps_io_hps_io_gpio_inst_GPIO54     => CONNECTED_TO_hps_0_hps_io_hps_io_gpio_inst_GPIO54,     --                                  .hps_io_gpio_inst_GPIO54
			hps_0_hps_io_hps_io_gpio_inst_GPIO61     => CONNECTED_TO_hps_0_hps_io_hps_io_gpio_inst_GPIO61,     --                                  .hps_io_gpio_inst_GPIO61
			lcd_clk_external_connection_export       => CONNECTED_TO_lcd_clk_external_connection_export,       --       lcd_clk_external_connection.export
			lcd_data_external_connection_in_port     => CONNECTED_TO_lcd_data_external_connection_in_port,     --      lcd_data_external_connection.in_port
			lcd_data_external_connection_out_port    => CONNECTED_TO_lcd_data_external_connection_out_port,    --                                  .out_port
			memory_mem_a                             => CONNECTED_TO_memory_mem_a,                             --                            memory.mem_a
			memory_mem_ba                            => CONNECTED_TO_memory_mem_ba,                            --                                  .mem_ba
			memory_mem_ck                            => CONNECTED_TO_memory_mem_ck,                            --                                  .mem_ck
			memory_mem_ck_n                          => CONNECTED_TO_memory_mem_ck_n,                          --                                  .mem_ck_n
			memory_mem_cke                           => CONNECTED_TO_memory_mem_cke,                           --                                  .mem_cke
			memory_mem_cs_n                          => CONNECTED_TO_memory_mem_cs_n,                          --                                  .mem_cs_n
			memory_mem_ras_n                         => CONNECTED_TO_memory_mem_ras_n,                         --                                  .mem_ras_n
			memory_mem_cas_n                         => CONNECTED_TO_memory_mem_cas_n,                         --                                  .mem_cas_n
			memory_mem_we_n                          => CONNECTED_TO_memory_mem_we_n,                          --                                  .mem_we_n
			memory_mem_reset_n                       => CONNECTED_TO_memory_mem_reset_n,                       --                                  .mem_reset_n
			memory_mem_dq                            => CONNECTED_TO_memory_mem_dq,                            --                                  .mem_dq
			memory_mem_dqs                           => CONNECTED_TO_memory_mem_dqs,                           --                                  .mem_dqs
			memory_mem_dqs_n                         => CONNECTED_TO_memory_mem_dqs_n,                         --                                  .mem_dqs_n
			memory_mem_odt                           => CONNECTED_TO_memory_mem_odt,                           --                                  .mem_odt
			memory_mem_dm                            => CONNECTED_TO_memory_mem_dm,                            --                                  .mem_dm
			memory_oct_rzqin                         => CONNECTED_TO_memory_oct_rzqin,                         --                                  .oct_rzqin
			pio_led_external_connection_export       => CONNECTED_TO_pio_led_external_connection_export,       --       pio_led_external_connection.export
			reset_reset_n                            => CONNECTED_TO_reset_reset_n,                            --                             reset.reset_n
			scl_external_connection_export           => CONNECTED_TO_scl_external_connection_export,           --           scl_external_connection.export
			sda_external_connection_export           => CONNECTED_TO_sda_external_connection_export,           --           sda_external_connection.export
			cam_wr_en_external_connection_export     => CONNECTED_TO_cam_wr_en_external_connection_export,     --     cam_wr_en_external_connection.export
			cam_frame_num_external_connection_export => CONNECTED_TO_cam_frame_num_external_connection_export  -- cam_frame_num_external_connection.export
		);

