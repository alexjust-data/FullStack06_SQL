------------------------------------------------------------------------------------------------
-- Ejercicio 2A
------------------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION clinical.catalog_yearly_orders(order_year INTEGER, catalog_option INTEGER)
RETURNS INTEGER AS $$
DECLARE 
  total NUMERIC;
BEGIN
  SELECT COUNT(*) INTO total
  FROM clinical.tb_orders 
  WHERE EXTRACT(YEAR FROM created_dt) = order_year AND order_code = catalog_option; 
  RETURN total;
END;
$$LANGUAGE plpgsql;

------------------------------------------------------------------------------------------------
-- Ejercicio 2B
------------------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION clinical.yearly_orders(order_year INTEGER)
RETURNS INTEGER AS $$
DECLARE 
  total NUMERIC;
BEGIN
  SELECT COUNT(*) INTO total
  FROM clinical.tb_orders 
  WHERE EXTRACT(YEAR FROM created_dt) = order_year; 
  RETURN total;
END;
$$LANGUAGE plpgsql;

------------------------------------------------------------------------------------------------
-- Ejercicio 2C
------------------------------------------------------------------------------------------------
DROP TYPE IF EXISTS clinical.summary_orders_record CASCADE;

CREATE TYPE clinical.summary_orders_record AS (
  year INTEGER,
  order_desc TEXT,
  percentage NUMERIC(3,2)
);

CREATE OR REPLACE FUNCTION clinical.summary_orders()
RETURNS SETOF clinical.summary_orders_record AS $$
DECLARE
  results clinical.summary_orders_record;
  created_year_aux INTEGER;
  order_code_aux INTEGER;
  order_desc_aux TEXT;
  catalog_yearly_count NUMERIC;
  yearly_count NUMERIC;
BEGIN
  FOR created_year_aux, order_code_aux, order_desc_aux IN ( 
    SELECT DISTINCT EXTRACT(YEAR FROM o.created_dt) AS created_year, o.order_code AS order_code, oc.order_desc AS order_desc
    FROM clinical.tb_orders o
    JOIN clinical.tb_orders_catalog oc ON (oc.order_code = o.order_code)
    ORDER BY created_year, order_code ASC
  ) 
  LOOP
    SELECT clinical.catalog_yearly_orders(created_year_aux, order_code_aux) INTO catalog_yearly_count;
    SELECT clinical.yearly_orders(created_year_aux) INTO yearly_count;
    results.year:=created_year_aux;
    results.order_desc:=order_desc_aux;
    results.percentage:=catalog_yearly_count/yearly_count;
    RETURN NEXT results;
  END LOOP;
END;
$$LANGUAGE plpgsql;

SELECT * FROM clinical.summary_orders();
