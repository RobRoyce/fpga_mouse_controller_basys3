`timescale 1ns / 1ps


module ps2_mouse(
                 input wire        i_clk,
                 input wire        i_reset,
                 input wire        i_PS2Data,
                 input wire        i_PS2Clk,
                 output wire [7:0] o_x,
                 output wire       o_x_ov,
                 output wire       o_x_sign,
                 output wire [7:0] o_y,
                 output wire       o_y_ov,
                 output wire       o_y_sign,
                 output wire       o_r_click,
                 output wire       o_l_click,
                 output wire       o_valid
                 );
   // Top level module that takes in the raw PS2 signal (clock and data) and
   // transforms them into actionable signals.


   wire [10:0]                     word1, word2, word3, word4;
   wire [7:0]                      signal1, signal2, signal3, signal4;
   wire                            valid, ready;

   assign o_valid = ready && valid;

   // signal processing -> validation -> map to output
   //----------------------------------------------------------------------
   ps2_signal ps2_signal(
                         .i_clk(i_clk),
                         .i_reset(i_reset),
                         .i_PS2Clk(i_PS2Clk),
                         .i_PS2Data(i_PS2Data),
                         .o_word1(word1),
                         .o_word2(word2),
                         .o_word3(word3),
                         .o_word4(word4),
                         .o_ready(ready)
                         );
   //----------------------------------------------------------------------
   ps2_validator ps2_validator(
                               .i_word1(word1),
                               .i_word2(word2),
                               .i_word3(word3),
                               .i_word4(word4),
                               .o_signal1(signal1),
                               .o_signal2(signal2),
                               .o_signal3(signal3),
                               .o_signal4(signal4),
                               .o_valid(valid)
                               );

   //----------------------------------------------------------------------
   ps2_mouse_map ps2_mouse_map(
                               .i_clk(i_clk),
                               .i_reset(i_reset),
                               .i_signal1(signal1),
                               .i_signal2(signal2),
                               .i_signal3(signal3),
                               .i_signal4(signal4),
                               .o_x(o_x),
                               .o_y(o_y),
                               .o_x_overflow(o_x_ov),
                               .o_y_overflow(o_y_ov),
                               .o_x_sign(o_x_sign),
                               .o_y_sign(o_y_sign),
                               .o_l_click(o_l_click),
                               .o_r_click(o_r_click)
                               );
endmodule
