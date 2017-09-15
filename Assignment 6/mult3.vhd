
--------1 bit adder--------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY bit_adder IS
PORT (Cin: IN std_logic;
      Ai: IN std_logic;
      Bi: IN std_logic;
      Cout: OUT std_logic;
      Sout: OUT std_logic);
END bit_adder;


ARCHITECTURE adder_logic OF bit_adder IS
BEGIN
  PROCESS(Ai, Bi, Cin)
    BEGIN
      Cout <= (Ai XOR Bi XOR Cin);
      Sout <= ((Ai AND Bi) OR (Bi AND Cin) OR (Cin AND Ai));
    END PROCESS;
END ARCHITECTURE adder_logic;




--------Carry Save Module-------- (Use 6 of these)

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY carry_save IS
PORT (inp1: IN std_logic_vector(7 DOWNTO 0);
      inp2: IN std_logic_vector(7 DOWNTO 0);
      inp3: IN std_logic_vector(7 DOWNTO 0);
      out1: OUT std_logic_vector(7 DOWNTO 0);
      out2: OUT std_logic_vector(7 DOWNTO 0));
END carry_save;


ARCHITECTURE carry_save_logic OF carry_save IS
BEGIN
  b0: ENTITY WORK.bit_adder(adder_logic)
      PORT MAP(Cin=>inp1(0), Ai=>inp2(0), Bi=>inp3(0), Cout=>out1(0), Sout=>out2(0));
  b1: ENTITY WORK.bit_adder(adder_logic)
      PORT MAP(Cin=>inp1(1), Ai=>inp2(1), Bi=>inp3(1), Cout=>out1(1), Sout=>out2(1));
  b2: ENTITY WORK.bit_adder(adder_logic)
      PORT MAP(Cin=>inp1(2), Ai=>inp2(2), Bi=>inp3(2), Cout=>out1(2), Sout=>out2(2));
  b3: ENTITY WORK.bit_adder(adder_logic)
      PORT MAP(Cin=>inp1(3), Ai=>inp2(3), Bi=>inp3(3), Cout=>out1(3), Sout=>out2(3));
  b4: ENTITY WORK.bit_adder(adder_logic)
      PORT MAP(Cin=>inp1(4), Ai=>inp2(4), Bi=>inp3(4), Cout=>out1(4), Sout=>out2(4));
  b5: ENTITY WORK.bit_adder(adder_logic)
      PORT MAP(Cin=>inp1(5), Ai=>inp2(5), Bi=>inp3(5), Cout=>out1(5), Sout=>out2(5));
  b6: ENTITY WORK.bit_adder(adder_logic)
      PORT MAP(Cin=>inp1(6), Ai=>inp2(6), Bi=>inp3(6), Cout=>out1(6), Sout=>out2(6));
  b7: ENTITY WORK.bit_adder(adder_logic)
      PORT MAP(Cin=>inp1(7), Ai=>inp2(7), Bi=>inp3(7), Cout=>out1(7), Sout=>out2(7));

END ARCHITECTURE carry_save_logic;



--------Look Ahead Module--------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY cla_unit IS
PORT (P: IN std_logic_vector(3 DOWNTO 0);
      G: IN std_logic_vector(3 DOWNTO 0);
      C: IN std_logic;
      Cout: OUT std_logic_vector(3 DOWNTO 0));
      Cnext: OUT std_logic;
END cla_unit;


ARCHITECTURE cla_logic OF cla_unit IS
BEGIN
  Cout(0) <= C;
  Cout(1) <= ((P(0) AND C) OR G(0));
  Cout(2) <= ((P(1) AND P(0) AND C) OR (P(1) AND G(0)) OR G(2));
  Cout(3) <= ((P(2) AND P(1) AND P(0) AND C) OR (P(2) AND P(1) AND G(0)) OR (P(2) AND G(1)) OR G(2));
  Cnext <= ((P(3) AND P(2) AND P(1) AND P(0) AND C) OR (P(3) AND P(2) AND P(1) AND G(0)) OR (P(3) AND P(2) AND G(1)) OR (P(3) AND G(2)) OR G(3));
END ARCHITECTURE cla_logic;


--------AND-OR Module--------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY and_or IS
PORT (A: IN std_logic;
      B: IN std_logic;
      P: IN std_logic;
      G: IN std_logic);
END and_or;


ARCHITECTURE and_or_logic OF and_or IS
BEGIN
  PROCESS(A, B)
    BEGIN
      P <= A OR B;
      G <= A AND B;  
  END PROCESS;
