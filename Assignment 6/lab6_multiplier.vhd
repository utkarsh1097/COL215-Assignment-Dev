LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

---------FULL ADDER----------

ENTITY full_adder IS
PORT(
	a: IN std_logic;
	b: IN std_logic;
	s: OUT std_logic;
	ci: IN std_logic;
	cf: OUT std_logic	
);
END ENTITY;

ARCHITECTURE full_adder_arc OF full_adder IS
BEGIN
PROCESS (a, b, ci)
	BEGIN 
		s <= a xor b xor ci;
		cf <= (ci and (b or a)) or (b and a);
	END PROCESS;
END ARCHITECTURE;

---------- carry propagate adder ----------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

ENTITY carry_propagate_adder IS
PORT(
	a: IN std_logic_vector(7 downto 0);
	b: IN std_logic_vector(7 downto 0);
	s: OUT std_logic_vector(7 downto 0);
	cLast: OUT std_logic
	--carry: out std_logic_vector(8 downto 0);
);
END ENTITY;

ARCHITECTURE carry_propagate_adder_arc OF carry_propagate_adder IS
signal c: std_logic_vector(8 downto 0);
BEGIN
--PROCESS(a, b)
	
	--BEGIN
		c(0) <= '0';
		
		v: ENTITY WORK.full_adder(full_adder_arc)
		   port map(
			a => a(0),
			b => b(0),
			s => s(0),
			ci => c(0),
			cf => c(1)
		);
		v1: ENTITY WORK.full_adder(full_adder_arc) port map(
			a => a(1), 
			b => b(1),
			s => s(1),
			ci => c(1),
			cf => c(2)
		);
		
		v2: ENTITY WORK.full_adder(full_adder_arc) port map(
			a => a(2),
			b => b(2),
			s => s(2),
			ci => c(2),
			cf => c(3)
		);
		v3: ENTITY WORK.full_adder(full_adder_arc) port map(
			a => a(3),
			b => b(3),
			s => s(3),
			ci => c(3),
			cf => c(4)
		);
		v4: ENTITY WORK.full_adder(full_adder_arc) port map(
			a => a(4),
			b => b(4),
			s => s(4),
			ci => c(4),
			cf => c(5)
		);
		v5: ENTITY WORK.full_adder(full_adder_arc) port map(
			a => a(5),
			b => b(5),
			s => s(5),
			ci => c(5),
			cf => c(6)
		);
		v6: ENTITY WORK.full_adder(full_adder_arc) port map(
			a => a(6),
			b => b(6),
			s => s(6),
			ci => c(6),
			cf => c(7)
		);
		v7: ENTITY WORK.full_adder(full_adder_arc) port map(
			a => a(7),
			b => b(7),
			s => s(7),
			ci => c(7),
			cf => c(8)
		);
		cLast <= c(8);
		--carry <= c;		
	--END PROCESS;
END ARCHITECTURE;	

------- MUTIPLIER1-----------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY mult1 IS
PORT (
	in1: IN std_logic_vector(7 downto 0);
	in2: IN std_logic_vector(7 downto 0);
	product: OUT std_logic_vector(15 downto 0)
);
END ENTITY;

ARCHITECTURE mult1_arc OF mult1 IS
signal i : integer range 0 to 7 := 0;
signal j : integer range 0 to 7 := 0;

type T_2D is array (7 downto 0, 7 downto 0) of std_logic;
signal p : T_2D;
signal dummy : std_logic_vector(8 downto 0);
signal nextin1: std_logic_vector(7 downto 0);
signal p0: std_logic_vector(7 downto 0);
signal p2: std_logic_vector(7 downto 0);
signal p3: std_logic_vector(7 downto 0);
signal p4: std_logic_vector(7 downto 0);
signal p5: std_logic_vector(7 downto 0);
signal p6: std_logic_vector(7 downto 0);
signal p7: std_logic_vector(7 downto 0);
signal p1: std_logic_vector(7 downto 0);



