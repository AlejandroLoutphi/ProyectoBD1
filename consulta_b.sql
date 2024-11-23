SELECT U.*, L.nombre nombre_ciudad, COUNT(S.id_contenido) series_vistas
FROM Ciudad L, Usuario U, Perfil P, Contenido C, Serie S, Visualizacion V
WHERE L.id_ciudad = U.id_ciudad
AND U.id_usuario = P.id_usuario
AND P.id_usuario = V.id_usuario
AND P.id_perfil = V.id_perfil
AND C.id_contenido = S.id_contenido
AND S.id_contenido = V.id_contenido
AND C.es_contenido_original = TRUE
GROUP BY U.id_usuario, L.nombre
ORDER BY COUNT(S.id_contenido)
LIMIT 1;
