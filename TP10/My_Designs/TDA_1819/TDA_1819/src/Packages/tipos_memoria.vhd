
-- Paquete "tipos_memoria":	
-- Descripci�n: Aqu� se define el tipo de datos necesario para declarar las se�ales
-- que representar�n las distintas secciones que constituyen la memoria principal 
-- de la PC: datos, instrucciones, subrutinas y pila. Cada posici�n del arreglo se 
-- corresponder�a con una direcci�n de memoria diferente (recordar que la m�nima 
-- unidad de memoria direccionable en la arquitectura implementada para la PC de 
-- este proyecto es de ocho bits).


LIBRARY IEEE;

USE std.textio.all;
use ieee.NUMERIC_STD.all;
USE IEEE.std_logic_1164.all; 


PACKAGE tipos_memoria is
		
	
	TYPE type_memory IS ARRAY (NATURAL RANGE <>) OF std_logic_vector(7 downto 0);	
		
		
END tipos_memoria;




PACKAGE BODY tipos_memoria is 
	
	
	
END tipos_memoria;


