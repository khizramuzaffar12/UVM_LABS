class ahb_slave_monitor extends uvm_monitor;
  `uvm_component_utils(ahb_slave_monitor)

  virtual ahb_lite_bus_if vif;
  uvm_analysis_port #(ahb_slave_txn) ap;

  function new(string name, uvm_component parent);
    super.new(name,parent);
    ap = new("ap",this);
  endfunction

  function void build_phase(uvm_phase phase);
    if (!uvm_config_db#(virtual ahb_lite_bus_if)::get(this,"","vif",vif))
      `uvm_fatal("NOVIF","Interface not found")
  endfunction

  task run_phase(uvm_phase phase);
    ahb_slave_txn tr;
    forever begin
      wait(vif.HREADYOUT == 0);
      if (vif.HTRANS == 2'b10 ) begin
        tr = ahb_slave_txn::type_id::create("tr");
        tr.addr  = vif.HADDR;
        tr.write = vif.HWRITE;
        tr.wdata = vif.HWDATA;
        wait(vif.HREADYOUT == 1);
        tr.rdata = vif.HRDATA;
        ap.write(tr);
      end
    end
  endtask
endclass

