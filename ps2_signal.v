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
   reg [43:0]                        fifo, buffer;
   reg                               ready;
   reg [5:0]                         counter;

   assign o_word1 = fifo[33 +: 11];
   assign o_word2 = fifo[22 +: 11];
   assign o_word3 = fifo[11 +: 11];
   assign o_word4 = fifo[0 +: 11];
   assign o_ready = ready;

   initial
     begin
        fifo <= 44'b0;
        buffer <= 44'b0;
        counter <= 6'b0;
        ready <= 1'b0;
     end

   always @(negedge i_PS2Clk)
     begin
        if(i_reset)
          begin
             buffer <= 44'b0;
             counter <= 6'b0;
             ready <= 1'b0;
          end
        else
          begin
             buffer <= {buffer, i_PS2Data};
             counter <= counter + 6'b1;

             case(counter)
               6'd43:
                 begin
                    ready <= 1'b1;
                    counter <= 6'b0;
                 end
               6'd0:
                 ready <= 1'b0;
             endcase // case (counter)
          end // else: !if(i_reset)
     end // always @ (negedge i_clk)

   always @(posedge i_clk)
     if(i_reset)
       fifo <= 44'b0;
     else if(ready)
       fifo <= buffer;

endmodule
