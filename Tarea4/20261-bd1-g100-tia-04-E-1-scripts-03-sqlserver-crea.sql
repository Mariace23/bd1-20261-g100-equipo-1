-- =========================================
-- SGBD: MS SQL Server
-- Red Social Pascualina
-- =========================================

-- =========================================
-- 1. TABLA: usuario (Independiente)
-- =========================================

CREATE TABLE usuario (
    id_usuario INT IDENTITY(1,1) PRIMARY KEY,

    nombre VARCHAR(120) NOT NULL,

    correo VARCHAR(120) UNIQUE NOT NULL,

    contrasena VARCHAR(120) NOT NULL,

    tipo_usuario VARCHAR(50) NOT NULL
    CHECK (tipo_usuario IN (
        'estudiante',
        'docente',
        'empleado',
        'empresa',
        'publico'
    )),

    fecha_registro DATE
    DEFAULT CAST(GETDATE() AS DATE),

    perfil_usuario NVARCHAR(MAX)
);

-- =========================================
-- 2. TABLA: grupo
-- Dependiente de usuario
-- =========================================

CREATE TABLE grupo (
    id_grupo INT IDENTITY(1,1) PRIMARY KEY,

    nombre_grupo VARCHAR(120) NOT NULL,

    descripcion VARCHAR(MAX),

    fecha_creacion DATE
    DEFAULT CAST(GETDATE() AS DATE),

    id_usuario INT NOT NULL,

    CONSTRAINT fk_grupo_usuario
    FOREIGN KEY (id_usuario)
    REFERENCES usuario(id_usuario)
    ON DELETE CASCADE
);

-- =========================================
-- 3. TABLA: perfil
-- Dependiente de usuario
-- =========================================

CREATE TABLE perfil (
    id_perfil INT IDENTITY(1,1) PRIMARY KEY,

    id_usuario INT UNIQUE NOT NULL,

    biografia VARCHAR(MAX),

    intereses VARCHAR(MAX),

    habilidades VARCHAR(MAX),

    CONSTRAINT fk_perfil_usuario
    FOREIGN KEY (id_usuario)
    REFERENCES usuario(id_usuario)
    ON DELETE CASCADE
);

-- =========================================
-- 4. TABLA: publicacion
-- Dependiente de usuario
-- =========================================

CREATE TABLE publicacion (
    id_publicacion INT IDENTITY(1,1) PRIMARY KEY,

    id_usuario INT NOT NULL,

    contenido VARCHAR(MAX) NOT NULL,

    fecha_publicacion DATE
    DEFAULT CAST(GETDATE() AS DATE),

    visibilidad VARCHAR(20)
    CHECK (visibilidad IN (
        'publica',
        'privada',
        'amigos'
    )),

    datos_multimedia NVARCHAR(MAX),

    CONSTRAINT fk_publicacion_usuario
    FOREIGN KEY (id_usuario)
    REFERENCES usuario(id_usuario)
    ON DELETE CASCADE
);

-- =========================================
-- 5. TABLA: evento
-- Dependiente de grupo
-- =========================================

CREATE TABLE evento (
    id_evento INT IDENTITY(1,1) PRIMARY KEY,

    nombre_evento VARCHAR(120) NOT NULL,

    descripcion VARCHAR(MAX),

    fecha_evento DATE NOT NULL,

    lugar VARCHAR(120),

    id_grupo INT NOT NULL,

    detalles_evento NVARCHAR(MAX),

    CONSTRAINT fk_evento_grupo
    FOREIGN KEY (id_grupo)
    REFERENCES grupo(id_grupo)
    ON DELETE CASCADE
);

-- =========================================
-- 6. TABLA: comentario
-- Intermedia
-- =========================================

CREATE TABLE comentario (
    id_comentario INT IDENTITY(1,1) PRIMARY KEY,

    id_usuario INT NOT NULL,

    id_publicacion INT NOT NULL,

    contenido VARCHAR(MAX) NOT NULL,

    fecha_comentario DATE
    DEFAULT CAST(GETDATE() AS DATE),

    CONSTRAINT fk_comentario_usuario
    FOREIGN KEY (id_usuario)
    REFERENCES usuario(id_usuario)
    ON DELETE NO ACTION,

    CONSTRAINT fk_comentario_publicacion
    FOREIGN KEY (id_publicacion)
    REFERENCES publicacion(id_publicacion)
    ON DELETE CASCADE
);

