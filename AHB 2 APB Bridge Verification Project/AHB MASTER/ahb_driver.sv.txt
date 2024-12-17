class ahb_driver extends uvm_driver #(ahb_xtn);
  `uvm_component_utils(ahb_driver)
  virtual ahb_if.AHB_DRV_MP vif;
  ahb_agent_config ahb_agt_cfg;
  
  function new(string name="ahb_driver",uvm_component parent);
     super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(ahb_agent_config)::get(this,"*","ahb_agent_config",ahb_agt_cfg))
          `uvm_fatal("AHB_AGT_CFG","cannot get ahb_agt_cfg in ahb_driver class")
  endfunction
  
  
  function void connect_phase(uvm_phase phase);
     vif=ahb_agt_cfg.vif;
  endfunction
  
  task run_phase(uvm_phase phase);
        
         @(vif.ahb_drv_cb);
         vif.ahb_drv_cb.Hresetn<=1'b0;
         
         @(vif.ahb_drv_cb);
         vif.ahb_drv_cb.Hresetn<=1'b1;
         
       forever 
         begin
           
            seq_item_port.get_next_item(req);
            send_to_dut(req);
            seq_item_port.item_done();
            
         end
  endtask
  
  task send_to_dut(ahb_xtn req);
   
    wait(vif.ahb_drv_cb.Hreadyout);
    //Address Phase Signals
    vif.ahb_drv_cb.Htrans<=req.Htrans;
    vif.ahb_drv_cb.Hsize<=req.Hsize;
    vif.ahb_drv_cb.Haddr<=req.Haddr;
    vif.ahb_drv_cb.Hwrite<=req.Hwrite;
    vif.ahb_drv_cb.Hreadyin<=1'b1;
    
    @(vif.ahb_drv_cb); // After 1 clk send HWdata
      
    //Data Phase Signals
    wait(vif.ahb_drv_cb.Hreadyout); //wait for HREADYOUT to send other datas

    if(vif.ahb_drv_cb.Hwrite)
      vif.ahb_drv_cb.Hwdata<=req.Hwdata;
    
      `uvm_info(get_type_name(),$sformatf("Printing from AHB_DRIVER: %s",req.sprint()),UVM_LOW)
      
     // repeat(0)//////////////////////////////// Default 2 (write issue 2 writes)
     // @(vif.ahb_drv_cb);                   //  1 works write 2 times first
  endtask

 endclass  
