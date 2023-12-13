-- library
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE IEEE.std_logic_arith.ALL;
USE IEEE.std_logic_unsigned.ALL;

-- entity
ENTITY uart IS
	PORT (
		clk : IN STD_LOGIC;
		rst_n : IN STD_LOGIC;

		Seven_Segment : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		Digit_SS : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);

		-- serial part
		rs232_rx : IN STD_LOGIC;
		rs232_tx : OUT STD_LOGIC

	);
END ENTITY;
ARCHITECTURE RTL OF uart IS
	-- signal button : std_logic;

	TYPE ASCII_ARR IS ARRAY(0 TO 16) OF STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL ASCII : ASCII_ARR;

	SIGNAL ASCII_MODE : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
	SIGNAL BCD_MODE : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL MODE : STD_LOGIC_VECTOR(1 DOWNTO 0);

	TYPE ASCII_ANGKA_ARR IS ARRAY (0 TO 2) OF STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL ASCII_A, ASCII_B, ASCII_C, ASCII_D : ASCII_ANGKA_ARR;

	TYPE BCD_ANGKA_ARR IS ARRAY(0 TO 2) OF STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL BCD_A, BCD_B, BCD_C, BCD_D : BCD_ANGKA_ARR;

	SIGNAL BCD_A_FULL, BCD_B_FULL, BCD_C_FULL, BCD_D_FULL : STD_LOGIC_VECTOR(11 DOWNTO 0);

	SIGNAL A_I, B_I, C_I, D_I : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL GO_I : STD_LOGIC := '0';
	SIGNAL FPB_OUT : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL KPK_OUT : STD_LOGIC_VECTOR(31 DOWNTO 0);

	SIGNAL DONE, RST_I : STD_LOGIC;

	TYPE BCD_FPB_ARR IS ARRAY(0 TO 2) OF STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL BCD_FPB : BCD_FPB_ARR;

	TYPE BCD_KPK_ARR IS ARRAY(0 TO 9) OF STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL BCD_KPK : BCD_KPK_ARR;

	TYPE ASCII_FPB_O_ARR IS ARRAY(0 TO 2) OF STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL ASCII_FPB_O : ASCII_FPB_O_ARR;

	TYPE ASCII_KPK_O_ARR IS ARRAY(0 TO 9) OF STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL ASCII_KPK_O : ASCII_KPK_O_ARR;

	SIGNAL clockdivider : STD_LOGIC;
	SIGNAL sendCounter : INTEGER := 0;

	COMPONENT CLOCKDIV IS
		PORT (
			CLK : IN STD_LOGIC;
			divider : IN INTEGER;
			DIVOUT : BUFFER STD_LOGIC
		);
	END COMPONENT;

	COMPONENT ascii_to_bcd IS
		PORT (
			ascii : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
			bcd : OUT STD_LOGIC_VECTOR (3 DOWNTO 0)
		);
	END COMPONENT;

	COMPONENT bcdtobinary8bit IS
		PORT (
			bcd_i : IN STD_LOGIC_VECTOR (11 DOWNTO 0);
			bin_o : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
		);
	END COMPONENT;

	COMPONENT kalkulator_top_level IS
		PORT (
			clk, rst, go_i : IN STD_LOGIC;
			mode : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
			a_i, b_i, c_i, d_i : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			fpb_out : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
			kpk_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			done : OUT STD_LOGIC
		);
	END COMPONENT;

	COMPONENT binarytobcd8bit IS
		PORT (
			bin : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
			bcd1 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
			bcd2 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
			bcd3 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
		);
	END COMPONENT;

	COMPONENT binarytobcd32bit IS
		PORT (
			bin : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			bcd1 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
			bcd2 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
			bcd3 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
			bcd4 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
			bcd5 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
			bcd6 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
			bcd7 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
			bcd8 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
			bcd9 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
			bcd10 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
		);
	END COMPONENT;

	COMPONENT bcd_to_ascii IS
		PORT (
			bcd : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
			ascii : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
		);
	END COMPONENT;

	COMPONENT my_uart_top IS
		PORT (
			clk : IN STD_LOGIC;
			rst_n : IN STD_LOGIC;
			send : IN STD_LOGIC;
			send_data : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			receive : OUT STD_LOGIC;
			receive_data : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
			sent : BUFFER STD_LOGIC;
			rs232_rx : IN STD_LOGIC;
			rs232_tx : OUT STD_LOGIC
		);
	END COMPONENT;

	COMPONENT sev_seg IS
		PORT (
			--Input
			clk : IN STD_LOGIC;
			--dataA, dataB, dataC, dataD : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
			mode : in std_logic_vector(1 downto 0);
			--Output
			selector : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
			ss : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
		);
	END COMPONENT;

	SIGNAL send_data, receive_data : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL receive : STD_LOGIC;
	SIGNAL receive_c : STD_LOGIC;
	SIGNAL send, sent : STD_LOGIC;
	SIGNAL ASCII_DONE : STD_LOGIC;

	SIGNAL doneA, doneB, doneC, doneD : STD_LOGIC;

	SIGNAL doneCalculating : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL clockKalku : STD_LOGIC;
