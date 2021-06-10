library ieee;
use ieee.std_logic_1164.all;
entity wimax is
   port(
      clk_m,clk2_m, reset_m: in std_logic;
	  ready_m : in std_logic;
	  data_in_m : in std_logic;
	  seed_m : in std_logic_vector(0 to 14);
	  valid_m: out std_logic;
	  data_out0_m, data_out1_m: out std_logic_vector(15 downto 0)
   );
end wimax ;



architecture my_wimax of wimax is


	 component prbs
      port(
      clk , reset, en: in std_logic;
      d : in std_logic;
	  seed: in std_logic_vector(0 to 14);
	  q, valid : out std_logic	  
   );
   end component;
   
	component encoder
      port(
      clk1, clk2, reset: in std_logic;
      en: in std_logic;
	  d: in std_logic;
	  valid: out std_logic;
      q: out std_logic
   );
   end component;
   
   
	component interleaver 
    port(
      clk, reset: in std_logic;
      en: in std_logic;
	  d: in std_logic;
	  valid: out std_logic;
      q: out std_logic
   );
	end component;

	component modulator 
    port(
      clk, reset: in std_logic;
      en: in std_logic;
	  d: in std_logic;
	  valid: out std_logic;
      I, Q: out std_logic_vector(15 downto 0)
   );
	end component;
	
signal rand_v_r_enc, enc_v_r_inter, inter_v_r_mod: std_logic;  --en valid interconnections
signal rand_o_i_enc, enc_o_i_inter, inter_o_i_mod: std_logic;  -- input output interconnections

begin
	my_randomizer: prbs
	  port map(
	  clk => clk_m, reset => reset_m, 
	  en=>ready_m,
	  d => data_in_m,
	  seed => seed_m,
	  valid => rand_v_r_enc,
	  q => rand_o_i_enc
	  );

	  
	 my_encoder: encoder
	  port map(
	   clk1 => clk_m,
	   clk2 => clk2_m,
	   reset => reset_m,
      en => rand_v_r_enc,
	  d => rand_o_i_enc,
	  valid => enc_v_r_inter,
      q => enc_o_i_inter
	  );

	  my_interleaver: interleaver
	  port map(
	   clk => clk2_m,
	   reset => reset_m,
	   en => enc_v_r_inter,
	   d => enc_o_i_inter,
	   valid => inter_v_r_mod,
	   q => inter_o_i_mod
	  );
	  
	my_modulator: modulator
	  port map(
	   clk => clk2_m,
	   reset => reset_m,
	   en => inter_v_r_mod,
	   d => inter_o_i_mod,
	   valid => valid_m,   
	   I => data_out0_m,
	   Q => data_out1_m
	  );
end my_wimax;

