/*
 * Copyright (c) 2026 Yaron Jing
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

// Tiny Tapeout interface: ui_in = load value, uio_in[0] = load,
// uio_in[1] = count enable, uo_out = current count.
module tt_um_counter (
    input  wire [7:0] ui_in,
    output wire [7:0] uo_out,
    input  wire [7:0] uio_in,
    output wire [7:0] uio_out,
    output wire [7:0] uio_oe,
    input  wire       ena,
    input  wire       clk,
    input  wire       rst_n
);

    // All bidirectional pins are inputs; never drive them.
    assign uio_out = 8'b0;
    assign uio_oe = 8'b0;

    counter counter_inst (
        .clk(clk),
        .reset_n(rst_n),
        .count(ui_in),
        .load(ena & uio_in[0]),
        .enable(ena & uio_in[1]),
        .counter_value(uo_out)
    );

    wire _unused = &{uio_in[7:2], 1'b0};

endmodule

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

    // Dedicated outputs always drive a defined value, even when disabled.
    assign counter_value = counter_reg;

endmodule
