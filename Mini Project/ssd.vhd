LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use IEEE.NUMERIC_STD.all;

ENTITY ssd IS
PORT(
	clk: In STD_logic;
	display_button:In STD_logic;
	off_count: IN std_logic_vector(3 downto 0);
	idle_count: IN std_logic_vector(3 downto 0);
	anode: OUT std_logic_vector(3 downto 0);
	cathode: OUT std_logic_vector(6 downto 0) 	
);

END ENTITY;

ARCHITECTURE ssd_logic OF ssd IS
	signal finClk: std_logic;
	signal dumAnode: std_logic_vector(3 downto 0);
	SIGNAL off_no: std_logic_vector(3 downto 0);
	SIGNAL idle_status: std_logic_vector(3 downto 0);
	signal dummy: std_logic;
	BEGIN
	a1: ENTITY WORK.clock(clock_arc) port map(
		clk => clk,
		pushbutton => display_button,
		finClk => finClk
	);	
	a2: ENTITY WORK.anode_gen(anode_gen_arc) port map(
		clk => finClk,
		anode => dumAnode		
	);
			anode <= dumAnode;
	
	PROCESS(off_count, idle_count, dumAnode)
		if dumAnode="1110" then
			case idle_count IS 
				when "0000" => cathode <= "1000000";
				when "0001" => cathode <= "1111001";
				when "0010" => cathode <= "0100100";
				when "0011" => cathode <= "0110000";
				when "0100" => cathode <= "0011001";
				when "0101" => cathode <= "0010010";
				when "0110" => cathode <= "0000010";
				when "0111" => cathode <= "0000111";
				when "1000" => cathode <= "1111111";
				when "1001" => cathode <= "0010000";
				when "1010" => cathode <= "1000000";
				others dummy <= '0';
			end case;
		else if dumAnode="1101" then
			if idle_count="1010" cathode <= "1111001";
			else cathode <= "1000000";
			end if;
		else if dumAnode="1011" then 
			case off_count IS 
				when "0000" => cathode <= "1000000";
				when "0001" => cathode <= "1111001";
				when "0010" => cathode <= "0100100";
				when "0011" => cathode <= "0110000";
			end case;
		else if dumAnode="0111" then
			cathode <= "1000000";
		end if;	
	END PROCESS;
END ARCHITECTURE;