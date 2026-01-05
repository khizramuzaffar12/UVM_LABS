//------------------------------------------------------------------------------
// AHB-Lite Slave Monitor
//------------------------------------------------------------------------------
import uvm_pkg::*;
`include "uvm_macros.svh"

class ahb_lite_slave_monitor extends uvm_monitor;

  `uvm_component_utils(ahb_lite_slave_monitor)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

endclass

