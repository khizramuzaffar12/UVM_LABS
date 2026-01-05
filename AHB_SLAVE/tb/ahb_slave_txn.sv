import uvm_pkg::*;
  `include "uvm_macros.svh"
class ahb_slave_txn extends uvm_sequence_item;
  bit        write;
  bit [31:0] addr;
  bit [31:0] wdata;
  bit [31:0] rdata;

  `uvm_object_utils(ahb_slave_txn)

  function new(string name="ahb_slave_txn");
    super.new(name);
  endfunction
endclass

