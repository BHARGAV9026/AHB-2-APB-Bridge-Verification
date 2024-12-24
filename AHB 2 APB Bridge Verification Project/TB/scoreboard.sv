class scoreboard extends uvm_component;
  `uvm_component_utils(scoreboard)
   ahb_xtn ahb;
   apb_xtn apb;
   
   uvm_tlm_analysis_fifo #(ahb_xtn) ahb_fifo;
   uvm_tlm_analysis_fifo #(apb_xtn) apb_fifo;

  covergroup ahb_cg;
		option.per_instance = 1;
		HADDR : coverpoint ahb.Haddr {
					   bins Haddr1={[32'h8000_0000:32'h8000_03ff]};
                                           bins Haddr2={[32'h8400_0000:32'h8400_03ff]};
                                           bins Haddr3={[32'h8800_0000:32'h8800_03ff]};
                                           bins Haddr4={[32'h8c00_0000:32'h8c00_03ff]};}
						
		HSIZE : coverpoint ahb.Hsize{
				         	bins zero= {0};
                                                bins one= {1};
                                                bins two= {2};}
						        	
                HWRITE : coverpoint ahb.Hwrite{ bins Hread={0};
                                                bins Hwrite={1};}

                HTRANS : coverpoint ahb.Htrans{ bins seq={2};
                                                bins nseq={3};}
             // AHB_CROSS: cross HADDR,HSIZE,HWRITE,HTRANS;
   endgroup

    covergroup apb_cg;
		option.per_instance = 1;
		PADDR : coverpoint apb.Paddr {
					   bins Paddr1={[32'h8000_0000:32'h8000_03ff]};
                                           bins Paddr2={[32'h8400_0000:32'h8400_03ff]};
                                           bins Paddr3={[32'h8800_0000:32'h8800_03ff]};
                                           bins Paddr4={[32'h8c00_0000:32'h8c00_03ff]};}
						
		PSEL : coverpoint apb.Pselx{
				         	bins pselx= {1,2,4,8};
                                               }
						        	
                PWRITE : coverpoint apb.Pwrite{ bins Prd={0};
                                                bins Pwr={1};}

                PENABLE : coverpoint apb.Penable{ bins Pe={0,1};}
                                              
              //APB_CROSS: cross PADDR,PSEL,PWRITE,PENABLE;
	endgroup


  
  function new(string name="scoreboard",uvm_component parent);
  
     super.new(name,parent);
     ahb_fifo=new("ahb_fifo",this);
     apb_fifo=new("apb_fifo",this);
     ahb_cg=new();
     apb_cg=new();
     
  endfunction

  
  function void build_phase(uvm_phase phase);
     super.build_phase(phase);
     ahb=ahb_xtn::type_id::create("ahb");
     apb=apb_xtn::type_id::create("apb");
     
  endfunction

  task run_phase(uvm_phase phase);
     //super.run_phase(phase);
    forever
     begin
 
       fork
           begin
              ahb_fifo.get(ahb);
              //ahb.print();
              ahb_cg.sample();
             `uvm_info(get_type_name(),$sformatf("printing from AHB_FIFO in SCOREBOARD %s",ahb.sprint()),UVM_LOW)
             // ahb_cg.sample();
           end
           
           begin
                apb_fifo.get(apb);
                // apb.print();
                 apb_cg.sample();
               `uvm_info(get_type_name(),$sformatf("printing from APB_FIFO IN SCOREBOARD %s",apb.sprint()),UVM_LOW)
               // apb_cg.sample();
           end  

          //chekc(ahb,apb); 
       join
      // $display("I AM AT CHECK METHOD");
       check_data(ahb,apb);
   end
endtask

  //$display("I am before compared method");


task compare( bit[31:0]haddr,bit[31:0]paddr,bit[31:0]hdata,bit[31:0]pdata);
  $display("I am in compared method");
    if(haddr==paddr)
       begin
          $display("ADDR COMPARISION SUCCESSFUL");
          $display("ADDR matched values: haddr=%h,paddr=%h",haddr,paddr);
       end

    else
       begin
           $display("ADDR COMPARISION FAILED");
           $display("ADDR mismatched values: haddr=%h,paddr=%h",haddr,paddr);
        end
       
   if(hdata==pdata)
       begin
          $display("DATA COMPARISION SUCCESSFUL");
          $display("DATA matched values: hdata=%h,pdata=%h",hdata,pdata);
       end

   else
        begin
         $display("DATA COMPARISION FAILED");
         $display("DATA mismatched values: hdata=%h,pdata=%h",hdata,pdata);
        end
endtask

task check_data(ahb_xtn ahb,apb_xtn apb);
 //$display("CHECK_DATA ");
   if(ahb.Hwrite)
      begin
         if(ahb.Hsize==0)
            begin
                if(ahb.Haddr[1:0]==2'b00)
                begin
                // $display("I am near compare method in nCHECK_DATA");
                 compare(ahb.Haddr,apb.Paddr,ahb.Hwdata[7:0],apb.Pwdata[7:0]);
                end
                if(ahb.Haddr[1:0]==2'b01)
                begin
                 compare(ahb.Haddr,apb.Paddr,ahb.Hwdata[15:8],apb.Pwdata[7:0]);
                end
                if(ahb.Haddr[1:0]==2'b10)
                 begin
                 compare(ahb.Haddr,apb.Paddr,ahb.Hwdata[23:16],apb.Pwdata[7:0]);
                 end
                if(ahb.Haddr[1:0]==2'b11)
                 begin
                 compare(ahb.Haddr,apb.Paddr,ahb.Hwdata[31:23],apb.Pwdata[7:0]);
                  end
           end
        if(ahb.Hsize==1)
            begin
                if(ahb.Haddr[1:0]==2'b00)
                 begin
                 compare(ahb.Haddr,apb.Paddr,ahb.Hwdata[15:0],apb.Pwdata[15:0]);
                 end
               if(ahb.Haddr[1:0]==2'b10)
                 begin
                 compare(ahb.Haddr,apb.Paddr,ahb.Hwdata[31:16],apb.Pwdata[15:0]);
                end
            end
         if(ahb.Hsize==2)
            begin
                if(ahb.Haddr[1:0]==2'b00)
                begin
                 compare(ahb.Haddr,apb.Paddr,ahb.Hwdata,apb.Pwdata);
                end
            end
    end
    
     if(ahb.Hwrite==0)
      begin
         if(ahb.Hsize==0)
            begin
                if(ahb.Haddr[1:0]==2'b00)
                 begin
                   compare(ahb.Haddr,apb.Paddr,ahb.Hrdata[7:0],apb.Prdata[7:0]);
                 end
                if(ahb.Haddr[1:0]==2'b01)
                 begin
                      compare(ahb.Haddr,apb.Paddr,ahb.Hrdata[7:0],apb.Prdata[15:8]);
                  end
                if(ahb.Haddr[1:0]==2'b10)
                  begin
                    compare(ahb.Haddr,apb.Paddr,ahb.Hrdata[7:0],apb.Prdata[23:16]);
                  end
                if(ahb.Haddr[1:0]==2'b11)
                  begin
                    compare(ahb.Haddr,apb.Paddr,ahb.Hrdata[7:0],apb.Prdata[31:24]);
                  end
           end
        if(ahb.Hsize==1)
            begin
                if(ahb.Haddr[1:0]==2'b00)
                 begin
                   compare(ahb.Haddr,apb.Paddr,ahb.Hrdata[15:0],apb.Prdata[15:0]);
                 end
                if(ahb.Haddr[1:0]==2'b10)
                 begin
                   compare(ahb.Haddr,apb.Paddr,ahb.Hrdata[15:0],apb.Prdata[31:16]);
                 end
            end
         if(ahb.Hsize==2)
            begin
                if(ahb.Haddr[1:0]==2'b00)
                 begin
                 compare(ahb.Haddr,apb.Paddr,ahb.Hrdata,apb.Prdata);
                end
            end
    end

endtask

endclass
