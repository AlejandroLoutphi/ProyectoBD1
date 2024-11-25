SELECT U.nombre, COUNT(V.*)
FROM Usuario U, Visualizacion V, Recomendada R
WHERE (U.id_usuario = V.id_usuario)
AND V.id_contenido IN (SELECT id_contenido FROM Pelicula)
AND (V.id_usuario = R.id_usuario AND V.id_contenido = R.id_contenido)
GROUP BY U.id_usuario
ORDER BY COUNT(V.*) DESC
LIMIT 5;
