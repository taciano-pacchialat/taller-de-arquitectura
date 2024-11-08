
-- Paquete "const_reloj":
-- Descripci�n: Aqu� se define el valor correspondiente al per�odo de reloj de la
-- CPU. Durante la primera mitad de cada ciclo la se�al de reloj adoptar� un valor
-- l�gico alto, mientras que durante la segunda mitad tendr� un valor bajo. Se
-- recomienda no intentar disminuir manualmente el valor aqu� determinado ya que en
-- tal caso la CPU podr�a presentar un comportamiento an�malo.


LIBRARY IEEE;

USE std.textio.all;
USE IEEE.std_logic_1164.all; 


PACKAGE const_reloj is
	
	
	CONSTANT PERIODO:	time := 50 ns;
	

END const_reloj;




PACKAGE BODY const_reloj is 
	

END const_reloj;


