------------------------------------------Slow Clock for more comfortable counter implementation-------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.numeric_std.ALL;

ENTITY slowClock IS
PORT(
    clk_fast: IN  std_logic;
    clk_slow: OUT std_logic
);
END ENTITY;	
ARCHITECTURE slowClock_arc OF slowClock IS
    signal prescaler : std_logic_vector(16 downto 0) := "00000000000000000";
BEGIN
    PROCESS(clk_fast)
    BEGIN
    IF rising_edge(clk_fast) THEN   -- rising clock edge
      prescaler <= prescaler + 1;
    END IF;
      clk_slow <= prescaler(16);
  END PROCESS;
END ARCHITECTURE;




---------------------------------------Light Controller Logic (1 sec = 763 counts)-----------------------------------------------------


LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.numeric_std.ALL;

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


ARCHITECTURE logic_controller IS
   signal counter_delay, door_delay: integer;
   signal cur_state: integer;
   signal prev_D: std_logic_vector(3 DOWNTO 0);
BEGIN
    PROCESS(clk)
    BEGIN
      IF rising_edge(clk) THEN
        IF SW_ON == '0' AND SW_OFF == '0' AND SW_DOOR = '0' THEN -- means reset
          counter_delay <= 0;
          door_delay <= 0;
          cur_state <= 0;
        ELSIF SW_ON = '1' THEN
          IF SW_OFF = '1' OR SW_DOOR = '1' THEN
            invalid <= '1';
            light <= '0';
          ELSE
            invalid <= '0';
            light <= '1';
          END IF;
        ELSIF SW_OFF = '1' THEN
          IF SW_ON = '1' OR SW_DOOR = '1' THEN
            invalid <= '1';
            light <= '0';
          ELSE
            invalid <= '0';
            light <= '1';
          END IF; --------------------------------------------ALL EASY TILL HERE----------------------------------------------------
        ELSIF SW_DOOR = '1' THEN
          IF SW_OFF = '1' OR SW_ON = '1' THEN
            invalid <= '1';
            light <= '0';
          ELSE
            invalid <= '0';
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
              light <= '1';
              door_delay <= 0;
              counter_delay <= 0;  
              cur_state <= 3;
            ELSIF cur_state = 3 THEN
              IF D /= "0000" THEN
                cur_state <= 4;
              ELSE
                door_delay <= 0;
                counter_delay <= 0;
                cur_state <= 6; 
              END IF;   
            ELSIF cur_state = 4 THEN 
              IF D = "0000" THEN 
                cur_state <= 2;  
              ELSE
                IF prev_D < D THEN --a new door is opened
                  cur_state <= 2;
                ELSE
                  cur_state <= 5;
                END IF;
              END IF;
            ELSIF cur_state = 5 THEN
              IF counter_delay <= 7630 THEN --10 s
                counter_delay <= counter_delay + 1;
                cur_state <= 3;
              ELSE
                IF door_delay <= 2289 --3 s
                  door_delay <= door_delay + 1;
                ELSE
                  light <= '0';
                  cur_state <= 4;
                END IF;
              END IF;
            ELSIF cur_state = 6 THEN
              IF light = '1' THEN
                IF door_delay <= 2289 --3 s
                  door_delay <= door_delay + 1;
                ELSE
                  light <= '0';
                  cur_state <= 7;
                END IF;
              ELSE
                cur_state <= 7;
              END IF;
            ELSIF cur_state = 7 THEN --------------------------------------CORRECT TILL HERE-------------------------------------------------
              IF D /= "0000"
                cur_state <= 2;
              ELSE
                IF ignition = '1' THEN
                  counter_delay <= 0;
                  door_delay <= 0;
                  cur_state <= 8;
                ELSE
                  IF door_key = '1' THEN
                    cur_state <= '0';
                  ELSE
                    cur_state <= 7;
                  END IF;
                END IF;
              END IF;
            ELSIF cur_state = 8 THEN
              IF D /= "0000"
                cur_state <= 2;
              ELSE
                counter_delay <= 0;
                door_delay <= 0;
                cur_state <= 9;
              END IF;
            ELSIF cur_state = 9 THEN
              IF D /= "0000" THEN
                cur_state <= 8;
              ELSE
                IF ignition = '1' THEN
                  IF light = '1' THEN
                    IF counter_delay <= 7630 THEN
                      counter_delay <= counter_delay + 1;
                      cur_state <= 9;
                    ELSE
                      IF door_delay <= 2289 THEN
                        door_delay <= door_delay + 1;
                      ELSE
                        light <= '0';
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
              light <= '1';
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
                      light <= '0';
                      cur_state <= 11;
                    END IF;
                  END IF;
                ELSE
                  cur_state <= 12;
                END IF;
              END IF;
            ELSIF cur_state = 12 THEN
              IF light = '0' THEN
                light <= '1';
                cur_state <= 12;
              ELSE
                door_delay <= 0;
                counter_delay <= 0;
                cur_state <= 13;
              END IF;
            ELSIF cur_state = 13 THEN 
              IF D /= "0000" THEN
                cur_state <= 14;
              ELSE
                door_delay <= 0;
                counter_delay <= 0;
                cur_state <= 16; --come back here 
              END IF;
            ELSIF cur_state = 14 THEN
              IF D = "0000" THEN 
                cur_state <= 12;  
              ELSE
                IF prev_D < D THEN --a new door is opened
                  cur_state <= 12;
                ELSE
                  cur_state <= 15;
                END IF;
              END IF;
            ELSIF cur_state = 15 THEN
              IF counter_delay <= 7630 THEN --10 s
                counter_delay <= counter_delay + 1;
                cur_state <= 13;
              ELSE
                IF door_delay <= 2289 --3 s
                  door_delay <= door_delay + 1;
                ELSE
                  light <= '0';
                  cur_state <= 14;
                END IF;
              END IF;
            ELSIF cur_state = 16 THEN
              IF light = '1' THEN
                IF door_delay <= 2289 --3 s
                  door_delay <= door_delay + 1;
                ELSE
                  light <= '0';
                  cur_state <= 17;
                END IF;
              ELSE
                cur_state <= 17;
              END IF;  
            ELSIF cur_state = 17 THEN
              IF D /= "0000"
                cur_state <= 12;
              ELSE
                IF ignition = '1' THEN
                  counter_delay <= 0;
                  door_delay <= 0;
                  cur_state <= 8;
                ELSE
                  IF door_key = '1' THEN
                    cur_state <= 0;
                  ELSE
                    cur_state <= 17;
                  END IF;
                END IF;
              END IF;
            END IF;
          END IF;
        END IF;
        prev_D <= D;
        counter_delay_bit <= std_logic_vector(counter_delay);
        door_delay_bit <= std_logic_vector(door_delay);
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
PORT (SW_DOOR: IN std_logic;
      clk: IN std_logic;
      SW_ON : IN std_logic;
      SW_OFF : IN std_logic;
      SW_DOOR : IN std_logic;
   --   reset: IN std_logic; it's useless
      D: IN std_logic_vector(3 DOWNTO 0); 
      door_key: IN std_logic;
      ignition: IN std_logic;
      anode: OUT std_logic_vector(3 DOWNTO 0);
      cathode: OUT std_logic_vector(6 DOWNTO 0);
      invalid: OUT std_logic;
      light: OUT std_logic); 
END mini_project;


ARCHITECTURE logic_mini_p IS
  signal slow_clk: std_logic;
  signal counter_delay_bit: std_logic_vector(3 DOWNTO 0);
  signal door_delay_bit: std_logic_vector(3 DOWNTO 0);
BEGIN

  C: ENTITY WORK.slowClock(slowClock_arc)
     PORT MAP(clk_fast => clk, 
              clk_slow => slow_clk);

  M: ENTITY WORK.controller(logic_controller)
     PORT MAP(SW_DOOR => SW_DOOR,
              clk => slow_clk,
              SW_ON => SW_ON,
              SW_OFF => SW_OFF,
              SW_DOOR => SW_DOOR,
              D => D, 
              door_key => door_key,
              ignition => ignition,
              counter_delay_bit => counter_delay_bit,
              door_delay_bit => door_delay_bit,
              invalid => invalid,
              light => light);

  SSD: ENTITY WORK.ssd(ssd_logic)
       PORT MAP(clk => slow_clk, 
                ??? => counter_delay_bit,
                ??? => door_delay_bit,
                anode => anode,
                cathode => cathode);

END ARCHITECTURE;
