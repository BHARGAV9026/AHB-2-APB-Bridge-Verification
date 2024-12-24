class apb_driver extends uvm_driver #(apb_xtn);
  `uvm_component_utils(apb_driver)
  virtual apb_if.APB_DRV_MP vif;
  apb_agent_config apb_agt_cfg;
  apb_xtn req;
  function new(string name="apb_driver",uvm_component parent);
     super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(apb_agent_config)::get(this,"*","apb_agent_config",apb_agt_cfg))
          `uvm_fatal("APB_AGT_CFG","cannot get apb_agt_cfg in apb_driver class")
    req=apb_xtn::type_id::create("req");
  endfunction
  
  
  function void connect_phase(uvm_phase phase);
   super.connect_phase(phase);
    begin
     vif=apb_agt_cfg.vif;
    end
  endfunction
  
  task run_phase(uvm_phase phase);

    forever
            begin
                  send_to_dut();
            end
  endtask
  
  task send_to_dut();
     
    wait(vif.apb_drv_cb.Penable); 
      
        if(!vif.apb_drv_cb.Pwrite)
             vif.apb_drv_cb.Prdata<={$random};
       else
           vif.apb_drv_cb.Prdata<=32'h0; 
            
         //repeat(1)///////////////////////////////////// Default 2 (write issue 2 writes) 
         @(vif.apb_drv_cb);  // 1 first x issue   
         
        `uvm_info(get_type_name(),$sformatf("Printing from APB_DRIVER: %s",req.sprint()),UVM_LOW)  
        
  endtask
        
 endclass  
