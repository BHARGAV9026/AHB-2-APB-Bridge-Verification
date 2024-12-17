class ahb_agent_top extends uvm_env;
  `uvm_component_utils(ahb_agent_top)
    ahb_agent ahb_agt[];
    env_config env_cfg;
   
  
    function new(string name="ahb_agent",uvm_component parent);
        super.new(name,parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
    
      env_cfg= env_config::type_id::create("env_cfg",this);
      
      if(!uvm_config_db#(env_config)::get(this,"*","env_config",env_cfg))
       `uvm_fatal("ENV_CONFIG","cannot get env_cfg in ahb_agt_top class")
       
      ahb_agt=new[env_cfg.no_of_ahb_agts];
      
     
      foreach(ahb_agt[i])
      begin
      ahb_agt[i]=ahb_agent::type_id::create($sformatf("ahb_agt[%0d]",i),this);
      end
      
      
    endfunction
    
 endclass
  