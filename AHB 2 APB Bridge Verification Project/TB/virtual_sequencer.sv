class virtual_sequencer extends uvm_sequencer #(uvm_sequence_item);
   `uvm_component_utils(virtual_sequencer)
  ahb_sequencer ahb_vseqrh[];
  apb_sequencer apb_vseqrh[];
  env_config env_cfg;
  
  function new(string name="virtual_sequencer",uvm_component parent);
       super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
     super.build_phase(phase);
     
     env_cfg= env_config::type_id::create("env_cfg",this);
     
     if(!uvm_config_db#(env_config)::get(this,"*","env_config",env_cfg))
       `uvm_fatal("ENV_CONFIG","cannot get env_cfg in env class")
       
     ahb_vseqrh=new[env_cfg.no_of_ahb_agts];
     apb_vseqrh=new[env_cfg.no_of_apb_agts];
        
  endfunction
  
endclass
