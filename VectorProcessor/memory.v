module memory (
        input clk , reset , set ,
        input signed [511 : 0] input1 , [8 : 0] address , wEnable,
        output signed [511 : 0] out
    );

    reg signed [31 : 0] mmemory [0 : 511] ;
    reg signed [511 : 0] MemOut;
    integer i , j , k , l;

    initial
    begin
        $readmemh("Initialldata.txt",mmemory);
    end
 
    always @(posedge clk or negedge reset or negedge set) 
    begin
        if(!reset) 
        begin
            for (k = 0 ; k < 32 ; k = k + 1) 
            begin
                mmemory[k] <= 32'h0;
            end
        end

        else if(!set) 
        begin
            for (l = 0 ; l < 32 ; l = l + 1) 
            begin
                mmemory[l] <= 32'h1;
            end
        end 

        else 
        begin
            if (wEnable) 
            begin
                for (i = 0; i < 16; i = i + 1) 
                begin
                    mmemory[(i + address) % 512] <= $signed(input1[32 * i +: 32]);
                end
            end
        end
    end

    always @(*) begin
        for (j = 0; j < 16; j = j + 1) 
        begin
            MemOut[32 * j +: 32] = $signed(mmemory[(j + address) % 512]);
        end 
    end

    assign out = MemOut;

endmodule
