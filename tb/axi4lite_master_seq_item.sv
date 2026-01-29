//---------------------------------------------------------------
//        axi4lite_seq  
//---------------------------------------------------------------

class axi4lite_seq extends uvm_sequence_item;
    
  // Write Address Channel
  rand logic AWVALID;
  rand logic [31:0] AWADDR;
  logic AWREADY;
  
  // Write Data Channel
  rand logic WVALID;
  rand logic [31:0] WDATA;
  rand logic [3:0] WSTRB;
  logic WREADY;
  
  // Write Response Channel
  logic BRESP;
  logic BVALID;
  
  // Read Address Channel
  rand logic ARVALID; 
  rand logic [31:0] ARADDR;
  logic ARREADY;
  
  // Read Data Channel
  rand logic RREADY;
  logic RVALID;
  logic [1:0] RRESP;
  rand logic [31:0] RDATA;

  //---------------------------------------
  //Utility and Field macros
  //---------------------------------------
  
  `uvm_object_utils_begin(axi4lite_seq)
  
    `uvm_field_int(AWADDR,UVM_ALL_ON)
    `uvm_field_int(BRESP,UVM_ALL_ON)
    `uvm_field_int(BVALID,UVM_ALL_ON)
    `uvm_field_int(AWVALID,UVM_ALL_ON)
    `uvm_field_int(WDATA,UVM_ALL_ON)
    `uvm_field_int(WSTRB,UVM_ALL_ON)
    `uvm_field_int(WVALID,UVM_ALL_ON)
    `uvm_field_int(ARADDR,UVM_ALL_ON)
    `uvm_field_int(ARVALID,UVM_ALL_ON)
    `uvm_field_int(RVALID,UVM_ALL_ON)
  `uvm_object_utils_end

  //--------------------------------------------------
  //     Constructor
  //--------------------------------------------------
  function new(string name = "axi4lite_seq");
    super.new(name);
  endfunction

  constraint c4 {ARADDR inside{[32'h00000000:32'h00FFFFFF]};};

  function string wr_convert2string();
    return $psprintf("AWADDR=%0h WSTRB=%0h WDATA=%0h",AWADDR,WSTRB,WDATA);
  endfunction
  
  function string rd_convert2string();
    return $psprintf("ARADDR=%0h RDATA=%0h",ARADDR,RDATA);
  endfunction
    
endclass
