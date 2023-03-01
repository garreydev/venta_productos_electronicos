--==============================================================================
-- Nombre de la tabla:
--   PRODUCTO
-- Descripción:
--   Tabla de Productos
-- Objetivo:
--   Almacenar registros de los productos.
-- Tipo de tabla:
--   Principal
-- Origen de los datos:
--   Mantenimiento de la tabla.
--==============================================================================
-- Cambios Realizados
--   - No Cambio....: ID-001
--   - Responsable..: Danny García Reyes
--   - Fecha........: Febrero 2023
--   - Observaciones: Creación de la tabla.
--==============================================================================
CREATE TABLE PRODUCTO (
  ID_PRODUCTO     FOR COLUMN PROIDPROD INTEGER GENERATED ALWAYS AS IDENTITY(
                                               START WITH 1 INCREMENT BY 1
                                               NO MINVALUE NO MAXVALUE
                                               CYCLE NO ORDER
                                               CACHE 20),
  NOMBRE_PRODUCTO FOR COLUMN PRONOMBRE CHAR(30)      NOT NULL WITH DEFAULT '',
  PRECIO          FOR COLUMN PROPRECIO DECIMAL(13,2) NOT NULL WITH DEFAULT 0,
  STOCK           FOR COLUMN PROSTOCKP INTEGER       NOT NULL WITH DEFAULT 0,
  ID_CATEGORIA    FOR COLUMN PROIDCATE CHAR(5)       NOT NULL,
  CONSTRAINT PRODUCTO_PK PRIMARY KEY (PROIDPROD)
) RCDFMT RPRODUCTO;

RENAME TABLE PRODUCTO TO TABLA_DE_PRODUCTOS
  FOR SYSTEM NAME PRODUCTO;

LABEL ON TABLE PRODUCTO IS 'TABLA DE PRODUCTOS';

COMMENT ON TABLE PRODUCTO IS 'TABLA DE PRODUCTOS';

-- Headers
LABEL ON COLUMN PRODUCTO (
  PROIDPROD IS 'ID PRODUCTO',
  PRONOMBRE IS 'NOMBRE PRODUCTO',
  PROPRECIO IS 'PRECIO PRODUCTO',
  PROSTOCKP IS 'STOCK PRODUCTO',
  PROIDCATE IS 'ID CATEGORIA'
);

-- Descripción
LABEL ON COLUMN PRODUCTO (
  PROIDPROD TEXT IS 'ID DE PRODUCTO',
  PRONOMBRE TEXT IS 'NOMBRE DE PRODUCTO',
  PROPRECIO TEXT IS 'PRECIO DE PRODUCTO',
  PROSTOCKP TEXT IS 'STOCK DE PRODUCTO',
  PROIDCATE TEXT IS 'ID DE CATEGORIA'
);

-- Comentarios
COMMENT ON COLUMN PRODUCTO (
  PROIDPROD IS 'ID DE PRODUCTO',
  PRONOMBRE IS 'NOMBRE DE PRODUCTO',
  PROPRECIO IS 'PRECIO DE PRODUCTO',
  PROSTOCKP IS 'STOCK DE PRODUCTO',
  PROIDCATE IS 'ID DE CATEGORIA'
);
