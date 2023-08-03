/* 1. Análisis tabla ventas */

# 1.1 Análisis de los 10 meses con mayor precio de venta desde 2001
SELECT max(v.precio_m2) AS "Precio máximo vivienda", v.year, v.month
  FROM vivienda.ventas_01_23 v
 WHERE v.distrito = "madrid" 
 GROUP BY v.year, v.month
 ORDER BY max(v.precio_m2) DESC
 LIMIT 10; 
 #Conclusión: Los meses con mayor precio de venta son todos del periodo precrash salvo el puesto 10, que es junio de 2023

# 1.2 Top 5 años con mayor porcentaje de incremento de precio entre apertura y cierre de año desde 2001
SELECT v.year,
       MAX(v.precio_m2) AS max_value, MIN(v.precio_m2) AS min_value,
       ((MAX(v.precio_m2) - MIN(v.precio_m2)) / MIN(v.precio_m2)) * 100 AS percentage_difference
 FROM vivienda.ventas_01_23 v
WHERE v.distrito = "madrid"
GROUP BY v.year
ORDER BY percentage_difference DESC
LIMIT 5;
#Conclusión: Los años con mayor crecimiento son todos del periodo precrash salvo 2018, que es el año con mayor crecimiento de precio

# 1.3 Top 5 años con menor porcentaje de incremento de precio entre apertura y cierre de año desde 2001
SELECT v.year,
       MAX(v.precio_m2) AS max_value, MIN(v.precio_m2) AS min_value,
       ((MAX(v.precio_m2) - MIN(v.precio_m2)) / MIN(v.precio_m2)) * 100 AS percentage_difference
 FROM vivienda.ventas_01_23 v
WHERE v.distrito = "madrid"
GROUP BY v.year
ORDER BY percentage_difference ASC
LIMIT 5;
#Conclusión: Los años con menos incremento de precio son 4 de la década de los 10' y también entra 2021

# 1.4 Top 10 distritos con mayor crecimiento de precio m2 teniendo en cuenta renta media del barrio
SELECT v.distrito, d.grupo,
       MAX(v.precio_m2) AS max_value, MIN(v.precio_m2) AS min_value,
       ((MAX(v.precio_m2) - MIN(v.precio_m2)) / MIN(v.precio_m2)) * 100 AS percentage_difference
FROM vivienda.ventas_01_23 v
JOIN vivienda.master_distritos d
  ON v.distrito = d.distrito
WHERE v.year >= 2012 and v.distrito != "madrid"
GROUP BY v.distrito, d.grupo
ORDER BY percentage_difference DESC
LIMIT 10;
#Conclusión: Entre los distritos que más se han encarecido hay empate de rentas, aunque destaca con un 80% de incremento el barrio de Vicalvaro

# 1.5 Top 10 barrios con menor crecimiento de precio m2 teniendo en cuenta renta media del barrio
SELECT v.distrito, d.grupo,
       MAX(v.precio_m2) AS max_value, MIN(v.precio_m2) AS min_value,
       ((MAX(v.precio_m2) - MIN(v.precio_m2)) / MIN(v.precio_m2)) * 100 AS percentage_difference
FROM vivienda.ventas_01_23 v
JOIN vivienda.master_distritos d
  ON v.distrito = d.distrito
WHERE v.year >= 2012 and v.distrito != "madrid"
GROUP BY v.distrito, d.grupo
ORDER BY percentage_difference ASC
LIMIT 10;
#Conclusión: Destaca que el 70% de los barrios que menos incrementaron su precio son de rentas medias

# 1.6 Top 10 barrios con mayor precio/m2 en relación a los precios de alquiler
SELECT v.distrito, d.grupo, AVG(v.precio_m2), ROUND(AVG(a.precio_m2))
FROM vivienda.ventas_01_23 v
JOIN vivienda.master_distritos d
  ON v.distrito = d.distrito
JOIN vivienda.alquiler_12_23 a
  ON v.distrito = a.distrito
WHERE v.year = 2022 and v.distrito != "madrid"
GROUP BY v.distrito, d.grupo
ORDER BY AVG(v.precio_m2) DESC
LIMIT 10;
#Conclusión: Los 5 distritos con mayor coste de la vivienda son también aquellos con mayores alquileres

