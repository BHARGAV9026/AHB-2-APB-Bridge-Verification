class apb_xtn extends uvm_sequence_item;
  `uvm_object_utils(apb_xtn)
    bit Penable;
    bit Pwrite;
    bit[31:0] Pwdata;
    bit[31:0] Paddr;
    rand bit[31:0]Prdata;
    bit[3:0] Pselx;

  function new(string name="apb_xtn");
     super.new(name);
  endfunction

  //constraint pselx_count{ Pselx dist{4'b0001:=4, 4'b0010:=4, 4'b0100:=4, 4'b1000:=4};}
  
  virtual function void do_print(uvm_printer printer);
     super.do_print(printer);
              	printer.print_field("Paddr",this.Paddr,32,UVM_HEX);
		printer.print_field("Pwrite",this.Pwrite,1,UVM_BIN);
		printer.print_field("Pselx",this.Pselx,4,UVM_BIN);
                printer.print_field("Penable",this.Penable,1,UVM_BIN);
		printer.print_field("Pwdata",this.Pwdata,32,UVM_HEX);
		printer.print_field("Prdata",this.Prdata,32,UVM_HEX);
  endfunction
 endclass  
 
