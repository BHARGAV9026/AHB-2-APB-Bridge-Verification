class ahb_monitor extends uvm_monitor;
  `uvm_component_utils(ahb_monitor)
  virtual ahb_if.AHB_MON_MP vif;
  uvm_analysis_port #(ahb_xtn) ahb_ap;
  ahb_agent_config ahb_agt_cfg;
  ahb_xtn xtn;
  
  function new(string name="ahb_monitor",uvm_component parent);
     super.new(name,parent);
     ahb_ap=new("ahb_ap",this);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
     //xtn=ahb_xtn::type_id::create("xtn");
    if(!uvm_config_db#(ahb_agent_config)::get(this,"*","ahb_agent_config",ahb_agt_cfg))
          `uvm_fatal("AHB_AGT_CFG","cannot get ahb_agt_cfg in ahb_monitor class")
  endfunction
  
  
  function void connect_phase(uvm_phase phase);
     super.connect_phase(phase);
     vif=ahb_agt_cfg.vif;
  endfunction
  
  task run_phase(uvm_phase phase);
    
   forever
     begin
        collect_data();  
     end
     
  endtask
  
  task collect_data();
  
     xtn=ahb_xtn::type_id::create("xtn"); 
                
     wait(vif.ahb_mon_cb.Htrans==2 || vif.ahb_mon_cb.Htrans==3)
         xtn.Haddr=vif.ahb_mon_cb.Haddr; 
         xtn.Hresetn=vif.ahb_mon_cb.Hresetn;
         xtn.Hsize=vif.ahb_mon_cb.Hsize;
         xtn.Htrans=vif.ahb_mon_cb.Htrans;
         xtn.Hreadyin=vif.ahb_mon_cb.Hreadyin;
         xtn.Hwrite=vif.ahb_mon_cb.Hwrite;
         xtn.Hburst=vif.ahb_mon_cb.Hburst;
         
     @(vif.ahb_mon_cb);  
       
     wait(vif.ahb_mon_cb.Hreadyout);
     
        if(vif.ahb_mon_cb.Hwrite)
          begin
           xtn.Hwdata=vif.ahb_mon_cb.Hwdata;
          // @(vif.ahb_mon_cb);
          end
           
        else if(!vif.ahb_mon_cb.Hwrite)
          begin
           // @(vif.ahb_mon_cb);
            xtn.Hrdata=vif.ahb_mon_cb.Hrdata;
          end
          
           xtn.Hresp=vif.ahb_mon_cb.Hresp;
           xtn.Hreadyout=vif.ahb_mon_cb.Hreadyout;
        
     `uvm_info(get_type_name(),$sformatf("Printing from AHB_MONITOR: %s",xtn.sprint()),UVM_LOW)
     ahb_ap.write(xtn);   
      
  endtask
  
 endclass  
