package axi4lite_pkg;

  import uvm_pkg::*;
  `include "uvm_macros.svh"

  // Include all files  
  `include "axi4lite_master_seq_item.sv"
  `include "axi4lite_master_seq.sv"
  `include "axi4lite_master_seqr.sv"
  `include "axi4lite_master_driver.sv"
  `include "axi4lite_master_monitor.sv"
  `include "axi4lite_master_agent.sv"
  `include "axi4lite_master_scoreboard.sv"
  `include "axi4lite_master_env.sv"
  `include "axi4lite_master_test.sv"

endpackage : axi4lite_pkg

