ghdl -i --workdir=work --std=08 *.vhdl
ghdl -m --workdir=work --std=08 alu_tb
ghdl -r --workdir=work --std=08 alu_tb --wave=wave.ghw --assert-level=note
# gtkwave wave.ghw