library ieee;
use ieee.std_logic_1164.all;

package constants is
    --  Physical Constants
    constant dataWidth          : integer := 16;
    constant addressWidth       : integer := 8;
    constant opCodeWidth        : integer := 6;
    constant aluRegisterWidth   : integer := 8;
    constant aluRegisterCount   : integer := 2;

    -- Instruction Constants
    constant opCodeNOP          : std_logic_vector(opCodeWidth-1 downto 0) := "000000";
    -- Register Control
    constant opCodeGET          : std_logic_vector(opCodeWidth-1 downto 0) := "000001";
    constant opCodeSET          : std_logic_vector(opCodeWidth-1 downto 0) := "000010";
    constant opCodeSETL         : std_logic_vector(opCodeWidth-1 downto 0) := "000011";
    -- Program Counter Control
    constant opCodeGOTOIFD0     : std_logic_vector(opCodeWidth-1 downto 0) := "000100";
    constant opCodeGOTOIFD1     : std_logic_vector(opCodeWidth-1 downto 0) := "000101";
    constant opCodeGOTO         : std_logic_vector(opCodeWidth-1 downto 0) := "000110";
    -- Maths
    constant opCodeADD          : std_logic_vector(opCodeWidth-1 downto 0) := "000111";
    constant opCodeINC0         : std_logic_vector(opCodeWidth-1 downto 0) := "001000";
    constant opCodeINC1         : std_logic_vector(opCodeWidth-1 downto 0) := "001001";
    constant opCodeDEC0         : std_logic_vector(opCodeWidth-1 downto 0) := "001010";
    constant opCodeDEC1         : std_logic_vector(opCodeWidth-1 downto 0) := "001011";
    constant opCodeSUB          : std_logic_vector(opCodeWidth-1 downto 0) := "001100";
    -- Logic
    constant opCodeAND          : std_logic_vector(opCodeWidth-1 downto 0) := "001101";
    constant opCodeOR           : std_logic_vector(opCodeWidth-1 downto 0) := "001110";
end constants;

package body constants is
end constants;