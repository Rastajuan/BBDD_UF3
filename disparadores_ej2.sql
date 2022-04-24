NOTA: El 2.3.1 es un PROCEDIMIENTO Y NO UN TRIGGER

2.3.1. Las ventas se irán añadiendo a la tabla correspondiente mediante un procedimiento. Este recibirá como parámetros de entrada el código del libro, el código del socio, la fecha de la venta y la cantidad vendida. El precio de la venta lo calculará el procedimiento, y será la cantidad del libro por su precio unitario

/*CREACION PROCEDIMIENTO*/
DELIMITER //
DROP PROCEDURE IF EXISTS insert_Ventas;
CREATE PROCEDURE insert_Ventas(IN codg_libro INT, IN codg_socio INT, IN fecha_venta DATE, IN cantidad_venta INT)
BEGIN
	SET @precio:=(SELECT libro.precio FROM libro WHERE libro.codigo=codg_libro)*cantidad_venta;
	INSERT INTO venta
	VALUES
	(codg_libro, codg_socio, fecha_venta, cantidad_venta, @precio);
END
//
DELIMITER ;

/*LLAMADA PROCEDIMIENTO*/
CALL insert_Ventas(1, 1243,'2022-04-03', 10);
CALL insert_Ventas(4, 5656,'2022-01-16', 5);


(====================================================================================================================================================================================================================================================================================================================================)

2.3.2. Cada vez que se venda un libro, el sistema ha de controlar que la cantidad vendida no exceda del stock de ese libro. Si lo intentamos hacer nos tiene que dar el siguiente mensaje "No queda stock para comprar, sentimos las molestias."

/*CREACION TRIGGER*/
DELIMITER //
DROP TRIGGER IF EXISTS trg_comprobar_Stock;
CREATE TRIGGER trg_comprobar_Stock BEFORE INSERT ON venta 
FOR EACH ROW
BEGIN
	DECLARE nuevo_Stock INT;
	SET @nuevo_Stock:=(SELECT libro.stock FROM libro WHERE libro.codigo=NEW.cod_libro)-NEW.cantidad;

	IF NEW.cantidad>(SELECT libro.stock FROM libro WHERE libro.codigo=NEW.cod_libro) 
	THEN 
		signal sqlstate '12345' SET message_text = 'No queda stock para comprar, sentimos las molestias.';
	END IF;
	IF NEW.cantidad<=(SELECT libro.stock FROM libro WHERE libro.codigo=NEW.cod_libro) 
	THEN 
		UPDATE libro
		SET stock:=nuevo_Stock WHERE libro.codigo=NEW.cod_libro;
	END IF;
END
//
DELIMITER ;

/*LLAMADA TRIGGER*/
CALL insert_Ventas(2, 5656, '2022-04-03', 5);
CALL insert_Ventas(2, 5656, '2022-04-03', 30);

(====================================================================================================================================================================================================================================================================================================================================)

2.3.3. El sistema no ha de dejarnos modificar el nombre de un socio. Si lo intentamos hacer nos tiene que dar el siguiente mensaje "No se puede cambiar el nombre de socio."

/*CREACION TRIGGER*/
DELIMITER //
DROP TRIGGER IF EXISTS trg_modificar_Socio;
CREATE TRIGGER trg_modificar_Socio BEFORE UPDATE ON socio 
FOR EACH ROW
BEGIN
	IF NEW.nombre != OLD.nombre 
	THEN 
		signal sqlstate '12345' SET message_text = 'No se puede cambiar el nombre de socio';
	END IF;
END
//
DELIMITER ;

/*LLAMADA TRIGGER*/
UPDATE socio
SET nombre='Vicente Martínez' WHERE nombre='Vicente Romero';

(====================================================================================================================================================================================================================================================================================================================================)

2.3.4. El sistema no ha de dejarnos modificar ni el título ni el autor de los libros. Si lo intentamos hacer nos tiene que dar el siguiente mensaje " No se puede cambiar el nombre del libro ni el autor. "

