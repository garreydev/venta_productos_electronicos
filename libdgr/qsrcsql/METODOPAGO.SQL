--==============================================================================
-- Nombre de la tabla:
--   METODOPAGO
-- Descripción:
--   Tabla de Métodos de Pago.
-- Objetivo:
--   Almacenar registros de los métodos de pago disponibles.
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
CREATE TABLE METODOPAGO (
  CODIGO      FOR COLUMN MEPCODIGO CHAR(3)  NOT NULL,
  DESCRIPCION FOR COLUMN MEPDESCRI CHAR(30) NOT NULL WITH DEFAULT '',
  DETALLE     FOR COLUMN MEPDETALE CHAR(50) NOT NULL WITH DEFAULT '',
  CONSTRAINT METODOPAGO_PK PRIMARY KEY (MEPCODIGO)
) RCDFMT RETODOPAGO;

RENAME TABLE METODOPAGO TO TABLA_DE_METODOS_DE_PAGO
  FOR SYSTEM NAME METODOPAGO;

LABEL ON TABLE METODOPAGO IS 'TABLA DE METODOS DE PAGO';

COMMENT ON TABLE METODOPAGO IS 'TABLA DE METODOS DE PAGO';

-- Headers
LABEL ON COLUMN METODOPAGO (
  MEPCODIGO IS 'CODIGO',
  MEPDESCRI IS 'DESCRIPCION',
  MEPDETALE IS 'DETALLE'
);

-- Descripción
LABEL ON COLUMN METODOPAGO (
  MEPCODIGO TEXT IS 'CODIGO DE METODO PAGO',
  MEPDESCRI TEXT IS 'DESCRIPCION DE METODO PAGO',
  MEPDETALE TEXT IS 'DETALLE DE METODO PAGO'
);

-- Comentarios
COMMENT ON COLUMN METODOPAGO (
  MEPCODIGO IS 'CODIGO DE METODO PAGO',
  MEPDESCRI IS 'DESCRIPCION DE METODO PAGO',
  MEPDETALE IS 'DETALLE DE METODO PAGO'
);
