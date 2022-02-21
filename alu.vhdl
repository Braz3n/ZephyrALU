use work.aluConstants.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu is
    port (
        rst         : in std_logic; 
        clk         : in std_logic; 
        opCode      : in std_logic_vector (aluOpCodeWidth-1 downto 0);
        dataBus     : inout std_logic_vector (aluRegisterWidth-1 downto 0);
        flgBus      : out std_logic_vector (aluRegisterWidth-1 downto 0)
    );
end alu;
  
architecture rtl of alu is
    signal tmpReg            : std_logic_vector (aluRegisterWidth-1 downto 0) := (others => '0');
    signal accReg            : std_logic_vector (aluRegisterWidth-1 downto 0) := (others => '0');
    signal flgReg            : std_logic_vector (aluRegisterWidth-1 downto 0) := (others => '0');
    signal internalFlgBus    : std_logic_vector (aluRegisterWidth-1 downto 0) := (others => '0');
    signal aluZeroSignal     : std_logic := '0';
    signal aluCarrySignal    : std_logic := '0';
    signal aluOverflowSignal : std_logic := '0';
    signal aluNegativeSignal : std_logic := '0';

    signal aluTemp : unsigned(aluRegisterWidth downto 0) := (others => '0');  -- Intentionally 9-bits wide!
