library ieee;
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all;


entity prbs_tb is
end prbs_tb;    

architecture behav of prbs_tb is

component prbs is
   port(
      d , clk, reset, en: in std_logic;
	  seed: in std_logic_vector(0 to 14);
      q, valid: out std_logic
      
   );
end component; 




signal clk: 	std_logic :='1';
signal reset: 	std_logic :='0';
signal en: 	std_logic :='0';
signal d:       std_logic := '0';
signal q, valid:       std_logic;
signal seed: std_logic_vector(0 to 14);
signal input: std_logic_vector(0 to 95) := x"ACBCD2114DAE1577C6DBF4C9";
signal output: std_logic_vector(0 to 95) := x"558AC4A53A1724E163AC2BF9";

constant PERIOD: time := 20 ns;

begin
    
uut: prbs 
     port map (clk => clk, reset => reset , en => en, d => d, q => q, valid => valid, seed => seed );
	
    clk <= not clk after (PERIOD/2);
 process 
	begin
	reset <= '1';
	wait for (PERIOD);
	reset <='0';
	wait for (PERIOD);
	en <= '1';
	seed <= "011011100010101";
	for i in 0 to 959 loop
		d <= input(i mod 96);
		wait for (1*PERIOD);
    end loop;
	en <= '0';
	wait;

end  process;

 process 
	begin
	wait until valid = '1';
	wait for (0.5 * PERIOD);
	for i in 0 to 959 loop
		assert (q = output(i mod 96))
			report "fail"
			severity note;
		wait for (1* PERIOD);
    end loop;
	wait;

end  process;
end behav;                                                    