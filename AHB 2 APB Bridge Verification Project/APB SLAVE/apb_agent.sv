class apb_agent extends uvm_component;
  `uvm_component_utils(apb_agent)
  
   apb_driver apb_drvh;
   apb_monitor apb_monh;
   apb_sequencer apb_seqrh;
   apb_agent_config apb_agt_cfg;
  

   function new(string name="apb_agent",uvm_component parent);
       super.new(name,parent);
   endfunction
   
   function void build_phase(uvm_phase phase);
    
       apb_agt_cfg=apb_agent_config::type_id::create("apb_agt_cfg");
   
       if(!uvm_config_db#(apb_agent_config)::get(this,"*","apb_agent_config",apb_agt_cfg))
          `uvm_fatal("APB_AGT_CFG","cannot get apb_agt_cfg in apb_agent class")
       apb_monh=apb_monitor::type_id::create("apb_monh",this);
       
       if(apb_agt_cfg.is_active==UVM_ACTIVE)
         begin
           apb_drvh=apb_driver::type_id::create("apb_drvh",this);
           apb_seqrh=apb_sequencer::type_id::create("apb_seqrh",this);
         end
         
   endfunction
   
   function void connect_phase(uvm_phase phase);
     if(apb_agt_cfg.is_active==UVM_ACTIVE)
       begin
           apb_drvh.seq_item_port.connect(apb_seqrh.seq_item_export);
       end
   endfunction
   
endclass