begin
    internalFlgBus(aluZeroFlagIndex)     <= '1' when aluZeroSignal = '1' else '0';
    internalFlgBus(aluCarryFlagIndex)    <= '1' when aluCarrySignal = '1' else '0';
    internalFlgBus(aluOverflowFlagIndex) <= '1' when aluOverflowSignal = '1' else '0';
    internalFlgBus(aluNegativeFlagIndex) <= '1' when aluNegativeSignal = '1' else '0';
    flgBus <= flgReg;
    
    aluZeroSignalProcess : process (opCode, dataBus, aluTemp) is
    begin
        if opCode = aluLDA then
            if unsigned(dataBus) = 0 then
                aluZeroSignal <= '1';
            else
                aluZeroSignal <= '0';
            end if;
        else
            if unsigned(aluTemp(aluRegisterWidth-1 downto 0)) = 0 then
                aluZeroSignal <= '1';
            else
                aluZeroSignal <= '0';
            end if;
        end if;
    end process;
    
    aluTempWriteProcess : process (clk, rst) is
    begin
        if rst = '1' then
            tmpReg <= (others => '0');
        elsif rising_edge(clk) then
            if opcode = aluLDT then
                tmpReg <= dataBus;
            end if;
        end if;
    end process;
    
    aluAccumulatorWriteProcess : process (clk, rst) is
    begin
        if rst = '1' then
            accReg <= (others => '0');
            flgReg <= (others => '0');
        elsif rising_edge(clk) then
            if opcode = aluLDA then
                accReg <= dataBus;
            elsif opcode /= aluNOP then
                accReg <= std_logic_vector(aluTemp(aluRegisterWidth-1 downto 0));
            end if;
            flgReg <= internalFlgBus;
        end if;
    end process;

    aluRegReadProcess : process (opCode, accReg, tmpReg, flgReg) is
    begin
        if opcode = aluRDA then
            dataBus <= accReg;
        elsif opcode = aluRDT then
            dataBus <= tmpReg;
        else
            dataBus <= (others => 'Z');
        end if;
    end process;

    aluOperationMux : process (opCode, accReg, tmpReg, aluTemp, flgReg, aluCarrySignal, aluNegativeSignal) is
    begin
        case opCode is
            ------------------
            -- Flag Setting --
            ------------------
            when aluSETC =>
                aluTemp <= '0' & unsigned(accReg);
                aluCarrySignal    <= '1';
                aluOverflowSignal <= flgReg(aluOverflowFlagIndex);
                aluNegativeSignal <= flgReg(aluNegativeFlagIndex);
            when aluCLRC =>
                aluTemp <= '0' & unsigned(accReg);
                aluCarrySignal    <= '0';
                aluOverflowSignal <= flgReg(aluOverflowFlagIndex);
                aluNegativeSignal <= flgReg(aluNegativeFlagIndex);
            when aluSETV =>
                aluTemp <= '0' & unsigned(accReg);
                aluCarrySignal    <= flgReg(aluCarryFlagIndex);
                aluOverflowSignal <= '1';
                aluNegativeSignal <= flgReg(aluNegativeFlagIndex);
            when aluCLRV =>
                aluTemp <= '0' & unsigned(accReg);
                aluCarrySignal    <= flgReg(aluCarryFlagIndex);
                aluOverflowSignal <= '0';
                aluNegativeSignal <= flgReg(aluNegativeFlagIndex);
            when aluSETN =>
                aluTemp <= '0' & unsigned(accReg);
                aluCarrySignal    <= flgReg(aluCarryFlagIndex);
                aluOverflowSignal <= flgReg(aluOverflowFlagIndex);
                aluNegativeSignal <= '1';
            when aluCLRN =>
                aluTemp <= '0' & unsigned(accReg);
                aluCarrySignal    <= flgReg(aluCarryFlagIndex);
                aluOverflowSignal <= flgReg(aluOverflowFlagIndex);
                aluNegativeSignal <= '0';
            when aluLDA =>
                aluCarrySignal    <= flgReg(aluCarryFlagIndex);
                aluOverflowSignal <= flgReg(aluOverflowFlagIndex);
                aluNegativeSignal <= dataBus(aluRegisterWidth-1);

            ----------------
            -- Arithmetic --
            ----------------
            when aluINC =>
                aluTemp <= '0' & unsigned(accReg) + 1;
                aluCarrySignal <= aluTemp(aluRegisterWidth);
                -- Basically ACC + 1, so half of the overflow test isn't necessary.
                aluOverflowSignal <= not accReg(aluRegisterWidth-1) and aluTemp(aluRegisterWidth-1);
                aluNegativeSignal <= aluTemp(aluRegisterWidth-1);
            when aluDEC =>
                aluTemp <= '0' & unsigned(accReg) - 1;
                aluCarrySignal <= aluTemp(aluRegisterWidth);
                -- Basically ACC - 1, so half of the overflow test isn't necessary.
                aluOverflowSignal <= (accReg(aluRegisterWidth-1) and not aluTemp(aluRegisterWidth-1));
                aluNegativeSignal <= aluTemp(aluRegisterWidth-1);
            when aluADD =>
                aluTemp <= ('0' & unsigned(accReg)) + ('0' & unsigned(tmpReg));
                aluCarrySignal <= aluTemp(aluRegisterWidth);
                aluOverflowSignal <= (accReg(aluRegisterWidth-1) and tmpReg(aluRegisterWidth-1) and not aluTemp(aluRegisterWidth-1)) or
                                        (not accReg(aluRegisterWidth-1) and not tmpReg(aluRegisterWidth-1) and aluTemp(aluRegisterWidth-1));
                aluNegativeSignal <= aluTemp(aluRegisterWidth-1);
            when aluADC =>
                if flgReg(aluCarryFlagIndex) = '1' then
                    aluTemp <= ('0' & unsigned(accReg)) + ('0' & unsigned(tmpReg)) + 1;
                else
                    aluTemp <= ('0' & unsigned(accReg)) + ('0' & unsigned(tmpReg));
                end if;
                aluCarrySignal <= aluTemp(aluRegisterWidth);
                aluOverflowSignal <= (accReg(aluRegisterWidth-1) and tmpReg(aluRegisterWidth-1) and not aluTemp(aluRegisterWidth-1)) or
                                        (not accReg(aluRegisterWidth-1) and not tmpReg(aluRegisterWidth-1) and aluTemp(aluRegisterWidth-1));
                aluNegativeSignal <= aluTemp(aluRegisterWidth-1);
            when aluSUB =>
                aluTemp <= ('0' & unsigned(accReg)) - ('0' & unsigned(tmpReg));
                aluCarrySignal <= aluTemp(aluRegisterWidth);
                aluOverflowSignal <= (accReg(aluRegisterWidth-1) and tmpReg(aluRegisterWidth-1) and not aluTemp(aluRegisterWidth-1)) or
                                        (not accReg(aluRegisterWidth-1) and not tmpReg(aluRegisterWidth-1) and aluTemp(aluRegisterWidth-1));
                aluNegativeSignal <= aluTemp(aluRegisterWidth-1);
            when aluSBB =>
                if flgReg(aluCarryFlagIndex) = '1' then
                    aluTemp <= ('0' & unsigned(accReg)) - ('0' & unsigned(tmpReg)) - 1;
                else
                    aluTemp <= ('0' & unsigned(accReg)) - ('0' & unsigned(tmpReg));
                end if;
                aluCarrySignal <= aluTemp(aluRegisterWidth);
                aluOverflowSignal <= (accReg(aluRegisterWidth-1) and tmpReg(aluRegisterWidth-1) and not aluTemp(aluRegisterWidth-1)) or
                                        (not accReg(aluRegisterWidth-1) and not tmpReg(aluRegisterWidth-1) and aluTemp(aluRegisterWidth-1));
                aluNegativeSignal <= aluTemp(aluRegisterWidth-1);

            -----------
            -- Logic --
            -----------
            when aluAND =>
                aluTemp <= '0' & unsigned(accReg and tmpReg);
                aluCarrySignal <= flgBus(aluCarryFlagIndex);
                aluOverflowSignal <= '0';
                aluNegativeSignal <= aluTemp(aluRegisterWidth-1);
            when aluNOT =>
                aluTemp <= '0' & unsigned(not accReg);
                aluCarrySignal <= flgBus(aluCarryFlagIndex);
                aluOverflowSignal <= '0';
                aluNegativeSignal <= aluTemp(aluRegisterWidth-1);
            when aluXOR =>
                aluTemp <= '0' & unsigned(accReg xor tmpReg);
                aluCarrySignal <= flgBus(aluCarryFlagIndex);
                aluOverflowSignal <= '0';
                aluNegativeSignal <= aluTemp(aluRegisterWidth-1);
            when aluOR =>
                aluTemp <= '0' & unsigned(accReg or tmpReg);
                aluCarrySignal <= flgBus(aluCarryFlagIndex);
                aluOverflowSignal <= '0';
                aluNegativeSignal <= aluTemp(aluRegisterWidth-1);
            

            ----------------------
            -- Shifts/Rotations --
            ----------------------
            when aluLSL =>
                aluTemp <= unsigned(accReg) & '0';
                aluCarrySignal <= aluTemp(aluRegisterWidth);
                aluNegativeSignal <= aluTemp(aluRegisterWidth-1);
                aluOverflowSignal <= aluCarrySignal xor aluNegativeSignal;
            when aluLSR =>
                aluTemp <= '0' & shift_right(unsigned(accReg), 1);
                aluCarrySignal <= accReg(0);
                aluNegativeSignal <= aluTemp(aluRegisterWidth-1);
                aluOverflowSignal <= aluCarrySignal xor aluNegativeSignal;
            when aluASR =>
                aluTemp <= '0' & unsigned(shift_right(signed(accReg), 1));
                aluCarrySignal <= accReg(0);
                aluNegativeSignal <= aluTemp(aluRegisterWidth-1);
                aluOverflowSignal <= aluCarrySignal xor aluNegativeSignal;
            when aluRLC =>
                aluTemp <= rotate_left(flgBus(aluCarryFlagIndex) & unsigned(accReg), 1);
                aluCarrySignal <= aluTemp(aluRegisterWidth);
                aluNegativeSignal <= aluTemp(aluRegisterWidth-1);
                aluOverflowSignal <= aluCarrySignal xor aluNegativeSignal;
            when aluRRC =>
                aluTemp <= rotate_right(flgBus(aluCarryFlagIndex) & unsigned(accReg), 1);
                aluCarrySignal <= aluTemp(aluRegisterWidth);
                aluNegativeSignal <= aluTemp(aluRegisterWidth-1);
                aluOverflowSignal <= aluCarrySignal xor aluNegativeSignal;
                
            ------------
            -- Others --
            ------------
            when others =>
                aluTemp <= '0' & unsigned(accReg);
                aluCarrySignal <= flgBus(aluCarryFlagIndex);
                aluOverflowSignal <= flgBus(aluOverflowFlagIndex);
                aluNegativeSignal <= accReg(aluRegisterWidth-1);
        end case;
    end process;    
end rtl;