/* 2. Análisis tabla alquiler */

# 2.1 Análisis de los 10 meses con mayor precio de alquiler desde 2012
SELECT max(v.precio_m2) AS "Precio máximo vivienda", max(a.precio_m2) AS "Precio máximo alquiler",v.year, v.month
  FROM vivienda.ventas_01_23 v
  JOIN vivienda.alquiler_12_23 a
    ON v.date = a.date
 WHERE v.distrito = "madrid" 
 GROUP BY v.distrito, v.year, v.month
 ORDER BY max(a.precio_m2) DESC
 LIMIT 10; 
 #Conclusión: Pese a que hubo una caida por el COVID de mayo de 2020 a junio de 2021, los 6 meses de 2023 han sido los meses con mayor precio histórico

# 2.2 Top 10 barrios con mayor aumento alquiler desde 2012
SELECT a.distrito, d.grupo,
       MAX(a.precio_m2) AS max_value, MIN(a.precio_m2) AS min_value,
       ((MAX(a.precio_m2) - MIN(a.precio_m2)) / MIN(a.precio_m2)) * 100 AS percentage_difference
FROM vivienda.alquiler_12_23 a
JOIN vivienda.master_distritos d
  ON a.distrito = d.distrito
WHERE a.year >= 2012 and a.distrito != "madrid"
GROUP BY a.distrito, d.grupo
ORDER BY percentage_difference DESC
LIMIT 10;
#Conclusión: Los 5 distritos donde más ha aumentado el alquiler son de rentas bajas

# 2.3 Top 10 distritos con menor aumento alquiler desde 2012
SELECT a.distrito, d.grupo,
       MAX(a.precio_m2) AS max_value, MIN(a.precio_m2) AS min_value,
       ((MAX(a.precio_m2) - MIN(a.precio_m2)) / MIN(a.precio_m2)) * 100 AS percentage_difference
FROM vivienda.alquiler_12_23 a
JOIN vivienda.master_distritos d
  ON a.distrito = d.distrito
WHERE a.year >= 2012 and a.distrito != "madrid"
GROUP BY a.distrito, d.grupo
ORDER BY percentage_difference ASC
LIMIT 10;
#Conclusión: 8 de los 10 distritos con menos aumento de alquiler son de rentas medias

# 2.4 Top 5 años con mayor porcentaje de incremento de precio entre apertura y cierre de año desde 2012
SELECT a.year,
       MAX(a.precio_m2) AS max_value, MIN(a.precio_m2) AS min_value,
       ((MAX(a.precio_m2) - MIN(a.precio_m2)) / MIN(a.precio_m2)) * 100 AS percentage_difference
 FROM vivienda.alquiler_12_23 a
WHERE a.distrito = "madrid"
GROUP BY a.year
ORDER BY percentage_difference DESC
LIMIT 5;
#Conclusión: Destaca en primer lugar 2020 por la pandemia y en segundo lugar 2022, año en el que se ha producido un pronunciado crecimiento

# 2.5 Top 5 años con menor porcentaje de incremento de precio entre apertura y cierre de año desde 2012
SELECT a.year,
       MAX(a.precio_m2) AS max_value, MIN(a.precio_m2) AS min_value,
       ((MAX(a.precio_m2) - MIN(a.precio_m2)) / MIN(a.precio_m2)) * 100 AS percentage_difference
 FROM vivienda.alquiler_12_23 a
WHERE a.distrito = "madrid"
GROUP BY a.year
ORDER BY percentage_difference ASC
LIMIT 5;
#Conclusión: Destaca 2021 en primer lugar, el año tras la pandemia donde los precios apenas variaron un 1,4%

/* 3. Análisis tabla de datos demográficos */
# 3.1 Top 10 barrios con mayor sensación de seguridad
SELECT d.distrito, ROUND(AVG(d.seguridad),2) AS promedio_seguridad, m.grupo
  FROM vivienda.demograficos_16_22 d
  JOIN vivienda.master_distritos m
    ON d.distrito = m.distrito
 GROUP BY d.distrito, m.grupo
 ORDER BY promedio_seguridad DESC
 LIMIT 10;
