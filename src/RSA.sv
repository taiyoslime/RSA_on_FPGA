module RSA(
    input logic clk,
    input logic rst,
    output logic [63:0] dbg
);
    parameter int mbit =  63;
    parameter int mbit_h = 31;
    logic [mbit:0] clk_cnt;
    logic [mbit:0] randn;
    logic [mbit:0] modpow_x;
    logic [mbit:0] modpow_y;
    logic [mbit:0] modpow_n;
    logic [mbit:0] modpow_res;
    logic modpow_busy;
    logic signed [mbit:0] extgcd_e;
    logic signed [mbit:0] extgcd_phi;
    logic signed [mbit:0] extgcd_res;
    logic [mbit:0] mirror_rabin_prime_test_n = 0;
    logic mirror_rabin_prime_test_isprime;
    logic mirror_rabin_prime_test_busy;


    // for demonstration

    logic [mbit:0] e = 65537;
    logic [mbit:0] d = 1567911045903664193;
    logic [mbit:0] m = 180691;
    logic [mbit:0] N = 4275095120893583027 ;
    logic [mbit:0] c = 992274341492776796;
    //int seg_int [8]  = '{0,0,0,0,0,0,0,0};
    logic d_decode_busy;
    logic [mbit:0] disp_n;

    initial begin
        dbg = 0;
        clk_cnt = 0;
        modpow_x = 0;
        modpow_y = 0;
        modpow_n = 0;
        $write("\n\n\n\n");
        //$write("m: %d e : %d \n",m,e);
        $write("d:%d N:%d\n",d,N );
        $write("\n" );

        $write("input \n" );
        $write("c: %d\n", c);
    end


    always @(posedge clk or negedge rst) begin
        if (!rst)
        begin
            clk_cnt <= 0;
        end
        else
        begin
            modpow_x <= c;
            modpow_y <= d;
            modpow_n <= N;

            if (modpow_busy == 1) begin
                $write("busy\n");
            end
            else begin
                $write("result : %d \n", modpow_res);
                $write("\n");
            end

            //mirror_rabin_prime_test_n <= 10007;
            //disp_n <= 1022;
            //zdbg <= modpow_res;
            //dbg <= mirror_rabin_prime_test_isprime;
            clk_cnt <= clk_cnt + 1;

        end
    end
    //random #(mbit) random_inst(.seed(clk_cnt),  .*);
    modpow #(mbit) modpow_inst(.*);
    //extgcd #(mbit) exgcd_inst(.*);
    //mirror_rabin_prime_test #(mbit) mirror_rabin_prime_test(.*);
    //d_decode #(mbit) d_decode_inst(.*);


endmodule