ghdl -i --workdir=work *.vhdl
ghdl -m --workdir=work alu_tb
ghdl -r --workdir=work alu_tb --wave=wave.ghw --assert-level=note --ieee-asserts=disable
gtkwave wave.ghw