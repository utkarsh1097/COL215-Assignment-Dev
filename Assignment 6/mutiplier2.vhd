LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

---------FULL ADDER----------

ENTITY full_adder IS
PORT(
	a: IN std_logic;
	b: IN std_logic;
	s: OUT std_logic
	ci: IN std_logic;
	cf: OUT std_logic	
);
END ENTITY;

ARCHITECTURE full_adder_arc OF bit_adder IS
BEGIN
PROCESS (a, b, ci)
	BEGIN 
		s = a xor b xor ci;
		cf = (c and (b or a)) or (b and a);
	END PROCESS;
END ARCHITECTURE;

---------- FULL ADDER ----------

ENTITY carry_propagate_adder IS
PORT(
	a: IN std_logic_vector(7 downto 0);
	b: IN std_logic_vector(7 downto 0);
	s: OUT std_logic_vector(7 downto 0);
	--cLast: OUT std_logic
	carry: out std_logic_vector(8 downto 0);
);
END ENTITY;

ARCHITECTURE carry_propagate_adder_arc OF carry_propagate_adder IS

BEGIN
	variable c: std_logic_vector(8 downto 0);
	
		c(0) = '0';
		
		v0: ENTITY WORK.full_adder port map(
			a => a(0);
			b => b(0);
			s => s(0);
			ci => c(0);
			cf => c(1);
		);
		v1: ENTITY WORK.full_adder port map(
			a => a(1);
			b => b(1);
			s => s(1);
			ci => c(1);
			cf => c(2);
		);
		
		v2: ENTITY WORK.full_adder port map(
			a => a(2);
			b => b(2);
			s => s(2);
			ci => c(2);
			cf => c(3);
		);
		v3: ENTITY WORK.full_adder port map(
			a => a(3);
			b => b(3);
			s => s(3);
			ci => c(3);
			cf => c(4);
		);
		v4: ENTITY WORK.full_adder port map(
			a => a(4);
			b => b(4);
			s => s(4);
			ci => c(4);
			cf => c(5);
		);
		v5: ENTITY WORK.full_adder port map(
			a => a(5);
			b => b(5);
			s => s(5);
			ci => c(5);
			cf => c(6);
		);
		v6: ENTITY WORK.full_adder port map(
			a => a(6);
			b => b(6);
			s => s(6);
			ci => c(6);
			cf => c(7);
		);
		v7: ENTITY WORK.full_adder port map(
			a => a(7);
			b => b(7);
			s => s(7);
			ci => c(7);
			cf => c(8);
		);
		--cLast <= c(8);
		carry <= c;		
	
	
END ARCHITECTURE;

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
		w0: ENTITY WORK.full_adder port map(
			a => a(0);
			b => b(0);
			ci => '0';
			s => s(0);
			cf => carry(0)
			
		);
		w1: ENTITY WORK.full_adder port map(
			a => a(1);
			b => b(1);
			ci => c(1);
			s => s(1);
			cf => carry(1)
			
		);
		w2: ENTITY WORK.full_adder port map(
			a => a(2);
			b => b(2);
			ci => c(2);
			s => s(2);
			cf => carry(2)
		);
		w3: ENTITY WORK.full_adder port map(
			a => a(3);
			b => b(3);
			ci => c(3);
			s => s(3);
			cf => carry(3)
		);
		w4: ENTITY WORK.full_adder port map(
			a => a(4);
			b => b(4);
			ci => c(4);
			s => s(4);
			cf => carry(4)
		);
		w5: ENTITY WORK.full_adder port map(
			a => a(5);
			b => b(5);
			ci => c(5);
			s => s(5);
			cf => carry(5)
		);
		w6: ENTITY WORK.full_adder port map(
			a => a(6);
			b => b(6);
			ci => c(6);
			s => s(6);
			cf => carry(6)
		);
		w7: ENTITY WORK.full_adder port map(
			a => a(7);
			b => b(7);
			ci => c(7);
			s => s(7);
			cf => carry(7)
		);
END ARCHITECTURE;		

-----------MUTIPLIER2---------------

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
	type dataout is array (7 downto 0,7 downto 0) of std_logic;
	signal carry : dataout ;
	--signal carry0 : std_logic_vector(7 downto 0);
	--signal carry1 : std_logic_vector(7 downto 0);
	--signal carry2 : std_logic_vector(7 downto 0);
	--signal carry3 : std_logic_vector(7 downto 0);
	--signal carry4 : std_logic_vector(7 downto 0);
	--signal carry5 : std_logic_vector(7 downto 0);
	--signal carry6 : std_logic_vector(7 downto 0);
	--signal carry7 : std_logic_vector(7 downto 0);
	COMPONENT carry_save_adder PORT (a, b, c : IN std_logic_vector(7 downto 0);
											s, carry: OUT std_logic_vector(7 downto 0)
									);
	END COMPONENT;
	FOR ALL: carry_save_adder USE ENTITY WORK.carry_save_adder(carry_save_adder_arc); 	
BEGIN
PROCESS(in1, in2)
	variable q : std_logic_vector(7 downto 0);
	
	BEGIN
		for i in 0 to 7 loop
			for j in 0 to 7 loop
				p(i, j) = in1(i) and in2(j) ;
			end loop;
		end loop;
		product(0) <= p(0,0);
		W0: ENTITY WORK.carry_save_adder(carry_save_adder_arc) port map(
			a(0) => '0' ;
			a(1 downto 7) => p(2, 0 downto 6);
			b => p(1, 0 downto 7);
			c(0 downto 6) => p(0, 1 downto 7);
			c(7) => '0';
			s => q ;
			carry => carry(0)
		);
		product(1) <= q(0);
		
		--w1: ENTITY WORK.carry_save_adder(carry_save_adder_arc) port map(
		--	a(0) => 0;
		--	a(1 downto 7) => p(3, 0 downto 6);
		--	b(7) => p(2, 3);
		--	b(0 downto 6) => q(1 downto 7);
		--	c => carry(0) ;
		--	s => q ;
		--	carry => carry(1)
			
		--  );
		
		------- GENERATE for w1 to w6 --------
		
		W1TO5: FOR k IN 1 TO 5 GENERATE
			Uk: carry_save_adder PORT MAP(
				a(0) => 0;
				a(1 downto 7) => p(k+2, 0 downto 6);
				b(7) => p(k+1, 7);
				b(0 downto 6) => q(1 downto 7);
				c => carry(k-1);
				s => q ;
				carry => carry(k)
			);
			product(k+1) <= q(0);--CHECK IF THIS VALUE ASSIGNMENT WORKS
		END GENERATE;	

		-------- -----------
		
		W6: ENTITY WORK.carry_propagate_adder(carry_propagate_adder_arc) port map(
			a(0 downto 6) => q(1 downto 7); 
			b => carry(5);
			s => product(7 downto 14);
			cLast => product(15)
		);
	END PROCESS;
END ARCHITECTURE;	

	