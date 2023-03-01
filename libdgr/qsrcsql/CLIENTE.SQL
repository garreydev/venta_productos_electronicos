--==============================================================================
-- Nombre de la tabla:
--   CLIENTE
-- Descripción:
--   Tabla de Clientes.
-- Objetivo:
--   Almacenar registros de clientes.
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
CREATE TABLE CLIENTE (
  ID_CLIENTE       FOR COLUMN CLIIDCLIE INTEGER GENERATED ALWAYS AS IDENTITY(
                                                START WITH 1 INCREMENT BY 1
                                                NO MINVALUE NO MAXVALUE
                                                CYCLE NO ORDER
                                                CACHE 20),
  NOMBRE           FOR COLUMN CLINOMCLI CHAR(50)   NOT NULL WITH DEFAULT '',
  APELLIDO         FOR COLUMN CLIAPECLI CHAR(50)   NOT NULL WITH DEFAULT '',
  FECHA_NACIMIENTO FOR COLUMN CLIFECNAC DATE       NOT NULL WITH DEFAULT,
  TELEFONO         FOR COLUMN CLITELCLI NUMERIC(8) NOT NULL WITH DEFAULT 0,
  DIRECCION        FOR COLUMN CLIDIRCLI CHAR(100)  NOT NULL WITH DEFAULT '',
  EMAIL            FOR COLUMN CLIEMACLI CHAR(50)   NOT NULL WITH DEFAULT '',
  CONSTRAINT CLIENTE_PK PRIMARY KEY (CLIIDCLIE)
) RCDFMT RCLIENTE;

RENAME TABLE CLIENTE TO TABLA_DE_CLIENTES
  FOR SYSTEM NAME CLIENTE;

LABEL ON TABLE CLIENTE IS 'TABLA DE CLIENTES';

COMMENT ON TABLE CLIENTE IS 'TABLA DE CLIENTES';

-- Headers
LABEL ON COLUMN CLIENTE (
  CLIIDCLIE IS 'ID CLIENTE',
  CLINOMCLI IS 'NOMBRE',
  CLIAPECLI IS 'APELLIDO',
  CLIFECNAC IS 'FECHA NACIMIENTO',
  CLITELCLI IS 'TELEFONO',
  CLIDIRCLI IS 'DIRECCION',
  CLIEMACLI IS 'EMAIL'
);

-- Descripción
LABEL ON COLUMN CLIENTE (
  CLIIDCLIE TEXT IS 'ID DE CLIENTE',
  CLINOMCLI TEXT IS 'NOMBRE DE CLIENTE',
  CLIAPECLI TEXT IS 'APELLIDO DE CLIENTE',
  CLIFECNAC TEXT IS 'FECHA DE NACIMIENTO',
  CLITELCLI TEXT IS 'TELEFONO DE CLIENTE',
  CLIDIRCLI TEXT IS 'DIRECCION DE CLIENTE',
  CLIEMACLI TEXT IS 'EMAIL DE CLIENTE'
);

-- Comentarios
COMMENT ON COLUMN CLIENTE (
  CLIIDCLIE IS 'ID DE CLIENTE',
  CLINOMCLI IS 'NOMBRE DE CLIENTE',
  CLIAPECLI IS 'APELLIDO DE CLIENTE',
  CLIFECNAC IS 'FECHA DE NACIMIENTO',
  CLITELCLI IS 'TELEFONO DE CLIENTE',
  CLIDIRCLI IS 'DIRECCION DE CLIENTE',
  CLIEMACLI IS 'EMAIL DE CLIENTE'
);
