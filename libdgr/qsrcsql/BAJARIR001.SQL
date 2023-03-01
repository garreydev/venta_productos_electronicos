-- ========================================================================== --
--                 SCRIPT PARA BAJAR LA INTEGRIDAD REFERENCIAL                --
-- ========================================================================== --
-- NO CAMBIO....: ID-001                                                      --
-- RESPONSABLE..: DANNY GARCÍA REYES                                          --
-- FECHA........: FEBRERO 2023                                                --
-- OBSERVACIONES: CREACIÓN DE DECLARACIONES DE INTEGRIDAD REFERENCIAL.        --
-- ========================================================================== --

-- -------------------------------------------------------------------------- --
-- IR ENTRE TABLAS: CLIENTE -> FACTURA, METODOPAGO -> FACTURA                 --
-- -------------------------------------------------------------------------- --
ALTER TABLE FACTURA DROP CONSTRAINT CLIENTE_FACTURA_FK;

ALTER TABLE FACTURA DROP CONSTRAINT METODOPAGO_FACTURA_FK;

-- -------------------------------------------------------------------------- --
-- IR ENTRE TABLAS: FACTURA -> DETVENTA, PRODUCTO -> DETVENTA                 --
-- -------------------------------------------------------------------------- --
ALTER TABLE DETVENTA DROP CONSTRAINT FACTURA_DETVENTA_FK;

ALTER TABLE DETVENTA DROP CONSTRAINT PRODUCTO_DETVENTA_FK;

-- -------------------------------------------------------------------------- --
-- IR ENTRE TABLAS: CATEGORIA -> PRODUCTO                                     --
-- -------------------------------------------------------------------------- --
ALTER TABLE PRODUCTO DROP CONSTRAINT CATEGORIA_PRODUCTO_FK;