#Conclusión: La mayoría de los distritos son de renta alta, seguidas de rentas medias-altas

# 3.2 Top 10 barrios con menor sensación de seguridad
SELECT d.distrito, ROUND(AVG(d.seguridad),2) AS promedio_seguridad, m.grupo
  FROM vivienda.demograficos_16_22 d
  JOIN vivienda.master_distritos m
	ON d.distrito = m.distrito
 WHERE d.distrito != "madrid"
 GROUP BY d.distrito, m.grupo
 ORDER BY promedio_seguridad ASC
 LIMIT 10;
#Conclusión: Los 5 peores distritos son de rentas bajas y los 5 siguientes de rentas medias-bajas

# 3.3 Top 10 barrios con menor calidad de vida
SELECT d.distrito, ROUND(AVG(d.cdv),2) AS promedio_cdv, ROUND(AVG(d.seguridad),2) AS promedio_seguridad, m.grupo
  FROM vivienda.demograficos_16_22 d
  JOIN vivienda.master_distritos m
	ON d.distrito = m.distrito
 WHERE d.distrito != "madrid"
 GROUP BY d.distrito, m.grupo
 ORDER BY promedio_cdv ASC
 LIMIT 10;
#Conclusión: Coinciden con la seguridad, existe cierta correlación. Los 4 primeros de rentas bajas y el quinto Tetuan, de rentas media_alta

# 3.4 Top 10 barrios con mayor número de parados
SELECT d.distrito, ROUND(AVG(d.paro),2) AS paro, m.grupo, ROUND(AVG(d.cdv),2) AS Calidad_Vida, ROUND(AVG(d.seguridad),2) AS promedio_seguridad
  FROM vivienda.demograficos_16_22 d
  JOIN vivienda.master_distritos m
	ON d.distrito = m.distrito
 WHERE d.distrito != "madrid"
 GROUP BY d.distrito, m.grupo
 ORDER BY paro DESC
 LIMIT 10;
#Conclusión: Hay correlación entre las variables demográficas, y corresponden más parados a distritos con menos calidad de vida y seguridad
#La excepción es Latina, que es del grupo medio_bajo y pese a tener más seguridad y calidad de vida, tiene más parados

# 3.5 Top 10 barrios por precio de alquiler con todos los datos demográficos
SELECT a.distrito, ROUND(AVG(precio_m2),2) AS precio_promedio_alquiler,
    ROUND(AVG(paro),2) AS tasa_paro_promedio,
    ROUND(AVG(cdv),2) AS calidad_vida_promedio,
    ROUND(AVG(seguridad),2) AS seguridad_promedio
 FROM vivienda.alquiler_12_23 a
 JOIN vivienda.demograficos_16_22 d ON a.distrito = d.distrito AND a.year = d.year
WHERE a.distrito != "madrid"
GROUP BY distrito
ORDER BY 2 DESC
LIMIT 10;
#Conclusión: Los distritos con mayor precio de alquiler coinciden con mejor calidad de vida y seguridad y menos parados

# 3.6 Top 10 barrios por precio de venta con todos los datos demográficos
SELECT v.distrito, ROUND(AVG(precio_m2),2) AS precio_promedio_alquiler,
    ROUND(AVG(paro),2) AS tasa_paro_promedio,
    ROUND(AVG(cdv),2) AS calidad_vida_promedio,
    ROUND(AVG(seguridad),2) AS seguridad_promedio, m.grupo
 FROM vivienda.ventas_01_23 v
 JOIN vivienda.demograficos_16_22 d ON v.distrito = d.distrito AND v.year = d.year
 JOIN vivienda.master_distritos m ON  v.distrito = m.distrito
WHERE v.distrito != "madrid"
GROUP BY distrito, m.grupo
ORDER BY 2 DESC
LIMIT 10;
#Conclusión: Datos muy similares a alquiler

