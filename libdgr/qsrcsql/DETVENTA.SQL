--==============================================================================
-- Nombre de la tabla:
--   DETVENTA
-- Descripción:
--   Tabla de Detalle de Ventas.
-- Objetivo:
--   Almacenar registros del detalle de las ventas realizadas.
-- Tipo de tabla:
--   Derivada
-- Origen de los datos:
--   Cada vez que se realiza una venta de productos.
--==============================================================================
-- Cambios Realizados
--   - No Cambio....: ID-001
--   - Responsable..: Danny García Reyes
--   - Fecha........: Febrero 2023
--   - Observaciones: Creación de la tabla.
--==============================================================================
CREATE TABLE DETVENTA (
  NUMERO_DETALLE FOR COLUMN DEVNUMDET INTEGER GENERATED ALWAYS AS IDENTITY(
                                               START WITH 1 INCREMENT BY 1
                                               NO MINVALUE NO MAXVALUE
                                               CYCLE NO ORDER
                                               CACHE 20),
  NUMERO_FACTURA FOR COLUMN DEVNUMFAC INTEGER       NOT NULL,
  ID_PRODUCTO    FOR COLUMN DEVIDPROD INTEGER       NOT NULL,
  CANTIDAD       FOR COLUMN DEVCANTID INTEGER       NOT NULL WITH DEFAULT 0,
  PRECIO         FOR COLUMN DEVPRECIO DECIMAL(13,2) NOT NULL WITH DEFAULT 0,
  CONSTRAINT DETVENTA_PK PRIMARY KEY (DEVNUMDET)
) RCDFMT RDETVENTA;

RENAME TABLE DETVENTA TO TABLA_DE_DETALLE_VENTAS
  FOR SYSTEM NAME DETVENTA;

LABEL ON TABLE DETVENTA IS 'TABLA DE DETALLE VENTAS';

COMMENT ON TABLE DETVENTA IS 'TABLA DE DETALLE VENTAS';

-- Headers
LABEL ON COLUMN DETVENTA (
  DEVNUMDET IS 'NUMERO DETALLE',
  DEVNUMFAC IS 'NUMERO FACTURA',
  DEVIDPROD IS 'ID PRODUCTO',
  DEVCANTID IS 'CANTIDAD',
  DEVPRECIO IS 'PRECIO'
);

-- Descripción
LABEL ON COLUMN DETVENTA (
  DEVNUMDET TEXT IS 'NUMERO DE DETALLE VENTA',
  DEVNUMFAC TEXT IS 'NUMERO DE FACTURA',
  DEVIDPROD TEXT IS 'ID DE PRODUCTO',
  DEVCANTID TEXT IS 'CANTIDAD',
  DEVPRECIO TEXT IS 'PRECIO'
);

-- Comentarios
COMMENT ON COLUMN DETVENTA (
  DEVNUMDET IS 'NUMERO DE DETALLE VENTA',
  DEVNUMFAC IS 'NUMERO DE FACTURA',
  DEVIDPROD IS 'ID DE PRODUCTO',
  DEVCANTID IS 'CANTIDAD',
  DEVPRECIO IS 'PRECIO'
);
