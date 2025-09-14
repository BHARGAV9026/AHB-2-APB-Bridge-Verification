class ahb_xtn extends uvm_sequence_item;
  `uvm_object_utils(ahb_xtn)
    bit Hclk,Hresetn;
    bit[31:0]Hrdata;
    bit[1:0]Hresp;
    rand bit Hwrite,Hreadyin,Hreadyout;
    rand bit[31:0]Haddr;
    rand bit[31:0]Hwdata;
    rand bit[2:0]Hburst;
    rand bit[1:0]Htrans;
    rand bit[2:0]Hsize;
    rand bit[9:0]length;

    constraint valid_size{Hsize inside {[0:2]};} //since Hrdata & Hwdata are 32 bit wide, 
                                                 //2^0=1-byte of Hwdata
                                                 //2^1=2-bytes(16-bits) of Hwdata
                                                 //2^2=4-bytes(32-bits) of Hwdata
                                                 //2^3=8-bytes(64-bits) exceeeds the limit 32_bit
                                                 //so,Hsize should be inside {[0:2]}
   constraint Hsize_count{Hsize dist {3'b000:=3, 3'b001:=3, 3'b010:=3};}
                                          //Hsize=3'b000=1-byte(8-bits) of Hwdata
                                           //Hsize=3'b001=2-byte(16-bits) of Hwdata
                                            //Hsize=3'b010=3-byte(32-bits) of Hwdata
  constraint valid_Haddr{Hsize ==3'b001 -> {Haddr%2==0};
                         Hsize ==3'b010 -> {Haddr%4==0};} //Haddr should be always be even

  constraint valid_ADDR{Haddr inside {[32'h8000_0000:32'h8000_03ff],
                                      [32'h8400_0000:32'h8400_03ff],
                                      [32'h8800_0000:32'h8800_03ff],
                                      [32'h8c00_0000:32'h8c00_03ff]};} //4 Slaves

  constraint c2{Htrans inside {0,2,3};}
  constraint valid_length{(Hburst==1) -> ((Haddr%1024)+(length*(2**Hsize)) <=1023);
                          (Hburst==0) -> length==1;
                          (Hburst==2) -> length==4;
                          (Hburst==3) -> length==4;
                          (Hburst==4) -> length==8;
                          (Hburst==5) -> length==8;
                          (Hburst==6) -> length==16;
                          (Hburst==7) -> length==16;}

  function new(string name="ahb_xtn");
     super.new(name);
  endfunction

 virtual function void do_print(uvm_printer printer);
      super.do_print(printer);
              	printer.print_field("Hresetn",this.Hresetn,1,UVM_BIN);
		printer.print_field("Hwrite",this.Hwrite,1,UVM_BIN);
		printer.print_field("Htrans",this.Htrans,2,UVM_DEC);
                printer.print_field("Haddr",this.Haddr,32,UVM_HEX);
		printer.print_field("Hwdata",this.Hwdata,32,UVM_HEX);
		printer.print_field("Hrdata",this.Hrdata,32,UVM_HEX);
		printer.print_field("Hsize",this.Hsize,2,UVM_DEC);
		printer.print_field("Hburst",this.Hburst,3,UVM_DEC);
                printer.print_field("Hreadyin",this.Hreadyin,1,UVM_BIN);
		printer.print_field("Hreadyout",this.Hreadyout,1,UVM_BIN);
		printer.print_field("length",this.length,10,UVM_DEC); 
     printer.print_field("Hresp",this.Hresp,2,UVM_DEC);      
  endfunction
 endclass  

