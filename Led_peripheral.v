// `include "Rom_for_ledPerpheral.v"


module Led_Peripheral(
    output reg[15:0]led,
    input [7:0]data_address,
    input [7:0]write_data,
    input wr_en,
    input clk,rst    
);

reg[7:0]data_reg1;
reg[7:0]data_reg2;
reg[7:0]data_add; // will take input from other module
reg[7:0]write_data_reg;

//reg[7:0]ram[0:7];

parameter led_control=8'b00000001;
parameter led_data_01=8'b00000010;
parameter led_data_02=8'b00000011;

 //Rom_for_ledPerpheral r1(wr_en,data_address,write_data,clk,rst);


always@(posedge clk or posedge rst)begin
  if(rst)begin
    led<=16'h0;
    data_reg1<=0;
    data_reg2<=0;
  end else begin
    //here we register ouput of ther module as input to this module
    data_add<=data_address;
    write_data_reg<=write_data;


    if(data_add == led_control) begin
        if(write_data_reg[0]==0)begin
            led<=16'h0;
        end else begin
        led<={data_reg1,data_reg2};
        end
    end 
    else if(data_add == led_data_01)begin
        if(wr_en)begin
            data_reg1<=write_data_reg;
        end
    end
    else if(data_add == led_data_02)begin
        if(wr_en)begin
            data_reg2<=write_data_reg;
        end 

    end else begin
        led<=16'h0;
    end
    
  end

  
end


endmodule












/*
module tb_led_peripheral;
    wire [15:0]led;
    reg [7:0]data_address;
    reg [7:0]write_data;
    reg wr_en,clk,rst;    

    Led_Peripheral l1(led,data_address,write_data,wr_en,clk,rst);


    initial begin
    clk=1;
    forever #5 clk=~clk;
    end

    initial begin
        $monitor("Time:%0t\t | clk:%b\t | Wr_En:%b\t | Address:%b\t | Input:%b\t | led:%b\t",$time,clk,wr_en,data_address,write_data,led);

        rst=1;
        #10;
        rst=0;
        #2;

        wr_en=1;
        data_address=8'b00000010;
        write_data=8'b11001100;#10;
        // wr_en=0;#10;
        // wr_en=1;#10;
        // data_address=8'b00000011;
        // write_data=8'b10101010;

        wr_en=1;
        data_address=8'b00000011;#10;
        write_data=8'b10101010;#10;


        wr_en=0;#10;

        data_address=8'b00000001;#10;
        write_data<=8'b11111110;
        #10;
        data_address=8'b00000001;#10;
        write_data=8'b00000001;#10;

        // wr_en=1;
        // data_address=8'b00000010;
        // write_data=8'b11110000;
        // #10;

        #200$finish;


    end
endmodule
*/