BEGIN
	   PROCESS(in1, in2)
	       BEGIN
		for i in 0 to 7 loop
			p0(i) <= in1(i) and in2(0);
			p1(i) <= in1(i) and in2(1);
			p2(i) <= in1(i) and in2(2);
			p3(i) <= in1(i) and in2(3);
			p4(i) <= in1(i) and in2(4);
			p5(i) <= in1(i) and in2(5);
			p6(i) <= in1(i) and in2(6);
			p7(i) <= in1(i) and in2(7);
			
			
		end loop;
		  END PROCESS;

		product(0) <= p0(0);
		q0: ENTITY WORK.carry_propagate_adder(carry_propagate_adder_arc) port map(
			
			a(0 downto 6) => p0(1 downto 7),
			
			b => p1,
			
			
			s(1 downto 7) => nextin1(0 downto 6),
			s(0) => product(1),
			cLast => nextin1(7)
					
		);
		q1: ENTITY WORK.carry_propagate_adder(carry_propagate_adder_arc) port map(
			a => nextin1,
			
			
			    b=>p2,
                
			s(1 downto 7) => nextin1(0 downto 6),
			s(0) => product(2),
			cLast => nextin1(7) 
		);
		q2: ENTITY WORK.carry_propagate_adder(carry_propagate_adder_arc) port map(
			a => nextin1,
			
			b => p3,
                
			s(1 downto 7) => nextin1(0 downto 6),
			s(0) => product(3),
			cLast => nextin1(7) 
		);
		q3: ENTITY WORK.carry_propagate_adder(carry_propagate_adder_arc) port map(
			a => nextin1,
			
			b => p4,
		
			s(1 downto 7) => nextin1(0 downto 6),
			s(0) => product(4),
			cLast => nextin1(7) 
		);
		q4: ENTITY WORK.carry_propagate_adder(carry_propagate_adder_arc) port map(
			a => nextin1,
			
			b=>p5,
			
			s(1 downto 7) => nextin1(0 downto 6),
			s(0) => product(5),
			cLast => nextin1(7) 
		);
		q5: ENTITY WORK.carry_propagate_adder(carry_propagate_adder_arc) port map(
			a => nextin1,
			
			b => p6,
			
			s(1 downto 7) => nextin1(0 downto 6),
			s(0) => product(6),
			cLast => nextin1(7) 
		);
		q6: ENTITY WORK.carry_propagate_adder(carry_propagate_adder_arc) port map(
			a => nextin1,
			
			b => p7,
			
			s(0 downto 7) => product(7 downto 14),
			cLast => product(15) 
		);
	
END ARCHITECTURE;	

--------------MULT2-----------------------------------------
----------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

---------FULL ADDER----------

ENTITY full_adder IS
PORT(
	a: IN std_logic;
	b: IN std_logic;
	s: OUT std_logic;
	ci: IN std_logic;
	cf: OUT std_logic	
);
END ENTITY;

ARCHITECTURE full_adder_arc OF full_adder IS
BEGIN
PROCESS (a, b, ci)
	BEGIN 
		s <= a xor b xor ci;
		cf <= (ci and (b or a)) or (b and a);
	END PROCESS;
END ARCHITECTURE;

---------- FULL ADDER ----------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY carry_propagate_adder IS
PORT(
	a: IN std_logic_vector(7 downto 0);
	b: IN std_logic_vector(7 downto 0);
	s: OUT std_logic_vector(7 downto 0);
	cLast: OUT std_logic
	--carry: out std_logic_vector(8 downto 0)
);
END ENTITY;

