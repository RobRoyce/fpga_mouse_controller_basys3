`timescale 1ns / 1ps

module ps2_mouse_map(
                     input wire        i_clk,
                     input wire        i_reset,
                     input wire [7:0]  i_signal1,
                     input wire [7:0]  i_signal2,
                     input wire [7:0]  i_signal3,
                     input wire [7:0]  i_signal4,
                     output wire [7:0] o_x,
                     output wire [7:0] o_y,
                     output wire       o_x_sign,
                     output wire       o_y_sign,
                     output wire       o_l_click,
                     output wire       o_r_click,
                     output wire       o_x_overflow,
                     output wire       o_y_overflow
                     );
   // This module takes the 8-bit words (after they have been validated) and
   // converts them into cohesive signals that can be operated on. Output names
   // are indicative of the mappings. Note that other signals of importance may
   // not be accounted for here. Namely, the Microsoft Intellimouse type
   // extension for supporting a scroll wheel mouse. This may be added in the
   // future (feel free to open a PR).

   assign o_x = i_signal2;
   assign o_y = i_signal3;
   assign {o_x_overflow, o_y_overflow} = i_signal1[1:0];
   assign {o_x_sign, o_y_sign} = i_signal1[3:2];
   assign {o_l_click, o_r_click} = i_signal1[7:6];
endmodule
