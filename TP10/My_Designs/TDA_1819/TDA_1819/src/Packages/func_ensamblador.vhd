
-- Paquete "func_ensamblador":  
-- Descripci�n:	Aqu� se definen las funciones necesarias para que el ensamblador
-- pueda comprobar errores de sintaxis por parte del usuario/programador durante
-- la asignaci�n de nombres y valores a las variables o bien en la definici�n de 
-- operandos inmediatos para las instrucciones del programa. Este paquete incluye 
-- validaciones para cualquier clase de valores, desde cadenas de caracteres ASCII
-- hasta d�gitos decimales, binarios y hexadecimales, entre otros.
-- Procedimientos y funciones:
-- isValidChar(): Retorna verdadero si el caracter recibido como par�metro es 
-- alfanum�rico o un gui�n bajo, y falso en caso contrario. Esta funci�n resulta 
-- particularmente �til para que el ensamblador pueda comprobar la correcta 
-- definici�n de los nombres para las variables y etiquetas del programa por parte 
-- del usuario.
-- isLetterOrNumber(): Retorna verdadero si el caracter recibido como par�metro es
-- alfanum�rico, y falso en caso contrario.	Esta funci�n solamente es utilizada en 
-- este proyecto para ser invocada por la funci�n anterior, isValidChar().
-- isLetter(): Retorna verdadero si el caracter recibido como par�metro es 
-- alfab�tico, y falso en caso contrario. Esta funci�n resulta particularmente 
-- �til para que el ensamblador pueda comprobar que el primer caracter del nombre 
-- utilizado por el usuario para definir tanto una variable como una etiqueta 
-- siempre sea un caracter alfab�tico y nunca uno num�rico.
-- isNumber(): Retorna verdadero si el caracter recibido como par�metro es 
-- num�rico (sistema decimal), y falso en caso contrario. Esta funci�n resulta
-- particularmente �til principalmente para que el ensamblador pueda determinar si 
-- los valores de las variables y operandos inmediatos definidos por el usuario en 
-- el sistema decimal se encuentran correctamente declarados.
-- isMinus(): Retorna verdadero si el caracter recibido como par�metro corresponde
-- al signo menos, y falso en caso contrario. Esta funci�n resulta particularmente 
-- �til para que el ensamblador pueda comprobar si el valor definido por el usuario 
-- para la variable u operando inmediato es negativo y, en caso de no serlo, si se 
-- encuentra correctamente declarado.
-- isNumberOrMinus(): Retorna verdadero si el caracter recibido como par�metro
-- es num�rico o un signo menos, y falso en caso contrario. Esta funci�n resulta
-- particularmente �til para que el ensamblador pueda comprobar si el primer 
-- caracter del valor asignado por el usuario a una variable u operando inmediato 
-- se encuentra correctamente declarado (la verificaci�n del resto de los d�gitos 
-- variar� en funci�n del sistema de numeraci�n utilizado por el usuario para 
-- representar el valor).
-- isAscii(): Retorna verdadero si el caracter recibido como par�metro pertenece
-- al conjunto de caracteres ASCII soportados por el ensamblador, y falso en caso
-- contrario. Esta funci�n resulta particularmente �til para que el ensamblador 
-- pueda comprobar la validez de cada uno de los caracteres de todas las cadenas 
-- ASCII asignadas por el usuario a las variables del programa.
-- isHexadecimal(): Retorna verdadero si el caracter recibido como par�metro
-- corresponde a un d�gito hexadecimal, y falso en caso contrario. Esta funci�n
-- resulta particularmente �til para que el ensamblador pueda comprobar la validez 
-- de cada uno de los d�gitos de todos los valores representados por el usuario 
-- en el sistema de representaci�n hexadecimal asignados a las distintas variables 
-- y operandos inmediatos del programa.
-- isBinary(): Retorna verdadero si el caracter recibido como par�metro 
-- corresponde a un d�gito binario, y falso en caso contrario. Esta funci�n 
-- resulta particularmente �til	para que el ensamblador pueda comprobar la validez
-- de cada uno de los d�gitos de todos los valores representados por el usuario
-- en el sistema de representaci�n binario asignados a las distintas variables y
-- operandos inmediatos del programa.
-- trim(): Recibe como par�metro una cadena de caracteres y la retorna con todos 
-- los espacios en blanco ubicados al final de ella eliminados. Esta funci�n
-- resulta particularmente �til para que todas las cadenas de caracteres 
-- presentadas al usuario en la consola del simulador (nombres, mensajes, etc.) 
-- tengan un formato adecuado y f�cil de leer, es decir, sin poseer espacios 
-- en blanco innecesarios que dificulten su lectura.