END ARCHITECTURE and_or_logic;


--------Carry Lookahead Module-------- (Use 2 of these in a row)

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY carry_look IS
PORT (A: IN std_logic_vector(3 DOWNTO 0);
      B: IN std_logic_vector(3 DOWNTO 0);
      Cin:IN  std_logic;
      S: OUT std_logic_vector(3 DOWNTO 0);
      Cout: OUT std_logic);
END carry_look;


ARCHITECTURE carry_logic OF carry_look IS
  signal P: std_logic_vector(3 DOWNTO 0);
  signal G: std_logic_vector(3 DOWNTO 0);
  signal C: std_logic_vector(3 DOWNTO 0);
  
  signal dummy1, dummy2, dummy3, dummy0: std_logic; --Not sure if b0...b3 will need a Cout mapped, so using this beforehand to reduce further efforts
BEGIN
  ao0: ENTITY WORK.and_or(and_or_logic)
       PORT MAP(A => A(0), B => B(0), P => P(0), G => G(0));
  ao1: ENTITY WORK.and_or(and_or_logic)
       PORT MAP(A => A(1), B => B(1), P => P(1), G => G(1));
  ao2: ENTITY WORK.and_or(and_or_logic)
       PORT MAP(A => A(2), B => B(2), P => P(2), G => G(2));
  ao3: ENTITY WORK.and_or(and_or_logic)
       PORT MAP(A => A(3), B => B(3), P => P(3), G => G(3));

  cla: ENTITY WORK.cla_unit(cla_logic)
       PORT MAP(P => P, G => G, C => Cin, Cout => C, Cnext => Cout);
  
  b0: ENTITY WORK.bit_adder(adder_logic)
       PORT MAP(Cin => C(0), A => A(0), B => B(0), S => S(0), Cout => dummy0);
  b1: ENTITY WORK.bit_adder(adder_logic)
       PORT MAP(Cin => C(1), A => A(1), B => B(1), S => S(1), Cout => dummy1);
  b2: ENTITY WORK.bit_adder(adder_logic)
       PORT MAP(Cin => C(2), A => A(2), B => B(2), S => S(2), Cout => dummy2);
  b3: ENTITY WORK.bit_adder(adder_logic)
       PORT MAP(Cin => C(3), A => A(3), B => B(3), S => S(3), Cout => dummy3);
END ARCHITECTURE carry_logic;


--------Multiplier 3--------

ENTITY mult3 IS
PORT (A: IN std_logic_vector(7 DOWNTO 0);
      B: IN std_logic_vector(7 DOWNTO 0);
      S: OUT std_logic_vector(15 DOWNTO 0));
END mult3;


ARCHITECTURE mult3_logic OF mult3 IS --For n bit multiplication, use (n-2) carry save modules and 2 carry lookahead modules (in a row) 
  signal p0: std_logic_vector(7 DOWNTO 0);
  signal p1: std_logic_vector(7 DOWNTO 0);
  signal p2: std_logic_vector(7 DOWNTO 0);
  signal p3: std_logic_vector(7 DOWNTO 0);
  signal p4: std_logic_vector(7 DOWNTO 0);
  signal p5: std_logic_vector(7 DOWNTO 0);
  signal p6: std_logic_vector(7 DOWNTO 0);
  signal p7: std_logic_vector(7 DOWNTO 0);

  signal inp1_1, inp1_2, inp1_3: std_logic_vector(7 DOWNTO 0);
  signal out1_1, out1_2: std_logic_vector(7 DOWNTO 0);
  signal inp2_1, inp2_2, inp2_3: std_logic_vector(7 DOWNTO 0);
  signal out2_1, out2_2: std_logic_vector(7 DOWNTO 0);
  signal inp3_1, inp3_2, inp3_3: std_logic_vector(7 DOWNTO 0);
  signal out3_1, out3_2: std_logic_vector(7 DOWNTO 0);
  signal inp4_1, inp4_2, inp4_3: std_logic_vector(7 DOWNTO 0);
  signal out4_1, out4_2: std_logic_vector(7 DOWNTO 0);
  signal inp5_1, inp5_2, inp5_3: std_logic_vector(7 DOWNTO 0);
  signal out5_1, out5_2: std_logic_vector(7 DOWNTO 0);
  signal inp6_1, inp6_2, inp6_3: std_logic_vector(7 DOWNTO 0);
  signal out6_1, out6_2: std_logic_vector(7 DOWNTO 0);

  signal inp7_1, inp7_2: std_logic_vector(7 DOWNTO 0);
  signal out7_1: std_logic_vector(7 DOWNTO 0);

  signal carryover1, carryover2: std_logic;

