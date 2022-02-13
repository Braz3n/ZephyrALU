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

    signal rst      : std_logic; 
    signal clk      : std_logic; 
    signal opCode   : std_logic_vector (aluOpCodeWidth-1 downto 0);
    signal dataBus  : std_logic_vector (aluRegisterWidth-1 downto 0);
    signal flgBus   : std_logic_vector (aluRegisterWidth-1 downto 0);
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
            flgBus  : std_logic_vector (aluRegisterWidth-1 downto 0);
        end record;
        
        type test_pattern_array is array (natural range <>) of test_pattern_type;
        
        constant test_pattern : test_pattern_array :=
        (
            ('0', aluLDT, "00000101", x"01"),  -- 00 - Load 5 into tmp.
            ('0', aluLDA, "00000101", x"00"),  -- 01 - Load 5 into acc.
            ('0', aluADD, "--------", x"00"),  -- 02 - ADD registers into tmp.
            ('0', aluRDT, "00000101", x"00"),  -- 03 - GET the value in tmp.
            ('0', aluRDA, "00001010", x"00"),  -- 04 - GET the value in acc.
            ('0', aluRDF, "00000000", x"00"),  -- 05 - GET the value in flg.

            ('0', aluOR,  "--------", x"00"),  -- 06 - OR registers into acc.
            ('0', aluRDA, "00001111", x"00"),  -- 07 - GET the value in acc.

            ('0', aluAND, "--------", x"00"),  -- 08 - AND registers into acc.
            ('0', aluRDA, "00000101", x"00"),  -- 09 - GET the value in acc.

            ('0', aluLDA, "11111111", x"00"),  -- 10 - Load 255 into acc.
            ('0', aluINC, "--------", x"02"),  -- 11 - INC acc into acc.
            ('0', aluRDA, "00000000", x"02"),  -- 12 - GET the value in acc.
            ('0', aluRDF, "00000011", x"02"),  -- 13 - GET the value in flg.

            ('0', aluDEC, "--------", x"00"),  -- 14 - DEC acc into acc.
            ('0', aluRDA, "11111111", x"00"),  -- 15 - GET the value in acc.
            ('0', aluRDF, "00000000", x"00"),  -- 16 - GET the value in flg01.

            ('1', aluNOP, "--------", x"01"),  -- 16 - Reset the ALU.
            ('0', aluRDA, "00000000", x"01"),  -- 17 - GET the value in acc.
            ('0', aluRDT, "00000000", x"01"),  -- 18 - GET the value in tmp.
            ('0', aluRDF, "00000001", x"01")   -- 19 - GET the value in flg.
        );
    begin

        for i in test_pattern'range loop
            -- Set input signals
            rst <= test_pattern(i).rst;
            opCode <= test_pattern(i).opCode;
            if opcode = aluRDA or opcode = aluRDT or opcode = aluRDF then
                dataBus <= (others => 'Z'); 
            else 
                dataBus <= test_pattern(i).dataBus;
            end if;
            
            wait for 20 ns;
            
            if opcode = aluRDA then
                assert dataBus = test_pattern(i).dataBus
                    report "Bad 'acc register' value " & to_string(dataBus) & 
                        ", expected " & to_string(test_pattern(i).dataBus) &
                        " at test pattern index " & integer'image(i) severity error;
            elsif opcode = aluRDT then
                assert dataBus = test_pattern(i).dataBus
                report "Bad 'tmp register' value " & to_string(dataBus) & 
                ", expected " & to_string(test_pattern(i).dataBus) &
                " at test pattern index " & integer'image(i) severity error;
            elsif opcode = aluRDF then
                assert dataBus = test_pattern(i).dataBus
                    report "Bad 'flag register' value " & to_string(dataBus) & 
                        ", expected " & to_string(test_pattern(i).dataBus) &
                        " at test pattern index " & integer'image(i) severity error;
            end if;
        end loop;

        assert false report "End Of Test - All Tests Successful!" severity note;
        wait;
    end process;

end behavioural;