BEGIN

	sevenseg : sev_seg PORT MAP(clk,MODE , Digit_SS, Seven_Segment);

	UART : my_uart_top
	PORT MAP(
		clk => clk,
		rst_n => rst_n,
		send => send,
		send_data => send_data,
		receive => receive,
		receive_data => receive_data,
		sent => sent,
		rs232_rx => rs232_rx,
		rs232_tx => rs232_tx
	);
	-- ACCEPTING INPUT
	PROCESS (clk, rst_n, ASCII, ASCII_DONE)
		VARIABLE COUNT : INTEGER := 0;
	BEGIN
		IF rst_n = '0' THEN
			COUNT := 0;
			ASCII_DONE <= '0';
		ELSIF ((clk = '1') AND clk'event) THEN
			receive_c <= receive;
			IF ((receive = '0') AND (receive_c = '1') AND COUNT < 17) THEN
				ASCII(COUNT) <= receive_data;
				COUNT := COUNT + 1;
			ELSE
				COUNT := COUNT;
			END IF;
			IF COUNT >= 17 THEN
				ASCII_DONE <= '1';
			ELSE
				ASCII_DONE <= '0';
			END IF;
		END IF;
	END PROCESS;

	--STORING VARIABLE AND PARSING
	PROCESS (ASCII, ASCII_DONE)
	BEGIN
		IF ASCII_DONE = '1' THEN
			ASCII_MODE <= ASCII(0);
			ASCII_A(0) <= ASCII(2);
			ASCII_A(1) <= ASCII(3);
			ASCII_A(2) <= ASCII(4);
			ASCII_B(0) <= ASCII(6);
			ASCII_B(1) <= ASCII(7);
			ASCII_B(2) <= ASCII(8);
			ASCII_C(0) <= ASCII(10);
			ASCII_C(1) <= ASCII(11);
			ASCII_C(2) <= ASCII(12);
			ASCII_D(0) <= ASCII(14);
			ASCII_D(1) <= ASCII(15);
			ASCII_D(2) <= ASCII(16);
		ELSE
			ASCII_MODE <= (OTHERS => '0');
			ASCII_A <= (OTHERS => "00000000");
			ASCII_B <= (OTHERS => "00000000");
			ASCII_C <= (OTHERS => "00000000");
			ASCII_D <= (OTHERS => "00000000");
		END IF;
	END PROCESS;

	-- CONVERTING TO BCD
	CONV1 : ascii_to_bcd PORT MAP(ASCII_MODE, BCD_MODE);
	CONV2 : ascii_to_bcd PORT MAP(ASCII_A(0), BCD_A(0));
	CONV3 : ascii_to_bcd PORT MAP(ASCII_A(1), BCD_A(1));
	CONV4 : ascii_to_bcd PORT MAP(ASCII_A(2), BCD_A(2));
	CONV5 : ascii_to_bcd PORT MAP(ASCII_B(0), BCD_B(0));
	CONV6 : ascii_to_bcd PORT MAP(ASCII_B(1), BCD_B(1));
	CONV7 : ascii_to_bcd PORT MAP(ASCII_B(2), BCD_B(2));
	CONV8 : ascii_to_bcd PORT MAP(ASCII_C(0), BCD_C(0));
	CONV9 : ascii_to_bcd PORT MAP(ASCII_C(1), BCD_C(1));
	CONV10 : ascii_to_bcd PORT MAP(ASCII_C(2), BCD_C(2));
	CONV11 : ascii_to_bcd PORT MAP(ASCII_D(0), BCD_D(0));
	CONV12 : ascii_to_bcd PORT MAP(ASCII_D(1), BCD_D(1));
	CONV13 : ascii_to_bcd PORT MAP(ASCII_D(2), BCD_D(2));

	--CONCATING BCD
	BCD_A_FULL <= BCD_A(0) & BCD_A(1) & BCD_A(2);
	BCD_B_FULL <= BCD_B(0) & BCD_B(1) & BCD_B(2);
	BCD_C_FULL <= BCD_C(0) & BCD_C(1) & BCD_C(2);
	BCD_D_FULL <= BCD_D(0) & BCD_D(1) & BCD_D(2);

	-- CONVERTING BCD TO BINARY
	MODE <= BCD_MODE(1 DOWNTO 0);
	BCDBIN1 : bcdtobinary8bit PORT MAP(BCD_A_FULL, A_I);
	BCDBIN2 : bcdtobinary8bit PORT MAP(BCD_B_FULL, B_I);
	BCDBIN3 : bcdtobinary8bit PORT MAP(BCD_C_FULL, C_I);
	BCDBIN4 : bcdtobinary8bit PORT MAP(BCD_D_FULL, D_I);

	PROCESS (clk, rst_n, A_I, B_I, C_I, D_I)
		CONSTANT ZERO : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
		VARIABLE COUNT : INTEGER := 0;
		VARIABLE TRIGGER : STD_LOGIC;
	BEGIN
		IF rst_n = '0' THEN
			COUNT := 0;
		ELSIF clk'event AND clk = '1' THEN
			IF TRIGGER = '1' THEN
				COUNT := COUNT + 1;
			END IF;
		END IF;
		IF A_I /= ZERO AND B_I /= ZERO AND C_I /= ZERO AND D_I /= ZERO THEN
			TRIGGER := '1';
		ELSE TRIGGER := '0';
		END IF;
		IF COUNT >= 1000 THEN
			GO_I <= '1';
		ELSE
			GO_I <= '0';
		END IF;
	END PROCESS;
	RST_I <= NOT rst_n;
	-- CALCULATING FPB AND KPK
	KALKULATOR : kalkulator_top_level PORT MAP(clockKalku, RST_I, GO_I, MODE, A_I, B_I, C_I, D_I, FPB_OUT, KPK_OUT, DONE);
	kalkuclock : CLOCKDIV PORT MAP(clk, 10000000, clockKalku);
	PROCESS (DONE)
	BEGIN
		IF (DONE = '1') THEN
			doneCalculating <= "00000001";
		ELSE
			doneCalculating <= "00000000";
		END IF;
	END PROCESS;
	--CONVERTING OUTPUT TO BCD
	CONVFPB : binarytobcd8bit PORT MAP(FPB_OUT, BCD_FPB(0), BCD_FPB(1), BCD_FPB(2));
	CONVKPK : binarytobcd32bit PORT MAP(KPK_OUT, BCD_KPK(0), BCD_KPK(1), BCD_KPK(2), BCD_KPK(3), BCD_KPK(4), BCD_KPK(5), BCD_KPK(6), BCD_KPK(7), BCD_KPK(8), BCD_KPK(9));

	--CONVERTING BCD OUTPUT TO ASCII
	CONVFPBBCD1 : bcd_to_ascii PORT MAP(BCD_FPB(0), ASCII_FPB_O(0));
	CONVFPBBCD2 : bcd_to_ascii PORT MAP(BCD_FPB(1), ASCII_FPB_O(1));
	CONVFPBBCD3 : bcd_to_ascii PORT MAP(BCD_FPB(2), ASCII_FPB_O(2));

	CONVKPKBCD1 : bcd_to_ascii PORT MAP(BCD_KPK(0), ASCII_KPK_O(0));
	CONVKPKBCD2 : bcd_to_ascii PORT MAP(BCD_KPK(1), ASCII_KPK_O(1));
	CONVKPKBCD3 : bcd_to_ascii PORT MAP(BCD_KPK(2), ASCII_KPK_O(2));
	CONVKPKBCD4 : bcd_to_ascii PORT MAP(BCD_KPK(3), ASCII_KPK_O(3));
	CONVKPKBCD5 : bcd_to_ascii PORT MAP(BCD_KPK(4), ASCII_KPK_O(4));
	CONVKPKBCD6 : bcd_to_ascii PORT MAP(BCD_KPK(5), ASCII_KPK_O(5));
	CONVKPKBCD7 : bcd_to_ascii PORT MAP(BCD_KPK(6), ASCII_KPK_O(6));
	CONVKPKBCD8 : bcd_to_ascii PORT MAP(BCD_KPK(7), ASCII_KPK_O(7));
	CONVKPKBCD9 : bcd_to_ascii PORT MAP(BCD_KPK(8), ASCII_KPK_O(8));
	CONVKPKBCD10 : bcd_to_ascii PORT MAP(BCD_KPK(9), ASCII_KPK_O(9));

	-- TRANSFERING OUTPUT TO UART
	PROCESS (rst_n, MODE, sent, ASCII_FPB_O, ASCII_KPK_O)
		VARIABLE COUNT : INTEGER := 0;
	BEGIN
		IF rst_n = '0' THEN
			COUNT := 0;
			sendCounter <= 0;
		ELSIF sent'event AND sent = '1' THEN
			COUNT := COUNT + 1;
			sendCounter <= sendCounter + 1;
		END IF;
		IF MODE = "00" AND COUNT < 3 THEN
			send_data <= ASCII_FPB_O(COUNT);
		ELSIF MODE = "01" AND COUNT < 10 THEN
			send_data <= ASCII_KPK_O(COUNT);
		ELSIF mode = "10" AND COUNT < 15 THEN
			IF COUNT < 3 THEN
				send_data <= ASCII_FPB_O(COUNT);
			ELSIF COUNT = 3 THEN
				send_data <= "00100000";
			ELSE
				send_data <= ASCII_KPK_O(COUNT);
			END IF;
		ELSE
			send_data <= "00000000";
		END IF;
	END PROCESS;

	clockdivide : CLOCKDIV PORT MAP(clk, 25000000, clockdivider);
	PROCESS (rst_n, clockdivider, sendCounter, MODE, DONE)
	BEGIN
		IF rst_n = '0' THEN
			send <= '0';
		ELSIF clockdivider = '1' AND DONE = '1' THEN
			IF MODE = "00" AND sendCounter >= 3 THEN
				send <= '0';
			ELSIF MODE = "01" AND sendCounter >= 10 THEN
				send <= '0';
			ELSIF MODE <= "10" AND sendCounter >= 15 THEN
				send <= '0';
			ELSE
				send <= '1';
			END IF;
		ELSE
			send <= '0';
		END IF;
	END PROCESS;
END ARCHITECTURE;