------------------------------------------------------------------------------------------------
--
-- Create database
--
------------------------------------------------------------------------------------------------

-- CREATE DATABASE BD_DW2;;

------------------------------------------------------------------------------------------------


------------------------------------------------------------------------------------------------
--
-- Drop schema &  tables
--
------------------------------------------------------------------------------------------------

DROP SCHEMA IF EXISTS clinical CASCADE;

------------------------------------------------------------------------------------------------
--
-- Create schema
--
------------------------------------------------------------------------------------------------

CREATE SCHEMA clinical ;

------------------------------------------------------------------------------------------------
--
-- Set the path
--
------------------------------------------------------------------------------------------------

SET search_path TO clinical;

------------------------------------------------------------------------------------------------
--
-- Create tb_medical_services
--
------------------------------------------------------------------------------------------------

CREATE TABLE tb_medical_services (
	med_service_id INT NOT NULL,
	description CHARACTER VARYING(50) NOT NULL,
	surgical CHARACTER  NOT NULL,
	short_code CHARACTER(3)  NOT NULL,
	CONSTRAINT PK_tb_med_services PRIMARY KEY(med_service_id)
	);

------------------------------------------------------------------------------------------------
--
-- Create table tb_users  
--
------------------------------------------------------------------------------------------------

CREATE TABLE tb_users (
	user_id INT NOT NULL,
	user_name CHARACTER(10)  NOT NULL,
	user_type CHARACTER(10)  NOT NULL,
	full_name CHARACTER VARYING(50) NOT NULL,
	register_dt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	medical_license_nbr CHARACTER(10),
	med_service_id INT,
   CONSTRAINT PK_tb_users PRIMARY KEY(user_id),
	CONSTRAINT FK_users_med_services FOREIGN KEY (med_service_id) REFERENCES tb_medical_services(med_service_id)
	);

------------------------------------------------------------------------------------------------
--
-- Create table tb_patient  
--
------------------------------------------------------------------------------------------------

CREATE TABLE tb_patient (
	patient_id INT NOT NULL,
	ehr_number INT,
	name CHARACTER VARYING(50),
	sex  CHARACTER,
	birth_dt DATE,
	residence CHARACTER VARYING(100),
	insurance CHARACTER VARYING(50),
	CONSTRAINT PK_tb_patient PRIMARY KEY(patient_id)
	);

------------------------------------------------------------------------------------------------
--
-- Create table tb_encounter  
--
------------------------------------------------------------------------------------------------

CREATE TABLE tb_encounter (
	encounter_id INT NOT NULL,
	patient_id INT NOT NULL,
	encounter_type CHARACTER VARYING(50) NOT NULL,
	arrival_dt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	discharge_dt TIMESTAMP,
	med_service_id INT NOT NULL,
	CONSTRAINT PK_tb_encounter PRIMARY KEY(encounter_id),
	CONSTRAINT FK_encounter_patient FOREIGN KEY (patient_id) REFERENCES tb_patient(patient_id),
	CONSTRAINT FK_encounter_med_service FOREIGN KEY (med_service_id) REFERENCES tb_medical_services(med_service_id)
	);

------------------------------------------------------------------------------------------------
--
-- Create table tb_orders_catalog  
--
------------------------------------------------------------------------------------------------

CREATE TABLE tb_orders_catalog (
	order_code INT NOT NULL, 
	category CHARACTER VARYING(50) NOT NULL, 
	subcategory CHARACTER VARYING(50) NOT NULL, 
	order_desc CHARACTER VARYING(50) NOT NULL, 
	cost REAL NOT NULL,
	CONSTRAINT PK_tb_orders_catalog PRIMARY KEY(order_code)
	);

------------------------------------------------------------------------------------------------
--
-- Create table tb_orders  
--
------------------------------------------------------------------------------------------------

CREATE TABLE tb_orders (
	order_id INT NOT NULL, 
	order_code INT NOT NULL, 
	encounter_id INT NOT NULL, 
	status CHARACTER VARYING(50), 
	created_dt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	status_dt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, 
	created_by_user INT NOT NULL,
	CONSTRAINT PK_tb_orders PRIMARY KEY(order_id),
	CONSTRAINT FK_orders_catalog FOREIGN KEY (order_code) REFERENCES tb_orders_catalog (order_code),
	CONSTRAINT FK_orders_encounter FOREIGN KEY (encounter_id) REFERENCES tb_encounter(encounter_id),
	CONSTRAINT FK_orders_users FOREIGN KEY (created_by_user) REFERENCES tb_users(user_id)
	);
