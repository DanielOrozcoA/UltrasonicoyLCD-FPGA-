library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_arith.all;
use IEEE.STD_LOGIC_unsigned.all;

entity PWM_ADC is
	
	generic(
    K: integer:=50000;
	N: integer:=16
	);
	
	port(
	CLK : in std_logic;
	RST : in std_logic;
	H : in std_logic;
	BOTONES : in std_logic_vector(7 downto 0);
	--BdT : out std_logic;
	PWM : out std_logic;
	PWM2 : out std_logic
	);
end PWM_ADC;

architecture simple of PWM_ADC is
signal Qp,Qn : std_logic_vector(N-1 downto 0):=(others =>'0');
signal BT : std_logic :='0';
signal BdTconH: std_logic_vector(1 downto 0):=(others =>'0');
signal Led_p, Led_n : std_logic :='0';
signal CCPR : std_logic_vector(N-1 downto 0):=(others =>'0');
signal IN_BOT: std_logic_vector(7 downto 0):=(others =>'0');

begin					
	--BdT <= BT;
	PWM <= Led_p;
	PWM2 <= not Led_p;
	BdTconH <= BT & H;
	IN_BOT <= BOTONES;
	CCPR <= IN_BOT * "11000100";
	
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
			--Led_n <= not Led_p;
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
	
	PWM_REG: process (CLK, RST, BOTONES, IN_BOT) is
	begin
		--CCPR <= IN_BOT * "11000100";
		if Qp < CCPR then
			Led_n <= '1';
		else Led_n <= '0';
		end if;
	end process PWM_REG;


end architecture simple;