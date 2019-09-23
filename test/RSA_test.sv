module RSA_test();
    logic clk, rst;
    logic [63:0] dbg;

    RSA RSA_instance(clk, rst, dbg);

    // clock
    initial begin
        clk = 1;
        forever #5  clk = ~clk;
    end

    // reset
    initial begin
        rst = 1;
        #5000  rst= 0;
    end

    initial begin
        #5000 $finish();
    end

    //
    always @(posedge clk) begin
        //$write("[%t] message: %d\n", $time, dbg);
        $write("[%t]", $time);
    end

endmodule