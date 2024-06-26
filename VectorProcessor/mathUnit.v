module mathUnit(input [511 : 0] input1 , [511 : 0] input2 , instr ,
                output signed [1023 : 0] out
                );

    reg [1023 : 0] regout;
    integer i , j;

    always @(*) 
    begin
        //sum instruction
        if(instr == 1'b0)
        begin
            for (j = 0; j < 16; j = j + 1) 
            begin
            regout[j * 64 +: 64] <= $signed(input1[j * 32 +: 32]) + $signed(input2[j * 32 +: 32]);
            end
        end
        //multiply instruction
        else if (instr == 1'b1)
        begin 
            for (i = 0; i < 16; i = i + 1) 
            begin
            regout[i * 64 +: 64] <= $signed(input1[i * 32 +: 32]) * $signed(input2[i * 32 +: 32]);
            end

        end

    end
    assign out = regout;

endmodule
