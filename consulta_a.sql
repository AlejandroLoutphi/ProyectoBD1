-- No tenemos ninguna pelicula de drama que dure más de 2 horas y media
SELECT C.nombre, P.sinopsis, C.annio_lanzamiento
FROM Pelicula AS P JOIN Contenido AS C
ON P.id_contenido = C.id_contenido
WHERE mins_duracion > 150
	AND P.id_contenido IN (SELECT id_contenido
						FROM Tiene 
						WHERE id_genero IN (SELECT id_genero FROM Genero WHERE nombre='Drama'))
	AND P.ganadora_premios = true
	AND P.id_contenido IN (SELECT id_contenido
						FROM Visualizacion
						GROUP BY id_contenido
						HAVING AVG(Calificacion) >= 4)
ORDER BY C.annio_lanzamiento ASC;
