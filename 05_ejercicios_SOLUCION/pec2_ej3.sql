
------------------------------------------------------------------------------------------------

-- 
SET search_path TO clinical;

------------------------------------------------------------------------------------------------
--
-- Pregunta a) 
--
------------------------------------------------------------------------------------------------
INSERT INTO clinical.tb_medical_services(med_service_id, description, surgical, short_code) VALUES(6,'Digestología','S','DIG');
INSERT INTO clinical.tb_orders_catalog(order_code, category, subcategory, order_desc, cost) VALUES (9001, 'M.Interna', 'Endoscopia', 'Colonoscopia', 600.00);
UPDATE clinical.tb_users SET med_service_id = 6 WHERE user_id = 13;

------------------------------------------------------------------------------------------------
--
-- Pregunta b) 
--
------------------------------------------------------------------------------------------------
ALTER TABLE tb_encounter 
ADD CONSTRAINT check_data_discharge CHECK (discharge_dt IS NULL OR  discharge_dt >= arrival_dt);
------------------------------------------------------------------------------------------------
--
-- Pregunta c) 
--
------------------------------------------------------------------------------------------------
CREATE OR REPLACE VIEW clinical.top_six_cost_doctors AS(
SELECT u.full_name , m.description, COUNT(o.order_id) As Orders, COUNT(DISTINCT e.patient_id) As Patients, SUM(c.cost) As Cost
FROM tb_medical_services m JOIN tb_users u ON (m.med_service_id= u.user_id) JOIN tb_orders o ON (u.user_id = o.created_by_user) NATURAL JOIN tb_orders_catalog c join tb_encounter e on (o.encounter_id = e.encounter_id)
GROUP BY u.full_name , m.description
ORDER BY Cost DESC
LIMIT 10);

------------------------------------------------------------------------------------------------
--
-- Pregunta d) 
--
------------------------------------------------------------------------------------------------
ALTER TABLE tb_users 
ADD COLUMN mail_address CHARACTER VARYING(100) UNIQUE DEFAULT NULL;
------------------------------------------------------------------------------------------------
--
-- Pregunta e) 
--
------------------------------------------------------------------------------------------------
CREATE USER rw_clinical WITH LOGIN PASSWORD 'rw_clinical_uoc'; -- Creamos el usuario con la contraseña indicada. La creación de usuarios en PostgreSQL es en base a roles. CREATE USER es un alias de CREATE ROLE
GRANT USAGE ON SCHEMA clinical TO rw_clinical; -- Damos permiso de uso al esquema clinical al usuario creado   
GRANT SELECT,INSERT,UPDATE,DELETE ON clinical.tb_medical_services TO rw_clinical; -- Damos permiso de SELECT,INSERT,UPDATE,DELETE solamente sobre la tabla al usuario creado. No hay WITH GRANT OPTION
GRANT SELECT,INSERT,UPDATE,DELETE ON clinical.tb_users TO rw_clinical; -- Damos permiso de SELECT,INSERT,UPDATE,DELETE solamente sobre la tabla al usuario creado. No hay WITH GRANT OPTION
GRANT SELECT,INSERT,UPDATE,DELETE ON clinical.tb_patient TO rw_clinical; -- Damos permiso de SELECT,INSERT,UPDATE,DELETE solamente sobre la tabla al usuario creado. No hay WITH GRANT OPTION
GRANT SELECT,INSERT,UPDATE,DELETE ON clinical.tb_encounter TO rw_clinical; -- Damos permiso de SELECT,INSERT,UPDATE,DELETE solamente sobre la tabla al usuario creado. No hay WITH GRANT OPTION
GRANT SELECT,INSERT,UPDATE,DELETE ON clinical.tb_orders_catalog TO rw_clinical; -- Damos permiso de SELECT,INSERT,UPDATE,DELETE solamente sobre la tabla al usuario creado. No hay WITH GRANT OPTION
GRANT SELECT,INSERT,UPDATE,DELETE ON clinical.tb_orders TO rw_clinical; -- Damos permiso de SELECT,INSERT,UPDATE,DELETE solamente sobre la tabla al usuario creado. No hay WITH GRANT OPTION

