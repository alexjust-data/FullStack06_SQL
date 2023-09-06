
------------------------------------------------------------------------------------------------

-- 
SET search_path TO clinical;

------------------------------------------------------------------------------------------------
--
-- Consulta a) 
--
------------------------------------------------------------------------------------------------
SELECT o.order_id, o.encounter_id, o.status, o.created_dt
FROM tb_orders O
WHERE o.created_dt BETWEEN '2019-01-01 00:00:00' AND current_timestamp
ORDER BY o.created_dt ASC;
------------------------------------------------------------------------------------------------
--
-- Consulta b) 
--
------------------------------------------------------------------------------------------------
SELECT p.name, ca.category, ca.order_desc, o.order_id, e.encounter_type, o.status, o.status_dt
FROM tb_orders_catalog ca  NATURAL JOIN  tb_orders o NATURAL JOIN tb_encounter e NATURAL JOIN tb_patient p
WHERE  (ca.category='Laboratorio' OR ca.category = 'M.Interna') AND o.created_dt < '2015-01-01 00:00:00' AND o.status='Cancelada'
ORDER BY o.status_dt ASC;
------------------------------------------------------------------------------------------------
--
-- Consulta c) 
--
------------------------------------------------------------------------------------------------
SELECT u.full_name , m.description, COUNT(o.order_id) As Orders, COUNT(DISTINCT e.patient_id) As Patients, SUM(c.cost) As Cost
FROM tb_medical_services m NATURAL JOIN tb_users u JOIN tb_orders o ON (u.user_id = o.created_by_user) NATURAL JOIN tb_orders_catalog c join tb_encounter e on (o.encounter_id = e.encounter_id)
GROUP BY u.full_name , m.description
ORDER BY Cost DESC
LIMIT 3;

------------------------------------------------------------------------------------------------
--
-- Consulta d) 
--
------------------------------------------------------------------------------------------------
SELECT DISTINCT * FROM tb_patient p
WHERE p.insurance ='Mapfre' AND p.patient_id NOT IN (
SELECT e.patient_id
FROM tb_encounter e WHERE e.encounter_type IN ('Urgencia','Ingreso Urgente'));


---------------De forma similar ----------------------------------------------------------------

SELECT DISTINCT pa.* 
FROM tb_patient pa
WHERE pa.insurance ='Mapfre' 
EXCEPT
SELECT DISTINCT pa.* 
FROM tb_patient pa NATURAL JOIN tb_encounter e
WHERE e.encounter_type IN ('Urgencia','Ingreso Urgente');
------------------------------------------------------------------------------------------------
--
-- Consulta e) 
--
------------------------------------------------------------------------------------------------
SELECT p.ehr_number, p.name, EXTRACT(YEAR FROM AGE(birth_dt)) Age, count(*) Visitas
FROM tb_patient p NATURAL JOIN tb_encounter e
GROUP BY  ehr_number, name, birth_dt
HAVING COUNT(*) >8
ORDER BY COUNT(*);


