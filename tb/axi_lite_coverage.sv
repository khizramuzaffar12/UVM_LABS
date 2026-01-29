//=============================================================
// File: axi_lite_coverage.sv
// Functional coverage for AXI4-Lite
//=============================================================

`include "uvm_macros.svh"
import uvm_pkg::*;
import axi4lite_pkg::*; // Import only the package containing seq_item

class axi_lite_coverage extends uvm_subscriber #(axi4lite_master_seq_item);

  `uvm_component_utils(axi_lite_coverage)

  // Covergroups
  covergroup cg_aw; option.per_instance=1;
    coverpoint tr.awaddr;
    coverpoint tr.awprot;
    coverpoint tr.awvalid;
    coverpoint tr.awready;
  endgroup

  covergroup cg_w; option.per_instance=1;
    coverpoint tr.wdata;
    coverpoint tr.wstrb;
    coverpoint tr.wvalid;
    coverpoint tr.wready;
  endgroup

  covergroup cg_b; option.per_instance=1;
    coverpoint tr.bresp;
    coverpoint tr.bvalid;
    coverpoint tr.bready;
  endgroup

  covergroup cg_ar; option.per_instance=1;
    coverpoint tr.araddr;
    coverpoint tr.arprot;
    coverpoint tr.arvalid;
    coverpoint tr.arready;
  endgroup

  covergroup cg_r; option.per_instance=1;
    coverpoint tr.rdata;
    coverpoint tr.rresp;
    coverpoint tr.rvalid;
    coverpoint tr.rready;
  endgroup

  function new(string name="axi_lite_coverage", uvm_component parent=null);
    super.new(name,parent);
  endfunction

  virtual function void write(axi4lite_master_seq_item tr);
    cg_aw = new;
    cg_w  = new;
    cg_b  = new;
    cg_ar = new;
    cg_r  = new;

    cg_aw.sample();
    cg_w.sample();
    cg_b.sample();
    cg_ar.sample();
    cg_r.sample();
  endfunction

endclass

