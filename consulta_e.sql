SELECT C.*, P.*
FROM Contenido C, Pelicula P
WHERE C.id_contenido = P.id_contenido
AND C.id_contenido > (SELECT AVG(Calificacion)
					FROM Visualizacion V, Pelicula P
                    WHERE V.id_contenido = P.id_contenido)
AND C.id_contenido IN (SELECT id_contenido
					FROM Actua
					WHERE id_actor IN (SELECT id_actor FROM Actor WHERE nombre='Daniel Brühl'));
