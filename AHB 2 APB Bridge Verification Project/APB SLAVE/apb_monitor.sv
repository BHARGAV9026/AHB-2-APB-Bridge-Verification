class apb_monitor extends uvm_monitor;
  `uvm_component_utils(apb_monitor)
  virtual apb_if.APB_MON_MP vif;
  uvm_analysis_port #(apb_xtn) apb_ap;
  apb_agent_config apb_agt_cfg;
  apb_xtn xtn;
  
  function new(string name="apb_monitor",uvm_component parent);
     super.new(name,parent);
     apb_ap=new("apb_ap",this);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    //xtn=apb_xtn::type_id::create("xtn");
    if(!uvm_config_db#(apb_agent_config)::get(this,"*","apb_agent_config",apb_agt_cfg))
          `uvm_fatal("APB_AGT_CFG","cannot get apb_agt_cfg in apb_monitor class")
  endfunction
  
  
  function void connect_phase(uvm_phase phase);
     super.connect_phase(phase);
     vif=apb_agt_cfg.vif;
  endfunction
  
  
  task run_phase(uvm_phase phase);

  forever
    begin
       collect_data();
    end
  endtask
  
  task collect_data();
    
   xtn=apb_xtn::type_id::create("xtn");
   wait(vif.apb_mon_cb.Penable);
    if(vif.apb_mon_cb.Pselx)
      begin
            xtn.Pselx=vif.apb_mon_cb.Pselx;
            xtn.Pwrite=vif.apb_mon_cb.Pwrite;
            xtn.Paddr=vif.apb_mon_cb.Paddr;
 

         if(vif.apb_mon_cb.Pwrite)
              xtn.Pwdata=vif.apb_mon_cb.Pwdata;
         else
              xtn.Prdata=vif.apb_mon_cb.Prdata;
      
         `uvm_info(get_type_name(),$sformatf("Printing from APB_MONITOR: %s",xtn.sprint()),UVM_LOW)
     end
     
        //repeat(1)
         @(vif.apb_mon_cb);
    
       apb_ap.write(xtn);
      
    endtask
  
endclass
   
  
   
