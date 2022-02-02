# ZephyrALU
A basic ALU implementation based on the design described by [Charles' Labs](http://www.charleslabs.fr/en/project-A+basic+VHDL+processor).

While the general design is the same, some changes have been made. Specifically, the OutSel bit in the instruction has been removed in favor of having specific GET instructions for each register.