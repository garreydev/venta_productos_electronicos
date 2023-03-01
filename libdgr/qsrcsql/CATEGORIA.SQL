--==============================================================================
-- Nombre de la tabla:
--   CATEGORIA
-- Descripción:
--   Tabla de Categorías.
-- Objetivo:
--   Almacenar registros de las categorías de los productos.
-- Tipo de tabla:
--   Catálogo
-- Origen de los datos:
--   Mantenimiento de la tabla.
--==============================================================================
-- Cambios Realizados
--   - No Cambio....: ID-001
--   - Responsable..: Danny García Reyes
--   - Fecha........: Febrero 2023
--   - Observaciones: Creación de la tabla.
--==============================================================================
CREATE TABLE CATEGORIA (
  ID_CATEGORIA FOR COLUMN CATIDCATE CHAR(5)  NOT NULL,
  DESCRIPCION  FOR COLUMN CATDESCRI CHAR(30) NOT NULL WITH DEFAULT '',
  DETALLE      FOR COLUMN CATDETALE CHAR(50) NOT NULL WITH DEFAULT '',
  CONSTRAINT CATEGORIA_PK PRIMARY KEY (CATIDCATE)
) RCDFMT RCATEGORIA;

RENAME TABLE CATEGORIA TO TABLA_DE_CATEGORIAS
  FOR SYSTEM NAME CATEGORIA;

LABEL ON TABLE CATEGORIA IS 'TABLA DE CATEGORIAS';

COMMENT ON TABLE CATEGORIA IS 'TABLA DE CATEGORIAS';

-- Headers
LABEL ON COLUMN CATEGORIA (
  CATIDCATE IS 'ID CATEGORIA',
  CATDESCRI IS 'DESCRIPCION',
  CATDETALE IS 'DETALLE'
);

-- Descripción
LABEL ON COLUMN CATEGORIA (
  CATIDCATE TEXT IS 'ID DE CATEGORIA',
  CATDESCRI TEXT IS 'DESCRIPCION DE CATEGORIA',
  CATDETALE TEXT IS 'DETALLE DE CATEGORIA'
);

-- Comentarios
COMMENT ON COLUMN CATEGORIA (
  CATIDCATE IS 'ID DE CATEGORIA',
  CATDESCRI IS 'DESCRIPCION DE CATEGORIA',
  CATDETALE IS 'DETALLE DE CATEGORIA'
);
