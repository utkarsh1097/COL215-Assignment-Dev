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
			ci => c(0),        --here ci for i=0 won't be '0'
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

ENTITY mutiplier2 IS
PORT (
	in1: IN std_logic_vector(7 downto 0);
	in2: IN std_logic_vector(7 downto 0);
	product: OUT std_logic_vector(15 downto 0)
);
END ENTITY;

ARCHITECTURE mutiplier2_arc OF mutiplier2 IS
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
    signal q1, q2, q3, q4, q5, q6 : std_logic_vector(7 downto 0);
    signal carry0: std_logic_vector(7 downto 0);
        signal carry2: std_logic_vector(7 downto 0);
        signal carry3: std_logic_vector(7 downto 0);
        signal carry4: std_logic_vector(7 downto 0);
        signal carry5: std_logic_vector(7 downto 0);
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
			a(7 downto 1) => p2(6 downto 0),
			b => p1(7 downto 0),
			c(6 downto 0) => p0(7 downto 1),
			c(7) => '0',
			s => q1 ,
			carry => carry0
		);
		product(1) <= q1(0);
		
		
		U1: ENTITY WORK.carry_save_adder PORT MAP(
                        a(0) => '0',
                        a(7 downto 1) => p3(6 downto 0),
                        b(7) => p2(7),
                        b(6 downto 0) => q1(7 downto 1),
                        c => carry0,
                        s => q2 ,
                        carry => carry1
                    );
                    product(2) <= q2(0);
        U2: ENTITY WORK.carry_save_adder PORT MAP(
                                    a(0) => '0',
                                    a(7 downto 1) => p4(6 downto 0),
                                    b(7) => p3(7),
                                    b(6 downto 0) => q2(7 downto 1),
                                    c => carry1,
                                    s => q3 ,
                                    carry => carry2
                                );
                                product(3) <= q3(0);
         U3: ENTITY WORK.carry_save_adder PORT MAP(
                                    a(0) => '0',
                                    a(7 downto 1) => p5(6 downto 0),
                                    b(7) => p4(7),
                                    b(6 downto 0) => q3(7 downto 1),
                                    c => carry2,
                                    s => q4 ,
                                    carry => carry3
                                );
                                product(4) <= q4(0);
          U4: ENTITY WORK.carry_save_adder PORT MAP(
                                a(0) => '0',
                                a(7 downto 1) => p6(6 downto 0),
                                b(7) => p5(7),
                                b(6 downto 0) => q4(7 downto 1),
                                c => carry3,
                                s => q5 ,
                                carry => carry4
                            );
                            product(5) <= q5(0);                                                                                                               

          U5: ENTITY WORK.carry_save_adder PORT MAP(
                                a(0) => '0',
                                a(7 downto 1) => p7(6 downto 0),
                                b(7) => p6(7),
                                b(6 downto 0) => q5(7 downto 1),
                                c => carry4,
                                s => q6 ,
                                carry => carry5
                            );
                            product(6) <= q6(0);

		-------- -----------
		
		W6: ENTITY WORK.carry_propagate_adder(carry_propagate_adder_arc) port map(
			a(6 downto 0) => q6(7 downto 1), 
			a(7) => p7(7),
			b => carry5,
			s => product(14 downto 7),
			cLast => product(15)
		);
	
END ARCHITECTURE;	

	

