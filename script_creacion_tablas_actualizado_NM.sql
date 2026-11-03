-- =====================================================
-- CENTROS INTEGRALES
-- =====================================================

CREATE TABLE public.centros_integrales (
    id SERIAL NOT NULL,
    esta_activo BOOLEAN,
    municipio_id INTEGER NOT NULL,
    nombre VARCHAR(50) NOT NULL,

    CONSTRAINT centros_integrales_pkey
        PRIMARY KEY (id),

    CONSTRAINT centros_integrales_municipio_id_fk
        FOREIGN KEY (municipio_id)
        REFERENCES public.municipios(id)
);


-- =====================================================
-- ROLES
-- =====================================================

CREATE TABLE public.roles (
    id SERIAL NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    descripcion VARCHAR(150),
    esta_activo BOOLEAN NOT NULL,

    CONSTRAINT roles_pkey
        PRIMARY KEY (id),

    CONSTRAINT uq_roles_nombre
        UNIQUE (nombre)
);


-- =====================================================
-- ACCIONES
-- =====================================================

CREATE TABLE public.acciones (
    id SERIAL NOT NULL,
    esta_activo BOOLEAN NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    descripcion VARCHAR(120),

    CONSTRAINT acciones_pkey
        PRIMARY KEY (id),

    CONSTRAINT uq_acciones_nombre
        UNIQUE (nombre)
);


-- =====================================================
-- USUARIOS
-- =====================================================

CREATE TABLE public.usuarios (
    id SERIAL NOT NULL,
    centro_integral_id INTEGER,
    rol_id INTEGER NOT NULL,
    usuario VARCHAR(50) NOT NULL,
    contrasena VARCHAR(50) NOT NULL,
    esta_activo BOOLEAN NOT NULL DEFAULT TRUE,

    CONSTRAINT usuarios_pkey
        PRIMARY KEY (id),

    CONSTRAINT usuarios_centros_integrales_id_fk
        FOREIGN KEY (centro_integral_id)
        REFERENCES public.centros_integrales(id),

    CONSTRAINT usuarios_roles_id_fk
        FOREIGN KEY (rol_id)
        REFERENCES public.roles(id),

    CONSTRAINT uq_usuarios_usuario
        UNIQUE (usuario),

    CONSTRAINT chk_contrasena
        CHECK (LENGTH(contrasena) >= 6)
);


-- =====================================================
-- LOGS
-- =====================================================

CREATE TABLE public.logs (
    id SERIAL NOT NULL,
    fecha DATE NOT NULL,
    hora TIME WITHOUT TIME ZONE NOT NULL,
    accion_id INTEGER NOT NULL,
    usuario VARCHAR(50) NOT NULL,
    detalle VARCHAR(150) NOT NULL,

    CONSTRAINT logs_pkey
        PRIMARY KEY (id),

    CONSTRAINT logs_accion_id_fkey
        FOREIGN KEY (accion_id)
        REFERENCES public.acciones(id)
);


-- =====================================================
-- PARTICIPANTES - CENTROS INTEGRALES (RELACION N:M)
-- =====================================================

-- Elimina la relacion directa anterior, si existe,
-- porque la relacion ahora se manejara mediante tabla pivote.
ALTER TABLE public.participantes
DROP COLUMN IF EXISTS centros_integrales_id CASCADE;


-- Tabla pivote entre participantes y centros_integrales.
CREATE TABLE public.participantes_centros_integrales (
    participantes_id INTEGER NOT NULL,
    centros_integrales_id INTEGER NOT NULL,
    fecha DATE,

    CONSTRAINT participantes_centros_integrales_pkey
        PRIMARY KEY (participantes_id, centros_integrales_id),

    CONSTRAINT participantes_centros_integrales_participantes_id_fkey
        FOREIGN KEY (participantes_id)
        REFERENCES public.participantes(id),

    CONSTRAINT participantes_centros_integrales_centros_integrales_id_fkey
        FOREIGN KEY (centros_integrales_id)
        REFERENCES public.centros_integrales(id)
);
