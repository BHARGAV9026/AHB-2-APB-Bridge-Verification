class virtual_sequence extends uvm_sequence #(uvm_sequence_item);
   `uvm_object_utils(virtual_sequence)
   virtual_sequencer vseqrh;
   ahb_sequencer v_ahb_seqrh[];
   apb_sequencer v_apb_seqrh[];
   env_config env_cfg;
   
   function new(string name="virtual_sequence");
     super.new(name);
   endfunction
   
   task body();
     
       if(!$cast(vseqrh,m_sequencer))
         begin
       `uvm_error("body","casting failed")
         end

    if(!uvm_config_db #(env_config)::get(null,get_full_name(),"env_config",env_cfg))
     `uvm_fatal("CONFIG","cannot get env_config in virtual_sequence")

   
    v_ahb_seqrh=new[env_cfg.no_of_ahb_agts];
    v_apb_seqrh=new[env_cfg.no_of_apb_agts];
      
    foreach(v_ahb_seqrh[i])
      begin
        v_ahb_seqrh[i]= vseqrh.ahb_vseqrh[i];
      end
    foreach(v_apb_seqrh[i])
      begin
        v_apb_seqrh[i]= vseqrh.apb_vseqrh[i];
      end
   
  endtask

endclass

//*******************************************************************************************************************************************
class single_v_sequence extends virtual_sequence;
 `uvm_object_utils(single_v_sequence)
 
   single_sequence s_seq;
   //apb_sequence apb_seq;
   
   function new(string name="single_v_sequence");
     super.new(name);
   endfunction
   
   task body();
     begin
           super.body();
           s_seq=single_sequence::type_id::create("s_seq");
           //apb_seq=apb_sequence::type_id::create("apb_seq");
           
        //fork
           s_seq.start(v_ahb_seqrh[0]);
          // apb_seq.start(v_apb_seqrh[0]);
        //join
        
     end   
  endtask
endclass


//*************************************************************************************************************************************************
class incr_v_sequence extends virtual_sequence;
   `uvm_object_utils(incr_v_sequence)
   
   incr_sequence incr_seq;
   //apb_sequence apb_seq;
    
   function new(string name="incr_v_sequence");
     super.new(name);
   endfunction
   
   task body();
     begin
         super.body();
          incr_seq=incr_sequence::type_id::create("incr_seq");
         // apb_seq=apb_sequence::type_id::create("apb_seq");
          
         //fork
            incr_seq.start(v_ahb_seqrh[0]);
            //apb_seq.start(v_apb_seqrh[0]);
         //join
       
     end
    endtask
endclass


//*****************************************************************************************************************************************************
class wrap_v_sequence extends virtual_sequence;
   `uvm_object_utils(wrap_v_sequence)
   wrap_sequence wrap_seq;
  // apb_sequence apb_seq;
   
   function new(string name="wrap_v_sequence");
     super.new(name);
   endfunction
   
   task body();
      begin
        super.body();
        wrap_seq=wrap_sequence::type_id::create("wrap_seq"); 
       // apb_seq=apb_sequence::type_id::create("apb_seq");
        
        //fork    
          wrap_seq.start(v_ahb_seqrh[0]);
         // apb_seq.start(v_apb_seqrh[0]);
      // join
      
     end
   endtask
endclass
