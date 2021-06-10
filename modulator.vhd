library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity modulator is 
port(
	reset, clk, en:in std_logic;
	d:in std_logic;
	valid:out std_logic;
	I:out std_logic_vector(15 downto 0);
	Q:out std_logic_vector(15 downto 0)
	);
end modulator;

architecture modulator_arch of modulator is
signal b0,index,flag,valid_sig:std_logic;


begin
process(clk,reset)
begin
	if(reset='1') then
		index<='0';
		flag<='0';
		valid<='0';
	elsif(rising_edge(clk)) then
		if(en='1') then
			if(index='0') then
				b0<=d;
				index<= not(index);
			elsif(index='1') then
				index<=not (index);
				valid <= '1';
				valid_sig<='1';
					if(b0='0' and d='0') then
						Q<=x"5A7F";
						I<=x"5A7F";
					elsif(b0='0' and d='1') then
						Q<=x"5A7F";
						I<=x"A581";
					elsif(b0='1' and d='0') then
						Q<=x"A581";
						I<=x"5A7F";
					else
						Q<=x"A581";
						I<=x"A581";
					end if;
				flag<='1';
			end if;
		end if;
		if(en='0' and flag='1') then
			valid_sig<='0';
			valid<=valid_sig;
		end if;
	end if;
end process;
end modulator_arch;