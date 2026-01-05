//------------------------------------------------------------------------------
// AHB-Lite Slave Driver
//------------------------------------------------------------------------------
import uvm_pkg::*;
`include "uvm_macros.svh"

class ahb_lite_slave_driver extends uvm_driver #(ahb_lite_slave_trans);

  `uvm_component_utils(ahb_lite_slave_driver)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

endclass

