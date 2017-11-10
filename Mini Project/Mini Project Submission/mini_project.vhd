--------------------------------------Slow Clock with pushbutton for more comfortable counter implementation-------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;

ENTITY slowClock IS
PORT(
    clk_fast : in  std_logic;
    clk_slow   : out std_logic
);
END ENTITY;	
ARCHITECTURE slowClock_arc OF slowClock IS
    signal prescaler : std_logic_vector(16 downto 0) := "00000000000000000";
BEGIN
    process(clk_fast)
    begin
    if rising_edge(clk_fast) then   -- rising clock edge
      prescaler <= prescaler + 1;
    end if;
      clk_slow <= prescaler(16);
  end process;
END ARCHITECTURE;

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY clock IS
PORT(
    clk: IN std_logic;
    pushbutton: IN std_logic;
    finClk: OUT std_logic
);
END ENTITY;	   

ARCHITECTURE clock_arc OF clock IS
signal slowClock: std_logic;
BEGIN 
    y: ENTITY WORK.slowClock(slowClock_arc) port map(
        clk_fast => clk,
        clk_slow => slowClock
    ); 
    PROCESS(clk, pushbutton)
    BEGIN
if(pushbutton = '1') then finclk <= clk;
        elsif(pushbutton = '0') then finclk <= slowClock;
        end if;
            
    END PROCESS;    
END ARCHITECTURE;


---------------------------------------Seven Segment Display for counters--------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use IEEE.NUMERIC_STD.all;

ENTITY anode_gen IS
PORT(
    clk : in  std_logic;
    --rst       : in  std_logic;
    anode   : out std_logic_vector(3 downto 0)
);
END ENTITY;	

ARCHITECTURE anode_gen_arc OF anode_gen IS
signal danode : std_logic_vector(3 downto 0);

BEGIN
PROCESS(clk)
    variable j : integer range 0 to 7 := 0;
    BEGIN
      if rising_edge(clk) then
        if j=0 then
            danode <= "1110";
            j := 1;   
        elsif j=1 then
                danode <= "1101";
                j := 2;
         elsif j=2 then
                danode <= "1011";
                j := 3;
          elsif j=3 then
                danode <= "0111";
                j := 0;                         
        end if;
      end if;  
    END PROCESS;
    anode <= danode;
END Architecture;



LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use IEEE.NUMERIC_STD.all;

ENTITY ssd IS
PORT(
	clk: In STD_logic;
	off_count: IN std_logic_vector(3 downto 0);
	idle_count: IN std_logic_vector(3 downto 0);
	anode: OUT std_logic_vector(3 downto 0);
	cathode: OUT std_logic_vector(6 downto 0) 	
);

END ENTITY;

ARCHITECTURE ssd_logic OF ssd IS
	signal dumAnode: std_logic_vector(3 downto 0);
	SIGNAL off_no: std_logic_vector(3 downto 0);
	SIGNAL idle_status: std_logic_vector(3 downto 0);
	signal dummy: std_logic;
BEGIN


	a2: ENTITY WORK.anode_gen(anode_gen_arc) port map(
		clk => clk,
		anode => dumAnode		
	);
			anode <= dumAnode;
	
	PROCESS(off_count, idle_count, dumAnode)
	BEGIN	
		if dumAnode="1110" then 
				if idle_count = "0000" then cathode <= "1000000";
				elsif idle_count = "0001" then cathode <= "1111001";
				elsif idle_count = "0010" then cathode <= "0100100";
				elsif idle_count = "0011" then cathode <= "0110000";
				elsif idle_count = "0100" then cathode <= "0011001";
				elsif idle_count = "0101" then cathode <= "0010010";
				elsif idle_count = "0110" then cathode <= "0000010";
				elsif idle_count =  "0111" then cathode <= "1111000";
				elsif idle_count = "1000" then cathode <= "0000000";
				elsif idle_count = "1001" then cathode <= "0010000";
				elsif idle_count = "1010"  then cathode <= "1000000";
				else dummy <= '0';
				end if;
		elsif dumAnode="1101" then
			if idle_count="1010" then cathode <= "1111001";
			else cathode <= "1000000";
			end if;
		elsif dumAnode="1011" then 
				if off_count = "0000" then cathode <= "1000000";
				elsif off_count = "0001" then cathode <= "1111001";
				elsif off_count = "0010" then cathode <= "0100100";
				elsif off_count = "0011" then cathode <= "0110000";
		        end if;	
		elsif dumAnode="0111" then
			         cathode <= "1000000";   
		  end if;
	END PROCESS;
