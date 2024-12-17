class ahb_agent extends uvm_component;
  `uvm_component_utils(ahb_agent)
  
   ahb_driver ahb_drvh;
   ahb_monitor ahb_monh;
   ahb_sequencer ahb_seqrh;
   ahb_agent_config ahb_agt_cfg;
  

   function new(string name="ahb_agent",uvm_component parent);
       super.new(name,parent);
   endfunction
   
   function void build_phase(uvm_phase phase);
    
       ahb_agt_cfg=ahb_agent_config::type_id::create("ahb_agt_cfg");
   
       if(!uvm_config_db#(ahb_agent_config)::get(this,"*","ahb_agent_config",ahb_agt_cfg))
          `uvm_fatal("AHB_AGT_CFG","cannot get ahb_agt_cfg in ahb_agent class")
       ahb_monh=ahb_monitor::type_id::create("ahb_monh",this);
       
       if(ahb_agt_cfg.is_active==UVM_ACTIVE)
         begin
           ahb_drvh=ahb_driver::type_id::create("ahb_drvh",this);
           ahb_seqrh=ahb_sequencer::type_id::create("ahb_seqrh",this);
         end
         
   endfunction
   
   function void connect_phase(uvm_phase phase);
     if(ahb_agt_cfg.is_active==UVM_ACTIVE)
       begin
           ahb_drvh.seq_item_port.connect(ahb_seqrh.seq_item_export);
       end
   endfunction
   
endclass