library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_arith.all;
use IEEE.STD_LOGIC_unsigned.all;

entity Codificador_Display is
	
	generic(
    K: integer:=5000000;
	N: integer:=23
	);

	port(
	CLK : in std_logic;
	RST : in std_logic;
	H : in std_logic;
	Q_US : in std_logic_vector(16 downto 0); -- ENTRADA - RECIBE LA SALIDA DE LA ENTIDAD ULTRASONICO Y ES IGUAL A LA CUENTA PRESENTE
	BdT : out std_logic;
	DISP_D : out std_logic_vector (7 downto 0); -- SALIDA - VECTOR PARA MOSTRAR EL DISPLAY DE DECENAS
	DISP_U : out std_logic_vector (7 downto 0); -- SALIDA - VECTOR PARA MOSTRAR EL DISPLAY DE UNIDADES
	PWM : out std_logic
	);
end Codificador_Display;

architecture simple of Codificador_Display is				 
signal Qp,Qn : std_logic_vector(N-1 downto 0):=(others =>'0');
signal BT : std_logic :='0';
signal BdTconH: std_logic_vector(1 downto 0):=(others =>'0');
signal Q_ent : std_logic_vector(16 downto 0); -- SEÑAL QUE ES IGUAL A LA CUENTA PRESENTE DEL ULTRASONICO
signal Q_mult : std_logic_vector(25 downto 0); -- SEÑAL DE VECTOR PARA MULTIPLICAR LA CUENTA PRESENTE POR 340
signal Q_cuenta_cod : std_logic_vector (4 downto 0); -- SEÑAL DE VECTOR PARA ALMACENAR LOS BITS DE LA SEÑAL "Q_mult" QUE REPRESENTAN EL ENTERO
signal Q_suma : std_logic_vector(8 downto 0); -- SEÑAL DE VECTOR PARA REALIZAR LA SUMA Y OBTENER LA PARTE DE UNIDADES
signal Q_c2 : std_logic_vector(8 downto 0):=(others =>'0'); -- COMPLEMENTO 2 DE LAS DECENAS - SE SUMA CON LA SEÑAL "Q_cuenta_cod" PARA OBTENER LAS UNIDADES
signal Led_p, Led_n : std_logic :='0';

begin					
	BdT <= BT;
	PWM <= Led_p;
	BdTconH <= BT & H;
	Q_ent <= Q_US;
	Q_mult <= Q_US * "101010100";
	Q_cuenta_cod(4) <= Q_mult(24);
	Q_cuenta_cod(3) <= Q_mult(23);
	Q_cuenta_cod(2) <= Q_mult(22);
	Q_cuenta_cod(1) <= Q_mult(21);
	Q_cuenta_cod(0) <= Q_mult(20);
	Q_suma <= Q_cuenta_cod + Q_c2;
	
	Mux: process (BdTconH, Qp) is
	begin		
		case BdTconH is
			when "01" => Qn <= Qp+1;
			when "11" => Qn <= (others=>'0');
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
		if RST = '0' then
			Qp <= (others => '0');
		elsif CLK'event and CLK = '0' then
			Qp <= Qn;
			Led_p <= Led_n;
		end if;
	end process Combinacional;
	
	Codificador_dec: process (Q_cuenta_cod) is
	begin
		-- DECENAS
		-- 0
		if(Q_cuenta_cod <= "01001") then
			DISP_D <= "00110000"; -- 0
			Q_c2 <= "000000000";
		-- 1
		elsif(Q_cuenta_cod >= "01010" and Q_cuenta_cod <="10011") then
			DISP_D <= "00110001"; -- 1
			Q_c2 <= "011110110";
		-- 2
		elsif(Q_cuenta_cod >= "10100" and Q_cuenta_cod <="11101") then
			DISP_D <= "00110010"; -- 2
			Q_c2 <= "011101100";
		-- 3
		elsif(Q_cuenta_cod >= "11110") then
			DISP_D <= "00110011"; -- 3
		else
			DISP_D <= "00110000"; -- 0
			--Q_c2 <= "000000000";
		end if;
	end process Codificador_dec;
	
	Codificador_uni: process (Q_suma) is
	begin
		--
		-- UNIDADES
		-- 0
		if(Q_suma(3) = '0' and Q_suma(2) = '0' and Q_suma(1) = '0' and Q_suma(0) = '0') then
			DISP_U <= "00110000"; -- 0
		-- 1
		elsif(Q_suma(3) = '0' and Q_suma(2) = '0' and Q_suma(1) = '0' and Q_suma(0) = '1') then
			DISP_U <= "00110001"; -- 1
		-- 2
		elsif(Q_suma(3) = '0' and Q_suma(2) = '0' and Q_suma(1) = '1' and Q_suma(0) = '0') then
			DISP_U <= "00110010"; -- 2
		-- 3
		elsif(Q_suma(3) = '0' and Q_suma(2) = '0' and Q_suma(1) = '1' and Q_suma(0) = '1') then
			DISP_U <= "00110011"; -- 3
		-- 4
		elsif(Q_suma(3) = '0' and Q_suma(2) = '1' and Q_suma(1) = '0' and Q_suma(0) = '0') then
			DISP_U <= "00110100"; -- 4
		-- 5
		elsif(Q_suma(3) = '0' and Q_suma(2) = '1' and Q_suma(1) = '0' and Q_suma(0) = '1') then
			DISP_U <= "00110101"; -- 5
		-- 6
		elsif(Q_suma(3) = '0' and Q_suma(2) = '1' and Q_suma(1) = '1' and Q_suma(0) = '0') then
			DISP_U <= "00110110"; -- 6
		-- 7
		elsif(Q_suma(3) = '0' and Q_suma(2) = '1' and Q_suma(1) = '1' and Q_suma(0) = '1') then
			DISP_U <= "00110111"; -- 7
		-- 8
		elsif(Q_suma(3) = '1' and Q_suma(2) = '0' and Q_suma(1) = '0' and Q_suma(0) = '0') then
			DISP_U <= "00111000"; -- 8
		-- 9
		elsif(Q_suma(3) = '1' and Q_suma(2) = '0' and Q_suma(1) = '0' and Q_suma(0) = '1') then
			DISP_U <= "00111001"; -- 9
		else
			DISP_U <= "00110000"; -- 0
		end if;
	end process Codificador_uni;
	
	-- PROCESO PARA HACER UN PULSO DE 10 US PARA HABILITAR EL ULTRASONICO
	PWM_TRIGGER: process (Qp) is
	begin
		if(Qp < "111110100") then
			Led_n <= '1';
		else
			Led_n <= '0';
		end if;
	end process PWM_TRIGGER;


end architecture simple;