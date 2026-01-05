class ahb_scoreboard extends uvm_component;
  `uvm_component_utils(ahb_scoreboard)

  // --------------------------------------------------
  // Analysis implementation
  // --------------------------------------------------
  uvm_analysis_imp #(ahb_txn, ahb_scoreboard) imp;

  // --------------------------------------------------
  // Reference memory model (256 x 32-bit words)
  // --------------------------------------------------
  bit [31:0] ref_mem [0:255];

  int error_count;
  string report_str;
  string status;
  // --------------------------------------------------
  // Constructor
  // --------------------------------------------------
  function new(string name, uvm_component parent);
    super.new(name, parent);
    imp = new("imp", this);
    error_count = 0;
  endfunction

  // --------------------------------------------------
  // BUILD PHASE
  // --------------------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    `uvm_info(get_type_name(),
              $sformatf("Build phase started for %s", get_full_name()),
              UVM_LOW)

    foreach (ref_mem[i])
      ref_mem[i] = 32'h0;
  endfunction

  // --------------------------------------------------
  // CONNECT PHASE
  // --------------------------------------------------
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    `uvm_info(get_type_name(),
              $sformatf("Connect phase executed for %s", get_full_name()),
              UVM_LOW)
  endfunction

  // --------------------------------------------------
  // RUN PHASE
  // --------------------------------------------------
  task run_phase(uvm_phase phase);
    `uvm_info(get_type_name(),
              $sformatf("Run phase started for %s", get_full_name()),
              UVM_LOW)
  endtask

  // --------------------------------------------------
  // WRITE METHOD (Scoreboard checking)
  // --------------------------------------------------
  function void write(ahb_txn tr);

    if (tr.write) begin
      ref_mem[tr.addr[9:2]] = tr.data;

      `uvm_info(get_type_name(),
                $sformatf("WRITE | Addr: 0x%08h | Data: 0x%08h",
                          tr.addr, tr.data),
                UVM_MEDIUM)
    end
    else begin
      if (ref_mem[tr.addr[9:2]] !== tr.data) begin
        error_count++;

        `uvm_error(get_type_name(),
                   $sformatf("READ MISMATCH | Addr: 0x%08h | Expected: 0x%08h | Actual: 0x%08h",
                             tr.addr,
                             ref_mem[tr.addr[9:2]],
                             tr.data))
      end
      else begin
        `uvm_info(get_type_name(),
                  $sformatf("READ PASS | Addr: 0x%08h | Data: 0x%08h",
                            tr.addr, tr.data),
                  UVM_MEDIUM)
      end
    end
  endfunction

  // --------------------------------------------------
  // CHECK PHASE
  // --------------------------------------------------
  function void check_phase(uvm_phase phase);
    super.check_phase(phase);

    `uvm_info(get_type_name(),
              $sformatf("Check phase executed for %s", get_full_name()),
              UVM_LOW)
  endfunction

  // --------------------------------------------------
  // REPORT PHASE
  // --------------------------------------------------
  function void report_phase(uvm_phase phase);
  super.report_phase(phase);

  

  status = (error_count == 0) ? "PASS" : "FAIL";

  report_str = {
    "\n============================================================\n",
    "                AHB SCOREBOARD FINAL REPORT\n",
    "============================================================\n",
    $sformatf(" Component      : %s\n", get_full_name()),
    $sformatf(" Final Status   : %s\n", status),
    $sformatf(" Total Errors   : %0d\n", error_count),
    (error_count == 0) ?
      " Result         : All AHB read/write checks PASSED\n" :
      " Result         : One or more AHB read checks FAILED\n",
    "============================================================\n"
  };

  `uvm_info(get_type_name(), report_str, UVM_LOW)
endfunction


  
  

    

endclass

