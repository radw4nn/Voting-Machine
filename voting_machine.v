module voting_machine #(
    parameter idle =  2'b00,                  // State encoding: Idle state
    parameter vote =  2'b01,                  // State encoding: Voting state
    parameter hold =  2'b10,                  // State encoding: Hold state
    parameter finish = 2'b11                  // State encoding: Finish state
)(
    input clk,                              // Clock input
    input rst,                              // Reset input (active high)
    input i_candidate_1,                    // Input to vote for candidate 1
    input i_candidate_2,                    // Input to vote for candidate 2
    input i_candidate_3,                    // Input to vote for candidate 3
    input i_voting_over,                    // Input high when voting is over

    output reg [31:0] o_count1,             // Output showing total votes for candidate 1
    output reg [31:0] o_count2,             // Output showing total votes for candidate 2
    output reg [31:0] o_count3              // Output showing total votes for candidate 3
);  

// Internal registers to store previous values of inputs
reg [31:0] r_cand1_prev;                    // Store previous value of candidate 1 input
reg [31:0] r_cand2_prev;                    // Store previous value of candidate 2 input
reg [31:0] r_cand3_prev;                    // Store previous value of candidate 3 input

// Internal registers to count votes for each candidate
reg [31:0] r_counter_1;                     // Counter for votes for candidate 1
reg [31:0] r_counter_2;                     // Counter for votes for candidate 2
reg [31:0] r_counter_3;                     // Counter for votes for candidate 3

// State registers
reg [1:0] r_present_state, r_next_state;    // Registers for the current and next state
reg [3:0] r_hold_count;                    // Counter for the hold state

//////////// Always block for state transitions and internal register updates ///////////////
always @(posedge clk or negedge rst) begin
    if (!rst) begin                         // Asynchronous reset
        r_next_state <= vote;               // Transition to the voting state when reset is low
        r_counter_1 <= 32'b0;               // Reset counters
        r_counter_2 <= 32'b0;
        r_counter_3 <= 32'b0;
        r_hold_count <= 4'b0000;            // Reset the hold counter
    end else begin
        case (r_present_state)
            idle: begin
                r_next_state <= vote;       // Transition to the voting state from idle
            end

            vote: begin
                if (i_voting_over) begin     // Check if voting is over
                    r_next_state <= finish; // Transition to the finish state
                end else begin
                    // Detect falling edge to count votes
                    if (i_candidate_1 == 1'b0 && r_cand1_prev == 1'b1) begin
                        r_counter_1 <= r_counter_1 + 1'b1; // Increment the counter for candidate 1
                        r_next_state <= hold;             // Transition to the hold state
                    end else if (i_candidate_2 == 1'b0 && r_cand2_prev == 1'b1) begin
                        r_counter_2 <= r_counter_2 + 1'b1; // Increment the counter for candidate 2
                        r_next_state <= hold;             // Transition to the hold state
                    end else if (i_candidate_3 == 1'b0 && r_cand3_prev == 1'b1) begin
                        r_counter_3 <= r_counter_3 + 1'b1; // Increment the counter for candidate 3
                        r_next_state <= hold;             // Transition to the hold state
                    end else begin
                        r_next_state <= vote;           // Continue counting votes
                    end
                end
            end

            hold: begin
                if (i_voting_over) begin         // Check if voting is over
                    r_next_state <= finish;     // Transition to the finish state
                end else begin
                    if (r_hold_count != 4'b1111) begin
                        r_hold_count <= r_hold_count + 1'b1; // Increment the hold counter
                    end else begin
                        r_next_state <= vote; // Transition back to the voting state
                    end
                end
            end

            finish: begin
                if (!i_voting_over) begin       // Check if voting is not over
                    r_next_state <= idle;     // Transition to the idle state
                end else begin
                    r_next_state <= finish;   // Remain in the finish state
                end
            end

            default: begin
                // Default case: reset all registers
                r_counter_1 <= 32'b0;
                r_counter_2 <= 32'b0;
                r_counter_3 <= 32'b0;
                r_hold_count <= 4'b0000;
                r_next_state <= idle;       // Default to the idle state
            end
        endcase
    end
end

//////////// Always block for updating outputs and state assignments //////////////////////
always @(posedge clk or negedge rst) begin
    if (rst) begin
        r_present_state <= idle;            // Stay in the idle state when reset is high
        o_count1 <= 32'b0;                  // Reset output counts
        o_count2 <= 32'b0;
        o_count3 <= 32'b0;
        r_hold_count <= 4'b0000;            // Reset hold counter
    end else begin
        if (i_voting_over) begin             // If voting is over
            o_count1 <= r_counter_1;        // Output the count for candidate 1
            o_count2 <= r_counter_2;        // Output the count for candidate 2
            o_count3 <= r_counter_3;        // Output the count for candidate 3
        end
        r_present_state <= r_next_state;    // Update the current state to the next state
        r_cand1_prev <= i_candidate_1;      // Update previous values of inputs
        r_cand2_prev <= i_candidate_2;
        r_cand3_prev <= i_candidate_3;
    end
end

endmodule
