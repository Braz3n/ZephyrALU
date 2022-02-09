library ieee;
use ieee.std_logic_1164.all;

package aluConstants is
    --  Physical Constants
    constant opCodeWidth        : integer := 6;
    constant aluRegisterWidth   : integer := 8;

    -- Flag Indicies
    constant zeroFlagIndex  : integer := 0;
    constant carryFlagIndex : integer := 1;

    -- Instruction Constants
    constant aluNOP          : std_logic_vector(opCodeWidth-1 downto 0) := "000000";
    -- Math - 10xxxx
    constant aluADD          : std_logic_vector(opCodeWidth-1 downto 0) := "100000";
    constant aluINC         : std_logic_vector(opCodeWidth-1 downto 0) := "100001";
    constant aluDEC         : std_logic_vector(opCodeWidth-1 downto 0) := "100011";
    constant aluSUB          : std_logic_vector(opCodeWidth-1 downto 0) := "100101";
    -- Logic - 11xxxx
    constant aluAND          : std_logic_vector(opCodeWidth-1 downto 0) := "110000";
    constant aluOR           : std_logic_vector(opCodeWidth-1 downto 0) := "110001";
end aluConstants;

package body aluConstants is
end aluConstants;