library TDA_1819;
use TDA_1819.const_ascii.all;

LIBRARY IEEE;

USE std.textio.all;
USE IEEE.std_logic_1164.all; 


PACKAGE func_ensamblador is
	
	
	function isValidChar(constant c: in character) return boolean;
		
	function isLetterOrNumber(constant c: in character) return boolean;
	
	function isLetter(constant c: in character) return boolean;
	
	function isNumber(constant c: in character) return boolean;
	
	function isMinus(constant c: in character) return boolean;
	
	function isNumberOrMinus(constant c: in character) return boolean; 
	
	function isAscii(constant c: in character) return integer; 
	
	function isHexadecimal(constant c: in character) return boolean;
	
	function isBinary(constant c: in character) return boolean;
	
	function trim(constant s: in string) return string;
	
	
END func_ensamblador;




PACKAGE BODY func_ensamblador is  
	
	
	function isValidChar(constant c: in character) return boolean is
	begin
		return (isLetterOrNumber(c) or (c = '_'));
	end isValidChar;
	
	function isLetterOrNumber(constant c: in character) return boolean is
	begin
		return (isLetter(c) or isNumber(c));
	end isLetterOrNumber;
	
	function isLetter(constant c: in character) return boolean is
	begin
		case c is
			when 'a' to 'z' | 'A' to 'Z' =>
				return true;
			when others =>
				return false;
		end case;
	end isLetter;
	
	function isNumber(constant c: in character) return boolean is
	begin
		case c is
			when '0' to '9' =>
				return true;
			when others =>
				return false;
		end case;
	end isNumber;
	
	function isMinus(constant c: in character) return boolean is
	begin
		return (c = '-');
	end isMinus;
	
	function isNumberOrMinus(constant c: in character) return boolean is
	begin
		return (isNumber(c) or isMinus(c));
	end isNumberOrMinus; 
	
	function isAscii(constant c: in character) return integer is
	begin
		for i in CARACTERES'range loop
			if (c = CARACTERES(i)) then
				return i;
			end if;
		end loop;
		return -1;
	end isAscii;
	
	function isHexadecimal(constant c: in character) return boolean is
	begin
		case c is
			when '0' to '9' =>
				return true;
			when 'A' to 'F' =>
				return true;
			when others =>
				return false;
		end case;
	end isHexadecimal;	
	
	function isBinary(constant c: in character) return boolean is
	begin
		case c is
			when '0' to '1' =>
				return true;
			when others =>
				return false;
		end case;
	end isBinary;
	
	function trim(constant s: in string) return string is
	
	function trimAux(constant s: in string; constant indice: in integer) return string is
	
	variable cadena: STRING(1 to indice);
	
	begin
		cadena(1 to indice) := s(1 to indice);
		return cadena;
	end trimAux; 
	
	variable indice: INTEGER := -1;
	
	begin
		for i in s'range loop
			if (s(i) = ' ') then
				indice := i - 1;
				exit;
			end if;
		end loop;
		if (indice /= -1) then
			return trimAux(s, indice);
		else
			return s;
		end if;
	end trim;
	
	
END func_ensamblador;


