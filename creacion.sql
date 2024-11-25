-- dominios
CREATE TYPE Sexo AS ENUM
    ('M', 'F', 'N/A');

CREATE TYPE Tipo AS ENUM
    ('Gold', 'Premium', 'VIP');

CREATE DOMAIN Calificacion AS INT CHECK (VALUE BETWEEN 1 AND 5);
CREATE DOMAIN Uint AS INT CHECK (VALUE >= 0);
CREATE DOMAIN BigUint AS BIGINT CHECK (VALUE >= 0);

-- tablas
CREATE TABLE Pais(
    id_pais SERIAL PRIMARY KEY,
    nombre VARCHAR(128) NOT NULL,
    descripcion VARCHAR(2048)
);

CREATE TABLE Ciudad(
    id_ciudad SERIAL PRIMARY KEY,
    nombre VARCHAR(128) NOT NULL,
    descripcion VARCHAR(2048),
    id_pais INT REFERENCES
        Pais(id_pais)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

CREATE TABLE Usuario(
    id_usuario SERIAL PRIMARY KEY,
    sexo Sexo,
    nombre VARCHAR(128) NOT NULL,
    email VARCHAR(128) UNIQUE NOT NULL,
    fecha_nacimiento DATE,
    nombre_usuario VARCHAR(128) UNIQUE NOT NULL,
    contrasena VARCHAR(128) NOT NULL,
    tarjeta BigUint,
    apellido VARCHAR(128),
    id_ciudad INT REFERENCES
        Ciudad(id_ciudad)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

CREATE TABLE Perfil(
    id_usuario INT REFERENCES
        Usuario(id_usuario)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    id_perfil SERIAL,
    nombre VARCHAR(128) NOT NULL,
    email VARCHAR(128),
    preferencias_idioma VARCHAR(128),
    PRIMARY KEY (id_usuario, id_perfil)
);

CREATE OR REPLACE FUNCTION inc_perfil_id_fn()
RETURNS TRIGGER
LANGUAGE PLPGSQL
AS $$
BEGIN
    IF ((SELECT count(*) FROM Perfil P WHERE P.id_usuario = NEW.id_usuario) >= 5) THEN
        RAISE EXCEPTION 'Solo pueden haber hasta 5 perfiles por usuario';
    END IF;
    RETURN NEW;
END;
$$;

CREATE TRIGGER inc_perfil_id
BEFORE INSERT ON Perfil
FOR EACH ROW
EXECUTE PROCEDURE inc_perfil_id_fn();

CREATE TABLE Genero(
    id_genero SERIAL PRIMARY KEY,
    nombre VARCHAR(128) NOT NULL,
    descripcion VARCHAR(2048)
);

CREATE TABLE Prefiere(
    id_usuario INT,
    id_perfil INT,
    id_genero INT REFERENCES
        Genero(id_genero)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    PRIMARY KEY (id_usuario, id_perfil, id_genero),
    FOREIGN KEY (id_usuario, id_perfil) REFERENCES
        Perfil(id_usuario, id_perfil)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

CREATE TABLE Suscripcion(
    id_suscripcion SERIAL PRIMARY KEY,
    tipo Tipo,
    nombre VARCHAR(128) NOT NULL,
    descripcion VARCHAR(2048),
    tarifa Uint
);

CREATE TABLE Contrata(
    id_usuario INT REFERENCES
        Usuario(id_usuario)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    id_suscripcion INT REFERENCES
        Suscripcion(id_suscripcion)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    fecha_inicio DATE,
    fecha_fin DATE,
    PRIMARY KEY (id_usuario, id_suscripcion, fecha_inicio)
);

CREATE TABLE Contenido(
    id_contenido SERIAL PRIMARY KEY,
    annio_lanzamiento Uint,
    nombre VARCHAR(128) NOT NULL,
    es_contenido_original BOOL
);

CREATE TABLE Pelicula(
    id_contenido INT REFERENCES
        Contenido(id_contenido)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    mins_duracion Uint,
    ganadora_premios BOOL,
    sinopsis VARCHAR(2048),
    PRIMARY KEY (id_contenido)
);

CREATE TABLE Serie(
    id_contenido INT REFERENCES
        Contenido(id_contenido)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
        num_episodios Uint DEFAULT 0,
    descripcion VARCHAR(2048),
    PRIMARY KEY (id_contenido)
);

CREATE TABLE Temporada(
    id_contenido INT REFERENCES
        Serie(id_contenido)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    id_temporada SERIAL,
    numero Uint,
    descripcion VARCHAR(2048),
    PRIMARY KEY (id_contenido, id_temporada)
);

CREATE TABLE Episodio(
    id_contenido INT,
    id_temporada INT,
    id_episodio SERIAL,
    numero Uint,
    nombre VARCHAR(128),
    descripcion VARCHAR(2048),
    PRIMARY KEY (id_contenido, id_temporada, id_episodio),
    FOREIGN KEY (id_contenido, id_temporada) REFERENCES
        Temporada(id_contenido, id_temporada)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

CREATE TABLE Actor(
    id_actor SERIAL PRIMARY KEY,
    nombre VARCHAR(128) NOT NULL,
    sexo Sexo,
    annio_debut Uint
);

CREATE TABLE Actua(
    id_actor INT REFERENCES
        Actor(id_actor)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    id_contenido INT REFERENCES
        Contenido(id_contenido)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    premios BOOL,
    es_protagonista BOOL,
    PRIMARY KEY (id_actor, id_contenido)
);

CREATE TABLE Requiere(
    id_contenido INT REFERENCES
        Contenido(id_contenido)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    id_suscripcion INT REFERENCES
        Suscripcion(id_suscripcion)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    PRIMARY KEY (id_contenido, id_suscripcion)
);

CREATE TABLE Recomendada(
    id_contenido INT REFERENCES
        Contenido(id_contenido)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    id_usuario INT,
    id_perfil INT,
    PRIMARY KEY (id_contenido, id_usuario, id_perfil),
    FOREIGN KEY (id_usuario, id_perfil) REFERENCES
        Perfil(id_usuario, id_perfil)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

CREATE TABLE Visualizacion(
    id_contenido INT REFERENCES
        Contenido(id_contenido)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    id_usuario INT,
    id_perfil INT,
    calificacion Calificacion,
    PRIMARY KEY (id_contenido, id_usuario, id_perfil),
    FOREIGN KEY (id_usuario, id_perfil) REFERENCES
        Perfil(id_usuario, id_perfil)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

CREATE TABLE Tiene(
    id_genero INT REFERENCES
        Genero(id_genero)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    id_contenido INT REFERENCES
        Contenido(id_contenido)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    PRIMARY KEY (id_genero, id_contenido)
);
