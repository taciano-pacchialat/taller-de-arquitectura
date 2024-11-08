
-- Paquete "const_memoria":
-- Descripci�n: Aqu� se define la direcci�n inicial para cada una de las distintas
-- secciones que constituyen la memoria principal de la PC: datos, instrucciones,
-- subrutinas y pila. Se reserva una porci�n de memoria al comienzo de la misma para 
-- operaciones privilegiadas de la CPU/sistema operativo, por lo cual el usuario bajo 
-- ning�n concepto podr� acceder a ella durante la ejecuci�n del programa. �stas 
-- definiciones son �tiles para que la unidad de gesti�n de memoria pueda comprobar en
-- cada intento de acceso por parte de la CPU si la direcci�n a acceder pertenece
-- efectivamente a la secci�n de la memoria a la cual el procesador deber�a estar 
-- accediendo. Por ejemplo, durante la ejecuci�n del programa principal la CPU s�lo 
-- deber�a poder acceder a la memoria de instrucciones durante la etapa de b�squeda 
-- ("fetch") y a la de datos durante la etapa de acceso a memoria ("memory access"), a
-- menos que se est� ejecutando una instrucci�n de manejo de la pila, en cuyo caso 
-- la etapa de acceso a memoria s�lo podr� acceder a la secci�n de pila de la memoria.  


LIBRARY IEEE;

USE std.textio.all;
use ieee.NUMERIC_STD.all;
USE IEEE.std_logic_1164.all; 


PACKAGE const_memoria is
		
	
	CONSTANT MEMORY_BEGIN:	INTEGER := 16#0000#;
	CONSTANT DATA_BEGIN:	INTEGER := 16#1000#;
	CONSTANT INST_BEGIN:	INTEGER := 16#2000#;
	CONSTANT SUBR_BEGIN:	INTEGER := 16#3000#;
	CONSTANT STACK_BEGIN:	INTEGER := 16#7000#;
	CONSTANT BASE_POINTER:	INTEGER := 16#8000#;
	CONSTANT MEMORY_END:	INTEGER := 16#8000#;	
		
		
END const_memoria;




PACKAGE BODY const_memoria is 
	
	
	
END const_memoria;


