//------------------------------------------------------------------------------
// AHB-Lite Slave Agent
//------------------------------------------------------------------------------
import uvm_pkg::*;
`include "uvm_macros.svh"

class ahb_lite_slave_agent extends uvm_agent;

  `uvm_component_utils(ahb_lite_slave_agent)

  ahb_lite_slave_driver    drv;
  ahb_lite_slave_monitor   mon;
  ahb_lite_slave_sequencer seqr;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    drv  = ahb_lite_slave_driver   ::type_id::create("drv",  this);
    mon  = ahb_lite_slave_monitor  ::type_id::create("mon",  this);
    seqr = ahb_lite_slave_sequencer::type_id::create("seqr", this);
  endfunction

endclass

