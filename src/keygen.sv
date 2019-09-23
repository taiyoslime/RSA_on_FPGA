module keygen #(
    parameter mbit = 63
)
(
    input logic clk,
    input logic rst,
    output logic [mbit:0] keygen_d;
);

    initial begin
        modpow_res = 0;
    end

    always @(posedge clk or negedge rst) begin
        if (!rst)
        begin
            modpow_res <= 0;
        end
        else
        begin
            modpow_res <= modpow_binary(modpow_x,modpow_y,modpow_n);
        end
    end

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


endmodule