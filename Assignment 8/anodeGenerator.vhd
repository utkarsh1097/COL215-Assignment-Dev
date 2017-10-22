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