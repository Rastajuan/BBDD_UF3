/*Tuve que insertar esta línea de código porque de repente no podía crear funciones*/
SET GLOBAL log_bin_trust_function_creators = 1;

2.1 Crear una función que retorne el valor de la hipotenusa de un triángulo a partir de los valores de sus lados.

/*CREACION FUNCION*/
DELIMITER //
DROP FUNCTION IF EXISTS f_valorHipotenusa;
CREATE FUNCTION f_valorHipotenusa
#Parametros
(cateto1 DECIMAL(4,2), 
cateto2 DECIMAL(4,2)
)
#Retorno
RETURNS DECIMAL(6,2)
#Cuerpo función
BEGIN
DECLARE hipotenusa DECIMAL(6,2);
SET hipotenusa=SQRT(SQUARE(cateto1) + SQUARE(cateto2));
RETURN hipotenusa;
END
//
DELIMITER ;

/*LLAMADA FUNCION*/
SELECT f_valorHipotenusa(2,4);


De la forma anterior me daba el error que no exisitia la funcion SQUARE en la biblioteca, lo sustituyo por algo más rudimentario

/*CREACION FUNCION*/
DELIMITER //
DROP FUNCTION IF EXISTS f_valorHipotenusa;
CREATE FUNCTION f_valorHipotenusa
(cateto1 DECIMAL(4,2), 
cateto2 DECIMAL(4,2)
)
RETURNS DECIMAL(6,2)
BEGIN
DECLARE hipotenusa DECIMAL(6,2);
SET hipotenusa=SQRT((cateto1*cateto1) + (cateto2*cateto2));
RETURN hipotenusa;
END
//
DELIMITER ;

/*LLAMADA FUNCION*/
SELECT f_valorHipotenusa(2,4);


No me había gustado la forma anterior y, después de mucho buscar, encontré la función POW() que si funciona en mysql

DELIMITER //
DROP FUNCTION IF EXISTS f_valorHipotenusa;
CREATE FUNCTION f_valorHipotenusa
(cateto1 DECIMAL(4,2), 
cateto2 DECIMAL(4,2)
)
RETURNS DECIMAL(6,2)
BEGIN
DECLARE hipotenusa DECIMAL(6,2);
SET hipotenusa = SQRT(POW(cateto1,2) + POW(cateto2,2));
RETURN hipotenusa;
END
//
DELIMITER ;

(=============================================================================================================================================================================)

2.2.1. Crear un procedimiento almacenado llamado insertar_departamentos_tunombre que inserte un nuevo departamento con los datos (nombre y planta) introducidos como parámetros

/*CREACION PROCEDIMIENTO*/
DELIMITER //
DROP PROCEDURE IF EXISTS insertar_departamentos_Juan;
CREATE PROCEDURE insertar_departamentos_Juan (IN valorNombre VARCHAR(20), IN valorPlanta INT)
BEGIN
INSERT INTO empresa.departamento(nombre,planta)
VALUES (valorNombre,valorPlanta);
END
//
DELIMITER ;

/*LLAMADA PROCEDIMIENTO*/
CALL insertar_departamentos_Juan('Playa y piscina', 3);

(=============================================================================================================================================================================)

2.2.2. Crear un procedimiento almacenado llamado empleados_sueldo_tunombre que seleccione los nombres, apellidos y sueldos de los empleados.

/*CREACION PROCEDIMIENTO*/
DELIMITER //
DROP PROCEDURE IF EXISTS empleados_sueldo_Juan;
CREATE PROCEDURE empleados_sueldo_Juan()
BEGIN
SELECT nombre, apellidos, sueldo FROM empleado;
END
//
DELIMITER ;

/*LLAMADA PROCEDIMIENTO>*/
CALL empleados_sueldo_Juan;

(=============================================================================================================================================================================)

2.2.3. Crear un procedimiento almacenado llamado empleados_hijos_tunombre que seleccione los nombres, apellidos y cantidad de hijos de los empleados con hijos.

/*CREACION PROCEDIMIENTO*/
DELIMITER //
DROP PROCEDURE IF EXISTS empleados_hijos_Juan;
CREATE PROCEDURE empleados_hijos_Juan()
BEGIN
SELECT nombre, apellidos, cantidadhijos FROM empleado
WHERE cantidadhijos>0;
END
//
DELIMITER ;

/*LLAMADA PROCEDIMIENTO*/
CALL empleados_hijos_Juan;

(=============================================================================================================================================================================)

2.2.4. Crear un procedimiento almacenado llamado empleados_mayor_sueldo_tunombre que seleccione los nombres, apellidos y sueldos de los empleados que tengan un sueldo superior o igual al enviado como parámetro.

/*CREACION PROCEDIMIENTO*/
DELIMITER //
DROP PROCEDURE IF EXISTS empleados_mayor_sueldo_Juan;
CREATE PROCEDURE empleados_mayor_sueldo_Juan(IN sueldoComparar INT)
BEGIN
SELECT nombre, apellidos, sueldo FROM empleado
WHERE sueldo>=sueldoComparar;
END
//
DELIMITER ;

