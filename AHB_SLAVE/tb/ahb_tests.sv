// ------------------------------------------------------
// AHB Slave Tests (Single File)
// ------------------------------------------------------

class ahb_base_test extends uvm_test;
  `uvm_component_utils(ahb_base_test)

  ahb_slave_env env;
  virtual ahb_lite_bus_if vif;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = ahb_slave_env::type_id::create("env", this);

    if (!uvm_config_db#(virtual ahb_lite_bus_if)::get(this,"","vif",vif))
      `uvm_fatal("NOVIF","Virtual interface not found")
  endfunction
endclass

// ------------------------------------------------------
// 1) Write _ Read Test
// ------------------------------------------------------
class ahb_write_read_test extends ahb_base_test;
  `uvm_component_utils(ahb_write_read_test)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);

    top.master.ahb_write(32'h10, 32'hDEADBEEF);
    top.master.ahb_read (32'h10);

    #20;
    phase.drop_objection(this);
  endtask
endclass

// ------------------------------------------------------
// 2) Single Write Test
// ------------------------------------------------------
class ahb_single_write_test extends ahb_base_test;
  `uvm_component_utils(ahb_single_write_test)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);

    top.master.ahb_write(32'h20, 32'hA5A5A5A5);

    #20;
    phase.drop_objection(this);
  endtask
endclass

// ------------------------------------------------------
// 3) Multiple Writes Test
// ------------------------------------------------------
class ahb_multi_write_test extends ahb_base_test;
  `uvm_component_utils(ahb_multi_write_test)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);

    for (int i = 0; i < 8; i++) begin
      top.master.ahb_write(i*4, 32'h1000 + i);
    end

    #20;
    phase.drop_objection(this);
  endtask
endclass

// ------------------------------------------------------
// 4) Multiple Write _ Read Back Test
// ------------------------------------------------------
class ahb_multi_write_read_test extends ahb_base_test;
  `uvm_component_utils(ahb_multi_write_read_test)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);

    for (int i = 0; i < 8; i++) begin
      top.master.ahb_write(i*4, 32'hABCD_0000 + i);
    end

    for (int i = 0; i < 8; i++) begin
      top.master.ahb_read(i*4);
    end

    #20;
    phase.drop_objection(this);
  endtask
endclass

// ------------------------------------------------------
// 5) Reset Behavior Test
// ------------------------------------------------------
class ahb_reset_test extends ahb_base_test;
  `uvm_component_utils(ahb_reset_test)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);

    top.master.ahb_write(32'h40, 32'hDEAD_BEEF);

    // Apply reset
    vif.HRESETn = 0;
    #20;
    vif.HRESETn = 1;

    // Read after reset
    top.master.ahb_read(32'h40);

    #20;
    phase.drop_objection(this);
  endtask
endclass

// ------------------------------------------------------
// 6) Random Read / Write Test
// ------------------------------------------------------
class ahb_random_test extends ahb_base_test;
  `uvm_component_utils(ahb_random_test)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);

    repeat (20) begin
      bit [31:0] addr;
      bit [31:0] data;

      addr = ($urandom % 256) * 4;
      data = $urandom;

      top.master.ahb_write(addr, data);
      top.master.ahb_read (addr);
    end

    #20;
    phase.drop_objection(this);
  endtask
endclass
