library ieee;
use ieee.std_logic_1164.all;

package aluConstants is
    --  Physical Constants
    constant aluOpCodeWidth     : integer := 5;
    constant aluRegisterWidth   : integer := 8;

    -- Flag Indicies
    constant aluZeroFlagIndex      : integer := 0;
    constant aluCarryFlagIndex     : integer := 1;
    constant aluOverflowFlagIndex  : integer := 2;
    constant aluNegativeFlagIndex  : integer := 3;

    -- Instruction Constants
    constant aluNOP  : std_logic_vector(aluOpCodeWidth-1 downto 0) := "00000";
    -- Registers - 01xxx
    constant aluLDA  : std_logic_vector(aluOpCodeWidth-1 downto 0) := "01110";  -- Load ACC
    constant aluLDT  : std_logic_vector(aluOpCodeWidth-1 downto 0) := "00010";  -- Load Temp
    constant aluRDA  : std_logic_vector(aluOpCodeWidth-1 downto 0) := "01111";  -- Read ACC
    constant aluRDT  : std_logic_vector(aluOpCodeWidth-1 downto 0) := "00011";  -- Read Temp
    constant aluSETC : std_logic_vector(aluOpCodeWidth-1 downto 0) := "11000";  -- Set Carry flag
    constant aluCLRC : std_logic_vector(aluOpCodeWidth-1 downto 0) := "11001";  -- Clear Carry flag
    constant aluSETV : std_logic_vector(aluOpCodeWidth-1 downto 0) := "11010";  -- Set Overflow flag
    constant aluCLRV : std_logic_vector(aluOpCodeWidth-1 downto 0) := "11011";  -- Clear Overflow flag
    constant aluSETN : std_logic_vector(aluOpCodeWidth-1 downto 0) := "11100";  -- Set Negative flag
    constant aluCLRN : std_logic_vector(aluOpCodeWidth-1 downto 0) := "11101";  -- Clear Negative flag
    -- Math
    constant aluADD  : std_logic_vector(aluOpCodeWidth-1 downto 0) := "00110";  -- Unsigned add Temp to ACC
    constant aluADC  : std_logic_vector(aluOpCodeWidth-1 downto 0) := "00111";  -- Unsigned add with carry Temp to ACC
    constant aluSUB  : std_logic_vector(aluOpCodeWidth-1 downto 0) := "01000";  -- Unsigned subtract Temp from ACC
    constant aluSBB  : std_logic_vector(aluOpCodeWidth-1 downto 0) := "01001";  -- Unsigned subtract with borrow Temp from ACC
    constant aluINC  : std_logic_vector(aluOpCodeWidth-1 downto 0) := "10110";  -- Increment ACC
    constant aluDEC  : std_logic_vector(aluOpCodeWidth-1 downto 0) := "10111";  -- Decrement ACC
    -- Logic
    constant aluAND  : std_logic_vector(aluOpCodeWidth-1 downto 0) := "01010";  -- Bitwise AND Temp and ACC
    constant aluNOT  : std_logic_vector(aluOpCodeWidth-1 downto 0) := "00101";  -- Bitwise NOT ACC
    constant aluXOR  : std_logic_vector(aluOpCodeWidth-1 downto 0) := "01101";  -- Bitwise XOR Temp and ACC
    constant aluOR   : std_logic_vector(aluOpCodeWidth-1 downto 0) := "01011";  -- Bitwise OR Temp and ACC
    -- Shifts/Rotations
    constant aluLSL  : std_logic_vector(aluOpCodeWidth-1 downto 0) := "10000";  -- Logical Shift Left ACC
    constant aluLSR  : std_logic_vector(aluOpCodeWidth-1 downto 0) := "10001";  -- Logical Shift Right ACC
    constant aluASR  : std_logic_vector(aluOpCodeWidth-1 downto 0) := "10010";  -- Arithmetic Shift Right ACC
    constant aluRLC  : std_logic_vector(aluOpCodeWidth-1 downto 0) := "10011";  -- Rotate Left Through Carry
    constant aluRRC  : std_logic_vector(aluOpCodeWidth-1 downto 0) := "10100";  -- Rotate Right Through Carry
    
end aluConstants;

package body aluConstants is
end aluConstants;