ARCHITECTURE carry_propagate_adder_arc OF carry_propagate_adder IS
signal c: std_logic_vector(8 downto 0);
BEGIN
	
	
		c(0) <= '0';
		
		v0: ENTITY WORK.full_adder(full_adder_arc) port map(
			a => a(0),
			b => b(0),
			s => s(0),
			ci => c(0),
			cf => c(1)
		);
		v1: ENTITY WORK.full_adder(full_adder_arc) port map(
			a => a(1),
			b => b(1),
			s => s(1),
			ci => c(1),
			cf => c(2)
		);
		
		v2: ENTITY WORK.full_adder(full_adder_arc) port map(
			a => a(2),
			b => b(2),
			s => s(2),
			ci => c(2),
			cf => c(3)
		);
		v3: ENTITY WORK.full_adder(full_adder_arc) port map(
			a => a(3),
			b => b(3),
			s => s(3),
			ci => c(3),
			cf => c(4)
		);
		v4: ENTITY WORK.full_adder(full_adder_arc) port map(
			a => a(4),
			b => b(4),
			s => s(4),
			ci => c(4),
			cf => c(5)
		);
		v5: ENTITY WORK.full_adder(full_adder_arc) port map(
			a => a(5),
			b => b(5),
			s => s(5),
			ci => c(5),
			cf => c(6)
		);
		v6: ENTITY WORK.full_adder(full_adder_arc) port map(
			a => a(6),
			b => b(6),
			s => s(6),
			ci => c(6),
			cf => c(7)
		);
		v7: ENTITY WORK.full_adder(full_adder_arc) port map(
			a => a(7),
			b => b(7),
			s => s(7),
			ci => c(7),
			cf => c(8)
		);
		cLast <= c(8);
		--carry <= c;		
	
	
END ARCHITECTURE;

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY carry_save_adder IS
PORT(
	a: IN std_logic_vector(7 downto 0);
	b: IN std_logic_vector(7 downto 0);
	c: IN std_logic_vector(7 downto 0);
	s: out std_logic_vector(7 downto 0);
	carry: OUT std_logic_vector(7 downto 0)
);
END ENTITY;

ARCHITECTURE carry_save_adder_arc OF carry_save_adder IS

BEGIN
		w0: ENTITY WORK.full_adder(full_adder_arc) port map(
			a => a(0),
			b => b(0),
			ci => '0',
			s => s(0),
			cf => carry(0)
			
		);
		w1: ENTITY WORK.full_adder(full_adder_arc) port map(
			a => a(1),
			b => b(1),
			ci => c(1),
			s => s(1),
			cf => carry(1)
			
		);
		w2: ENTITY WORK.full_adder(full_adder_arc) port map(
			a => a(2),
			b => b(2),
			ci => c(2),
			s => s(2),
			cf => carry(2)
		);
		w3: ENTITY WORK.full_adder(full_adder_arc) port map(
			a => a(3),
			b => b(3),
			ci => c(3),
			s => s(3),
			cf => carry(3)
		);
		w4: ENTITY WORK.full_adder(full_adder_arc) port map(
			a => a(4),
			b => b(4),
			ci => c(4),
			s => s(4),
			cf => carry(4)
		);
		w5: ENTITY WORK.full_adder(full_adder_arc) port map(
			a => a(5),
			b => b(5),
			ci => c(5),
			s => s(5),
			cf => carry(5)
		);
		w6: ENTITY WORK.full_adder(full_adder_arc) port map(
			a => a(6),
			b => b(6),
			ci => c(6),
			s => s(6),
			cf => carry(6)
		);
		w7: ENTITY WORK.full_adder(full_adder_arc) port map(
			a => a(7),
			b => b(7),
			ci => c(7),
			s => s(7),
			cf => carry(7)
		);
END ARCHITECTURE;		

-----------MUTIPLIER2---------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY mult2 IS
PORT (
	in1: IN std_logic_vector(7 downto 0);
	in2: IN std_logic_vector(7 downto 0);
	product: OUT std_logic_vector(15 downto 0)
);
END ENTITY;

