class env extends uvm_env;
 `uvm_component_utils(env)
  ahb_agent_top  ahb_agt_top;
  apb_agent_top  apb_agt_top;
  scoreboard  sbh;
  virtual_sequencer v_sequencer;
  env_config env_cfg;
  
  function new(string name="env",uvm_component parent);
     super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
     env_cfg= env_config::type_id::create("env_cfg",this);
     if(!uvm_config_db#(env_config)::get(this,"*","env_config",env_cfg))
       `uvm_fatal("ENV_CONFIG","cannot get env_cfg in env class")
 
       
     if(env_cfg.has_ahb_agent==1)
       ahb_agt_top=ahb_agent_top::type_id::create("ahb_agt_top",this);
       
      if(env_cfg.has_apb_agent==1)
       apb_agt_top=apb_agent_top::type_id::create("apb_agt_top",this);
       
       if(env_cfg.has_sb==1)
         sbh = scoreboard::type_id::create("sbh",this);
         
      if(env_cfg.has_virtual_seqr)
         v_sequencer=virtual_sequencer::type_id::create("v_sequencer",this);
       
  endfunction
  
  function void connect_phase(uvm_phase phase);
  
   foreach(v_sequencer.ahb_vseqrh[i])
   begin
      v_sequencer.ahb_vseqrh[i]=ahb_agt_top.ahb_agt[i].ahb_seqrh;
   end
    
   foreach(v_sequencer.apb_vseqrh[i])
    begin
      v_sequencer.apb_vseqrh[i]=apb_agt_top.apb_agt[i].apb_seqrh;
    end 
    
    foreach(ahb_agt_top.ahb_agt[i])
    begin
      ahb_agt_top.ahb_agt[i].ahb_monh.ahb_ap.connect(sbh.ahb_fifo.analysis_export);
    end
    
   foreach(apb_agt_top.apb_agt[i])
    begin
      apb_agt_top.apb_agt[i].apb_monh.apb_ap.connect(sbh.apb_fifo.analysis_export);
    end
   
  endfunction
  
 endclass
       
