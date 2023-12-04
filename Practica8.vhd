library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.STD_LOGIC_ARITH.all;

entity Practica8 is
	port(
		CLK 	: in std_logic;
		RST		: in std_logic;
		H 		: in std_logic;
		ECHO_US	: in std_logic; -- ENTRADA ECHO - ULTRASONICO
		TRIGGER_US	: out std_logic; -- SALIDA PARA HABILITAR EL TRIGGER DEL ULTRASONICO
		-- ENTRADAS Y SALIDAS LCD
		e: out std_logic;
		rs: out std_logic;
		datos: out std_logic_vector(7 downto 0);
--		DISP_D: in std_logic_vector(7 downto 0);
--		DISP_U: in std_logic_vector(7 downto 0)
		-- ENTRADAS Y SALIDAS PWM
		PWM1	: out std_logic;
		PWM2	: out std_logic;
		ADC		: in std_logic_vector(7 downto 0)
	);
end Practica8;

architecture simple of Practica8 is
signal Q_US : std_logic_vector (16 downto 0);
signal RESET_US : std_logic;
signal char_dec: std_logic_vector (7 downto 0);
signal char_uni: std_logic_vector (7 downto 0);

begin	

	C1 : entity work.Ultrasonico generic map(88234,17)port map(CLK, RESET_US, ECHO_US, Q_US);
	C2 : entity work.Codificador_Display generic map(50000000,26)port map(CLK, RST, H, Q_US, RESET_US, char_dec, char_uni, TRIGGER_US);
	C3 : entity work.LCD port map(CLK, e, rs, datos, char_dec, char_uni);
	C4 : entity work.PWM_ADC generic map(50000,16) port map(CLK,RST,H,ADC,PWM1,PWM2);

end architecture simple;