-- =========================================
-- SGBD: MySQL 8+
-- Red Social Pascualina
-- =========================================

-- =========================================
-- 1. TABLA: usuario (Independiente)
-- =========================================

CREATE TABLE usuario (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,

    nombre VARCHAR(120) NOT NULL,

    correo VARCHAR(120) UNIQUE NOT NULL,

    contrasena VARCHAR(120) NOT NULL,

    tipo_usuario VARCHAR(50) NOT NULL,

    fecha_registro DATE DEFAULT (CURRENT_DATE),

    -- Campo JSON para datos semi-estructurados
    perfil_usuario JSON,

    CONSTRAINT chk_tipo_usuario
    CHECK (
        tipo_usuario IN (
            'estudiante',
            'docente',
            'empleado',
            'empresa',
            'publico'
        )
    )

) ENGINE=InnoDB;

-- =========================================
-- 2. TABLA: grupo
-- Dependiente de usuario
-- =========================================

CREATE TABLE grupo (
    id_grupo INT AUTO_INCREMENT PRIMARY KEY,

    nombre_grupo VARCHAR(120) NOT NULL,

    descripcion TEXT,

    fecha_creacion DATE DEFAULT (CURRENT_DATE),

    id_usuario INT NOT NULL,

    CONSTRAINT fk_grupo_usuario
    FOREIGN KEY (id_usuario)
    REFERENCES usuario(id_usuario)
    ON DELETE CASCADE

) ENGINE=InnoDB;

-- =========================================
-- 3. TABLA: perfil
-- Dependiente de usuario
-- =========================================

CREATE TABLE perfil (
    id_perfil INT AUTO_INCREMENT PRIMARY KEY,

    id_usuario INT UNIQUE NOT NULL,

    biografia TEXT,

    intereses TEXT,

    habilidades TEXT,

    CONSTRAINT fk_perfil_usuario
    FOREIGN KEY (id_usuario)
    REFERENCES usuario(id_usuario)
    ON DELETE CASCADE

) ENGINE=InnoDB;

-- =========================================
-- 4. TABLA: publicacion
-- Dependiente de usuario
-- =========================================

CREATE TABLE publicacion (
    id_publicacion INT AUTO_INCREMENT PRIMARY KEY,

    id_usuario INT NOT NULL,

    contenido TEXT NOT NULL,

    fecha_publicacion DATE DEFAULT (CURRENT_DATE),

    visibilidad VARCHAR(20),

    datos_multimedia JSON,

    CONSTRAINT chk_visibilidad
    CHECK (
        visibilidad IN (
            'publica',
            'privada',
            'amigos'
        )
    ),

    CONSTRAINT fk_publicacion_usuario
    FOREIGN KEY (id_usuario)
    REFERENCES usuario(id_usuario)
    ON DELETE CASCADE

) ENGINE=InnoDB;

-- =========================================
-- 5. TABLA: evento
-- Dependiente de grupo
-- =========================================

CREATE TABLE evento (
    id_evento INT AUTO_INCREMENT PRIMARY KEY,

    nombre_evento VARCHAR(120) NOT NULL,

    descripcion TEXT,

    fecha_evento DATE NOT NULL,

    lugar VARCHAR(120),

    id_grupo INT NOT NULL,

    detalles_evento JSON,

    CONSTRAINT fk_evento_grupo
    FOREIGN KEY (id_grupo)
    REFERENCES grupo(id_grupo)
    ON DELETE CASCADE

) ENGINE=InnoDB;

-- =========================================
-- 6. TABLA: comentario
-- Intermedia
-- =========================================

CREATE TABLE comentario (
    id_comentario INT AUTO_INCREMENT PRIMARY KEY,

    id_usuario INT NOT NULL,

    id_publicacion INT NOT NULL,

    contenido TEXT NOT NULL,

    fecha_comentario DATE DEFAULT (CURRENT_DATE),

    CONSTRAINT fk_comentario_usuario
    FOREIGN KEY (id_usuario)
    REFERENCES usuario(id_usuario)
    ON DELETE RESTRICT,

    CONSTRAINT fk_comentario_publicacion
    FOREIGN KEY (id_publicacion)
    REFERENCES publicacion(id_publicacion)
    ON DELETE CASCADE

) ENGINE=InnoDB;

-- =========================================
-- 7. TABLA: reaccion
-- Intermedia
-- =========================================