ARCHITECTURE mult2_arc OF mult2 IS
	signal i : integer range 0 to 7 := 0;
	signal j : integer range 0 to 7 := 0;
	signal k : integer range 0 to 10 := 0;
	--type dataout is array (7 downto 0,7 downto 0) of std_logic;
	--signal carry : dataout ;
	signal p0: std_logic_vector(7 downto 0);
    signal p2: std_logic_vector(7 downto 0);
    signal p3: std_logic_vector(7 downto 0);
    signal p4: std_logic_vector(7 downto 0);
    signal p5: std_logic_vector(7 downto 0);
    signal p6: std_logic_vector(7 downto 0);
    signal p7: std_logic_vector(7 downto 0);
    signal p1: std_logic_vector(7 downto 0);
    signal q : std_logic_vector(7 downto 0);
    signal carry0: std_logic_vector(7 downto 0);
        signal carry2: std_logic_vector(7 downto 0);
        signal carry3: std_logic_vector(7 downto 0);
        signal carry4: std_logic_vector(7 downto 0);
        signal carry5: std_logic_vector(7 downto 0);
        signal carry6: std_logic_vector(7 downto 0);
        signal carry7: std_logic_vector(7 downto 0);
        signal carry1: std_logic_vector(7 downto 0);
        
	COMPONENT carry_save_adder PORT (a, b, c : IN std_logic_vector(7 downto 0);
											s, carry: OUT std_logic_vector(7 downto 0)
									);
	END COMPONENT;
	FOR ALL: carry_save_adder USE ENTITY WORK.carry_save_adder(carry_save_adder_arc); 	
BEGIN

	
	
	PROCESS(in1, in2)
               BEGIN
            for i in 0 to 7 loop
                p0(i) <= in1(0) and in2(i);
                p1(i) <= in1(1) and in2(i);
                p2(i) <= in1(2) and in2(i);
                p3(i) <= in1(3) and in2(i);
                p4(i) <= in1(4) and in2(i);
                p5(i) <= in1(5) and in2(i);
                p6(i) <= in1(6) and in2(i);
                p7(i) <= in1(7) and in2(i);
            end loop;
      END PROCESS;
		product(0) <= p0(0);
		W0: ENTITY WORK.carry_save_adder(carry_save_adder_arc) port map(
			a(0) => '0' ,
			a(1 downto 7) => p2(0 downto 6),
			b => p1(0 downto 7),
			c(0 downto 6) => p0(1 downto 7),
			c(7) => '0',
			s => q ,
			carry => carry0
		);
		product(1) <= q(0);
		
		
		U1: carry_save_adder PORT MAP(
                        a(0) => '0',
                        a(1 downto 7) => p3(0 downto 6),
                        b(7) => p2(7),
                        b(0 downto 6) => q(1 downto 7),
                        c => carry0,
                        s => q ,
                        carry => carry1
                    );
                    product(2) <= q(0);
        U2: carry_save_adder PORT MAP(
                                    a(0) => '0',
                                    a(1 downto 7) => p4(0 downto 6),
                                    b(7) => p3(7),
                                    b(0 downto 6) => q(1 downto 7),
                                    c => carry1,
                                    s => q ,
                                    carry => carry2
                                );
                                product(3) <= q(0);
         U3: carry_save_adder PORT MAP(
                                            a(0) => '0',
                                            a(1 downto 7) => p5(0 downto 6),
                                            b(7) => p4(7),
                                            b(0 downto 6) => q(1 downto 7),
                                            c => carry2,
                                            s => q ,
                                            carry => carry3
                                        );
                                        product(4) <= q(0);
          U5: carry_save_adder PORT MAP(
                                a(0) => '0',
                                a(1 downto 7) => p7(0 downto 6),
                                b(7) => p6(7),
                                b(0 downto 6) => q(1 downto 7),
                                c => carry4,
                                s => q ,
                                carry => carry5
                            );
                            product(6) <= q(0);
          U4: carry_save_adder PORT MAP(
                                    a(0) => '0',
                                    a(1 downto 7) => p6(0 downto 6),
                                    b(7) => p5(7),
                                    b(0 downto 6) => q(1 downto 7),
                                    c => carry3,
                                    s => q ,
                                    carry => carry4
                                );
                                product(5) <= q(0);                                                                                                               

		-------- -----------
		
		W6: ENTITY WORK.carry_propagate_adder(carry_propagate_adder_arc) port map(
			a(0 downto 6) => q(1 downto 7), 
			b => carry5,
			s => product(7 downto 14),
			cLast => product(15)
		);
	
END ARCHITECTURE;	