END ARCHITECTURE;






---------------------------------------Light Controller Logic (1 sec = 763 counts)-----------------------------------------------------


LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.all;

ENTITY controller IS
PORT(
      clk: IN std_logic;
      SW_ON : IN std_logic;
      SW_OFF : IN std_logic;
      SW_DOOR : IN std_logic;
   --   reset: IN std_logic; it's useless
      D: IN std_logic_vector(3 DOWNTO 0); 
      door_key: IN std_logic;
      ignition: IN std_logic;
      counter_delay_bit: OUT std_logic_vector(3 DOWNTO 0);
      door_delay_bit: OUT std_logic_vector(3 DOWNTO 0);
      invalid: OUT std_logic;
      light: OUT std_logic);
END controller;
--each state is either a box or a diamond


ARCHITECTURE logic_controller OF controller IS
   signal counter_delay, door_delay: integer;
   signal cur_state: integer;
   signal prev_D: std_logic_vector(3 DOWNTO 0);
   signal templight, tempinvalid: std_logic;
BEGIN
    PROCESS(clk)
    BEGIN
      IF rising_edge(clk) THEN
        IF SW_ON = '0' AND SW_OFF = '0' AND SW_DOOR = '0' THEN -- means reset
          counter_delay <= 0;
          door_delay <= 0;
          cur_state <= 0;
          tempinvalid <= '1';
          templight <= '0';
        ELSIF SW_ON = '1' THEN
          IF SW_OFF = '1' OR SW_DOOR = '1' THEN
            tempinvalid <= '1';
            templight <= '0';
          ELSE
            tempinvalid <= '0';
            templight <= '1';
          END IF;
        ELSIF SW_OFF = '1' THEN
          IF SW_ON = '1' OR SW_DOOR = '1' THEN
            tempinvalid <= '1';
            templight <= '0';
          ELSE
            tempinvalid <= '0';
            templight <= '0';
          END IF; --------------------------------------------ALL EASY TILL HERE----------------------------------------------------
        ELSIF SW_DOOR = '1' THEN
          IF SW_OFF = '1' OR SW_ON = '1' THEN
            tempinvalid <= '1';
            templight <= '0';
          ELSE
            tempinvalid <= '0';
            IF cur_state = 0 THEN
              IF door_key = '1' THEN
                cur_state <= 1;
              ELSE
                cur_state <= 0; -- let it be what it is right now.
              END IF;
            ELSIF cur_state = 1 THEN
              IF D /= "0000" THEN
                cur_state <= 2;
              ELSE
                cur_state <= 1; 
              END IF;
            ELSIF cur_state = 2 THEN
              templight <= '1';
              door_delay <= 0;
              counter_delay <= 0;  
              cur_state <= 3;
            ELSIF cur_state = 3 THEN
              IF D /= "0000" THEN
                IF prev_D /= D THEN --a new door is opened
                  cur_state <= 2;
                ELSE            
                  cur_state <= 4;
                END IF;
              ELSE
                door_delay <= 0;
                counter_delay <= 0;
                cur_state <= 6; 
              END IF;   
            ELSIF cur_state = 4 THEN 
              IF D = "0000" THEN 
                cur_state <= 2;  
              ELSE
                IF prev_D /= D THEN --a new door is opened
                  cur_state <= 2;
                ELSE
                  cur_state <= 5;
                END IF;
              END IF;
            ELSIF cur_state = 5 THEN
              IF prev_D /= D THEN --a new door is opened
                cur_state <= 2;
              ELSE
                IF counter_delay <= 7630 THEN --10 s
                  counter_delay <= counter_delay + 3;
                  cur_state <= 3;
                ELSE
                  IF door_delay <= 2289 THEN --3 s 
                    door_delay <= door_delay + 3;
                    cur_state <= 3;
                  ELSE
                    templight <= '0';
                    cur_state <= 4;
                  END IF;
                END IF;
              END IF;
            ELSIF cur_state = 6 THEN
              IF templight = '1' THEN
                IF D /= "0000" THEN
                  cur_state <= 2;
                ELSE
                  IF door_delay <= 2289 THEN --3 s
                    door_delay <= door_delay + 1;
                  ELSE
                    templight <= '0';  
                    cur_state <= 7;
                  END IF;
                END IF;
              ELSE
                cur_state <= 7;
              END IF;
            ELSIF cur_state = 7 THEN  -------------------------------------CORRECT TILL HERE-------------------------------------------------
              IF D /= "0000" THEN
                cur_state <= 2;
              ELSE
                IF ignition = '1' THEN
                  counter_delay <= 0;
                  door_delay <= 0;
                  cur_state <= 8;
                ELSE
                  IF door_key = '1' THEN
                    cur_state <= 0;
                  ELSE
                    cur_state <= 7;
                  END IF;
                END IF;
              END IF;
            ELSIF cur_state = 8 THEN
              IF D /= "0000" THEN
                cur_state <= 2;
              ELSE
                counter_delay <= 0;
                door_delay <= 0;
                cur_state <= 9;
              END IF;
            ELSIF cur_state = 9 THEN
              IF D /= "0000" THEN
                cur_state <= 2;
              ELSE
                IF ignition = '1' THEN
                  IF templight = '1' THEN
                    IF counter_delay <= 7630 THEN
                      counter_delay <= counter_delay + 1;
                      cur_state <= 9;
                    ELSE
                      IF door_delay <= 2289 THEN
                        door_delay <= door_delay + 1;
                      ELSE
                        templight <= '0';
                        cur_state <= 9;
                      END IF;
                    END IF;
                  ELSE
                    cur_state <= 9;
                  END IF;
                ELSE
                  cur_state <= 10;
                END IF;
              END IF;
            ELSIF cur_state = 10 THEN
              templight <= '1';
              door_delay <= 0;
              counter_delay <= 0;
              cur_state <= 11;
            ELSIF cur_state = 11 THEN
              IF ignition = '1' THEN
                cur_state <= 8;
              ELSE
                IF D = "0000" THEN
                  IF counter_delay <= 7630 THEN
                    counter_delay <= counter_delay + 1;
                    cur_state <= 11;
                  ELSE
                    IF door_delay <= 2289 THEN
                      door_delay <= door_delay + 1;
                    ELSE
                      templight <= '0';
                      cur_state <= 11;
                    END IF;
                  END IF;
                ELSE
                  cur_state <= 12;
                END IF;
              END IF;
            ELSIF cur_state = 12 THEN
              IF templight = '0' THEN
                templight <= '1';
                cur_state <= 12;
              ELSE
                door_delay <= 0;
                counter_delay <= 0;
                cur_state <= 13;
              END IF;
            ELSIF cur_state = 13 THEN 
              IF D /= "0000" THEN
                IF prev_D /= D THEN --a new door is opened
                  cur_state <= 12;
                ELSE
                  cur_state <= 14;
                END IF;
              ELSE
                door_delay <= 0;
                counter_delay <= 0;
                cur_state <= 16; --come back here 
              END IF;
            ELSIF cur_state = 14 THEN
              IF D = "0000" THEN 
                cur_state <= 12;  
              ELSE
                IF prev_D /= D THEN --a new door is opened
                  cur_state <= 12;
                ELSE
                  cur_state <= 15;
                END IF;
              END IF;
            ELSIF cur_state = 15 THEN
              IF prev_D /= D THEN --a new door is opened
                cur_state <= 12;
              ELSE
                IF counter_delay <= 7630 THEN --10 s
                  counter_delay <= counter_delay + 3;
                  cur_state <= 13;
                ELSE
                  IF door_delay <= 2289 THEN --3 s
                    door_delay <= door_delay + 3;
                  ELSE
                    templight <= '0';
                    cur_state <= 14;
                  END IF;
                END IF;
              END IF;
            ELSIF cur_state = 16 THEN
              IF templight = '1' THEN
                IF D /= "0000" THEN
                  cur_state <= 12;
                ELSE
                  IF door_delay <= 2289 THEN --3 s
                    door_delay <= door_delay + 1;
                  ELSE
                    templight <= '0';
                    cur_state <= 17;
                  END IF;
                END IF;
              ELSE
                cur_state <= 17;
              END IF;  
            ELSIF cur_state = 17 THEN
              IF D /= "0000" THEN
                cur_state <= 12;
              ELSE
                IF ignition = '1' THEN
                  counter_delay <= 0;
                  door_delay <= 0;
                  cur_state <= 8;
                ELSE
                  IF door_key = '1' THEN
                    cur_state <= 18;
                  ELSE
                    cur_state <= 17;
                  END IF;
                END IF;
              END IF;
            ELSIF cur_state = 18 THEN
              IF door_key = '0' THEN
                cur_state <= 0;
              ELSE
                cur_state <= 18;
              END IF;
            END IF;
          END IF;
        END IF;
        prev_D <= D;
        counter_delay_bit <= std_logic_vector(to_unsigned((counter_delay)/763, 4));
        door_delay_bit <= std_logic_vector(to_unsigned((door_delay)/763, 4));
        light <= templight;
        invalid <= tempinvalid;
      END IF;  
    END PROCESS;
