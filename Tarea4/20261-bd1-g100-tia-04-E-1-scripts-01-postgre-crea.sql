-- Scripst de Creación de la Base de Datos - SGBD PostgreSQL


-- =========================================
-- 1. TABLA: usuario (Independiente)
-- =========================================
CREATE TABLE usuario (
    id_usuario SERIAL PRIMARY KEY,
    nombre VARCHAR(120) NOT NULL,
    correo VARCHAR(120) UNIQUE NOT NULL,
    contraseña VARCHAR(120) NOT NULL,

    tipo_usuario VARCHAR(50) NOT NULL
    CHECK (tipo_usuario IN ('estudiante', 'docente', 'empleado', 'empresa', 'publico')),

    fecha_registro DATE DEFAULT CURRENT_DATE,

    -- Campo JSONB para datos semi-estructurados (Big Data / IoT)
    perfil_usuario JSONB
);

-- =========================================
-- 2. TABLA: grupo (Dependiente de Usuario)
-- =========================================
CREATE TABLE grupo (
    id_grupo SERIAL PRIMARY KEY,
    nombre_grupo VARCHAR(120) NOT NULL,
    descripcion TEXT,
    fecha_creacion DATE DEFAULT CURRENT_DATE,
    id_usuario INTEGER NOT NULL,

    CONSTRAINT fk_grupo_usuario
        FOREIGN KEY (id_usuario)
        REFERENCES usuario(id_usuario)
        ON DELETE CASCADE
);

-- =========================================
-- 3. TABLA: perfil (Dependiente de Usuario)
-- =========================================
CREATE TABLE perfil (
    id_perfil SERIAL PRIMARY KEY,
    id_usuario INTEGER UNIQUE NOT NULL,
    biografia TEXT,
    intereses TEXT,
    habilidades TEXT,

    CONSTRAINT fk_perfil_usuario
        FOREIGN KEY (id_usuario)
        REFERENCES usuario(id_usuario)
        ON DELETE CASCADE
);

-- =========================================
-- 4. TABLA: publicacion (Dependiente de Usuario)
-- =========================================
CREATE TABLE publicacion (
    id_publicacion SERIAL PRIMARY KEY,
    id_usuario INTEGER NOT NULL,
    contenido TEXT NOT NULL,
    fecha_publicacion DATE DEFAULT CURRENT_DATE,

    visibilidad VARCHAR(20)
    CHECK (visibilidad IN ('publica', 'privada', 'amigos')),

    -- Campo JSONB para contenido multimedia o metadatos
    datos_multimedia JSONB,

    CONSTRAINT fk_publicacion_usuario
        FOREIGN KEY (id_usuario)
        REFERENCES usuario(id_usuario)
        ON DELETE CASCADE
);

-- =========================================
-- 5. TABLA: evento (Dependiente de grupo)
-- =========================================
CREATE TABLE evento (
    id_evento SERIAL PRIMARY KEY,
    nombre_evento VARCHAR(120) NOT NULL,
    descripcion TEXT,
    fecha_evento DATE NOT NULL,
    lugar VARCHAR(120),
    id_grupo INTEGER NOT NULL,

    -- Campo JSONB para detalles adicionales del evento
    detalles_evento JSONB,

    CONSTRAINT fk_evento_grupo
        FOREIGN KEY (id_grupo)
        REFERENCES grupo(id_grupo)
        ON DELETE CASCADE
);

-- =========================================
-- 6. TABLA: comentario (Intermedia usuario + publicacion)
-- =========================================
CREATE TABLE comentario (
    id_comentario SERIAL PRIMARY KEY,
    id_usuario INTEGER NOT NULL,
    id_publicacion INTEGER NOT NULL,
    contenido TEXT NOT NULL,
    fecha_comentario DATE DEFAULT CURRENT_DATE,

    CONSTRAINT fk_comentario_usuario
        FOREIGN KEY (id_usuario)
        REFERENCES usuario(id_usuario)
        ON DELETE CASCADE,

    CONSTRAINT fk_comentario_publicacion
        FOREIGN KEY (id_publicacion)
        REFERENCES publicacion(id_publicacion)
        ON DELETE CASCADE
);

