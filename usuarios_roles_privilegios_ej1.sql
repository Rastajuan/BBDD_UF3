1.1.Crear un rol nuevo llamado BOSSTuNombre que actúe de administrador sobre todo el motor de la base de datos.

/*CREACION ROLE*/
CREATE ROLE IF NOT EXISTS 'BOSSJuan';

/*ASIGNACION PRIVILEGIOS*/
GRANT ALL ON *.* TO 'BOSSJuan' WITH GRANT OPTION;

/*COMPROBACION PRIVILEGIOS*/
SHOW GRANTS FOR 'BOSSJuan';

(=================================================================================================================)

1.2.Crear un nuevo usuario llamado THEBOSSTuNombre asociado al rol BOSSTuNombre.

/*CREACION USUARIO*/
CREATE USER IF NOT EXISTS 'THEBOSSJuan'
IDENTIFIED BY '1234'
DEFAULT ROLE BOSSJuan; 

/*VERIFICACION CREACION USUARIO*/
SELECT USER FROM mysql.user;

/*VERIFIFICACION PERMISOS*/
SHOW GRANTS FOR 'THEBOSSJuan';
SELECT user, host FROM mysql.server;

(=================================================================================================================)

1.3.Acceder por consola al nuevo usuario THEBOSSTuNombre 

/*CAMBIO USUARIO*/
SYSTEM MYSQL -u THEBOSSJuan -p 

/*VERIFIFICACION USUARIO ACTUAL*/
SELECT CURRENT_USER;

/*COMPROBACION PRIVILEGIOS*/
SHOW GRANTS; #Privilegios usuario actual
SHOW GRANTS FOR BOSSJuan; #Privilegios por nombre usuario

(=================================================================================================================)

1.4.Creación de una base de datos llamada INSTITUTO

CREATE DATABASE IF NOT EXISTS instituto;

(=================================================================================================================)

1.5.Creación tablas 'alumnos', 'aulas' y 'modulos'

/*CREACION TABLA alumnos*/
CREATE TABLE alumnos(
clave_alumno INT UNSIGNED PRIMARY KEY NOT NULL,
nombre VARCHAR(45),
apellido1 VARCHAR(45),
edad INT UNSIGNED,
curso_actual INT UNSIGNED);

/*CREACION TABLA aulas*/
CREATE TABLE aulas(
numero_aula INT UNSIGNED PRIMARY KEY NOT NULL,
capacidad INT UNSIGNED);

/*CREACION TABLA modulos*/
CREATE TABLE modulos(
clave_modulo INT UNSIGNED PRIMARY KEY NOT NULL,
curso INT UNSIGNED,
descripcion VARCHAR(200));

(=================================================================================================================)

1.6.Ejecutar comando DESCRIBE para verificar la estructura de cada tabla

/*DESCRIBE 'alumnos'*/
DESCRIBE alumnos;

/*DESCRIBE 'aulas'*/
DESCRIBE aulas;

/*DESCRIBE 'modulos'*/
DESCRIBE modulos;

(=================================================================================================================)

1.7.Renombrar la tabla MODULOS a ASIGNATURAS

ALTER TABLE modulos
RENAME asignaturas;

(=================================================================================================================)

1.8.Añadir un nuevo campo a la tabla ALUMNOS llamado apellido2

ALTER TABLE alumnos	
ADD apellido2 VARCHAR(45);

(=================================================================================================================)

1.9.Añadir un nuevo campo a la tabla ASIGNATURAS llamada nombre_professor

ALTER TABLE asignaturas
ADD nombre_professor VARCHAR(45);

(=================================================================================================================)

1.10.Insertar en cada tabla 5 registros.

/*INSERCION REGISTROS TABLA alumnos*/
INSERT INTO alumnos(clave_alumno, nombre, apellido1, apellido2, edad, curso_actual)
VALUES
(1, 'Juan', 'Bello', 'Fernandez', 50, 1),
(2, 'Maria', 'Gonzalez', 'Gutierrez', 24, 1),
(3, 'Luis', 'Piedrahita', 'Asensio', 32, 2),
(4, 'Cristina', 'Almeida', 'Martinez', 29, 2),
(5, 'Sigmund', 'Freud', 'Garcia', 35, 1);

