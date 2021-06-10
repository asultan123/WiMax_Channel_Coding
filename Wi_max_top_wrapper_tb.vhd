library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity wimax_wrapper_tb is   
end  wimax_wrapper_tb;
architecture behav of wimax_wrapper_tb is
--module declaration 
component wimax_wrapper is
  port(
		clk1, clk2, reset, ready : in std_logic;
		correct : out std_logic
   );
end component ;
--internal signals
signal  clk1:  std_logic := '1';
signal clk2: std_logic := '1';
signal  reset:  std_logic;
signal  ready, correct : std_logic;

--clock period
constant PERIOD2: time := 10 ns;
constant PERIOD1: time := 20 ns;
begin
--unit under test instance
uut: wimax_wrapper 
	port map(
    clk1 => clk1,
	clk2 => clk2,
	reset => reset,
	ready => ready,
	correct => correct
    );
	
--clock
 clk1 <= not clk1 after PERIOD1/2;
 clk2 <= not clk2 after PERIOD2/2;
-- stimulus process
 
 stimulus : process 
	begin
	reset <= '1';
	wait for (1*PERIOD1);
	reset <='0';
	--wait for (PERIOD1);
	ready <= '1';
	wait for (960 * PERIOD1);
	ready <= '0';
	wait;

end  process stimulus;

--evaluation
process 
begin

    wait for (392*PERIOD1);
	assert(correct = '1')
		report "fail"
		severity note;
	wait;
 end process;
 
 
end behav;             
                                       