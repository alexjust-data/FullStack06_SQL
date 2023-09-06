------------------------------------------------------------------------------------------------
-- EJERCICIO 3A
------------------------------------------------------------------------------------------------
DROP TRIGGER IF EXISTS tg_orders_status ON clinical.tb_orders;

CREATE OR REPLACE FUNCTION clinical.fn_orders_status() 
RETURNS trigger AS $$
BEGIN
  IF (OLD.status = 'Cancelada' AND NEW.status = 'Realizada') THEN
    RAISE EXCEPTION 'Status cannot be updated from Cancelada to Realizada';
  END IF;
  IF (OLD.status = 'Realizada' AND NEW.status = 'Cancelada') THEN
    RAISE EXCEPTION 'Status cannot be updated from Realizada to Cancelada';
  END IF;
  RETURN NEW;
END
$$ language 'plpgsql';

CREATE TRIGGER tg_orders_status
BEFORE UPDATE ON clinical.tb_orders FOR EACH ROW
WHEN (OLD.status IS DISTINCT FROM NEW.status)
EXECUTE FUNCTION clinical.fn_orders_status();

------------------------------------------------------------------------------------------------
-- EJERCICIO 3B
------------------------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS clinical.tb_orders_status_changelog (
  order_id INT NOT NULL, 
  old_status CHARACTER VARYING (50) NOT NULL,
  new_status CHARACTER VARYING (50) NOT NULL,
  changelog_dt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_orders FOREIGN KEY (order_id) REFERENCES clinical.tb_orders(order_id)
);

------------------------------------------------------------------------------------------------
-- EJERCICIO 3C
------------------------------------------------------------------------------------------------
DROP TRIGGER IF EXISTS tg_orders_status_changelog ON clinical.tb_orders;

CREATE OR REPLACE FUNCTION fn_orders_status_changelog() 
RETURNS trigger AS $$
BEGIN
  INSERT INTO clinical.tb_orders_status_changelog VALUES (OLD.order_id, OLD.status, NEW.status);
  RETURN NEW;
END
$$ language 'plpgsql';

CREATE TRIGGER tg_orders_status_changelog
BEFORE UPDATE ON clinical.tb_orders FOR EACH ROW
WHEN (OLD.status IS DISTINCT FROM NEW.status)
EXECUTE PROCEDURE fn_orders_status_changelog();
