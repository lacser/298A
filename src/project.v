/*
 * Copyright (c) 2026 Yaron Jing
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module counter (
    input  wire       clk,
    input  wire       reset_n,
    input  wire [7:0] count,
    input  wire       load,
    input  wire       enable,

    output wire [7:0] counter_value
);

    reg [7:0] counter_reg;

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            counter_reg <= 8'd0;
        else if (load)
            counter_reg <= count;
        else if (enable)
            counter_reg <= counter_reg + 8'd1;
    end

    assign counter_value = enable ? counter_reg : 8'bzzzz_zzzz;

endmodule
