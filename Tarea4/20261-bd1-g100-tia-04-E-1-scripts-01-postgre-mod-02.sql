-- Scripts de Modificación de la Base de Datos - SGBD PostgreSQL

-- =========================================================
-- 1.- DATOS SEMI-ESTRUCTURADOS PARA BIG DATA
-- Gestionar el campo "perfil_usuario" en tabla "usuario"
-- =========================================================

-- 1. Agregar un campo tipo JSONB

ALTER TABLE usuario
ADD COLUMN perfil_usuario JSONB;

-- =========================================================
-- 2. Agregar un par de registros
-- =========================================================

INSERT INTO usuario (
    nombre,
    correo,
    contraseña,
    tipo_usuario,
    fecha_registro,
    perfil_usuario
)
VALUES
(
    'Sara Gomez',
    'sara@gmail.com',
    '12345',
    'estudiante',
    CURRENT_DATE,
    '{
        "gustos": ["musica", "programacion", "gym"],
        "habilidades": ["SQL", "Java", "Python"],
        "redes": {
            "instagram": "@sarita",
            "tiktok": "@sara.tech"
        },
        "ciudad": "Medellin"
    }'
),

(
    'Juan Torres',
    'juan@gmail.com',
    '54321',
    'docente',
    CURRENT_DATE,
    '{
        "gustos": ["videojuegos", "tecnologia"],
        "habilidades": ["PostgreSQL", "C++"],
        "redes": {
            "facebook": "juan.torres",
            "linkedin": "juan-dev"
        },
        "ciudad": "Bogota"
    }'
);

-- =========================================================
-- 3. Consultar la información agregada
-- =========================================================

SELECT
    nombre,
    perfil_usuario -> 'gustos' AS gustos,
    perfil_usuario -> 'habilidades' AS habilidades
FROM usuario;

-- =========================================================
-- 4. Descripción y propósito del campo
-- =========================================================

-- El campo perfil_usuario permite almacenar información flexible
-- de cada usuario, como gustos, habilidades y redes sociales,
-- utilizando formato JSONB.
--
-- Este tipo de dato es útil para escenarios Big Data porque
-- facilita guardar grandes cantidades de información dinámica
-- sin modificar constantemente la estructura de la base de datos.



-- =========================================================
-- 2.- DATOS SEMI-ESTRUCTURADOS (BIG DATA o IoT)
-- Gestionar un nuevo campo JSONB en la tabla evento
-- Campo: info_extra
-- =========================================================

-- 1. Agregar campo tipo JSONB

ALTER TABLE evento
ADD COLUMN info_extra JSONB;

-- =========================================================
-- 2. Agregar información al campo JSONB
-- =========================================================

UPDATE evento
SET info_extra =
'{
    "tipo": "virtual",
    "cupos": 80,
    "apps": ["Zoom", "Discord"],
    "nivel": "principiante"
}'
WHERE id_evento = 1;

UPDATE evento
SET info_extra =
'{
    "tipo": "presencial",
    "cupos": 40,
    "ubicacion": "Bloque 5",
    "wifi": true
}'
WHERE id_evento = 2;

-- =========================================================
-- 3. Consultar la información agregada
-- =========================================================

SELECT
    nombre_evento,
    info_extra ->> 'tipo' AS tipo_evento,
    info_extra ->> 'cupos' AS cupos
FROM evento;

-- =========================================================
-- 4. Descripción y propósito del campo
-- =========================================================

-- El campo info_extra permite almacenar información variable
-- sobre los eventos, como aplicaciones usadas, cupos, nivel
-- o ubicación.
--
-- Este tipo de estructura puede relacionarse con soluciones
-- Big Data e IoT, ya que permite manejar información dinámica
-- generada por plataformas digitales o dispositivos conectados.