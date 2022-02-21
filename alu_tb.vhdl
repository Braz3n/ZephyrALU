use work.aluConstants.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--  A testbench has no ports.
entity alu_tb is
end alu_tb;
    
architecture behavioural of alu_tb is
    --  Declaration of the component that will be instantiated.
    component alu
    port (
        rst         : in    std_logic; 
        clk         : in    std_logic; 
        opCode      : in    std_logic_vector (aluOpCodeWidth-1 downto 0);
        dataBus     : inout std_logic_vector (aluRegisterWidth-1 downto 0);
        flgBus      : out std_logic_vector (aluRegisterWidth-1 downto 0)
    );
    end component;

    --  Specifies which entity is bound with the component.
    for alu_UUT: alu use entity work.alu;

    signal rst        : std_logic; 
    signal clk        : std_logic; 
    signal opCode     : std_logic_vector (aluOpCodeWidth-1 downto 0);
    signal dataBus    : std_logic_vector (aluRegisterWidth-1 downto 0);
    signal flgBus     : std_logic_vector (aluRegisterWidth-1 downto 0);
    signal test_index : integer range 0 to 64;
begin
    -- Component instantiation.
    alu_UUT : alu port map 
    (
        rst => rst,
        clk => clk,
        opCode => opCode,
        dataBus => dataBus,
        flgBus => flgBus
    );

    -- Clock process.
    process 
    begin 
        clk <= '0';
        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;
    end process;

    -- Actual working process block.
    process
        type test_pattern_type is record
            rst      : std_logic; 
            opCode   : std_logic_vector (aluOpCodeWidth-1 downto 0);
            dataBus  : std_logic_vector (aluRegisterWidth-1 downto 0);
            flgBus   : std_logic_vector (aluRegisterWidth-1 downto 0);
        end record;
        
        type test_pattern_array is array (natural range <>) of test_pattern_type;
        
        constant test_pattern : test_pattern_array :=
        (
            ('0', aluLDT,  "00000101", "00000001"),  -- 00 - Load 5 into tmp.
            ('0', aluLDA,  "00000101", "00000000"),  -- 01 - Load 5 into acc.
            ('0', aluADD,  "--------", "00000000"),  -- 02 - ADD registers into acc.
            ('0', aluRDT,  "00000101", "00000000"),  -- 03 - GET the value in tmp.
            ('0', aluRDA,  "00001010", "00000000"),  -- 04 - GET the value in acc.

            ('0', aluOR,   "--------", "00000000"),  -- 05 - OR registers into acc.
            ('0', aluRDA,  "00001111", "00000000"),  -- 06 - GET the value in acc.

            ('0', aluAND,  "--------", "00000000"),  -- 07 - AND registers into acc.
            ('0', aluRDA,  "00000101", "00000000"),  -- 08 - GET the value in acc.

            ('0', aluLDA,  "11111111", "00001000"),  -- 09 - Load 255 into acc.
            ('0', aluINC,  "--------", "00000011"),  -- 10 - INC acc value.
            ('0', aluRDA,  "00000000", "00000011"),  -- 11 - GET the value in acc.

            ('0', aluDEC,  "--------", "00001010"),  -- 12 - DEC acc into acc.
            ('0', aluRDA,  "11111111", "00001010"),  -- 13 - GET the value in acc.

            ('0', aluLSL,  "--------", "00001010"),  -- 14 - Logical shift left acc.
            ('0', aluRDA,  "11111110", "00001010"),  -- 15 - GET the value in acc.

            ('0', aluLSR,  "--------", "00000000"),  -- 16 - Logical shift right acc.
            ('0', aluRDA,  "01111111", "00000000"),  -- 17 - GET the value in acc.

            ('0', aluASR,  "--------", "00000110"),  -- 18 - Arithmetic shift right acc.
            ('0', aluRDA,  "00111111", "00000110"),  -- 19 - GET the value in acc.

            ('0', aluRLC,  "--------", "00000000"),  -- 20 - Rotate Left Through Carry acc.
            ('0', aluRLC,  "--------", "00001100"),  -- 21 - Rotate Left Through Carry acc.
            ('0', aluASR,  "--------", "00001100"),  -- 22 - Arithmetic shift right acc.
            ('0', aluRDA,  "11111111", "00001100"),  -- 23 - GET the value in acc.

            ('0', aluLDA,  "10101010", "00001100"),  -- 24 - Load 5 into acc.
            ('0', aluRLC,  "--------", "00000110"),  -- 25 - Rotate Left Through Carry acc.
            ('0', aluRDA,  "01010100", "00000110"),  -- 26 - GET the value in acc.
            ('0', aluRLC,  "--------", "00001100"),  -- 27 - Rotate Left Through Carry acc.
            ('0', aluRDA,  "10101001", "00001100"),  -- 28 - GET the value in acc.

            ('1', aluNOP,  "--------", "00000000"),  -- 29 - Reset the ALU.
            ('0', aluRDA,  "00000000", "00000001"),  -- 30 - GET the value in acc.
            ('0', aluRDT,  "00000000", "00000001"),  -- 31 - GET the value in tmp.

            ('0', aluSETC, "00000000", "00000011"),  -- 32 - Set the Carry flag.
            ('0', aluSETN, "00000000", "00001011"),  -- 33 - Set the Negative flag.
            ('0', aluSETV, "00000000", "00001111"),  -- 34 - Set the Overflow flag.
            ('0', aluCLRC, "00000000", "00001101"),  -- 35 - Clear the Carry flag.
            ('0', aluCLRN, "00000000", "00000101"),  -- 36 - Clear the Negative flag.
            ('0', aluCLRV, "00000000", "00000001"),  -- 37 - Clear the Overflow flag. 

            ('0', aluSETC, "00000000", "00000011"),  -- 38 - Set the Carry flag.
            ('0', aluADC,  "00000000", "00000000"),  -- 39 - Add with carry tmp and acc.
            ('0', aluRDA,  "00000001", "00000000"),  -- 40 - GET the value in acc.
            ('0', aluSETC, "00000000", "00000010"),  -- 41 - Set the Carry flag.
            ('0', aluSBB,  "00000000", "00000001"),   -- 42 - Subtract with borrow tmp and acc.
            ('0', aluRDA,  "00000000", "00000001")  -- 43 - GET the value in acc.
        );
    begin

        for i in test_pattern'range loop
            -- Set input signals
            test_index <= i;
            rst <= test_pattern(i).rst;
            opCode <= test_pattern(i).opCode;
            if test_pattern(i).opCode = aluLDA or test_pattern(i).opCode = aluLDT then
                dataBus <= test_pattern(i).dataBus;
            else
                dataBus <= (others => 'Z'); 
            end if;
            
            wait for 20 ns;
            
            assert flgBus = test_pattern(i).flgBus
                report "Bad 'Flag register' value " & to_string(flgBus) & 
                    ", expected " & to_string(test_pattern(i).flgBus) &
                    " at test pattern index " & integer'image(i) severity error;
            
            if test_pattern(i).opCode = aluRDA then
                assert dataBus = test_pattern(i).dataBus
                    report "Bad 'acc register' value " & to_string(dataBus) & 
                        ", expected " & to_string(test_pattern(i).dataBus) &
                        " at test pattern index " & integer'image(i) severity error;
            elsif test_pattern(i).opCode = aluRDT then
                assert dataBus = test_pattern(i).dataBus
                report "Bad 'tmp register' value " & to_string(dataBus) & 
                ", expected " & to_string(test_pattern(i).dataBus) &
                " at test pattern index " & integer'image(i) severity error;
            end if;
        end loop;

        assert false report "End Of Test - All Tests Successful!" severity note;
        wait;
    end process;

end behavioural;