LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

---------BIT ADDER----------

ENTITY bit_adder IS
PORT(
	a: IN std_logic;
	b: IN std_logic;
	s: OUT std_logic
	ci: IN std_logic;
	cf: OUT std_logic	
);
END ENTITY;

ARCHITECTURE bit_adder_arc OF bit_adder IS
BEGIN
PROCESS (a, b, ci)
	BEGIN 
		s = a xor b xor ci;
		cf = (c and (b or a)) or (b and a);
	END PROCESS;
END ARCHITECTURE;

---------- FULL ADDER ----------

ENTITY full_adder IS
PORT(
	a: IN std_logic_vector(7 downto 0);
	b: IN std_logic_vector(7 downto 0);
	s: OUT std_logic_vector(7 downto 0);
	--cLast: OUT std_logic
	carry: out std_logic_vector(8 downto 0);
);
END ENTITY;

ARCHITECTURE full_adder_arc OF full_adder IS

BEGIN
PROCESS(a, b)
	variable c: std_logic_vector(8 downto 0);
	BEGIN
		c(0) = '0';
		v0: ENTITY WORK.bit_adder port map(
			a => a(0);
			b => b(0);
			s => s(0);
			ci => c(0);
			cf => c(1);
		);
		v1: ENTITY WORK.bit_adder port map(
			a => a(1);
			b => b(1);
			s => s(1);
			ci => c(1);
			cf => c(2);
		);
		
		v2: ENTITY WORK.bit_adder port map(
			a => a(2);
			b => b(2);
			s => s(2);
			ci => c(2);
			cf => c(3);
		);
		v3: ENTITY WORK.bit_adder port map(
			a => a(3);
			b => b(3);
			s => s(3);
			ci => c(3);
			cf => c(4);
		);
		v4: ENTITY WORK.bit_adder port map(
			a => a(4);
			b => b(4);
			s => s(4);
			ci => c(4);
			cf => c(5);
		);
		v5: ENTITY WORK.bit_adder port map(
			a => a(5);
			b => b(5);
			s => s(5);
			ci => c(5);
			cf => c(6);
		);
		v6: ENTITY WORK.bit_adder port map(
			a => a(6);
			b => b(6);
			s => s(6);
			ci => c(6);
			cf => c(7);
		);
		v7: ENTITY WORK.bit_adder port map(
			a => a(7);
			b => b(7);
			s => s(7);
			ci => c(7);
			cf => c(8);
		);
		cLast <= c(8);
		carry <= c;		
	END PROCESS;
	
END ARCHITECTURE;

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
type dataout is array (7 downto 0,7 downto 0) of std_logic;
signal p : dataout ;
signal dummy : std_logic_vector(8 downto 0);
BEGIN
PROCESS(in1, in2)
	variable nextin1: std_logic_vector(7 downto 0); 
	BEGIN		
		for i in 0 to 7 loop
			for j in 0 to 7 loop
				p(i, j) = in1(i) and in2(j) ;
			end loop;
		end loop;

		product(0) <= p(0, 0);
		q0: ENTITY WORK.full_adder port map(
			a(0 downto 6) => p(1 downto 7, 0);
			a(7) => '0';
			b => p(0 downto 7, 1);
			s(1 downto 7) => nextin1(0 downto 6);
			s(0) => product(1);
			carry(8) => nextin1(7);
					
		);
		q1: ENTITY WORK.full_adder port map(
			a => nextin1;
			
			b => p(0 downto 7, 2);
			s(1 downto 7) => nextin1(0 downto 6);
			s(0) => product(2);
			carry(8) => nextin1(7) 
		);
		q2: ENTITY WORK.full_adder port map(
			a => nextin1;
			b => p(0 downto 7, 3);
			s(1 downto 7) => nextin1(0 downto 6);
			s(0) => product(3);
			carry(8) => nextin1(7) 
		);
		q3: ENTITY WORK.full_adder port map(
			a => nextin1;
			b => p(0 downto 7, 4);
			s(1 downto 7) => nextin1(0 downto 6);
			s(0) => product(4);
			carry(8) => nextin1(7) 
		);
		q4: ENTITY WORK.full_adder port map(
			a => nextin1;
			b => p(0 downto 7, 5);
			s(1 downto 7) => nextin1(0 downto 6);
			s(0) => product(5);
			carry(8) => nextin1(7) 
		);
		q5: ENTITY WORK.full_adder port map(
			a => nextin1;
			b => p(0 downto 7, 6);
			s(1 downto 7) => nextin1(0 downto 6);
			s(0) => product(6);
			carry(8) => nextin1(7) 
		);
		q6: ENTITY WORK.full_adder port map(
			a => nextin1;
			b => p(0 downto 7, 7);
			s(0 downto 7) => product(7 downto 14);
			carry(8) => product(15) 
		);
	END PROCESS;
END ARCHITECTURE;	
		
		
		
