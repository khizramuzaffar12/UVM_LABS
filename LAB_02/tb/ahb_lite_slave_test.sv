//------------------------------------------------------------------------------
// AHB-Lite Slave Test
//------------------------------------------------------------------------------

import uvm_pkg::*;
`include "uvm_macros.svh"

class ahb_lite_slave_test extends uvm_test;

  `uvm_component_utils(ahb_lite_slave_test)

  ahb_lite_slave_env env;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = ahb_lite_slave_env::type_id::create("env", this);
  endfunction

  function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    uvm_top.print_topology();
  endfunction

endclass

