library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity interleaver_tb is
end interleaver_tb;

architecture interleaver_tb_body of interleaver_tb is
component interleaver
	port(
	d:in std_logic;
	en,clk,reset: in std_logic;
	q: out std_logic;
	valid: out std_logic);
end component;
signal clk:std_logic:='1';
signal d,en,reset,q,valid:std_logic;
signal check:std_logic_vector(191 downto 0):=x"4B047DFA42F2A5D5F61C021A5851E9A309A24FD58086BD1E";
signal a:std_logic_vector(191 downto 0):=x"2833E48D392026D5B6DC5E4AF47ADD29494B6C89151348CA";
--signal b:std_logic_vector(191 downto 0);
constant T:time:=10 ns;
begin
dut:interleaver port map(d=>d,en=>en,clk=>clk,reset=>reset,q=>q,valid=>valid);
clk<=not clk after T/2;
process
variable error_status:boolean;
begin
reset<='1'; wait for T;
reset<='0'; wait for T;
en<='1';
for i in 1919 downto 0 loop
d<=a(i mod 192); wait for T;
end loop;
en<='0'; wait for 1.4*T;
wait;
end process;
process 
begin 
for j in 1 to 10 loop
	wait until valid='1';
	wait for (0.5 * T);
	for i in 191 downto 0 loop
	assert (q=check(i)) 
		report "test failed."
		severity note;
	wait for T;
	end loop;
end loop;
wait;
end process;
end interleaver_tb_body;