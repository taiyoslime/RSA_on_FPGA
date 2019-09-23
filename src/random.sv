module random #(
    parameter mbit = 63
)
(
    input logic clk,
    input logic rst,
    input logic [mbit:0] seed,
    output logic [mbit:0] randn
);

    initial begin
        randn = 0;
    end

    always @(posedge clk or negedge rst) begin
        if (!rst)
        begin
            randn <= 0;
        end
        else
        begin
            if (mbit == 31) begin
                randn <= xorshift32(seed);
            end
            else if (mbit == 63) begin
                randn <= xorshift64(seed);
            end
            else begin
                randn <= xorshift64(seed);
            end
        end
    end

    function logic [mbit:0] xorshift32(input logic [mbit:0] seed);
        if (seed == 0) begin
            seed = seed + 1;
        end
        xorshift32 = seed;
        xorshift32 = xorshift32 ^ (xorshift32 << 13);
        xorshift32 = xorshift32 ^ (xorshift32 >> 17);
        xorshift32 = xorshift32 ^ (xorshift32 << 5);
    endfunction

    function logic [mbit:0] xorshift64(input logic [mbit:0] seed);
        if (seed == 0) begin
            seed = seed + 1;
        end
        xorshift64 = seed;
        xorshift64 = xorshift64 ^ (xorshift64 << 13);
        xorshift64 = xorshift64 ^ (xorshift64 >> 7);
        xorshift64 = xorshift64 ^ (xorshift64 << 17);
    endfunction


endmodule