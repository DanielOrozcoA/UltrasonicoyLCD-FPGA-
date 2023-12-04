library IEEE;
use IEEE.std_logic_1164.all;

entity LCD is
	port(
		clk: in std_logic;
		e: out std_logic;
		rs: out std_logic;
		datos: out std_logic_vector(7 downto 0);
		DISP_D: in std_logic_vector(7 downto 0);
		DISP_U: in std_logic_vector(7 downto 0)
	);
end LCD;

architecture simple of LCD is
type estados is (E0, E1, E2, E3, E4, E5, E6, E7, E8, E9,
				E10, E11, E12, E13, E14, E15, E16, E17, E18, E19,
				E20, E21, E22, E23, E24, E25, E26, E27, E28, E29,
				E30, E31, E32, E33, E34, E35, E36, E37, E38, E39,
				E40, E41, E42, E43, E44, E45, E46, E47, E48, E49,
				E50, E51, E52, E53, E54, E55, E56, E57, IDLE
				);
signal estado_presente, estado_futuro: estados := E0;
signal char_dec : std_logic_vector(7 downto 0);
signal char_uni : std_logic_vector(7 downto 0);

begin
	
	char_dec <= DISP_D;
	char_uni <= DISP_U;
	
	proceso1: process(estado_presente)
	begin
		case estado_presente is
			-- CONFIGURACION DEL LCD:
			when E0 =>
				datos <= X"38"; -- SET (DATO, LINEA Y MATRIZ)
				e <= '1';       -- SUBE SE�AL
				rs <= '0';      -- INDICA QUE SERA UN COMANDO
				estado_futuro <= E1;
			when E1 =>
				e <= '0';       -- BAJA SE�AL
				estado_futuro <= E2;
			-- LIMPIA LCD
			when E2 =>
				datos <= X"01"; -- CLEAR DISPLAY
				e <= '1';       -- SUBE SE�AL
				rs <= '0';      -- INDICA QUE SERA UN COMANDO
				estado_futuro <= E3;
			when E3 =>
				e <= '0';       -- BAJA SE�AL
				estado_futuro <= E4;
			-- ACTIVA DISPLAY Y CURSOR
			when E4 =>
				datos <= X"0E"; -- DISPLAY ON Y CURSOR ON
				e <= '1';       -- SUBE SE�AL
				rs <= '0';      -- INDICA QUE SERA UN COMANDO
				estado_futuro <= E5;
			when E5 =>
				e <= '0';       -- BAJA SE�AL
				estado_futuro <= E6;
			-- CARACTER D
			when E6 =>
				datos <= X"44"; -- D
				e <= '1';       -- SUBE SE�AL
				rs <= '1';      -- INDICA QUE SERA UN CARACTER
				estado_futuro <= E7;
			when E7 =>
				e <= '0';       -- BAJA SE�AL
				estado_futuro <= E8;
			-- CARACTER i
			when E8 =>
				datos <= X"69"; -- i
				e <= '1';       -- SUBE SE�AL
				rs <= '1';      -- INDICA QUE SERA UN CARACTER
				estado_futuro <= E9;
			when E9 =>
				e <= '0';       -- BAJA SE�AL
				estado_futuro <= E10;
			-- CARACTER s
			when E10 =>
				datos <= X"73"; -- s
				e <= '1';       -- SUBE SE�AL
				rs <= '1';      -- INDICA QUE SERA UN CARACTER
				estado_futuro <= E11;
			when E11 =>
				e <= '0';       -- BAJA SE�AL
				estado_futuro <= E12;
			-- CARACTER t
			when E12 =>
				datos <= X"74"; -- t
				e <= '1';       -- SUBE SE�AL
				rs <= '1';      -- INDICA QUE SERA UN CARACTER
				estado_futuro <= E13;
			when E13 =>
				e <= '0';       -- BAJA SE�AL
				estado_futuro <= E14;
			-- CARACTER a
			when E14 =>
				datos <= X"61"; -- a
				e <= '1';       -- SUBE SE�AL
				rs <= '1';      -- INDICA QUE SERA UN CARACTER
				estado_futuro <= E15;
			when E15 =>
				e <= '0';       -- BAJA SE�AL
				estado_futuro <= E16;
			-- CARACTER n
			when E16 =>
				datos <= X"6E"; -- n
				e <= '1';       -- SUBE SE�AL
				rs <= '1';      -- INDICA QUE SERA UN CARACTER
				estado_futuro <= E17;
			when E17 =>
				e <= '0';       -- BAJA SE�AL
				estado_futuro <= E18;
			-- CARACTER c
			when E18 =>
				datos <= X"63"; -- c
				e <= '1';       -- SUBE SE�AL
				rs <= '1';      -- INDICA QUE SERA UN CARACTER
				estado_futuro <= E19;
			when E19 =>
				e <= '0';       -- BAJA SE�AL
				estado_futuro <= E20;
			-- CARACTER i
			when E20 =>
				datos <= X"69"; -- i
				e <= '1';       -- SUBE SE�AL
				rs <= '1';      -- INDICA QUE SERA UN CARACTER
				estado_futuro <= E21;
			when E21 =>
				e <= '0';       -- BAJA SE�AL
				estado_futuro <= E22;
			-- CARACTER a
			when E22 =>
				datos <= X"61"; -- a
				e <= '1';       -- SUBE SE�AL
				rs <= '1';      -- INDICA QUE SERA UN CARACTER
				estado_futuro <= E23;
			when E23 =>
				e <= '0';       -- BAJA SE�AL
				estado_futuro <= E24;
			-- CARACTER :
			when E24 =>
				datos <= X"3A"; -- :
				e <= '1';       -- SUBE SE�AL
				rs <= '1';      -- INDICA QUE SERA UN CARACTER
				estado_futuro <= E25;
			when E25 =>
				e <= '0';       -- BAJA SE�AL
				estado_futuro <= E26;
			-- CARACTER " "
			when E26 =>
				datos <= X"20"; -- " "
				e <= '1';       -- SUBE SE�AL
				rs <= '1';      -- INDICA QUE SERA UN CARACTER
				estado_futuro <= E27;
			when E27 =>
				e <= '0';       -- BAJA SE�AL
				estado_futuro <= E28;
			-- CARACTER X
			when E28 =>
				datos <= char_dec;
				e <= '1';       -- SUBE SE�AL
				rs <= '1';      -- INDICA QUE SERA UN CARACTER
				estado_futuro <= E29;
			when E29 =>
				e <= '0';       -- BAJA SE�AL
				estado_futuro <= E30;
			-- CARACTER X
			when E30 =>
				datos <= char_uni;
				e <= '1';       -- SUBE SE�AL
				rs <= '1';      -- INDICA QUE SERA UN CARACTER
				estado_futuro <= E31;
			when E31 =>
				e <= '0';       -- BAJA SE�AL
				estado_futuro <= E32;
			-- CARACTER " "
			when E32 =>
				datos <= X"20"; -- " "
				e <= '1';       -- SUBE SE�AL
				rs <= '1';      -- INDICA QUE SERA UN CARACTER
				estado_futuro <= E33;
			when E33 =>
				e <= '0';       -- BAJA SE�AL
				estado_futuro <= E34;
			-- CARACTER c
			when E34 =>
				datos <= X"63"; -- c
				e <= '1';       -- SUBE SE�AL
				rs <= '1';      -- INDICA QUE SERA UN CARACTER
				estado_futuro <= E35;
			when E35 =>
				e <= '0';       -- BAJA SE�AL
				estado_futuro <= E36;
			-- CARACTER m
			when E36 =>
				datos <= X"6D"; -- m
				e <= '1';       -- SUBE SE�AL
				rs <= '1';      -- INDICA QUE SERA UN CARACTER
				estado_futuro <= E37;
			when E37 =>
				e <= '0';       -- BAJA SE�AL
				estado_futuro <= E38;
			-- CICLO INFINITO PARA ACTUALIZAR CENTIMETROS
			when E38 =>
				datos <= X"8B"; -- MANDA CURSOR A POSICION DE DECENAS
				e <= '1';       -- SUBE SE�AL
				rs <= '0';      -- INDICA QUE SERA UN COMANDO
				estado_futuro <= E39;
			when E39 =>
				e <= '0';       -- BAJA SE�AL
				estado_futuro <= E40;
			when E40 =>
				datos <= char_dec;
				e <= '1';       -- SUBE SE�AL
				rs <= '1';      -- INDICA QUE SERA UN CARACTER
				estado_futuro <= E41;
			when E41 =>
				e <= '0';       -- BAJA SE�AL
				estado_futuro <= E42;
			-- CARACTER 1
			when E42 =>
				datos <= char_uni;
				e <= '1';       -- SUBE SE�AL
				rs <= '1';      -- INDICA QUE SERA UN CARACTER
				estado_futuro <= E43;
			when E43 =>
				e <= '0';       -- BAJA SE�AL
				estado_futuro <= E38;
			when IDLE =>
				estado_futuro <= IDLE; -- AQUI SE QUEDA INACTIVO
			when others =>
				estado_futuro <= IDLE;
		end case;
	end process proceso1;
	
	proceso2: process(clk)
	variable pulsos: integer range 0 to 50000000;
	begin
		if(clk'event and clk='1') then
			if(pulsos=2500000) then -- 50 ms
				pulsos := 0;
				estado_presente <= estado_futuro;
			else
				pulsos := pulsos + 1;
			end if;
		end if;
	end process proceso2;
	
	
end architecture simple;