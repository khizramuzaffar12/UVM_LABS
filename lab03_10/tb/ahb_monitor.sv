class ahb_monitor extends uvm_monitor;
  `uvm_component_utils(ahb_monitor)

  virtual ahb_lite_bus_if vif;
  uvm_analysis_port #(ahb_txn) ap;

  // --------------------------------------------------
  // Constructor
  // --------------------------------------------------
  function new(string name, uvm_component parent);
    super.new(name,parent);
    ap = new("ap", this);
  endfunction

  // --------------------------------------------------
  // Build Phase
  // --------------------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    `uvm_info(get_type_name(),
              $sformatf("BUILD PHASE started for %s", get_full_name()),
              UVM_LOW)

    if (!uvm_config_db#(virtual ahb_lite_bus_if)::get(this,"","vif",vif))
      `uvm_fatal("NOVIF","No interface assigned to monitor")
  endfunction

  // --------------------------------------------------
  // Run Phase
  // --------------------------------------------------
  task run_phase(uvm_phase phase);
    ahb_txn tr;

    `uvm_info(get_type_name(),
              $sformatf("RUN PHASE started for %s", get_full_name()),
              UVM_LOW)

    forever begin
      @(posedge vif.HCLK);  // sample every clock

      if (vif.HTRANS == 2'b10) begin
        tr = ahb_txn::type_id::create("tr");
        tr.addr  = vif.HADDR;
        tr.write = vif.HWRITE;

        if (tr.write)
          tr.data = vif.HWDATA;
        else begin
          wait(vif.HREADYOUT);  // wait for read data
          tr.data = vif.HRDATA;
        end

        // -----------------------------
        // Print transaction using sprint()
        // -----------------------------
        `uvm_info(get_type_name(),
                  $sformatf("INSIDE AHB MONITOR : %s", tr.sprint()),
                  UVM_MEDIUM)

        // Send to scoreboard
        ap.write(tr);
      end
    end
  endtask

endclass

