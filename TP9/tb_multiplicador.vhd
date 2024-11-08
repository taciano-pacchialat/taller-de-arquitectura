use work.Utiles.all;

architecture test of tb_multiplicador is
    -- Señales para conectar al DUT (Device Under Test)
    signal A, B: Bit_Vector(3 downto 0);
    signal STB, CLK: Bit;
    signal Result: Bit_Vector(7 downto 0);
    signal Done: Bit;

    -- Instancia del multiplicador (DUT)
    component multiplicador is
        port(
            A, B: in Bit_Vector(3 downto 0);
            STB: in Bit;
            CLK: in Bit;
            Result: out Bit_Vector(7 downto 0);
            Done: out Bit
        );
    end component;

begin
    uut: multiplicador
        port map (
            A => A,
            B => B,
            STB => STB,
            CLK => CLK,
            Result => Result,
            Done => Done
        );

    -- Generación de la señal de reloj utilizando el procedimiento 'Clock' del package 'Utils'
    ClockProcess: process
    begin
        Clock(CLK, 7.5 ns, 7.5 ns);  -- T = 15 ns
    end process;

    StimulusProcess: process
    begin
        
        B <= Convert(8, 4);   -- A = 8
        A <= Convert(3, 4);   -- B = 3
        STB <= '0';    

        STB <= '1', '0' after 15 ns;

        wait until Done = '1';
    end process;

end test;