module register (
        input clk , reset , set ,
        input [511 : 0] input1 , [511 : 0] input2,
        input [1 : 0] wAdd1 , [1 : 0] wAdd2,
        input wEnable1 , wEnable2 ,[1 : 0] rAdd,
        output signed [511 : 0] out,
        output signed [511 : 0] A1 , signed [511 : 0] A2 , signed [511 : 0] A3 , signed [511 : 0] A4
    );


        // 512*4 registers!
    reg signed [511 : 0] registers [0 : 3];

    integer i,j;
    always @(posedge clk or negedge reset or negedge set) 
    begin
        //reset signal is enabled!
        if(!reset) 
        begin
            for (j = 0; j < 16; j = j + 1) 
            begin
            registers[j] = 512'b0;
            end
        end
        //set signal is enabled!
        else if(!set)
        begin
            for (i = 0; i < 16; i = i + 1) 
            begin
            registers[j] = 512'b1;
            end
        end
        //write signal is enabled!
        else
        begin
            if (wEnable1) 
            begin
            registers[wAdd1] <= $signed(input1);
            end
            if (wEnable2) 
            begin
            registers[wAdd2] <= $signed(input2);
            end
        end
    end

    assign A1 = registers[0];
    assign A2 = registers[1];
    assign A3 = registers[2];
    assign A4 = registers[3];

    assign out = registers[rAdd];

endmodule