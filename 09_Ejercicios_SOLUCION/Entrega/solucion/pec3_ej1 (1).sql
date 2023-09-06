------------------------------------------------------------------------------------------------
-- Ejercicio 1A
------------------------------------------------------------------------------------------------
ALTER TABLE clinical.tb_patient ALTER COLUMN birth_dt SET NOT NULL;

------------------------------------------------------------------------------------------------
-- Ejercicio 1B
------------------------------------------------------------------------------------------------
ALTER TABLE clinical.tb_encounter ADD CONSTRAINT ck_dicharge_bigger_than_arrival CHECK (discharge_dt >= arrival_dt);

------------------------------------------------------------------------------------------------
-- EJERCICIO 1C
------------------------------------------------------------------------------------------------
DROP TRIGGER IF EXISTS dont_update_created_date ON clinical.tb_orders;

CREATE OR REPLACE FUNCTION clinical.check_created_dt_change() 
RETURNS trigger language plpgsql AS $$
BEGIN
  IF (NEW.created_dt <> OLD.created_dt) THEN
    RAISE EXCEPTION 'It is not possible to update the column created_dt';
  END IF;
  RETURN NEW;
END;
$$;

CREATE TRIGGER dont_update_created_date
BEFORE UPDATE ON clinical.tb_orders FOR EACH ROW
EXECUTE PROCEDURE clinical.check_created_dt_change();
