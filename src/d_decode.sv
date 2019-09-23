module d_decode #(
    parameter mbit = 63
)
(
   input logic clk,
   input logic rst,
   input logic [mbit:0] clk_cnt,
   input logic [mbit:0] disp_n,
   //output int seg_int [8] = {0,0,0,0,0,0,0,0},
   output logic d_decode_busy
);

    logic [mbit:0] b_n;
    int cnt;

    initial begin
       d_decode_busy = 1;
         b_n = 0;
         cnt = 0;
    end

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            b_n <= 0;
            d_decode_busy <= 0;
            cnt <= 0;
        end
        else begin
            if (!d_decode_busy) begin
                 if ( b_n != disp_n ) begin
                        d_decode_busy <= 1;
                        cnt <= 0;
                 end
                 b_n <= disp_n;
            end

            else begin
                if (cnt < 8) begin
                        $write("b_n: %d\n", b_n);
                        $write("cnt : %d %d\n", cnt ,  b_n / (10 ** (7 - cnt) ) );
                        b_n <= b_n - b_n / (10 ** (7 - cnt) ) * (10 ** (7 - cnt) );
                    cnt <= cnt + 1;
                end
                else begin
                    d_decode_busy <= 0;
                    cnt <= 0;
                end

            end
        end
    end


endmodule
