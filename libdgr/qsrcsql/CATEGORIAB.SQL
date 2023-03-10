--==============================================================================
-- Nombre de la tabla:
--   CATEGORIAB
-- Descripción:
--   Bitácora de la Tabla de Categorías.
-- Objetivo:
--   Almacenar los cambios realizados en la tabla de las categorías, los cuales
--   pueden ser: inserción, actualización o eliminación.
-- Tipo de tabla:
--   Bitácora
-- Origen de los datos:
--   Se ingresa un registro cuando se realiza un cambio en la tabla de las
--   categorías.
--==============================================================================
-- Cambios Realizados
--   - No Cambio....: ID-001
--   - Responsable..: Danny García Reyes
--   - Fecha........: Febrero 2023
--   - Observaciones: Creación de la tabla.
--==============================================================================
CREATE TABLE CATEGORIAB (
  ID_CATEGORIA   FOR COLUMN BCATIDCATE CHAR(5)   NOT NULL,
  FECHA_EVENTO   FOR COLUMN BCATFECEVN TIMESTAMP NOT NULL,
  DESCRIPCION    FOR COLUMN BCATDESCRI CHAR(30)  NOT NULL WITH DEFAULT '',
  DETALLE        FOR COLUMN BCATDETALE CHAR(50)  NOT NULL WITH DEFAULT '',
  TIPO_EVENTO    FOR COLUMN BCATTIPEVN CHAR(1)   NOT NULL WITH DEFAULT 'I',
  USUARIO_EVENTO FOR COLUMN BCATUSUEVN CHAR(18)  NOT NULL WITH DEFAULT USER,
  CONSTRAINT BCATTIPEVN_CHK_CST CHECK (BCATTIPEVN IN ('I', 'A', 'E')),
  CONSTRAINT CATEGORIAB_PK PRIMARY KEY (BCATIDCATE, BCATFECEVN)
) RCDFMT RATEGORIAB;

RENAME TABLE CATEGORIAB TO BITACORA_TABLA_DE_CATEGORIAS
  FOR SYSTEM NAME CATEGORIAB;

LABEL ON TABLE CATEGORIAB IS 'BITACORA DE TABLA DE CATEGORIAS';

COMMENT ON TABLE CATEGORIAB IS 'BITACORA DE TABLA DE CATEGORIAS';

-- Headers
LABEL ON COLUMN CATEGORIAB (
  BCATIDCATE IS 'ID CATEGORIA',
  BCATFECEVN IS 'FECHA EVENTO',
  BCATDESCRI IS 'DESCRIPCION',
  BCATDETALE IS 'DETALLE',
  BCATTIPEVN IS 'TIPO EVENTO',
  BCATUSUEVN IS 'USUARIO EVENTO'
);

-- Descripción
LABEL ON COLUMN CATEGORIAB (
  BCATIDCATE TEXT IS 'ID DE CATEGORIA',
  BCATFECEVN TEXT IS 'FECHA DEL EVENTO',
  BCATDESCRI TEXT IS 'DESCRIPCION DE CATEGORIA',
  BCATDETALE TEXT IS 'DETALLE DE CATEGORIA',
  BCATTIPEVN TEXT IS 'TIPO DE EVENTO',
  BCATUSUEVN TEXT IS 'USUARIO DEL EVENTO'
);

-- Comentarios
COMMENT ON COLUMN CATEGORIAB (
  BCATIDCATE IS 'ID DE CATEGORIA',
  BCATFECEVN IS 'FECHA DEL EVENTO',
  BCATDESCRI IS 'DESCRIPCION DE CATEGORIA',
  BCATDETALE IS 'DETALLE DE CATEGORIA',
  BCATTIPEVN IS 'TIPO DE EVENTO: I-INSERCION, A-ACTUALIZACION, E-ELIMINACION',
  BCATUSUEVN IS 'USUARIO DEL EVENTO'
);
