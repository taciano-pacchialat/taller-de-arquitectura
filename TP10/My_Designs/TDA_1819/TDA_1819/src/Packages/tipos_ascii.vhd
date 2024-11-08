
-- Paquete "tipos_ascii":
-- Descripci�n: Aqu� se definen los tipos de datos necesarios para declarar las
-- constantes que contienen tanto los caracteres que pueden ser interpretados por el 
-- ensamblador como la representaci�n en c�digo m�quina (sistema binario) para cada uno
-- de ellos (paquete "const_ascii"). 


LIBRARY IEEE;
USE std.textio.all;	
USE IEEE.std_logic_1164.all; 


PACKAGE tipos_ascii is
	
	
	TYPE cod_caracteres_array IS ARRAY (POSITIVE RANGE <>) OF std_logic_vector(7 downto 0);
	TYPE caracteres_array IS ARRAY (POSITIVE RANGE <>) OF CHARACTER;
	
	
END tipos_ascii;




PACKAGE BODY tipos_ascii is 
	

END tipos_ascii;


