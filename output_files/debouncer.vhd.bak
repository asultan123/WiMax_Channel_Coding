library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity debounce is
  port (
	clk : in std_logic;
	datain : in std_logic;
	reset : in std_logic;
	dataout : out std_logic
  ) ;
end entity ; -- debounce

architecture arch of debounce is

	signal datain_d0_reg : std_logic; 
	signal datain_d0_next : std_logic; 
	signal datain_d1_reg : std_logic; 
	signal datain_d1_next : std_logic; 
	signal dataout_reg : std_logic; 
	signal dataout_next : std_logic; 
	signal reset_counter : std_logic;
	signal counter_reg : unsigned(19 downto 0);
	signal counter_next : unsigned(19 downto 0);
	signal counter_overflow : std_logic;

begin

	registers : process( clk, reset, reset_counter )
	begin
		if (reset = '1') then
		
			datain_d1_reg <= '0';
			datain_d0_reg <= '0';
			dataout_reg <= '0';	
			counter_reg <= (others => '0');

		elsif (clk'event and clk = '1') then
			
			datain_d0_reg <= datain_d0_next;
			datain_d1_reg <= datain_d1_next;

			if(reset_counter = '1') then
				counter_reg <= (others => '0');
			else
				if (counter_overflow = '0') then
					counter_reg <= counter_next; -- if overflow hasn't happened yet, keep incrementing or reset at mismatch
					dataout_reg <= dataout_reg; -- if overflow hasn't happened yet, keep last output
				else
					counter_reg <= counter_reg; -- if overflow has happened, stop incrementing
					dataout_reg <= dataout_next; -- if overflow has happened, get the new output
				end if;
			end if;
			
		end if;
	end process ; -- registers

	reset_counter <= datain_d0_reg xor datain_d1_reg;
	counter_overflow <= counter_reg(19);

	with reset_counter select
		counter_next <=
			(others => '0')	when '1', -- current output is valid
			counter_reg + 1	when others; 

	datain_d0_next <= datain;
	datain_d1_next <= datain_d0_reg;
	dataout_next <= datain_d1_reg;
	dataout <= dataout_reg;

end architecture ; -- arch