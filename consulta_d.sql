SELECT DISTINCT M.*
FROM Pais M, Ciudad L, Usuario U, Perfil P, Visualizacion V, Serie S
WHERE M.id_pais = L.id_pais
AND L.id_ciudad = U.id_ciudad
AND P.id_usuario = U.id_usuario
AND V.id_usuario = P.id_usuario
AND V.id_perfil = P.id_perfil
AND V.id_contenido = S.id_contenido
AND S.num_episodios > 10
