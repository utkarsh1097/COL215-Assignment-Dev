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
		CASE anode ID
			WHEN "1110" =>bcd<= d_o(3 downto 0);
			WHEN "1101" =>bcd<= d_o(7 downto 4);
			WHEN "1011" =>bcd<= d_o(11 downto 8);
			WHEN "0111" =>bcd<= d_o(15 downto 12);
		END CASE
		
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
				WHEN others=> cathode <=; 
			 end case;
	   end process;
END ssd_arc;	   