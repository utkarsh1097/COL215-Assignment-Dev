---------------------------------------------------------------SLOW CLOCK--------------------------------------------
-----------------------------------------------------------------------------------------------------------------
	

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
    signal prescaler : std_logic_vector(18 downto 0) := "0000000000000000000";
BEGIN
    process(clk_100Mhz)
    begin
    if rising_edge(clk_100Mhz) then   -- rising clock edge
      prescaler <= prescaler + 1;
    end if;
      clk_2KHz <= prescaler(18);
  end process;
END ARCHITECTURE;



-------------------------------------------------------------------------FINAL CLOCK-----------------------------------------------
---------------------------------------------------------------------------------------------------------------------

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


-------------------------------------------ANODE GENERATOR -------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use IEEE.NUMERIC_STD.all;

ENTITY anode_gen IS
PORT(
    clk : in  std_logic;
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



--------------------------------------------------SSD FINAL BLOCK-----------------------------------
-----------------------------------------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use IEEE.NUMERIC_STD.all;

ENTITY ssd_final IS
PORT(
	clk: In STD_logic;
	display_button:In STD_logic;
	quotient: IN std_logic_vector(7 downto 0);
	remainder: IN std_logic_vector(7 downto 0);	
	anode: OUT std_logic_vector(3 downto 0);
	cathode: OUT std_logic_vector(6 downto 0) 	
);

END ENTITY;

ARCHITECTURE ssd_final_arc OF ssd_final IS
signal finClk: std_logic;
signal dumAnode: std_logic_vector(3 downto 0);
SIGNAL bcd: std_logic_vector(3 downto 0);
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
        PROCESS(dumAnode)
        BEGIN
	  IF valid = '1' THEN anode <= dumAnode;
          END IF;
        END PROCESS; 
	PROCESS(product, dumAnode)
         BEGIN
           IF dumAnode = "1110" THEN bcd<= remainder(3 downto 0);
           ELSIF dumAnode = "1101" THEN bcd<= remainder(7 downto 4);
           ELSIF dumAnode = "1011" THEN bcd<= quotient(3 downto 0);
           ELSIF dumAnode = "0111" THEN bcd<= quotient(7 downto 4);
           ELSE dummy <= '0';
           END IF;
        END PROCESS;    

        process(bcd)
          BEGIN
            IF bcd = "0000" THEN cathode <="1000000";  
            ELSIF bcd = "0001" THEN cathode <="1111001";  
            ELSIF bcd = "0010" THEN cathode <="0100100";  
            ELSIF bcd = "0011" THEN cathode <="0110000";  
            ELSIF bcd = "0100" THEN cathode <="0011001";  
            ELSIF bcd = "0101" THEN cathode <="0010010";  
            ELSIF bcd = "0110" THEN cathode <="0000010";  
            ELSIF bcd = "0111" THEN cathode <="1111000";  
            ELSIF bcd = "1000" THEN cathode <="0000000";  
            ELSIF bcd = "1001" THEN cathode <="0010000";
            ELSIF bcd = "1010" THEN cathode <="0001000";  
            ELSIF bcd = "1011" THEN cathode <="0000011";  
            ELSIF bcd = "1100" THEN cathode <="1000110";  
            ELSIF bcd = "1101" THEN cathode <="0100001";  
            ELSIF bcd = "1110" THEN cathode <="0000110";
            ELSIF bcd = "1111" THEN cathode <="0001110";
            ELSE dummy <= '0';
            END IF;  
       end process;

END ARCHITECTURE;



----------------Sub-circuit 1 (Register File)-------------- --Register file will store R->Remainder(16 bit), Q->Qoutient(8 bit), D=B*2^7(15 bit)
 
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
------D Flip Flop------
ENTITY dff IS
PORT (D: IN std_logic;
      clk: IN std_logic;
      Q: OUT std_logic);
END dff;
 
 
ARCHITECTURE dflipflop OF dff IS
BEGIN
  PROCESS(clk)
  BEGIN
    IF rising_edge(clk) THEN
      Q <= D;
    END IF;
  END PROCESS;
END ARCHITECTURE dflipflop;
 
 
 
------REGISTER for 8 bits------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
 
ENTITY registr1 IS
PORT (X: IN  std_logic_vector(7 DOWNTO 0);
      clk: IN std_logic;
      Y: OUT std_logic_vector(7 DOWNTO 0));
END registr;
 
 
ARCHITECTURE reg1 OF registr1 IS
BEGIN
  ff0:ENTITY WORK.dff(dflipflop)
      PORT MAP(D=>X(0) , clk=>clk, Q=>Y(0));
 
  ff1:ENTITY WORK.dff(dflipflop)
      PORT MAP(D=>X(1) , clk=>clk, Q=>Y(1));
 
  ff2:ENTITY WORK.dff(dflipflop)
      PORT MAP(D=>X(2) , clk=>clk, Q=>Y(2));
 
  ff3:ENTITY WORK.dff(dflipflop)
      PORT MAP(D=>X(3) , clk=>clk, Q=>Y(3));
 
  ff4:ENTITY WORK.dff(dflipflop)
      PORT MAP(D=>X(4) , clk=>clk, Q=>Y(4));
 
  ff5:ENTITY WORK.dff(dflipflop)
      PORT MAP(D=>X(5) , clk=>clk, Q=>Y(5));
 
  ff6:ENTITY WORK.dff(dflipflop)
      PORT MAP(D=>X(6) , clk=>clk, Q=>Y(6));
 
  ff7:ENTITY WORK.dff(dflipflop)
      PORT MAP(D=>X(7) , clk=>clk, Q=>Y(7));
  
END ARCHITECTURE reg1;



------REGISTER for 15 bits------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
 
ENTITY registr2 IS
PORT (X: IN  std_logic_vector(14 DOWNTO 0);
      clk: IN std_logic;
      Y: OUT std_logic_vector(14 DOWNTO 0));
END registr;
 
 
ARCHITECTURE reg2 OF registr2 IS
BEGIN
  ff0:ENTITY WORK.dff(dflipflop)
      PORT MAP(D=>X(0) , clk=>clk, Q=>Y(0));
 
  ff1:ENTITY WORK.dff(dflipflop)
      PORT MAP(D=>X(1) , clk=>clk, Q=>Y(1));
 
  ff2:ENTITY WORK.dff(dflipflop)
      PORT MAP(D=>X(2) , clk=>clk, Q=>Y(2));
 
  ff3:ENTITY WORK.dff(dflipflop)
      PORT MAP(D=>X(3) , clk=>clk, Q=>Y(3));
 
  ff4:ENTITY WORK.dff(dflipflop)
      PORT MAP(D=>X(4) , clk=>clk, Q=>Y(4));
 
  ff5:ENTITY WORK.dff(dflipflop)
      PORT MAP(D=>X(5) , clk=>clk, Q=>Y(5));
 
  ff6:ENTITY WORK.dff(dflipflop)
      PORT MAP(D=>X(6) , clk=>clk, Q=>Y(6));
 
  ff7:ENTITY WORK.dff(dflipflop)
      PORT MAP(D=>X(7) , clk=>clk, Q=>Y(7));

  ff8:ENTITY WORK.dff(dflipflop)
      PORT MAP(D=>X(8) , clk=>clk, Q=>Y(8));
 
  ff9:ENTITY WORK.dff(dflipflop)
      PORT MAP(D=>X(9) , clk=>clk, Q=>Y(9));
 
  ff10:ENTITY WORK.dff(dflipflop)
      PORT MAP(D=>X(10) , clk=>clk, Q=>Y(10));
 
  ff11:ENTITY WORK.dff(dflipflop)
      PORT MAP(D=>X(11) , clk=>clk, Q=>Y(11));
 
  ff12:ENTITY WORK.dff(dflipflop)
      PORT MAP(D=>X(12) , clk=>clk, Q=>Y(12));
 
  ff13:ENTITY WORK.dff(dflipflop)
      PORT MAP(D=>X(13) , clk=>clk, Q=>Y(13));
 
  ff14:ENTITY WORK.dff(dflipflop)
      PORT MAP(D=>X(14) , clk=>clk, Q=>Y(14));

END ARCHITECTURE reg2;


------REGISTER for 16 bits------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
 
ENTITY registr3 IS
PORT (X: IN  std_logic_vector(15 DOWNTO 0);
      clk: IN std_logic;
      Y: OUT std_logic_vector(15 DOWNTO 0));
END registr;
 
 
ARCHITECTURE reg3 OF registr3 IS
BEGIN
  ff0:ENTITY WORK.dff(dflipflop)
      PORT MAP(D=>X(0) , clk=>clk, Q=>Y(0));
 
  ff1:ENTITY WORK.dff(dflipflop)
      PORT MAP(D=>X(1) , clk=>clk, Q=>Y(1));
 
  ff2:ENTITY WORK.dff(dflipflop)
      PORT MAP(D=>X(2) , clk=>clk, Q=>Y(2));
 
  ff3:ENTITY WORK.dff(dflipflop)
      PORT MAP(D=>X(3) , clk=>clk, Q=>Y(3));
 
  ff4:ENTITY WORK.dff(dflipflop)
      PORT MAP(D=>X(4) , clk=>clk, Q=>Y(4));
 
  ff5:ENTITY WORK.dff(dflipflop)
      PORT MAP(D=>X(5) , clk=>clk, Q=>Y(5));
 
  ff6:ENTITY WORK.dff(dflipflop)
      PORT MAP(D=>X(6) , clk=>clk, Q=>Y(6));
 
  ff7:ENTITY WORK.dff(dflipflop)
      PORT MAP(D=>X(7) , clk=>clk, Q=>Y(7));

  ff8:ENTITY WORK.dff(dflipflop)
      PORT MAP(D=>X(8) , clk=>clk, Q=>Y(8));
 
  ff9:ENTITY WORK.dff(dflipflop)
      PORT MAP(D=>X(9) , clk=>clk, Q=>Y(9));
 
  ff10:ENTITY WORK.dff(dflipflop)
      PORT MAP(D=>X(10) , clk=>clk, Q=>Y(10));
 
  ff11:ENTITY WORK.dff(dflipflop)
      PORT MAP(D=>X(11) , clk=>clk, Q=>Y(11));
 
  ff12:ENTITY WORK.dff(dflipflop)
      PORT MAP(D=>X(12) , clk=>clk, Q=>Y(12));
 
  ff13:ENTITY WORK.dff(dflipflop)
      PORT MAP(D=>X(13) , clk=>clk, Q=>Y(13));
 
  ff14:ENTITY WORK.dff(dflipflop)
      PORT MAP(D=>X(14) , clk=>clk, Q=>Y(14));

  ff15:ENTITY WORK.dff(dflipflop)
      PORT MAP(D=>X(15) , clk=>clk, Q=>Y(15));

END ARCHITECTURE reg3;

------REGISTER FILE------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY registr_file IS
PORT (Qin: IN  std_logic_vector(7 DOWNTO 0); ---Quotient
      Din: IN std_logic_vector(14 DOWNTO 0); ---D
      Rin: IN std_logic_vector(15 DOWNTO 0); ---A (A needs to have 8 more bits to the left). This is for remainder
      clk: IN std_logic;
      Qout: OUT std_logic_vector(7 DOWNTO 0);
      Dout: OUT std_logic_vector(14 DOWNTO 0);
      Rout: OUT std_logic_vector(15 DOWNTO 0));
END registr_file;
 
 
ARCHITECTURE reg_file OF registr_file IS
BEGIN
  r1: ENTITY WORK.registr1(reg1)
      PORT MAP(X=>Qin, clk=>clk, Y=>Qout);
  r3: ENTITY WORK.registr2(reg2)
      PORT MAP(X=>Din, clk=>clk, Y=>Dout);
  r4: ENTITY WORK.registr3(reg3)
      PORT MAP(X=>Rin, clk=>clk, Y=>Rout); 
      
END ARCHITECTURE reg_file;


----------------Sub-circuit 2 (Validation)----------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
 
------INPUT VALIDATE------
ENTITY validate IS
PORT (divisor: IN std_logic_vector(7 DOWNTO 0);
      valid: OUT std_logic);
END validate;
 
 
ARCHITECTURE valid_logic OF validate IS
BEGIN
  PROCESS(divisor)
  BEGIN
    IF divisor = "00000000" THEN
      valid <= '0';
    ELSE valid <= '1';
    END IF;
  END PROCESS;
END ARCHITECTURE valid_logic;


----------------Sub-circuit 3 (Division)----------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.all;



ENTITY division IS
PORT (Qin: IN  std_logic_vector(7 DOWNTO 0); ---Quotient
      Din: IN std_logic_vector(14 DOWNTO 0); ---D
      Rin: IN std_logic_vector(15 DOWNTO 0); ---A (A needs to have 8 more bits to the left). This is for remainder
      B: IN std_logic_vector(7 DOWNTO 0); ---This value of B is just for sake of validation.
      clk: IN std_logic;
      Qout: OUT std_logic_vector(7 DOWNTO 0);
      Dout: OUT std_logic_vector(14 DOWNTO 0);
      Rout: OUT std_logic_vector(15 DOWNTO 0));
END division;


ARCHITECTURE div_logic OF division IS
BEGIN
  PROCESS(clk)
  BEGIN
    IF rising_edge(clk) and unsigned(B)<=unsigned(Din) THEN
      IF unsigned(Din) <= unsigned(Rin) THEN
        Rout <= std_logic_vector(unsigned(Rin) - unsigned(Din));
        Qout <= std_logic_vector(unsigned(Qin)*2 + 1));
      ELSE 
        Qout <= std_logic_vector(unsigned(Qin)*2));
        Rout <= Rin;
      END IF;
      Dout <= std_logic_vector(unsigned(Din)/2);
    END IF;
  END PROCESS;
