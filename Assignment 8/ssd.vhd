LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use IEEE.NUMERIC_STD.all;

ENTITY ssd_final IS
PORT(
	clk: In STD_logic;
	display_button:In STD_logic;
	floor1: IN std_logic_vector(3 downto 0);
	floor2: IN std_logic_vector(3 downto 0);
	dir1: IN std_logic_vector(1 downto 0);
	dir2: IN std_logic_vector(1 downto 0);
	door1: IN std_logic;
	door2: IN std_logic;
	anode: OUT std_logic_vector(3 downto 0);
	cathode: OUT std_logic_vector(6 downto 0) 	
);

END ENTITY;

ARCHITECTURE ssd_final_arc OF ssd_final IS
signal finClk: std_logic;
signal dumAnode: std_logic_vector(3 downto 0);
SIGNAL floor_no: std_logic_vector(3 downto 0);
SIGNAL lift_status: std_logic_vector(3 downto 0);
SIGNAL lift1_status: std_logic_vector(3 downto 0);
SIGNAL lift2_status: std_logic_vector(3 downto 0);
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
	

	PROCESS(dir1, door1)
		BEGIN
			if dir1 = "01" then lift1_status <= "0001";
			elsif dir1 = "10" then lift1_status <= "0010";
			elsif dir1 = "00" then 
				if door1 = "1" then lift1_status <= "0100";
				elsif door1 = "0" then lift1_status <= "1000";
				end if;
			end if;	
		END PROCESS
		
	PROCESS(dir2, door2)
		BEGIN
			if dir2 = "01" then lift2_status <= "0001";
			elsif dir2 = "10" then lift2_status <= "0010";
			elsif dir2 = "00" then 
				if door2 = "1" then lift2_status <= "0100";
				elsif door2 = "0" then lift2_status <= "1000";
				end if;
			end if;	
		END PROCESS
		
	PROCESS(lift1_status, lift2_status, floor1, floor2, dumAnode)
        BEGIN
            IF dumAnode = "1110" THEN lift_status<= lift2_status;   -- lift2 status
            ELSIF dumAnode = "1101" THEN floor_no<= floor2;  -- lift2 floor
            ELSIF dumAnode = "1011" THEN lift_status<= lift1_status; -- lit1 status
            ELSIF dumAnode = "0111" THEN floor_no<= floor1; -- lift1 floor
            ELSE dummy <= '0';
            END IF;
        END PROCESS;    
           
    process(lift_status)
		BEGIN
		   IF lift_status = "0001" THEN cathode <="1000001";  
		   ELSIF lift_status = "0010" THEN cathode <="0100001";  
		   ELSIF lift_status = "0100" THEN cathode <="0100011";  
		   ELSIF lift_status = "1000" THEN cathode <="1000110";  
		   ELSE dummy <= '0';
		   END IF;  
		end process;
		  
    process(floor_no)
		BEGIN
		   IF floor_no = "0001" THEN cathode <="1000000";  
		   ELSIF floor_no = "0010" THEN cathode <="1111001";  
		   ELSIF floor_no = "0100" THEN cathode <="0100100";  
		   ELSIF floor_no = "1000" THEN cathode <="0110000";  
		   ELSE dummy <= '0';
		   END IF;
		END PROCESS;
END ARCHITECTURE;