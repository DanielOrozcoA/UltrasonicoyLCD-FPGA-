library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_arith.all;
use IEEE.STD_LOGIC_unsigned.all;

entity Ultrasonico is
	
	generic(
    K: integer:=88234; -- CANTIDAD DE PULSOS PARA DETECTAR HASTA 30 CM
	N: integer:=17
	);
	
	port(
	CLK : in std_logic;
	RST : in std_logic;
	H : in std_logic; -- ENTRADA - LA CUENTA SE HABILITA CON EL ECHO DEL ULTRASONICO
	Q_US : out std_logic_vector(16 downto 0) -- SALIDA - ES IGUAL A LA CUENTA PRESENTE
	);
end Ultrasonico;

architecture simple of Ultrasonico is				 
signal Qp,Qn : std_logic_vector(N-1 downto 0):=(others =>'0');
signal BT : std_logic :='0';
signal BdTconH: std_logic_vector(1 downto 0):=(others =>'0');

begin					
	--BdT <= BT;
	Q_US <= Qp; -- SALIDA IGUAL A LA CUENTA PRESENTE
	--PWM <= Led_p;
	BdTconH <= BT & H;
	
	Mux: process (BdTconH, Qp) is
	begin		
		case BdTconH is
			when "01" => Qn <= Qp+1;
			when "11" => Qn <= Qp; -- SI LA CUENTA LLEGA AL MÁXIMO NO SE REINICIARÁ NI CONTARÁ MÁS
			when others => Qn <= Qp;
		end case;
	end process Mux;
	
	Comparador: process (Qp) is
	begin
		if Qp = K then
			BT <= '1';
		else BT <= '0';
		end if;
	end process Comparador;
	
	Combinacional: process (CLK, RST) is
	begin
		if RST = '1' then
			Qp <= (others => '0');
		elsif CLK'event and CLK = '0' then
			Qp <= Qn;
		end if;
	end process Combinacional;


end architecture simple;