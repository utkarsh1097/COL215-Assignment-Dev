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
		v1: ENTITY WORK                                                                          .full_adder(full_adder_arc) port map(
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

ENTITY mutiplier1 IS
PORT (
	in1: IN std_logic_vector(7 downto 0);
	in2: IN std_logic_vector(7 downto 0);
	product: OUT std_logic_vector(15 downto 0)
);
END ENTITY;

ARCHITECTURE mutiplier1_arc OF mutiplier1 IS
signal i : integer range 0 to 7 := 0;
signal j : integer range 0 to 7 := 0;
--type NIBBLE is array (7 downto 0) of std_ulogic;
--type MEM is array (0 to 7) of NIBBLE;
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
			--a(0 downto 6) => p(1 downto 7, 0) ,
			a(0 downto 6) => p0(1 downto 7),
			--a(0) => p1(0),
			--a(1) => p2(0),
			--a(2) => p3(0),
			--a(3) => p4(0),
			--a(4) => p5(0),
		--	a(5) => p6(0),
			--a(6) => p7(0),
			--a(7) => '0',
			--b => p(0 downto 7, 1),
			b => p1,
			--b(0) => p0(1),
			--b(1) => p1(1),
			--b(2) => p2(1),
			--b(3) => p3(1),
			--b(4) => p4(1),
			--b(5) => p5(1),
			--b(6) => p6(1),
			--b(7) => p7(1),
			
			s(1 downto 7) => nextin1(0 downto 6),
			s(0) => product(1),
			cLast => nextin1(7)
					
		);
		q1: ENTITY WORK.carry_propagate_adder(carry_propagate_adder_arc) port map(
			a => nextin1,
			
			--b => p(0 downto 7, 2),
			    b=>p2,
                --b(0) => p0(2),
                --b(1) => p1(2),
                --b(2) => p2(2),
                --b(3) => p3(2),
               -- b(4) => p4(2),
               -- b(5) => p5(2),
               -- b(6) => p6(2),
               -- b(7) => p7(2),
			s(1 downto 7) => nextin1(0 downto 6),
			s(0) => product(2),
			cLast => nextin1(7) 
		);
		q2: ENTITY WORK.carry_propagate_adder(carry_propagate_adder_arc) port map(
			a => nextin1,
			--b => p(0 downto 7, 3),
			b => p3,
                --b(0) => p0(3),
                --b(1) => p1(3),
               -- b(2) => p2(3),
               -- b(3) => p3(3),
               -- b(4) => p4(3),
               --- b(5) => p5(3),
                --b(6) => p6(3),
                --b(7) => p7(3),
			s(1 downto 7) => nextin1(0 downto 6),
			s(0) => product(3),
			cLast => nextin1(7) 
		);
		q3: ENTITY WORK.carry_propagate_adder(carry_propagate_adder_arc) port map(
			a => nextin1,
			--b => p(0 downto 7, 4),
			b => p4,
			        --        b(0) => p0(4),
        --    b(1) => p1(4),
          --  b(2) => p2(4),
          --  b(3) => p3(4),
          --  b(4) => p4(4),
           -- b(5) => p5(4),
            ---b(6) => p6(4),
        --    b(7) => p7(4),
			s(1 downto 7) => nextin1(0 downto 6),
			s(0) => product(4),
			cLast => nextin1(7) 
		);
		q4: ENTITY WORK.carry_propagate_adder(carry_propagate_adder_arc) port map(
			a => nextin1,
			--b => p(0 downto 7, 5),
			b=>p5,
			--b(0) => p0(5),
              --              b(1) => p1(5),
                --            b(2) => p2(5),
                  --          b(3) => p3(5),
                    --        b(4) => p4(5),
                      --      b(5) => p5(5),
                        --    b(6) => p6(5),
                          --  b(7) => p7(5),
			s(1 downto 7) => nextin1(0 downto 6),
			s(0) => product(5),
			cLast => nextin1(7) 
		);
		q5: ENTITY WORK.carry_propagate_adder(carry_propagate_adder_arc) port map(
			a => nextin1,
			--b => p(0 downto 7, 6),
			b => p6,
			--b(0) => p0(6),
              --              b(1) => p1(6),
                --            b(2) => p2(6),
                  ---          b(3) => p3(6),
                     ---       b(4) => p4(6),
                        --    b(5) => p5(6),
                          --  b(6) => p6(6),
                            --b(7) => p7(6),
			s(1 downto 7) => nextin1(0 downto 6),
			s(0) => product(6),
			cLast => nextin1(7) 
		);
		q6: ENTITY WORK.carry_propagate_adder(carry_propagate_adder_arc) port map(
			a => nextin1,
			--b => p(0 downto 7, 7),
			b => p7,
			--b(0) => p0(7),
              --              b(1) => p1(7),
                --            b(2) => p2(7),
                  --          b(3) => p3(7),
                    --        b(4) => p4(7),
                      --      b(5) => p5(7),
                        --    b(6) => p6(7),
                          --  b(7) => p7(7),
			s(0 downto 7) => product(7 downto 14),
			cLast => product(15) 
		);
	
END ARCHITECTURE;	
		
		
		

