--==============================================================================
-- Nombre de la tabla:
--   FACTURA
-- Descripción:
--   Tabla de Facturas.
-- Objetivo:
--   Almacenar registros de las facturas.
-- Tipo de tabla:
--   Principal
-- Origen de los datos:
--   Cada vez que se realiza una venta de productos.
--==============================================================================
-- Cambios Realizados
--   - No Cambio....: ID-001
--   - Responsable..: Danny García Reyes
--   - Fecha........: Febrero 2023
--   - Observaciones: Creación de la tabla.
--==============================================================================
CREATE TABLE FACTURA (
  NUMERO_FACTURA FOR COLUMN FACNUMERO INTEGER GENERATED ALWAYS AS IDENTITY(
                                              START WITH 1 INCREMENT BY 1
                                              NO MINVALUE NO MAXVALUE
                                              CYCLE NO ORDER
                                              CACHE 20),
  FECHA_FACTURA  FOR COLUMN FACFECHAF DATE    NOT NULL WITH DEFAULT,
  ID_CLIENTE     FOR COLUMN FACIDCLIE INTEGER NOT NULL,
  CODIGO_METODOP FOR COLUMN FACCODMEP CHAR(3) NOT NULL,
  CONSTRAINT FACTURA_PK PRIMARY KEY (FACNUMERO)
) RCDFMT RFACTURA;

RENAME TABLE FACTURA TO TABLA_DE_FACTURAS
  FOR SYSTEM NAME FACTURA;

LABEL ON TABLE FACTURA IS 'TABLA DE FACTURAS';

COMMENT ON TABLE FACTURA IS 'TABLA DE FACTURAS';

-- Headers
LABEL ON COLUMN FACTURA (
  FACNUMERO IS 'NUMERO FACTURA',
  FACFECHAF IS 'FECHA FACTURA',
  FACIDCLIE IS 'ID CLIENTE',
  FACCODMEP IS 'CODIGO METODO PAGO'
);

-- Descripción
LABEL ON COLUMN FACTURA (
  FACNUMERO TEXT IS 'NUMERO DE FACTURA',
  FACFECHAF TEXT IS 'FECHA DE FACTURA',
  FACIDCLIE TEXT IS 'ID DE CLIENTE',
  FACCODMEP TEXT IS 'CODIGO DE METODO PAGO'
);

-- Comentarios
COMMENT ON COLUMN FACTURA (
  FACNUMERO IS 'NUMERO DE FACTURA',
  FACFECHAF IS 'FECHA DE FACTURA',
  FACIDCLIE IS 'ID DE CLIENTE',
  FACCODMEP IS 'CODIGO DE METODO PAGO'
);