END ARCHITECTURE logic_controller;



---------------------------------------------------Main Component-----------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.numeric_std.ALL;

ENTITY mini_project IS
PORT (pushbutton: IN std_logic;
      SW_DOOR: IN std_logic;
      clk: IN std_logic;
      SW_ON : IN std_logic;
      SW_OFF : IN std_logic;
   --   reset: IN std_logic; it's useless
      D: IN std_logic_vector(3 DOWNTO 0); 
      door_key: IN std_logic;
      ignition: IN std_logic;
      anode: OUT std_logic_vector(3 DOWNTO 0);
      cathode: OUT std_logic_vector(6 DOWNTO 0);
      invalid: OUT std_logic;
      light: OUT std_logic); 
END mini_project;


ARCHITECTURE logic_mini OF mini_project IS
  signal slow_clk: std_logic;
  signal counter_delay_bit: std_logic_vector(3 DOWNTO 0);
  signal door_delay_bit: std_logic_vector(3 DOWNTO 0);
BEGIN

  C: ENTITY WORK.clock(clock_arc)
     PORT MAP(clk => clk, 
              finClk => slow_clk,
              pushbutton => pushbutton);

  M: ENTITY WORK.controller(logic_controller)
     PORT MAP(SW_DOOR => SW_DOOR,
              clk => slow_clk,
              SW_ON => SW_ON,
              SW_OFF => SW_OFF,
              D => D, 
              door_key => door_key,
              ignition => ignition,
              counter_delay_bit => counter_delay_bit,
              door_delay_bit => door_delay_bit,
              invalid => invalid,
              light => light);

  SSD: ENTITY WORK.ssd(ssd_logic)
       PORT MAP(clk => slow_clk, 
                idle_count => counter_delay_bit,
                off_count => door_delay_bit,
                anode => anode,
                cathode => cathode);

END ARCHITECTURE;


