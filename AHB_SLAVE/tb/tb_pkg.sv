package tb_pkg;

  // Import UVM
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  // Include all TB files
  `include "ahb_slave_txn.sv"
  `include "ahb_slave_driver.sv"
  `include "ahb_slave_monitor.sv"
  `include "ahb_slave_scoreboard.sv"
  `include "ahb_slave_agent_env.sv"
  `include "ahb_tests.sv"

endpackage

