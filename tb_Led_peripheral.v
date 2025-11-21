//this has some issue like it is taking 6 clock cycle instead of 4

//`include "Led_peripheral.v"
`include "ROM_for_ledPerpheral.v"
module tb_led_peripheral();
    // wire[15:0]led;
    // reg [7:0]data_address;
    // reg [7:0]write_data;
    // reg wr_en;
    // reg clk,rst;

     wire wr_en;
     wire[7:0]data_address;
     wire[7:0]write_data;
     wire[31:0]counter;
    reg clk,rst;

    //Led_Peripheral l2(led,data_address,write_data,wr_en,clk,rst);
    Rom_for_ledPerpheral r1(wr_en,data_address,write_data,counter,clk,rst);



initial begin
    clk=1;
    forever #5 clk=~clk;
end


initial begin
    $monitor("Time:%0t\t | clk:%b\t | Wr_En:%b\t | wr_ptr:%b\t | Address:%b\t | Input:%b\t | led:%b\t | counter:%d",$time,clk,wr_en,r1.wr_ptr,data_address,write_data,r1.led,counter);
    rst=1;
    #10;
    rst=0;

#600$finish;
end

endmodule
