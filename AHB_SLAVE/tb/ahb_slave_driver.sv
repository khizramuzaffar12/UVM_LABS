class ahb_slave_driver extends uvm_driver #(ahb_slave_txn);
  `uvm_component_utils(ahb_slave_driver)

  virtual ahb_lite_bus_if vif;
  bit [31:0] mem [0:255];
function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction
  function void build_phase(uvm_phase phase);
    if (!uvm_config_db#(virtual ahb_lite_bus_if)::get(this,"","vif",vif))
      `uvm_fatal("NOVIF","Interface not found")
  endfunction

  task run_phase(uvm_phase phase);
    vif.HREADYOUT = 1;
    vif.HRESP     = 0;
    vif.HRDATA    = 0;

    forever begin
      @(posedge vif.HCLK);
      if (!vif.HRESETn) begin
        vif.HREADYOUT = 1;
        continue;
      end

      if (vif.HTRANS == 2'b10) begin
        vif.HREADYOUT = 0;

        if (vif.HWRITE) begin
          mem[vif.HADDR[9:2]] = vif.HWDATA;
          @(posedge vif.HCLK);
          vif.HREADYOUT = 1;
        end else begin
          @(posedge vif.HCLK);
          vif.HRDATA    = mem[vif.HADDR[9:2]];
          vif.HREADYOUT = 1;
        end
      end
    end
  endtask
endclass

