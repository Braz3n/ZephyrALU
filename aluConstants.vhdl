library ieee;
use ieee.std_logic_1164.all;

package aluConstants is
    --  Physical Constants
    constant aluOpCodeWidth     : integer := 5;
    constant aluRegisterWidth   : integer := 8;

    -- Flag Indicies
    constant zeroFlagIndex      : integer := 0;
    constant carryFlagIndex     : integer := 1;

    -- Instruction Constants
    constant aluNOP : std_logic_vector(aluOpCodeWidth-1 downto 0) := "00000";
    -- Registers - 01xxx
    constant aluLDA : std_logic_vector(aluOpCodeWidth-1 downto 0) := "01000";  -- Load ACC
    constant aluLDT : std_logic_vector(aluOpCodeWidth-1 downto 0) := "01001";  -- Load Temp
    constant aluRDA : std_logic_vector(aluOpCodeWidth-1 downto 0) := "01010";  -- Read ACC
    constant aluRDT : std_logic_vector(aluOpCodeWidth-1 downto 0) := "01011";  -- Read Temp
    constant aluRDF : std_logic_vector(aluOpCodeWidth-1 downto 0) := "01100";  -- Read Flags
    -- Math - 10xxx
    constant aluADD : std_logic_vector(aluOpCodeWidth-1 downto 0) := "10000";  -- Unsigned add Temp to ACC
    constant aluSUB : std_logic_vector(aluOpCodeWidth-1 downto 0) := "10001";  -- Unsigned subtract Temp from ACC
    constant aluINC : std_logic_vector(aluOpCodeWidth-1 downto 0) := "10010";  -- Increment ACC
    constant aluDEC : std_logic_vector(aluOpCodeWidth-1 downto 0) := "10011";  -- Decrement ACC
    -- Logic - 11xxx
    constant aluAND : std_logic_vector(aluOpCodeWidth-1 downto 0) := "11000";  -- Bitwise AND Temp and ACC
    constant aluNOT : std_logic_vector(aluOpCodeWidth-1 downto 0) := "11001";  -- Bitwise OR  Temp and ACC
    constant aluXOR : std_logic_vector(aluOpCodeWidth-1 downto 0) := "11010";  -- Bitwise OR  Temp and ACC
    constant aluOR  : std_logic_vector(aluOpCodeWidth-1 downto 0) := "11011";  -- Bitwise OR  Temp and ACC
end aluConstants;

package body aluConstants is
end aluConstants;