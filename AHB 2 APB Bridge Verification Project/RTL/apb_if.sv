interface apb_if(input bit clock);
  bit[31:0]Paddr;
  bit[31:0]Prdata;
  bit[31:0]Pwdata;
  bit[3:0]Pselx;
  bit Penable,Pwrite;
 
 clocking apb_drv_cb @(posedge clock);
   default input #1 output #1;
     input Pwrite,Pwdata;
     input Pselx;
     input Penable;
     input Paddr;
     output Prdata;
 endclocking

clocking apb_mon_cb @(posedge clock);
 default input #1 output #1;
   input Pwrite;
   input Pselx;
   input Prdata;
   input Penable;
   input Pwdata;
  input Paddr;
endclocking

modport APB_DRV_MP(clocking apb_drv_cb);
modport APB_MON_MP(clocking apb_mon_cb);

endinterface