/*LLAMADA PROCEDIMIENTO*/
SET @sueldoComparar=1000;
CALL empleados_mayor_sueldo_Juan(@sueldoComparar);

(=============================================================================================================================================================================)

2.2.5. Crear una tabla llamada "Indefinido" con los siguientes campos: documento, nombre, apellido. Crear otra tabla llamada "Temporal" con los siguientes campos: documento, nombre, apellido.

/*CREACION TABLA 'indefinido'*/
DROP TABLE IF EXISTS indefinido;
CREATE TABLE indefinido
(
documento VARCHAR(45),
nombre VARCHAR(45),
apellido VARCHAR(45)
);

/*CREACION TABLA 'temporal'*/
DROP TABLE IF EXISTS temporal;
CREATE TABLE temporal
(
documento VARCHAR(45),
nombre VARCHAR(45),
apellido VARCHAR(45)
);

/*CREACION TABLAS CON SP*/
DELIMITER //
DROP TABLE IF EXISTS indefinido;
DROP TABLE IF EXISTS temporal;
DROP PROCEDURE IF EXISTS crear_tablas_indefinido_y_temporal;
CREATE PROCEDURE crear_tablas_indefinido_y_temporal()
BEGIN
	CREATE TABLE indefinido(
		documento VARCHAR(45),
		nombre VARCHAR(45),
		apellido VARCHAR(45)
		);
	CREATE TABLE temporal(
		documento VARCHAR(45),
		nombre VARCHAR(45),
		apellido VARCHAR(45)
		);
END
//
DELIMITER ;

/*LLAMADA PROCEDIMIENTO*/
CALL crear_tablas_indefinido_y_temporal;

(=============================================================================================================================================================================)

2.2.6 Crear un procedimiento almacenado llamado clasificar_empleados_tunombre que inserte a la tabla "Indefinidos" a todos los empleados que cobren más de 1000 €, 
y que inserte a la tabla "Temporales" a todos los empleados que cobren menos o igual de 1000 €.

/*CREACION PROCEDIMIENTO*/
DELIMITER //
DROP PROCEDURE IF EXISTS clasificar_empleados_Juan;
CREATE PROCEDURE clasificar_empleados_Juan()
BEGIN
INSERT INTO indefinido(documento,nombre,apellido) 
SELECT documento,nombre,apellidos
FROM empleado
WHERE sueldo > 1000;
INSERT INTO temporal(documento,nombre,apellido) 
SELECT documento,nombre,apellidos
FROM empleado
WHERE sueldo <= 1000;
END
//
DELIMITER ;

/*LLAMADA PROCEDIMIENTO*/
CALL clasificar_empleados_Juan;


(=============================================================================================================================================================================)

2.2.7. Crear un procedimiento que elimine un departamento, verificando que exista y que no tenga empleados. El procedimiento recibirá como parámetro de entrada el nombre del departamento. 
En caso de no existir, o de tener empleados, el procedimiento ha de informar de este hecho con sus respectivos mensajes:
El departamento no existe o está mal escrito. 
El departamento tiene empleados y no se puede borrar.

/*CREACION PROCEDIMIENTO*/
DELIMITER //
DROP PROCEDURE IF EXISTS eliminar_departamento;
CREATE PROCEDURE eliminar_departamento(IN nom_departamento VARCHAR(20))
BEGIN
DECLARE nombre_Departamento VARCHAR(20);
DECLARE numero_Departamento INT;
DECLARE hay_empleados INT;
/*Asignamos el departamento que coincide con el nombre de la entrada*/
SET nombre_Departamento:=(SELECT departamento.nombre FROM departamento WHERE departamento.nombre=nom_departamento); 
/*Asignamos con una subconsulta si existe algun empleado en ese dto. LIMIT 1 limita solo a un resultado ya que puede haber más de 1 y daria error en la subconsulta*/
SET hay_empleados:=
	(
	SELECT COUNT(empleado.Documento) FROM empleado
    INNER JOIN departamento ON empleado.num_dpt = departamento.num_dpt
    WHERE departamento.nombre=nom_departamento LIMIT 1
    );
/*Si el dto no existe o no está bien escrito lanzamos error*/
IF(nombre_Departamento IS NULL) 
THEN SELECT 'El departamento no existe o está mal escrito.' AS 'HA HABIDO UN ERROR: '; 
/*Si hay empleados, lanzamos error*/
ELSEIF(hay_empleados > 0)
THEN SELECT 'El departamento tiene empleados y no se puede borrar.' AS 'HA HABIDO UN ERROR: ';
/*Eliminación del departamento si los anteriores parámetros no se cumplen*/
ELSE
	DELETE FROM departamento WHERE departamento.nombre=nom_departamento;
	SELECT 'Departamento eliminado' AS 'Resultado del procedimiento';
END IF;
END
//
DELIMITER ;

/*LLAMADA PROCEDIMIENTO*/ 
CALL eliminar_departamento('Playa y piscina'); #Sin empleados
CALL eliminar_departamento('Contabilidad'); #Con empleados (dará error)
CALL eliminar_departamento('CContabilidadD'); #Mal escrito (dará error)

(=============================================================================================================================================================================)