----------------------------------MULT3----------------------------------------------------------
--------------------------------------------------------------------------------------------------



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
      Sout <= (Ai XOR Bi XOR Cin);
      Cout <= ((Ai AND Bi) OR (Bi AND Cin) OR (Cin AND Ai));
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
      Cout: OUT std_logic_vector(3 DOWNTO 0);
      Cnext: OUT std_logic);
END cla_unit;


ARCHITECTURE cla_logic OF cla_unit IS
BEGIN
  Cout(0) <= C;
  Cout(1) <= ((P(0) AND C) OR G(0));
  Cout(2) <= ((P(1) AND P(0) AND C) OR (P(1) AND G(0)) OR G(1));
  Cout(3) <= ((P(2) AND P(1) AND P(0) AND C) OR (P(2) AND P(1) AND G(0)) OR (P(2) AND G(1)) OR G(2));
  Cnext <= ((P(3) AND P(2) AND P(1) AND P(0) AND C) OR (P(3) AND P(2) AND P(1) AND G(0)) OR (P(3) AND P(2) AND G(1)) OR (P(3) AND G(2)) OR G(3));
END ARCHITECTURE cla_logic;


--------AND-OR Module--------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY and_or IS
PORT (A: IN std_logic;
      B: IN std_logic;
      P: OUT std_logic;
      G: OUT std_logic);
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
  
  signal dummy1, dummy2, dummy3, dummy0: std_logic; --Not sure if cout0...cout3 will need a Cout mapped, so using this beforehand to reduce further efforts
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
       PORT MAP(Cin => C(0), Ai => A(0), Bi => B(0), Sout => S(0), Cout => dummy0);
  b1: ENTITY WORK.bit_adder(adder_logic)
       PORT MAP(Cin => C(1), Ai => A(1), Bi => B(1), Sout => S(1), Cout => dummy1);
  b2: ENTITY WORK.bit_adder(adder_logic)
       PORT MAP(Cin => C(2), Ai => A(2), Bi => B(2), Sout => S(2), Cout => dummy2);
  b3: ENTITY WORK.bit_adder(adder_logic)
       PORT MAP(Cin => C(3), Ai => A(3), Bi => B(3), Sout => S(3), Cout => dummy3);
END ARCHITECTURE carry_logic;


--------Multiplier 3--------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

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
       PORT MAP(inp1 => inp1_1, inp2 => inp1_2, inp3 => inp1_3, out1 => out1_1, out2 => out1_2);  --Out1 corresponds to carry

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
       PORT MAP(inp1 => inp2_1, inp2 => inp2_2, inp3 => inp2_3, out1 => out2_1, out2 => out2_2);  --Out1 corresponds to carry

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
       PORT MAP(inp1 => inp3_1, inp2 => inp3_2, inp3 => inp3_3, out1 => out3_1, out2 => out3_2);  --Out1 corresponds to carry

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
       PORT MAP(inp1 => inp4_1, inp2 => inp4_2, inp3 => inp4_3, out1 => out4_1, out2 => out4_2);  --Out1 corresponds to carry

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
       PORT MAP(inp1 => inp5_1, inp2 => inp5_2, inp3 => inp5_3, out1 => out5_1, out2 => out5_2);  --Out1 corresponds to carry

  --Initialize inp6_1
  inp6_1 <= out5_1;

  --Initialize inp6_2
  inp6_2(6 DOWNTO 0) <= out5_2(7 DOWNTO 1);
  inp6_2(7) <= p6(7);

  --Initialize inp6_3
  inp6_3(7 DOWNTO 1) <= p7(6 DOWNTO 0);
  inp6_3(0) <= '0';

  --Now pass through sizth carry save

  cs6: ENTITY WORK.carry_save(carry_save_logic)
       PORT MAP(inp1 => inp6_1, inp2 => inp6_2, inp3 => inp6_3, out1 => out6_1, out2 => out6_2);  --Out1 corresponds to carry

  --Finally time to use the Carry Lookahead Module

  carryover1 <= '0';

  --Now define inp7_1 and inp7_2
  inp7_1 <= out6_1;

  inp7_2(6 DOWNTO 0) <= out6_2(7 DOWNTO 1);
  inp7_2(7) <= p7(7);
    

  cl1: ENTITY WORK.carry_look(carry_logic)
       PORT MAP(A => inp7_1(3 DOWNTO 0), B => inp7_2(3 DOWNTO 0), Cin => carryover1, S => out7_1(3 DOWNTO 0), Cout => carryover2);

  cl2: ENTITY WORK.carry_look(carry_logic)
       PORT MAP(A => inp7_1(7 DOWNTO 4), B => inp7_2(7 DOWNTO 4), Cin => carryover2, S => out7_1(7 DOWNTO 4), Cout => S(15)); --Cout is S(15)!!

  --Now, define the final output. S(15) already defined

  S(0) <= p0(0);
  S(1) <= out1_2(0);
  S(2) <= out2_2(0);
  S(3) <= out3_2(0);
  S(4) <= out4_2(0);
  S(5) <= out5_2(0);
  S(6) <= out6_2(0);
  S(10 DOWNTO 7) <= out7_1(3 DOWNTO 0);
  S(14 DOWNTO 11) <= out7_1(7 DOWNTO 4);