END ARCHITECTURE div_logic;



----------------------------------MAIN CIRCUIT-------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;


ENTITY lab7_divider IS
PORT (divisor: IN std_logic_vector(7 DOWNTO 0);
      dividend: IN std_logic_vector(7 DOWNTO 0);
      load_inputs: IN std_logic;
      clk: IN std_logic;
      sim_mode: IN std_logic;
      output_valid: OUT std_logic;
      input_valid: OUT std_logic;
      anode: OUT std_logic_vector(3 DOWNTO 0);
      cathode: OUT std_logic_vector(6 DOWNTO 0)); 
END lab7_divider;


ARCHITECTURE lab7_logic OF lab7_divider IS
  signal valid: std_logic;
  --signal slow_clk: std_logic;
  signal toutput_valid: std_logic;
  signal divisor_sign, dividend_sign: std_logic;     --0 means positive, 1 means negative
  signal A, B: std_logic_vector(7 DOWNTO 0);
  variable tempA, tempB: std_logic_vector(7 DOWNTO 0);
  signal quotient_to_ssd, remainder_to_ssd: std_logic_vector(7 DOWNTO 0);
  variable tquotient_to_ssd, tremainder_to_ssd: std_logic_vector(7 DOWNTO 0);
  signal Q_in_reg: std_logic_vector(7 DOWNTO 0);
  signal D_in_reg: std_logic_vector(14 DOWNTO 0);
  signal R_in_reg: std_logic_vector(15 DOWNTO 0);
  signal Q_out_reg: std_logic_vector(7 DOWNTO 0);
  signal D_out_reg: std_logic_vector(14 DOWNTO 0);
  signal R_out_reg: std_logic_vector(15 DOWNTO 0);
  signal Q_out_div: std_logic_vector(7 DOWNTO 0);
  signal D_out_div: std_logic_vector(14 DOWNTO 0);
  signal R_out_div: std_logic_vector(15 DOWNTO 0);
