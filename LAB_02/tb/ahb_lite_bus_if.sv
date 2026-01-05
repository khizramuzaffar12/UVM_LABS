//============================================================
// AHB-Lite Interface 
//============================================================
import uvm_pkg::*;
`include "uvm_macros.svh"

interface ahb_lite_bus_if;
logic HCLK;
logic HRESETn;
logic [31:0] HADDR;
logic HWRITE;
logic [2:0] HSIZE;
logic [2:0] HBURST;
logic [3:0] HPROT;
logic [1:0] HTRANS;
logic HREADY;
logic [31:0] HWDATA;
logic [31:0] HRDATA;
logic HREADYOUT;
logic [1:0] HRESP;
endinterface
