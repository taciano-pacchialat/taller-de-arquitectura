
-- Entidad "buses_admin":
-- Descripci�n: Aqu� se define el administrador para todos los buses de la PC. T�ngase
-- en cuenta que, al tratarse de una arquitectura Harvard, existir�n buses separados
-- para las instrucciones y los datos, de manera tal de poder transmitir simult�neamente
-- desde y hacia la memoria de instrucciones y la de datos, ya que de otro modo no podr�an
-- ejecutarse en la CPU al mismo tiempo las etapas "fetch" (acceso a memoria de 
-- instrucciones) y "memory access" (acceso a memoria de datos). Por lo tanto, este 
-- administrador podr� durante el emsamblaje del programa recibir informaci�n desde el 
-- ensamblador de la PC a trav�s de los buses de direcciones, datos y control para gestionar 
-- su transmisi�n hacia la memoria de datos (variables del programa) o instrucciones 
-- (c�digo del programa) de la PC seg�n corresponda. Luego, durante la ejecuci�n del 
-- programa deber� ser capaz de administrar en forma paralela las transmisiones de 
-- informaci�n mediante los buses entre la unidad de b�squeda de la CPU (etapa "fetch") 
-- y la memoria de instrucciones y entre la etapa "memory access" y la memoria de datos.
-- Procesos:
-- ToDataMemory: En primer lugar, recibe la se�al del ensamblador o de la etapa "memory
-- access" para comenzar una nueva transmisi�n de informaci�n hacia la memoria de datos. 
-- Luego carga en los buses de direcciones, datos y control de la memoria de datos la 
-- informaci�n recibida desde los buses del ensamblador o de la etapa "memory access" seg�n 
-- corresponda, para finalmente proceder a realizar la transmisi�n propiamente dicha de 
-- la misma hacia la memoria de datos.
-- ToInstMemory: En primer lugar, recibe la se�al del ensamblador o de la unidad de 
-- b�squeda de la CPU (etapa "fetch") para comenzar una nueva transmisi�n de informaci�n 
-- hacia la memoria de instrucciones. Luego carga en los buses de direcciones, datos y 
-- control de la memoria de instrucciones la informaci�n recibida desde los buses del 
-- ensamblador o de la etapa "fetch" seg�n corresponda, para finalmente proceder a 
-- realizar la transmisi�n propiamente dicha de la misma hacia la memoria de 
-- instrucciones.
-- FromDataMemory: En primer lugar, recibe la se�al de la memoria de datos de la PC para
-- comenzar una nueva transmisi�n de informaci�n hacia la etapa "memory access" de la CPU
-- (n�tese que el ensamblador no se encuentra involucrado en este proceso porque jam�s
-- requerir� leer un dato de la memoria de datos para cumplir su tarea). Luego carga
-- en el bus de datos de la etapa "memory access" la informaci�n recibida desde el bus
-- de la memoria de datos, para finalmente proceder a realizar la transmisi�n propiamente
-- dicha de la misma hacia la etapa "memory access".
-- FromInstMemory: En primer lugar, recibe la se�al de la memoria de instrucciones de la
-- PC para comenzar una nueva transmisi�n de informaci�n hacia la unidad de b�squeda de
-- la CPU (n�tese que el ensamblador no se encuentra involucrado en este proceso porque
-- jam�s requerir� leer un dato de la memoria de instrucciones para cumplir su tarea).
-- Luego carga en el bus de datos de la unidad de b�squeda (etapa "fetch") la informaci�n
-- recibida desde el bus de la memoria de instrucciones, para finalmente proceder a 
-- realizar la transmisi�n propiamente dicha de la misma hacia la unidad de b�squeda.


library TDA_1819;

LIBRARY IEEE;

USE std.textio.all;
use ieee.NUMERIC_STD.all;
USE IEEE.std_logic_1164.all; 