/*CREACION TRIGGER*/
DELIMITER //
DROP TRIGGER IF EXISTS trg_modificar_Libro;
CREATE TRIGGER trg_modificar_Libro BEFORE UPDATE ON libro 
FOR EACH ROW
BEGIN
	IF NEW.titulo!=OLD.titulo OR NEW.autor!=OLD.autor 
	THEN 
		signal sqlstate '12345' SET message_text='No se puede cambiar el nombre del libro ni el autor.';
	END IF;
END
//
DELIMITER ;

/*LLAMADA TRIGGER*/
UPDATE libro
SET titulo='It' WHERE titulo='Dracula'; #Actualización titulo
UPDATE libro
SET autor='M. de Unamuno' WHERE autor='Miguel de Cervantes'; #Actualización titulo

(====================================================================================================================================================================================================================================================================================================================================)

2.3.5. A causa de la crisis, se ha producido un aumento en la morosidad. Se ha de crear una tabla llamada Morosos con los mismos datos que la tabla Socio a partir de un procedimiento llamado crear_morosos. Después poblar la tabla con los mismos datos (INSERT)

/*CREACION PROCEDIMIENTO*/
DELIMITER //
DROP PROCEDURE IF EXISTS crear_morosos;
CREATE PROCEDURE crear_morosos()
BEGIN
	CREATE TABLE morosos(
		codigo INT PRIMARY KEY NOT NULL,
	    nombre VARCHAR(45),
	    direccion VARCHAR(45),
	    telefono VARCHAR(9)
		);

	/*Hacemos un TRUNCATE previo para vaciar la tabla antes de insertar por si volvemos a ejecutar el SP*/
	TRUNCATE morosos;

	INSERT INTO morosos
	SELECT * FROM socio;
	
END 
//
DELIMITER ;

/*LLAMADA PROCEDIMIENTO*/ 

CALL crear_morosos;

(====================================================================================================================================================================================================================================================================================================================================)

2.3.6. Hay que evitar que los socios que deben dinero se den de baja.

/*CREACION TRIGGER*/
DELIMITER //
DROP TRIGGER IF EXISTS no_delete_morosos;
CREATE TRIGGER no_delete_morosos BEFORE DELETE ON socio
FOR EACH ROW
BEGIN 
	IF EXISTS (SELECT codigo FROM morosos  WHERE OLD.codigo = morosos.codigo) 
	THEN
		signal sqlstate '12345' SET message_text = 'No se puede dar de baja al socio porque se encuentra en situación de morosidad';
	END IF;
END
//
DELIMITER ;

<LLAMADA TRIGGER> 

DELETE FROM SOCIO WHERE CODIGO = 1243;

(====================================================================================================================================================================================================================================================================================================================================)

2.3.7. Si modificamos cualquier campo de los socios (que no sea el nombre), el sistema ha de automáticamente cambiar los mismos datos a la tabla de morosos, si el socio editado está en esa tabla.

/*CREACION TRIGGER*/
DELIMITER //
DROP TRIGGER IF EXISTS modificar_datos_socios;
CREATE TRIGGER modificar_datos_socios AFTER UPDATE ON socio
FOR EACH ROW
BEGIN 
	IF EXISTS (SELECT codigo FROM morosos WHERE OLD.codigo = morosos.codigo) 
	THEN
		UPDATE Morosos set codigo = NEW.codigo WHERE codigo = OLD.codigo; 
	    UPDATE Morosos set direccion = NEW.direccion WHERE direccion = OLD.direccion; 
	    UPDATE Morosos set telefono = NEW.telefono WHERE telefono = OLD.telefono; 
	END IF;
END
//
DELIMITER ;

/*LLAMADA TRIGGER*/
/* UPDATE de codigo, direcciom y telefono*/ 
UPDATE socio 
SET codigo = 2222 WHERE codigo = 1111; 

UPDATE socio 
SET direccion = 'C/ De las Moreres, 123' WHERE codigo = 2222;

UPDATE 
socio SET telefono = '666999777' WHERE codigo = 2222;

/*Vistas Modificaciones*/
SELECT * FROM socio ;
SELECT * FROM morosos;

(====================================================================================================================================================================================================================================================================================================================================)

