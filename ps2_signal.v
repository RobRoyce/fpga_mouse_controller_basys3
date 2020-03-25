`timescale 1ns / 1ps

module ps2_signal(
                  input wire         i_clk,
                  input wire         i_reset,
                  input wire         i_PS2Clk,
                  input wire         i_PS2Data,
                  output wire [10:0] o_word1,
                  output wire [10:0] o_word2,
                  output wire [10:0] o_word3,
                  output wire [10:0] o_word4,
                  output wire        o_ready
                  );
   reg [43:0]                        fifo,
                                     buffer;
   reg [5:0]                         counter;
   reg [1:0]                         PS2Clk_sync;
   reg                               ready,
                                     PS2Data;
   wire                              PS2Clk_negedge;

   assign o_word1 = fifo[33 +: 11];
   assign o_word2 = fifo[22 +: 11];
   assign o_word3 = fifo[11 +: 11];
   assign o_word4 = fifo[0 +: 11];
   assign o_ready = ready;
   assign PS2Clk_negedge = (PS2Clk_sync == 2'b10);

   initial
     begin
        fifo <= 44'b0;
        buffer <= 44'b0;
        counter <= 6'b0;
        PS2Clk_sync <= 2'b1;
        ready <= 1'b0;
        PS2Data <= 1'b0;
     end // initial begin


   always @(posedge i_clk)
     begin
        if(i_reset)
          begin
             fifo <= 44'b0;
             buffer <= 44'b0;
             counter <= 6'b0;
             ready <= 1'b0;
             PS2Clk_sync <= 2'b1;
             PS2Data <= 1'b0;
          end
        else
          begin
             PS2Clk_sync <= {PS2Clk_sync[0], i_PS2Clk};
             PS2Data <= i_PS2Data;

             if(PS2Clk_negedge)
               begin
                  buffer <= {buffer, PS2Data};
                  counter <= counter + 6'b1;
               end

             if(counter == 6'd44)
               begin
                  fifo = buffer;
                  buffer = 44'b0;
                  counter = 6'b0;
                  ready = 1'b1;
               end
             else
               begin
                  ready <= 1'b0;
                  fifo <= 44'b0;
               end
          end
     end
endmodule