BEGIN
  PROCESS(A, B)
    BEGIN --p[i][j]=a[i].b[j]
      p0(0) <= a(0) AND b(0);
      p0(1) <= a(0) AND b(1);
      p0(2) <= a(0) AND b(2); 
      p0(3) <= a(0) AND b(3);
      p0(4) <= a(0) AND b(4);
      p0(5) <= a(0) AND b(5);
      p0(6) <= a(0) AND b(6);
      p0(7) <= a(0) AND b(7);
       
      p1(0) <= a(1) AND b(0);
      p1(1) <= a(1) AND b(1);
      p1(2) <= a(1) AND b(2); 
      p1(3) <= a(1) AND b(3);
      p1(4) <= a(1) AND b(4);
      p1(5) <= a(1) AND b(5);
      p1(6) <= a(1) AND b(6);
      p1(7) <= a(1) AND b(7);

      p2(0) <= a(2) AND b(0);
      p2(1) <= a(2) AND b(1);
      p2(2) <= a(2) AND b(2); 
      p2(3) <= a(2) AND b(3);
      p2(4) <= a(2) AND b(4);
      p2(5) <= a(2) AND b(5);
      p2(6) <= a(2) AND b(6);
      p2(7) <= a(2) AND b(7);

      p3(0) <= a(3) AND b(0);
      p3(1) <= a(3) AND b(1);
      p3(2) <= a(3) AND b(2); 
      p3(3) <= a(3) AND b(3);
      p3(4) <= a(3) AND b(4);
      p3(5) <= a(3) AND b(5);
      p3(6) <= a(3) AND b(6);
      p3(7) <= a(3) AND b(7);

      p4(0) <= a(4) AND b(0);
      p4(1) <= a(4) AND b(1);
      p4(2) <= a(4) AND b(2); 
      p4(3) <= a(4) AND b(3);
      p4(4) <= a(4) AND b(4);
      p4(5) <= a(4) AND b(5);
      p4(6) <= a(4) AND b(6);
      p4(7) <= a(4) AND b(7);
  
      p5(0) <= a(5) AND b(0);
      p5(1) <= a(5) AND b(1);
      p5(2) <= a(5) AND b(2); 
      p5(3) <= a(5) AND b(3);
      p5(4) <= a(5) AND b(4);
      p5(5) <= a(5) AND b(5);
      p5(6) <= a(5) AND b(6);
      p5(7) <= a(5) AND b(7);

      p6(0) <= a(6) AND b(0);
      p6(1) <= a(6) AND b(1);
      p6(2) <= a(6) AND b(2); 
      p6(3) <= a(6) AND b(3);
      p6(4) <= a(6) AND b(4);
      p6(5) <= a(6) AND b(5);
      p6(6) <= a(6) AND b(6);
      p6(7) <= a(6) AND b(7);

      p7(0) <= a(7) AND b(0);
      p7(1) <= a(7) AND b(1);
      p7(2) <= a(7) AND b(2); 
      p7(3) <= a(7) AND b(3);
      p7(4) <= a(7) AND b(4);
      p7(5) <= a(7) AND b(5);
      p7(6) <= a(7) AND b(6);
      p7(7) <= a(7) AND b(7);
  END PROCESS;

  --See https://moodle.iitd.ac.in/pluginfile.php/76400/mod_resource/content/1/Lec18%20Adder%20Multiplier%20Design%2008%20Sep%202017.pdf Pg 19

  --Initialize inp1_1
  inp1_1(6 DOWNTO 0) <= p0(7 DOWNTO 1);
  inp1_1(7) <= '0';

  --Initialize inp1_2
  inp1_2 <= p1;

  --Initialize inp1_3  
  inp1_3(7 DOWNTO 1) <= p2(6 DOWNTO 0);
  inp1_3(0) <= '0';

  --Now pass through first carry save
  cs1: ENTITY WORK.carry_save(carry_save_logic)
       PORT(inp1 => inp1_1, inp2 => inp1_2, inp3 => inp1_3, out1 => out1_1, out2 => out1_2);  --Out1 corresponds to carry

  --Initialize inp2_1
  inp2_1 <= out1_1;

  --Initialize inp2_2
  inp2_2(6 DOWNTO 0) <= out1_2(7 DOWNTO 1);
  inp2_2(7) <= p2(7);

  --Initialize inp2_3
  inp2_3(7 DOWNTO 1) <= p3(6 DOWNTO 0);
  inp2_3(0) <= '0';

  --Now pass through second carry save

  cs2: ENTITY WORK.carry_save(carry_save_logic)
       PORT(inp1 => inp2_1, inp2 => inp2_2, inp3 => inp2_3, out1 => out2_1, out2 => out2_2);  --Out1 corresponds to carry

  --Initialize inp3_1
  inp3_1 <= out2_1;

  --Initialize inp3_2
  inp3_2(6 DOWNTO 0) <= out2_2(7 DOWNTO 1);
  inp3_2(7) <= p3(7);

  --Initialize inp3_3
  inp3_3(7 DOWNTO 1) <= p4(6 DOWNTO 0);
  inp3_3(0) <= '0';

  --Now pass through third carry save

  cs3: ENTITY WORK.carry_save(carry_save_logic)
       PORT(inp1 => inp3_1, inp2 => inp3_2, inp3 => inp3_3, out1 => out3_1, out2 => out3_2);  --Out1 corresponds to carry

  --Initialize inp4_1
  inp4_1 <= out3_1;

  --Initialize inp4_2
  inp4_2(6 DOWNTO 0) <= out3_2(7 DOWNTO 1);
  inp4_2(7) <= p4(7);

  --Initialize inp4_3
  inp4_3(7 DOWNTO 1) <= p5(6 DOWNTO 0);
  inp4_3(0) <= '0';

  --Now pass through fourth carry save

  cs4: ENTITY WORK.carry_save(carry_save_logic)
       PORT(inp1 => inp4_1, inp2 => inp4_2, inp3 => inp4_3, out1 => out4_1, out2 => out4_2);  --Out1 corresponds to carry

  --Initialize inp5_1
  inp5_1 <= out4_1;

  --Initialize inp5_2
  inp5_2(6 DOWNTO 0) <= out4_2(7 DOWNTO 1);
  inp5_2(7) <= p5(7);

  --Initialize inp5_3
  inp5_3(7 DOWNTO 1) <= p6(6 DOWNTO 0);
  inp5_3(0) <= '0';

  --Now pass through fifth carry save

  cs5: ENTITY WORK.carry_save(carry_save_logic)
       PORT(inp1 => inp5_1, inp2 => inp5_2, inp3 => inp5_3, out1 => out5_1, out2 => out5_2);  --Out1 corresponds to carry

  --Initialize inp6_1
  inp6_1 <= out5_1;

  --Initialize inp6_2
  inp6_2(6 DOWNTO 0) <= out2_5(7 DOWNTO 1);
  inp6_2(7) <= p6(7);

  --Initialize inp6_3
  inp6_3(7 DOWNTO 1) <= p7(6 DOWNTO 0);
  inp6_3(0) <= '0';

  --Now pass through sizth carry save

  cs6: ENTITY WORK.carry_save(carry_save_logic)
       PORT(inp1 => inp6_1, inp2 => inp6_2, inp3 => inp6_3, out1 => out6_1, out2 => out6_2);  --Out1 corresponds to carry

  --Finally time to use the Carry Lookahead Module

  carryover1 <= '0';

  --Now define inp7_1 and inp7_2
  inp7_1 <= out6_1;

  inp7_2(6 DOWNTO 0) <= out6_2(7 DOWNTO 1);
  inp7_2(7) <= p7(7);
    

  cl1: ENTITY WORK.carry_look(carry_logic)
       PORT(A => inp7_1(3 DOWNTO 0), B => inp7_2(3 DOWNTO 0), Cin => carryover1, S <= out7_1(3 DOWNTO 0), Cout <= carryover2);

  cl2: ENTITY WORK.carry_look(carry_logic)
       PORT(A => inp7_1(7 DOWNTO 4), B => inp7_2(7 DOWNTO 4), Cin => carryover1, S <= out7_1(7 DOWNTO 4), Cout <= S(15)); --Cout is S(15)!!

  --Now, define the final output. S(15) already defined

  S(0) <= p0(0);
  S(1) <= out1_2(0);
  S(2) <= out2_2(0);
  S(3) <= out3_2(0);
  S(4) <= out4_2(0);
  S(5) <= out5_2(0);
  S(6) <= out6_2(0);
  S(10 DOWNTO 7) <= out7_1(3 DOWNTO 0);
  S(14 DOWNTO 11) <= out7_2(7 DOWNTO 4);

END ARCHITECTURE mult3_logic; 
