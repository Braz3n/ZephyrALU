use work.aluConstants.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu is
    port (
        rst         : in std_logic; 
        clk         : in std_logic; 
        opCode      : in std_logic_vector (aluOpCodeWidth-1 downto 0);
        dataBus     : inout std_logic_vector (aluRegisterWidth-1 downto 0)
    );
end alu;
  
architecture rtl of alu is
    signal tmpReg           : std_logic_vector (aluRegisterWidth-1 downto 0) := (others => '0');
    signal accReg           : std_logic_vector (aluRegisterWidth-1 downto 0) := (others => '0');
    signal flgReg           : std_logic_vector (aluRegisterWidth-1 downto 0) := (others => '0');
    signal internalFlgBus   : std_logic_vector (aluRegisterWidth-1 downto 0) := (others => '0');
    signal aluCarrySignal   : std_logic := '0';

    signal aluTemp : unsigned(aluRegisterWidth downto 0) := (others => '0');  -- Intentionally 9-bits wide!
begin
    internalFlgBus(zeroFlagIndex) <= '1' when unsigned(accReg) = 0 else '0';
    internalFlgBus(carryFlagINdex) <= '1' when aluCarrySignal = '1' else '0';
    
    aluRegWriteProcess : process (clk, rst) is
    begin
        if rst = '1' then
            tmpReg <= (others => '0');
            accReg <= (others => '0');
            flgReg <= (others => '0');
        elsif rising_edge(clk) then
            if opCode = aluLDA then
                accReg <= dataBus;
            elsif opcode = aluLDT then
                tmpReg <= dataBus;
            elsif opcode = aluNOP then
                null; -- Do nothing
            else
                accReg <= std_logic_vector(aluTemp(aluRegisterWidth-1 downto 0));
                flgReg <= internalFlgBus;
            end if;
        end if;
    end process;

    aluRegReadProcess : process (rw, tmpReg, accReg, flgReg) is
    begin
        if opcode = aluRDA then
            dataBus <= accReg;
        elsif opcode = aluRDT then
            dataBus <= tmpReg;
        elsif opcode = aluRDF then
            dataBus <= flgReg;
        else
            dataBus <= (others => 'Z');
        end if;
    end process;

    aluOperationMux : process (opCode, accReg, tmpReg, aluTemp) is
    begin
        case opCode is
            when aluINC =>
                aluTemp <= '0' & unsigned(accReg) + 1;
                aluCarrySignal <= aluTemp(aluRegisterWidth);
            when aluDEC =>
                aluTemp <= '0' & unsigned(accReg) - 1;
                aluCarrySignal <= aluTemp(aluRegisterWidth);
            when aluADD =>
                aluTemp <= ('0' & unsigned(accReg)) + ('0' & unsigned(tmpReg));
                aluCarrySignal <= aluTemp(aluRegisterWidth);
            when aluSUB =>
                aluTemp <= ('0' & unsigned(accReg)) - ('0' & unsigned(tmpReg));
                aluCarrySignal <= aluTemp(aluRegisterWidth);
            when aluAND =>
                aluTemp <= '0' & (accReg and tmpReg);
                aluCarrySignal <= '0';
            when aluNOT =>
                aluTemp <= '0' & (not accReg);
                aluCarrySignal <= '0';
            when aluXOR =>
                aluTemp <= '0' & (accReg xor tmpReg);
                aluCarrySignal <= '0';
            when aluOR =>
                aluTemp <= '0' & (accReg or tmpReg);
                aluCarrySignal <= '0';
            when others =>
                aluTemp <= (others => '0');
                aluCarrySignal <= '0';
        end case;
    end process;    
end rtl;