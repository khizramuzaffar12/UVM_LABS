`include "uvm_macros.svh"
import uvm_pkg::*;
import axi4lite_pkg::*;
`include "axi_lite_coverage.sv"

class my_env extends uvm_env;

    `uvm_component_utils(my_env);

    master_agent          agt;
    master_scoreboard     scb;
    axi_lite_coverage     axi_cov;     // Coverage subscriber
    virtual dut_if        vif;

    function new(string name, uvm_component parent);
       super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        agt = master_agent::type_id::create("agt", this);
        scb = master_scoreboard::type_id::create("scb", this);
        axi_cov = axi_lite_coverage::type_id::create("axi_cov", this);

        if (!uvm_config_db#(virtual dut_if)::get(this, "", "vif", vif)) begin
            `uvm_fatal("build phase", "No virtual interface specified for this env instance")
        end
        uvm_config_db#(virtual dut_if)::set(this, "agt", "vif", vif);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        // Connect monitor to scoreboard
        agt.mon.mon_ap.connect(scb.mon_export);

        // Connect monitor to coverage
        agt.mon.mon_ap.connect(axi_cov.analysis_export);
    endfunction

endclass