END ARCHITECTURE mult3_logic; 

---------------------------------------------------------------SLOW CLOCK--------------------------------------------
-----------------------------------------------------------------------------------------------------------------

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
        if(pushbutton <= '1') then finclk <= clk;
        elsif(pushbutton <= '0') then finclk <= slowClock;
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


-----------------------------------SEVEN SEGMENT DISPLAY-------------------------------------------------
----------------------------------------------------------------------------------------

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

--------------------------------------------------SSD FINAL BLOCK-----------------------------------
-----------------------------------------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use IEEE.NUMERIC_STD.all;

ENTITY ssd_final IS
PORT(
	clk: In STD_logic;
	display_button:In STD_logic;
	product: IN std_logic_vector(15 downto 0);
	anode: OUT std_logic_vector(3 downto 0);
	cathode: OUT std_logic_vector(6 downto 0) 	
);

END ENTITY;

ARCHITECTURE ssd_final_arc OF ssd_final IS
signal finClk: std_logic;
signal dumAnode: std_logic_vector(3 downto 0);
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
	a3: ENTITY WORK.ssd(ssd_arc) port map(
		d_o => product,
		anode => dumAnode,
		cathode => cathode
	);
END ARCHITECTURE;

------------------------FINAL----------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY lab6 IS
PORT(
    clk: IN std_logic;
    in1: IN std_logic_vector(7 downto 0);
    in2: IN std_logic_vector(7 downto 0);
    display_button: IN std_logic;
    multiplier_select :IN std_logic_vector(1 downto 0);
    anode: OUT  std_logic_vector(3 downto 0);
    cathode: OUT std_logic_vector(3 downto 0);
    product: OUT std_logic_vector(15 downto 0)
);
END ENTITY;

ARCHITECTURE lab6_logic OF lab6 IS
signal product1 : std_logic_vector(15 downto 0);
signal product2 : std_logic_vector(15 downto 0);
signal product3 : std_logic_vector(15 downto 0);
signal dumProduct : std_logic_vector(15 downto 0);
BEGIN
	m1: ENTITY WORK.mult1(mult1_arc) port map(
            in1 => in1,
            in2 => in2,
            product => product1
        );
     m2: ENTITY WORK.mult2(mult1_arc) port map(
            in1 => in1,
            in2 => in2,
            product => product2
        );
      m3: ENTITY WORK.mult3(mult3_logic) port map(
           A => in1,
           B => in2,
           S => product3
           ); 
    PROCESS(multiplier_select) 
    BEGIN                    	
        if multiplier_select = "00" then 
            product <= product1;
            dumProduct <= product1;
        elsif multiplier_select = "01" then 
            product <= product2;
            dumProduct <= product2;
        elsif multiplier_select = "10" then 
                product <= product3;
                dumProduct <= product3;               
        end if;     
     END PROCESS;
     b: ENTITY WORK.ssd_final(ssd_final_arc) port map(
        clk => clk,
         display_button => display_button,
         product => dumProduct,
         anode => anode,
         cathode => cathode 
     );
     
         
END ARCHITECTURE;
		
		