entity buses_admin is
	
	port (
		DataDataBusInCpu		: out std_logic_vector(31 downto 0);
		InstDataBusInCpu		: out std_logic_vector(31 downto 0);
		EnableInDataCpu			: out std_logic;
		EnableInInstCpu			: out std_logic;
		DataAddrBusMem			: out std_logic_vector(15 downto 0);
		DataDataBusInMem		: out std_logic_vector(31 downto 0);
		DataSizeBusMem			: out std_logic_vector(3 downto 0);
		DataCtrlBusMem			: out std_logic_vector(1 downto 0);	
		InstAddrBusMem			: out std_logic_vector(15 downto 0);
		InstDataBusInMem		: out std_logic_vector(31 downto 0);
		InstSizeBusMem			: out std_logic_vector(3 downto 0);
		InstCtrlBusMem			: out std_logic_vector(1 downto 0);
		EnableInDataMem			: out std_logic;
		EnableInInstMem			: out std_logic;
		DataAddrBusComp			: in  std_logic_vector(15 downto 0);
		DataDataBusOutComp		: in  std_logic_vector(31 downto 0);
		DataSizeBusComp			: in  std_logic_vector(3 downto 0);
		DataCtrlBusComp			: in  std_logic_vector(1 downto 0);
		InstAddrBusComp			: in  std_logic_vector(15 downto 0);
		InstDataBusOutComp		: in  std_logic_vector(31 downto 0);
		InstSizeBusComp			: in  std_logic_vector(3 downto 0);
		InstCtrlBusComp			: in  std_logic_vector(1 downto 0);
		DataDataBusOutMem		: in  std_logic_vector(31 downto 0);
		InstDataBusOutMem		: in  std_logic_vector(31 downto 0);
		DataAddrBusCpu			: in  std_logic_vector(15 downto 0);
		DataDataBusOutCpu		: in  std_logic_vector(31 downto 0);
		DataSizeBusCpu			: in  std_logic_vector(3 downto 0);
		DataCtrlBusCpu			: in  std_logic_vector(1 downto 0);
		InstAddrBusCpu			: in  std_logic_vector(15 downto 0);
		InstDataBusOutCpu		: in  std_logic_vector(31 downto 0);
		InstSizeBusCpu			: in  std_logic_vector(3 downto 0);
		InstCtrlBusCpu			: in  std_logic_vector(1 downto 0); 
		EnableCompToDataMem		: in  std_logic;
		EnableCompToInstMem		: in  std_logic;
		EnableCpuToDataMem		: in  std_logic;
		EnableCpuToInstMem		: in  std_logic;
		EnableDataMemToCpu		: in  std_logic;
		EnableInstMemToCpu		: in  std_logic);

end buses_admin;




architecture BUSES_ADMIN_ARCHITECTURE of buses_admin is


	
begin
	
	
	ToDataMemory: PROCESS
	
	VARIABLE First: BOOLEAN := true;
	
	BEGIN
		WAIT UNTIL (rising_edge(EnableCompToDataMem) OR rising_edge(EnableCpuToDataMem));
		if (First) then
			First := false;
			EnableInDataMem <= '0';
			WAIT FOR 1 ps;
		end if;
		if (EnableCompToDataMem = '1') then
			DataAddrBusMem <= DataAddrBusComp;
			DataDataBusInMem <= DataDataBusOutComp;
			DataSizeBusMem <= DataSizeBusComp;
			DataCtrlBusMem <= DataCtrlBusComp;
		else
			DataAddrBusMem <= DataAddrBusCpu;
			DataDataBusInMem <= DataDataBusOutCpu;
			DataSizeBusMem <= DataSizeBusCpu;
			DataCtrlBusMem <= DataCtrlBusCpu;
		end if;
		EnableInDataMem <= '1';
		WAIT FOR 1 ps;
		EnableInDataMem <= '0';
	END PROCESS ToDataMemory;
	
	
	ToInstMemory: PROCESS
	
	VARIABLE First: BOOLEAN := true;
	
	BEGIN
		WAIT UNTIL (rising_edge(EnableCompToInstMem) OR rising_edge(EnableCpuToInstMem));
		if (First) then
			First := false;
			EnableInInstMem <= '0';
			WAIT FOR 1 ps;
		end if;
		if (EnableCompToInstMem = '1') then
			InstAddrBusMem <= InstAddrBusComp;
			InstDataBusInMem <= InstDataBusOutComp;
			InstSizeBusMem <= InstSizeBusComp;
			InstCtrlBusMem <= InstCtrlBusComp;
		else 
			InstAddrBusMem <= InstAddrBusCpu;
			InstDataBusInMem <= InstDataBusOutCpu;
			InstSizeBusMem <= InstSizeBusCpu;
			InstCtrlBusMem <= InstCtrlBusCpu;
		end if;
		EnableInInstMem <= '1';
		WAIT FOR 1 ps;
		EnableInInstMem <= '0';
	END PROCESS ToInstMemory;	
	
	
	FromDataMemory: PROCESS
	
	VARIABLE First: BOOLEAN := true;
	
	BEGIN
		WAIT UNTIL rising_edge(EnableDataMemToCpu);
		DataDataBusInCpu <= DataDataBusOutMem;
		if (First) then
			First := false;
			EnableInDataCpu <= '0';
			WAIT FOR 1 ps;
		end if;
		EnableInDataCpu <= '1';
		WAIT FOR 1 ps;
		EnableInDataCpu <= '0';
	END PROCESS FromDataMemory;
	
	
	FromInstMemory: PROCESS
	
	VARIABLE First: BOOLEAN := true;
	
	BEGIN
		WAIT UNTIL rising_edge(EnableInstMemToCpu);
		InstDataBusInCpu <= InstDataBusOutMem;
		if (First) then
			First := false;
			EnableInInstCpu <= '0';
			WAIT FOR 1 ps;
		end if;
		EnableInInstCpu <= '1';
		WAIT FOR 1 ps;
		EnableInInstCpu <= '0';
	END PROCESS FromInstMemory;
	
	
end BUSES_ADMIN_ARCHITECTURE;





