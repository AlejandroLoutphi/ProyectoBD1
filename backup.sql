PGDMP  4    %            
    |            test    17.0    17.0 �    �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                           false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                           false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                           false            �           1262    83471    test    DATABASE        CREATE DATABASE test WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'English_United States.1252';
    DROP DATABASE test;
                     postgres    false            |           1247    83494    biguint    DOMAIN     W   CREATE DOMAIN public.biguint AS bigint
	CONSTRAINT biguint_check CHECK ((VALUE >= 0));
    DROP DOMAIN public.biguint;
       public               postgres    false            t           1247    83488    calificacion    DOMAIN     u   CREATE DOMAIN public.calificacion AS integer
	CONSTRAINT calificacion_check CHECK (((VALUE >= 1) AND (VALUE <= 5)));
 !   DROP DOMAIN public.calificacion;
       public               postgres    false            n           1247    83473    sexo    TYPE     A   CREATE TYPE public.sexo AS ENUM (
    'M',
    'F',
    'N/A'
);
    DROP TYPE public.sexo;
       public               postgres    false            q           1247    83480    tipo    TYPE     J   CREATE TYPE public.tipo AS ENUM (
    'Gold',
    'Premium',
    'VIP'
);
    DROP TYPE public.tipo;
       public               postgres    false            x           1247    83491    uint    DOMAIN     R   CREATE DOMAIN public.uint AS integer
	CONSTRAINT uint_check CHECK ((VALUE >= 0));
    DROP DOMAIN public.uint;
       public               postgres    false            �            1255    83739    inc_perfil_id_fn()    FUNCTION     &  CREATE FUNCTION public.inc_perfil_id_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF ((SELECT count(*) FROM Perfil P WHERE P.id_usuario = NEW.id_usuario) >= 5) THEN
        RAISE EXCEPTION 'Solo pueden haber hasta 5 perfiles por usuario.';
    END IF;
    RETURN NEW;
END;
$$;
 )   DROP FUNCTION public.inc_perfil_id_fn();
       public               postgres    false            �            1255    83741    no_peli_en_serie_fn()    FUNCTION     *  CREATE FUNCTION public.no_peli_en_serie_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF ((SELECT count(*) FROM Serie WHERE id_contenido = NEW.id_contenido) > 0) THEN
        RAISE EXCEPTION 'Un contenido puede ser serie o pelicula. No ambos.';
    END IF;
    RETURN NEW;
END;
$$;
 ,   DROP FUNCTION public.no_peli_en_serie_fn();
       public               postgres    false            �            1255    83743    no_serie_en_peli_fn()    FUNCTION     -  CREATE FUNCTION public.no_serie_en_peli_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF ((SELECT count(*) FROM Pelicula WHERE id_contenido = NEW.id_contenido) > 0) THEN
        RAISE EXCEPTION 'Un contenido puede ser serie o pelicula. No ambos.';
    END IF;
    RETURN NEW;
END;
$$;
 ,   DROP FUNCTION public.no_serie_en_peli_fn();
       public               postgres    false            �            1255    83745    upd_num_episodios_serie()    FUNCTION     D  CREATE FUNCTION public.upd_num_episodios_serie() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE Serie S
    SET num_episodios = (SELECT count(*) FROM Episodio E WHERE E.id_contenido = S.id_contenido)
    WHERE S.id_contenido = NEW.id_contenido OR S.id_contenido = OLD.id_contenido;
    RETURN NEW;
