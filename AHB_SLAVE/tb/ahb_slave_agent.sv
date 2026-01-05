class ahb_slave_agent extends uvm_agent;
  `uvm_component_utils(ahb_slave_agent)

  ahb_slave_driver  drv;
  ahb_slave_monitor mon;
  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    drv = ahb_slave_driver ::type_id::create("drv",this);
    mon = ahb_slave_monitor::type_id::create("mon",this);
  endfunction
endclass

