LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY ssd IS 
PORT (
	d_o: in std_logic_vector(15 downto 0);
	cathode: out std_logic_vector(6 downto 0);
	anode: in std_logic_vector(3 downto 0)
	);
END ssd;



ARCHITECTURE ssd_arc OF ssd IS
	SIGNAL bcd: std_logic_vector(3 downto 0);
	begin
	   PROCESS(d_o)
	   BEGIN
		CASE anode Is
			WHEN "1110" =>bcd<= d_o(3 downto 0);
			WHEN "1101" =>bcd<= d_o(7 downto 4);
			WHEN "1011" =>bcd<= d_o(11 downto 8);
			WHEN "0111" =>bcd<= d_o(15 downto 12);
		END CASE;
	END PROCESS;	
		
		process(bcd)
			BEGIN
			 CASE bcd IS
				WHEN "0000"=> cathode <="0000001";  
				WHEN "0001"=> cathode <="1001111";  
				WHEN "0010"=> cathode <="0010010";  
				WHEN "0011"=> cathode <="0000110";  
				WHEN "0100"=> cathode <="1001100";  
				WHEN "0101"=> cathode <="0100100";  
				WHEN "0110"=> cathode <="0100000";  
				WHEN "0111"=> cathode <="0001111";  
				WHEN "1000"=> cathode <="0000000";  
				WHEN "1001"=> cathode <="0000100";  
				--WHEN others=> cathode <=; 
			 end case;
	   end process;
END ssd_arc;
------------------------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use IEEE.NUMERIC_STD.all;

ENTITY slowClock IS
PORT(
    clk_100Mhz : in  std_logic;
    --rst       : in  std_logic;
    clk_2KHz   : out std_logic
);
END ENTITY;	
ARCHITECTURE slowClock_arc OF slowClock IS
    signal prescaler : unsigned(23 downto 0);
    signal clk_2KHz_i : std_logic;
BEGIN
    gen_clk : process (clk_100Mhz)
  begin  -- process gen_clk
    --if rst = '1' then
      --clk_2Hz_i   <= '0';
      --prescaler   <= (others => '0');
    if rising_edge(clk_100Mhz) then   -- rising clock edge
      if prescaler = 25000 then     -- 12 500 000 in hex
        prescaler   <= (others => '0');
        clk_2KHz_i   <= not clk_2KHz_i;
      else
        prescaler <= prescaler + 1;
      end if;
    end if;
  end process gen_clk;
  clk_2KHz <= clk_2KHz_i;
END ARCHITECTURE;
---------------------------------------------

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
        if(pushbutton <= '1') then finclk <= clk;
        elsif(pushbutton <= '0') then finclk <= slowClock;
        end if;
            
    END PROCESS;    
END ARCHITECTURE;

------------------------------------------------------------------
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
signal danode : std_logic_vector;

BEGIN
PROCESS(clk)
    variable j : integer range 0 to 7 := 0;
    BEGIN
    if rising_edge(clk) and j=0 then
        danode <= "1110";
        j := 1;   
    elsif rising_edge(clk) and j=1 then
            danode <= "1101";
            j := 2;
     elsif rising_edge(clk) and j=2 then
            danode <= "1101";
            j := 3;
      elsif rising_edge(clk) and j=3 then
            danode <= "1101";
            j := 1;                         
      end if;
    END PROCESS;
    anode <= danode;
END Architecture;