END;
$$;
 0   DROP FUNCTION public.upd_num_episodios_serie();
       public               postgres    false            �            1259    83658    actor    TABLE     �   CREATE TABLE public.actor (
    id_actor integer NOT NULL,
    nombre character varying(128) NOT NULL,
    sexo public.sexo,
    annio_debut public.uint
);
    DROP TABLE public.actor;
       public         heap r       postgres    false    878    888            �            1259    83657    actor_id_actor_seq    SEQUENCE     �   CREATE SEQUENCE public.actor_id_actor_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.actor_id_actor_seq;
       public               postgres    false    240            �           0    0    actor_id_actor_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.actor_id_actor_seq OWNED BY public.actor.id_actor;
          public               postgres    false    239            �            1259    83664    actua    TABLE     �   CREATE TABLE public.actua (
    id_actor integer NOT NULL,
    id_contenido integer NOT NULL,
    premios boolean,
    es_protagonista boolean
);
    DROP TABLE public.actua;
       public         heap r       postgres    false            �            1259    83506    ciudad    TABLE     �   CREATE TABLE public.ciudad (
    id_ciudad integer NOT NULL,
    nombre character varying(128) NOT NULL,
    descripcion character varying(2048),
    id_pais integer
);
    DROP TABLE public.ciudad;
       public         heap r       postgres    false            �            1259    83505    ciudad_id_ciudad_seq    SEQUENCE     �   CREATE SEQUENCE public.ciudad_id_ciudad_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.ciudad_id_ciudad_seq;
       public               postgres    false    220            �           0    0    ciudad_id_ciudad_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE public.ciudad_id_ciudad_seq OWNED BY public.ciudad.id_ciudad;
          public               postgres    false    219            �            1259    83598 	   contenido    TABLE     �   CREATE TABLE public.contenido (
    id_contenido integer NOT NULL,
    annio_lanzamiento public.uint,
    nombre character varying(128) NOT NULL,
    es_contenido_original boolean
);
    DROP TABLE public.contenido;
       public         heap r       postgres    false    888            �            1259    83597    contenido_id_contenido_seq    SEQUENCE     �   CREATE SEQUENCE public.contenido_id_contenido_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE public.contenido_id_contenido_seq;
       public               postgres    false    232            �           0    0    contenido_id_contenido_seq    SEQUENCE OWNED BY     Y   ALTER SEQUENCE public.contenido_id_contenido_seq OWNED BY public.contenido.id_contenido;
          public               postgres    false    231            �            1259    83582    contrata    TABLE     �   CREATE TABLE public.contrata (
    id_usuario integer NOT NULL,
    id_suscripcion integer NOT NULL,
    fecha_inicio date NOT NULL,
    fecha_fin date
);
    DROP TABLE public.contrata;
       public         heap r       postgres    false            �            1259    83644    episodio    TABLE     �   CREATE TABLE public.episodio (
    id_contenido integer NOT NULL,
    id_temporada integer NOT NULL,
    id_episodio integer NOT NULL,
    numero public.uint,
    nombre character varying(128),
    descripcion character varying(2048)
);
    DROP TABLE public.episodio;
       public         heap r       postgres    false    888            �            1259    83643    episodio_id_episodio_seq    SEQUENCE     �   CREATE SEQUENCE public.episodio_id_episodio_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.episodio_id_episodio_seq;
       public               postgres    false    238            �           0    0    episodio_id_episodio_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public.episodio_id_episodio_seq OWNED BY public.episodio.id_episodio;
          public               postgres    false    237            �            1259    83550    genero    TABLE     �   CREATE TABLE public.genero (
    id_genero integer NOT NULL,
    nombre character varying(128) NOT NULL,
    descripcion character varying(2048)
);
    DROP TABLE public.genero;
       public         heap r       postgres    false            �            1259    83549    genero_id_genero_seq    SEQUENCE     �   CREATE SEQUENCE public.genero_id_genero_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.genero_id_genero_seq;
       public               postgres    false    226            �           0    0    genero_id_genero_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE public.genero_id_genero_seq OWNED BY public.genero.id_genero;
          public               postgres    false    225            �            1259    83497    pais    TABLE     �   CREATE TABLE public.pais (
    id_pais integer NOT NULL,
    nombre character varying(128) NOT NULL,
    descripcion character varying(2048)
);
    DROP TABLE public.pais;
       public         heap r       postgres    false            �            1259    83496    pais_id_pais_seq    SEQUENCE     �   CREATE SEQUENCE public.pais_id_pais_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.pais_id_pais_seq;
       public               postgres    false    218            �           0    0    pais_id_pais_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.pais_id_pais_seq OWNED BY public.pais.id_pais;
          public               postgres    false    217            �            1259    83604    pelicula    TABLE     �   CREATE TABLE public.pelicula (
    id_contenido integer NOT NULL,
    mins_duracion public.uint,
    ganadora_premios boolean,
    sinopsis character varying(2048)
);
    DROP TABLE public.pelicula;
       public         heap r       postgres    false    888            �            1259    83538    perfil    TABLE     �   CREATE TABLE public.perfil (
    id_usuario integer NOT NULL,
    id_perfil integer NOT NULL,
    nombre character varying(128) NOT NULL,
    email character varying(128),
    preferencias_idioma character varying(128)
);
    DROP TABLE public.perfil;
       public         heap r       postgres    false            �            1259    83537    perfil_id_perfil_seq    SEQUENCE     �   CREATE SEQUENCE public.perfil_id_perfil_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.perfil_id_perfil_seq;
       public               postgres    false    224            �           0    0    perfil_id_perfil_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE public.perfil_id_perfil_seq OWNED BY public.perfil.id_perfil;
          public               postgres    false    223            �            1259    83558    prefiere    TABLE     �   CREATE TABLE public.prefiere (
    id_usuario integer NOT NULL,
    id_perfil integer NOT NULL,
    id_genero integer NOT NULL
);
    DROP TABLE public.prefiere;
       public         heap r       postgres    false            �            1259    83694    recomendada    TABLE     �   CREATE TABLE public.recomendada (
    id_contenido integer NOT NULL,
    id_usuario integer NOT NULL,
    id_perfil integer NOT NULL
);
    DROP TABLE public.recomendada;
       public         heap r       postgres    false            �            1259    83679    requiere    TABLE     i   CREATE TABLE public.requiere (
    id_contenido integer NOT NULL,
    id_suscripcion integer NOT NULL
);
    DROP TABLE public.requiere;
       public         heap r       postgres    false            �            1259    83616    serie    TABLE     �   CREATE TABLE public.serie (
    id_contenido integer NOT NULL,
    num_episodios public.uint DEFAULT 0,
    descripcion character varying(2048)
);
    DROP TABLE public.serie;
       public         heap r       postgres    false    888    888            �            1259    83574    suscripcion    TABLE     �   CREATE TABLE public.suscripcion (
    id_suscripcion integer NOT NULL,
    tipo public.tipo,
    nombre character varying(128) NOT NULL,
    descripcion character varying(2048),
    tarifa public.uint
);
    DROP TABLE public.suscripcion;
       public         heap r       postgres    false    881    888            �            1259    83573    suscripcion_id_suscripcion_seq    SEQUENCE     �   CREATE SEQUENCE public.suscripcion_id_suscripcion_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 5   DROP SEQUENCE public.suscripcion_id_suscripcion_seq;
       public               postgres    false    229            �           0    0    suscripcion_id_suscripcion_seq    SEQUENCE OWNED BY     a   ALTER SEQUENCE public.suscripcion_id_suscripcion_seq OWNED BY public.suscripcion.id_suscripcion;
          public               postgres    false    228            �            1259    83630 	   temporada    TABLE     �   CREATE TABLE public.temporada (
    id_contenido integer NOT NULL,
    id_temporada integer NOT NULL,
    numero public.uint,
    descripcion character varying(2048)
);
    DROP TABLE public.temporada;
       public         heap r       postgres    false    888            �            1259    83629    temporada_id_temporada_seq    SEQUENCE     �   CREATE SEQUENCE public.temporada_id_temporada_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE public.temporada_id_temporada_seq;
       public               postgres    false    236            �           0    0    temporada_id_temporada_seq    SEQUENCE OWNED BY     Y   ALTER SEQUENCE public.temporada_id_temporada_seq OWNED BY public.temporada.id_temporada;
          public               postgres    false    235            �            1259    83724    tiene    TABLE     a   CREATE TABLE public.tiene (
    id_genero integer NOT NULL,
    id_contenido integer NOT NULL
);
    DROP TABLE public.tiene;
       public         heap r       postgres    false            �            1259    83520    usuario    TABLE     �  CREATE TABLE public.usuario (
    id_usuario integer NOT NULL,
    sexo public.sexo,
    nombre character varying(128) NOT NULL,
    email character varying(128) NOT NULL,
    fecha_nacimiento date,
    nombre_usuario character varying(128) NOT NULL,
    contrasena character varying(128) NOT NULL,
    tarjeta public.biguint,
    apellido character varying(128),
    id_ciudad integer
);
    DROP TABLE public.usuario;
       public         heap r       postgres    false    892    878            �            1259    83519    usuario_id_usuario_seq    SEQUENCE     �   CREATE SEQUENCE public.usuario_id_usuario_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public.usuario_id_usuario_seq;
       public               postgres    false    222            �           0    0    usuario_id_usuario_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public.usuario_id_usuario_seq OWNED BY public.usuario.id_usuario;
          public               postgres    false    221            �            1259    83709    visualizacion    TABLE     �   CREATE TABLE public.visualizacion (
    id_contenido integer NOT NULL,
    id_usuario integer NOT NULL,
    id_perfil integer NOT NULL,
    calificacion public.calificacion
);
 !   DROP TABLE public.visualizacion;
       public         heap r       postgres    false    884            �           2604    83661    actor id_actor    DEFAULT     p   ALTER TABLE ONLY public.actor ALTER COLUMN id_actor SET DEFAULT nextval('public.actor_id_actor_seq'::regclass);
 =   ALTER TABLE public.actor ALTER COLUMN id_actor DROP DEFAULT;
       public               postgres    false    240    239    240            �           2604    83509    ciudad id_ciudad    DEFAULT     t   ALTER TABLE ONLY public.ciudad ALTER COLUMN id_ciudad SET DEFAULT nextval('public.ciudad_id_ciudad_seq'::regclass);
 ?   ALTER TABLE public.ciudad ALTER COLUMN id_ciudad DROP DEFAULT;
       public               postgres    false    220    219    220            �           2604    83601    contenido id_contenido    DEFAULT     �   ALTER TABLE ONLY public.contenido ALTER COLUMN id_contenido SET DEFAULT nextval('public.contenido_id_contenido_seq'::regclass);
 E   ALTER TABLE public.contenido ALTER COLUMN id_contenido DROP DEFAULT;
       public               postgres    false    232    231    232            �           2604    83647    episodio id_episodio    DEFAULT     |   ALTER TABLE ONLY public.episodio ALTER COLUMN id_episodio SET DEFAULT nextval('public.episodio_id_episodio_seq'::regclass);
 C   ALTER TABLE public.episodio ALTER COLUMN id_episodio DROP DEFAULT;
       public               postgres    false    238    237    238            �           2604    83553    genero id_genero    DEFAULT     t   ALTER TABLE ONLY public.genero ALTER COLUMN id_genero SET DEFAULT nextval('public.genero_id_genero_seq'::regclass);
 ?   ALTER TABLE public.genero ALTER COLUMN id_genero DROP DEFAULT;
       public               postgres    false    225    226    226            �           2604    83500    pais id_pais    DEFAULT     l   ALTER TABLE ONLY public.pais ALTER COLUMN id_pais SET DEFAULT nextval('public.pais_id_pais_seq'::regclass);
 ;   ALTER TABLE public.pais ALTER COLUMN id_pais DROP DEFAULT;
       public               postgres    false    217    218    218            �           2604    83541    perfil id_perfil    DEFAULT     t   ALTER TABLE ONLY public.perfil ALTER COLUMN id_perfil SET DEFAULT nextval('public.perfil_id_perfil_seq'::regclass);
 ?   ALTER TABLE public.perfil ALTER COLUMN id_perfil DROP DEFAULT;
       public               postgres    false    223    224    224            �           2604    83577    suscripcion id_suscripcion    DEFAULT     �   ALTER TABLE ONLY public.suscripcion ALTER COLUMN id_suscripcion SET DEFAULT nextval('public.suscripcion_id_suscripcion_seq'::regclass);
 I   ALTER TABLE public.suscripcion ALTER COLUMN id_suscripcion DROP DEFAULT;
       public               postgres    false    228    229    229            �           2604    83633    temporada id_temporada    DEFAULT     �   ALTER TABLE ONLY public.temporada ALTER COLUMN id_temporada SET DEFAULT nextval('public.temporada_id_temporada_seq'::regclass);
 E   ALTER TABLE public.temporada ALTER COLUMN id_temporada DROP DEFAULT;
       public               postgres    false    235    236    236            �           2604    83523    usuario id_usuario    DEFAULT     x   ALTER TABLE ONLY public.usuario ALTER COLUMN id_usuario SET DEFAULT nextval('public.usuario_id_usuario_seq'::regclass);
 A   ALTER TABLE public.usuario ALTER COLUMN id_usuario DROP DEFAULT;
       public               postgres    false    222    221    222            �          0    83658    actor 
   TABLE DATA           D   COPY public.actor (id_actor, nombre, sexo, annio_debut) FROM stdin;
    public               postgres    false    240   ֮       �          0    83664    actua 
   TABLE DATA           Q   COPY public.actua (id_actor, id_contenido, premios, es_protagonista) FROM stdin;
    public               postgres    false    241   �       �          0    83506    ciudad 
   TABLE DATA           I   COPY public.ciudad (id_ciudad, nombre, descripcion, id_pais) FROM stdin;
    public               postgres    false    220   _�       �          0    83598 	   contenido 
   TABLE DATA           c   COPY public.contenido (id_contenido, annio_lanzamiento, nombre, es_contenido_original) FROM stdin;
    public               postgres    false    232   p�       �          0    83582    contrata 
   TABLE DATA           W   COPY public.contrata (id_usuario, id_suscripcion, fecha_inicio, fecha_fin) FROM stdin;
    public               postgres    false    230   �       �          0    83644    episodio 
   TABLE DATA           h   COPY public.episodio (id_contenido, id_temporada, id_episodio, numero, nombre, descripcion) FROM stdin;
    public               postgres    false    238   L�       �          0    83550    genero 
   TABLE DATA           @   COPY public.genero (id_genero, nombre, descripcion) FROM stdin;
    public               postgres    false    226   ��      �          0    83497    pais 
   TABLE DATA           <   COPY public.pais (id_pais, nombre, descripcion) FROM stdin;
    public               postgres    false    218   ��      �          0    83604    pelicula 
   TABLE DATA           [   COPY public.pelicula (id_contenido, mins_duracion, ganadora_premios, sinopsis) FROM stdin;
    public               postgres    false    233   !�      �          0    83538    perfil 
   TABLE DATA           [   COPY public.perfil (id_usuario, id_perfil, nombre, email, preferencias_idioma) FROM stdin;
    public               postgres    false    224   ��      �          0    83558    prefiere 
   TABLE DATA           D   COPY public.prefiere (id_usuario, id_perfil, id_genero) FROM stdin;
    public               postgres    false    227   :�      �          0    83694    recomendada 
   TABLE DATA           J   COPY public.recomendada (id_contenido, id_usuario, id_perfil) FROM stdin;
    public               postgres    false    243   ��      �          0    83679    requiere 
   TABLE DATA           @   COPY public.requiere (id_contenido, id_suscripcion) FROM stdin;
    public               postgres    false    242   [�      �          0    83616    serie 
   TABLE DATA           I   COPY public.serie (id_contenido, num_episodios, descripcion) FROM stdin;
    public               postgres    false    234   ��      �          0    83574    suscripcion 
   TABLE DATA           X   COPY public.suscripcion (id_suscripcion, tipo, nombre, descripcion, tarifa) FROM stdin;
    public               postgres    false    229   x�      �          0    83630 	   temporada 
   TABLE DATA           T   COPY public.temporada (id_contenido, id_temporada, numero, descripcion) FROM stdin;
    public               postgres    false    236   ��      �          0    83724    tiene 
   TABLE DATA           8   COPY public.tiene (id_genero, id_contenido) FROM stdin;
    public               postgres    false    245   ��      �          0    83520    usuario 
   TABLE DATA           �   COPY public.usuario (id_usuario, sexo, nombre, email, fecha_nacimiento, nombre_usuario, contrasena, tarjeta, apellido, id_ciudad) FROM stdin;
    public               postgres    false    222   8�      �          0    83709    visualizacion 
   TABLE DATA           Z   COPY public.visualizacion (id_contenido, id_usuario, id_perfil, calificacion) FROM stdin;
    public               postgres    false    244   =�      �           0    0    actor_id_actor_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.actor_id_actor_seq', 76, true);
          public               postgres    false    239            �           0    0    ciudad_id_ciudad_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.ciudad_id_ciudad_seq', 100, true);
          public               postgres    false    219            �           0    0    contenido_id_contenido_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('public.contenido_id_contenido_seq', 41, true);
          public               postgres    false    231            �           0    0    episodio_id_episodio_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.episodio_id_episodio_seq', 960, true);
          public               postgres    false    237            �           0    0    genero_id_genero_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.genero_id_genero_seq', 13, true);
          public               postgres    false    225            �           0    0    pais_id_pais_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.pais_id_pais_seq', 20, true);
          public               postgres    false    217            �           0    0    perfil_id_perfil_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.perfil_id_perfil_seq', 60, true);
          public               postgres    false    223            �           0    0    suscripcion_id_suscripcion_seq    SEQUENCE SET     L   SELECT pg_catalog.setval('public.suscripcion_id_suscripcion_seq', 3, true);
          public               postgres    false    228            �           0    0    temporada_id_temporada_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('public.temporada_id_temporada_seq', 50, true);
          public               postgres    false    235            �           0    0    usuario_id_usuario_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.usuario_id_usuario_seq', 30, true);
          public               postgres    false    221            �           2606    83663    actor actor_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.actor
    ADD CONSTRAINT actor_pkey PRIMARY KEY (id_actor);
 :   ALTER TABLE ONLY public.actor DROP CONSTRAINT actor_pkey;
       public                 postgres    false    240            �           2606    83668    actua actua_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY public.actua
    ADD CONSTRAINT actua_pkey PRIMARY KEY (id_actor, id_contenido);
 :   ALTER TABLE ONLY public.actua DROP CONSTRAINT actua_pkey;
       public                 postgres    false    241    241            �           2606    83513    ciudad ciudad_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY public.ciudad
    ADD CONSTRAINT ciudad_pkey PRIMARY KEY (id_ciudad);
 <   ALTER TABLE ONLY public.ciudad DROP CONSTRAINT ciudad_pkey;
       public                 postgres    false    220            �           2606    83603    contenido contenido_pkey 
   CONSTRAINT     `   ALTER TABLE ONLY public.contenido
    ADD CONSTRAINT contenido_pkey PRIMARY KEY (id_contenido);
 B   ALTER TABLE ONLY public.contenido DROP CONSTRAINT contenido_pkey;
       public                 postgres    false    232            �           2606    83586    contrata contrata_pkey 
   CONSTRAINT     z   ALTER TABLE ONLY public.contrata
    ADD CONSTRAINT contrata_pkey PRIMARY KEY (id_usuario, id_suscripcion, fecha_inicio);
 @   ALTER TABLE ONLY public.contrata DROP CONSTRAINT contrata_pkey;
       public                 postgres    false    230    230    230            �           2606    83651    episodio episodio_pkey 
   CONSTRAINT     y   ALTER TABLE ONLY public.episodio
    ADD CONSTRAINT episodio_pkey PRIMARY KEY (id_contenido, id_temporada, id_episodio);
 @   ALTER TABLE ONLY public.episodio DROP CONSTRAINT episodio_pkey;
       public                 postgres    false    238    238    238            �           2606    83557    genero genero_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY public.genero
    ADD CONSTRAINT genero_pkey PRIMARY KEY (id_genero);
 <   ALTER TABLE ONLY public.genero DROP CONSTRAINT genero_pkey;
       public                 postgres    false    226            �           2606    83504    pais pais_pkey 
   CONSTRAINT     Q   ALTER TABLE ONLY public.pais
    ADD CONSTRAINT pais_pkey PRIMARY KEY (id_pais);
 8   ALTER TABLE ONLY public.pais DROP CONSTRAINT pais_pkey;
       public                 postgres    false    218            �           2606    83610    pelicula pelicula_pkey 
   CONSTRAINT     ^   ALTER TABLE ONLY public.pelicula
    ADD CONSTRAINT pelicula_pkey PRIMARY KEY (id_contenido);
 @   ALTER TABLE ONLY public.pelicula DROP CONSTRAINT pelicula_pkey;
       public                 postgres    false    233            �           2606    83543    perfil perfil_pkey 
   CONSTRAINT     c   ALTER TABLE ONLY public.perfil
    ADD CONSTRAINT perfil_pkey PRIMARY KEY (id_usuario, id_perfil);
 <   ALTER TABLE ONLY public.perfil DROP CONSTRAINT perfil_pkey;
       public                 postgres    false    224    224            �           2606    83562    prefiere prefiere_pkey 
   CONSTRAINT     r   ALTER TABLE ONLY public.prefiere
    ADD CONSTRAINT prefiere_pkey PRIMARY KEY (id_usuario, id_perfil, id_genero);
 @   ALTER TABLE ONLY public.prefiere DROP CONSTRAINT prefiere_pkey;
       public                 postgres    false    227    227    227            �           2606    83698    recomendada recomendada_pkey 
   CONSTRAINT     {   ALTER TABLE ONLY public.recomendada
    ADD CONSTRAINT recomendada_pkey PRIMARY KEY (id_contenido, id_usuario, id_perfil);
 F   ALTER TABLE ONLY public.recomendada DROP CONSTRAINT recomendada_pkey;
       public                 postgres    false    243    243    243            �           2606    83683    requiere requiere_pkey 
   CONSTRAINT     n   ALTER TABLE ONLY public.requiere
    ADD CONSTRAINT requiere_pkey PRIMARY KEY (id_contenido, id_suscripcion);
 @   ALTER TABLE ONLY public.requiere DROP CONSTRAINT requiere_pkey;
       public                 postgres    false    242    242            �           2606    83623    serie serie_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.serie
    ADD CONSTRAINT serie_pkey PRIMARY KEY (id_contenido);
 :   ALTER TABLE ONLY public.serie DROP CONSTRAINT serie_pkey;
       public                 postgres    false    234            �           2606    83581    suscripcion suscripcion_pkey 
   CONSTRAINT     f   ALTER TABLE ONLY public.suscripcion
    ADD CONSTRAINT suscripcion_pkey PRIMARY KEY (id_suscripcion);
 F   ALTER TABLE ONLY public.suscripcion DROP CONSTRAINT suscripcion_pkey;
       public                 postgres    false    229            �           2606    83637    temporada temporada_pkey 
   CONSTRAINT     n   ALTER TABLE ONLY public.temporada
    ADD CONSTRAINT temporada_pkey PRIMARY KEY (id_contenido, id_temporada);
 B   ALTER TABLE ONLY public.temporada DROP CONSTRAINT temporada_pkey;
       public                 postgres    false    236    236            �           2606    83728    tiene tiene_pkey 
   CONSTRAINT     c   ALTER TABLE ONLY public.tiene
    ADD CONSTRAINT tiene_pkey PRIMARY KEY (id_genero, id_contenido);
 :   ALTER TABLE ONLY public.tiene DROP CONSTRAINT tiene_pkey;
       public                 postgres    false    245    245            �           2606    83529    usuario usuario_email_key 
   CONSTRAINT     U   ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_email_key UNIQUE (email);
 C   ALTER TABLE ONLY public.usuario DROP CONSTRAINT usuario_email_key;
       public                 postgres    false    222            �           2606    83531 "   usuario usuario_nombre_usuario_key 
   CONSTRAINT     g   ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_nombre_usuario_key UNIQUE (nombre_usuario);
 L   ALTER TABLE ONLY public.usuario DROP CONSTRAINT usuario_nombre_usuario_key;
       public                 postgres    false    222            �           2606    83527    usuario usuario_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_pkey PRIMARY KEY (id_usuario);
 >   ALTER TABLE ONLY public.usuario DROP CONSTRAINT usuario_pkey;
       public                 postgres    false    222            �           2606    83713     visualizacion visualizacion_pkey 
   CONSTRAINT        ALTER TABLE ONLY public.visualizacion
    ADD CONSTRAINT visualizacion_pkey PRIMARY KEY (id_contenido, id_usuario, id_perfil);
 J   ALTER TABLE ONLY public.visualizacion DROP CONSTRAINT visualizacion_pkey;
       public                 postgres    false    244    244    244                       2620    83740    perfil inc_perfil_id    TRIGGER     u   CREATE TRIGGER inc_perfil_id BEFORE INSERT ON public.perfil FOR EACH ROW EXECUTE FUNCTION public.inc_perfil_id_fn();
 -   DROP TRIGGER inc_perfil_id ON public.perfil;
       public               postgres    false    224    246            	           2620    83742    pelicula no_peli_en_serie    TRIGGER     }   CREATE TRIGGER no_peli_en_serie BEFORE INSERT ON public.pelicula FOR EACH ROW EXECUTE FUNCTION public.no_peli_en_serie_fn();
 2   DROP TRIGGER no_peli_en_serie ON public.pelicula;
       public               postgres    false    233    247            
           2620    83744    serie no_serie_en_peli    TRIGGER     z   CREATE TRIGGER no_serie_en_peli BEFORE INSERT ON public.serie FOR EACH ROW EXECUTE FUNCTION public.no_serie_en_peli_fn();
 /   DROP TRIGGER no_serie_en_peli ON public.serie;
       public               postgres    false    248    234                       2620    83746     episodio upd_num_episodios_serie    TRIGGER     �   CREATE TRIGGER upd_num_episodios_serie AFTER INSERT OR DELETE OR UPDATE OF id_contenido ON public.episodio FOR EACH ROW EXECUTE FUNCTION public.upd_num_episodios_serie();
 9   DROP TRIGGER upd_num_episodios_serie ON public.episodio;
       public               postgres    false    238    249    238            �           2606    83669    actua actua_id_actor_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.actua
    ADD CONSTRAINT actua_id_actor_fkey FOREIGN KEY (id_actor) REFERENCES public.actor(id_actor) ON UPDATE CASCADE ON DELETE CASCADE;
 C   ALTER TABLE ONLY public.actua DROP CONSTRAINT actua_id_actor_fkey;
       public               postgres    false    241    240    4840            �           2606    83674    actua actua_id_contenido_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.actua
    ADD CONSTRAINT actua_id_contenido_fkey FOREIGN KEY (id_contenido) REFERENCES public.contenido(id_contenido) ON UPDATE CASCADE ON DELETE CASCADE;
 G   ALTER TABLE ONLY public.actua DROP CONSTRAINT actua_id_contenido_fkey;
       public               postgres    false    232    4830    241            �           2606    83514    ciudad ciudad_id_pais_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.ciudad
    ADD CONSTRAINT ciudad_id_pais_fkey FOREIGN KEY (id_pais) REFERENCES public.pais(id_pais) ON UPDATE CASCADE ON DELETE CASCADE;
 D   ALTER TABLE ONLY public.ciudad DROP CONSTRAINT ciudad_id_pais_fkey;
       public               postgres    false    220    218    4810            �           2606    83592 %   contrata contrata_id_suscripcion_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.contrata
    ADD CONSTRAINT contrata_id_suscripcion_fkey FOREIGN KEY (id_suscripcion) REFERENCES public.suscripcion(id_suscripcion) ON UPDATE CASCADE ON DELETE CASCADE;
 O   ALTER TABLE ONLY public.contrata DROP CONSTRAINT contrata_id_suscripcion_fkey;
       public               postgres    false    230    4826    229            �           2606    83587 !   contrata contrata_id_usuario_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.contrata
    ADD CONSTRAINT contrata_id_usuario_fkey FOREIGN KEY (id_usuario) REFERENCES public.usuario(id_usuario) ON UPDATE CASCADE ON DELETE CASCADE;
 K   ALTER TABLE ONLY public.contrata DROP CONSTRAINT contrata_id_usuario_fkey;
       public               postgres    false    222    230    4818            �           2606    83652 0   episodio episodio_id_contenido_id_temporada_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.episodio
    ADD CONSTRAINT episodio_id_contenido_id_temporada_fkey FOREIGN KEY (id_contenido, id_temporada) REFERENCES public.temporada(id_contenido, id_temporada) ON UPDATE CASCADE ON DELETE CASCADE;
 Z   ALTER TABLE ONLY public.episodio DROP CONSTRAINT episodio_id_contenido_id_temporada_fkey;
       public               postgres    false    238    238    4836    236    236            �           2606    83611 #   pelicula pelicula_id_contenido_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.pelicula
    ADD CONSTRAINT pelicula_id_contenido_fkey FOREIGN KEY (id_contenido) REFERENCES public.contenido(id_contenido) ON UPDATE CASCADE ON DELETE CASCADE;
 M   ALTER TABLE ONLY public.pelicula DROP CONSTRAINT pelicula_id_contenido_fkey;
       public               postgres    false    233    232    4830            �           2606    83544    perfil perfil_id_usuario_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.perfil
    ADD CONSTRAINT perfil_id_usuario_fkey FOREIGN KEY (id_usuario) REFERENCES public.usuario(id_usuario) ON UPDATE CASCADE ON DELETE CASCADE;
 G   ALTER TABLE ONLY public.perfil DROP CONSTRAINT perfil_id_usuario_fkey;
       public               postgres    false    4818    222    224            �           2606    83563     prefiere prefiere_id_genero_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.prefiere
    ADD CONSTRAINT prefiere_id_genero_fkey FOREIGN KEY (id_genero) REFERENCES public.genero(id_genero) ON UPDATE CASCADE ON DELETE CASCADE;
 J   ALTER TABLE ONLY public.prefiere DROP CONSTRAINT prefiere_id_genero_fkey;
       public               postgres    false    226    227    4822            �           2606    83568 +   prefiere prefiere_id_usuario_id_perfil_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.prefiere
    ADD CONSTRAINT prefiere_id_usuario_id_perfil_fkey FOREIGN KEY (id_usuario, id_perfil) REFERENCES public.perfil(id_usuario, id_perfil) ON UPDATE CASCADE ON DELETE CASCADE;
 U   ALTER TABLE ONLY public.prefiere DROP CONSTRAINT prefiere_id_usuario_id_perfil_fkey;
       public               postgres    false    224    227    227    4820    224                       2606    83699 )   recomendada recomendada_id_contenido_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.recomendada
    ADD CONSTRAINT recomendada_id_contenido_fkey FOREIGN KEY (id_contenido) REFERENCES public.contenido(id_contenido) ON UPDATE CASCADE ON DELETE CASCADE;
 S   ALTER TABLE ONLY public.recomendada DROP CONSTRAINT recomendada_id_contenido_fkey;
       public               postgres    false    243    4830    232                       2606    83704 1   recomendada recomendada_id_usuario_id_perfil_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.recomendada
    ADD CONSTRAINT recomendada_id_usuario_id_perfil_fkey FOREIGN KEY (id_usuario, id_perfil) REFERENCES public.perfil(id_usuario, id_perfil) ON UPDATE CASCADE ON DELETE CASCADE;
 [   ALTER TABLE ONLY public.recomendada DROP CONSTRAINT recomendada_id_usuario_id_perfil_fkey;
       public               postgres    false    4820    243    243    224    224                        2606    83684 #   requiere requiere_id_contenido_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.requiere
    ADD CONSTRAINT requiere_id_contenido_fkey FOREIGN KEY (id_contenido) REFERENCES public.contenido(id_contenido) ON UPDATE CASCADE ON DELETE CASCADE;
 M   ALTER TABLE ONLY public.requiere DROP CONSTRAINT requiere_id_contenido_fkey;
       public               postgres    false    242    232    4830                       2606    83689 %   requiere requiere_id_suscripcion_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.requiere
    ADD CONSTRAINT requiere_id_suscripcion_fkey FOREIGN KEY (id_suscripcion) REFERENCES public.suscripcion(id_suscripcion) ON UPDATE CASCADE ON DELETE CASCADE;
 O   ALTER TABLE ONLY public.requiere DROP CONSTRAINT requiere_id_suscripcion_fkey;
       public               postgres    false    229    4826    242            �           2606    83624    serie serie_id_contenido_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.serie
    ADD CONSTRAINT serie_id_contenido_fkey FOREIGN KEY (id_contenido) REFERENCES public.contenido(id_contenido) ON UPDATE CASCADE ON DELETE CASCADE;
 G   ALTER TABLE ONLY public.serie DROP CONSTRAINT serie_id_contenido_fkey;
       public               postgres    false    232    4830    234            �           2606    83638 %   temporada temporada_id_contenido_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.temporada
    ADD CONSTRAINT temporada_id_contenido_fkey FOREIGN KEY (id_contenido) REFERENCES public.serie(id_contenido) ON UPDATE CASCADE ON DELETE CASCADE;
 O   ALTER TABLE ONLY public.temporada DROP CONSTRAINT temporada_id_contenido_fkey;
       public               postgres    false    236    4834    234                       2606    83734    tiene tiene_id_contenido_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.tiene
    ADD CONSTRAINT tiene_id_contenido_fkey FOREIGN KEY (id_contenido) REFERENCES public.contenido(id_contenido) ON UPDATE CASCADE ON DELETE CASCADE;
 G   ALTER TABLE ONLY public.tiene DROP CONSTRAINT tiene_id_contenido_fkey;
       public               postgres    false    245    232    4830                       2606    83729    tiene tiene_id_genero_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.tiene
    ADD CONSTRAINT tiene_id_genero_fkey FOREIGN KEY (id_genero) REFERENCES public.genero(id_genero) ON UPDATE CASCADE ON DELETE CASCADE;
 D   ALTER TABLE ONLY public.tiene DROP CONSTRAINT tiene_id_genero_fkey;
       public               postgres    false    226    4822    245            �           2606    83532    usuario usuario_id_ciudad_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_id_ciudad_fkey FOREIGN KEY (id_ciudad) REFERENCES public.ciudad(id_ciudad) ON UPDATE CASCADE ON DELETE CASCADE;
 H   ALTER TABLE ONLY public.usuario DROP CONSTRAINT usuario_id_ciudad_fkey;
       public               postgres    false    220    4812    222                       2606    83714 -   visualizacion visualizacion_id_contenido_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.visualizacion
    ADD CONSTRAINT visualizacion_id_contenido_fkey FOREIGN KEY (id_contenido) REFERENCES public.contenido(id_contenido) ON UPDATE CASCADE ON DELETE CASCADE;
 W   ALTER TABLE ONLY public.visualizacion DROP CONSTRAINT visualizacion_id_contenido_fkey;
       public               postgres    false    4830    244    232                       2606    83719 5   visualizacion visualizacion_id_usuario_id_perfil_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.visualizacion
    ADD CONSTRAINT visualizacion_id_usuario_id_perfil_fkey FOREIGN KEY (id_usuario, id_perfil) REFERENCES public.perfil(id_usuario, id_perfil) ON UPDATE CASCADE ON DELETE CASCADE;
 _   ALTER TABLE ONLY public.visualizacion DROP CONSTRAINT visualizacion_id_usuario_id_perfil_fkey;
       public               postgres    false    224    224    4820    244    244            �   8  x�MU�r�6<�?��\��J��U9+Ūr�2&�$J$���d�/�1��ANɏ�� e��Gw�lHg쬑�xliOaQ"���;y��r � E��{6U{B�b������sg�ɣ�H���?��{��*ն�%"��`��=��
�ә��z�W�Z���m����%;�����1%?���+O�OM��^�r����Z,��`��uy=��_$"Ĝ��s��[E��:c�Jޗ�+�7eT]/#�:w\�OzV�؄�[ǦG9�㌶���m����5�.���k`��S�܏m�k�(h�X-���7�iU%
����>7���ͷ��(�6 �@��E^|Ѯ�0�AUOF��FD1���w`p��D���O�3P��S�(�F����'5Qv'��&^U�r�h@^�Nmhgެ�lk�M��U����X+���s?�T�cqP$�v/lj�j�V���3"�%�R��F�����8�+�����;qLY�J�1��q��)U.�!n���UެȔ��/`�O3��s=��_>!�$�k�T/Z�ur�V}��N��|U�^�-�е��G�Mi,F��A�������I@70��gm����HB��8T]9�D�_�|k����"��G��B9�nM�U��V^�-?;mW�$)�κ��[-�d M��
���"��v,'�3�N�`H�r���r������=�'y�Gn��%	 �ܾ�e�&�:ix����{�#�F���b��nԴ�ƴWX)yn�-��4��.0�]<*}<����4�{����O�H3�ӥm�006���ўF�r�eT�}�fe �Ё[,�K<��H�3W�V0���6^�"Ǿ��E���Cēw��u�h	Xy'�F�Ob��s6xt�n?!>H O�S��f)P���W 2��+we{��ba���=�Uy~�+��F-fE�b���M�Tdݗ�f.f�:'y@������Y었<���v����ݱy߈<��١�7Q�m�-\�\�T�1=�5O��/�'�+��C3��� OiZ~�O��!�/7�ۊ�7�������      �   1  x�=�K�� �1.�U����7�
z�����)��
i6b��g��5�Y��!$��re9ia�@>�I�2��{�q���U+&�w�]���������OiYk2�S�����B�o쓖RĨĖʣ�[3^�xY#N����ۇ�G�poH�0܀[����ZQݐӊ��K��VL�^뤪^�1��i�ĸTZN9M��oA��4i��?�S��wx�㒝�z7�iŐ�Ԡh�$�_����܆�T=�T�����SU8��y�|��3�Y�fPA䘁 �E�Sk'Q۔M�ŗ����ȥ��1��X��      �     x����r�8E�ͯ�L��Zƚĉc'�8��lZ$JBL�p"}�\P$e��`k6�[����ֶ̈́�[���:���\���XW{�6���F�\p�L��T͔D)��j�ݶ�R������R{F�o�-�欤������kʳ�B�������8��*�hÔF����:~���_LĬ%�v�}V��4��,g)�$z��9~�!�$��P%�Bb�׍�+4�����(�O���z�8-��C2Z��(�xrȌ�f�]8�����X�z]b���Q��E�_��c��A	K��Â�����}5�Vt�p(O�̛N�ڳ����g%d$��i�wa��fQ��ۢ���fB��P"	�(�g��Mn��rg%d�����z!$��y���G��R�<Jt�z�O�̺�{�|c�kf�f<�[;`:A�5���;�,e���i���uY��8J�j��\D�4l+�b/�z��]j31#�{.+���E1aF��~��(v�����q��~��e4]�W�K�k5)bI�l�0H�+W+,�:+!$���	��� ��v;�7?b�) XEYJm�� 3N�KH�2sF7��we���WB�Ϥ2Ǐ���4��Z��P�N�&��]|��ڛ���Dԙ���}���+���5��S/&r�妯T��v�������9���M[T%h'R� �j�uJ�SH�"2l���q��]����(5��T�S���7�GNK�h���(�Ꝯ����%�Z�-�}�W��`q뷣�;����4
�	�wج��M߉�דS�������i4O���8�)S\Rf��u/�d���q���B�g9�0�x!cNw�[ا]ŹS�un)ɢ9Z��+?�#�<���)��W)|I�����>LB��!b1��@����S�2�<�Q4瞒Y�H�6��۱`0N�ޮA�E�=���
� d�Y(�K�]��������83�|�j-�p̏*Ǳ텘��k\��c���ۣ��?�9�[[�A�Mp�<�}NG��{���,�e���Tm��)b
�\�C�YI!Y��l���bfm�tj�ğaN+��H"]����h*�R?��rg%��+����؏+��r��R�jBj�`��A��)U�ߡ{����h�@�f4%�h��R�ʚb��BKT*����RPخe�N�Q�k�^M/Ţ[�z��6����v�2@����/g��ߕQG��]�I�
�;,o�+������2<��n�N���{VrN2�����r�?EQ�ԧq      �   b  x�=S[n�0��O�'($�/�/N�w��
��Z�64�T
��'�z��bݡ� ����3�VuM�V�d�مGڰQ�Yt��b.r�r�Zu�V���N��l,��[��Յ��$W�8������6;c����x�������z��ݬ���������f���mb�e'��-$iuǔ��0I�y���4��$�j��W@Ob�DCL����$���a�v>q�{�N���������[���u�����s�F�l� �`U`���U��z˨����ަ�,��;!�~��"�􈦙�~������ٕ��$��_-Խێ) j���n�W�Q�R\kuƉ��
�9:��t�T������h1�ܪ�����AB<�C}"��麈>8b,�V�!�S����? F�x��861��7��e�&;�/��6s7�ڰ�M&fT��#;��Iچ��j�����o����M{*/1���|�u+��{�6N��d%k��(������r�ʹE�(�@Ê�ā.��-�@c+�n�X�����(�Ey=�{�-����:��g����w��F��LG�AX�RY�dD�՗�ɹʫ�_��f����      �   Z   x�M��� �l/D����:bb@H~�5�H��T�"U��-Z$��4?">��J�#|��@D�5a5�##�Y������XO(WM�� ���T      �      x�̽ˎYv%:v}��G* `���@�$�O2�E�R��w�𰠹���-��QC��TH���jr�G�%w��瘻3��좤�L2�}��~������y�������|U5󛺝���o���^�l�/����?o�e¿U�r��4��خR_�y/����<����v�\��:�m��|��]�V���0�oҦn�t�7��K���f�N�n^���E�i�j��&R��i�?㗷}��j�o��پ�l�O������a�?��i�j�M˪��W�0_����O�U_��w��|���jy�d����,k��[�h����u{�5�O+J٦��9Vm��x(��cȎ��{l[7{]ˎ�����7[�2���w%?�/���\�>�O��2��y��jY�������Wi%+Z�\J��T���?SI��?ϱ�V�ev��9����������+?��?�0�m����-�+�h�v��l:9��|����5a�z9Y�Nn��.Τ��3�.�
�H��:�*\�u_3[gׯS[J��Z�V/�nY�K[�p��#�8J�{\a9�]���q;�H���.V�q�m�I>���������$��V�HW%����"��E5�R�O�c��cp�f�d��M��>ē���a�o`�M�ު�L~D��c����͗e��q��<MنU����}��.�?؏��m���O�'���n����Ky"���O��q��]�f�qiEJ�j����2�k������]e�����Qn�|��&�������B_x����$k���Dtn�(��Z���[T��_,�r�T���v*��W��������1���m_�Wq|"Q�pl#�Fʟ����򙦩>j��}�-ǭ��k���(Ԥ<>|�R��_ƺ꓊�L��Z�p�/d'Ґ��l닗��\O��(/l����/T���ma��ߦ���	bɯ����_�i�N�R9.��{#�`5��X������pӌ�ƫ�~�ڼ�+TEM���,6�����u;����DC���2����ݦ��n9�9�@kW,�m����"�u*��mَ�� �I�Oj��?�lC�\q���L�/Keg3ED�kv�Z��R4��n'[4����BT�wQͪb�j�b]�/H��������L&��U}[��n��Ƿ��]_/����e������h�@D|(z��e���~�bD�'���������Di��|�8q�u���o*<gSEy�兪���tI��ʤ�>n�=}���(T֩�3;�Td��c�����ӧ������wq�ԫ�<,��r�IZVBMS�'���#5�,h���kٝJ4c�"�c��ST��[U��G�����3��w����C_mD_��������WM�@�wil��O�Ǩ�~�UZ�a��X�C=�����,EѥE�6��I��vط>�!
�
^Ɵq�7�X�8��V�#8lQڍ_���b�_�r\�u�����8{���a'pIE���9TŦ�v-�nS�8�-��˶u<��y�k��{��T/D�b���y�)����&Hu����3�hpY,״�T��3�����%�A�Ts]��a��,L�PJ��������i���ٌ��]���|AM���I8��r��w�}��n��e��~*.9��&~3B���7�&[n?�{s�Um�q��e��A�n���&�'�z���/����5�����2 ��\QX�j�-v�lU�M�.�i��mk/@�]���K�pv	�����r�K0�s����Kħ]7�Q^�b�*�X����H%�#�����ަ��Ǭ"E-��'5�۝Y®1�v#/F|�ێn��fA��<-�u4�m����wڣ%&��߰��^6������'X���Ջ@l���n��ͷ*w]4���t'!/4����	��t���糰�bL�w���4eHU���?PX]����� �I�a���������EX�:�d����E�j��(�ʮ��N\�%�v_b ��|kB��j�*&ӵ�h�G�_<U�Xت������Iމn�Ы"�N�n#"U��'B3�+�s�D�c�mG���-�,�~����d�:Z�n1�ꂊ�դ--����E.�~�_�ī":�W�]�b]�=�{'A-e��}�]�F즘��כ�͈�oX�%\6�"pq�f��p�B��4�J�N�G1���	p����������$D��%�R�S��N��gPW�Zm��<Y�<�%w���<��1�!�A�-�3X���z���0y�����Yd/(>&��'��d��V�߉%��d���*��zus}�����,A� +�y��������n^��&�3�n~H7j���7]S���n�q&�*�P˦�3��Me�a.j AɫG��	�~yto[����<C-g?X�@-/�ƣ�XD��Z��>����`a&q�f\ڹ��&���k����o���9�$~�FL�(ed<6�l�}�\��E-�&#�����mz~C��.�C(�дՁ����h6zM�ރ�/m�Mgl1Ӂ	3�g��VP��
g0�o.߿2�������n��ں�}]�.b�ݰ�a��@yY�gV8޵��~}�&�Cx+�UT������y�SX�Q�4G�FuL����/��b���h9��$��}U!���C�g���/j�i;*ҫ��+�)"�]���ߌ���Q� ���.Ɔ���� !����,�>Q���Z¡;QJ�����D���x[��gh��ѭ�f>=H��oL���ZSr���Ų�Y�����T�����^B����xl_��&�c9��0	r?���ʤޥ�|r"�ѥ���Y�����Wsj�&�3������m]7�$��:X��[h0�t�la}	O�ތ���[[8#���m��-�z&��b�"z�L���+\���m����:�M��-_~�2�/lG��E6���T���ݶ���W�Bq$7��P����δ�P����"�����	���+Ϥl��Fj!�zri�~�\����j��埑�Dr����-gU���Y*��@c��%ĭ�����9��X�]ƭ���}j���q�f��+�z ��띛_|�����w=h�ŅT'ZT]G��a���#-z[�u��ei[DM��*��@�ʦ㺥W��;���4�H|!.ʷL���Z�V�1��1�(���\=V����c��03��T���9Xԑ��"����^�b��#���^r�n���H�a�0.���3�� �u0\V'�g��n�n��Z�p]�/);��0m����@̖�~�;(��ΐ�b�,��ȝӂ۪����I�H��z�n��]��G��Zہ�+R�pW�l^�����H���}�:2�9��ӅMV���כ-��n0ٻA�9��F���'[�p�(ߏ��D�:t�o�#�6_׭�Q�$���5g�0Mj���w�<Bu�wU����G�p�R�� ������A�ڂn����I�~���8@4���e�9���(�CZ�M'K�&ќmQu�3�#|�9���׻2Ć0�fWO�i���������o+���[t6���_�Щ"�r�#]��#�	�SWH/-�"]՘�S��9#Ho�8:bd�d>'�uZ��x���,��<K'wZp��hMVg4r��]���ޣ�x�N�7�(�.�.��1��c����K=͚ջ��Z��
>��������x�}[j"/�`u�"�p_�׽�Z,�������x"��a$D�uo�[��+����nV��\vH��*��rW]���yݚ��GN�7�W�Ҫq���X�ڡ\h�Z��xϕ@�Xl1����Vs�Eu�֒~�M�j�x`,�8_���.;T㶺�&>��9㻕{3�6]��d^��[+���7R��Ҝ1GO��'9K+{>}�f|Zw�x+���<��~�H��ę��|	�g%7���gj&���ƃ�,��8xy)���W�"Χ�>lw���A�_��1m6�H�A�H�U^Y�C�(nЋZ޿�5�6�=�[TLϋJ�f��i�?�����������C@����"K>��j�n���(2�H�XaG�QM�*�B�"P����j˸���@u'q�D�u���T[��L��@*�VC��WĄ�J<�    Uh�&�^��O7���ڲ����͐-R���?W�Z�!��9�ٵ��G.T���fH,GE_'M��Q>K�$8��B�K�1����� ��k���pb�5�J]8� ��Vtb� c�}1�P{Il����f������N�S}$��vX
��Y�]d�C�ă.,K�=B�^Z���S����;���ߐUk|�¦x�k�.L���sn���Ѥ�ҵZ3p�!)px�n��R��n�L�u�&��v�x�̂	�N���6��uSU����ü֪������Q�c+�mZ��f{`������i�$��O��U7���Y�բ�(
E��[��F��(�T2����g,�T�Ü���
�o�O�W�ȒZn9�A�(���W��TA��Y���9��m�h���vٌ���X�ZM�Px�Jc����@�?~h �������r.��N���L鈽����zh`a���s ��ûz
}<��-��A!�/��RJ�FT� ��pM�{� �W~�*M��z����S��J\����V/f��v��
slbi����q������_Fp��6���$f]��c�5�$�G��v���tL�G�q}%�����|�gߧ��Q˾�`$kp�lWL���ve��6���o�x[��X��gr+�]m%JoB>��:�1�W�x�M֌���ަ
a�n�yYj��S�oXBQ�_�]�� :�N�Z<ش�XItۖ%�ξ��\�L�WP-D�,;n�>2�*�D'ע�\��>����d	Pr�vi:E5Ql��|�U׵���2��3�k��ᒈτ|*��ʊF�h����q�f�d/���8�wc{��*5�Ku�n�}��$�$�P���I���f��ܶ[��.���|e�׫C��0S=f���~�������f�oE#ד��nIZ@���`B��d�P�99�+�nQ-1�C&��fa����:�9�r�75"�.e�u{+�|���w��ڎ�(��]:㚹�2�oV��R���Wy�������, �҂�����2_�"G�ȴ�f�qٽj�{����	�[��ܑ
�H�߹ea��k��G����_���R�US�A����=�@�>tʆ��&���H	(YQ�������ܩΐS�бaMy>ג���3n"��qa+M򳢘��J�{G�+�}B�J��.5�`�BO��p��]d�l����Q�V�;�W7��A�d��X�g�^�7��(:��"��Jrr��j��H�%qm����	�z�S����̕j�s�����CA��6
��t�_8[�#�q$���kϺC	�I�^` b��`n�o37�U�3S��V�YH}��2")e�<�����Z	�M5s�b�L�ɗ��6940e����[�7hk*U�'e���9��ӛ�^�["Gʁ�2����˯ �u������*�n�tƏ3��Z���\�Hؾ���������919�������#?���M�G�Sv�r3�����U�JS~�<2k�.�,����:�����^�Ltm���3����E���1�։�[���ջa� �n-C0��W�Ԟ�K�C�r�c�ĪXVywxM#�co_�4\�H	(�&M��������m]5sۋ��������Gܓ�h��Ҡ�E7��;�jHR���d,c=�]ܑs�Z�7��x��Ȓ�a��L�"Β�F��&�x���Q���2�jX^�N#I��v��w�F��S��Ne��:��$ZúW�B��ܼ�D��ع��}���X��j���K+Uu�pyu�����	��N�W����	����V�n��Ȅ��kJ,�&�����΄�|�	��i�0�U�G��+����v����f��p�W!����[:�1+�������;�`��+6�8Rזr�ߏr�W��h��I�-�py��%�5�7)k��J�d�����ĵ�"��\;�d˗��7�&�#@?������<�����A�����Z)❗U2��A=z���ߎ�u- �=�g̍�E�l�ѡ�+����@ IyypQ��o|+�N}+����o� �
��Ng����i�Y/`>w����E]��X'�.�	ЀGxXT�����DbM~_\N������	��?t-�Na\�d�>�B+��S�<�=E�Og�j=�l*��2}�/Ȯ)k=l�8%�x�Vȱ��'�p�4�Ou9�E�xt��V�����z����>Ͳ�c{���cl�+������ g�%�U%
n��<���0��"��J�UI�Q
��A�c~�M�M�_��^`5L�ر�\b�H��V}�Ս��L+�����,$��h��E��Cs��f��d� g4����UzFnt4C@/p�1�q�\�����:�^ �bn�aQ�;�ak@K��eq�6�Wg�d!��/�?QAx�@�gN�`*`��h�ì�Ȁ����1��lO`O*FM/F��)��w��i'n|%�j��M�I�=B�B�]=���ى���ʚ>M��D����[Y�czL�i��8d"!���w�g�q�VJ��<������]Z�G`���\ok��2�t��M�v#���Qb�u<����R�����8�xYxX�>�V6İ��3��3��v���2c˂r<m��-s��Şq��Ԉ��mFj[�0���{Զ/���6+�]ڍ��T��د��ך(��:)��a�.Beb����M�O��Z���O3���&�|y��ڷ�D�!+E{�ȌZ�&[q����������Ƞ9��h0��Lh<��=����͢xg�&j⩡�~#Ri蕀C�R��f�'�&]����b���x�>9fl���/����F6Z�3&����*ޱ� \��x{$�4�^u�uH&�As~U#?~���:[k��?�)��:`��;c���F����ᒰ��tfG�X�v�ԡ���[���ҷ���sq�L7xh��r"z��h��O.�C$����Я�Vĉ������㈫��ϿIM���:4��[�\pו9sF�S�/ՠ��5�Te����|����v�U��JM�v�j�|m�K,�Y�H�]�����>���v�r�I:��.�#d^ B˛�m���x���'z����^��buW�X���5J�9��9#[�������;�|�*�i�B������
��(��r{P�������N�c�WE�_O��Oȿ��1e{^������m&�~e��3��e��RAw���|E �fp��-\�ɳ6I�"~W�[��7�.-L�*ݞFh[���E�~���U�G��H7!-`��z�
t�5�E��7=�ؘ��&�3�����i+Qvs���]�L�<Y�<7���Q@���V�P֎a{�n�Y��YF�1p�
Zl�����aۨ�2N&2G�׹)� jQE��tP�Y�e�Վ�+�E��6��-��zEs�.����C�/O�W��Dx���!.ߣ�(�Ɍ{��5��b6r�YU��4A�c�É��m}����A�C���R	��d���r]�nCw�Ò���a�[��J�i=�I�M���Ĵ������z٣⁖~�a�[��EL=���:HϹh�-�E�1�Se?��2��W�~Ǆ�R�_�h������@�k�<�,�P�٧��T�B�)8�;��6��$��Q,l�D��R�2'_rp�2m�[F��8S����������Pq\�ё���eU/;'BQ.�@����>�����足�<���*��Z��|���S9��7U����.�D��zw 3�P�v^�Z����n���)�Ê�rǅ�::�jj�h��r|�OAeѡ_c>�	JDS��s�����x��y��<Zjul�uS}d~�6Y�Q����~�f�KV�qS��Ʌ|�FТv;�ɉ!s"S�o�4i.����j�p�#�p9v0��gč���h=g� �%�B7+0`�g}܍}gb���l�rb L�f���]eݡV���,�#g��'s�uט�\�ݫ;���������%(<�2;	�.�I-z����S�>�8l#�qOlڥ��z�s��te,^��u'��Uriȟ�]�p��?y2{���.⒬ɬ�~2�)��(��*%�l~e�~#�    ���jǳυ�_���?�.P}�NWpm@��]�{��#NN�"_ì�r3��oފ�K۽*�-k��h�����ɹM�P��$�ZD{P�(��߾�Ӎ�T�~E�@v�\ƲM���e2>b����`�L��g���e/��Ui`�1�o3�����Ç�L4���� �I}�v>���T^>.�c�x���E7s�nP��9"��r��-�2�4�3�3
P�K�A��� -^b��V[0�lX?'HM���ƈb��`��OY?�X�n.��e[���,z,K�w�hA�yZ�f�3B����w"#Pꑜ��]
��ܯ� �(>�Yg��
�Hyw�i��x��y�Y����U+�ۦ5�;�%���1y#��D���je-�&a)Z9�|ji�Hq�*�R+��uoVx�md�֒	nޣ���f�j�����$1�RY�-9�⹈J�S��>�U͟^<r1/=���OM�� 8�Fd��I`��Ws.w�[��g�K*�%MFǹXV9R�9Ս����d�����������'z��l�۩����ճ6��S_9��ڵv�l�}��L[h$l`�Z?��7
�S��(d 6`j��\.3in�'9���HO�uS��>�UU�[X��+-ǫ�bCȭDBx��$�{ɯw	�<�����������"Xd�nj���F����R��������1ʵ`3��ﵦ�xh���A� �f_l�����'�T�9<A;�D�)�/x*�C���!�ʓ�z��><�����=���O��q	��^����������N+�춧�!�OJ��Kk<,��hᬆ�i�M|�)N�rӓ��>�iR��z�Fʼ��5vD��=K'щޑ��d^���zb��A��XK���lx{k�0vN���>�0V��V��A���LyZ&x���.�ꖛɦ}`E�xA9lH�Q��h� d&2�S�I���:ĠEOY�R}�~\�\���Q�@'��b��wL�?�(�vV�/�={l�]=P 95��,��;H��(�!�T���1�*y�9w�3Rff>�n�+�5�7����~������Z��&'U�t/���-s�ǂkc.;vy'�.�g��G��ж�}l]J(��L����m;���,�`T���.ԝ'�;�����A���0r��0QcMF֙b�ݣ�����l�rnj�X�I�a����;7����Ķ��D^cMpi�]�+���H��ۺtfFj��H'�?�ɬ���6{�Ć�����j�=l�V��R�V�\_�Tw�=x����ԏ�Z�7'¬V�f��e4�J6��"Y�֟
2H�q��v��ǈ?D����5I��߲��r�*��En�n��%;����D+7d�ms=Q�x.��u����P����G�]@��#,�	�׿��,"�J+�i�Όe+Lə�'��W#
`WYW3��4��jK�jk�Z��'��n��
�,��)"ۿ.��/xn���>z�i k�ؙwUMo�w�*����0R�&j�	�@�3t�)���edCX
s�>����7%U^<�`[eJչ�� �ϵ����;�C`����M��1ս2���gi�c�ڜ��zJx)_��W�ON�>L��#F�a�ޒ@�Xk\��(-�O	=����r0��W��r��M73�
 m�{N)b˃<.�P�FLz��O�f]�ǲ�S�NJX�g�����tI��סP��1�M��ߧ��~���yGì�;r��_� ��Փ������<�ƍ6%tm����SN�~R^i
dc��/e�R�WM�B`�0���(��k�'�����K/k����Ӿ#��^QW��>�6��;������-9��7��%�Ux}f���:��Ԩ/2$~$n�O�>�#Yd?6�����m��pY�?ɯ�y�z�N�c����}���v~YH�XܢW馩�~�j����RE`I�LY��Pc�������̓�}"j��$����X�0�kQtY����B9�e^����0.`Sh���!�F�씖��C��&��Ӣ�	4鲿V�;��
:	I���X�3���{^�+�UҘ��f���R`Q�KU�I�����k���&4�U���㶶<���m>?�vy ���إ�6
��Z��fĹ?���@c�C&T_���?�)���|��դ����m����$CM�.?"�qp��*�
�r��H4$ʑi�4�&�3�:���!��J�dRi�L��WF�#*b����ŎhʦM\^�˙�'Pљych����Rݡ�p(Z ��uV&
�.�+��b�9��'���rs��x��A��!���.u�\���j�:�����>/�{G �]7�$MϞ��q�]h�q�CN��9���$�����]ξ��N�YTP6��1���j=��*i�qU�yй	3����vk�-���G^)8��oXӺx,��|%K�',/�o�jl�	:>����_~��b��~&Fi��u����
|e�J�/￦��lJX8����k)N�%�!��f��|��l��V8Ȣ�{v��R�@�t��&�AT%ﲗM�/��v�nG8���-o��v��M+�w�s�2V�G�g�3��������W�4!���/�!G#��e>7u�^�##�C~%W5HS"����k�4��ڙEDcG�����W����;떖�S;�m�����ѭV�3���-����f �4�E�f����]���zۋ�7^h�eP��i��Pղ�nm��=��>�uD�S(����h����A���*i�΀���q}��GuX20~�ʍ�YT�)�aA�y�w͞���k�Ү���1.��v�P�$>���>�I(��}��7K��O=6��V�M%�i�:��Ήg��[�hT�mмkC���#/w�c�*���~�Ϥ�(��8.u���Q����Nʢ���� jP��1 �(LUl��n?���8�/�n�4 ��^��v�0�L��_�wc�(���,���(5�e$ބ4���li�H[�dB��\_�Gx7�!�;�A��|	i�H����,��_!�U�g�
"{{V i�z@Arm�������a��x�ǉ8g��r�#Eop �n�Ҽ[�03�Ǯjyo��.i�>A�o�Jh^ܕ������vj���rָ7_�4�?f�W7F�E��Eá!�u=�O��Tz�>�ç��-�lw�����}����c%������˔q��&�cD}W�+��oJ���\�!4JO?=�:~j���r3��	5�D��}��d�E�D7*!�_�+�
n�ۂ)� �˟�C�wnqr#~��v��(�ra��v��I�����b��R�J.������Cv �/�k�ԗ�OH���fQ��71�{�EP�c�u��|t��v"���<q�f�
������)�$��4��q��K��G�c�D�"�w�s)v�[�Uh��2��u~l��;q�?��+\�G�LI��e���e+��B�Z"�����jէ��`m�ⴥ���P+��6=�H4>�L�͑�ƾ�F��$t���|_�uӄ�OQ	��2�V����*NZ;��5��u. ��\+�u�f���yf���E1�����J�dQj��!ȳ�'C�qps,�����.m��KH�h�܌����L���C8���4�'��)�J�^�B�^b�v����1��^6����pPba<�3/��ֆ� ���hU��l��S�B������t��7Oo�Q��DV@ی�>4���D�5b��� ���3[e�{��8��$�;���c����YC���7�қ�C %�>B�~��*��QA�]/�q"�W�����̀�N��2n������a)���f\�ݎ4���Y�.��}��)s�<�`^�}��<��Y~���5�X�#��k�"O��H��F~d�B�p��)�e�h["!ٵQ���Y�Ngi�l��w}=���T&�ڦ�nj�j��lc��l�JM���iyj�}-v��[rӭ%��2��ZG��^�@W���AN�j,��$��	,�cNh�;b�G���*��`x+�iM�|L0BubI���y���_��ɍ�����    Tw�����՟s��h�"c�\��eܞ���p<_���Q�Bj`x�hM���)KQ�<�@":��Jϩ}j)����Z�m�r�<(2��'���.O�k�A�	�w~LZ��7��ρ�`_�]��y��ok�Q��U_�#�2 Icr�AC�3��%	��Em��a���hd$�x����4�5@l��(�ݨ(��a��v̪�\��U1�����7)��������ou�_��'	�b�a ��2c���A�0��	8�����NL4@��YI�P�D���i�מ�B�~�f���hԌ�����r)��/5�3c�
�p�#�T�{[�E�P�壧�P���a������S
��,�d���]o;1HEӏ�wHUD*SC�1}ɖH8! R���V�X�1�Tl\[{86�F�	)u��x�c�6V�nŸ�Q�rM�}NS�ʛ�v$�YNК&:$?�Q�|Fm�([��d�����/C�������Ӹ�p7����Hc[�^�R���K����c���zXv�3p΍�o����}�/1�GP M�ȷ���q1�9q�8k�q�H�G5=�L'���r+KӶ���dq���7�0�!��+�9j��c~D��i����o���j�{Q �h)����u��ݮ#�;r.�K����x��j��c�3P����*M���cw56�����-	�D�;���f�t�y�zK�锊���l�_W=أ�����>g�h,dn�=��f�D�y� JOj+�I���WY�}�r#"R.���$��n��ʍ���×�{G$X�}zEI�|���%xh����Y0���fٺN���/����ޭ���7�9X���n��+��C�t	"����
�Er�jR`��#Q�K(�]�u��4������g�~�y��a.��s�՟������K�bs��������0���'�p���U�jQ�V��Й=<ޤ3,l9��dd7�$��l��[
cR?D��+�3��O�Z���@|�OL�;����f�\� �c��/>P�k��5lO�4)Vn�^i?B�Z�!����V���V��&���#m���v��F��l�1�;�;���)7��,b%��=ai#�p8n��!�#4&�}nA�y4p�}E��M����e��Ϊ�F�3�B�=�n[����8�$C0<����	�ƛZ����Rw��,Xc���C-F��^�����	Fj"Uv�ިJ;���AJ4��)6�^�DǅO����=�{�8L�ƌ`�8Y�Sjӆ9��hX!Fn�q�K~���/�Y
A�	kW�&Z�w��9�0mH�p�]�����|%=33G��{m��<.XKW)Ķ�(�w�28��%j p1�z�YB��A��S˯]�DĉJ���f㬪�܊�������;�\R�*<���(�d��akd��!@���vY�!4��)Ӛ�, 9���\`�+s���5��FQKr�1�@]��8��uH�k��ޝ{�m�a�.y���VP���r��$��}��nw���V�?�
��F��b��ek�Phad!��oF�)]��3�K��1��z�� ��9|r�s���-m ����^���
q
,���2@c� ���u<۾ȧh�`�A�ձ떶�Q�$�~��.�˅�\}d&�rc���{h���rY�����r��O�X��0Z�	'��	��uU�"QVƅ"��(5�)8�l�w�x�a�N�Zp��Z�!�ɉֱ�+�a��z�ݞx1m���rc�J�6N��hB���y��lq��p�/m���i�`���!/&=����
��qT�n�ss�VX�I�ǧ~R8]q�L�ʳ�K�5jo�Ɂc�5�c��Ie�Z���)��Z1Vf㍪����NqV cᄭU΍b~MU�g+&9l����)��4�D���w{��
z3ub�)5�>�$�R�Ir�����FcO<�kjj����&��pQ��^~SY��9�<;�7�5?�xJ�V����*3uʶE�b�͙9f�Uq�Oz2��\>`a��dn0�{�0F�1��G��M�,��ʂm�(d���ԛN��58����G3��yVy�����}{�N��Z�O�:��)<�=���:4�dI� �&�s<��m�<b���d4��}�@g���J]8�����vIG���V@K�����a;������h�%��X��IV?�d'���9����!5�G�����m�?�+��V�!ɷM�l���)WC��4��	����ywz6�g�y�5(=M�mi/]vN�z����}���{j.e��"���u�п�Xk��(��W�uT�!}5���xx`y2{[!�Ǵ�眀S�Qβ��E��e����ϸ�/���n�c�b]!��\c�C��
D$D_4J�i�؃~��Y�&�&������ޏzB��d̢�@'��N���>�����9&��*��{����\�U51����v9��`4`�G�ʽ�����E�Q���|��(V�\"4����Už��8CS#S��CUF��XO[N#s���f7���*M{����R�S-+��L�ȅ~b	V�i��ol<�]h����ZO�'���W��_���ζ�Ǻ����7��ٳ�J�a��>E��;R��]��*c:���lR�������L��,�[]�v��3~O��t,���Y�R���fЅ��Q1%!�����u�"�!
Żfm�\��3.؄����z>� �I</.���p��7��}T�i"� �$`C�������ZF�j���A�@��9��}G7;�:�#�<�R��5�
�C�L�CۄDe�vQ Vq���V!�7�e������I9��2�L��vU���3�L�{�0作=*�1��O���0�� �+O�,�S4
r�.{��l
�Z��RZkU����k^�$���r�T)Ҙ�Kd��e���/B�HMt���C@�*пN]�8����}U��s5'��3�E�Zx<}�:$k�e�)���^����z�h��]ƫ٣�k�Z��_��J+ j��b:�����(�L;�u��,�o4��	I��1�sR<tA���!s�f�7��1�in}��i��O��f~u]`y�[q4{���{w�qc�k
Ki��[mo1˺��gOf��G�Y2(�ͻı��Ё�[�&�u����MY�p�#OK����7.�|F����>�=e�������:���i�>Q�x�T�.F�f��cc�	jصu�7g���w�3�7�W��ЪC�p�0o�)%ӭy��*��I�f�x+R�i^�g'鳿h��f�NE;�I��wH�U�Ƣ��ZBU�#�H��'k�������%`�=� �?vtF�Z��6�D�Fe=��]ot�!��f�r~�W�|>Y�j3U�oO�j)I"Y��ei�3Y���~B��yO��`�`�F��2͏�VF�D:-#����xfx�٦K�B�團���j+�̦G��w��I���![�M�R���P$��z�r㫈��d��i穇��d��T����N����rJo"$�Dn�Z�C��7�抦��Nl��r5��!&��LAՃu��3κ3Җ�Z 3�r`� �%�}������eVJ�S�j�2L�-r`rp���=m��������뉙|��~(��[C�+����I251����{���a���>g��L��~�oߌB]-��EG
\�2�����ʚ�����h�������\�";�^�Sם���ҡ���zԁj���Y@&��Dޗ�أ�)�g_�c�ϋIb��`��wIj@�����([:]��2����jX�~���p�����f�ȟ����TO�J�F&�9"�-���� �m�+m֓�||�EA�j��%�i�|
����D���ث$,�P/�?_��O�N�,.�O���/�Q(�}g��B#	��O�tB3I���1r`<Z�]V[�h]��3$� �pp�&Y1~ᐎ#�G�]��GP3�W{��L�D/Ql*|2?+"�Ni�wN����4�b���j{��g���\������a�􇵏|%��U{���%s�Ha E��PEu��㤙����    �+�[�99�K�@��9:�߁�P�|a���:.�{K=�:W�d� �&C�q�>�˔�5���g�^B?~db�i���]��T ڸ�X�%^L`,t�w�֦H� 2LK��`��{Na�
��mkt�M�S��$:V�=�z��&������Qa���/�EX
a��;�/k�0:Ul��m���JwfG�;�b�h�_�.g�ےs6>�R�u�z	|!���������}sK���|�J`�A7�y4Ά�i�_Il6��ǘ/��ɜ�f��Z������6�h�o}d'+�$�ŕ�dq+�x�"�R=��=���xW�6?�Q{+�i;�W 8��HF9��/�O����ɣ_���v�>�����mj�����݇�Of�f?z�� ��p5��h�������'�V+��!��j#�2� )��V��7V��UM���w@9	UYp.!���7��Cf;}�����ϊ5���k�r-Sf�xIkdhۏ�"�4m���bg��27��G��j�J��؂S6t��ʺ:��CZ�9m��g�'�7�W��n@*�#O�7f��0�{�6��2��O]�$�Y����u'���V�R?��?����>��bs�S�m��Yd$���'�{�����v�G��d	U[����!�Ț:���ZkX��h�� �'P��ތ��`<�d�e[�'.KI��&���xi$OJT	��?5����¼W�A0�Eo�g�2%�b��+:V�ps�Lh��Mj�>> v���cvz��[��y����� ���z!�(�<zl�� 
޹k�Z�SDTBޭ���yFV��&L*��ck�'��@�s9��h3���i�r�l�n��_��E�{�h�ɪ���EE��l~[!��	��éʓ�P1�NX�+�lzk�}�	?B��X͞�1-Fw��bِ<#k1<5�]e�'��r���_�]���B;<F���m7V�(����FB�I�p���a$��J�}��U�B٩��N��K��Oy�������	/9��ѐ�Wʖ����I5�u��,�΅7c�Q�T�ј.����[�g�P����Q�|��pZ�v	�i�Mq�ieE8��e���e@��F>���,��Ap�_	��hS�9�-Q�(Jc<�V����c�A*�s	���qE�BGAY'����*�8+�x�ð9�㎍)����
@���qG�û�:�c�;8�?y��P�w (��I`5���̓��7H��0�E�l3�4`� +x��i#lA�ߑ��+~��d�F1|@d�T��:F�-���34S�[sB�yn���ݴ������:+��1�U�E9=���<X<���W=a�`����&�4�ç��LT]ј��b*k�kO"	�m��zG��Q�n��P��wZ��m����cۋ��J}��=#��KZ�L��U��l�H֞,���7J��{�ݗu���^5Nl�Q����]�%���/B��a�6�D�ВŠ��{&:�@��4��s ��Eo���R��	;���w�oKAdF���X��C�߯��I�d�06���<��,��:N���0;���*������s$R$0����|
��tho\:-�m����ð܅j�����f�k�z ���5^A2����}?Ջ*oפ˳��~ߠ��a�Le=�q�	>�I���z�!������G_�~�n��� D��<mf�����Ÿ��ֳb�x�&�|U���x���-0N�DnB�t����Ւ}�zN���"qR��3g�.ag��7[���b��z�1� 7��P9�B�gA����<���ͱ@PV�v��p*X��� �cF���d���=G�Y����zw/J1���"4Ey�{p#��mM�ɵ� �*U��Ƈ���&䈋~�;qƼR��"��W��Zr����P R{協��jJ.��מ��#�����>��d؉�����/�t�Xt�� ��t1A��c���j�wFv����$}�!��]��F�=�4�y�ê���C�d@Q0��ɆpL�x�{�
�9�0�S�A�}��s/V���谁f�o�2�p\��w�
H2������Dy�����]Q��]��H�@u��.�����-& H#.�,�ٕu��޸B]����L�zu9H���٦��N���eSnVU��_	O�'1��x���[��͊9��#�WZ'<�`?e��Q�թ?���������LE�K��R�o�fu#/v��dU���ޜ~��Q��c:G�0.����^k�+T�a.��tW�x�����~7����&P�f���2hy3�қ�����ͳIG�.�����¹�X��n�X������:��_��7��l�g��p�g�RP�:�^�R[����vaT�7��W�'v�cg�p���:Z�pMS\��&IN�#a1O^~�Qz��C9��	��9�)��V3n���!|F��ǈ���m���c=�4�������6,�Y��Z�nW�LPή3�c1�1X\:V}�`q��<�#gR>��^����kY�"g��愝 {!��N��f 8�ױ�=&mdo�43���}�۪)��#"�����.IL�������rwt���\*q�>�dټ�.�����!}��O{���E�}�&�ܴ�Z����c�`�]�����#�4t��>oK�D!	Y���C�'�j_q��} Y�i�L1	���Hf�>�d�Aϕ��uY��Tt"#.יW�%b|ŝ�#}|n����k����)&�{��=�>���\a'ح1�I��cnm��I�������H���L�r9i���!μ��d%b��ߦ���s�h��/�$��;J�ߦ��$L��S)��5colф�^��&|�c�V ����snJWx��B�E�r������3��-����R�$S��=,yټC�4:�N� Ka3�ǡh��lO��ܺ��z�t5� ���1��������M��!a��4��;>�Z�q��(�@*>Ɯ �'�ק�u�W�����ն7+E'�bbRʹ/�p)��WH .�_Լ���̳���h�V�c�Ǉ*��*��=�c�,0�i|��R��5��L�B����%r~ʰ�s�&ΈN�W_в���G�h�{zzb���9�9�pL�;e:��&k�F0�.X�J�)v�>��U\i���#JSRĴE�V��N�u�v>!��x���0�,�V ZE�A�Z�֭�3ݘ�wo�].O���k��M����Gn�hV{#V?f�8��:�1,�
[܌���r�)w�s]�z(_5]����?�Ω�	��m�Qi߱ҍ}얿�ˀ
X�/y�Ή7�	 ���L���AQߛ�s�
�;|�c�t�����{���(k�.����X�D�����h�7K'��9�sv|)�NDV�yׯS+1N���]��t(c�D�ҳ��&t����o���?�Z�r�)�p�(�!��*�[�W��@�dӰ4�1��N-���+�S��Kl<�����P���e��wxB�g���d�(��� �Rtō�=��鰬=�.>����Y���3�/��/��jp~k��is����d��x���{����mg.I$�s6*/9��f�0T�ގ8׀��oe�	�ba����W���kc�s:�~}���S�6�e`����K9���Q�W�wt�L@4�S�v�Sτ��0�w��j�E�{���/Y�k��a�����i�]�F��6[bpg��pu�їy
��Yy3�+�7n���)�mZ�@�'�y�$��,�+}��`Y:Xފ�D?0�\ks�}�)����O�L���Dt�K��kڧ�uV�1��RN��.ɞ��WH�ble�mV�1�(����)�擎K+�w<�3ok1r+�W�Qt�O'��^���� ̂ߛ�Z�������.7O�V��Qj�I���(�{v0K���X�G�����_o�#��l0�|�M���sڇ��k5���X�J�*�fT�M�s`�5�r<+�'��[�^U��Mߣ�?�r߯����f����n��+?l�)�	�9#@,[߰c��R    :�����9�s��W�֫C�}xȔ'��>ա��0�6)��eǯ8W���eT�'��������K�ײZ��z�=��Ɂ^�O�������X�U7!���q����/����ӝѪڠM8n4ѡ~�yP>�|���y�׎1�l��\;HU��;U����9���-�0/K&TL0�R��>Ww��Mx~j���A��#VƵ�8.	�6U����Ӧ�nL�?u�O��plq][�.�8��� �0�����g�
�H���ԘS�K�����x�f�o9)B�hT
I�w���S6m��_̉�}P�Ϫ+�g6ް� 	��hRv�`O/��v��X�������.�~f��Q�7tӴ�`��ל��9;��X��aw��$�
^�|+�)����C���x���WCiLb�&z'���c4�qP�
�y�h�Ʌ�A%}�S�����yd3�Jf���Z�˕�P!:�֮}��������
�N8߻<�e��Tn���d�bN�V���0!�aƎ�{HIִ�a$+�gū�"̳
aB�A�O-t�����[�Ck�3f�ym����6�������M��{�'�t�*r�}yU���V8��������[��~��tCX��>ZL���1h������`�Ғ�z�3��3G���.��#��8�j�)�b�B_L����,_�)n�e��ѵZ�9�w��43�MgH+.��i���hJyjMU��J�a ��?Ԋ���)�L���ox� .u��6�v��r��aj�f���Yw�6,�C���Eq���O�����m�:/�Zx2|��t�	`�HL2)!Rk�ȉ�2��:�BǄ]d��g�]�W�Xx�/<�s�ۛ�gߏ�I��ag�km�<����U@�����Ϭ�K�!���W��H&/uqٍ?4�Ä��.PC;��P�'����&�m>����)��6e
�G��sPF!��x"�tD��Q*��X*ʦG�D�����66G������^��H����z�Go[�I֥4%��3ë��ـ2�iͽ���T���8�Քd��~�<6c�|ݑ�������T,�m��Q�/��E�
5D���E��bc;�@)�%�?�K�Z�� 3��-����J.d%
ή奮���| �
6.�M�&�R|��JMdS
t��Aϧ���A�E@�� �[^/�?S��^��4!8r3e�O	/����9ֳIiB���|<ԙT]:1V_{����n� c�b(��V  ��Bu��6V?��C,3O-硛d��)�х�4�D:/�f��W774O<tqw�R�̱�G����	�2�`���.w_�Ԙ�xJ��L����~���q4��A��^P��I�QF���s�˰��K4L��1g
�@�AM'���8�����y����]P
�e��f{�����qѪ�^�#�;=r~<]k���=�1 ����^uѯ0.�q���ۏ ��sb]�o{����g���)�������C�U�4�Myo8��PLq�������|v.ɘ��5̪�Zw&�>�){�f�d�@���]1
��H��R��7Ahs�DC�K��n��/�٧��F�"�ΚV�r���<��g�X�9�GӸ�6�b�Vv8���p�Y�%�J���{��
���d�A�[�ֆG�]P5��c�B'v�L��kԗx4@��=/�U�jWH	��)G��W����l���������A�/��c�lt��9��Y�U��ff�dTl�9��T}_�{�/���x
��⬷�����D�DΌ?��3��¡��J[2�\[q5){}0�Xg��0J������1�gE����{\�S5�U�=��U2��<�u�v�=�TI�T�'����4ؗ��UY�e�Da�w6 ����] �Y��}pK���E��I�y�f*�/Kk
-����.�tO0}=�`��I�5��$ё�5�Z����4%\��?n,��ʄr?D|��E�컖3EE�u�:��ɛ.���:��'z�2O��D�ۘh˶����um}Z�=��m�T?+�!��\*��˴XP�&�}�%��G����T���4��u���M�Swx�0��B�JA��Ѫ��X���o��� �}����C��S�iQ�m�7�����S&N�,`���엌��ъں�#���Q��v[������Å�v�&/�,��g:O��CMt!:����,��ӫ�B?�Wr�:�1Q��dp��9	#��`�_��
��-5�"�Dr��J�%�@���B�+ġ��J��c^��r���w�N��Ɉ��o���#A���0�-���O��׃칂�PAP>�gD�����)��ԇ����:���Q����V�(�dt�>&��!�[���zl��j�����|��^���m�ļ6I�z_sB���[G�)��x����g�(-��^�q���Td�WO�?�����!w�#�����kM�v���c��1�Ijb�ȑEV�䔌X�S����D�7^���aOr�_� Ϡ��a?�o��c�ϡ(Fǎ4���b�K,�H�?Y���\�ޝ��t�+bUVP4��@+'mb�l��7^C_�cD�H� �N+m]��4��4A�]�-�r8�ߩ������`iijKM���UjznQ��d�UW߫��bc��Қ�q&�e�sd%
���X;��CbTŤeu`Z��D��	^��� Jo5�R3�蒬��e:���ݗ�w�@��Ny�]�W�M����?)�a̭OB�[<�R�ҍ#�-�/x�&�0�m!W�1�dV1'l�
�2k���:�1��"(�/�s��fïx3ZN��I�M�	�C�U�@1o�W�m�9$OeY�H\fT+D������{��DT>���~���2�Ś:�e�n 2���+3�}f`�e�nO�!�Y��\lF���.!��-��p��hEK��DU��ԯ� *lT�YF}HQ��[�G����)C�Ǌ�<%��ߨ���_��k#�[��ݞ���8O�5Qʀ7�_���|a��' �s���{`�zz)W�9
��@}0��? d��L+ܯ�|z�a�ı��b�3_�t=��+D��˃��FY��Dw� �meN����h΀#�;��p��w�ه*�n#V���Qؐ�QB�Lߑ7 �V7d�h�	�,	��\���l�mYh�y�zXm��"��7��ct�U�h_F�^x[�+�fuݮ+r԰�h�h��H�H`^���oP�W3iF��}UO����'�Ase�_v��Z�Үj��%�}�@�jev���h���*Lo��eBj�ϻ����Q�]��)�F3�8E����~�l��e0�X�~��7V�d�I�PL#�n��B��)K��v��$��嘤Yat4c/�'+4�iX�y���-b��(8��`�@�ϛ�fJQ�(��D�3����u��0%~��{�H{XP�~?�l�1��{��3})�qK�,�{�Vp���Y4�����	~/�~IB���:!i���C���i��b�`�
X���3�i)��0+*�B�����a�8�5�yL�8ق�5.+���.�l�ʍ��Ț���Z1��d����U2���W�fkrO��>�d�a��{4_y�nR�l����8�	g!&H}��M��tZ�`��$���0S�3��ݭ�f�;{��+xn��L���E	胻�L�`�\���� ��]+>�D�?ǵ,3{8��p�A���w��$6�>U"��A/��E�=�΄��0ѫ3�m�3�� ?Y�C7#�76�$� 6��G6��򁱧�<�1Kr, lA�� 9ځ�6��n�cv����4�����K{!��5��������#��)��c
ޓ�\i�{��FS�:A�|�m&e����Hk��^� ���!�B���1��A���ٹ6��^;���L?�j��H��������Vi���vW-
��o��..�
���M��w`������G���
�c���Bj�,U����(�I���ttּ�c�X/3�Y'�?zw_���=܎�    �D�NM0��[���r��5ɘD͡H2.��4��6��Ιħk��aG1-|��mL���N��'��r���7b�]���kl�7�H��LY��Q���N�hyg��k����Q����ؑ�zk����8z�V�)���)Rtdh�|���=f�ܕr>e���Mř]�	CŹڌ۾�H�M�S�T���Վ�:�ێ�/�+�V�۠�/;E��`/��XW>��.�d~�'����L+^i��|$s��kA��R�
G_<oR�ۉ��.��<z��������q��8��Dv�-ڐzj5�7�Cmh�����T��iW[v������׉ /Vz_�������[!���
���5�U�����h�UR�{f�����?�������
h:R^���y趪6�]�������83�D��8�m]�Y�o�bh0W��Ò�+u9(�)L%�@c�
�ޝA���!�X)�T�Sߦ� 5)���O�=@t�˪^v�� �rc4Pǈ]����8�)��4LyI���w����-Zk=���8s��	����f+A�����4F�X�����`X��ō~!UQDCK�=�QX�������e��U�G�Rt�<-]�6��)��fҗB2��˦�\���.��Q��B>9?������ ܦ~�K�<�ӽ���	&�WRkk�7�2����z���\�s5�f��4{��W��}����6��5vH	/�m'�06@~�v�FP�e!��;:H��{'���Zh~W�j�v
p��h�x`l
�tf�h�&փ��С����Z���zM��t�9��J�*�Z��_�v��nG)l2s��I�ӣN~0h��޺Ĝ�p�)��Ql�Z� o�rB��aJ�{ͣ784P��Z�])@���i���.b a*_o�(v(l���%�qӮ�e�i�llP�t��3)1�"�,�䧯҉!���G��{M����ݫ]�tXPq[ �LOօg��\�a�mЇ�N=Gd�7#�bpQ(�k��Jy4���ig?���]���#�4`�n0.��7�7�~�~J+�/���.,�� �����/�e�FS���3�D�!?Ϩ�[����U�U�m�^��z^� "�]������T!F��ٟI�
�@�Nc�.��V#^��̖�c$�ث���z%��V��1g`l��>�G��h�nC����F���5ئu��#2Pmk���	s��U�eky���Bx��|��U�2ݕ��|Ũ�U��nյ�X�0���*����2� �t��:��FUY6��sPo�*��N���\$qRf��탬&Vm���D��3o�h;qX���8e�O�6�*`�c��mڻ�
ʹ��� /�eb�:-���t^�5���4cH��CX���A�KwU
����zyZ��}�̈́|�ک�=��]����o�<��n����r���9_�䳘2BL"Xe�I~{�"ك� F�aOڲ�a��o;�B ��|�hSmI���\�^��+��Y�bʣ���NS(Lgd/͙<l�l:���e�p8��{<�Gm(�[���0Ο�~�nnH�2j\���4qrf���s�d����6�a� d`���I2�^�wZ��a�}�9���Br��|�������u�u����<��3<��!623��Tc`,"s*�}�Cb�� �c�
lY��ܩU28 j��k|(t����+e�c$�a��f�T�%;�������� H�eѲiP���ݱ.e:���	C�ƣ*c�Mz��y�'7� �8j툎�5����=s�W�$�ՐL���I֔� O?�P	�:���!���4e�蝫�c1���>7O2�vf�;gaX�PͰE{��o�z?އ��R�t��� �]�a�CK�x6����<Nd���QɈ̪pc��E���I8��yS\ҵ�"����@M���޴:�E�;DSm�tv�r3�>���˒g�Ǻ�*��y�'"9�&yM�Tj�n[�9���3���n�<^N[E�,wXPn�Нr4-����մ�/�
G}^S��E.F�&�n?�ǵd:��� �O�ت�eL��4)}���c$3��� �;(��I-�o���t��A�6��U]p �;6������ێ]v���~2�[�ѹu��4P5�����sT�JS��1����Xl�8���m�B,��@�ӿ_���at2��l�!O��
)�_|f�QD�5��gqTW����sz�$�S�$��P��$�j��ͻ�{m;諹�"M7�|�}ʽ��I��lQ���;���q󳳤dб[�?x��7�֭Hy�RF�S��"8Ɓ���cꆉc�A��'�6����Y��!ߌ�r���[�,c��j[s��#�w=@���K
R�g�q�G>M�gb!����@�L��X�9z�W��ؐX��}�o�# 3�r?��^vL1�v�c��e~�`)�)�����(\O���"����l`�r�J���+��ű��f/�aG���4�6��*tA��H�k��`�9%�6qz��?fA����urO.��Y�b�]s��1�.��,��{�r�y��Ӌ�s�/�INM�ϗ�N;u���W�E<!�C�e%GE��Dŗ������w���DtP���j�� z��#t��T6Ĭ���#Q#T��Lj,�&��9�]nt�{�cꌗc�����K�ӎ��%�5���Kc#}���9�~m��Ing�i��V-��*���~�s���/��F�se��I�.[�N���c�_7�M��M�1[���;�� �Sp0¼̯��0.����i����F�"���:�L��n�Ak�X�.�!���A�Vj	�XE�[)�y�by`�{�>z�����x����V�^Ym�povQ��Z�o���m����Ґ�U���;ϐ�y"l�þ��r�SM�s�r�K��+�٦�n�����C�im���L
LYm�aǔO�y��0��z-ݶK�#�H,�O�[�	L�y��L�uEj�d�_ �s^,��ƚ<�IJݥ���7 ����e:���`1�� ���5rCbr6�G����Y���M�(�܍��Z�xq�Sᜐ8��c�-M��tĚ8����Q?ϨE��ۗ��l3#���;��kz��4�;B�v#/��^��c�qݎ����a�9����1�1�}�i�┉1��D� �l`����'�d�,�<��B�b�I��1,�tΊ�{�[6��􈴲�I�V�w�V��Z)]Z�Y9�������9n,��0n��1[�˧�+�wD�1�I��N,��C��7��,x���m[�Vՙ���aU��or%�{%��P��Qy�����*�|���28�E';��l�O]���/�y�<�s�c �v��F�z�3B��Z�vR��u�"�϶@�|�ds2폅<⇸" ʗ���Q3Yً�3���糯��~��_y�h�nZL�+����Yk�OX+��[�os�š�0w>� x�O�ч���U�@;�I�~�3��+W^k:W��M���ߗ{gH���\��6E�l	x��d���>�`Z���Vé��2l��U������]��^;ڊ˝+��P��I[
o�a��͈O~NU`@��R=�
�#C��%��8�#����a�݌������ӂ��Ƀ�c?��;`�2��񼢖w*�U<��ڇ�W�c�E$�g�h��+$y�$Ro@�v���8�؃�t3���ێ^�g�`-�`�xA.*"�7��q���o��9�M�G��7*d�$[��f�4��
~���+�ȭ��՚�׌�z���_��ۃ�]��e�6C%�7fp?M�����v͑P{4�J�#��v#�#D����L��\��3O���s�YF�*�SJ�`�	,����8I�O���j^��8Tz��|@"K8g�쫺i���y��"mmm�x.��ڝ������"����;��j�r�n6o�}g`��#^'��X_*�͉O�K���G�c��E%vܛX�k�����T��_:&lpLX���6�e�P4�K|	W]ߔ�gGݳCȵ�m7�:�U�XZ]�j�Y��n^�O��I�V\8�ρ�M\���%�Q�B	lIWߨ���I����%l�,�u�    k�u�7��0�>T_�2ؐ�*��b͡����c�K��=�T��&d�4��ga���z�x�z��P4�7v��f<�T��%G㊝��l,Ԋ�=t�O�̅��4f���Im��+F������u}�V�*]�rE	���~����Y�S:����@�ʚ_�:*�b\��0A)@V�Sl����e9'�`{�5{�<�V	һ���b��N�he�i���u+�([�j[���ā�(�74�Ii_�#m{-����ݸJ�Zzltoi!/���rU�<�U��� �����
������}D[4*��;7`t������m�wyD
��MB����kR:�4Y`[Φ�=8�%��7��$�i�������,P/%�����ް��O�����2f[N� 1V��a�O���F���� ]ty�TK�3U^�b��J�9�cv�{@��������37A_�:�e�T�ٮr��dm4�{��:
���9��=V�ёJ�z
µ�ԚN{��\�5b��K48�lp�!1�W���􉌉1�x*tө&��_�a�7�:�ɝ����R�[�R�R��	��0j��Z�6L�?��=����7K�Ѧ���YP�鼔u7:��{y�h]B�Ё\�!s�*��:
��>�>d�P��(�Βe
���A��)x(�N R�QL��A~��Dm^&� ��"qU��=x� o���bBc��
񻪱�{��n�Y1&��Q�������]��Ȯ-�1�V��*:ޏԠ��|��̔�j�xD8�p�܁�GeU�����e�2��;S���O��Yk?�>D�j e&��>���Z����	�t�����?H��}�]�!�<� w��O��z��@�ʝo+{)�6����e�������G�?[v��������p�h��fbG�=<>�Y�IR�P�/�^��R�����Y*���
R���w��-��eKS�dj���-ݶ�[bح��iY�MƂ\���
���)p�v����f���Ѭ,���P�A}���(�˧K��s%��m�dV���
��aHjEdĸ�q=ur���9��βq�G��n�W�>������d�EjZ�����Mr����a�Hy���怗��r�:�)+Ss�1i�B�Ba`�skω,DUV���t�V��(��a�~^�%fk���J�@���*Ht`	�s�^�m&�H����a|�Dr������]th����1{Z\�I������E���V�U�s�I�jHW�?i���h
�M��(��:�{F�PZ����,n}K�1g�d�ZN�d5!vC�K�;�^_���>��.�0s�E�$m@��F�|��jSrHc��X���M��X+?ɡ�B��;d���X��r�H�Xǜ,�������݂��~���,�GB��#���{Q����gBM���I栩�T"d)���p��M�c �)��ʎ�VaK��b�2m���R���{����i3��(%��ZP����3�2R�<�� M\:�e�kʟdU�R\艋䳡��*�A���t(�.,�¦{��@���%�����4��!�M���Ə금~��H��R7i�龅�v��e��3�@ e�M,B��Ӗ�m�Be�r@,��u�1���]dҲ�.���,�cZ���p����N�?��������F"� 5��b��9�&qh-�Ҟ��@a�����b��kz֗@$�ZS'1�V+������D1�c!�#������Ȫ��Cp�@��P7�N��y��
�ߗ̊?)�׀i𢢿*�+kF��V��ݮ|�W�Ҿg���(A����%zhr��Q�q�Jo��+�{]�0��ʚ�0���:m����֪���6�r��l�fG��т�]�ʀ}��T����*R��Ev(�,Gw���u6{[����1��Vј*9��ċ�"CG��.�'�O�ގ�҇)�(���?��JװXE1����ڝ_��m����t���"�,c���/-z0���
?V],DOҜ�湪B:HUL�{�22�;Q��/���� �K:l�P��m�̅��yM�M��
}�*�6���=�;ww�XE�)�(�V|</�+�z�'X;L�T�����O�oz���^����&�
�O�u�� op��"+m'YH�����j:	��e4&F::��"�)I
�� �Z���4Ӂ��kk��֤5ws��!��=�.�3����O(M�*]���`P��6�d>p򬽺o>��jB*��\XRy6��Rw+�[i���k9D+&����Gsd&��*�"�Q/�9�������F9Z5h�\|&��GwxF~cY��.��5bؔN�a��7^(�ou��R�y�� ~����#����ڝ^R�u�1�NH#'kz���V��ʉ<��%�t0���lMس\m75�
��w�Y���mmm��F�W�lAW+2�8���z�HZ�F`��$�Y�;���3�ȯ�w��64( ��q'��閬`����1n�P<�xQ��2����$�UR�[S/�@�A�/���/��I�N�V�x�[nsb��"��A)��F���N�2C-�ś�p���_�x�H�/���d1@����ވ�ެ��D2�)��f{<=�3�f��w�>�Lms�.GDٚ��W�
3B�5xD�g��":- }���#�ǚ�L�u��)�P�tfnj�3>f�3?C�-�/����5K�C���/�3&<!�6�O��|�X̇:�#����0�:��/�v�zFn�����WZ��Z1�g��C�N���}.�(a��@uL�`ǳ�����^���nW�w����W���4��L�(2r'���O�Tx�:��B_?�Ν��\j�[��UC�)8�y��3�ӡ��$�𞥋�V.(���i��TUzu���S�(	����(���m~r~����K:���bEc�\���ތ)F�"�s���H)���@�ܱ�^?��V����T;��mI)w֠۫�no�c�Pa�~l�{���y��#-Bz����I������{e;�F���R�ы���ך��r*}��+JDJ�)6X@��
j�:��d}#.O(w��;���	g5�/>9�s�P���/���`���	Ku7M��.zZ�5-��+B�AJ:�+���M}�I�u��bI�H�B�\M���Y�[*�@ W8���^�K�S��f��K��ه�s��$�]G��7��S칩>�e��Z�5�#��ݤ�]pi��	��!����.<���,�ׯ4ݕ+���"�����I��H���H��ؐϯ~��	nۺ<�t&�Y��z�@CNE'w��ů"����0�=��Ȗ�bC�XGys,�y��_�ޮVy]�o~7{/
��Ce�1�j!���>�n$��~$<#��\R8�(ެ��}��h��O>>���ucڶoক���#]��}5WF'p��\�J,^�e�t���"�(���+������+���JJ���/��v�4c\�� 럍�TÈ<�Ėw)�����
 ����Ds*u�����|�G�n����H%�D����7냦O}���3���j]�P��c����AKၘKr�*��f��<W֗�E��s��v±��̯P��Zo������?hT�b��-�Q&���g/���(WX$u�*kWi���.���_��N5�h��룓��9D"�MX�V�g��=8�+o�)@sڭ���d�Й��$�����wK=耶��N�X�7�Jn<x�7������;bo�]��;�E�:��$��Vi�ҹ��t�H�!ܟ�x�f�⸴���g��\�p��m��zqE�|�YL��Z�@9�I���}Tw�ߩ�ڤ���I�G!�^�-�L��41�n8e���-@o�{5��B��Ɩ��5t1����������ҘW�RĪq���R}�j	kIZ.����T�I%��>�)��V�����|(��C���������bq�y$��D-K^W�ﲄ /X����|<�:��c��i�M�����&����
�l��{^��pf&�.��@�%Ѡ:l���>;���߫�E��P��OQ�A0�b$XR��\�]絠��    ,`�����Y>�9������S?�2�mW����p$;
� ���@�F����P�t<����
H�!x;�-�f��r���k%`<�֜_����|ذ�J���xC����7�.#�2J2�21�?$�]}Bm=?<��Z�����&���q�UX. B
'n�Z 6s��P�y^R�ȗB$�3R��Yϧh���(�_�f�ze���q�@�3e�'z�u�+�9�A�F��|��%y6�_��/b>z	�[�(��7K�L���U���6RIo���U���!��!AU�u?����J����s����1�b_�N�/h&��{��E2�?ޓ��!>�,������ȶyc��{)6�0�A:C� ����i��o�bT���ߓ����M>!�ҙ#ɺ�=�����r� ����I&��ǦYɔrJ[��X��y@��%���ߧgŁG�?)7AUjI��-Cø!۴�*��D�9L*#0��64�֣l���k�Rg B��k0��� ��ѧ]�I���V�Ȝ)>�Åyh��!Ch�y/�O����H�^_2	c<]@j���6Kc`7T=Y���G(�M�[����>������I}��0�;��}�u@q�l�LD�[iE�W������@��m�ɲ�%�M�����Ĭ�}��-j���}�d{��b���j�YAC���H���>8ޓ�~iC��t"��ez6XI����=���[90�ƖAx�]&|8Ҭ�=���.�?�>O�mE��q}Īt����k+�S����QDHn�;�@�9���nEx�M?"���˛�#]A9�t��N��h����]����@y��v�����%Z������Id���2L]Zl_�;�]�T/�f+�|�Z��i*�^\u[��(������*z��<`�/�@ם�l�]nfP��:.9қ�`y�:�r�*�<�����-i��V�1�ꊲ�v�c�������jo��&��`�LVx��p�� H�K$�C�P�vn���pn�%�.^Qӷ7����ۅ����)��iC��Wk��@ʻO��)��J}�G1�,H2�hR��ؾ|F�r�F�dR�q ��2+���>�+%Q��s�9���|�V�2	�i*՗�_�	h��QH,;#l����~�m��v���F
����U�����]j2�,馷1���I����(WY���Gs�R����� ���؂�H��2�'��F�˞�Cŋ�e�(Ɇ�ѵqe�^ÅЊ�[��g@�[�*Q�ى�r��?2�Dc�T��ƜB�t0��:\���ϩ@��ge��J�c�RgY�g�w�ܮ��⥝ ��1�r��L}�@	f�;B����F-��~x�(A�D���C��d�,�����š��=7��֢�\)F� �+d�,Mb��)�QQru^�/�߹�X��<C�����ljf27SȢ���2>�[��\F5�e�������)��5�s5Qm��|y��qD���T����Z�3��F��=켗�)���ݱ��������=Liߣ9=֏��N�b��]E+E`�^�����9(ᔖ��Q�3<�#Oh�WE���/~؊�c�@N��t9?%�5�CAU.�hRQEH-�m�%�P���5�F\��X{�$+)�����^����	�b?��Vj� ��&��%����\>�[b������6�W����F �5=��Bl70!�AV�/y�h��	7΋c?McGClY]M������:V�m?�{��Y�!�8��B��"l_,��������ڡѫ�7*A�V#E�jH~T>p�\��DA��؋_�[��I$���$��9��Ą�>�(�ϓ���(���:�PJ��Ӑ&�f��J�K��l�]�==&,ذ��I̐S����!�ܘIc�Z20d�}l����ɠ�9��_f�K���\4ˋ��^�_EE���)Z2-Ơ@�0c���в�,Y��t�����Su�E����
4IX�c�g7����S�A��������Q�#�x�7���`�?���0�l��4��+�!�rw>��2�-�����q�A�<�X��>��&�Bexh.����/�0�몳l��6M&Ŭ�����S����y���
e���㇌KH�4ib��Z��zq�p1 ��Hn�Vg��[HG�׳��XZ 8�7��^Iݼ�!NMz�� �ɭ��G����j�ѡ�yR�������?m�BwpH�L���~�e�Z���z<2�"����˞l�-q�\�䋋)y���$)0�'L�QB��� �~l��9�C%��l�'\Xw@eh�#�4��C���<�{LG٤3�(7�8ѻ��-��Ǵ�s��L�j�g0�b��qK�h:��ɺd��~s�y�3��Z��"�~d#3�E�J&eT�k���S�* !�j%��ޖl�"�����\k��X?�C�/�w����]�ĺ��QW���Uw���� b�0��������*-�U=ך0��~�{�+�7$h�鰙�Q/��k��yr|�h�?�h�Eڿ����h^�~��E3����A���� @����XPK�Y��\R�s�l>��K��͟�<4��\]��78�D� -hۖN)�k�g��*k�2x�B�O�!U�f��6^v���_B�����O���.\���<ˉ��wl(�7��B���y�_�pQ��^úV�t	zr�3��q���T�B��?/�5c��1&Bf���.Ma�����]�I2�H�n������>|]����t!@�󯏵x��0���$
�>�u����_��b�&#��JMl���N�}b���xD �b����>*�|>1��E5�����|Ƃ����T��d׮5w��(�ߞCM��z�-��4��4� �"=���^�u�]��s����:㖠o-L�}��� �U�� " o��6L�݇9i`*���9�{S�p�������gi/9TZD-]>ju�o���bu�-٥7�w�0z�R��1=��@�uR<��d������'�AX����)D��80�e�ǉ�rX�?x���g�ܾ914��f�i�e��trrd;�<Mv�2��?wU����������>ewn�8�&Y����p�m��O?n�2���En���\�'��&JJy\X�0�e8{;���RوX�q�'����h=k��z�&�Jņ��S\'�*�� �J���"7�A:�]\�'4�����̯nbF����1��(i��c�_�f�q>J������$�+��ײ��]�xAlP���gO
M�2;�͒.^�x���h�^||"P���7�D�n
�x~�ݚoH�f�Mr��h5��n�n�$�/�n��[�.0�J�Y��W��Uo��&�Fx��o"f���o*w��1�N�q�<#%�Z��$@�e�_Dhca!��G�h�K���|����J�k#>F�}�t�dnx�����Ǻ�^�Ɖh�e�*MΤ�AXN���LF�7#L�<)�6ӳ�h�.�Li����\����}����1�8{"?Ō�mK��N��);�1ЅWh�s�)�s&�p״�AO��DLC��o��J�h�sC}����}�吞�g����}�7��BV?pʗ-GD��47�T�����g敿�z��:���0�3:8k�{`��ʳ�G���YI1��]�Cl`_1d��xѱ�Bw�cR�E�.`���|�^�����s��'��ұ#c�޿�T��$N�8��k���� ��|Ӄ�E�3G�>��I�z��a����?��Id�J��JZ³|�ZK��BT}[o
~�=��F�<c�_׃=���{73�oJ𴒔~.A��.����[V�օ���+����U���R(z��p����������[�a�>�S�`�q��d��%]Y�j�oVZ �v�`6l�||��^o�!�f�X�r�� W�e��L��8*��+�iZ��>?z�}�T�ݛ���ߊp�V��ͦ�^���`y?l��z�t.�uym�&��ڂ���Q�����ֲ.*X�O�җ� ���/ٞ\�m �b�ԡM�l@�,y}�Ѻ�/��i���� �&]1h?z$���W
�ɺHS���(}k�>pr��WD-��%�b�O�\A    
�{�5yɓ��S
S�ؠ�:�:h����1Y��"O-�tBtz{��fM�̂�lK�lm� e�/�V�QSr�Ű�����מK ��%�Gm_���g;���K.��!t�9�Xܕ����-����b�(�����,-�˪�,�φ���d��[��oه-g�Tڱ�$0�����e
,Q	�_o�`4JXzpHjM!%f�=4-H8�r_��)`w��"�a�2�]߃Q u遑v�뜏�����ɠ���1g�;��j�V�l}��}9,�Q�G���!M'c�No�C�Xj/��k���5��鬑P�z�Q�[��ڃ�6�Bd%Q�r'��% F��`�7��9���;��]����=���� ddf��CDu���QhN��J5_��&G����Ȫ�k�b�7�;�����}�v���"���+Pe�����Ӄ;��T�[w�;��&"E����ˮ�J�mB�2�N���e�l3$$�Ҳ�������b���N�>��O�n�n��k��Ύ���\�2�\y�i����z� �|���C�
3{$Ve?�`�D��Ӂ�u���T�f��o�z7�Ϫ����s����k�"�P�%]Ū6i@\0��2|���͞@Kz>wʎ
ҿt��b�Q���x��}����Z��˴w?>�Z�����a)L�4&5��m�j-F��{�A�����3k�5A��c�l�2��0�2��ha
l�玦?��5[��2���b'A��Jي��"�BR�ĕxB��_JǡE��<�O��c�����w�.���v��&;��j|��g��v+o�}O��ϟ�nWW�P^��2HӗɁT��1
oI���E7-0�!�p#�8���9�Iu�&���~�-�Ć]�"��ܶ�]]C�F�ЋHإ����8��RS��ft�-�E`�C��Ƀ����9gG�U��iZ�p��MC$�^����Ҵ��m<��<`W;��y���̮g���J��.��4��^L�0��)bq)XdI�z7�k)j�c]Q+�{"K���B��ݶ��?�7��۷V�ȳ�6��ch���/-'�����ٿ��جJ�eo��Ӓ2V[�س�}�!��� �!{�#ʖ44_zK.`x'�\��Q��_�Z|"}���O�b|�h��)��>���ǻ"^I4���2����^J㱩S;Er�Yr�Rh�aSf4�JS�Sd�����0=��c�W��T*#N���T�k:[T-'uC��
x�}�gJw@R�L��̪f��I�Tz�8'J��#��(�3r��SӃ�;H�ŗ�%e�&�B��2��o�ͽ>W2�jW�����Ճyۏ
�y��I�Xn w$�9���~g�*iR+:*e']pG�T�~CN><a�|"H%���>Y���a�!-A4�w�}�7�d?<)=�}�����<�=��+W���nvJZ�[��<��&H\k���������.�ExWmR��z�j�s5��w�n�$-w�L'�($�mIc�_\�a�����L���,��;v<�}0 ��^ �8�Q`*W��E����b�|INR��L��ġ٤sG�M��c�J�-�+�+c��CS�a_#���� ����d�=����-b�&ab�^���"7���r%d��h������X�ӊ�����q[��|�ß�~j1كL`s
4�H��u1���C~:V�p9�hn	�xD��=x'��}8R�(lͣM�o�i�#�pء8��>�ImMK�XHH������4�]<���,o�������� ��Y>����x���V{�h0x��RN�U$.(c�π|"מ�{���r��My"TT�giN�>���{s�d���灌/�c�b���T�������{O1i�Ջ�#܇�jT��۾�o"ڵ��[&d����J�L�y}�g�^l7 ���l0O�"�ٚMD�����7(y>u-o_;�q�=�*�l?���R��r�(}�c&i&��N�طU7����(۟�l�;<d|#�E�*}zw���g��[�:'��Zɽ�*S���JG�ʅ0��*�Ss�)v��B�rW�r��p"Ʊx��cPY��y.�(�����%_����_�b�:��mˉ���Y���:�x�J"aĀpǎ�����Ϊx�iJ�Y�e')Ǐ[�q	��΁v�u�Ƥ��.����g�A�RP���_�o'�W{GI�鰺�A*�ʦUf��ƊI,eA# Uy��D�S�	�5z2P�����:n��N�T-��r*��*9(�J�ci�|�Z��-7�UC�秗�^YH�`��8C���~#�5�3����jץÜ;�3���%j{k�J3�g��؈}�k����~-�����ّ�k�[P#¸�]Ϯ"����&8''��6�L�@���@s?�m���א�l?3���h?nQ�(���%㱛���.:ri=Cn�XS�{;*=ź�fp�����O��������,�:�_� E�o��6��������c1�-���1%�9�jz�$��U&�M3���V�yR��M4]Þ�����0�����al�����~Wl?��&��<cڵ�#>�\�r �|�ԟ±�LoĻ���6�=NN�I��K���1: ���#X�Dr�Q��Oɤ��խ3-x����*_�s$/�#�Lf�d���['��?!�|  �#C�e�f�,����Cy��*J��y���!_ a������5��
�q�I��
�4�T��yΙ� p���m�K>1�J=��S4tw�U��E�)�y���{�Jo��I��) }V��]U�u/�s:�;�I��k�$~N��ұ38�.�L��Wi���?���GWHf�09&��p���3��"�:�U/��{S�\e���9mC��� 8�����L��oI�M٫�LV�6���_xy|�$��&�?�cHs��\�d-���α���$6_윕4K cQ�@�,+�:O��%���u�܆K+djb��2��g�x�A���DxΠ.{Vժ��U���MY�������+��E���t�����F�J2�'|�L$}�v�d��r��(k�ɢ�棻�����@U�e���
D�lI8|TN�����5[��9A��L;=��M8f7�O�ř���ĺ���+zc�D��B�����mK7NXGT(		���u�-��y���R�`�~ٯ�jZ�z?s�d����W��Xo�0fN4[�:2�r��f�X|���a��ݥ�\�>�=�Z������^)T6X0�&����F�ƿ:F|�T�7ۦmѸ2��g��	�~%����*-�^��P�",���Wm���ࢃJ�f�ӥ�oX�u��ղuR�ȋ ?8�|S=�S��'E��RA����̃�)ʡ.K�y��V�>NԄ����4<����gw-prc�� ���eS}��pq�KT�Ep�P���x)�oyT���[ [����o�� 10�˼�j
=?�i"��L��������0x���g,�!������+k�<��m��Y8�M�{�{<.9�{X6�/f:ӂ�Զ��S�������ٛ���˫��u\�t�mzpeW�������J��x��}|��Z�<�gg����n��0�_n�o��ˉ�-���ەI-�a�/a7�ԷǪc]=�J��Pg[�}�����G\U ��N�}��y���g?l��M	 �k;%v��r,�xKM�/��b+R���yS���<$|jK�2�%[]�)r2��0�$s{1{+�/�oD��k%X��$��X{;��9����"F
��ò6
WE3�)8Y��me�ŀ
�&� �dv鼡��To���	0Z_��9�X�?ߪ@W�55��p7��}�(����`�a/��@�4��%
��3���tv5��J�����*�(��^�.ZѢ��m��G����X�[�9*����>B�@H���?���܇~&����> � O.O�W�����?�IFӠ
f)��>�J	��0y?]�E�o�'�G>����,��x��~������M�+
��D	sP�&����Ԕ����"e`r�r���߈)�߲9�Ȉ��_�����C�`����W0�    �E�KUh�H4���H��r�t���o�)��%� l4>��������jJ����]CS%
tw�]o7�J�� �#7�_;Q���o�ۣBin����B�P�B�v�����
eaU<��� ��i�Ç.��;���{q��ϩc[N{�Q@��Q�E%�E�OƣuT��@�^�K�ݴ������	w۱��5R"o���B!�s��޿�Y+Ț`����hB[�z�1�J�0u�	�#�#fyC�ͺ�(�����%Ԫj���!���8���v�V	��R���ހDR?Ҫ���W�߳�?QK�R\�L�r*�BV�ӑ�/C@su�	�C�J�߁ 3��?����mBg�H�|�'�����9��kP18D~�T�v�l2}<d�#3�ƚ���v8ƌl[Dt�C?���ei�]pg½4��C��W�N�"y�K���td�9��S W;.�S�^���`s(mh��4�1en�+���t��*9����$y�|�H�|���L����B$[}{����S�/9T/!�|�4	` Vԗd��O��gS�y�4^��j{ޤ+Q���:;C.�}�+��N@n�J���P�L��8�E,d��	O)2�u �c���������"
c�u�)��N���?�S���J��cz(0~�J6~	��Qu����ߜ���w0e�@���E�8'���#��U�����[>E���4.��bgqR>���p{�t��q�\�\?|Qt���C�؃{ۇ��Q��2�@0d+��_�idh̠�B6��%!��b#Bj�}�6�,��"|��;�2K��U�19��M�.��5H���&3���d�
2m�M/]�&��vT���?cܢ%Z�g'�]�=a�+�;�R�l���)i����J�_�A�Kn�ma�M:�B�
��5���x�-�;A��U�I@�:d���
��L����>M�F��RPHޝ��_�8܇F�sń��T��$���ȐGs��lhln�C�ɝu� �-���wQ��F~,��4F�SZ���=9�ҦtGqѦRP���L�č*  ����N��o��N�b��B�v���H٧q�R(Pb�M���Q@n��;9/�˝6�*e�2�٪@�lw"] q��*����x3�H����'5�?�'�$E�<����O2����n9Q�#A��8�^�w�p�EX�)f^E"�2wP��%Q�Q��3� �^4t�V�C���A�ю�1�qV���J�}�p�)HW�e߯{��-��W=/c�b�S��X��(5��%��hgz�)��][���1�}�2L.�������,��Q#V��3d��R��!�*��X��/�5^��$�M�̼��*����W&��b?1��K 覸u+O-�T�k(�=H,(:� q:q���oy���gAu��էf�9�Q�}s��k�0�Q�,�Y�
�^�L�#����	c�{p����j�d�B�L��k��PJ�Y�9[�f#xnӪ��պ�ȶT̶(D�y�5����yԬ��RJR�Q� ����C�uvT��D���޵�4�$A��X���
���U-�0i-.2	�O����=7���[p���̞�$���ml�f��es7���04����Y�s��(V/�Jb�o���u�ַ���o��ə���2	����mݑ x��h�9�S��ߏ�)؁Pͼ�O��W��O"�G1�e���?'���/�x[G�r�Ëi2��>��S#@�B�,��Z��V�cax~��z�y���w���ρ
��@5�YY���h�ԯC��������$)���!��ʝ�j"@��Le�4���<}S���?��`�4�����,Z^"���=���~_Yw�aJ��iZ��Z���ҝf��j#|ӯ~n��p��E�6c���Ϸ�d�%�O�)|�[|�Z��|=��g��&����]�L���n���@����a��>���L[�v�g-��l���}��?��tU�4����5��5s���]P�����lF�V0�&�k10��r����nv���6k��/��>�h��]xG���m�\�+�LZ<�UJ�_�������2X<����Dϑ�m��:��h���[���YN1�Ȭ�y��.����B�Ex�9{iz���w�D����pJ�}8c:2�A�?���nF��W��*�Vu;l�|�x^L�\-�ƞ�J�" {�z���_���/ޕ��2U���w83�}��:�R�;{��V�[�c��.�H����R�$�̞�%)X(-ly��y�J
�U�{ A=Z�F�&�JN��� �J{��:o�}�py�#���<+�*<����5�i�çj�[g�NY�;��N��^k��
P&Y'ru�1x�����?@B�`>~�*0��z��UH��=Y�=�J^e^�,
�z����/f+�5��ph�fx��Ey���T�4^1�@�n�v.���T�K!�3 ������;�sf���gr�L�<���l���nz��_�-�� ���@ŋ,����(���X��̆h���n>��TM�	.KP��}����M)r4H�3��*KV������鿢OY�ڪF+�&�4������<�݁���~�	e���g� j�|3�i�A%ʕt�`)�JP&D&i����y��G���9��K1�:�h&]˘��E��A�-�-��y���!��S��ݢn�;bJ�.a��>6�� ���VJ<�t8��)w���J�ӹR�C$�@�5dD,��S�HV�E��9��1
r����`'����k+;��PtH���H�t��z21bJ��Q��y�<�w&лd5����Ѧ-�1�^�Z�(��hQ^��^����@u�N�r���/����>#�5|Sw۴��7�¶i��떋0��P��������:a;�V�睛gu;B��������HI�)<�KC�m�{��̮�����ڌ�ǻY�S׋���k�Vq�'�*��iW��m�4���U��ev�v��������)���	�]��<�k�P��Y��!
5�8��4\�e��ʡU�tT�y�H��(�Q30���h�����U۵�Y��7�n��]z�Ea�����÷5�
o���&�8(���5 GX׌��e�Wz6�u*�I����B�J��锞ԇ9~��-e�}�g��O�;�y�Wf���KU�H�(�,�A�9�p])i���N�?���jɻ��������.X�!�����YѰ�!�|���.K��}4�-XE>T���o~ �Z��L���옢���C6�Ey���l,����f�3���|�h�u�<x�(�^�Q�E�9.	�Z*���9��B�*���ꩽӬV�}���(��/�������
�@8�,���L��ho�e:��Թ�[�ݥ�׏N��oG��L+�#�bēJ��v����ub�rG�8+�Xв���׮8��yC�^UK3'�~�~����%�W'� O�P�x8y�W��^�XB��t5(a�E~��-��̅�{�s<v�&y#y���}��������ŧ�O�����������+%�=O�KA[�ķ��;�l�ɚ? fQ3��OۏMwo�>�Q!�96�x�;\/�$�b�5��� ��%Ì۩};]K}��XE���p/��B���d6�ث�f״��^�$P>\�Z���N��O�����m�nn��ݪ�g`�|���Y�[�Zk�]�SɏE�.x"g �t��E�
��Ӌ���Ǡ�V�>�Sp&T�o��̋~�c�-�>��6��P޶}��Uq�U�s8�[t@�l����L�M'��:,Ư���"�}�� �"V� HH��N�S8��ezك�z7����7���r��mM�;����c�0�J,�5�{�y;��6��T�ڧ��mV疏y� �$�½p�lR�9��WI�4�cr�N�a�mrV�fr{ZW�Z�w�gv!�
Mğ��X�d��
��!��bJk� ba�>�рkZu\��F��W�l���V�p�����'�}�a�<�'0ŁlTZ�Y    ��|���o����=E+�:5���̾�@4Gcn��<�s%���s�9s��4�}#�l�n���<�V����/���@�d��Hl�u�%0���M��ã Ry��F�@�}�D�Bu��?xr\aw>'�X�enԲq���8�(��W�=�;��(�z����p����(m!��Y�!jVf�*i��aE�r�!O�`�A���JR�K�>I[A#�uI��݈�#k&��c�	��c��� �S&8�4ˇ�]ϟ�g�	���=ұOc��KC���ͬ��EH1���|$�5��"�:��*�֟k�y����("�������F��!cvr\}v�ws��r�p`�#)ay���
\Ț":����f��c��PZmF������*�<�q����\X��y�Z̿ݮF�o#ڰ�_��D>�S$o���R���Ί�I�8�	"��\���oY��p��.C�W+�U��^LՍ��U#��Zl�"�w`�=�
.����L��~4�Û�˛��|�gH��8�VUz�)���:ɼ��k�-�6��i�ө�v슒˃�7|�!��;j���*i+�0���x����t�=��)�#�󜄡_��+d�mu����"Y��|f]����}$�8�$LCؾ�<y�[W��ՠt^qN��[�_�6B���.��y�|qU�ƽ��E�Br3����H� B$��bDZ��Ö�� �H-���Jzv��L�g5���/D8ݣKd�����~��t}Z�T�W,Z�E��(���83ա��3�Eϕ�� Uz�����үe�+�P�Q|J����[������C�Vh���{���ܙƷMY<I[j��lY��L�/RW5k�Kة�`G^�3�탼F��ٰy��K3�]5%�-k��jI��H�!t����K#)h��>�N��GGj|.���y�x@;E�����G��0��]��9���`P!�=�B�E��+����B)ً��3'��Q�IB@H	���	����1I��,_�B��`��6�(R��GПY�T[��ّ�?k��[��δ(q�X�P���0�ICD�-�z5B�Ǿ �\�Ώ�ܒ1{�L!��%�����/�t��,d4Lχq���<D�F�ۨ�h194^�亴��p�׿�;����3�G[YH�[�8K��C�8��Ξ�h��X��Ÿ��_%�5����C���hQ�7M?�=LnH�Bk	�7�:�r[G�rK�9���ݒ�:!_��9��m���v��e�s9��%�'����6]O҇�V���l?T�T �N0e��CT�-��fk]K�0i�J�K�#�߳�3���poZ�z�k�
O�W�����n��@q�g��)�;a��=�߬�DL���4PK�B,&L���N�W�4U��c%�v��N �,��NJ�
Gl��	(I�}_���t?D1[������!F*z�����R�G
D:8ɻ(���0�����oxpL擕P��V!��9GV�1���3�Q�ͺ�}f�1ńu>G�¢i�Y�j�a�\��BP���K���u܅�3�[Wp���ǽ&��r��&-ᅷ�&�ٸ��">�������;���%m���v�VV��Eb�%]W*lV�k#���ĩj	�d.��X�i�Ֆ���#��I�i���3�0�l!�VTgw-���z��b.����*�G�&�*n��+3v+[.�SS�#��P~N(�=-��R�����J�z�.�*�n$ó7��+��/�0K��EH�̙�M2��I�;`��a��H���
H_�O��"������ʉP�R�-�F�z�E�6�����
Lm��e��}��oɸ�{i����#�I�MGtQg�
�T:�AE��x�A��B�`@1$�� }| �P���C��-7��D8iɧ��m��{]G9/���H�����>�^�G�S ��̼��j��Ur5�6�ч}�g�7Dt2*�x-*�(i�臙��n���097vC��zEq���,LK�I��ki����u�f��Eu6�ܓ�R@��%�D�?��l��ԇ4l��_��3��}�➤V6����Pb�ԏP�0�����4��w�6��r���p��c��V�}�6K�/I1!a��I0�!��a~܋�
)�W!���>{F�#f:MA��0_{6��}!��&��f�Z�.r��`YAhc�@[�>�m�B;�/��(�J���t=�	 `�/�Z�����]q����f�4 ��l����X1�
��I����[H��=e2�S�Bc��x��,z���L�8<k�J��铬zx�m���~'�5�
m���^��(EZ�[a����g��-q�$�L}{$=�̢ݑ����7���x�f�(�-�������c�ɇ�Z��v��I��(~�X�ջ6Z��e�1Ѧ�����4��iܕ3��87�ƾS/t��0	*dӀ��J��Z9~�b�߲�S?L�D�GtA�R��(.�e�j�*��t	�d>b�
��rG/�q�tvu���q#}l̿ 'S����O��j���Uȫ����T/&�E9����7a!��w�Rr�pa���
}�_���S�P���ܨW���9�q0�I�v��g
��������Y��%D��_i����
l���hyD�]wK�eiơ��}�x��t{ݮ�
�Uj�F	�V���LB�t�Z���X�aY�������h�D�4�zE鳋����-�)KpLl憗��8~p _������M�/˶Q�9��JDLW+��K�5��FJSgA�ߤv�����݅�t���%��o��V��ד�y%?�P�5�Y|X����4�)3ԭ#�p�`�٫]��s_����|�w���g�n3:G�|Uk8������@����l�5#vS��oX�\�T�z��i���y9�<�V��DNns�a,éþdک�x�~`��J�"�G�F�ɭ�m�
tc,4�ZHf�n�����t�c���{������m���ͿI�(��Y��z��(��~�K���6�D?,��V�3E&��/���>����������Ux�86�il?�|l�\���j]eQ�����ܱ]
	i���[��_��mT'gz:�9��j|���+7���\� �jSjt��&>�>nG$�$ў���>�ô$�v���]%��/�0�����%w(l �xrBMY��Q�A"n�˫/m�VP��Tbp5fkof�g�+p�i2�l���~;z�^6u�)�V	��e�,�|;H�0s��LI�ka�	N��M����@�IN��U��>��k��jg�fP���q�>������� �^-@���п�	:�/�Ů���pރ��)�R��6c�5^`a��}�ֺ}� �/�o��,a6c�K�H#�_�P���Ǐg�E3,�\���P?˝!�m����s���Cmwa�6_�Ib�'�QjFF=���ˁH��2��@'�(UC_im��e/HBT�uJx�u'M�U?:y\�ʫU��7��ⵠ0	�!iY�O	���=& �ĭm�m�����i�Vϗ�r)��C#(?�>���y���y���G�b��. Jٶ�ze[��DqU��U��:7
�{�y$|
�iw�5#�0&' �}?I��d�`�6�|>�^v���U��K�Z?�d��3:��&t��Pc��6��� ���t�ƌ�6�#�!)3��·����A����^6����X������3%�w�5�ve�*l�,�%i�3�Q��r�2Z�2�1_�#�^X�x����"��qD�L�ON�Ltt�@r���RՌ�+WV��3��G�� ���.��	7Nc�9�V��ޱ�!��b>c�-�L���f�W_������?��l�gIo���0I�#�)Y�2ZA���$�_ߥjI�K_&{�;$�Yh��}�Z|�'/I��[�Z�he��ʛ;���jDH�ō�lai��f뺆M �>��Ǯ��
T���н��v�H�|�ň_�x�G���� �T��V�1�s���|��Q�D!C�+ڑ��.�i]y85�B,� �AH���!Gy���`�i?���̈́������>����>�2    wr��/�⊙e�6��_0�9r;�[������*�0[ʣ/���r�v�����Ҡ>�S��r�&�r�Ò�Mm��o���T�#S��� e��e���N;[j�M��|���I�|5:o����M4�+Tz�]�2�M���	�R��>�.���^�Q"�Z��j��o�g�����¸�;��\�ٜ�'c^W�l/��R+��j��Ww�μ{6s%���
78
W�t�Y�:P���_ ѧ��M�꯻|���*�1TG�w�ۖ}G�B-}���T�D�λ����mk=��l���BϿ3
<�^�p��y��~��=���L��(�G��g~���Q�*����<?�PثT��㭡�c�"���t3�ܧt �Ć���{qJ�.�t�"����ξ����}:�xs���h٪Qzj-���5>�k ���cЉG+�H����l��e�P�d���)�Ce:8yP:I����DfeE�Q�8m+��x�r�:L��v`�n ��΂q�s�B��hv#��{,>|҅���<>W�>��%��@Lg|BK�8�������l.����k�4�i8ř<��!�w��?��֚�O�S�=��U�bU�La�v���+i�<�<��/N��]�Ó�D-��×�Bi��Ґ������T�����z��d�G�
}�a��|FvV�|�}�<�f��N}f�}v��SKX�U���-,� RmL�"Af6�c�S�723ہS/�u	��������bq��s�E̕�/����n�tf�0���S;��b�,�2G���9#O,upA.�q�~�]��K��Y:��p����{ma�L���\v&�1�1c�|.�Ӌ�q��
��\O-���~�k�N�)�;qL��$�T&z�n{�}w^����I]�w��T���bvj~����b[x�bP}`u`2��E{��ų�|�����;Z ����bv��D.g��	P��JC?`0�K���"#6�S�p_�p�y��lV��C+MB��,���DH%��|M��6���;̆�1��\�N��������Z�fu��p��Zr��}��8v�h}��JGš���@�6}�
OOv�gE��W$��}��n�G�m�s���\�No�H�&;%_����ϰ�VL��0�-�R-VKcnR��͢�!�g!�㢔��l�P+铥'��lnfg�3��4�Mc�Y􂝒�*�~<qTH�[GM@^~!}!\U���g$R�z���*��$a��coӸ<�����3�; A.�Ql��W�J̺��x���,����P�������t��G'-���`[f�q�U&G�N��c��#��B�Ѧt2;��~B���i�;��/�=�x��Z�WYH< #k�0sB��5��O�Q�Q��5n���˺���tvv���pT�N~yh������zE_D
1(�Y	N8������9q.�"�˳���_���&����̒�m�y1o�����ĕX3��Hj;�#x T�ޘ~�Q�i�{mW�6�F�v8�ra<��&u�ž�ӱ>�sȏ�C�җc6�2¹h-4+g.����r�������HΒ����dӤ��{�[�AB�|��3\^@�f?[JC$��R�i��<�����u\y�V����4�JY$΂�3,�J 4}Α��>��,�D.A�+�:��Dͦ�܇��*V7��hq���m�0��F[{S�(�sɩ�jBA�gB���gf�K�Z�Ѧ��tI��מ������D�u�%��o�G>D5�y9���x��="�I.��;���7���F�$�$�����q˭`����m^iH��c)�Ε�,�<�y�L���'�ZD�>���''Lk��m
�5p��5F>�k3��&ߘ2��zX�~L�j��p��.���\���G�ce
!FqX��<U$�iG����k��b���wj,�Vl_�2�9�F�6�]�h>FK{J��rH�kj���P�-�'��8����m������61�2�VR�л"�_��j����Ϟy�*bE�"i�~ز�Ngu���>K}�Ч������>�u,��y��Dn��Y���,աG�A�E�Ɋ�����9��3[��&�~t�k�o*pv|� �%��k��^ZS���0�:U�(M���������>+%pqf�x��_BF*�/��:��_�d�@��zE�i�B��/^��2���m�֥Ò��f׃'�f ^�̸D!*!Z^B�����2��G���%z�I�J���_����tD,b��(�e΀W\[��T�����sf+�5� Fp�F��1�o��rv~�f�j��薐J(�B�`�ɼy%�:-2|��q���T���2M� ��=j�\�G���+Bd�4�9]�ί��e�������k�N�?sv�AG�[�%�E�3�%�f�����ji�ݺ���Xq�\�;ǌ��A�bC����XN�柯t{?<;^ha�(Uko��*��|&��d���#Ͷ3�1����Dҫm��f��Ej�;�h�=:0P)F��@�#"��bC�2���<�b=�ر���o�)O��Ћ�P �g'�h=����^��bY;�����R퀞y��� �Ha&����Fh	k��B	&TW�F�FJk�'�*�H�����ũ�F�st!��r�g�4���h/BQ��yӃ�em�$JPYl�_��'{�rD�h )��"Crͽ����6����6��\�c�d�)*i�]���#�Þ{L��.ɷ�*����E'΄D�������vxO�����ܲ�i�ֵY9k��DN: s�3���;�g�F��N*B��p���o��R��s]�9�y3�t�%��.�t}>��p���vjR���^��
8�O  ��{|�}�qdX�A�d2�e%��t��Q��fc��[��IV/�/C:|�O�bv�V� �9�L�T�l��*tM���C�}S3Q�&�lį��������J�p�>2%T*���r���E�O�ʅ��Tj]��\�\Ϯ��	 3�_�N�e�P]S���2�6��� E���$�"�LWF���#v��[�i�v�;q9�����滤�2T�����(^�.�[e*m���2�����(���|L���� ߈p�B��gv5����^b�?���uh�<H3���
Y�ȶ9E��[��݁X �5��_�V�w�)g��e�Q��O�zv�n�*m��$�X!� V�!�F�S��8tO�0-����!���u!붗<Xx�f����~�V�ǞV̈_������h$�}K�(L%et1G^L���ZU>�pfh���Z�b:�v#2��L��xvy2�g~;���_� Hy�Wxp:y�r�%���B)M�����U8�O����eHk_�:�n�����dv9��$?�8n2P
�:Z�s1��!C˭��;Z�wۦ��^�l��v#,��R٧[��<�mĝ>�˦b��vg��]���<�]��G��1��jkx����S�	k}k�j��j����B�������eC�'J��3є��G��]g~'{7g����x��ɭȧ��9�����<5W�;dD�e��$휖��*h�\�� �%��d��8��=��ܜ�./���%����P8�F�ӱ���X����e28lz�1:�<���P��~T�#|#�<�m_0��.f��o��қP2��[�U1(�-�?��n{$w���J�lm2�����,z�Y!�+�Ƶ���#�_����I]�.�T��}f�`�(ȁ�/1��9��(I:?����R�,=^���Y�817���2c{K�����z6�Z�iR��\){�I�Ŧ�)m~栰��9m?7�'���;��G�k�	`gt�B������n{�����0q`���O�#�?6����b�k�C���`��lT�=��?H��Wd����j�����`n����W�^�9m�m2R�E�"mJe���1��k���B��`�5��K[��l�X�����P`�D͐��3
T����UI�,5�2KTZ��tD�j������I�J���$僤g�c:���l��*yX�9��:X����dvu Ӳn�e��Ѯ�0�WB�K!�c�'��    �Fl�����C#�퐚�4A�Ƀ+9D	��>>�]�		N(�i^�H�
A� X��|ɴ�]� -H�^'�*��H�x��zUYub�
�.	�����1 �,��\n���M�����+�V�v���W�G�ft}�3Q(?*Д�N�oa�P����gW9�k(T%�=˸j���8:�7��&�1ų4�]2uc�$�@�".�;9�R���y�[�	P�xB���\̮�s�~��[��É�.�y�����Y�c��s;M���>b(�����i�X�֪9G�T����7�����j�23	�6��[�-�[ޢ�ԟH�A�H�{��q&+y_.�A�Z,ge&a��U�|s�՜\}s��4ω<�9�xK���V^vy�?�����b�P�F���������n/�����:���K��ň�;`	4��]le*�|f�������տF��(��=�D�%��
�� e�#]܍&��mhنߤ��]���-ZTa��c���� �3���3Ne�Z۠�T�Yb�	��rŤg�^Go�w�pzhC��oKm���#��eM�1
i�
�St�s������[F��!k˅�i[	ץ�e�;�w(��c��XCm��Ofק{�$C['�����ڄ�!E�w�hY��l��՝�LҊ�/�~CrϢ�O-ݮ���t}r:�>���$�_�A,͑��9 �j�2@z�WM�=�¿=�S���Z�&�y r_n��ňC�_x�ֿ�K���>�/5���Ԧ5,��0�v+�s�r oE{�)QK
�rl�|,h�W��������������En�;Dء�nZ�R�Bn���Y���iY`�;�Q�,���[ES���;��K&�H�'�bvMn�'���|6�j�KfJ$��$�- Er&{X����r?W����D�G־�Ǵq}r9���o���_�����k������(��結�ٜ,�i�U3��|��OXh����Ѷ&���nHcf����u�`ZD:2u����Q�A�����TxZ��_��-1U��0�i�I,u�Z7��C٬��\���nHyDv%��-&v�Hإ)Oq)��LT��a����z���Ti���fW�3�:�����	qN�y�u�8���0�g�D��h+�M�W
�QV�[Z}�� �*��?,��a!���h#���rn�r�B�[�Ե��g6�����8	�I�������_`�� �$�������P���/B�w�$��]����շ�<NE*RE	� /�Ƒ���4�$N�n�=']�G���}rO"6}«�T��2PY��OI*��uNk���}.Q�L���LV��:���	���T�r�z��_�`+(Rw/P� |�QA"��\�����ҍ��a��(Z	mP���̉���Ī	-�v@��PZ���(9�fMZ���J#L!�7�����޶�z�E:P�^H���A������c�V����j�"����4��}	��]�
�l.b��h��x	��x@N���T�P��.���*F����$�� ^��u�2(�,�����|�3-KH���r�1�w�[�}��O��o��$s1.o�%@!��݀N�k�b�S����>�|<�+����E�-n-�U���O�
���2ᄛ��]6W��*��_�u�����(M�4�׏cZ����N���|�'�2�.����Bc�t�h!�4.�ځE�wl6[o#�0�V�a?n4����T�����A��i>������Q��GLy�S�9�@VY�l\��r�LSOE $��>x%*5�},��r���Ϥa	r��m�u얔��&5uJ�8<���DT�Ɋ��Gu}5�ѥ�^��M7��d��]ƲR�CI^l*�0�#�D��e�p�c����o��	h���z�x�K1�r�b�o�&�g��N��jB�"��:A[ڰ7l�S�1����!HW��P�h�47Ա�%��0�Sp3�jվJZL��LxT�d�~�H�`�籒e�-��k���w<5���j�+�Bb_B�J��W��9��E[m�Z���;#��1�����G�SԶ�e�- ���ޥ�~U�DsܤϢ�37H����I���f����)*�}%;���� � N��)��99���g��Y�=���H>,��M7�@�^���;�����m�خbɶZ9
�� wD�ʆ������P����)x�;��(�މ��[��U��ySFx�U|�O�.[Y���'��?0��#;��H�PI:v�sW[���_���^�@f�"�%�A���_v�W�Z��n�[)��ҧ.� ���#�G�+!m���-�OЩ.|��@G��z����ƻ���	�"1{���`��r�(/� ��>4+�q��^A]�A����v֭�'!>�c#�(�2y[���fك��	;Z�0�)b�<�q:�������*�}f���PZM��bc�-�����*�y�26W���<.$���+�g?���M��7�(mG��
�Tb8�&І9݀�	�%f���D!gٶF��i��3��M����%��Du���!������/i%�B\�_��˃%q���&�9?��t܆�J�q����bɑT�F���段��m�~#�U��0A	��a*
D�3!�3�:�^���}�+竐����=��	i��]fk! �ˍ$��V�������W
�5Q�P��U��Y`j_F;TrH��8����ܥ��~J��
��Ʊ�D�pn
�>�S�5��ߖ�ư�b���]��[��k�X����n�p�^�7\�� dۺ�a5/��Gv�4�6���:AS�6 $��\8�g�h�v[J�}��٥���p�W���	�0R�syH~�C
b[����R�/ə�-&@��+��]+�����IL��L�A�;�]���#��z
�a�-�'��x��q27�����W�5������h����ʯK���\���������_���UK>"g�R"M��T,I/=e�2<�z�1��m*d:
R�m�k�\�8�K3��x^��b��G��d���?�sՄ�}^˲JO��h�3��vߐ�~���i�0`��'�S�V}޺X��N���D�(�'�D;�os�U�����ѱ<���6)T�_\���ѧC��Y�7Fdu�!��P�lJ,s&��^�_�M#�6�k4��9֭�P��Z��J'�<�p��{G�ۦU��m�r9�*�S7vl�� �5�W�o�F�ݙ��,�]Ӱ]���+ӏ����\���}޺O����-sFP
%S+=|���Ջ�V��H�A+j	�����n_�d"���iz�#�>u���1��!�k���|r��4�N./7���5km:��C�+�G1��!g���l�?f$>��Ⱥ��x]���R���8)�kz��|_5k��xbq��^����8�-�%�wT�������$��V�D���$��hQ�a�zB}&��bz�v�ʉ�י8��ѷ髕��G��,@ʝB�(�1����$]݅���27h�X�1�>t�/������* ����~���0٢S��B*���ɴ���+ #)iQTTg�D��X�Aݫ�bl	h���ν�Y�_MP�g���mC���O�4L,��îi<�H�R�h��ߖ�+��̉�\�v�:�9�DIN� o���I�:�8�E.cZ�(}�S� �u,+c��농�Z��T�ם����=3��kdV�H<w��T��DL�v�gy.���g��S�p�'h��Vz����f�Sz3�2����7R�� ��z��+��ю^�Ũ2��q��f�������m��:�$�M�
K�:-�j���FK���ݐ�����P��`$z<J�Ry�B�ZU���b��~�R���Bi���qF�g�df�;|J�b��w���p)���QH!}�2PF�~T�I[����|��1�D�k��̂�}agmN7`Y���X^O���M��,W,t���K9���JR�mdT>�+�����lf��UMNS���Bi/�.��"0�S�ǠVz��j@�ep%i�2��[�$(���px��� �|i�����ݴ���92�    �ȳ*�(%y��|�Ξ5��w|y��W�2�f��1��I``�`�AG1p��ٳ܎	���e��sS9Mp5&z��"�<�]	>�S�-��4��y�[n��k2َ��W��̴3#�\��\����KRr�'���g�~���t>�3`I^
�#}���qYB�s��^��]p��_��`;VS��	p�ĺ�6|L�)>3@��@"�n%@3��v�����>�s%VBqN�3v����[ѕ���󣈲��xKEQ�e�ː��V"� �Y��Tӥ"���(X(V ��%t��@j�?�t��Ȕ^�]��htY�'�et��]�A��$�:��
^ҴNu��/�&f�#���VpNW;9��G��1������I��9L��_iL� gr���%�2�M�(�-�(�,���VX��m5��/˿�{��#4�`�ȧ� H��2&=�,:s�L�:D��"�m*��]��
y�����:S<]�S#��Q�����P;� �xڸ�����Rgdn�Bv�t�:�B������ڲ��,������Ɩ�X��97S�dȄ �(�`�l7 @z�.'q��Uʹ��,�|��^�,��)��j�ڸk�ܲD�w�{.�j�HAK�G��l"W�`>zk�"ك�7� ��6�����3|�)��:����T��3�=Z��%�L�'"O\�ӴMq�.�s9!���u���e\�UN+u����E�-y�O�����Iis�uGvB�QF��Q�����U%n~i�<�>�S0}h:�}���0�U-	����i!В�gu#B6���]-�su�u�9�[�5�W���.�^����tuF���9��q�-":A���٦t�"�)p~�)l�ܾ����l��	'�M��KnI~�*���k������e����t���S,��I	#�(��3��ЄC�ܿ�ucj�6�`���dlg�/�=/^x�9}��*��J[�0�Y`T��?����$5�z����vE5�Yr@A���&�$����o����e��%;�j���5C+6�: 꺺a�[ѳB��
�j9�a�<��N	�X.�ɋ��y�i�~D9��憀"��FYSyr]�ÿ�ϏFx���S0��S�Y���6�C�ks��"�zf2��:7�ܭ4,��-l'�Ek57�V�Z'tp��6�kp��yqgBϚ*ZV��Uz���0�8E���i@��vs�}�Xi(Э��/��7�2�5��(�,k-O��"Tg����P×����o�+����T�ÖX�2���yK��+��yIu(aeA������ 0��1(w�4��`|��v�Yf%�W�D�wo�c܅t�l�m�*1a�����n�T'�1z��6K9]��ݰ�O�;/�W�M��.5�
����~�ӆd������.K�g߅}o� ���#�d�4S�*j��HW7�Z��"膿�o�_8��'���ȉ�0�S��|7h�d��O+0{ƾG(knl��>q`
!M���JVs�dtU+��+���bcn�²�����fs�״$z���xL 9*�O�v�c���Q��wX^�o��ðLB���c:�tSP�o���PG�  ��r��@�D$2�F��h�tw�읃L�UG �%xg9ｗ��3׉K��Dɝ�W�o`k�*�ԥ������@�O�~��M�)ł �����Hڈ��O�l:o3��gw6�䤙:D��Q�ܾ{0�;��0Izm��7�ͱ����7tt7P�ȬT�
�ǂ��È����%�t�j���uu�db��Й&ޒ6SK�����A<�{hGY�'�[Ldq��e!���3��}&tvy!%�䓺�γ{�HC}��H��d(�p���M,҃<9LFH�����JilT�E��X(�R�N���S�ڡN�� ��P{O�$����N��Y;�y���y��^�d������Ѷ���)V5��+�7R�G����N���mՃu�v&4b��n��ļ���d6�r��B�հ����|[�f��e�e���]g��SI�5ֵWI˴؄�'��pٙІI��+ǋ9�m
�<7���������FdQ��i�c����)Eʰ�����2��;WA�0�N��e�Vcƣ�>'Λ_�z�_����c�,�>�6Zk'�����@��^�T�^�$/���}������L ��O�ܜ��*NU��֙�=M)�E��/��#m-���T�|q_�r�Ԝ����5*�E�Rei%��!t�r���a�����s��6�H+��;��aA,�!B;ޝ��+�0��g�%4t��Q���lY p!}���v��W������f�����_���b��2��B{�}-��?u�F�)`)r��� �e��k�������t7?�0�������0`#"Is��@�<YҦrd9օ#����d��b=��P�3�\7���j!�xz=���~s	������7��B���eo>�|f�HC��mQ4���.���>K��|q����
�5�\Ǜ~/��e}Y?�Pz�yU�����f�;]He|P�)
�N��J�;�iOy�6�W�x�|�`�y�DW=kȿ /t�}�D3�hl$��>g�6V�c���?uRI�j�N�sn�9nD�|�!��Ϲ)q�ۊPԼ�R
ˬ���\yrEWU�co���]��K�������h[XǍ��.�@��~�ۋ:9�mE�-2���cp�<4%�f�\01�7�_4u��6�+~ޮzG�V6��Z.l����lv�༞0G2����мꖽŮ��%����ص��q�x����I�dK�@��qe�IN��N�.���tO�8�}�S;�#eNX�/�=�Tս�#��%w�>���ԩ��C=�����
����ҝ�ć�w��~]�z�>�(��1s��)Ĥ���7�/�,Q�ɗ�뾷f����5U�X�*�8��A�o*$�Ҏ�ϫ6����=Z�3�4~�V�9��ů��u�Z�F} $�@��J�Z}KN����ĉwg�v�҇@kJj���	���Ф�	�.�gB�X@�
*��?�v6��R�uud��3X��V��/R�2|����ϼ���2@��!�À���6��3��y�hL�㔃��y�qМ%I��e��:��N�q�8_����B��[��t� MbҰ&�pKŴ8/�yf��i�t�o/���s��՟0�:&� ��2�<z�)�g�OH�78�^JTSvD�#���Jғ'�������;��@�/-鯚�m؀;q�j>ʝH���H���5��/��8��8E����KV�;a����9��\��q�ɳ�+���q�!���ƾ��Ad�fvT���+#p�Ն�o$R02'��@`�۲�ũ�[��b�.$3y:Ie����ϸ�����*/-�_�u�il�w�ckD,�b�y�!<���]����i��}��z]bn/���X*Zʟ�w@��3@�#�C
��f�����/��Ce�F�d��B7My)�|�Г(� ���O_����i��o��V�
(���ĵ�:�����u+�bA��f��A�"�h^e����<Ǐ�a
���/on~�E�Z�)bg�7��<��Q����|��@������|�RBϥ*�2a�F��[����P��2V6�@�SioG���n�L����Xy�@[��}/�`�������	7X�%� ~�6�)s7s"�`&�S��AL+y�!���6g+�[�t`��^#� ��L�-�b<���>7� ����C��m�${3 T�7?~%��b{�N��q�����{������g�&���m�>����=;�&�)�Ȑ��o�ϺU��N����A'� �m�Υ����߫�A�����YG�;X{X~����_�5`eJ���g�=�_��G�� �
��:˗�A9>1W� ���P�kU���p��"m�[0\`ϑ����`�Tݡr�TR��LGN�J������YE�vC<��[���v����g~̰�ȋh�(.��a���s�M�qxH��e�lӂ;2�>��=-�h��v�@������ݖ빍�Lc���nU&c�'��F`1o��8 �
  x7ƶ�=�v)l��� ��l1#���;}{�'���ܱ$���RL+֮b3��<�B�)/��җa��)���8Ё�k�3��֜�/~��3�ǩT��A
K��cy��9:#܃�j�p��Զ�(�?�7i�0�/����� ���*w�џ��[FN�Te+�N��L7������be{��6o�bwGZ@'+{E��0F����"k��:�`t��??\�'V
�	��;��>۬~}I�Wt��I��G���̼��HΡeL��s�>�WY;����]b�0�����6�2����E6��۾h[w�y��OJ?��V����,N�
4�"L҉<�N���L�X{.;�y4y���DL��a$6|e��,]�e��2�J�"���h�����I����.�U}J㸶=���ɽ2���B%��9�${�9$"�r�L���J���9�����|�؏����C���C���O8�u386�xȢF��$�����"ӛL+��:oLv��C �'���ɞ�Ow{G(��桵f���g�r�.	1k��Ck�.�VV!\.T���~���~] 8�g&s��1S��aGO��s#Q'�6��n�a�G�(jTe�����5���)ㄮ�������y �����^��C�Y3/����u8\1��+�Y-b�s)����0�vAk<�-�Y-��ƣ��y���k�������ק�5�K�6�$�����r���kB VE�q���z���Y�em�悊M&�*��Fh�Bh2�L�w�|��ͷ�����t=x�1�8��tT�w���w��@�h�Ȼ�#�z`�g���atJ����Di!�o�>`��������~�Y�@{� 譁�j�;��ɜ�i+�[f������*rV�ʠ� k�`y"0&`�p]9���F�aC�T�����/��8-�ش8��^�dAf�!+�nJOF8����ɗq%;��.E,��zf��l���?4�O�I=Ǉ�(�i�BSFf�q�p����۪�+��%'h�������7w��]���~�t.��h�Y'�ڀ.5Ӟ�M�[\�%^��%9t�rӡ�N��T��@����D@��f]|(S!�Q-f��q*����ǲs\|���7�U�)�J�E��k��QWw�^�/�q=)̫���V^����V$�5�d(rȗ��}����'#���D��Y��+�t^'�=���������-;.�r����Ջy���	�I���윱�m�7yܟ^\Y ���������O��S7��D�@딷�����H�t[���n�5Дz�B�Tc�}y������\�o9�\p�dOmӖ�H�У�ۙ�i�|��ʃ�,̓��W��.�08���`̫�y��ϜQ#a���ʙ�s��_�=y�����:�c��L>��8
�6�5��}H���w�tC��NQ�V4�'�b��|�Nq=�(���\M].0�w�e����lm�\>���j>��Q̐''�7����CI�b~CdP�y�Č�,�}��POW��8X��Q���%/�*���҅/��ܽ��S�5}���#]�2|$�����h|�Wt΋���p�����C�|y0i_R8a���}l�ʈR�5���uH�i���(��t�*k��]׼��9�?7�;k6�VƘX8K�Ή�����Xu�x���/TŖ,��9��* Pv��FFeܨ��}����5Xt/���\C��2�>�%�����p`��g^\.�-�i����&�e*k2P4S�-���bh����R�e����F������<oi@[��%=Q̏���{g�D��F�8��e�85�fF7r0�3��c�oŰX>���L��� :�B���,���^e���Ѱ���/�ũUxD�}0������$���^�;UE���Ò���o����^(0#���>�hv%����Q�Ӎc6��6�(�]�Ó��d�K����Aј>���x�C���7�;��\ټ䒓���l$?��zSǂ�y�<��vQ��I���[�ᵧx�&G�؏h鮝W�\�d9�\�f���v�S�#/�e��މ%eN����((�r�~�cH8����z��f纏�E��L�+�<&9��Ā]|S�w�j57�J'���-H>��cj�'��"�2g>�W^6I�ȫ�;���U�������z�1E��;�idB<���#:��Ѳ�q���97E������dP����F�!{b�?���TZ��ĉ����Y"�W� ��yӾ!��U��)(ga�e4��lBP�1��%ɞ
[�ī�u�a�CC'�K�|g��hp���9[����鉼lΗ�-q(=�s΍BQ
_~��E�C�F��o��U�#�yh���'<.�(c�J9�.-L-��m2ۓ��5@���y= �Y����j��ײ�6��4 ^�c���h.H�t�	*3#{Y.G�Hۥ���f�ҝ�{������~>�?�`�8�zun�uZ.%�j@��t�����NX�U���N� P,ieѱ��t^��
\�L���J+r;B�mr~�f���Fq#\$�0&u��=zN�FZ�#̽�+���rq���QIg/0G������et7��%:{ ?s$���w�Zu��p�\�\����&,��	�ӊ��U��߰iu��qX�/���h��p�Y�(�����p�Ji[3��H��;�����v;������Zȶv�3C�?y�Sf��� K�X!�ܿIk����J�����t����������-��l���`�ac�9�S2M|�ʹ]�G³"�	��}���ѣG���      �     x�mU���6�ɯ��[>��P>�J�*�Ρ�Yrȃ
�� ����_�Ё#g
�s7������p���{x��ڬ����?���G�dnH2��a��9[6ͫ9qAܚdb�;wn�䂹U�j�C?qI��ޢ�z��e����ݽG��%���7j���E��qݒ4ou�N�ݼE�(B�e>ʪٝ����A���~���M�:TlF�D�������<I���%�co�оln�������y6�Q��@�-�,�N�ya۟�h֒�L�v�n�#jEBg��"i��72h��P�����.��-���I�$�'z�%�?�ֲ3�{(���CTd�2�/��1[i~N
��=��X?��&�i՘�C,o0�1�~�'__6?HA�!S&�f#��j�Rā�E��0�F�H�U���%��ZB,h(#T9�_5�hJ�>��,lH00Ւ�d��UP������d�C%&��V ���i�q�e��P����#Dg���²~㰋���݆�1Y���e�O�Dq2Z?�.�)n(@1�"���%Q��*�,���i�����6y|Ӽn�:���`�a�ɹ��j�݌�����2g:+�.dB:��~��J���8�>aɎQK֌�ϳ��
bD�=��IS��Nχ���͆I�2�J��($N�]�|���q咱\7D���#�\�Τ��%��OPŅ�Nde�����|0e@�l�pS�|޼z��e��%�'d���}1[�?�]6�H+�+�X ���M��ʨ#ZP�_��b\���01��4�y����[�g��[VY����f�=��R�c�,o��c�Y��T�B��fJV_ׂF<���S��5�^4?m�𜹹�,�� ���"Į�:CIW�E�=}�@�>��T$p�&�|��:+Hal?����S�{ټ���9�T_r�IG�E�%~5SY�q����[���.�Q�]�ó����#/�gc[,�jV�Of�!��.���BaA�?���[Z:�טQ~pW�.��쎻q�Xw���a�F���?����C۶�M�      �   Q  x��X�r�6}���팇���QR�+��I:��ˊD$� ����{ �@�b%������=8�{��d,yAJPrI솯�Rd����,笙?a�.T�U��K�L��td�-s�����\3��,�*���Μ�+J٥(D��+�N(*�`׍���aY�L38��)�	��RcX�����_Xq��Ζ&�:q&�3��{C*s��/��,tm�+��\���Ԗ]�E,��߰
&i����`��_����#�����bk1��@m�G�_X`��+@��W��
`�0؄����dl ��Υ�5
�V�r��:��{���Q!p-�:@sM��6�CV�z����q�U�K���%7��~k����B�Z��H�Xm+���xrْ�l(�g,�U:z���'Y�x��օSp#h4��`px뫌��sW)��hEL]���\S����Q�7�b�J�^`;���$�VpS"0#r]���p
k|�p��6SRsn@���Gv/�t.źbD}�X�?<�ep4�P�3W��q��r�6@)�
�}&c�I�_�Ao��_#"��SY�U�b���t��/�I�������8�(��t/c�B�b͍�T9"m�������z��a3�cx��H(��L��k/�z�?���gHO�O*�
1����Jf��:��˺��#���$-��̠���J�JH��(�q_�%���_'�����Ȫ�sL��^}�M]j��+>-[vgeM�֙-\v��ZK|	����;1)h���[�G �t�[�x����q:�S�ç������]�c�ag��~桪��T����*��e:z��u�_����cڣm�}UЖ���G����(Ci߰���j�̮(0SU��-�U�y��}�>^[�@�U�M.�Ķ������4`�<S��@�)����0�
��ٚ� ���V����C�um��b'
u�'[�|�>8�6�˥HG��< �J;q ����!23��8�z+�%���GQ �+��"��١1�O�[5KX��@����[����EwdJ���Ӥ�v�j��<�e��n��&C'�Ϭ�k�S-ο��T���i��-����X���<��k��IѧK�������ʷ��vB��A�����"�H��nE��H��g��������w���E�sq����G1�_�(B�(�>VOZDn�D�/���K 6ia�<�g�w��	��J"�	ޞ.�k�#8����P5w�����[�D՟O
�T���6���7��Je���H��ص"�@�df{k~Ӵ���PC\��N�g�a�5�%?T�[�����7��^�?Nt��Sf�b<\B�8+z��R����i���J��c��a�>C鵿����x���톣�D�x;�r��Eگ�U�,ɫ /����$ݡ[�é=MlF�9�x�|t��Na�8L|�b�����n�š\�=M`
^����Il�o�\�E̦�z�za��a�@q�N1�(�1�ǰv�=]����g�ۤ_�=���*�U3゛Z�q���ô���u�m"6<�5��!�dq�X��i8����ϒ�6ۣf(Ξ<*д��~v[��Q[�;��I�6�i����nSx5�Qy�����p�2�m��t4�ٷW�      �   �  x��X�r�<S_�P�DR������vy������r1��\��|���CJ�=&?����n*'�8�~��<���WW��웢CU	J�ܿ������U6�z���z�l��LL�P�4V���mhl>��W�����0،���t�Y�U����;�\T��1��&��V��wx���⋳�b6���*D��1%h�`�A��<��V���c��*zDn
^a_|�--�������Š�@=�^��s&ݸ��`@�|��N
�������JX�7<�?��"��l�|;fBp.Y3��2X=����+��Y+m��A�b6@��ā�'I��bB\r������|����,a�I�������}�j�2w�;fgt,��k��pPWm�J�(��.4X>�j�;�cS���zvC�<l�*%��/Q���Z{$�K�U�����	$CM�[g�1��j����M����`-g	N}�-�ԑo@�7@�4m���{�^�w��|w��c��s��r�L�c��AV� Q7:<��D~�?BU�Ч�&�	�x���K���Z��-�$p^m#��b���{D�@A7����E�W!9���Z��+���8��������1���$+@ʸ���1+��4>�v�R��F#.!a���u�
+Y��<�*D�%9;l�稾�=�{_�r.���`!�t�"���q����ˁ��yUQ(v%��;�0V��#��m�������u� 00���&�ob1�S8Q�[�_¸	��bS��X�Xی�Jq[�<T��Dx�� �� �n�*�����!Ba5Hkr���~�[q�$�?u;F��8��&8m�Ga4b�v����bz5G�t;�ЭJ���k��� ���+��DV�����f�.n ��B`{񱍐Or��A�vmGo�wF���mq�B�X�]Q"޾���cǬ9�����\��ES�O�L\��J����,��+��)��K�ƶ;�נٝ ���eՈ�`3򂕃`���v��c��6�
�ȨY�@������9�o���K�l�*�M�4��jwp����^��.�z~i��_�7�����kີ5R��>�����Uϧ繓c^��G"KHk)�#Z�]����c��S_��9§e:`}�����Y�����Pc�M9z��Z4$���6}�����!�%�w�򢳍4/��	ߨ��M4��X�?zǑ�2�lH]:-�����SS��
0u�����A:1͏�"�^���"z4�k��^�i6�N���'�Fܫ�B�����>{���|���X+{��ӓ�f'R��R�
��T�
2z��l�p���|�?��������%vh7ቚR�����mo"�����JbԤ���#��H}RLk6�A��N$t�2�� C���4�����գ�E B�=L,�v��Rm�<��`��:�Nd��T�!^ ��{*�'���:^�Њ�n���zV��o��Jb�cl.줥��8{bw���V'2Uw&=d�I!��;��D��IJm@�+F���<i�>s��AN;4׌���]a ��:HkU�Y:��~.�x���Z�\��ؤ�#�v��rbB�a����h7�u��c���%i2��WN��6E(M�f�2ec8GΌb+(?�5Nm
�5ԩ/���~��cj����,;��*R}l�A���OO����7�{b�8� M�s��hJ�N�<X�YƁ-�=g��D�vh)ӗ�����'��K!�u�I�n�� VH{g�����l���S���:�}�Ni��G)�'�����q&z���w��8v��Gm�*�'�"3���g$�b�8���$�:OSE�J�!�;���_�y�ieS���s����ϭN��d�h]8���@V��q�8M5K1OfW݀(5�cZ��0r�q�29r�wl͸�޾����6�ť�,N����*�x�}����s��lg�	�Q�շzȫ=��e�k_GHϣ�-a���oK�᠒�_/����]�|�(����dQ#���>b��0��ApbA��77�eA���ˠ���؝L���u[�5�jQ� �qU0(��\���`)(������3ܖ�s�ܘd�;N��`�#�t�^'v��D�[X:�7�؇��f�C�(l�L�i�bR5&l �����\���y�'�Z�/��ˀ��T��N�M-�g��w��2#�8������ ��R�      �   6  x�uVK��8]G���D1��c�S��Uv�6�уل�H�%�TST���g.1s�~TV��f�@BOdD�Oh�!E��;K���"�J��e�[����	-����_�eq�,V����-Suf_�?�ï�^�b��Yb����2Ċ^s��5��sV(���>/+]8���-��[��6�a�f�F|_��}�$���z�Z�]liK��(��XD���7���6&��3Vю�8ID�5��.P�ᶛQ�-{ ��Nz�Mu�g'�N�����J�Ŏ�.�O�IP�/���Ɔ�6TQ1@G�=8�BSb/)tmz�����;RW�5DTf�R������/g��x���vև�jKJ�+�ђ)��%��uu颭1j3�V�K��~�=�B�iXJ9�+�*�,����ZZɝ�E�.�F�L[>��xqҐ����n��CYK=���EB�E3+t���\Y6�@)����Q,[��Cls��[�;r-�1����7$|������
c*����B��`����a��RB��Yn��֥�1�,���7�Ifa�&���G�P�i��0�'�e��W����f9%�h1y�ɶr��W�O�#�]��I!�m1��B�CQ�k{��f�
"�ħ�u���O��{�ov=7&�F�S���[��TH�l��2���P��ŗ�가�V\�&'�	:���`l�ry幞��ҫ=$dL���)M�7跩yF�07���Nw�	7������=}*r
���?4�e����rbf�s2x:e L5&���X�VG��~a<Ue�^�9��s	 E�+�m0K��p�nJ:q{1�-�\Z�l؋�6�A�AwuH��s~,�'3��]c�^���C��2��LY�zM��|F'�� ].�з�߿������<Y����=jdBʟ�a��_�	���O�b���M��f ��Wh x:C����i�Y��{\kqd���@b%}'������)����c�΁^9J�d�IҕҨ�1����X�����乥�k���f.�vx��C3xs���j������ָ�3�K~���Q�����FVQ=�',&ܰ���j��o��LT>�!g��j66J$ʔ�� �YC�����5�.���f�~�e�sg�Oa~cC7.��*� %�������7�Co|���h��ސ+�= ������ɤ��;vGb>�S��QuԈ��|�m{���&���T0�b]����r�H�C���10�Q?'���*�9B�~� �F�����
���ހA_"���^�u�r��S��m�Yͦ����ȈIH�H[EwS<�s�LJt0~�e���/���2�N��x��LHiP�y5u���	��b{�9L�A�v���{�K�.#������O���QpL���KQ�{ަ��햮����&e���h݇�]�t7���;��X1S��`1�U�!����G�?Ƈ������-�Ơ���#� 9�o�y#�};)��>�>@���5m����"�{���.��r�K�k�]�|�!���	]y�/O"�<���F����b����~      �   ~  x�ES�u� ;�a���|v��sԖMzJB���
ې�t`u�h�a������T�&�1�С+�ra��F��PC����=!8M6�4�B��0���f�]�p�s�OZ�7q���zC�+8���n!�7�rQ��f,�`�A;�̐x`��� ��#F��LC`���E��%���T��sD2��Q�a�����}ҽV*��"��5��LX���0�,�3�S�ҕ�v(��Y(yv�8eY^R���n&�I���T�G�	�����x�}��@<F�px�ϭ'�?o!��諊���%�;����s��^�n����-�.C�7��]ﾊ"|P�~:{�~�7}��gŸ�������!<�'[����W|�(o^ާ�ZkX��i������      �   �  x�EUٱ#!��l!	�e�c�ux�^�x}HOEU�|�eC?��CM�ʞ�p�dß��x�r�Y{x���}��}��DI�N��m>������s9��K�1����X�[�#�X�������*xY���\���t�]wď	X��!����@���%��#���l�W�ظ���� Ցb��T�ȸ^��Y����O� u�T����}��j���q83�z�wka^F�7q�4�������$E�w�Ʒ��p�P�$��@�D���j�� &�#�G��j�/�6o�Z�S/�;_���%����
)��Q��4<�,��~�Y��[LP;̶B �<�uGz���[ogh��D���9c�H��K!"�5�-Y&��Z�$"+�-�ޡ�r�ˬG�qu͘d떵�����{�b=�j�4�t���K��ˢ~P��Q�L[M����yɝ��Y�o#���B�����X(xe���[�AGɎߞ�c���!g.x�O>������,�zPə��"DK���9����櫽�+!1�V����_�Y��v�Rk	x?Q��9(�<�m���W�G3��E
�.sp���Vm�^L�j���`��_���V�*�:�������Nqhm��c����      �   !   x�32�4�26�4�26���A, ���� @Z       �   �  x�MT�n�6=K_�X^'��k�p-�^�^f��v����������"���ޒ�j���5)�̛7�;��l~�nN:p��zv?��~�8�';e�%������<��='�p�$R�GY=�+���K���n����cI�7��$���h�`q��CB��Nn��#����J�^6��͛B�W��U �h�Q0q�8�ē.�$�jI:#qع�x2=r�=��8.��	7s��>�/a���M�Ѩh�윞�;�E�[wY�WY%u�f�<2&|F�^��2 ����Rz�9��'�����Y�(��Jܹ�`����y��94��(c*>j��FhPm\#��^0�U����sm���@�l�F��p&a 
�����ǿ��N9ό���A� ��a�`{�u"E���!��@���b��`7G�"�*��D0��T�!Mɣi��o�u���҅z�"rӤ��y0��2����@ɟ��V� �=L�k2ڡ�o���%��8�JA/=�#��~9����V����0��L�"�ʯ �k��wVA͉{�b-͉+��yh�B��� ;j��A�gѡǬ�on��Y7<`Ǟ)>�j��y��`�`���k��˽���W���>�G��f���?�p��,s��.f(X�-G�]���X?��U�y�/Gw�7�9l"�b�+হ|ݼQ��-�5���4y�Hwg��d�h����4�@h&�1^�j��hA�g��f+��	�����_�V�L�Q77��8V��5;�����X$Tj���`wSI׾n����V쳻��|����$l��Uڟ����d�`��`V$�VKͩu�g~�m!A��@G���"��Ԉ͂́��4�!B@`IW�P%b�a�]��h�.�x���W@
�;w���K�b�8�Bq��y�[���c<��&�\��(�6!�>�Zބ�m!ۤ`�mK~���?��b��������m�/(Ѓ}      �   '  x�͒KN�0���)f	EMZ+�[ Q�+6�=�A�'���e�I8@W� .��H;�b<�����GΓ֪_N؀0�Hb{�[�!�<.B�>^��Z�haZ@%V܄�Z��P�`��N�QGA�XE���Հ"[��y dp���v>�a���|�95�9o��qlB��(�8�ң
�-64��(z�%Gm@K�j�z��o�9���|t8�a��k���f)���99H��l�"_m��v�GC�����q2�*��c���'װ<�}�y��+b8���$t����4-����Y�����Cw      �   �  x��Y˒�<�~>`<�>��r��%��DY!�/�nLV���s�䰿�������G�O�%άzf�:�'�2$r��GVVV���9~���Z�Z����W�]2MyL�ޙ<?l]�q������7l���ƚ��5�L+��~���}cyJ;5�]���yyse|�����
��;�N܌W�`��v���������X�bg���'�)���g.g�0}�:>���zs;�.�Y��|�6����х���Mcӈ�%��=����q[��.E8�[���i&��/����)�sat�Z�H[/��օl�I�����Ey1��nb�<5�ц5�3�y�5ɍqi���1я�{��!ف�8��f�T���7#���I��h� >�ϋ�G̮�E�c0�u�e�r��L�5#�m��!V�����7y�'�ޮ��Gd�k�z���	F�`S��a�>��y�|�h�c���}�`��z�����hF���.�c��	��i!��������J���	&�.7H�䍧�H��=� ~��J�Y
�>"/N��x��⟱���L��䀺zqrC�񙎥�����lm��H��V�pX'�ي�lb3���>�4&#�����L�}ǘombE�����O4�)��wxs��^g��nrp���c���K(�RK�*x���y�%�	��G��w���HV���=o�B��n��r��������o� 	�)���|lA�M8HI.O�a�I�0)���p����?�ei:7�^/y�������NaaZF��Z)�P+�$��FI�^��$M�}�Ȃ,�w�
d5�՝o�ۉ�d1�us�,0��	���֖e>�ex�4�|�b3��)	���R��ǿ�������yDga0�V?5+;Z%��q���N����K8���5x�~�V�qkF�S�`��a�-���������`�A� �R�ڿ����]���j����b99kJ5�c������9���<Df�<����²�-D$��"=�fܭ���q�P1F.�vE%�����ȗW �f����:�뵠�\ˋ� ��y\��0xؐ.������$:�s#}�*Ip�;/@��_���n5�0A	6�G��8Ԏ�3�M/�� �Q0��H�.�$)���mJ)���7b�S��;F5{;e^D! � shQ��4�.V�%򎒂�����ob1���m�"27�v��Ȫ����P"02�7LP�N�+l�+R���a��9������zt9	���{�{�(�`�@��-�o�Z�/!d4�>�n8^�g���a�Y�J&TA�D�;�i���{Dpl	�\ø�Th(�d�C�	"9�JI�{Iop����Qu���g �=��}������x`�K$��je�y�ж5��m1��d�#����I�m#�F4��̏��s�پ��-�NmO�Z����#R�� ���#�j׻��+�9%� �=�Է�8ѫ��5%��6�̐ۡ�Z-�*�e�Q<�����7���:'�Z�)y2��1�G:�X��28�m�S
� ������^��#�苍�;)��L\�D�Ŵ�:7��؍���e�_U�0C`����F,nݚ�XC�2)ͭ�B	Z���?Q7��I��� �4i ��=Vs(\���`~��*y��]�V����t8>5�]�$��WؔD؋����Rn>M��e�&Za;�. �(�������ؔH3�dwH۰*�$��ɕ�E�a�?�V'碢��2-s�DPmmnN��' �޼�Ԑ�����S���-�S�V��8~!�B�Q0x4��/Sﲺ�s"�]g�}]����|�4/0Ā�R�Ie�
M��\k�ا`�w��;�W�Fװބ�U0n`ہå{����U�:��PZ�]�,R�0Ǥ��!���E2�n�$������4�w {��ųx쮀���)�B+�N���5{@��P?K{����]�(��_�BM�8��~%��i�6�X���KI,�K�d����Yܝ�V�1�9z�2��qEq�������1ΰ��(��\��(m$f�n�@~;*����i��d?@��Ӡ;΄�t�'T�ߕ b�^M�!3�����^K��*	T��S�&���$s��$s�$f��\.A(�왾��U%�;g^;T�����%Rb$wI�����jlKv���{�T�$L��z��2�X�H\���-�n��⊺��m�b5[��r��Z��A� <Р��D�YWV��u�Uo�})
;!�S�61��v.sN M
A �8)BDH���Ql�����KNߖz�ʌ�d��1�to�}�&Yۗ~#���GY���^ ڳgCF>bτ��ߊ
"rA����8?t"n
 �o�$��X�j�c	\�I;��ɘ�1��k]���X�Ҁ��`j5p�D��	��2G�}v#���u(�Ǩ�+i�|"ەn�>��C�H:���T�N`)Ǥ*@��_:�l\�-[=|��Ir��&z�|�)O �^C'$�n&K��Șb%��-%��M�A]U2P��xl'�5蕍 Bv���ty�X�O!��+��L�N#e��h0���u�qw��aY�"�2<+D^5���ͻ�#ru�y��I�󌊍-�{aY��7y~G��1v����պƓ�Y��Z��Pϧ����ĩ�m�tK�?�P�^�2��K U�b�s���<*����Ad���fi��r)@J���e4(�Q�(�d|���,�S�(%Q\�AaTI�qYJ'd5ؽ5�����X)�40��|7���FB~�T�g!�D:��B��U&��� O�}W��ID�8d������-�년uL~E�R�2��0�`���e�Zl.}�*�*u�U]T�.�%����G�)��T����t+�s�X���X�B�J;N�+dfB���I���1����A'+�K[pE�Xd���\�{��`����AR���-O��<��n�sy�i���Kh��2a��S��7,��TVHD����M��FzU�@�o"H<�Y�EQs�VeH�ЋD���<�WA�+~1��\�	(�(V�r����ˆߩ���.����%p�Â��%de?�;�(�.�(M�����ղxs\��3󛠳�G���*����?�8O�"T�^j'KJ8gwP��VG���%q8����;���R6�ؽ-��n�va�0'�f*���p��ڷj:�r�y[��X�t�2�S����vG!ϬJ����u��Zu��X�<$Q#o�����	4oI�Z�j���jp�*�p3&X�e�u�o�m]i�[�a�}�E$��.��d�����/&&h�^��y�&��%�)4�N�q|%6ʲM���di[��p�~��e3�J�e��8�B�T�����E=-����E��\���;�U�~W,[���l��c�>t~��W���>#w�t
NW�Տ�k�C�����H�Ĉ���t����~�["7�"]3�Q���\b�:z�h%1��R��o؟%r�Q-_��w(�?.OOO���h�      �   x   x�N�!z�bn�誽l�u�#b�"��j̚!���l��܈fd@��)ΰ�]\y��~��4�U�9�q��m�x+�;)��!�jWSu<q�v�|)��y}��>�I�? 8�>      �   �
  x�UWɒ�8<��1��H�7ﻍw�c.2Ȁ�fo_?�_ӯ��ѥ�Ȯ��J0����<F<��	���wɉ6��%k_2����GV���6��h�����N=��Dܔ�����I����8�)YC�Q,ˊ�놬h�AE�� h��9w��� ����\�\�+_�T<~J5��F=^ߺw�Xas�����94�ݥ\��k:��mwh_Ùس�eK��:�(�X�4�*Vt������P��6Y,^�H�@2�I�\f����l|a�o���ӭ�~��'r�ڋDz���Kƾ[�f:�6����t���|&kl�&H����!B06C�XD��
dڱ��@Ki�A�%��DZ����k.�!�< ��VL5m�]�=,M�!hO�G]!�i1�?_�ٌ�r�#{]�F�٨�Fu
�g�FQ�2���Ut�����(
���ć�A/X�"���d,��������tWz�@���PKM�.�a��*1����y����%��n����TUC��J�F�V�HW���q��SR��V�=��"˓/PRZ<g�~`^���f坭�V'�@�<��][�c[Fn�_Z��k:���OG�����x�/�%f�V�^i��E�6�j��2�G�y"��X<^Iv�����A��ϋ�L�7�|��:Nt��|���ҷfw�˙�p>4uc�<57��9�/Z"���2U���u?��h0h�\dN����ݹ�-'�_'_��̔��jN�M�\��j|�ul�f��
k�iڑs;s�7Q�&����7ǥ=4i�LU1S�̨�B���~#W�6�K]�!�IB��A�V�<�,tkQ��x`ڿ�Ԕ��Y�ia�I�;>Ե<����<��i�����(ޣs�*�ѳ��,@����h�.C���A����"7`}�_����D�c�uN2�h=�P�jm���/�?�Y��K��#�����q>�z����`�������V2��ٱl�Q+E�D748>�������j�s��=���y+J�@�KI�Uʦ�F�Ԅ�}gE����]K���,Cs|���=��=�������o�w&Ҙ�(LŪ�QÐ���?�H#L>�{�a��7��)H�X��C�~k6
9�4�M��@c�3����r��x)m��L�Kyp4o��f�H�uC�a*E�oPd(X�9�%1/=�Q�W;-/(���M�s���S����m�{v������t�}H}�ݨ(oes�R��I�VW�B&�~SMJ�SAU���?�H����	����r�s B�m�A��ʁ���-�\0��o��8M���'��oAv����݊/,i~��Ⱥ�Z�с�#��UE�oX���5�h��,�{�Q��p�r��x�z��/���O��3ʋ��Eiz�ҍ�c͍~E���sڟ�B�X��N��&Z>�PS�p�a�5p 3�2@5PDA4&5E������e��ǹ��$i&���q"����f�>��]�Nϝ���ͨ)Lq~�WO���0��+ϒN��l����04MӉL�OT�u�q�+�+��0%�d����sᵂ�=�fz�6i�Q�:�ᵍ�m�[�?ߕ��.;�����?ovܧ��3�{�Ʉ�'�ݤ��aE�U���/4���+��q���t~+�y!�?M�6���u�GH[{8W�C[S�]�/7Z���ތe�i��~4������㒍/�砊�N�˺�u��TĠAFu@��n@FѽZ�8 K|��5�"�O�g\��p��58?��6�t%�꛽�?[H�]�?����ؘK���q�a \T��
�1�e2�P��R�U�	���G����?�a(�ZB�^ɚ���Pg�Ͳ�f5�G�v�}`��|�Y�{���M�,�����e=
�TEC�Kv��@#RY��K���C2Ipm� ����ׯE�+Q�}�s�ت�K�T&�\Ξ�co�㷯�g�]���y�r�u��Q�O�ls��j�	�F�-H߰H�6U9���G�����H��T��S�y�'�|���/��/���ks�\���/�P��{+�I���Eo>zph�Ӂ�L��H�BEn�*A�#��Y@>r_W���/�^�*)��{PS���b@ۅT��,����R���N��i�;����za-���Ubua���H��2\0�P��T��V�,�
l�_A�q�"����8��w��G���b�?uL���b���N����yJoM�������
9�M��B��dh&`�hZ�"�5�'H��8:�ɃI�V�p�U�������AM�v�.��䮚O�������x���ܷXhvp���<jڽ�J��]&�84����hT�"�\e�A�d". l���+����
+שj]��q�#d�%6�$ݣ&_�c64���襝cǞ{��i*N�v��rU�jV:�S�R�Ć��T��A>���2C���׭u
���5�p4~	Z�R�����c��~����$C�l�9���c�3b��<����'�_�������GQ(|���ѢE|���n?8A�E�1H(Y�d�	� h�rf���5#.��l��wM_sw�����ǒ/:��vH���0}g�z1rYv`l�,c�l`M3�F߸�R�s�Պ90�S�$׼�D�$ܲ����2Ŀ�5�vo��'��蕝楈�OL�|no�A(��ju������ +��8N7���Bc��A��>~��;����r���h�x���*���u�fd���00��Bw:�f�4M_������'˸�Vl��V�/2z�U�k3��P�Z|`����h4���\      �   N  x�]X[��8�v3c;��2�_� !�S�ѩ��!����4�m����z{Z�����~���_����-��F{�6�>���ۯ������W�����7����6���!���_[7�6�6�tC���7.��ܭ�6��5^�1������M|~�O�-ݏ�\;"�o���yP����<x�~M��QY��q��m"p�gM��+��1�q�ǽ9H����J ���L^ *~��<I�qTi ��Q8���A�:a�r�rK(�>�=�	�U$�u &~��Dm`�I�*+�
�׸��?Ƀ���a��͐�F�g'��5���?��⫃�XN'A�OO�ӝ�%օ�=r�`��2�#].}4żI��H<� ��K�B^���(���w��D'��N,���@(��&;�Β��X3&�!*M�A��t)�kd����Y��Xp�wE:A�~	*"]4���5	�����7�7�=DJ�C�DϠH4E*��rC�PMG3
�0	o��E��6��?J�h"^��'FL2�ZDxF��%ZD�h�t�W���Su��p7�|��)���d��W9uj޺=�Fgle����ZB��K�c������]q�� !eI�-��E�;�TP�/��6�$S�ͪ�V8�!�Gv.��,�L��A�gU~1e�hh�C/#� S�l�~1��-�FH�y(���yIRαe[eTx���z�-�|�Y�Zj�SM_��]�bDG%e���Qe�+ā�>�@�6+��3&֟&�ʬ�Q}��KRЅ�.�g��D6�,�8cv����>B|9�9`ЇAα`)����U�5r	���ɱ7R����~h�����Ā	��1 �A��co�T�L�$�5GX�^}eg1%O2�2ø`�"pg���^��ЬJKu��4�L[��ׯ�=
$��>�;[}T�1���B�5|�J�x�:�h�eT}	WSʬ6�1���I9��k?=�Q�)�=R�Gآԑ	P�"�d��پ+�0����L�D��\�V��s	M���.L ��!o��_����"2dո�V1��`-�_�ŉ/q���O�d�,8����,HB�Q�T$�U�rrRY��T�1�PI�+�c���/8F��E��u�;:��X���Y,h1qQt}e;v�ɦ�(Ε�
h��y������+�I�<X+����"���e��Vz�bH#;<�M��(��V;�\N�'�\�Y�,N�Nfl�XA�� ���������5Fg/w_�?fa�U�!���x�9�UDÊa�a{��oQ�����3�jCF��*��_��w��U�CIT0�6��w�S��Θ�,
������HN���[I�<�a40M>g%ɩ,�9NR�ЈjYm?�e�v1�������D��=�\��j�iҙ����a�iA�t��ڇ��
�uFЛ�:��⃏��t�b�CE��?�����'/Ou%h+r���w�vq�a��9z��M�[K��L��>SZ�>E�G��檕o�_Ⲿ��Q.V4MVbT��9~�r�̲mw��O'�lDӔW�~���9���5��T��W���7'���c���t�U���D���~mYI��3��d���kX�F�_�eۆ��纮� �M�L     