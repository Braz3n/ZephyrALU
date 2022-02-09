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
        regSel      : in    std_logic;  -- 0=tmp, 1=acc
        rw          : in    std_logic;  -- 0=write, 1=read
        flagsOut    : in    std_logic;
        aluEn       : in    std_logic;
        outEn       : in    std_logic;
        opCode      : in    std_logic_vector (opCodeWidth-1 downto 0);
        dataBus     : inout std_logic_vector (aluRegisterWidth-1 downto 0)
    );
    end component;

    --  Specifies which entity is bound with the component.
    for alu_UUT: alu use entity work.alu;

    signal rst      : std_logic; 
    signal clk      : std_logic; 
    signal regSel   : std_logic; 
    signal rw       : std_logic; 
    signal flagsOut : std_logic; 
    signal aluEn    : std_logic;
    signal outEn    : std_logic;
    signal opCode   : std_logic_vector (opCodeWidth-1 downto 0);
    signal dataBus  : std_logic_vector (aluRegisterWidth-1 downto 0);
begin
    -- Component instantiation.
    alu_UUT : alu port map 
    (
        rst => rst,
        clk => clk,
        regSel => regSel,
        rw => rw,
        flagsOut => flagsOut,
        aluEn => aluEn,
        outEn => outEn,
        opCode => opCode,
        dataBus => dataBus
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
            regSel   : std_logic; 
            rw       : std_logic; 
            flagsOut : std_logic; 
            aluEn    : std_logic;
            outEn    : std_logic;
            opCode   : std_logic_vector (opCodeWidth-1 downto 0);
            dataBus  : std_logic_vector (aluRegisterWidth-1 downto 0);
        end record;
        
        type test_pattern_array is array (natural range <>) of test_pattern_type;
        
        constant test_pattern : test_pattern_array :=
        (
            ('0', '0', '0', '0', '0', '0', aluNOP, "00000101"),  -- 00 - Load 5 into tmp.
            ('0', '1', '0', '0', '0', '0', aluNOP, "00000101"),  -- 01 - Load 5 into acc.
            ('0', '0', '1', '0', '1', '0', aluADD, "00000000"),  -- 02 - ADD registers into tmp.
            ('0', '0', '1', '0', '0', '1', aluNOP, "00000101"),  -- 03 - GET the value in tmp.
            ('0', '1', '1', '0', '0', '1', aluNOP, "00001010"),  -- 04 - GET the value in acc.
            ('0', '0', '1', '1', '0', '1', aluNOP, "00000000"),  -- 05 - GET the value in flg.

            ('0', '1', '1', '0', '1', '0', aluOR,  "00000000"),  -- 06 - OR registers into acc.
            ('0', '1', '1', '0', '0', '1', aluNOP, "00001111"),  -- 07 - GET the value in acc.

            ('0', '1', '1', '0', '1', '0', aluAND, "00000000"),  -- 08 - AND registers into acc.
            ('0', '1', '1', '0', '0', '1', aluNOP, "00000101"),  -- 09 - GET the value in acc.

            ('0', '1', '0', '0', '0', '0', aluNOP, "11111111"),  -- 10 - Load 255 into acc.
            ('0', '1', '1', '0', '1', '0', aluINC, "00000000"),  -- 11 - INC acc into acc.
            ('0', '1', '1', '0', '0', '1', aluNOP, "00000000"),  -- 12 - GET the value in acc.
            ('0', '0', '1', '1', '0', '1', aluNOP, "00000011"),  -- 13 - GET the value in flg.

            ('0', '1', '1', '0', '1', '0', aluDEC, "00000000"),  -- 14 - DEC acc into acc.
            ('0', '1', '1', '0', '0', '1', aluNOP, "11111111"),  -- 15 - GET the value in acc.
            ('0', '0', '1', '1', '0', '1', aluNOP, "00000000"),  -- 16 - GET the value in flg.

            ('1', '0', '1', '0', '0', '0', aluNOP, "00000000"),  -- 16 - Reset the ALU.
            ('0', '1', '1', '0', '0', '1', aluNOP, "00000000"),  -- 17 - GET the value in acc.
            ('0', '0', '1', '0', '0', '1', aluNOP, "00000000"),  -- 18 - GET the value in tmp.
            ('0', '1', '1', '1', '0', '1', aluNOP, "00000001")   -- 19 - GET the value in flg.
        );
    begin

        for i in test_pattern'range loop
            -- Set input signals
            rst <= test_pattern(i).rst;
            regSel <= test_pattern(i).regSel;
            rw <= test_pattern(i).rw;
            flagsOut <= test_pattern(i).flagsOut;
            aluEn <= test_pattern(i).aluEn;
            outEn <= test_pattern(i).outEn;
            opCode <= test_pattern(i).opCode;
            if test_pattern(i).outEn = '0' then
                dataBus <= test_pattern(i).dataBus;
            else 
                dataBus <= (others => 'Z'); 
            end if;
            
            wait for 20 ns;
            
            if test_pattern(i).rw = '0' then
                if flagsOut = '1' then
                    assert dataBus = test_pattern(i).dataBus
                        report "Bad 'flag register' value " & to_string(dataBus) & 
                            ", expected " & to_string(test_pattern(i).dataBus) &
                            " at test pattern index " & integer'image(i) severity error;
                elsif regSel = '0' then
                    assert dataBus = test_pattern(i).dataBus
                        report "Bad 'tmp register' value " & to_string(dataBus) & 
                            ", expected " & to_string(test_pattern(i).dataBus) &
                            " at test pattern index " & integer'image(i) severity error;
                elsif regSel = '1' then
                    assert dataBus = test_pattern(i).dataBus
                        report "Bad 'acc register' value " & to_string(dataBus) & 
                            ", expected " & to_string(test_pattern(i).dataBus) &
                            " at test pattern index " & integer'image(i) severity error;
                end if;
            end if;
        end loop;

        assert false report "End Of Test - All Tests Successful!" severity note;
        wait;
    end process;

end behavioural;