-- =========================================
-- 7. TABLA: reaccion
-- Intermedia
-- =========================================

CREATE TABLE reaccion (
    id_reaccion INT IDENTITY(1,1) PRIMARY KEY,

    id_usuario INT NOT NULL,

    id_publicacion INT NOT NULL,

    tipo_reaccion VARCHAR(50)
    CHECK (tipo_reaccion IN (
        'like',
        'love',
        'haha',
        'wow',
        'triste',
        'enojado'
    )),

    CONSTRAINT fk_reaccion_usuario
    FOREIGN KEY (id_usuario)
    REFERENCES usuario(id_usuario)
    ON DELETE NO ACTION,

    CONSTRAINT fk_reaccion_publicacion
    FOREIGN KEY (id_publicacion)
    REFERENCES publicacion(id_publicacion)
    ON DELETE CASCADE
);

-- =========================================
-- 8. TABLA: mensaje
-- Intermedia
-- =========================================

CREATE TABLE mensaje (
    id_mensaje INT IDENTITY(1,1) PRIMARY KEY,

    contenido VARCHAR(MAX) NOT NULL,

    fecha_envio DATETIME
    DEFAULT GETDATE(),

    id_emisor INT NOT NULL,

    id_receptor INT NOT NULL,

    CONSTRAINT fk_mensaje_emisor
    FOREIGN KEY (id_emisor)
    REFERENCES usuario(id_usuario)
    ON DELETE CASCADE,

    CONSTRAINT fk_mensaje_receptor
    FOREIGN KEY (id_receptor)
    REFERENCES usuario(id_usuario)
    ON DELETE NO ACTION
);

-- =========================================
-- 9. TABLA: solicitud_amistad
-- Intermedia
-- =========================================

CREATE TABLE solicitud_amistad (
    id_solicitud INT IDENTITY(1,1) PRIMARY KEY,

    estado VARCHAR(20)
    CHECK (estado IN (
        'pendiente',
        'aceptada',
        'rechazada'
    )),

    fecha_envio DATE
    DEFAULT CAST(GETDATE() AS DATE),

    id_emisor INT NOT NULL,

    id_receptor INT NOT NULL,

    CONSTRAINT fk_solicitud_emisor
    FOREIGN KEY (id_emisor)
    REFERENCES usuario(id_usuario)
    ON DELETE CASCADE,

    CONSTRAINT fk_solicitud_receptor
    FOREIGN KEY (id_receptor)
    REFERENCES usuario(id_usuario)
    ON DELETE NO ACTION
);

-- =========================================
-- 10. TABLA: reporte
-- Intermedia
-- =========================================

CREATE TABLE reporte (
    id_reporte INT IDENTITY(1,1) PRIMARY KEY,

    motivo VARCHAR(MAX),

    fecha_reporte DATE
    DEFAULT CAST(GETDATE() AS DATE),

    id_usuario INT NOT NULL,

    id_publicacion INT NOT NULL,

    CONSTRAINT fk_reporte_usuario
    FOREIGN KEY (id_usuario)
    REFERENCES usuario(id_usuario)
    ON DELETE NO ACTION,

    CONSTRAINT fk_reporte_publicacion
    FOREIGN KEY (id_publicacion)
    REFERENCES publicacion(id_publicacion)
    ON DELETE CASCADE
);

-- =========================================
-- 11. TABLA: notificacion
-- Dependiente de usuario
-- =========================================

CREATE TABLE notificacion (
    id_notificacion INT IDENTITY(1,1) PRIMARY KEY,

    mensaje VARCHAR(MAX) NOT NULL,

    fecha DATETIME
    DEFAULT GETDATE(),

    id_usuario INT NOT NULL,

    CONSTRAINT fk_notificacion_usuario
    FOREIGN KEY (id_usuario)
    REFERENCES usuario(id_usuario)
    ON DELETE CASCADE
);

-- =========================================
-- ÍNDICES PARA OPTIMIZACIÓN
-- =========================================

CREATE INDEX idx_publicacion_usuario
ON publicacion(id_usuario);

CREATE INDEX idx_comentario_publicacion
ON comentario(id_publicacion);

CREATE INDEX idx_reaccion_publicacion
ON reaccion(id_publicacion);

CREATE INDEX idx_evento_grupo
ON evento(id_grupo);

-- =========================================
-- CONSULTA DE VALIDACIÓN
-- =========================================

SELECT * FROM usuario;
SELECT * FROM publicacion;
SELECT * FROM comentario;

