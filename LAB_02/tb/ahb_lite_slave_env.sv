//------------------------------------------------------------------------------
// AHB-Lite Slave Environment
//------------------------------------------------------------------------------
import uvm_pkg::*;
`include "uvm_macros.svh"

class ahb_lite_slave_env extends uvm_env;

  `uvm_component_utils(ahb_lite_slave_env)

  ahb_lite_slave_agent      agent;
  ahb_lite_slave_scoreboard sb;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    agent = ahb_lite_slave_agent     ::type_id::create("agent", this);
    sb    = ahb_lite_slave_scoreboard::type_id::create("sb",    this);
  endfunction

endclass

