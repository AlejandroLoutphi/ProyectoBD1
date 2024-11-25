SELECT *
FROM Contenido
WHERE id_contenido > (SELECT AVG(Calificacion)
					FROM Visualizacion)
AND id_contenido IN (SELECT id_contenido
					FROM Actua
					WHERE id_actor IN (SELECT id_actor FROM Actor WHERE nombre='Daniel Brühl'));