use work.constants.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu is
    port (
        rst         : in std_logic; 
        clk         : in std_logic; 
        dataIn      : in std_logic_vector (aluRegisterWidth-1 downto 0); 
        opCode      : in std_logic_vector (opCodeWidth-1 downto 0);
        regSel      : in std_logic_vector (aluRegisterCount-1 downto 0);
        regNullFlag : out std_logic_vector (aluRegisterCount-1 downto 0);
        dataOut     : out std_logic_vector (aluRegisterWidth-1 downto 0)
    );
end alu;
  
architecture rtl of alu is
    signal registerBus : std_logic_vector (aluRegisterWidth-1 downto 0);
    signal aluReg0 : std_logic_vector (aluRegisterWidth-1 downto 0) := (others => '0');
    signal aluReg1 : std_logic_vector (aluRegisterWidth-1 downto 0) := (others => '0');
    signal aluRegOut : std_logic;
begin

    aluReg0Process : process (clk, rst) is
    begin
        if rst = '1' then
            aluReg0 <= (others => '0');
        elsif rising_edge(clk) and rst = '0' and regSel(0) = '1' then
            aluReg0 <= registerBus;
        end if;
    end process;

    aluReg1Process : process (clk, rst) is
    begin
        if rst = '1' then
            aluReg1 <= (others => '0');
        elsif rising_edge(clk) and rst = '0' and regSel(1) = '1' then
            aluReg1 <= registerBus;
        end if;
    end process;

    opMux : process (opCode, aluReg0, aluReg1) is
    begin
        -- Asynchronous op code multiplexer.
        case opCode is
            when opCodeSET =>
                registerBus <= dataIn;
            when opCodeSETL =>
                registerBus <= dataIn;
            when opCodeINC0 =>
                registerBus <= std_logic_vector(unsigned(aluReg0) + 1);
            when opCodeINC1 =>
                registerBus <= std_logic_vector(unsigned(aluReg1) + 1);
            when opCodeDEC0 =>
                registerBus <= std_logic_vector(unsigned(aluReg0) - 1);
            when opCodeDEC1 =>
                registerBus <= std_logic_vector(unsigned(aluReg1) - 1);
            when opCodeADD =>
                registerBus <= std_logic_vector(unsigned(aluReg0) + unsigned(aluReg1));
            when opCodeSUB =>
                registerBus <= std_logic_vector(unsigned(aluReg0) - unsigned(aluReg1));
            when opCodeAND =>
                registerBus <= std_logic_vector(unsigned(aluReg0) and unsigned(aluReg1));
            when opCodeOR =>
                registerBus <= std_logic_vector(unsigned(aluReg0) or unsigned(aluReg1));
            when others =>
                registerBus <= (others => '0');
        end case;
    end process;

    -- Outputs
    regNullFlag(0) <= '1' when unsigned(aluReg0) = 0 else '0';
    regNullFlag(1) <= '1' when unsigned(aluReg1) = 0 else '0';

    dataOutMux : process (opCode) is
    begin
        case opCode is
            when opCodeGET0 =>
                dataOut <= aluReg0;
            when opCodeGET1 =>
                dataOut <= aluReg1;
            when others =>
                dataOut <= (others => '0');
        end case;
    end process;
end rtl;