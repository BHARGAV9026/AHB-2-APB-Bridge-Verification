class apb_sequence extends uvm_sequence #(apb_xtn);
  `uvm_object_utils(apb_sequence)
  
  function new(string name="apb_sequence");
     super.new(name);
  endfunction
  
  task body();
     begin
         req=apb_xtn::type_id::create("req");
         start_item(req);
         assert(req.randomize());
         finish_item(req);
     end
  endtask
  
 endclass  
 
