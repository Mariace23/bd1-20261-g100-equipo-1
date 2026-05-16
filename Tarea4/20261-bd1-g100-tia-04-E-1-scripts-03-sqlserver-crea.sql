-- Scripst de Creación de la Base de Datos - SGBD MS SQL Server


-- =========================================
-- 1. TABLA: usuario (Independiente)
-- =========================================
CREATE TABLE usuario (
    id_usuario INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(120) NOT NULL,
    correo VARCHAR(120) UNIQUE NOT NULL,
    contraseña VARCHAR(120) NOT NULL,

    tipo_usuario VARCHAR(50) NOT NULL
    CHECK (tipo_usuario IN ('estudiante', 'docente', 'empleado', 'empresa', 'publico')),

    fecha_registro DATE DEFAULT GETDATE(),

    -- Campo para datos semi-estructurados
    perfil_usuario NVARCHAR(MAX)
);

-- =========================================
-- 2. TABLA: grupo
-- =========================================
CREATE TABLE grupo (
    id_grupo INT IDENTITY(1,1) PRIMARY KEY,
    nombre_grupo VARCHAR(120) NOT NULL,
    descripcion TEXT,
    fecha_creacion DATE DEFAULT GETDATE(),
    id_usuario INT NOT NULL,

    CONSTRAINT fk_grupo_usuario
    FOREIGN KEY (id_usuario)
    REFERENCES usuario(id_usuario)
    ON DELETE CASCADE
);

-- =========================================
-- 3. TABLA: perfil
-- =========================================
CREATE TABLE perfil (
    id_perfil INT IDENTITY(1,1) PRIMARY KEY,
    id_usuario INT UNIQUE NOT NULL,
    biografia TEXT,
    intereses TEXT,
    habilidades TEXT,

    CONSTRAINT fk_perfil_usuario
    FOREIGN KEY (id_usuario)
    REFERENCES usuario(id_usuario)
    ON DELETE CASCADE
);

-- =========================================
-- 4. TABLA: publicacion
-- =========================================
CREATE TABLE publicacion (
    id_publicacion INT IDENTITY(1,1) PRIMARY KEY,
    id_usuario INT NOT NULL,
    contenido TEXT NOT NULL,
    fecha_publicacion DATE DEFAULT GETDATE(),

    visibilidad VARCHAR(20)
    CHECK (visibilidad IN ('publica', 'privada', 'amigos')),

    datos_multimedia NVARCHAR(MAX),

    CONSTRAINT fk_publicacion_usuario
    FOREIGN KEY (id_usuario)
    REFERENCES usuario(id_usuario)
    ON DELETE CASCADE
);

-- =========================================
-- 5. TABLA: evento
-- =========================================
CREATE TABLE evento (
    id_evento INT IDENTITY(1,1) PRIMARY KEY,
    nombre_evento VARCHAR(120) NOT NULL,
    descripcion TEXT,
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
-- =========================================
CREATE TABLE comentario (
    id_comentario INT IDENTITY(1,1) PRIMARY KEY,
    id_usuario INT NOT NULL,
    id_publicacion INT NOT NULL,
    contenido TEXT NOT NULL,
    fecha_comentario DATE DEFAULT GETDATE(),

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
-- 7. TABLA: reaccion
-- =========================================
CREATE TABLE reaccion (
    id_reaccion INT IDENTITY(1,1) PRIMARY KEY,
    id_usuario INT NOT NULL,
    id_publicacion INT NOT NULL,

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
-- 8. TABLA: mensaje
-- =========================================
CREATE TABLE mensaje (
    id_mensaje INT IDENTITY(1,1) PRIMARY KEY,
    contenido TEXT NOT NULL,
    fecha_envio DATETIME DEFAULT GETDATE(),
    id_emisor INT NOT NULL,
    id_receptor INT NOT NULL,

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
-- 9. TABLA: solicitud_amistad
-- =========================================
CREATE TABLE solicitud_amistad (
    id_solicitud INT IDENTITY(1,1) PRIMARY KEY,

    estado VARCHAR(20)
    CHECK (estado IN ('pendiente', 'aceptada', 'rechazada')),

    fecha_envio DATE DEFAULT GETDATE(),
    id_emisor INT NOT NULL,
    id_receptor INT NOT NULL,

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
-- 10. TABLA: reporte
-- =========================================
CREATE TABLE reporte (
    id_reporte INT IDENTITY(1,1) PRIMARY KEY,
    motivo TEXT,
    fecha_reporte DATE DEFAULT GETDATE(),
    id_usuario INT NOT NULL,
    id_publicacion INT NOT NULL,

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
-- 11. TABLA: notificacion
-- =========================================
CREATE TABLE notificacion (
    id_notificacion INT IDENTITY(1,1) PRIMARY KEY,
    mensaje TEXT NOT NULL,
    fecha DATETIME DEFAULT GETDATE(),
    id_usuario INT NOT NULL,

    CONSTRAINT fk_notificacion_usuario
    FOREIGN KEY (id_usuario)
    REFERENCES usuario(id_usuario)
    ON DELETE CASCADE
);