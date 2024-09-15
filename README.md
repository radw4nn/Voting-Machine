# Voting Machine with Verilog 🎛🏛️️

## Overview 🌟

This Verilog module implements a simple voting machine that counts votes for three candidates. The module includes state management to handle voting, holding, and finishing states. It provides outputs for the total number of votes for each candidate.

## Module Description 📋

The `voting_machine` module has the following features:

- **States**:
  - `idle` 🕒: Initial state where the module waits for the voting process to start.
  - `vote` ✅: State where votes are counted for each candidate.
  - `hold` ⏳: State where the module waits for a short period before transitioning back to voting or finishing.
  - `finish` 🎉: State where the final vote counts are output after the voting is over.

- **Inputs**:
  - `clk` 🕰️: Clock input.
  - `rst` 🔄: Reset input (active high).
  - `i_candidate_1` 🗳️: Input to vote for candidate 1.
  - `i_candidate_2` 🗳️: Input to vote for candidate 2.
  - `i_candidate_3` 🗳️: Input to vote for candidate 3.
  - `i_voting_over` 🚦: Input high when the voting process is complete.

- **Outputs**:
  - `o_count1` 📊: Output showing the total votes for candidate 1.
  - `o_count2` 📊: Output showing the total votes for candidate 2.
  - `o_count3` 📊: Output showing the total votes for candidate 3.

## Parameters ⚙️

- `idle` 🕰️: State encoding for idle state (`2'b00`).
- `vote` 🗳️: State encoding for voting state (`2'b01`).
- `hold` ⏳: State encoding for hold state (`2'b10`).
- `finish` 🎉: State encoding for finish state (`2'b11`).

## Internal Registers 🛠️

- `r_cand1_prev`, `r_cand2_prev`, `r_cand3_prev`: Registers to store previous values of candidate inputs.
- `r_counter_1`, `r_counter_2`, `r_counter_3`: Registers to count votes for each candidate.
- `r_present_state`, `r_next_state`: Registers to store the current and next state.
- `r_hold_count`: Counter used in the hold state.

## Functionality 🔍

1. **State Transitions**:
   - The module transitions between states based on the current state and input signals.
   - In the `idle` 🕒 state, it waits for the reset signal to start the voting process.
   - In the `vote` ✅ state, it counts votes for each candidate and transitions to the `hold` ⏳ state if a vote is detected.
   - In the `hold` ⏳ state, it waits for a brief period before returning to the `vote` ✅ state or transitioning to the `finish` 🎉 state if voting is over.
   - In the `finish` 🎉 state, it outputs the final vote counts and remains in this state until the voting process is reset.

2. **Vote Counting**:
   - The module detects falling edges of candidate inputs to count individual votes.
   - Vote counts are updated in the `vote` ✅ state and are output in the `finish` 🎉 state.

## Usage 🚀

To use this module in a larger design:

1. **Instantiate the Module**:
   ```verilog
   voting_machine uut (
       .clk(clk),
       .rst(rst),
       .i_candidate_1(candidate_1),
       .i_candidate_2(candidate_2),
       .i_candidate_3(candidate_3),
       .i_voting_over(voting_over),
       .o_count1(count1),
       .o_count2(count2),
       .o_count3(count3)
   );
