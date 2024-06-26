module processor(input clk , reset , set , [12 : 0] instruction , 
                output signed [511 : 0] A1 , signed [511 : 0] A2 , signed [511 : 0] A3 , signed [511 : 0] A4);

    
    //ports for mathUnit
    reg [511 : 0] mathUnitInput1;
    reg [511 : 0] mathUnitInput2;
    reg instr;
    wire signed [1023 : 0] mathUnitOutput;
    //ports register
    reg [511 : 0] registerInput1;
    reg [511 : 0] registerInput2;
    reg [1 : 0] registerWriteAdd1;
    reg [1 : 0] registerWriteAdd2;
    reg registerWriteEnable1;
    reg registerWriteEnable2;
    reg [1 : 0] registerReadAdd;
    wire signed [511 : 0] registerOut;
    wire signed [511 : 0] registerA1;
    wire signed [511 : 0] registerA2;
    wire signed [511 : 0] registerA3;
    wire signed [511 : 0] registerA4;
    //ports for memory
    reg signed [511 : 0] memoryInput;
    reg [8 : 0] memoryAddress;
    reg memoryWriteEnable;
    wire signed [511 : 0] memoryOut;


    //instance from mathUnit
    mathUnit mathUnit (mathUnitInput1 , mathUnitInput2 , instr , mathUnitOutput);
    //instance from register
    register registerr (clk , reset , set , registerInput1 , registerInput2 , registerWriteAdd1 ,
                                    registerWriteAdd2 , registerWriteEnable1 , registerWriteEnable2 ,
                                    registerReadAdd , registerOut , registerA1 , registerA2 , registerA3 , registerA4);
    //instance from memory
    memory memoryy (clk , reset , set , memoryInput, memoryAddress, memoryWriteEnable, memoryOut);

    integer j;

     always @(negedge clk) 
     begin
        #5
        if(instruction[12 : 11] == 2'b00)
            begin
                memoryWriteEnable <= 0;
                memoryAddress <= instruction[8 : 0];
                registerWriteEnable1 <= 1;
                registerWriteEnable2 <= 0;
                registerWriteAdd1 <= instruction[10 : 9];
                #5
                registerInput1 <= memoryOut;
            end

        else if(instruction[12 : 11] == 2'b01)
            begin
                memoryWriteEnable <= 1;
                memoryAddress <= instruction[8 : 0];
                registerWriteEnable1 <= 0;
                registerWriteEnable2 <= 0;
                registerWriteAdd1 <= instruction[10 : 9];
                #5
                registerInput1 <= memoryOut;
            end

        else if(instruction[12 : 11] == 2'b10) 
            begin
                memoryWriteEnable <= 0;
                registerWriteEnable1 <= 1;
                registerWriteEnable2 <= 1;
                registerWriteAdd1 <= 2'b10;
                registerWriteAdd2 <= 2'b11;
                instr = 1'b0;
                mathUnitInput1 <= registerA1;
                mathUnitInput2 <= registerA2;
                #5
                for(j = 0 ; j < 16 ; j = j + 1) 
                begin
                    registerInput1[32 * j +: 32] <= mathUnitOutput[64 * j +: 32];
                    registerInput2[32 * j +: 32] <= mathUnitOutput[64 * j + 32 +: 32];
                end
            end

        else if(instruction[12 : 11] == 2'b11)  
            begin
                memoryWriteEnable <= 0;
                registerWriteEnable1<= 1;
                registerWriteEnable1 <= 1;
                registerWriteAdd1 <= 2'b10;
                registerWriteAdd1  <= 2'b11;
                instr = 1'b1;
                mathUnitInput1 <= registerA1;
                mathUnitInput2 <= registerA2;
                #5
                for(j = 0; j < 16; j = j + 1) 
                begin
                    registerInput1[32 * j +: 32] <= mathUnitOutput[64 * j +: 32];
                    registerInput2[32 * j +: 32] <= mathUnitOutput[64 * j + 32 +: 32];
                end
            end
    end



    assign A1 = registerA1;
    assign A2 = registerA2;
    assign A3 = registerA3;
    assign A4 = registerA4;


endmodule