/* 4. Análisis tabla de padrón */
# 4.1  Top 10 distritos con mayor poblacion
SELECT p.distrito, ROUND(AVG(total), 0) AS padron_total, m.grupo
  FROM vivienda.padron_12_22 p
  JOIN vivienda.master_distritos m ON  p.distrito = m.distrito
 WHERE p.distrito NOT LIKE 'madrid'
 GROUP BY p.distrito, m.grupo
 ORDER BY padron_total DESC
 LIMIT 10;
#Conclusión: Los distritos más poblados son en su mayoría de rentas bajas y rentas medias

# 4.2  Top 10 distritos con menor poblacion en relación a la renta media
SELECT p.distrito, ROUND(AVG(total), 0) AS padron_total, m.grupo
  FROM vivienda.padron_12_22 p
  JOIN vivienda.master_distritos m ON  p.distrito = m.distrito
 WHERE p.distrito NOT LIKE 'madrid'
 GROUP BY p.distrito, m.grupo
 ORDER BY padron_total DESC
 LIMIT 10;
#Conclusión: Entre los distritos menos poblados destaca que hay 5 de rentas altas

# 4.3  Top 10 de distritos con mayor porcentaje de extranjeros según renta
SELECT p.distrito, (AVG(p.extranjeros/p.total))*100 AS padron_total, m.grupo
  FROM vivienda.padron_12_22 p
  JOIN vivienda.master_distritos m ON  p.distrito = m.distrito
 WHERE p.distrito NOT LIKE 'madrid'
 GROUP BY p.distrito, m.grupo
 ORDER BY padron_total DESC
 LIMIT 10;
#Conclusión: Salvo el distrito centro que es el que más extranjeros tiene, predominan distritos de rentas bajas entre los que tienen mayor porcentaje de inmigrantes

# 4.4  Top 10 de distritos con mayor porcentaje de extranjeros según renta
SELECT p.distrito, (AVG(p.extranjeros/p.total))*100 AS padron_total, m.grupo
  FROM vivienda.padron_12_22 p
  JOIN vivienda.master_distritos m ON  p.distrito = m.distrito
 WHERE p.distrito NOT LIKE 'madrid'
 GROUP BY p.distrito, m.grupo
 ORDER BY padron_total ASC
 LIMIT 10;
 #Conclusión: Predominancia de distritos de rentas altas y ningún distrito con renta baja entre los 10 distritos con menos porcentaje de extranjeros
 
 /* 5. Análisis tabla google */
# 5.1  Top 10 años con mayor interés medio de búsqueda de alquiler en madrid en Google
SELECT ROUND(AVG(alquiler_madrid)) AS Interes_Alquiler_Madrid, year
  FROM vivienda.google_04_23 
 GROUP BY year
 ORDER BY AVG(alquiler_madrid) desc
 LIMIT 10;
 #Conclusión: Se detecta pico de búsqueda entre 2015 y 2018
 
 # 5.2  Top 10 años con menor interés medio de búsqueda de alquiler en madrid en Google
SELECT ROUND(AVG(alquiler_madrid)) AS Interes_Alquiler_Madrid, year
  FROM vivienda.google_04_23 
 GROUP BY year
 ORDER BY AVG(alquiler_madrid) asc
 LIMIT 10;
 #Conclusión: Aparecen años circundantes a la crisis de 2008 (2010,2006 y 2009) pero también 2020, 2021 y 2023 ¿tendencia negativa?
 
# 5.3  Top 10 años con mayor interés medio de búsqueda de compra en madrid en Google
SELECT ROUND(AVG(comprar_madrid)) AS Interes_Comprar_Madrid, year
  FROM vivienda.google_04_23 
 GROUP BY year
 ORDER BY AVG(comprar_madrid) desc
 LIMIT 10;
 #Conclusión: Destacan los años del "bottom" del mercado inmobiliario durante la crisis (2012-2017)
 
# 5.4  Top 10 años con menor interés medio de búsqueda de compra en madrid en Google
SELECT ROUND(AVG(comprar_madrid)) AS Interes_Comprar_Madrid, year
  FROM vivienda.google_04_23 
 GROUP BY year
 ORDER BY AVG(comprar_madrid) asc
 LIMIT 10
 #Conclusión: Destacan los años en torno al crash de la burbuja inmobiliaria (2006-2009) Cierran el top 10 2020,2021 y 2023
 