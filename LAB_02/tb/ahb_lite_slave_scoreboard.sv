//------------------------------------------------------------------------------
// AHB-Lite Slave Scoreboard
//------------------------------------------------------------------------------
import uvm_pkg::*;
`include "uvm_macros.svh"

class ahb_lite_slave_scoreboard extends uvm_scoreboard;

  `uvm_component_utils(ahb_lite_slave_scoreboard)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

endclass