/*INSERCION REGISTROS TABLA asignaturas*/
INSERT INTO asignaturas(clave_modulo, curso, descripcion, nombre_professor)
VALUES
(204, 1, 'Base de datos', 'Xavier'),
(306, 1, 'Lenguaje de Marcas', 'Javier'),
(165, 2, 'FrontEnd e Interfaces', 'Gonzalo'),
(250, 2, 'BackEnd y JS', 'Laia'),
(89, 1, 'Sistemas informáticos', 'Pilar' );


/*INSERCION REGISTROS TABLA aulas*/
INSERT INTO aulas(numero_aula, capacidad)
VALUES
(100, 30),
(200, 35),
(300, 28),
(400, 36),
(500, 29);

(=================================================================================================================)

1.11.Realizar alguna consulta SELECT sobre cada una de las tablas creadas.

/*Consultas tablas 'alumnos'*/
SELECT clave_alumno, nombre FROM alumnos
WHERE edad>=30;

SELECT nombre, apellido1 curso_actual FROM alumnos
WHERE apellido1 LIKE '%a%' OR apellido2="Fernandez";

SELECT nombre, apellido1, apellido2 FROM alumnos
ORDER BY edad DESC;

/*Consultas tabla 'asignaturas'*/
SELECT clave_modulo, descripcion FROM asignaturas
WHERE clave_modulo>100 OR clave_modulo<300
ORDER BY clave_modulo;

SELECT COUNT(clave_modulo) AS TotalModulos, 
MIN(clave_modulo) AS CodigoMenor, 
MAX(clave_modulo) AS CodigoMayor
FROM asignaturas;
 
/*Consultas tabla 'aulas'*/
SELECT COUNT(*) AS NumeroDeAulas,
MIN(capacidad) AS MenorCapacidad,
MAX(capacidad) AS MayorCapacidad,
SUM(capacidad) AS TotalCapacidad,
ROUND(AVG(capacidad),2) AS CapacidaMedia
FROM aulas;

(=================================================================================================================)

1.12 Añadir diversos usuarios con perfiles de acceso diferentes y dar privilegios

1.12.1 Sólo acceso local: 'userlocalJuan'

/*CREACION USUARIO*/
CREATE USER IF NOT EXISTS userlocalJuan@localhost
IDENTIFIED BY '1234';

/*ASIGNACION TODOS LOS PERMISOS*/
GRANT ALL ON *.* TO userlocalJuan@localhost;

(=================================================================================================================)

1.12.1.1 Comprobaciones usuario 'userlocalJuan'. Todos los permisos.
/*Cambio a usuario 'userlocalJuan'*/
SYSTEM MYSQL -u userlocalJuan -p;

/*Comprobación cambio usuario*/
SELECT CURRENT_USER;

/*COMPROBACION SELECT*/
SELECT * FROM alumnos;
SELECT * FROM asignaturas;
SELECT * FROM aulas;

/*COMPROBACION INSERT*/
/*Tabla 'alumnos'*/
INSERT INTO alumnos(clave_alumno,nombre,apellido1,apellido2,edad,curso_actual)
VALUES
(6,'Alicia','Gutierrez','Cava', 22, 1);

/*Tabla 'asignaturas'*/
INSERT INTO asignaturas(clave_modulo,curso,descripcion,nombre_professor)
VALUES
(450, 1,'Formación y Orientación Laboral', 'Pilar');

/*Tabla 'aulas'*/
INSERT INTO aulas(numero_aula, capacidad)
VALUES
(600, 35);

/*COMPROBACION UPDATE*/
/*Tabla 'alumnos'*/
UPDATE alumnos
SET apellido1='Colmenar'
WHERE apellido1='Gonzalez';

