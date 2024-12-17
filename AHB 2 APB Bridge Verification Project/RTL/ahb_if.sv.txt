interface ahb_if (input bit clock);
  bit[31:0]Haddr;
  bit[31:0]Hwdata;
  bit[31:0]Hrdata;
  bit[1:0]Htrans;
  bit[2:0]Hburst;
  bit Hreadyin,Hreadyout;
  bit Hwrite,Hresetn;
  bit[2:0]Hsize;
  bit[1:0]Hresp;
 
 
 clocking ahb_drv_cb @(posedge clock);
  default input #1 output #1;
    output Haddr,Hwrite,Hwdata,Htrans;
    output Hburst,Hreadyin,Hsize,Hresetn;
    input Hreadyout;
 endclocking

clocking ahb_mon_cb @(posedge clock);
  default input #1 output #1;
     input Haddr,Hwrite,Hwdata,Htrans;
     input Hburst,Hreadyin,Hsize,Hrdata;
     input Hreadyout,Hresp,Hresetn;
endclocking

modport AHB_DRV_MP(clocking ahb_drv_cb);
modport AHB_MON_MP(clocking ahb_mon_cb);

endinterface
  
