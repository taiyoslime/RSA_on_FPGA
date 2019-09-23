module extgcd #(
    parameter mbit = 63
)
(
    input logic clk,
    input logic rst,
    input logic signed [mbit:0] extgcd_e,
    input logic signed [mbit:0] extgcd_phi,
    output logic signed [mbit:0] extgcd_res
);

    initial begin
        extgcd_res = 0;
    end

    always @(posedge clk or negedge rst) begin
        if (!rst)
        begin
            extgcd_res <= 0;
        end
        else
        begin
            extgcd_res <= extgcd(extgcd_e, extgcd_phi);
        end
    end

    function logic signed [mbit:0] extgcd (input logic signed [mbit:0] e, input logic signed [mbit:0] phi);
        logic signed [mbit:0] p_d;
        logic signed [mbit:0] d;
        logic signed [mbit:0] p_k;
        logic signed [mbit:0] k;
        logic signed [mbit:0] q;
        logic signed [mbit:0] tmp;
        p_d = 1;
        d = 0;
        p_k = 0;
        k = 1;
        q = 0;
        tmp = 0;
        while (phi != 0) begin
            q = e / phi;
            tmp = d;
            d = p_d - q * d;
            p_d = tmp;
            tmp = k;
            k = p_k - q * k;
            p_k = tmp;
            tmp = e;
            e = phi;
            phi = tmp % phi;
        end
        return p_d;
    endfunction

endmodule