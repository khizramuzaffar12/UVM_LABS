interface dut_if(input bit ACLK);
  //----------------------------------------
  //    Declaring Interface of AXI4-Lite
  //----------------------------------------
    
//   logic ACLK;
  logic ARESETN;
  // 1. Write Address Channel
  logic AWVALID;
  logic AWREADY;
  logic [2:0] AWPROT;
  logic [31:0] AWADDR;
  // 2. Write Data Channel
  logic WVALID;
  logic WREADY;
  logic [31:0] WDATA;
  logic [3:0] WSTRB;
  // 3. Write Response Channel
  logic BVALID;
  logic BREADY;
  logic [1:0] BRESP;
  // 4. Read Address Channel
  logic ARVALID;
  logic ARREADY;
  logic [2:0] ARPROT; 
  logic [31:0] ARADDR;
  // 5. Read Data Channel
  logic RVALID;
  logic RREADY;
  logic [1:0] RRESP;
  logic [31:0] RDATA;
  
  // Clocking block for Master Agent Driver 
  clocking m_driver_cb @(posedge ACLK);
    output AWADDR, AWVALID,AWPROT,WDATA,WSTRB,WVALID,BREADY,
    ARADDR,ARPROT,ARVALID,RREADY;
    input  AWREADY,WREADY,BRESP,BVALID,ARREADY,RDATA,RRESP,RVALID;
  endclocking
  
  // Clocking block for Master Active Agent Monitor
  clocking monitor_cb @(posedge ACLK);
    input  AWADDR,AWVALID,AWPROT,WDATA,WSTRB,WVALID,BREADY,ARADDR,ARPROT,
    ARVALID,RREADY,AWREADY,WREADY,BRESP,BVALID,ARREADY,RDATA,RRESP,RVALID; 
  endclocking
  
  endinterface
  
