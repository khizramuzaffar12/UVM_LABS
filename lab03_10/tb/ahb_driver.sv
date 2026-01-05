class ahb_driver extends uvm_driver #(ahb_txn);
  `uvm_component_utils(ahb_driver)

  virtual ahb_lite_bus_if vif;

  // --------------------------------------------------
  // Constructor
  // --------------------------------------------------
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  // --------------------------------------------------
  // BUILD PHASE
  // --------------------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    `uvm_info(get_type_name(),
              $sformatf("BUILD PHASE started for %s", get_full_name()),
              UVM_LOW)

    if (!uvm_config_db#(virtual ahb_lite_bus_if)::get(this,"","vif",vif))
      `uvm_fatal("NOVIF","No interface assigned to driver")
  endfunction

  // --------------------------------------------------
  // RUN PHASE
  // --------------------------------------------------
  task run_phase(uvm_phase phase);
    ahb_txn tr;

    `uvm_info(get_type_name(),
              $sformatf("RUN PHASE started for %s", get_full_name()),
              UVM_LOW)

    forever begin
      // Get next item from sequence
      seq_item_port.get_next_item(tr);

      // -----------------------------
      // Print transaction using sprint()
      // -----------------------------
      `uvm_info(get_type_name(),
                $sformatf("INSIDE AHB DRIVER : %s", tr.sprint()),
                UVM_MEDIUM)

      // -----------------------------
      // Drive the transaction on the interface
      // -----------------------------
      vif.HADDR  = tr.addr;
      vif.HWRITE = tr.write;
      vif.HTRANS = 2'b10;  // NONSEQ
      vif.HSIZE  = 3'b010; // 32-bit
      vif.HWDATA = tr.data;

      // Wait for slave ready
      @(posedge vif.HCLK);
      wait(vif.HREADYOUT == 1);

      // Back to IDLE
      vif.HTRANS = 2'b00;
      @(posedge vif.HCLK);

      // Notify sequence that item is done
      seq_item_port.item_done();
    end
  endtask

endclass

