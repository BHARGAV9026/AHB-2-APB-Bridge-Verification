class ahb_sequence extends uvm_sequence #(ahb_xtn);
  `uvm_object_utils(ahb_sequence)
  
  function new(string name="ahb_sequence");
     super.new(name);
  endfunction
  
 endclass  
 
// *****************************************************************************************************************************
 
 class single_sequence extends ahb_sequence;
   `uvm_object_utils(single_sequence)
   
   function new(string name="single_sequence");
      super.new(name);
   endfunction
   
   task body();
       req=ahb_xtn::type_id::create("req");
       start_item(req);
       assert(req.randomize() with {Hburst==3'b000; Htrans==2'b10;});
       finish_item(req);
   endtask
 
 endclass
 
 //*******************************************************************************************************************************
 
 class incr_sequence extends ahb_sequence;
    `uvm_object_utils(incr_sequence)
       	bit[31:0] haddr;
	bit[2:0]  hsize;
	bit hwrite;
	bit[9:0] length1;
	bit[2:0] hburst;

 
    function new(string name="incr_sequence");
       super.new(name);
    endfunction
    
    task body();
      begin
       req=ahb_xtn::type_id::create("req");
       start_item(req);
       assert( req.randomize() with {Htrans==2'b10;Hwrite inside{0,1}; /*for Non_seq transfer*/
                                     Hburst inside{3,5,7};});
                                           
            //Hburst=1 means INCR(unspecified length)
            //Hburst=3 means INCR4(4-beats), length=no_of_beats=4
            //Hburst=5 means INCR8(8-beats),length= 8
            //Hburst=7 means INCR16(16-beats),length=16
       finish_item(req);
       
       haddr=req.Haddr;
       hsize=req.Hsize;
       hburst=req.Hburst;
       hwrite=req.Hwrite;
       length1=req.length;
       
       for(int i=1;i<length1;i++)
         begin
            start_item(req);
            assert( req.randomize() with {Htrans==2'b11; /*for sequential transfers*/
                                  Hburst==hburst;
                                  Hwrite==hwrite;
                                  Hsize==hsize;
                                  Haddr==haddr+(2**hsize);});
            finish_item(req);
            haddr=req.Haddr;
         end
     end
  endtask
endclass

/***********************************************************************************************************************/

class wrap_sequence extends ahb_sequence;
  `uvm_object_utils(wrap_sequence)
    	bit[31:0] haddr;
	bit[2:0]  hsize;
	bit hwrite;
	bit[9:0] length1;
	bit[2:0] hburst;

    bit[31:0]start_addr;
    bit[31:0]bound_addr;
    
   function new(string name="incr_sequence");
       super.new(name);
    endfunction
    
  task body();
       req=ahb_xtn::type_id::create("req");
       begin
       start_item(req);
       assert(req.randomize() with {Htrans==2'b10; Hwrite inside{0,1};/*for Non_seq transfer*/
                                    Hburst inside{2,4,6};});
                             
                             
            //Hburst=2 means WRAP4(4-beats,length=4)
            //Hburst=4 means WRAP8(8-beats), length=no_of_beats=8
            //Hburst=6 means WRAP16(16-beats),length=16

       finish_item(req);
       end
       
       haddr=req.Haddr;
       hsize=req.Hsize;
       hburst=req.Hburst;
       hwrite=req.Hwrite;
       length1=req.length;

       start_addr=( ((haddr)/(2**hsize)*(length1))*((2**hsize) * length1));
       
       $display("START ADDRESS : %h",start_addr);
       
       bound_addr=( start_addr + (2**hsize)*length1);
       
       $display("BOUND ADDRESS : %h",bound_addr);
       
       haddr=req.Haddr+(2**hsize);
       
       for(int i=1;i<length1;i=i+1)
         begin
           if(haddr==bound_addr)
              begin
               haddr=start_addr;
              end 

            start_item(req);
            assert( req.randomize() with {Htrans==2'b11;
                                          length==length1; /*for sequential transfers*/
                                          Hburst==hburst;
                                          Hwrite==hwrite;
                                          Hsize==hsize;
                                          Haddr==haddr;});
            finish_item(req);
            
            haddr=req.Haddr+(2**hsize);
         end
  endtask
endclass








  
 
             
