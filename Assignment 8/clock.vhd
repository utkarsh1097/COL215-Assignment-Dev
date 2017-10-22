library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;

ENTITY slowClock IS
PORT(
    clk_100Mhz : in  std_logic;
    clk_2KHz   : out std_logic
);
END ENTITY;	
ARCHITECTURE slowClock_arc OF slowClock IS
    signal prescaler : std_logic_vector(16 downto 0) := "00000000000000000";
BEGIN
    process(clk_100Mhz)
    begin
    if rising_edge(clk_100Mhz) then   -- rising clock edge
      prescaler <= prescaler + 1;
    end if;
      clk_2KHz <= prescaler(16);
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
        clk_100Mhz => clk,
        clk_2Khz => slowClock
    ); 
    PROCESS(clk, pushbutton)
    BEGIN
        if(pushbutton = '1') then finclk <= clk;
        elsif(pushbutton = '0') then finclk <= slowClock;
        end if;
            
    END PROCESS;    
END ARCHITECTURE;