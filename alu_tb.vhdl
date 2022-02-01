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
        rst         : in std_logic; 
        clk         : in std_logic; 
        dataIn      : in std_logic_vector (aluRegisterWidth-1 downto 0); 
        opCode      : in std_logic_vector (opCodeWidth-1 downto 0);
        regSel      : in std_logic_vector (aluRegisterCount-1 downto 0);
        regNullFlag : out std_logic_vector (aluRegisterCount-1 downto 0);
        dataOut     : out std_logic_vector (dataWidth-1 downto 0)
    );
    end component;

    --  Specifies which entity is bound with the component.
    for alu_UUT: alu use entity work.alu;

    signal rst, clk     : std_logic;
    signal dataIn       : std_logic_vector (aluRegisterWidth-1 downto 0);
    signal opCode       : std_logic_vector (opCodeWidth-1 downto 0);
    signal regSel       : std_logic_vector (aluRegisterCount-1 downto 0);
    signal regNullFlag  : std_logic_vector (aluRegisterCount-1 downto 0);
    signal dataOut      : std_logic_vector (dataWidth-1 downto 0);
begin
    -- Component instantiation
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

    process 
    begin 
        clk <= '0';
        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;
    end process;

    -- process
    -- begin
    --     rst <= '0';
    --     wait for 10 ns;
    -- end process;

    --  This process does the real job.
    process
    begin
        rst <= '0';
        -- Load in some data.
        dataIn <= std_logic_vector(to_unsigned(5, aluRegisterWidth));
        opCode <= opCodeSETL;
        regSel <= "11";

        wait for 20 ns;

        opCode <= opCodeNOP;
        regSel <= "00";

        wait for 20 ns;

        dataIn <= std_logic_vector(to_unsigned(0, aluRegisterWidth));
        opCode <= opCodeADD;
        regSel <= "00";
        
        wait for 20 ns;

        dataIn <= std_logic_vector(to_unsigned(0, aluRegisterWidth));
        opCode <= opCodeSUB;
        regSel <= "00";

        wait for 20 ns;

        dataIn <= std_logic_vector(to_unsigned(0, aluRegisterWidth));
        opCode <= opCodeOR;
        regSel <= "00";

        wait for 20 ns;

        dataIn <= std_logic_vector(to_unsigned(0, aluRegisterWidth));
        opCode <= opCodeAND;
        regSel <= "00";

        wait for 20 ns;


        assert false report "end of test" severity note;
        -- finish(0);
    -- finish;
    --  Wait forever; this will finish the simulation.
    wait;
    end process;

end behavioural;