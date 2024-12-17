class env_config extends uvm_object;
  `uvm_object_utils(env_config)
   bit has_ahb_agent=1;
   bit has_apb_agent=1;
   bit no_of_ahb_agts=1;
   bit no_of_apb_agts=1;
  bit has_sb=1;
  bit has_virtual_seqr=1;
  
 ahb_agent_config ahb_agt_cfg;
 apb_agent_config apb_agt_cfg;

 function new(string name="env_config");
    super.new(name);
 endfunction

endclass
