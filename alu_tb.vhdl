use work.constants.all;

-- use std.env.finish;

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
        rst         : in  std_logic; 
        clk         : in  std_logic; 
        dataIn      : in  std_logic_vector (aluRegisterWidth-1 downto 0); 
        opCode      : in  std_logic_vector (opCodeWidth-1 downto 0);
        regSel      : in  std_logic_vector (aluRegisterCount-1 downto 0);
        regNullFlag : out std_logic_vector (aluRegisterCount-1 downto 0);
        dataOut     : out std_logic_vector (aluRegisterWidth-1 downto 0)
    );
    end component;

    --  Specifies which entity is bound with the component.
    for alu_UUT: alu use entity work.alu;

    signal rst, clk     : std_logic;
    signal dataIn       : std_logic_vector (aluRegisterWidth-1 downto 0);
    signal opCode       : std_logic_vector (opCodeWidth-1 downto 0);
    signal regSel       : std_logic_vector (aluRegisterCount-1 downto 0);
    signal regNullFlag  : std_logic_vector (aluRegisterCount-1 downto 0);
    signal dataOut      : std_logic_vector (aluRegisterWidth-1 downto 0);
begin
    -- Component instantiation.
    alu_UUT : alu port map 
    (
        clk => clk,
        rst => rst,
        dataIn => dataIn,
        opCode => opCode,
        regSel => regSel,
        regNullFlag => regNullFlag,
        dataOut => dataOut
    );

    -- Clock process.
    process 
    begin 
        clk <= '0';
        wait for 10 fs;
        clk <= '1';
        wait for 10 fs;
    end process;

    -- Actual working process block.
    process
        type test_pattern_type is record
            rst         : std_logic;
            dataIn      : std_logic_vector (aluRegisterWidth-1 downto 0);
            opCode      : std_logic_vector (opCodeWidth-1 downto 0);
            regSel      : std_logic_vector (aluRegisterCount-1 downto 0);
            regNullFlag : std_logic_vector (aluRegisterCount-1 downto 0);
            dataOut     : std_logic_vector (aluRegisterWidth-1 downto 0);
        end record;
        
        type test_pattern_array is array (natural range <>) of test_pattern_type;
        
        constant test_pattern : test_pattern_array :=
        (
            ('0', "00000101", opCodeSETL, "01", "10", "00000000"),  -- 00 - Load 5 into reg0.
            ('0', "00000101", opCodeSET,  "10", "00", "00000000"),  -- 01 - Load 5 into reg1.
            ('0', "00000000", opCodeADD,  "01", "00", "00000000"),  -- 02 - ADD registers into reg0.
            ('0', "00000000", opCodeGET0, "00", "00", "00001010"),  -- 03 - GET the value in reg0.
            ('0', "00000000", opCodeGET1, "00", "00", "00000101"),  -- 04 - GET the value in reg1.

            ('0', "00000000", opCodeOR,   "01", "00", "00000000"),  -- 05 - OR registers into reg0.
            ('0', "00000000", opCodeGET0, "00", "00", "00001111"),  -- 06 - GET the value in reg0.

            ('0', "00000000", opCodeAND,  "10", "00", "00000000"),  -- 07 - AND registers into reg1.
            ('0', "00000000", opCodeGET1, "00", "00", "00000101"),  -- 08 - GET the value in reg1.

            ('0', "11111111", opCodeSET,  "10", "00", "00000000"),  -- 09 - Load 255 into reg1.
            ('0', "00000000", opCodeINC1, "01", "01", "00000000"),  -- 10 - INC reg1 and store in reg0.
            ('0', "00000000", opCodeGET0, "00", "01", "00000000"),  -- 11 - GET the value in reg0.

            ('0', "00000000", opCodeDEC0, "01", "00", "00000000"),  -- 12 - DEC reg0 and store in reg0.
            ('0', "00000000", opCodeGET0, "00", "00", "11111111"),  -- 13 - GET the value in reg0.

            ('1', "00000000", opCodeNOP,  "00", "11", "00000000"),  -- 14 - Reset the ALU.
            ('0', "00000000", opCodeGET0, "00", "11", "00000010"),  -- 15 - GET the value in reg0.
            ('0', "00000000", opCodeGET1, "00", "11", "00000000")   -- 16 - GET the value in reg1.
        );
    begin

        for i in test_pattern'range loop
            -- Set input signals
            rst <= test_pattern(i).rst;
            dataIn <= test_pattern(i).dataIn;
            opCode <= test_pattern(i).opCode;
            regSel <= test_pattern(i).regSel;

            wait for 20 fs;

            assert regNullFlag = test_pattern(i).regNullFlag
                report "Bad 'null register' value " & to_string(regNullFlag) & 
                        ", expected " & to_string(test_pattern(i).regNullFlag) &
                        " at test pattern index " & integer'image(i) severity error;
            assert dataOut = test_pattern(i).dataOut
                report "Bad 'data out' value " & to_string(dataOut) & 
                        ", expected " & to_string(test_pattern(i).dataOut) & 
                        " at test pattern index " & integer'image(i) severity error;
        end loop;

        assert false report "End Of Test - All Tests Successful!" severity note;
        wait;
    end process;

end behavioural;