module display(row, col, red, green, blue, color, up, down, left, right, vnotactive, CLK, RST);
    input [9:0] row, col;
    input CLK, RST, color, up, down, left, right, vnotactive;
    output red, green, blue;
    reg red, green, blue;
    reg [9:0] originX, originY;
    reg [9:0] topX, topY;
    reg [9:0] endX, endY;
    reg [1:0] key_state;
    initial begin
        originX = 0;
        originY = 0;
        topX = 50;
        topY = 50;
        endX = 750;
        endY = 300;
    end



    always @(posedge CLK or negedge RST) begin
        if(!RST) begin
            red <= 1'b1;
            green <= 1'b1;
            blue <= 1'b1;
        end
        else begin
            if (row >= topX && row <= endX && col >= topY && col <= endY) begin
                if (1) begin
                        red <= 1'b1;
                        green <= 1'b1;
                        blue <= 1'b1;
                end
                else begin
                        red <= 1'b0;
                        green <= 1'b0;
                        blue <= 1'b0;
                end
            end
            else begin
                red <= 1'b0;
                green <= 1'b0;
                blue <= 1'b0;
            end
        end
    end
    /*
    always @(posedge CLK or negedge RST) begin
        if(!RST) begin
            originX <= 10'd300;
            originY <= 10'd200;
            key_state <= 2'd0;
        end
        else begin
            case(key_state)
                2'd0: begin
                    if(vnotactive) key_state <= 2'd1;
                end
                2'd1: begin
                    if(!up) originY <= originY - 10'd2;
                    else if(!down) originY <= originY + 10'd2;
                    if(!left) originX <= originX - 10'd2;
                    else if(!right) originX <= originX + 10'd2;
                    if(!up|!down|!left|!right) key_state <= 2'd2;
                    else if(!vnotactive) key_state <= 2'd0;
                end
                2'd2: begin
                    if(!vnotactive) key_state <= 2'd0;
                end
                2'd3: begin
                end
            endcase
        end
    end
    */
endmodule
