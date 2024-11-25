SELECT *
FROM Usuario
WHERE id_usuario IN (SELECT id_usuario
					FROM Contrata
					WHERE fecha_fin >= CURRENT_DATE)
AND id_usuario IN (SELECT id_usuario
					FROM Visualizacion
					WHERE id_contenido IN (SELECT id_contenido FROM Requiere)
					GROUP BY id_usuario
					HAVING COUNT(id_contenido) > 2)
AND nombre LIKE '%adri%';