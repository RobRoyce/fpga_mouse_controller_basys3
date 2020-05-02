`timescale 1ns / 1ps

module ps2_validator(
                     input wire [10:0] i_word1,
                     input wire [10:0] i_word2,
                     input wire [10:0] i_word3,
                     input wire [10:0] i_word4,
                     output wire [7:0] o_signal1,
                     output wire [7:0] o_signal2,
                     output wire [7:0] o_signal3,
                     output wire [7:0] o_signal4,
                     output wire       o_valid
                     );
   // Provides (imperfect) validation of the PS2 signal. This is done by
   // checking for parity and ensuring the start and stop bits are correct. If
   // either of these cases fail to occur, the 'valid' output will be 0. Note
   // that this is entirely combinational.


   wire                                parity1, parity2, parity3, parity4, parity;
   wire                                start1, start2, start3, start4, start;
   wire                                stop1, stop2, stop3, stop4, stop;
   wire                                valid1, valid2, valid3, valid4;

   // Separate packets into segments
   assign {start1, o_signal1, parity1, stop1} = i_word1;
   assign {start2, o_signal2, parity2, stop2} = i_word2;
   assign {start3, o_signal3, parity3, stop3} = i_word3;
   assign {start4, o_signal4, parity4, stop4} = i_word4;

   // XNOR words together and compare to parity bit
   assign valid1 = ~^o_signal1 == parity1;
   assign valid2 = ~^o_signal2 == parity2;
   assign valid3 = ~^o_signal3 == parity3;
   assign valid4 = ~^o_signal4 == parity4;

   assign parity = valid1 && valid2 && valid3 && valid4;
   assign start = (!start1 && !start2 && !start3 && !start4);
   assign stop = (stop1 && stop2 && stop3 && stop4);
   assign o_valid = (start && stop && parity);

endmodule
