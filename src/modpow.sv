// vulnerable
module modpow #(
    parameter mbit = 63
)
(
    input logic clk,
    input logic rst,
    input int clk_cnt,
    input logic [mbit:0] modpow_x,
    input logic [mbit:0] modpow_y,
    input logic [mbit:0] modpow_n,
    output logic [mbit:0] modpow_res,
    output logic modpow_busy
);

    logic [mbit:0] x;
    logic [mbit:0] y;
    logic [mbit:0] n;
    logic [mbit:0] m_b;


    initial begin
        modpow_res = 0;
        x = 0;
        y = 0;
        n = 0;
        m_b = 1;
        modpow_busy = 0;
    end

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            modpow_res <= 0;
            x <= 0;
            y <= 0;
            n <= 0;
            m_b <= 1;
            modpow_busy <= 0;
        end
        else begin


            if (!modpow_busy) begin
                if (x != modpow_x || y != modpow_y || n != modpow_n) begin
                     modpow_busy <= 1;
                     m_b <= 1;
                end

                 x <= modpow_x;
                 y <= modpow_y;
                 n <= modpow_n;
            end


            if (modpow_busy) begin
                $write("%d %d %d %d\n", m_b, x, y, n);
                if (y == 0) begin
                    modpow_res <= m_b;
                    modpow_busy <= 0;
                end
                else begin
                    if (clk_cnt[0] == 0) begin
                        proc();
                    end
                    else begin
                        proc2();
                    end
                end
            end
        end
    end

    task proc;
        if (y[0] == 1'b1) begin
            m_b <= (m_b * x) % n;
        end
    endtask

    task proc2;
        x <= (x * x) % n;
        y <= y >> 1;
    endtask

endmodule