class test extends uvm_test;
 `uvm_component_utils(test)
 env envh;
 virtual_sequence vseqh;
 env_config env_cfg;
 ahb_agent_config ahb_agt_cfg;
 apb_agent_config apb_agt_cfg;

function new(string name="test",uvm_component parent);
  super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
   env_cfg=env_config::type_id::create("env_cfg");
  ahb_agt_cfg=ahb_agent_config::type_id::create("ahb_agt_cfg");
  apb_agt_cfg=apb_agent_config::type_id::create("apb_agt_cfg");

   
   if(!uvm_config_db#(virtual ahb_if)::get(this,"*","in0",ahb_agt_cfg.vif))
      `uvm_fatal("AHB_IF","cannot get() ahb_if into ahb_agt_cfg")
      
    if(!uvm_config_db#(virtual apb_if)::get(this,"*","in1",apb_agt_cfg.vif))
      `uvm_fatal("APB_IF","cannot get() apb_if into apb_agt_cfg")  

   env_cfg.ahb_agt_cfg=ahb_agt_cfg;
   env_cfg.apb_agt_cfg=apb_agt_cfg;
  
   uvm_config_db#(env_config)::set(this,"*","env_config",env_cfg);
   uvm_config_db#(ahb_agent_config)::set(this,"*","ahb_agent_config",ahb_agt_cfg);
   uvm_config_db#(apb_agent_config)::set(this,"*","apb_agent_config",apb_agt_cfg);

   envh=env::type_id::create("envh",this);
   vseqh= virtual_sequence::type_id::create("vseqh");
endfunction

function void end_of_elaboration_phase(uvm_phase phase);
  uvm_top.print_topology();
endfunction

endclass

class single_test extends test;
    `uvm_component_utils(single_test)
    single_v_sequence single_vseq;
      //single_sequence s_seq;
    function new(string name="single_test",uvm_component parent);
       super.new(name,parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
       single_vseq=single_v_sequence::type_id::create("single_vseq");
        //s_seq=single_sequence::type_id::create("s_seq");
     endfunction
     
     task run_phase(uvm_phase phase);
      phase.raise_objection(this);
       
        //  s_seq.start(envh.ahb_agt_top.ahb_agt[0].ahb_seqrh);
        single_vseq.start(envh.v_sequencer);
      phase.drop_objection(this);
     endtask
endclass

class incr_test extends test;
    `uvm_component_utils(incr_test)
    incr_v_sequence incr_vseq;
    //incr_sequence i_seq;
    function new(string name="incr_test",uvm_component parent);
       super.new(name,parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
       incr_vseq=incr_v_sequence::type_id::create("incr_vseq");
            // i_seq=incr_sequence::type_id::create("i_seq");

     endfunction
     
     task run_phase(uvm_phase phase);
      phase.raise_objection(this);
        
         // i_seq.start(envh.ahb_agt_top.ahb_agt[0].ahb_seqrh);
          incr_vseq.start(envh.v_sequencer);
      phase.drop_objection(this);
     endtask
endclass

class wrap_test extends test;
    `uvm_component_utils(wrap_test)
    wrap_v_sequence wrap_vseq;
     // wrap_sequence w_seq;
    function new(string name="wrap_test",uvm_component parent);
       super.new(name,parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
       wrap_vseq=wrap_v_sequence::type_id::create("wrap_vseq");
     // w_seq=wrap_sequence::type_id::create("w_seq");

     endfunction
     
     task run_phase(uvm_phase phase);
      phase.raise_objection(this);
       //begin
          //w_seq.start(envh.ahb_agt_top.ahb_agt[0].ahb_seqrh);
          wrap_vseq.start(envh.v_sequencer);
       //end
      phase.drop_objection(this);
     endtask
endclass
