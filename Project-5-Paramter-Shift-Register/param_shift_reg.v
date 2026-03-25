module param_shift_reg
#(
    parameter SHIFT_WIDTH = 8,
    parameter SHIFT_DIRECTION = "LEFT",
    parameter LOAD_AVALUE = 1,
    parameter LOAD_SVALUE = 1
)
(
    sclr, sset, shiftin, load, data, clk, enable, aclr, aset, shiftout, q
);

input sclr, sset, shiftin, load, data, clk, enable, aclr, aset;
input [SHIFT_WIDTH-1:0] data;

output shiftout;
output reg [SHIFT_WIDTH-1:0] q;

assign shiftout = (SHIFT_DIRECTION == "LEFT") ? q[SHIFT_WIDTH-1] : q[0];

always @(posedge clk or posedge aclr or posedge aset) begin

    if (aclr) begin
        q <= {SHIFT_WIDTH{1'b0}} + LOAD_SVALUE;
    end

    else if (aset) begin
        q <= {SHIFT_WIDTH{1'b0}} + LOAD_AVALUE;
    end

    else if (enable) begin

        if (sclr) begin
            q <= {SHIFT_WIDTH{1'b0}} + LOAD_AVALUE;
        end

        else if (sset) begin
            q <= {SHIFT_WIDTH{1'b0}} + LOAD_SVALUE;
        end

        else if (load) begin
            q <= data;
        end

        else begin
            case (SHIFT_DIRECTION)
                "LEFT":  q <= {q[SHIFT_WIDTH-2:0], shiftin};
                "RIGHT": q <= {shiftin, q[SHIFT_WIDTH-1:1]};
            endcase
        end

    end

end

endmodule