/*Tabla 'asignaturas'*/
UPDATE asignaturas
SET clave_modulo=90
WHERE clave_modulo=89;

/*Tabla 'aulas'*/
UPDATE aulas
SET numero_aula=150, capacidad=25
WHERE numero_aula=100;

/*COMPROBACION DELETE*/
/*Tabla 'alumnos'*/
DELETE FROM alumnos
WHERE clave_alumno=6;

/*Tabla 'asignaturas'*/
DELETE FROM asignaturas
WHERE nombre_professor='Pilar';

/*Tabla 'aulas'*/
DELETE FROM aulas
WHERE capacidad=25;

/*COMPROBACION ALTER TABLE*/
/*Tabla 'alumnos'*/
ALTER TABLE alumnos
MODIFY nombre VARCHAR(45) NOT NULL;

/*Tabla 'asignaturas'*/
ALTER TABLE asignaturas 
ADD email_profesor VARCHAR(45) UNIQUE;

/*Tabla 'aulas'*/
ALTER TABLE aulas 
ADD planta_edificio VARCHAR(20) AFTER numero_aula;

(=================================================================================================================)

1.12.2 Sólo acceso local: localTuNombre. Puede consultar todas las tablas y modificar la tabla ‘ALUMNOS’ y 
‘ASIGNATURAS’ menos los campos ‘edad’, ‘curso_actual’ y ‘descripcion’.

/*CREACION USUARIO*/
CREATE USER IF NOT EXISTS 'localJuan'@'localhost'
IDENTIFIED BY '1234';

/*COMPROBACION CREACION USUARIO*/
SELECT user FROM mysql.user;

/*ASIGNACION PERMISOS*/
/*Consultar todas las tablas*/
GRANT SELECT ON instituto.* TO localJuan@localhost;

/*Tabla 'alumnos': todos los campos menos 'edad' y 'curso_actual'*/
GRANT UPDATE (clave_alumno,nombre,apellido1,apellido2,escuela_anterior) 
ON instituto.alumnos
TO localJuan@localhost;

/*Tabla 'asignaturas': todos los campos menos 'descripcion'*/
GRANT UPDATE (clave_modulo,curso,nombre_professor,email_profesor) 
ON instituto.asignaturas
TO localJuan@localhost;

/*COMPROBACION PERMISOS*/
SHOW GRANTS FOR localJuan@localhost;

(=================================================================================================================)

1.12.2.1 Comprobaciones con el usuario 'localJuan@localhost'

/*CAMBIO USUARIO*/
SYSTEM MYSQL -u localJuan -p;

/*COMPROBACION SELECT*/
SELECT * FROM alumnos;SELECT * FROM asignaturas;SELECT * FROM aulas;

/*COMPROBACION UPDATE*/
/*Tabla 'alumnos', acceso a todo menos los campos 'edad', 'curso_actual'*/
/*UPDATE campo nombre (permitido)*/
UPDATE alumnos
SET nombre='Segismunda'
WHERE nombre='Cristina';

/*UPDATE campo edad (restringido)*/
UPDATE alumnos
SET edad=65
WHERE nombre='Juan';

/*UPDATE campo curso_actual (restringido)*/
UPDATE alumnos
SET curso_actual=2
WHERE nombre='Juan';

/*Tabla 'asignaturas' acceso a todo menos el campo 'descripcion'*/
/*UPDATE campo nombre_professor (permitido)*/
UPDATE asignaturas
SET email_profesor='xavierIFP@ifp.com'
WHERE nombre_professor='Xavier';

/*UPDATE campo descripcion (permitido)*/
UPDATE asignaturas
SET descripcion='Manualidades'
WHERE nombre_professor='Gonzalo';

/*Tabla 'aulas' acceso totalmente restringido salvo el SELECT en el primer punto del ejercicio*/
NO SE ASIGNAN NUEVOS PERMISOS

/*COMPROBACION DELETE*/
-Tabla 'alumnos'
DELETE FROM alumnos
WHERE clave_alumno=6;

