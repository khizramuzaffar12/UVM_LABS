class ahb_agent extends uvm_agent;
  `uvm_component_utils(ahb_agent)

  ahb_driver    drv;
  ahb_monitor   mon;
  ahb_sequencer seqr;
  function new(string name, uvm_component parent);
  super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    drv  = ahb_driver   ::type_id::create("drv",this);
    mon  = ahb_monitor  ::type_id::create("mon",this);
    seqr = ahb_sequencer::type_id::create("seqr",this);
  endfunction

  function void connect_phase(uvm_phase phase);
    drv.seq_item_port.connect(seqr.seq_item_export);
  endfunction
endclass

