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
    -- Register Control - 00xxxx
    constant opCodeGET0         : std_logic_vector(opCodeWidth-1 downto 0) := "000001";
    constant opCodeGET1         : std_logic_vector(opCodeWidth-1 downto 0) := "000010";
    constant opCodeSET          : std_logic_vector(opCodeWidth-1 downto 0) := "000011";
    constant opCodeSETL         : std_logic_vector(opCodeWidth-1 downto 0) := "000100";
    -- Program Counter Control - 01xxxx
    constant opCodeGOTOIFD0     : std_logic_vector(opCodeWidth-1 downto 0) := "010000";
    constant opCodeGOTOIFD1     : std_logic_vector(opCodeWidth-1 downto 0) := "010001";
    constant opCodeGOTO         : std_logic_vector(opCodeWidth-1 downto 0) := "010010";
    -- Maths - 10xxxx
    constant opCodeADD          : std_logic_vector(opCodeWidth-1 downto 0) := "100000";
    constant opCodeINC0         : std_logic_vector(opCodeWidth-1 downto 0) := "100001";
    constant opCodeINC1         : std_logic_vector(opCodeWidth-1 downto 0) := "100010";
    constant opCodeDEC0         : std_logic_vector(opCodeWidth-1 downto 0) := "100011";
    constant opCodeDEC1         : std_logic_vector(opCodeWidth-1 downto 0) := "100100";
    constant opCodeSUB          : std_logic_vector(opCodeWidth-1 downto 0) := "100101";
    -- Logic - 11xxxx
    constant opCodeAND          : std_logic_vector(opCodeWidth-1 downto 0) := "110000";
    constant opCodeOR           : std_logic_vector(opCodeWidth-1 downto 0) := "110001";
end constants;

package body constants is
end constants;