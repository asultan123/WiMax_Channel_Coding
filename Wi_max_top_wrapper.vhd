library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity Wi_max_top_wrapper is
   port(
			clk1, reset_not, ready_unstable : in std_logic;
			correct : out std_logic
   );
end Wi_max_top_wrapper ;


--=============================
-- Listing 10.2
--=============================
architecture wrapper of Wi_max_top_wrapper is

component debounce is
  port (
	clk : in std_logic;
	datain : in std_logic;
	reset : in std_logic;
	dataout : out std_logic
  ) ;
end component ; -- debounce


	 component wimax is
   port(
      clk_m, clk2_m, reset_m: in std_logic;
	  ready_m : in std_logic;
	  data_in_m : in std_logic;
	  seed_m : in std_logic_vector(0 to 14);
	  valid_m: out std_logic;
	  data_out0_m, data_out1_m: out std_logic_vector(15 downto 0)
   );
end component ;
   
   
   component  Clock_100MHz is
	port (
		refclk   : in  std_logic := '0'; --  refclk.clk
		rst      : in  std_logic := '0'; --   reset.reset
		outclk_0 : out std_logic;        -- outclk0.clk
		locked   : out std_logic         --  locked.export
	);
end component;

--signal ready : std_logic;

signal reset : std_logic;
signal ready : std_logic;
   
   
   signal seed: std_logic_vector(0 to 14);
   signal data_in,  valid,clk2,locked: std_logic;
   signal data_out_0, data_out1: std_logic_vector( 15 downto 0);
  -- signal clks , resets, loads, ens:  std_logic;
   --signal passs: std_logic;
   shared variable count2,counter : integer := 0;
	signal count : unsigned(6 downto 0) := (others => '0');
   signal ROM_in : std_logic_vector(0 to 95) := x"ACBCD2114DAE1577C6DBF4C9";
   --constant output_rand: std_logic_vector(0 to 95) := to_stdlogicvector(x"558AC4A53A1724E163AC2BF9");
   --constant ROM_out :  std_logic_vector(0 to 191) := "010010110000010001111101111110100100001011110010101001011101010111110110000111000000001000011010010110000101000111101001101000110000100110100010010011111101010110000000100001101011110100011110";
   signal rightI:std_logic_vector(0 to 95):="011011010000001101110011110000000001100111111011001100100110111011101111010000001111110110001001";
   signal rightQ:std_logic_vector(0 to 95):="110011111001000011100010001101110010110111101100110111110001001011010010110001110111011000011100";
   --signal output : std_logic_vector(0 to 191);
   signal zerosI,zerosQ:std_logic_vector(0 to 95);
--   constant ROM_seed : std_logic_vector(0 to 14) := "011011100010101";
   
   
 begin
 
 my_debouncer_ready : debounce
 port map(
 	clk => clk1,
	datain => ready_unstable,
	reset => reset,
	dataout => ready
 );
 
 
my_wimax : wimax
port map(
clk_m => clk1,
clk2_m => clk2,
ready_m => ready,
reset_m => reset, 
seed_m => seed,
data_in_m => data_in,
data_out0_m => data_out_0,
data_out1_m => data_out1,
valid_m => valid
);

my_pll :  Clock_100MHz
port map(

refclk=>clk1,
rst=> reset,
outclk_0 => clk2,
locked => locked

);



process(clk1, reset)
	begin
		if reset = '1' then
			count <= (others => '0');
			seed <= "011011100010101";
			--data_in <= '0';
		elsif (rising_edge(clk1)) then
			if (ready = '1') then
					data_in <= ROM_in(to_integer(count));
					
					if(count < 95) then
						count <= count + 1;
					else
						count <= (others => '0');
					end if;
					
					seed <= "011011100010101";
					
--					if(count >95) then 
--						count=0;
--						end if;
			end if;
		end if;
end process;
	
process(reset, clk1)
	begin
		
		if reset = '1' then
			zerosQ<= (others=>'0');
			zerosI<= (others=>'0');
			correct <= '0';
			count2 := 0;
			--counter := 0;
			--output <= (others => '0');
		elsif (rising_edge(clk1)) then
			if (valid = '1') then
					
					if (data_out_0 ="0101101001111111") then
						zerosI(count2)<='1'; 
					else 
						zerosI(count2)<='0';
					end if;
					if (data_out1="0101101001111111") then
						zerosQ(count2)<='1'; 
					else 
						zerosQ(count2)<='0';
					end if;
					--output(count2) <= data_out_0(15);
					--output(count2+1) <= data_out1(15);
					count2 := count2+1;
					
					if(ready = '1') then
						if (count2 > 95)then 
							if (zerosI = rightI and zerosQ = rightQ) then
								correct <= '1';
							else
								correct <= '0';
							end if;
							count2 := 0;
						end if;
					end if;
				
			end if;
		end if;
end process;

reset <= not reset_not;


end wrapper;