CREATE TABLE reaccion (
    id_reaccion INT AUTO_INCREMENT PRIMARY KEY,

    id_usuario INT NOT NULL,

    id_publicacion INT NOT NULL,

    tipo_reaccion VARCHAR(50),

    CONSTRAINT chk_tipo_reaccion
    CHECK (
        tipo_reaccion IN (
            'like',
            'love',
            'haha',
            'wow',
            'triste',
            'enojado'
        )
    ),

    CONSTRAINT fk_reaccion_usuario
    FOREIGN KEY (id_usuario)
    REFERENCES usuario(id_usuario)
    ON DELETE RESTRICT,

    CONSTRAINT fk_reaccion_publicacion
    FOREIGN KEY (id_publicacion)
    REFERENCES publicacion(id_publicacion)
    ON DELETE CASCADE

) ENGINE=InnoDB;

-- =========================================
-- 8. TABLA: mensaje
-- Intermedia
-- =========================================

CREATE TABLE mensaje (
    id_mensaje INT AUTO_INCREMENT PRIMARY KEY,

    contenido TEXT NOT NULL,

    fecha_envio TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    id_emisor INT NOT NULL,

    id_receptor INT NOT NULL,

    CONSTRAINT fk_mensaje_emisor
    FOREIGN KEY (id_emisor)
    REFERENCES usuario(id_usuario)
    ON DELETE CASCADE,

    CONSTRAINT fk_mensaje_receptor
    FOREIGN KEY (id_receptor)
    REFERENCES usuario(id_usuario)
    ON DELETE RESTRICT

) ENGINE=InnoDB;

-- =========================================
-- 9. TABLA: solicitud_amistad
-- Intermedia
-- =========================================

CREATE TABLE solicitud_amistad (
    id_solicitud INT AUTO_INCREMENT PRIMARY KEY,

    estado VARCHAR(20),

    fecha_envio DATE DEFAULT (CURRENT_DATE),

    id_emisor INT NOT NULL,

    id_receptor INT NOT NULL,

    CONSTRAINT chk_estado_solicitud
    CHECK (
        estado IN (
            'pendiente',
            'aceptada',
            'rechazada'
        )
    ),

    CONSTRAINT fk_solicitud_emisor
    FOREIGN KEY (id_emisor)
    REFERENCES usuario(id_usuario)
    ON DELETE CASCADE,

    CONSTRAINT fk_solicitud_receptor
    FOREIGN KEY (id_receptor)
    REFERENCES usuario(id_usuario)
    ON DELETE RESTRICT

) ENGINE=InnoDB;

-- =========================================
-- 10. TABLA: reporte
-- Intermedia
-- =========================================

CREATE TABLE reporte (
    id_reporte INT AUTO_INCREMENT PRIMARY KEY,

    motivo TEXT,

    fecha_reporte DATE DEFAULT (CURRENT_DATE),

    id_usuario INT NOT NULL,

    id_publicacion INT NOT NULL,

    CONSTRAINT fk_reporte_usuario
    FOREIGN KEY (id_usuario)
    REFERENCES usuario(id_usuario)
    ON DELETE RESTRICT,

    CONSTRAINT fk_reporte_publicacion
    FOREIGN KEY (id_publicacion)
    REFERENCES publicacion(id_publicacion)
    ON DELETE CASCADE

) ENGINE=InnoDB;

-- =========================================
-- 11. TABLA: notificacion
-- Dependiente de usuario
-- =========================================

CREATE TABLE notificacion (
    id_notificacion INT AUTO_INCREMENT PRIMARY KEY,

    mensaje TEXT NOT NULL,

    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    id_usuario INT NOT NULL,

    CONSTRAINT fk_notificacion_usuario
    FOREIGN KEY (id_usuario)
    REFERENCES usuario(id_usuario)
    ON DELETE CASCADE

) ENGINE=InnoDB;



INSERT INTO usuario (
    nombre,
    correo,
    contrasena,
    tipo_usuario
)
VALUES (
    'Carlos',
    'carlos@gmail.com',
    '123456',
    'estudiante'
);


INSERT INTO publicacion (
    id_usuario,
    contenido,
    visibilidad
)
VALUES (
    1,
    'Hola comunidad',
    'publica'
);



-- =========================================
-- CONSULTAS DE VALIDACIÓN
-- =========================================

SELECT * FROM usuario;
SELECT * FROM publicacion;