-- =========================================
-- 7. TABLA: reaccion (Intermedia usuario + publicacion)
-- =========================================
CREATE TABLE reaccion (
    id_reaccion SERIAL PRIMARY KEY,
    id_usuario INTEGER NOT NULL,
    id_publicacion INTEGER NOT NULL,

    tipo_reaccion VARCHAR(50)
    CHECK (tipo_reaccion IN ('like', 'love', 'haha', 'wow', 'triste', 'enojado')),

    CONSTRAINT fk_reaccion_usuario
        FOREIGN KEY (id_usuario)
        REFERENCES usuario(id_usuario)
        ON DELETE CASCADE,

    CONSTRAINT fk_reaccion_publicacion
        FOREIGN KEY (id_publicacion)
        REFERENCES publicacion(id_publicacion)
        ON DELETE CASCADE
);

-- =========================================
-- 8. TABLA: mensaje (Intermedia usuario ↔ usuario)
-- =========================================
CREATE TABLE mensaje (
    id_mensaje SERIAL PRIMARY KEY,
    contenido TEXT NOT NULL,
    fecha_envio TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    id_emisor INTEGER NOT NULL,
    id_receptor INTEGER NOT NULL,

    CONSTRAINT fk_mensaje_emisor
        FOREIGN KEY (id_emisor)
        REFERENCES usuario(id_usuario)
        ON DELETE CASCADE,

    CONSTRAINT fk_mensaje_receptor
        FOREIGN KEY (id_receptor)
        REFERENCES usuario(id_usuario)
        ON DELETE CASCADE
);

-- =========================================
-- 9. TABLA: solicitud_amistad (Intermedia usuario ↔ usuario)
-- =========================================
CREATE TABLE solicitud_amistad (
    id_solicitud SERIAL PRIMARY KEY,

    estado VARCHAR(20)
    CHECK (estado IN ('pendiente', 'aceptada', 'rechazada')),

    fecha_envio DATE DEFAULT CURRENT_DATE,
    id_emisor INTEGER NOT NULL,
    id_receptor INTEGER NOT NULL,

    CONSTRAINT fk_solicitud_emisor
        FOREIGN KEY (id_emisor)
        REFERENCES usuario(id_usuario)
        ON DELETE CASCADE,

    CONSTRAINT fk_solicitud_receptor
        FOREIGN KEY (id_receptor)
        REFERENCES usuario(id_usuario)
        ON DELETE CASCADE
);

-- =========================================
-- 10. TABLA: reporte (Intermedia usuario + publicacion)
-- =========================================
CREATE TABLE reporte (
    id_reporte SERIAL PRIMARY KEY,
    motivo TEXT,
    fecha_reporte DATE DEFAULT CURRENT_DATE,
    id_usuario INTEGER NOT NULL,
    id_publicacion INTEGER NOT NULL,

    CONSTRAINT fk_reporte_usuario
        FOREIGN KEY (id_usuario)
        REFERENCES usuario(id_usuario)
        ON DELETE CASCADE,

    CONSTRAINT fk_reporte_publicacion
        FOREIGN KEY (id_publicacion)
        REFERENCES publicacion(id_publicacion)
        ON DELETE CASCADE
);

-- =========================================
-- 11. TABLA: notificacion (Dependiente de usuario)
-- =========================================
CREATE TABLE notificacion (
    id_notificacion SERIAL PRIMARY KEY,
    mensaje TEXT NOT NULL,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    id_usuario INTEGER NOT NULL,

    CONSTRAINT fk_notificacion_usuario
        FOREIGN KEY (id_usuario)
        REFERENCES usuario(id_usuario)
        ON DELETE CASCADE
);