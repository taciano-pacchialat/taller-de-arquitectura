entity multiplicador is
    port(
        A, B: in Bit_Vector(3 downto 0);
        STB: in Bit;
        CLK: in Bit;
        Result: out Bit_Vector(7 downto 0);
        Done: out Bit
    );
end multiplicador;

architecture Behavioral of multiplicador is
    -- Componentes a utilizar
    component ShiftN is
        port (
            CLK: in Bit;
            CLR: in Bit;
            LD: in Bit;
            SH: in Bit;
            DIR: in Bit;
            D: in Bit_Vector(3 downto 0);
            Q: out Bit_Vector(7 downto 0)
        ); 
    end component;

    component Controller is
        port (
            CLK: in Bit;
            STB: in Bit;
            LSB: in Bit;
            STOP: in Bit;
            SHIFT: out Bit;
            INIT: out Bit;
            ADD: out Bit;
            DONE: out Bit
        );
    end component;

    component acumulador is 
        port (
            D: in Bit_Vector(7 downto 0);
            Clk: in Bit;
            Pre: in Bit;
            Clr: in Bit;
            Q: out Bit_Vector(7 downto 0)
        );
    end component;

    component Adder8 is 
        port (
            A, B: in Bit_Vector(7 downto 0);
            Cin: in Bit;
            Cout: out Bit;
            Sum: out Bit_Vector(7 downto 0)
        );
    end component;

    -- Señales internas
    signal Stop, Init, Shift, Add: Bit;
    signal Q_SRA, Q_SRB: Bit_Vector(7 downto 0);
    signal Q_ACC, D_ACC: Bit_Vector(7 downto 0);
    signal COut: Bit;
    signal Q_ADDER: Bit_Vector(7 downto 0);
    signal Estable : Bit;
	
	-- Las entradas del acumulador son activas en bajo
	signal NotInit, NotClk: Bit;

begin 
    -- Asignaciones concurrentes
        NotInit <= not Init;

        Result <= Q_ACC;
        Stop <= not(Q_SRA(0) or Q_SRA(1) or Q_SRA(2) or Q_SRA(3) 
                            or Q_SRA(4) or Q_SRA(5) or Q_SRA(6) or Q_SRA(7));
        NotClk <= not CLK;
        Estable <= '0', '1' after 2 ns;


    -- Instancia del controlador de la maquina
    fsmInstance: Controller
        port map (
            CLK => NotClk,
            STB => STB,
            LSB => Q_SRA(0),
            STOP => Stop,
            SHIFT => Shift,
            INIT => Init,
            ADD => Add,
            DONE => Done
        );
    
    -- Instancia del registro A
    shiftAInstance: ShiftN
        port map (
            CLK => CLK,
            CLR => '0',
            DIR => '0',
            LD => Init,
            SH => Shift,
            D => A,
			Q => Q_SRA
        );

    -- Instancia del registro B
    shiftBInstance: ShiftN
        port map (
            CLK => CLK,
            CLR => '0',
            DIR => '1',
            LD => Init,
            SH => Shift,
            D => B,		   
			Q => Q_SRB
        );
    -- Instancia del sumador
    adderInstance: Adder8
        port map (
            A => Q_SRB,
            B => Q_ACC,
            Cin => '0',
            Sum => Q_ADDER,
            Cout => COut
        );
    -- Instancia del Latch8
    accumulatorInstance: acumulador 
    port map (
        D => Q_ADDER,
        Clk => Add, -- Se hace un 'LD' cuando Add = '1'
        Pre => '1',
        Clr => NotInit,
        Q => Q_ACC
    );
end Behavioral;


