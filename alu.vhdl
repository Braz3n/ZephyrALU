use work.aluConstants.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu is
    port (
        rst         : in std_logic; 
        clk         : in std_logic; 
        regSel      : in std_logic;  -- 0=tmp, 1=acc
        rw          : in std_logic;  -- 0=write, 1=read
        flagsOut    : in std_logic;
        aluEn       : in std_logic;
        outEn       : in std_logic;
        opCode      : in std_logic_vector (opCodeWidth-1 downto 0);
        dataBus     : inout std_logic_vector (aluRegisterWidth-1 downto 0)
    );
end alu;
  
architecture rtl of alu is
    signal internalDataBus  : std_logic_vector (aluRegisterWidth-1 downto 0);
    signal tmpReg           : std_logic_vector (aluRegisterWidth-1 downto 0) := (others => '0');
    signal accReg           : std_logic_vector (aluRegisterWidth-1 downto 0) := (others => '0');
    signal flgReg           : std_logic_vector (aluRegisterWidth-1 downto 0);
    signal internalFlgBus   : std_logic_vector (aluRegisterWidth-1 downto 0);
    signal aluCarrySignal   : std_logic;

    signal aluTemp : unsigned(aluRegisterWidth downto 0);  -- Intentionally 9-bits wide!
begin
    dataBus <= internalDataBus when outEn = '1' else (others => 'Z');
    
    internalFlgBus(zeroFlagIndex) <= '1' when unsigned(accReg) = 0 else '0';
    internalFlgBus(carryFlagINdex) <= '1' when aluCarrySignal = '1' else '0';
    
    aluRegWriteProcess : process (clk, rst) is
    begin
        if rst = '1' then
            tmpReg <= (others => '0');
            accReg <= (others => '0');
            flgReg <= (others => '0');
        elsif rising_edge(clk) then
            if aluEn = '1' then
                accReg <= std_logic_vector(aluTemp(aluRegisterWidth-1 downto 0));
                flgReg <= internalFlgBus;
            end if;
            
            if rw = '1' then
                if regSel = '0' then
                    tmpReg <= dataBus;
                else
                    accReg <= dataBus;
                end if;
                flgReg <= flgReg;
            end if;
        end if;
    end process;

    aluRegReadProcess : process (rw, tmpReg, accReg, flgReg) is
    begin
        if rw = '0' and outEn = '1' then
            if flagsOut = '1' then
                internalDataBus <= flgReg;
            elsif regSel = '0' then
                internalDataBus <= tmpReg;
            elsif regSel = '1' then
                internalDataBus <= accReg;
            else
                internalDataBus <= (others => '0');
            end if;
        else
            internalDataBus <= (others => '0');
        end if;
    end process;

    opMux : process (opCode, accReg, tmpReg, aluTemp) is
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
                aluTemp <= '0' & ((unsigned(accReg)) and (unsigned(tmpReg)));
                aluCarrySignal <= '0';
            when aluOR =>
                aluTemp <= '0' & ((unsigned(accReg)) or (unsigned(tmpReg)));
                aluCarrySignal <= '0';
            when others =>
                aluTemp <= (others => '0');
                aluCarrySignal <= '0';
        end case;
    end process;    
end rtl;