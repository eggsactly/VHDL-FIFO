--  This file is part of VHDL-FIFO.
--
--  VHDL-FIFO is free software: you can redistribute it and/or modify
--  it under the terms of the GNU Lesser General Public License as published by
--  the Free Software Foundation, either version 3 of the License, or
--  (at your option) any later version.
--
--  VHDL-FIFO is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU General Public License for more details.

--  You should have received a copy of the GNU Lesser General Public License
--  along with VHDL-FIFO.  If not, see <http://www.gnu.org/licenses/>.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

use std.textio.all; -- Imports the standard textio package.

--  A testbench has no ports.
entity Fifo_tb is
end Fifo_tb;

architecture sim of Fifo_tb is
    component Fifo is
    generic ( 
        DEPTH    :     integer          := 32
    ); 
    port    ( 
        CLK      : in  std_logic;
        RST      : in  std_logic;
        W_DATA   : in  std_logic_vector;
        W_EN     : in  std_logic;
        R_DATA   : out std_logic_vector;
        R_EN     : in  std_logic;
        HAS_DATA : out std_logic;
        IS_FULL  : out std_logic
    );
    end component;

    signal RST, W_EN, R_EN, HAS_DATA, IS_FULL : std_logic;
    signal W_DATA, R_DATA : std_logic_vector(31 downto 0);
    constant Clk_period : time                          := 10 ns;
    signal CLK : std_logic := '1';
    signal runTest : std_logic := '1';

    -- This function encapsulates the assertion checking code for standard logic vectors
    function slvAssert (
        expected : std_logic_vector;
        actual   : std_logic_vector;
        testName : String)
        return BOOLEAN is
        variable myLine : line; 
        variable errorMessage : String(1 to 4096);
    begin
        write (myLine, String'("Expecting: "));
        hwrite (myLine, expected);
        write (myLine, String'(", Got: "));
        hwrite (myLine, actual);
        write (myLine, testName);
        assert myLine'length < errorMessage'length;  -- make sure S is big enough
        if myLine'length > 0 then
            read(myLine, errorMessage(1 to myLine'length));
        end if;
        assert actual = expected report errorMessage severity error;

        return (actual = expected);
    end slvAssert;

begin
    -- Instatiate the FIFO
    FifoInst : Fifo
    generic map (DEPTH => 4)
    port map    (
        CLK => CLK,
        RST => RST,
        W_DATA => W_DATA,
        W_EN => W_EN,
        R_DATA => R_DATA,
        R_EN => R_EN,
        HAS_DATA => HAS_DATA,
        IS_FULL => IS_FULL);

    -- Create the clock
    clockProc : process
    begin
        if runTest = '1' then
            wait for Clk_period/2;
            CLK <= not CLK;
        else
            wait;
        end if;
    end process;
    
    -- Provide Stimulus and assertions
    testProc : process 
        variable myLine : line; 
        variable expectedValue : std_logic_vector(R_DATA'range) := x"00000000";
        -- We have to create an arbitraily large number for a string (super annoying)
        variable errorMessage : String(1 to 4096);
        variable result       : Boolean;
    begin
        -- Initialize important signals
        RST <= '0';
        W_EN <= '0';
        R_EN <= '0';
        wait until rising_edge(CLK);
        
        RST <= '1';
        wait until rising_edge(CLK);

        RST <= '0';
        wait until rising_edge(CLK);

        assert HAS_DATA = '0' report "Has Data Check 1 failed" severity error;
        assert IS_FULL = '0' report "Is FULL Check 1 failed" severity error;

        W_DATA <= x"00000001";
        W_EN   <= '1';
        wait until rising_edge(CLK);
 
        W_EN   <= '0';

        wait until rising_edge(CLK);

        assert HAS_DATA = '1' report "Has Data Check 2 failed" severity error;
        assert IS_FULL = '0' report "Is FULL Check 2 failed" severity error;
        expectedValue := x"00000000";
        result := slvAssert(expectedValue, R_DATA, String'(" R_DATA check 1 failed"));

        R_EN <= '1';

        wait until rising_edge(CLK); 

        R_EN <= '0';

        wait until rising_edge(CLK); 

        assert HAS_DATA = '0' report "Has Data Check 3 failed" severity error;
        assert IS_FULL = '0' report "Is FULL Check 3 failed" severity error;
        expectedValue := x"00000001";
        result := slvAssert(expectedValue, R_DATA, String'(" R_DATA check 2 failed"));

        wait until rising_edge(CLK); 

        W_DATA <= x"00000002";
        W_EN   <= '1';

        wait until rising_edge(CLK); 

        W_DATA <= x"00000003";
        W_EN   <= '1';

        wait until rising_edge(CLK); 

        W_DATA <= x"00000004";
        W_EN   <= '1';

        wait until rising_edge(CLK); 

        W_DATA <= x"00000005";
        W_EN   <= '1';

        wait until rising_edge(CLK);

        W_EN   <= '0'; 

        wait until rising_edge(CLK);

        assert HAS_DATA = '1' report "Has Data Check 4 failed" severity error;
        assert IS_FULL = '1' report "Is FULL Check 4 failed" severity error;

        W_DATA <= x"00000006";
        W_EN   <= '1';

        wait until rising_edge(CLK);

        W_EN <= '0';

        wait until rising_edge(CLK);

        assert HAS_DATA = '1' report "Has Data Check 5 failed" severity error;
        assert IS_FULL = '1' report "Is FULL Check 5 failed" severity error;

        wait until rising_edge(CLK);

        R_EN   <= '1';

        wait until rising_edge(CLK);
        
        wait until falling_edge(CLK);
        assert HAS_DATA = '1' report "Has Data Check 6 failed" severity error;
        assert IS_FULL = '0' report "Is FULL Check 6 failed" severity error;
        expectedValue := x"00000002";
        result := slvAssert(expectedValue, R_DATA, String'(" R_DATA check 3 failed"));

        wait until falling_edge(CLK);

        assert HAS_DATA = '1' report "Has Data Check 7 failed" severity error;
        assert IS_FULL = '0' report "Is FULL Check 7 failed" severity error;
        expectedValue := x"00000003";
        result := slvAssert(expectedValue, R_DATA, String'(" R_DATA check 4 failed"));

        wait until falling_edge(CLK);

        assert HAS_DATA = '1' report "Has Data Check 8 failed" severity error;
        assert IS_FULL = '0' report "Is FULL Check 8 failed" severity error;
        expectedValue := x"00000004";
        result := slvAssert(expectedValue, R_DATA, String'(" R_DATA check 5 failed"));

        wait until rising_edge(CLK);
        assert HAS_DATA = '1' report "Has Data Check 9 failed" severity error;

        wait until falling_edge(CLK);

        assert IS_FULL = '0' report "Is FULL Check 9 failed" severity error;
        expectedValue := x"00000005";
        result := slvAssert(expectedValue, R_DATA, String'(" R_DATA check 6 failed"));

        wait until rising_edge(CLK);

        R_EN <= '0';

        wait until rising_edge(CLK);

        assert HAS_DATA = '0' report "Has Data Check 10 failed" severity error;
        assert IS_FULL = '0' report "Is FULL Check 10 failed" severity error;

        -- End the test
        assert false report "end of test" severity note;
        runTest <= '0';
        -- Wait forever, this will finish the simulation
        wait;
    end process;
end sim; 
