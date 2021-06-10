library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity encoder is
   port(
      d , en , clk1, clk2, reset: in std_logic;
      valid , q: out std_logic
   );
end encoder ;



architecture encoder_arch of encoder is
   signal r_reg:  std_logic_vector(0 to 5); 
   signal ping,pong: std_logic_vector (95 downto 0);
   signal x,y,toggle,delay,reg_ready,on_going:  std_logic;
   signal index_in,index_out, ins, outs : unsigned (7 downto 0);
begin


   
   
   process(reset,clk1)
   begin
			if (reset='1') then	
				r_reg<=  (others => '0');
				pong <= (others => '0');
				ping <= (others => '0');
				reg_ready <= '0';
				index_in <= x"00";
				index_out <= x"00";	
				ins <= x"00";
				outs <= x"00";
			
			elsif (rising_edge(clk1)) then
						
					if (en = '1') then
					
						ping(to_integer(index_in)) <= d;
					
							if(index_in = 95) then
								index_in <= (others => '0');
								r_reg <= d & ping(94 downto 90);
								pong <= d & ping(94 downto 0);
								reg_ready <= '1';
								ins <= ins +1;
							else
								index_in <= index_in +1;
							end if;
					end if;
					
					if(reg_ready = '1') and on_going = '1' then
						
							r_reg <= pong(to_integer(index_out)) & r_reg(0 to 4);
							if index_out = 95 then
								index_out <= (others => '0');
								outs <= outs +1;
							else
								index_out <= index_out +1;
							end if;	
						
					end if;
			end if;
	end process;
	
process(reset,clk2)
   begin
			if (reset='1') then
				toggle <= '0';
				q <= '0';
				valid <= '0';
				delay <= '0';
				on_going <= '1';

			elsif (rising_edge(clk2)) then
			
				if (ins = outs and ins > 0) then
						q <= '0';
						on_going <= '0';
						--delay <= '0';
						valid <= '0';
					end if;
					
					if reg_ready = '1' 
					
					then
						
						x <= (pong(to_integer(index_out)) xor r_reg(0) xor r_reg(1) xor r_reg(2) xor r_reg(5)) ;
						y <= (pong(to_integer(index_out)) xor r_reg(1) xor r_reg(2) xor r_reg(4) xor r_reg(5)) ;
					--else 
					
						--x <= '0';
						--y <= '0';
					  end if;
				if(reg_ready = '1') and (on_going = '1')then

                 delay <= '1';
                 valid <= delay;
				 
					if (toggle = '1') 
					 
					then 
						
						q <= x;
						toggle<=not(toggle);
					elsif ((toggle = '0') and (reg_ready = '1')) then
						
						q <= y;
						toggle<=not(toggle);
					end if;
				end if;	
					
					--if (ins = outs and ins > 0) then
						--q <= '0';
						--on_going <= '0';
						--delay <= '0';
						--valid <= delay;
					--end if;
			end if;
	end process;	
end encoder_arch;

