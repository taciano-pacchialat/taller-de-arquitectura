
-- Entidad "reloj":	
-- Descripci�n: Aqu� se define el generador para el reloj de la CPU. Su funci�n es simple, 
-- ya que se encarga �nicamente de crear y transmitir una se�al peri�dica, cuyo per�odo se 
-- encuentra establecido en el paquete "const_reloj", hacia el administrador del procesador
-- para que �ste gestione a partir de ella la habilitaci�n de los dem�s componentes
-- de la CPU. Este reloj se activa una vez finalizado el ensamblaje del programa
-- para comenzar su ejecuci�n y se desactiva solamente cuando todos los otros 
-- procesos del procesador ya se encuentren detenidos por el administrador. 
-- Descripci�n: Aqu� se define el administrador de la CPU, encargado de, en cada ciclo
-- de reloj, habilitar en primer lugar la ejecuci�n simult�nea de todas las etapas del 
-- pipeline (en caso de que la segmentaci�n del procesador se encuentre activada por el 
-- usuario). Luego, antes de que finalice el ciclo de reloj habilitar� al banco de 
-- registros internos intermedios de la segmentaci�n para que reciba y almacene de las 
-- etapas "decode", "execute" y "memory access" toda la informaci�n que deseen 
-- transmitir especialmente a las siguientes etapas del pipeline que no sean 
-- consecutivas a ellas.
-- Procesos: 
-- Main: Mantiene la se�al de reloj en un estado inactivo hasta recibir desde el
-- ensamblador la se�al de finalizaci�n del ensamblaje del programa, momento a partir
-- del cual proceder� a generar los ciclos de reloj, activando la se�al durante la 
-- primera mitad de cada per�odo y desactiv�ndola durante la segunda mitad. Esta se�al
-- ser� transmitida al administrador de la CPU, el cual utilizar� tanto el flanco 
-- ascendente como el descendente de cada ciclo para gestionar la habilitaci�n de todos
-- los dem�s componentes del procesador. Finalmente, una vez recibida la se�al del
-- administrador de que el resto de los m�dulos de la CPU ya se encuentran detenidos,
-- este proceso se detendr� de manera permanente, por lo que la se�al de reloj volver�
-- a su estado inicial inactivo	y ya no se generar�n m�s ciclos de reloj.


library TDA_1819;	
use TDA_1819.const_reloj.all;


library ieee;
use ieee.NUMERIC_STD.all;
use ieee.std_logic_1164.all;
library std;
use std.TEXTIO.all;



entity reloj is

    port (
		CLK				: out std_logic;
		DoneCompCPU		: in  std_logic;
		StopEnd			: in  std_logic);

end reloj;




architecture reloj_architecture of reloj is		


	
begin	
	
	
	Main: PROCESS
	
	VARIABLE First: BOOLEAN := true;
	
	BEGIN
		if (First) then
			First := false;
			CLK <= '0';
		else
			CLK <= '1' AND DoneCompCPU;
		end if;
		WAIT FOR PERIODO / 2; 
		CLK <= '0';
		WAIT FOR PERIODO / 2;
		if (StopEnd = '1') then
			WAIT;
		end if; 
	END PROCESS Main;
	

end reloj_architecture;