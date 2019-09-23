module RSA(
    input logic clk,
    input logic rst,

    input logic btn,
    output bit [7:0] seg [8]
);
    logic [63:0] clk_cnt;
    logic [mbit:0] dbg;
    logic [0:0] btn_flag;
    parameter logic [7:0] seg_num [0 : 9] = '{
        8'b00111111,
        8'b00000110,
        8'b01011011,
        8'b01001111,
        8'b01100110,
        8'b01101101,
        8'b01111101,
        8'b00000111,
        8'b01111111,
        8'b01101111
    };
    parameter int mbit_h = 31;
    parameter int e = 65537;
    /*
    task print_seg(input logic [mbit:0] n);
    begin
        for(int i = 0; i < 7; i++)


    end
    endtask
    */

    function logic [mbit:0] xorshift64(input logic [mbit:0] seed);
        if (seed == 0) begin
            seed = seed + 1;
        end
        xorshift64 = seed;
        xorshift64 = xorshift64 ^ (xorshift64 << 13);
        xorshift64 = xorshift64 ^ (xorshift64 >> 17);
        xorshift64 = xorshift64 ^ (xorshift64 << 5);
    endfunction


    function logic [mbit_h:0] xorshift32(input logic [mbit_h:0] seed);
        if (seed == 0) begin
            seed = seed + 1;
        end
        xorshift32 = seed;
        xorshift32 = xorshift32 ^ (xorshift32 << 13);
        xorshift32 = xorshift32 ^ (xorshift32 >> 7);
        xorshift32 = xorshift32 ^ (xorshift32 << 17);
    endfunction

    function logic [mbit:0] rand64(input logic [mbit:0] seed);
        return xorshift64(seed);
    endfunction

    function logic [mbit_h:0] rand32(input logic [mbit_h:0] seed);
        return xorshift32(seed);
    endfunction


    function logic [mbit:0] seed_gen();
        return clk_cnt;
    endfunction

    initial begin
        btn_flag = 1;
    end

    always @(posedge clk or negedge rst) begin
        if (!rst)
        begin
                dbg <= 0;
                clk_cnt <= 0;
        end
        else
        begin
            if (!btn && btn_flag) begin
                dbg <= extgcd(7,11) + 5;
                $display(extgcd(7,11));
                btn_flag <= 0;
            end
            else if (btn) begin
                btn_flag <= 1;
            end
            clk_cnt <= clk_cnt + 1;

        end
    end

/*
    genvar i;
    generate
        for (i = 0; i < 8; i++ ) begin : seg_attach
            assign seg[i] = seg_num[dbg[i]];
        end
    endgenerate
*/

    function logic [mbit:0] modpow_binary(input logic [mbit:0] x, input logic [mbit:0] y, input logic [mbit:0] n);
        modpow_binary = 1;
        while(y > 0) begin
            modpow_binary = (modpow_binary * modpow_binary) % n;
            if (y[0] == 1'b1) begin
                modpow_binary = (modpow_binary * x) % n;
            end
            y = y >> 1;
        end
        return modpow_binary;
    endfunction

    function logic [mbit:0] modpow(input logic [mbit:0] x, input logic [mbit:0] y, input logic [mbit:0] n);
        return modpow_binary(x,y,n);
    endfunction

    function logic signed [mbit:0] extgcd (input logic [mbit:0] e, input logic [mbit:0] phi);
        logic signed [mbit:0] d = 0;
        logic signed [mbit:0] k = 1;
        logic signed [mbit:0] _d = 1;
        logic signed [mbit:0] _k = 0;
        logic signed [mbit:0] q = 0;
        while (d != 0) begin
            q = e / phi;
            phi = e;
            e = phi % e;
            k = _k;
            _k = k - q * _k;
            d = _d;
            _d = d - q * _d;
        end
        return d;
    endfunction


    function logic[0:0] mirror_rabin_prime_test(input logic [mbit_h:0] n);
        logic [mbit_h:0] a;
        logic [mbit_h:0] t;
        logic [mbit_h:0] y;
        logic [mbit:0] d;

        if ( n == 2 ) begin
                return 0;
        end
        if ( n == 1 || (n & 1 == 0 )) begin
                return 0;
        end

        d = (n - 1) >> 1;
        while (d[0] == 0) begin
            d >>= 1;
        end

        for(int i = 0; i < 20 ; i ++) begin
            a = rand32(seed_gen());
            t = d;
            y = modpow(a, t, n);

            while (t != n - 1 & y != 1 & y != n - 1) begin
                y = (y * y) % n;
                t <<= 1;
            end


            if (y != n - 1 & t[0] == 0) begin
                return 0;
            end
        end
        return 1;
    endfunction

    function logic[0:0] is_prime(input logic [mbit:0] n);
        return mirror_rabin_prime_test(n);
    endfunction


    function logic [mbit_h:0] prime32_gen();
        do begin
            prime32_gen = rand32(seed_gen());
            prime32_gen[mbit_h - 1] = 1;
            prime32_gen[0] = 1;
        end while(!is_prime(prime32_gen));
        return prime32_gen;
    endfunction

    function [mbit:0] private_key_gen();
        logic [mbit_h:0] p = prime32_gen();
        logic [mbit_h:0] q = prime32_gen();
        logic [mbit:0] n = p * q;
        logic [mbit:0] phi = (p - 1) * ( q - 1 );
        logic signed [mbit:0] d = extgcd(e, phi);
        if (d < 0) begin
            d += phi;
        end
        private_key_gen = d;
    endfunction

    function logic [mbit:0] encrypt(input logic [mbit:0] m, input logic [mbit:0] e, input logic [mbit:0] n);
        return modpow(m,e,n);
    endfunction

    function logic [mbit:0] decrypt(input logic [mbit:0] c, input logic [mbit:0] d, input logic [mbit:0] n);
        return modpow(c,d,n);
    endfunction

endmodule