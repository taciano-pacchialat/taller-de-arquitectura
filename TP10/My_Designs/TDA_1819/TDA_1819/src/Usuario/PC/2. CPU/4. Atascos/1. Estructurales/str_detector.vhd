
-- Entidad "str_detector":
-- Descripci�n: Aqu� se define el detector para posibles atascos por dependencias
-- estructurales, ya sea por conflictos para acceder a la memoria de datos o al banco de 
-- registros de prop�sito general de la CPU para actualizarlo. Su tarea es analizar si
-- efectivamente existen dichas dependencias a partir de informaci�n proporcionada por el
-- administrador de la etapa de ejecuci�n de la segmentaci�n, el banco de registros 
-- internos intermedios y el detector de dependencias de datos. En caso afirmativo, 
-- transmitir� la correspondiente se�al a todas las etapas del pipeline que la necesiten 
-- para detener temporalmente su ejecuci�n hasta que la dependencia sea resuelta. 
-- Procesos:
-- SetStallSTRM: En primer lugar, recibe la se�al del administrador de la etapa de ejecuci�n
-- para proceder a realizar la detecci�n de una posible dependencia estructural por conflicto
-- en el acceso a memoria de datos de la PC. Luego, lleva a cabo la detecci�n propiamente
-- dicha a partir de la informaci�n recibida del administrador de la etapa de ejecuci�n de la
-- segmentaci�n: si en el ciclo actual de reloj se est�n ejecutando la ALU y la �ltima
-- fase de una operaci�n en la FPU, entonces esto implicar�a que en el pr�ximo ciclo dos 
-- instrucciones intentar�n acceder al mismo tiempo a la memoria de datos (ejecuci�n de la 
-- etapa "memory access"), por lo que se producir� un conflicto por este recurso (atasco 
-- estructural). Con esta informaci�n, este proceso podr� detectarlo y as� notificar su 
-- presencia a las etapas del pipeline que requieran saberlo para detener su ejecuci�n actual.
-- SetStallSTRW: En primer lugar, recibe la se�al del detector de dependencias de datos en 
-- caso de que ocurra un atasco de tipo WAW para proceder a realizar la detecci�n de una
-- posible dependencia estructural por conflicto en el acceso al banco de registros de 
-- prop�sito general de la CPU para actualizarlo. Luego, lleva a cabo la detecci�n propiamente
-- dicha a partir de la presencia actual o no de un atasco estructural respecto a la memoria 
-- de datos y de la informaci�n recibida del banco de registros internos intermedios para
-- la segmentaci�n: si no existe atasco estructural y la instrucci�n siguiente a aqu�lla que
-- provoc� el atasco WAW no requiere la utilizaci�n de la FPU para completar su ejecuci�n, 
-- entonces cuando finalice el atasco WAW ambas instrucciones necesitar�n acceder al banco de 
-- registros de prop�sito general para actualizarlo (ejecuci�n de la etapa "writeback"), por 
-- lo que se producir� un conflicto por este recurso (atasco estructural). La misma situaci�n 
-- suceder� si existiera un atasco estructural respecto a la memoria de datos y el mismo no 
-- se hubiera resuelto cuando finalice el atasco WAW: tanto la instrucci�n que en el 
-- conflicto por la memoria logr� acceder a ella como la instrucci�n que provoc� el atasco WAW 
-- intentar�n actualizar simult�neamente el banco de registros de prop�sito general, por lo 
-- que se aqu� tambi�n se producir� un conflicto por este recurso (atasco estructural). En 
-- ambos casos, deber�n ser notificadas las etapas del pipeline que requieran saberlo para 
-- detener su ejecuci�n actual.
-- Main: Este proceso se ejecuta �nicamente cuando se produce un cambio en cualquiera de las
-- se�ales de detecciones de dependencias estructurales llevadas a cabo por los dos procesos
-- anteriores, actualizando en consecuencia la se�al de atasco estructural general (sin 
-- importar el recurso en particular en conflicto, si es que lo hubiera) con el valor que 
-- corresponda para que el mismo sea conocido por todas las etapas del pipeline que requieran
-- saberlo para continuar o detener su ejecuci�n actual seg�n sea necesario.


library TDA_1819; 
use TDA_1819.const_registros.all;
use TDA_1819.const_cpu.all; 
use TDA_1819.tipos_cpu.all;

LIBRARY IEEE;

USE std.textio.all;
use ieee.NUMERIC_STD.all;
USE IEEE.std_logic_1164.all; 




entity str_detector is
	
	generic (
		Pipelining	: BOOLEAN);
	
	port ( 
		StallSTR		: out 	std_logic;
		StallSTRW		: inout std_logic;
		EnableEXALU		: in  	std_logic;
		EnableEXFPU		: in  	std_logic;
		StallWAWAux		: in  	std_logic;
		PipeFP_4		: in  	std_logic;
		DoneSTRW		: in  	std_logic;
		EnableCheckSTRM	: in  	std_logic);

end str_detector;




architecture STR_DETECTOR_ARCHITECTURE of str_detector is


	SIGNAL StallSTRM:		std_logic;

	
begin
	

	SetStallSTRM: PROCESS
	
	VARIABLE First: BOOLEAN := true;
	
	BEGIN
		if (First) then
			First := false;
			StallSTRM <= '0';
			WAIT FOR 1 ns;
		end if; 
		WAIT UNTIL ((Pipelining) AND (rising_edge(EnableCheckSTRM)));
		if ((StallWAWAux = '1') and (StallSTRM = '0')) then
			StallSTRM <= '0';
		else
			StallSTRM <= not (EnableEXALU or EnableEXFPU);
		end if;
	END PROCESS SetStallSTRM; 
	
	
	SetStallSTRW: PROCESS
	
	BEGIN	
		StallSTRW <= '0';
		WAIT UNTIL rising_edge(StallWAWAux);
		if ((StallSTRM = '0') and (PipeFP_4 = '0')) then
			WAIT UNTIL falling_edge(StallWAWAux);
			StallSTRW <= '1';
			WAIT UNTIL rising_edge(DoneSTRW);
		elsif (StallSTRM = '1') then
			WAIT UNTIL falling_edge(StallWAWAux);
			if (StallSTRM = '1') then
				StallSTRW <= '1';
				WAIT UNTIL rising_edge(DoneSTRW);
			end if;
		end if;
	END PROCESS SetStallSTRW;
	
	
	Main: PROCESS
	
	VARIABLE First: BOOLEAN := true;
	
	BEGIN
		if (First) then
			First := false;
			StallSTR <= '0';
			WAIT FOR 1 ns;
		end if;	
		WAIT ON StallSTRM, StallSTRW;
		StallSTR <= StallSTRM or StallSTRW;
	END PROCESS Main;
		
	
end STR_DETECTOR_ARCHITECTURE;





