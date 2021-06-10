library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity interleaver is
   port(
      clk, reset: in std_logic;
      en: in std_logic;
	  d: in std_logic;
	  valid: out std_logic;
      q: out std_logic
   );
end interleaver ;



architecture interleaver_body of interleaver is
   signal ping, pong:  std_logic_vector(191 downto 0);
   signal ready, on_going : std_logic; 
   signal counter,counter1,ins,outs : unsigned (7 downto 0);
begin
	

    
   process(clk,reset)
   begin
			if (reset='1') then	
				
				counter <= x"00";
				counter1 <= x"00";
				ins <= x"00";
				outs <= x"00";
				ready <= '0';
				on_going <= '1';
				ping<= (others => '0');
				pong <= (others => '0');
				valid <= '0';
				q <= '0';
			elsif (rising_edge(clk)) then
					
					if (en = '1') then
									ping(to_integer((12*(counter mod 16))+(counter/16)))<=d;
						    if (counter >= 191) then
								counter <= x"00";
								ready <= '1';
								pong<=ping;
								ins <= ins +1;
							else
								counter <= counter +1;
							end if;
						
					end if;
					
					if(ready = '1') and (on_going = '1') then
						
						valid <= '1';
						
							q <= pong(to_integer(counter1));
							if (counter1 >= 191) then
								counter1 <= x"00";
								outs <= outs +1;
							else
								counter1 <= counter1 +1;
							end if;
							
						
					end if;
					
					if (ins = outs and ins > 0) then
						on_going <= '0';
						valid<='0';
					end if;
					
			end if;
	end process;
end interleaver_body;

