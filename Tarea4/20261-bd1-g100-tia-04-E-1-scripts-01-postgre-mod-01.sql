-- Scripts de Modificación de la Base de Datos - SGBD PostgreSQL


-- Gestionar una tabla "nueva"
-- 1.- "agregar" una nueva tabla a la base de datos que tenga relación con el sistema
-- 2.- Darle un nombre "coherente"
-- 3.- Agregar campos coherentes con la tabla
-- 4.- Realizar todas las operaciones que se solicitan a continuación
--

-- =========================================
-- 1.
-- Crear una tabla nueva relacionada con el sistema
-- =========================================

CREATE TABLE servicio (
    id_servicio SERIAL,
    nombre_servicio VARCHAR(100),
    precio INTEGER,
    descripcion TEXT
);

-- =========================================
-- 2.
-- Agregar clave primaria y otros campos
-- =========================================

ALTER TABLE servicio
ADD CONSTRAINT pk_servicio PRIMARY KEY (id_servicio);

ALTER TABLE servicio
ADD COLUMN categoria VARCHAR(50),
ADD COLUMN disponibilidad BOOLEAN DEFAULT TRUE,
ADD COLUMN id_usuario INTEGER;

-- Relación con tabla usuario
ALTER TABLE servicio
ADD CONSTRAINT fk_servicio_usuario
FOREIGN KEY (id_usuario)
REFERENCES usuario(id_usuario)
ON DELETE CASCADE;

-- =========================================
-- 3.
-- Quitar uno de los campos
-- =========================================

ALTER TABLE servicio
DROP COLUMN descripcion;

-- =========================================
-- 4.
-- Cambiar el nombre de la tabla
-- =========================================

ALTER TABLE servicio
RENAME TO oferta_servicio;

-- =========================================
-- 5.
-- Agregar un campo único
-- =========================================

ALTER TABLE oferta_servicio
ADD COLUMN codigo_servicio VARCHAR(50) UNIQUE;

-- =========================================
-- 6.
-- Agregar fechas y control de orden
-- =========================================

ALTER TABLE oferta_servicio
ADD COLUMN fecha_inicio DATE,
ADD COLUMN fecha_fin DATE,
ADD CONSTRAINT chk_fechas
CHECK (fecha_inicio <= fecha_fin);

-- =========================================
-- 7.
-- Agregar campo entero con control
-- =========================================

ALTER TABLE oferta_servicio
ADD COLUMN cupos INTEGER,
ADD CONSTRAINT chk_cupos
CHECK (cupos >= 0);

-- =========================================
-- 8.
-- Modificar tamaño de un campo texto
-- =========================================

ALTER TABLE oferta_servicio
ALTER COLUMN nombre_servicio TYPE VARCHAR(200);

-- =========================================
-- 9.
-- Modificar campo numérico y control de rango
-- =========================================

ALTER TABLE oferta_servicio
ADD CONSTRAINT chk_precio
CHECK (precio BETWEEN 0 AND 10000000);

-- =========================================
-- 10.
-- Agregar índice
-- =========================================

CREATE INDEX idx_oferta_servicio_precio
ON oferta_servicio(precio);

-- =========================================
-- 11.
-- Eliminar una de las fechas
-- =========================================

ALTER TABLE oferta_servicio
DROP COLUMN fecha_fin;

-- =========================================
-- 12.
-- Borrar todos los datos sin dejar traza
-- =========================================

TRUNCATE TABLE oferta_servicio;