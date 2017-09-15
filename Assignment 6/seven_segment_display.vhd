ENTITY ssd IS 
PORT (
	bcd: in std_logic_vector(3 downto 0);
	cathode: out std_logic_vector(6 downto 0)
	);
END ssd;

ARCHITECTURE ssd_arc OF ssd IS
	begin
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