-Tabla 'asignaturas'
DELETE FROM asignaturas
WHERE nombre_professor='Pilar';

-Tabla 'aulas'	
DELETE FROM aulas
WHERE capacidad=25;

(=================================================================================================================)

1.12.3 Sólo acceso externo: 'userexternoJuan'
Tiene acceso de lectura en todas las tablas. Puede operar en todas las tablas menos en el campo 'clave_alumno' y en la tabla 'asignaturas' sólo puede consultar. No puede modificar la estructura de ninguna tabla

/*CREACION USUARIO*/
CREATE USER IF NOT EXISTS 'userexternoJuan'@'192.168.1.%'
IDENTIFIED BY '1234';

/*ASIGNACION DE LOS PERMISOS*/

/*Lectura en todas las tablas de la BBDD instituto*/
GRANT SELECT ON instituto.* TO 'userexternoJuan'@'192.168.1.%';

/*Operar en todas las tablas menos en el campo 'clave_alumno' y en la tabla 'asignaturas'*/
/*Tabla 'alumnos'*/
GRANT INSERT(nombre, apellido1,apellido2,edad,curso_actual) 
ON instituto.alumnos 
TO 'userexternoJuan'@'192.168.1.%';

GRANT UPDATE(nombre, apellido1,apellido2,edad,curso_actual) 
ON instituto.alumnos 
TO 'userexternoJuan'@'192.168.1.%';

/*Tabla 'asignaturas'*/
SIN PERMISOS SALVO EL SELECT AGREGADO EN EL PRIMER APARTADO

/*Tabla 'aulas'*/
GRANT UPDATE, INSERT, DELETE ON instituto.aulas TO 'userexternoJuan'@'192.168.1.%';  

/*COMPROBACION PERMISOS*/
SHOW GRANTS FOR 'userexternoJuan'@'192.168.1.%';

/*COMPROBACIONES USUARIO REMOTO*/

/*SELECT*/
SELECT * FROM alumnos;
SELECT * FROM asignaturas;
SELECT * FROM aulas;

/*INSERT*/
/*Tabla alumnos*/
INSERT INTO alumnos(clave_alumno,nombre,apellido1,apellido2,edad,curso_actual)
VALUES
(10,'Neil','Armstrong','Ramirez',43,2);

INSERT INTO alumnos(nombre,apellido1,apellido2,edad,curso_actual)
VALUES
('Neil','Armstrong','Ramirez',43,2);

/*Tabla asignaturas*/
INSERT INTO asignaturas(clave_modulo,curso,descripcion,nombre_professor,email_profesor)
VALUES
(500,2,'Proyecto','Jordi','jordifp@ifp.es');

/*Tabla aulas*/
INSERT INTO aulas(numero_aula,planta_edificio,capacidad)
VALUES
(600,3,30);

/*UPDATE*/
/*Tabla alumnos*/
UPDATE alumnos
SET clave_alumno=7 WHERE clave_alumno=5;

UPDATE alumnos
SET apellido2='Westfalia' WHERE clave_alumno=5;

/*Tabla asignaturas*/
UPDATE asignaturas
SET curso=7 WHERE curso=2;

/*Tabla aulas*/
UPDATE aulas
SET planta_edificio=3 WHERE numero_aula=200;

/*DELETE*/
/*Tabla alumnos*/
DELETE FROM alumnos
WHERE nombre='Juan';

/*Tabla asignaturas*/
DELETE FROM asignaturas
WHERE curso=2;

/*Tabla aulas*/
DELETE FROM aulas
WHERE numero_aula=400;

/*ALTER*/
/*Tabla alumnos*/
ALTER TABLE alumnos
ADD nombre_padre VARCHAR(45);

/*Tabla asignaturas*/
ALTER TABLE asignaturas
DROP COLUMN curso;

/*Tabla aulas*/
ALTER TABLE aulas
ADD color_puerta VARCHAR(45);

(=================================================================================================================)

