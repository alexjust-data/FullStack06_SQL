-----------------------------------
-- Pregunta 1 a) 
-----------------------------------
/* 
 *  ALTER TABLE
 *  Autor: Alex Rodriguez Just
 *  Fecha creación: 2021-05-05
 *  Descripción: evitar la posibilidad de registrar pacientes cuyo birth_dt
 *               tenga valor nulo.
 */
ALTER TABLE clinical.tb_patient ADD CONSTRAINT constraint_birth 
CHECK(birth_dt IS NOT NULL) NOT VALID;

ALTER TABLE clinical.tb_patient VALIDATE CONSTRAINT constraint_birth;

-----------------------------------
-- Pregunta 1 b)
-----------------------------------
/* 
 *  ALTER TABLE
 *  Autor: Alex Rodriguez Just
 *  Fecha creación: 2021-05-05
 *  Descripción: asegurarse de que "discharge_dt" sea siempre mayor o igual que "arrival_dt".
 */
ALTER TABLE clinical.tb_encounter ADD CONSTRAINT check_dates
CHECK(arrival_dt <= discharge_dt);

ALTER TABLE clinical.tb_encounter VALIDATE CONSTRAINT check_dates;

-----------------------------------
-- Pregunta 1 c)
-----------------------------------

CREATE OR REPLACE FUNCTION stop_change_on_created_dt()
RETURNS trigger AS
/* 
 *  Procedimiento: stop_change_on_created_dt()
 *  Autor: Alex Rodriguez Just
 *  Fecha creación: 2021-05-05
 *  Versión: 1.0
 *  Parámetros:  
 *  Descripción: evitar que los valores insertados en created_dt puedan ser modificados.
 *               Se opta por esta opción ya que si utilizamos REVOKE UPDATE para negar permisos 
 *               en todas las columnas y luego usar GRANT para dar permisos en las columnas deseadas,
 *               deberíamos escojer el usuario para esos permisos y no tenemos constancia de qué 
 *               usuario utilizarán para la corrección de ejercicio.
 *               Ete procedimiento se dispara con el TRIGGER avoid_created_dt_changes
 */
$$
BEGIN
  IF NEW.created_dt <> OLD.created_dt THEN
      RAISE EXCEPTION 'the inserted values cannot be modified';
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER avoid_created_dt_changes
BEFORE UPDATE ON clinical.tb_orders FOR EACH ROW
EXECUTE PROCEDURE stop_change_on_created_dt();












