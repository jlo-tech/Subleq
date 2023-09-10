module CONTROLLER (clk, selop, awe, bwe, ramwe, pcwe);

input clk;
output reg selop, awe, bwe, ramwe, pcwe;

reg [1:0] state = 0;

initial begin
    selop = 0;
    awe = 0;
    bwe = 0;
    ramwe = 0;
    pcwe = 0;
end

always @(posedge clk) begin

    /* Set signals appropriately */
    case (state)
        0: begin
            selop <= 0;
            awe <= 1;
            bwe <= 0;
            ramwe <= 0;
            pcwe <= 0;
        end
        1: begin
            selop <= 1;
            awe <= 0;
            bwe <= 1;
            ramwe <= 0;
            pcwe <= 0;
        end
        2: begin
            selop <= 0;
            awe <= 0;
            bwe <= 0;
            ramwe <= 1;
            pcwe <= 0;
        end

        3: begin
            selop <= 0;
            awe <= 0;
            bwe <= 0;
            ramwe <= 0;
            pcwe <= 1;
        end 
    endcase

    /* Next state */
    state = state + 1;

end

endmodule

`ifdef TEST
module tb_CONTROLLER;

reg clk;
wire selop, awe, bwe, ramwe, pcwe;

CONTROLLER dut (clk, selop, awe, bwe, ramwe, pcwe);

integer i;

initial begin

    $dumpfile("trace_controller.vcd");
    $dumpvars(0, dut);

    for (i = 0; i < 8; i++) begin

        clk = 0;
        #1;

        clk = 1;
        #1;
    end
end

endmodule
`endif