BEGIN
  
  output_valid <= '0';
  toutput_valid <= '0';

  PROCESS(dividend)
  BEGIN
    IF dividend(7) = '1' THEN
      dividend_sign <= '1';
      tempA := std_logic_vector(unsigned(dividend) - 1);
      FOR i in 0 to 7 LOOP 
        A(i) <= NOT tempA(i);
      END LOOP;
    ELSE 
      A <= dividend;
      dividend_sign <= '0';
    END IF;
  END PROCESS;
  
  PROCESS(divisor)
  BEGIN
    IF divisor(7) = '1' THEN
      divisor_sign <= '1';
      tempB := std_logic_vector(unsigned(divisor) - 1);
      FOR i in 0 to 7 LOOP 
        B(i) <= NOT tempB(i);
      END LOOP;
    ELSE 
      B <= divisor;
      divisor_sign <= '0';    
    END IF;
  END PROCESS;
  
  v: ENTITY WORK.valid(valid_logic)
     PORT MAP(divisor => divisor, valid => valid);
  input_valid <= valid;

  PROCESS(load_inputs, valid, clk)
  BEGIN
    IF valid = '1' and load_inputs = '1' and rising_edge(clk) THEN 
      Q_in_reg <= "00000000";
      R_in_reg(7 DOWNTO 0) <= A;
      R_in_reg(15 DOWNTO 8) <= "00000000";
      D_in_reg(14 DOWNTO 7) <= B;
      D_in_reg(6 DOWNTO 0) <= "0000000";
    END IF;
  END PROCESS;
 

  r: ENTITY WORK.registr_file(reg_file)
     PORT MAP(Qin => Q_in_reg, Rin => R_in_reg, Din => D_in_reg, Qout => Q_out_reg, Rout => R_out_reg, Dout => D_out_reg, clk => clk);

  d: ENTITY WORK.division(div_logic)
     PORT MAP(Qin => Q_out_reg, Rin => R_out_reg, Din => D_out_reg, B => B, clk => clk, Qout => Q_out_div, Rout => R_out_div, Dout => D_out_div);


  PROCESS(D_out_div, clk)
  BEGIN
    IF unsigned(D_out_div) < unsigned(B) and rising_edge(clk) THEN
      toutput_valid <= '1';
    ELSE
      Q_in_reg <= Q_out_div;
      D_in_reg <= D_out_div;
      R_in_reg <= R_out_div;
    END IF;
  END PROCESS;
 

  output_valid <= toutput_valid;

  PROCESS(output_valid)
  BEGIN
    IF output_valid = '1' THEN
      IF divisor_sign = '0' AND dividend_sign = '0' THEN 
         quotient_to_ssd <= Q_out_div;
         remainder_to_ssd <= R_out_div(7 DOWNTO 0);
      ELSIF divisor_sign = '0' AND dividend_sign = '1' THEN
        FOR i in 0 to 7 LOOP 
          tquotient_to_ssd(i) := NOT Q_out_div(i);
        END LOOP;
        quotient_to_ssd <= std_logic_vector(unsigned(tquotient_to_ssd)+1);
        FOR i in 0 to 7 LOOP 
          tremainder_to_ssd(i) := NOT R_out_div(i);
        END LOOP;
        remainder_to_ssd <= std_logic_vector(unsigned(tremainder_to_ssd)+1);
      ELSIF divisor_sign = '1' AND dividend_sign = '0' THEN
        FOR i in 0 to 7 LOOP 
          tquotient_to_ssd(i) := NOT Q_out_div(i);
        END LOOP;
        quotient_to_ssd <= std_logic_vector(unsigned(tquotient_to_ssd)+1);
        remainder_to_ssd <= R_out_div(7 DOWNTO 0);
      ELSE 
        quotient_to_ssd <= Q_out_div;
        FOR i in 0 to 7 LOOP 
          tremainder_to_ssd(i) := NOT R_out_div(i);
        END LOOP;
        remainder_to_ssd <= std_logic_vector(unsigned(tremainder_to_ssd)+1);
      END IF;
    END IF;
  END PROCESS;
  
  ssd: ENTITY WORK.ssd_final(ssd_final_arc)
       PORT MAP(clk => clk, quotient => quotient_to_ssd, remainder => remainder_to_ssd, anode => anode, cathode => cathode, display_button => sim_mode);

END ARCHITECTURE lab7_logic;

