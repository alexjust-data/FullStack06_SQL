-----------------------------------------------------
-- Pregunta 3 a) Creo función clinical.cambio_status()
-----------------------------------------------------

CREATE or REPLACE FUNCTION clinical.cambio_status() 
RETURNS trigger AS 
$$
/* 
 *  Procedimiento: cambio_status()
 *  Autor: Alex Rodriguez Just
 *  Fecha creación: 2021-05-05
 *  Versión: 1.0
 *  Parámetros:  ninguno
 *  Descripción: Procedimiento que se lanza a partir de TRIGGER actualiza_status
 *               Evita que las filas con "status":"Cancelada" puedan ser
 *               actualizadas a "Realizada" y viceversa.
 */
BEGIN
    raise notice 'Old: %', OLD.status;
    raise notice 'New: %', NEW.status;
    IF ((NEW.status='Realizada' AND OLD.status='Cancelada') OR
        (NEW.status='Cancelada' AND OLD.status='Realizada')) THEN
        RAISE EXCEPTION 
			'UPDATE DENIED';
    ELSE  
        RETURN NEW;
    END IF;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER actualiza_status
AFTER UPDATE OF status ON clinical.tb_orders
FOR EACH ROW EXECUTE PROCEDURE cambio_status();

---------------------------------------------------------------
-- Pregunta 3 b) Creo tabla clinical.tb_orders_status_changelog
---------------------------------------------------------------

CREATE TABLE clinical.tb_orders_status_changelog(
    order_id INTEGER NOT NULL,
    old_status VARCHAR(50) NOT NULL,
    new_status VARCHAR(50) NOT NULL,
    changelog_dt TIMESTAMP NOT NULL,
    CONSTRAINT FK_orders_status_changelog FOREIGN KEY(order_id) REFERENCES clinical.tb_orders(order_id)
);

-----------------------------------------------------------------------
-- Pregunta 3 c) Creo función clinical.captura_orders_status()
-----------------------------------------------------------------------

CREATE OR REPLACE FUNCTION clinical.captura_orders_status() 
RETURNS trigger AS $$ 
/* 
 *  Procedimiento: cambio_status()
 *  Autor: Alex Rodriguez Just
 *  Fecha creación: 2021-05-05
 *  Versión: 1.0
 *  Parámetros:  ninguno
 *  Descripción: Procedimiento que cargará en la tabla clinical.tb_orders_status_changelog
 *               los cambios de "status" en la tabla clinical.tb_orders.
 * 				 Se lanzará a partir de TRIGGER captura_status.
 */
BEGIN 
  INSERT INTO clinical.tb_orders_status_changelog 
  VALUES (OLD.order_id, 
		  OLD.status, 
		  NEW.status, 
		  CURRENT_TIMESTAMP);
RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER captura_status
AFTER UPDATE OF status ON clinical.tb_orders
FOR EACH ROW EXECUTE PROCEDURE clinical.captura_orders_status();
