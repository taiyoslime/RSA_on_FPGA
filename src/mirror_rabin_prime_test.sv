module mirror_rabin_prime_test #(
   parameter mbit = 63
)
(
    input logic clk,
    input logic rst,
    input logic [mbit:0] clk_cnt,
    input logic [mbit:0] mirror_rabin_prime_test_n,
    output logic mirror_rabin_prime_test_isprime,
    output logic mirror_rabin_prime_test_busy
);

    parameter int th = 20;
    int cnt;
    logic [mbit:0] randn;
    logic [mbit:0] modpow_x;
    logic [mbit:0] modpow_y;
    logic [mbit:0] modpow_n;
    logic [mbit:0] modpow_res;
    logic [mbit:0] b_n;
    logic [mbit:0] a;
    logic [mbit:0] t;
    logic [mbit:0] y;
    logic [mbit:0] d;
    logic modpow_busy;



    random #(mbit) random_inst(.seed(clk_cnt),  .*);
    modpow #(mbit) modpow_inst(.*);


    initial begin
        cnt = 0;
        mirror_rabin_prime_test_busy = 0;
        mirror_rabin_prime_test_isprime = 0;
        b_n = 0;
    end

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            cnt <= 0;
            b_n <= 0;
            mirror_rabin_prime_test_busy <= 0;
            mirror_rabin_prime_test_isprime <= 0;
        end
        else begin
            if (b_n != mirror_rabin_prime_test_n ) begin
                mirror_rabin_prime_test_busy <= 1;
                cnt <= 0;
            end
            b_n <= mirror_rabin_prime_test_n;

            if (mirror_rabin_prime_test_busy) begin

                if ( mirror_rabin_prime_test_n == 1 || mirror_rabin_prime_test_n[0] == 0 ) begin
                    mirror_rabin_prime_test_isprime <= 0;
                    mirror_rabin_prime_test_busy <= 0;
                end
                else if ( mirror_rabin_prime_test_n == 2 ) begin
                    mirror_rabin_prime_test_isprime <= 1;
                    mirror_rabin_prime_test_busy <= 0;
                end
                else begin
                    if (cnt == 0) begin
                        preproc();
                    end
                    else if (1 <= cnt && cnt <= th + 1) begin
                        if( !rand_ch(mirror_rabin_prime_test_n) ) begin
                            mirror_rabin_prime_test_isprime <= 0;
                            mirror_rabin_prime_test_busy <= 0;
                        end
                    end
                    else begin
                        mirror_rabin_prime_test_isprime <= 1;
                        mirror_rabin_prime_test_busy <= 0;
                    end
                    cnt <= cnt + 1;
                end
            end
        end
    end


    task preproc;
        d = (mirror_rabin_prime_test_n - 1) >> 1;
        while (d[0] == 0) begin
            d >>= 1;
        end
    endtask

    function logic[0:0] rand_ch(input logic [mbit:0] n);
        a = randn % (n - 1) + 1;
        t = d;

        modpow_x = a;
        modpow_y = t;
        modpow_n = n;

        y = modpow_res;
        while (t != n - 1 && y != 1 && y != n - 1) begin
            y = (y * y) % n;
            t <<= 1;
        end
        if (y != n - 1 && t[0] == 0) begin
            return 0;
        end
        return 1;
    endfunction

endmodule