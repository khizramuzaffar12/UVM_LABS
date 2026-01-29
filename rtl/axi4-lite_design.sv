//=============================================================================================
//       axi4lite slave design    
//=============================================================================================
package axi_lite_pkg;

	localparam ADDR_WIDTH = 32;
	localparam DATA_WIDTH = 32;
	localparam STRB_WIDTH = DATA_WIDTH / 8;

	localparam RESP_OKAY   = 2'b00;
	localparam RESP_EXOKAY = 2'b01;
	localparam RESP_SLVERR = 2'b10;
	localparam RESP_DECERR = 2'b11;

	typedef logic [ADDR_WIDTH - 1 : 0] addr_t;
	typedef logic [DATA_WIDTH - 1 : 0] data_t;
	typedef logic [STRB_WIDTH - 1 : 0] strb_t;
	typedef logic [1 : 0] resp_t;


	// Read Address Channel
	typedef struct packed {
		addr_t addr;
		logic valid;
		logic ready;
	} ar_chan_t;

	// Read Data Channel
	typedef struct packed {
		data_t data;
		resp_t resp;
		logic valid;
		logic ready;
	} r_chan_t;

	// Write Address Channel
	typedef struct packed {
		addr_t addr;
		logic valid;
		logic ready;
	} aw_chan_t;

	// Write Data Channel
	typedef struct packed {
		data_t data;
		strb_t strb;
		logic valid;
		logic ready;
	} w_chan_t;

	// Write Response Channel
	typedef struct packed {
		resp_t resp;
		logic valid;
		logic ready;
	} b_chan_t;


	typedef struct packed {
		ar_chan_t ar;
		r_chan_t r;
		aw_chan_t aw;
		w_chan_t w;
		b_chan_t b;
	} axi_lite_bus_t;


endpackage    
import axi_lite_pkg::*;
module axi_lite_slave (
    dut_if s_axi_lite
);

  typedef enum logic [2:0] {IDLE, RADDR, RDATA, WADDR, WDATA, WRESP} state_type;
  state_type state, next_state;

  addr_t addr;
  data_t buffer[0:31];

  // ----------------------------
  // READ ADDRESS CHANNEL
  // ----------------------------
  assign s_axi_lite.ARREADY = (state == RADDR);

  // ----------------------------
  // READ DATA CHANNEL
  // ----------------------------
  assign s_axi_lite.RDATA  =
      (state == RDATA) ? buffer[addr[6:2]] : 32'h0;

  assign s_axi_lite.RRESP  = RESP_OKAY;
  assign s_axi_lite.RVALID = (state == RDATA);

  // ----------------------------
  // WRITE ADDRESS CHANNEL
  // ----------------------------
  assign s_axi_lite.AWREADY = (state == WADDR);

  // ----------------------------
  // WRITE DATA CHANNEL
  // ----------------------------
  assign s_axi_lite.WREADY = (state == WDATA);

  // ----------------------------
  // WRITE RESPONSE CHANNEL
  // ----------------------------
  assign s_axi_lite.BVALID = (state == WRESP);
  assign s_axi_lite.BRESP = RESP_OKAY;

  // ----------------------------
  // ADDRESS LATCH (FIXED)
  // ----------------------------
  always_ff @(posedge s_axi_lite.ACLK) begin
    if (!s_axi_lite.ARESETN) begin
      addr <= '0;
    end else begin
      case (state)
        RADDR : addr <= s_axi_lite.ARADDR;
        WADDR : addr <= s_axi_lite.AWADDR;
        default: addr <= addr;   // ? HOLD ADDRESS (FIX)
      endcase
    end
  end

  // ----------------------------
  // WRITE DATA STORAGE (FIXED)
  // ----------------------------
  always_ff @(posedge s_axi_lite.ACLK) begin
    if (!s_axi_lite.ARESETN) begin
      for (int i = 0; i < 32; i++)
        buffer[i] <= 32'h0;
    end else begin
      if (state == WDATA)
        buffer[addr[6:2]] <= s_axi_lite.WDATA;  // ? SAME DECODE AS READ
    end
  end

  // ----------------------------
  // FSM NEXT STATE
  // ----------------------------
  always_comb begin
    next_state = state;
    case (state)
      IDLE  : next_state = s_axi_lite.ARVALID ? RADDR :
                           s_axi_lite.AWVALID ? WADDR : IDLE;

      RADDR : if (s_axi_lite.ARVALID && s_axi_lite.ARREADY)
                next_state = RDATA;

      RDATA : if (s_axi_lite.RVALID && s_axi_lite.RREADY)
                next_state = IDLE;

      WADDR : if (s_axi_lite.AWVALID && s_axi_lite.AWREADY)
                next_state = WDATA;

      WDATA : if (s_axi_lite.WVALID && s_axi_lite.WREADY)
                next_state = WRESP;

      WRESP : if (s_axi_lite.BVALID && s_axi_lite.BREADY)
                next_state = IDLE;
    endcase
  end

  // ----------------------------
  // FSM STATE REGISTER
  // ----------------------------
  always_ff @(posedge s_axi_lite.ACLK) begin
    if (!s_axi_lite.ARESETN)
      state <= IDLE;
    else
      state <= next_state;
  end

endmodule

