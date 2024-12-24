class apb_agent_config extends uvm_object;
  `uvm_object_utils(apb_agent_config)
  
  uvm_active_passive_enum is_active=UVM_ACTIVE;
  virtual apb_if vif;
  static int apb_drv_data_count=0;
  static int apb_mon_data_count=0;
 
 function new(string name="apb_agent_config");
  super.new(name);
endfunction

endclass

