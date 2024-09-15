`include "voting_machine.v"                     // Include statement for iverilog simulation; remove this line for other simulators
`timescale 1ns/1ns                             // Time unit and time precision set to 1 ns

module tb_voting_machine ();
reg t_clk;
reg t_rst;
reg t_candidate_1;
reg t_candidate_2;
reg t_candidate_3;
reg t_vote_over;

wire [5:0] t_result_1;
wire [5:0] t_result_2;
wire [5:0] t_result_3;

// Instantiate the voting machine unit under test
voting_machine uut ( 
    .clk(t_clk), 
    .rst(t_rst), 
    .i_candidate_1(t_candidate_1), 
    .i_candidate_2(t_candidate_2), 
    .i_candidate_3(t_candidate_3), 
    .i_voting_over(t_vote_over),
    .o_count1(t_result_1),
    .o_count2(t_result_2),
    .o_count3(t_result_3)
);

// Initialize clock signal
initial t_clk = 1'b1;

// Generate clock signal with a period of 10 ns
always
begin
    #5 t_clk = ~t_clk;     
end

// Apply stimulus to the design
initial
begin
    $monitor ("time = %d, rst = %b, candidate_1 = %b, candidate_2 = %b, candidate_3 = %b, vote_over = %b, result_1 = %3d, result_2 = %3d, result_3 = %3d,\n",
    $time, t_rst, t_candidate_1, t_candidate_2, t_candidate_3, t_vote_over, t_result_1, t_result_2, t_result_3);

    // Reset all inputs and outputs
    t_rst = 1'b1;
    t_candidate_1 = 1'b0;
    t_candidate_2 = 1'b0;
    t_candidate_3 = 1'b0;
    t_vote_over = 1'b0;

    // Release reset
    #20 t_rst = 1'b0;
    
    // Simulate button presses for each candidate
    #10 t_candidate_1 = 1'b1;              // Press button for candidate 1
    #10 t_candidate_1 = 1'b0;              // Release button for candidate 1

    #20 t_candidate_2 = 1'b1;              // Press button for candidate 2
    #10 t_candidate_2 = 1'b0;              // Release button for candidate 2

    #20 t_candidate_1 = 1'b1;              // Press button for candidate 1
    #10 t_candidate_1 = 1'b0;              // Release button for candidate 1

    #20 t_candidate_3 = 1'b1;              // Press button for candidate 3
    #10 t_candidate_3 = 1'b0;              // Release button for candidate 3
  
    #20 t_candidate_2 = 1'b1;              // Press button for candidate 2
    #10 t_candidate_2 = 1'b0;              // Release button for candidate 2

    #20 t_candidate_2 = 1'b1;              // Press button for candidate 2
    #10 t_candidate_2 = 1'b0;              // Release button for candidate 2
    
    #20 t_candidate_1 = 1'b1;              // Press button for candidate 1
    #10 t_candidate_1 = 1'b0;              // Release button for candidate 1
    
    #20 t_candidate_3 = 1'b1;              // Press button for candidate 3
    #10 t_candidate_3 = 1'b0;              // Release button for candidate 3

    #30 t_vote_over = 1'b1;               // Set vote_over to indicate end of voting

    #50 t_rst = 1'b1;                     // Assert reset after voting is complete
    
    // Use $stop to pause simulation; replace with $finish for other simulators
    #60 $stop;                            // Use $stop for ModelSim; use $finish for other simulators
end

// Generate VCD file for GTKWave waveform viewer
initial
begin
    $dumpfile ("voting_dumpfile.vcd");
    $dumpvars (0, tb_voting_machine);
end

endmodule
