library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity prbs is
   port(
      d , clk , reset, en: in std_logic;
      seed: in std_logic_vector(0 to 14);
	  q, valid : out std_logic	  
   );
end prbs;

architecture prbs_arch of prbs is
   signal r_reg : std_logic_vector(0 to 14);
   signal reg_ready,reg_ready_d: std_logic;
   signal counter:  unsigned (7 downto 0);
   signal buffer_d : std_logic;
begin
 
   process(clk,reset)
   begin
      if (reset='1') then
         r_reg <=(others=>'0');
		 valid <= '0';
		 reg_ready <= '0';
		 reg_ready_d<='0';
		 q <= '0';
		 counter <= x"00";
		 buffer_d <= '0';
      elsif (rising_edge(clk)) then
		buffer_d <= d;
         if (en = '1' and counter = 0 and reg_ready = '0') then
			r_reg <= seed;
			reg_ready_d<='1';
			reg_ready <= reg_ready_d;
			
		elsif (reg_ready = '1') then
				q <= (r_reg(14) xor r_reg(13)) xor buffer_d;
				valid <= '1';
				if (counter = 96) then
					counter <= "00000001";
					r_reg <=  (r_reg(14) xor r_reg(13)) & r_reg(0 to 13) ;
				elsif counter = 95 then
		
					r_reg <= seed;
					counter <= counter +1;
				else
					counter <= counter +1;
					r_reg <=  (r_reg(14) xor r_reg(13)) & r_reg(0 to 13) ;
				end if;
		end if;
		
		if (en <= '0' and counter = 1) then 
			valid <= '0';
			reg_ready <= '0';
		
			q <= '0';
		end if;
		
	  end if;
		

   end process;
 
 
end prbs_arch;