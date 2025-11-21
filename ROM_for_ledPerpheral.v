`include "Led_peripheral.v"

module  Rom_for_ledPerpheral(
    output reg wr_en,
    output reg[7:0]data_address,
    output reg[7:0]write_data,
    output reg[31:0]counter,
    input clk,rst

);

reg [7:0]rom[0:30];
reg [7:0]wr_ptr;
reg [7:0]pc; //program counter
wire [15:0]led;

Led_Peripheral l1(led,data_address,write_data,wr_en,clk,rst);


initial begin
rom[0]=8'h11;     //opcode:-start
rom[1]=8'h12;     //opcode:- move led
rom[2]=8'h5;      //data write
rom[3]=8'h13;     //opcode:- led pattern 
rom[4]=8'h5;      //data write
rom[5]=8'h14;     //opcode:-led pattern
rom[6]=8'h3;      //data write
rom[7]=8'h11;     //once again opcode to check if what we did above is correct   
rom[8]=8'h12;     //similarly to check waht we did is correct or not
rom[9]=8'h15;     // opcode:move counter
rom[10]=8'h50;
rom[11]=8'h60;
rom[12]=8'h70;
rom[13]=8'h80;
rom[14]=8'h30;
rom[15]=8'h15;     //to verify if what we have load delay for counter is correct or not
rom[16]=8'h20;
rom[17]=8'h30;
rom[18]=8'h40;
rom[19]=8'h50;
rom[20]=8'h60;
end



reg [2:0]state;
reg [7:0]reg1;
reg [7:0]reg2;
reg [7:0]reg3;
reg [7:0]reg4;
reg [2:0]counter_reg; // to fetch the counter data 
// parameter=


always@(posedge clk or posedge rst)begin 
    if(rst)begin
        state<=0;
        wr_ptr<=0;
        data_address<=0;
        write_data<=0;
        wr_en<=0;
        counter<=0;
        reg1<=0;
        reg2<=0;
        reg3<=0;
        reg4<=0;
        counter_reg<=0;
        //pc<=rom[wr_ptr];
    end else begin
        case(state)
            3'b000: //FETCH 
            begin
                pc<=rom[wr_ptr];   //FETCH Action
                state<=3'b001;
            end

            3'b001: //DECODE 
            begin
                case(pc)

                    8'h11: begin state<=3'b010; wr_ptr<=wr_ptr+1; end
                    8'h12: begin state<=3'b010; wr_ptr<=wr_ptr+1; end
                    8'h13: begin state<=3'b010; wr_ptr<=wr_ptr+1; end
                    8'h14: begin state<=3'b010; wr_ptr<=wr_ptr+1; end
                    8'h15: begin state<=3'b010;/*wr_ptr<=wr_ptr+1;*/ end
                    default: begin state<=0; wr_ptr<=wr_ptr+1; end
                    

                endcase

                
            end 

            3'b010: //FETCH DATA
            begin
                case(pc)
                    8'h11:
                    begin
                        state<=0; // as the opcode is 1byte just goto to next instruction,and for this we are taking 1 clock cycle
                    end

                    8'h12:
                    begin
                        data_address<=8'h1;
                        //wr_en<=0;
                        pc<=rom[wr_ptr];  //data fetch for write data for next clock cycle
                        state<=3'b011;
                    end

                    8'h13:
                    begin
                        data_address<=8'h2;
                        pc<=rom[wr_ptr];   //data fetch for write data for next clock cycle

                        state<=3'b011;
                    end

                    8'h14:
                    begin
                        data_address<=8'h3;
                        pc<=rom[wr_ptr];   //data fetch for write data for next clock cycle

                        
                        state<=3'b011;
                    end

                    8'h15:
                    begin
                        case(counter_reg)
                        // 3'b000:begin counter<={reg1,reg2,reg3,reg4};counter_reg<=3'b001; end
                        // 3'b001:begin reg1<=rom[wr_ptr+1];counter_reg<=3'b010; end
                        // 3'b010:begin reg2<=rom[wr_ptr+2];counter_reg<=3'b011; end
                        // 3'b011:begin reg3<=rom[wr_ptr+3];counter_reg<=3'b100; end
                        // 3'b100:begin reg4<=rom[wr_ptr+4];counter_reg<=3'b000;wr_ptr<=wr_ptr+1;state<=3'b011; end

                        3'b000:begin reg1<=rom[wr_ptr+1];counter_reg<=3'b001; end
                        3'b001:begin reg2<=rom[wr_ptr+2];counter_reg<=3'b010; end
                        3'b010:begin reg3<=rom[wr_ptr+3];counter_reg<=3'b011; end
                        3'b011:begin reg4<=rom[wr_ptr+4];counter_reg<=3'b100; end
                        3'b100:begin counter<={reg1,reg2,reg3,reg4};wr_ptr<=wr_ptr+4;state<=3'b000;counter_reg<=0;end
                        endcase
                    end

                    // 8'h20:
                    // begin
                    //     // counter<={reg1,reg2,reg3,reg4};
                    //     wr_ptr<=wr_ptr+1;
                    // end

                endcase
            
            end //
                3'b011: 
                begin
                    wr_en<=1;
                    write_data<=pc; //pc supposed to hold write data which was being fetched at earlier cycle
                    // counter<={reg1,reg2,reg3,reg4}; // this will show's the data on the next clock cyle (this is the next clock cycle)

                    state<=0;
                end
            // end

        endcase

    end
end



endmodule


