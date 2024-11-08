
-- Entidad "memory_access":
-- Descripci�n: Aqu� se define la etapa de acceso a memoria de la segmentaci�n del 
-- procesador, la cual recibe del banco de registros internos del pipeline toda la 
-- informaci�n originada en la etapa "decode" necesaria para llevar a cabo dicha 
-- operaci�n de acceso: tipo de acceso (nulo, a memoria o a un perif�rico de E/S), 
-- modo de acceso (lectura o escritura), direcci�n de memoria o puerto del perif�rico
-- a partir de la cual deber� realizarse el acceso, ya sea para leer o escribir en �l, 
-- tama�o del operando involucrado en la operaci�n (8, 16 � 32 bits), y finalmente el 
-- dato propiamente dicho (en caso de tratarse de una escritura). Con esta informaci�n,
-- procede a acceder a la memoria de datos de la PC o al perif�rico de E/S seg�n 
-- corresponda y obtiene o actualiza el valor requerido por la instrucci�n actual.
-- Finalmente, s�lo en caso de tratarse de una operaci�n de lectura, esta etapa
-- transmitir� el dato le�do al banco de registros internos del pipeline para que �ste
-- a su vez lo haga llegar a la etapa "writeback" a fin de que �sta lo utilice para
-- actualizar el banco de registros de la CPU. Obviamente, si la instrucci�n actual
-- no requiere acceder a memoria (tipo de acceso nulo), entonces no se llevar� a cabo 
-- ning�n tipo de acci�n en esta etapa.
-- Procesos:
-- Main: En primer lugar, recibe la se�al del administrador de la CPU para comenzar la
-- etapa de acceso a memoria de una nueva instrucci�n. Aqu� no se lleva a cabo ning�n
-- tipo de detecci�n de atascos en el cauce ya que todos los detectores implementados
-- tanto en las etapas anteriores del pipeline como en el banco de registros internos
-- de la segmentaci�n garantizan que no se realizar�n accesos indebidos a memoria en
-- caso de que el cauce se encuentre atascado debido a alguna dependencia estructural,
-- de datos o de control. Por lo tanto, este proceso se encarga simplemente de, en la
-- segunda mitad del ciclo de reloj, comprobar el tipo y el modo de acceso para 
-- determinar, en primer lugar, si efectivamente debe realizarse alguna acci�n en esta
-- etapa del pipeline y luego, en caso afirmativo, a qu� dispositivo necesita acceder:
-- memoria de datos o un perif�rico de E/S, transmitiendo a trav�s del bus de datos de 
-- la PC el dato a escribir e impartiendo la orden de escritura mediante el bus de 
-- control (si se trata de una escritura); o bien emitiendo la orden de lectura	a 
-- trav�s del bus de control y recibiendo en el bus de datos el dato le�do (si se trata
-- de una lectura). N�tese que en ambos casos ser� necesario escribir en el bus de 
-- direcciones la direcci�n en memoria de datos o el puerto del perif�rico de E/S a 
-- partir del cual se efectuar� el acceso. Por �ltimo, s�lo si se hubiera tratado de 
-- una operaci�n de lectura, el dato le�do ser� transmitido al banco de registros 
-- internos del pipeline ya que indudablemente deber� ser utilizado para actualizar el 
-- banco de registros de la CPU, de lo cual se ocupar� la �ltima etapa de la 
-- segmentaci�n: "writeback".


library TDA_1819;	
use TDA_1819.const_buses.all;
use TDA_1819.const_cpu.all;
use TDA_1819.tipos_cpu.all; 


LIBRARY IEEE;

USE std.textio.all;
use ieee.NUMERIC_STD.all;
USE IEEE.std_logic_1164.all; 




entity memory_access is
	
	port (
		DataAddrBusCpu		: out std_logic_vector(15 downto 0);
		DataDataBusOutCpu	: out std_logic_vector(31 downto 0);
		DataSizeBusCpu		: out std_logic_vector(3 downto 0);
		DataCtrlBusCpu		: out std_logic_vector(1 downto 0);
		EnableCpuToDataMem	: out std_logic;
		DataMAtoWB			: out std_logic_vector(31 downto 0);
		RecInMA				: in  memaccess_record;
		DataDataBusInCpu	: in  std_logic_vector(31 downto 0);
		EnableInDataCpu		: in  std_logic;
		EnableMA			: in  std_logic);

end memory_access;




architecture MEMORY_ACCESS_ARCHITECTURE of memory_access is


	
begin
	
	
	Main: PROCESS  
	
	VARIABLE First: BOOLEAN := true;
	VARIABLE Mode: INTEGER;
	VARIABLE Source: INTEGER;
	VARIABLE SizeBits: INTEGER;
	
	BEGIN 
		WAIT UNTIL rising_edge(EnableMA);
		if (First) then
			First := false;
			EnableCpuToDataMem <= '0';
			WAIT FOR 1 ns;
		end if;
		WAIT UNTIL falling_edge(EnableMA);
		Mode := to_integer(unsigned(RecInMA.mode));
		CASE Mode IS
			WHEN MEM_NULL =>
				NULL;
			WHEN MEM_MEM =>	
				SizeBits := to_integer(unsigned(RecInMA.datasize))*8;
				DataAddrBusCpu <= RecInMA.address;
				DataSizeBusCpu <= RecInMA.datasize;
				DataDataBusOutCpu <= "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ"; 
				if (RecInMA.read = '1') then
					DataCtrlBusCpu <= READ_MEMORY;
					EnableCpuToDataMem <= '1';
					WAIT FOR 1 ns;
					EnableCpuToDataMem <= '0';
					WAIT FOR 1 ns;
					--WAIT UNTIL rising_edge(EnableInDataCpu);
					for i in 31 downto SizeBits loop
						DataMAtoWB(i) <= 'Z';
					end loop;
					for i in SizeBits-1 downto 0 loop
						DataMAtoWB(i) <= DataDataBusInCpu(i);
					end loop;
				elsif (RecInMA.write = '1') then
					Source := to_integer(unsigned(RecInMA.source));
					if (Source = MEM_ID) then
						for i in SizeBits-1 downto 0 loop
							DataDataBusOutCpu(i) <= RecInMA.data.decode(i);
						end loop;
					elsif (Source = MEM_EX) then
						for i in SizeBits-1 downto 0 loop
							DataDataBusOutCpu(i) <= RecInMA.data.execute(i);
						end loop;
					end if;
					DataCtrlBusCpu <= WRITE_MEMORY;
					EnableCpuToDataMem <= '1';
					WAIT FOR 1 ns;
					EnableCpuToDataMem <= '0';
					WAIT FOR 1 ns;
				else
					report "Error: el modo de acceso a memoria no es v�lido"
					severity FAILURE;
				end if;
			WHEN MEM_PER =>
				NULL;
			WHEN OTHERS =>
				report "Error: la configuraci�n de la etapa de acceso a memoria no es v�lida"
				severity FAILURE;
		END CASE;
	END PROCESS Main; 
	
	
end MEMORY_ACCESS_ARCHITECTURE;





