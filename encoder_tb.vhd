library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity encoder_tb is   
end  encoder_tb;
architecture behav of encoder_tb is
--module declaration 
component encoder is
   port(
      clk1, clk2, reset: in std_logic;
      en: in std_logic;
	  d: in std_logic;
	  valid: out std_logic;
      q: out std_logic
   );
end component ;
--internal signals
signal  clk1:  std_logic := '0';
signal clk2: std_logic := '0';
signal  reset:  std_logic;
signal  en, d:  std_logic;
signal valid:  std_logic;
signal q: std_logic;
signal input: std_logic_vector(0 to 95) := x"558AC4A53A1724E163AC2BF9";
signal output: std_logic_vector(0 to 191) := x"2833E48D392026D5B6DC5E4AF47ADD29494B6C89151348CA";
--clock period
constant PERIOD2: time := 10 ns;
constant PERIOD1: time := 20 ns;
begin
--unit under test instance
uut: encoder 
	port map(
    clk1	=> clk1,
	clk2 => clk2,
    reset	=> reset,
    en	=> en,
    d	 => d,
    valid => valid,
    q => q
    );
	
--clock
 clk1 <= not clk1 after PERIOD1/2;
 clk2 <= not clk2 after PERIOD2/2;
-- stimulus process
 process 
 begin
	-- initial values for the inputs
	reset  <= '1';

    -- deassert reset
	wait for (1*PERIOD1);
    reset    <= '0';
    -- write 
    wait for (PERIOD1);
	en <= '1';
	--wait for (1*PERIOD1);
	for i in 0 to 959 loop
		d <= input(i mod 96);
		wait for (1*PERIOD1);		
	end loop;
	en <= '0';
	
    wait;
end process;

--evaluation
process 
begin
    wait until (valid = '1');
	wait for (0.5*PERIOD2);
	for i in 0 to 1919 loop
		assert(q = output(i mod 192))
			report "fail"
			severity note;
		wait for (PERIOD2);		
	end loop;
	wait;
 end process;
 
 
end behav;             
										