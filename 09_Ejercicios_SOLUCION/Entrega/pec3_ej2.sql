---------------------------------------------------------
-- Pregunta 2 a) creo procedimiento catalog_yearly_orders
---------------------------------------------------------

CREATE OR REPLACE FUNCTION catalog_yearly_orders (
    years integer, 
    codes clinical.tb_orders.order_code%type)
RETURNS integer AS 
/* 
 *  Procedimiento: catalog_yearly_orders()
 *  Autor: Alex Rodriguez Just
 *  Fecha creación: 2021-05-05
 *  Versión: 1.0
 *  Parámetros:  years, codes
 *  Descripción: Devuelve el número de prestaciones realizadas para
 *               esa opción del catálogo y ese año.
 */
$$
DECLARE
    año integer;
    orden integer;
    suma_prestaciones integer;
BEGIN
    suma_prestaciones = 0;
    FOR año, orden 
        IN SELECT extract(year from o.created_dt), o.order_code 
           FROM clinical.tb_orders o
           WHERE extract(year from o.created_dt)=years AND 
                 o.order_code=codes AND
                 o.status='Realizada'  LOOP 
        suma_prestaciones = suma_prestaciones + 1;
    END LOOP;
    RETURN suma_prestaciones;
END;
$$ LANGUAGE plpgsql STABLE;

SELECT * FROM catalog_yearly_orders(2019, 2114);

-------------------------------------------------
-- Pregunta 2 b) creo procedimiento yearly_orders
-------------------------------------------------

CREATE OR REPLACE FUNCTION yearly_orders(
	year INTEGER)
RETURNS integer AS
/* 
 *  Procedimiento: catalog_yearly_orders()
 *  Autor: Alex Rodriguez Just
 *  Fecha creación: 2021-05-05
 *  Versión: 1.0
 *  Parámetros:  year
 *  Descripción: Devuelve el número de prestaciones realizadas para ese año.
 */
$$
DECLARE
    total_prestaciones_realizadas integer;
BEGIN
    total_prestaciones_realizadas = 0;
    SELECT COUNT(o.order_code) INTO total_prestaciones_realizadas
    FROM clinical.tb_orders o
    WHERE o.status='Realizada' AND extract(year from o.created_dt)=year
    GROUP BY extract(year from o.created_dt) ORDER BY 1 ASC;
    RETURN coalesce(total_prestaciones_realizadas, 0);
END;
$$ LANGUAGE plpgsql STABLE;

------------------------------------------------------------------------
-- Pregunta 2 c) Creo procedimiento summary_orders y su TYPE date_output
------------------------------------------------------------------------

--------------------------------------------------------------------
-- Creo TYPE clinical.date_output para procedimiento summary_orders()
--------------------------------------------------------------------
CREATE TYPE clinical.date_output AS (years INTEGER, 
									 order_desc VARCHAR(50), 
									 percentage DECIMAL(4,2));

-------------------------------------
-- Creo procedimiento summary_orders 
-------------------------------------
CREATE OR REPLACE FUNCTION summary_orders()
RETURNS SETOF clinical.date_output AS 
$$
/* 
 *  Procedimiento: summary_orders()
 *  Autor: Alex Rodriguez Just
 *  Fecha creación: 2021-05-05
 *  Versión: 1.0
 *  Parámetros:  sin parámetros
 *  Descripción: Devuelve conjunto de filas con columnas "year","order_desc","percentage" 
 *               ordenado por año y el código de la opción del catálogo, ascendentemente.
 */
DECLARE
	year_desc_per clinical.date_output;
	years INTEGER;
	code INTEGER;
	total_year NUMERIC;
	total_code NUMERIC;
	order_desc VARCHAR(50);
	percentage DECIMAL(4,2);
BEGIN
	total_year = 0;
	total_code = 0;
	percentage = 0;
	-- itero por cada año diferente
	FOR years IN SELECT DISTINCT extract('year' from o.created_dt) 
			     FROM clinical.tb_orders o  
			     ORDER BY 1 ASC LOOP
		-- de cada año diferente, itero por cada código diferente
		FOR code IN SELECT DISTINCT o.order_code 
					FROM clinical.tb_orders o 
					WHERE extract('year' from o.created_dt) = years AND o.status = 'Realizada' 
					ORDER BY 1 ASC LOOP
						-- uso procedimientos a) y b) junto a las iteraciones "year" & "code"
						total_year = (SELECT * FROM yearly_orders(years));
						total_code = (SELECT * FROM catalog_yearly_orders(years, code));
						-- cálculos para sacar el procentaje
 						percentage = total_code/total_year;
						-- selecciono la descripcción del servicio por cada código encontrado
						order_desc = (SELECT  oc.order_desc 
									  FROM clinical.tb_orders_catalog oc 
									  WHERE oc.order_code = code);
						-- nos devuelve los TYPE date_output
						RETURN NEXT (years, order_desc , percentage);
		END LOOP;
	END LOOP;
END;
$$LANGUAGE plpgsql;











