-- ========================================================================== --
--                 SCRIPT PARA SUBIR LA INTEGRIDAD REFERENCIAL                --
-- ========================================================================== --
-- No Cambio....: ID-001                                                      --
-- Responsable..: Danny García Reyes                                          --
-- Fecha........: Febrero 2023                                                --
-- Observaciones: Creación de declaraciones de integridad referencial.        --
-- ========================================================================== --

-- -------------------------------------------------------------------------- --
-- IR ENTRE TABLAS: CLIENTE -> FACTURA, METODOPAGO -> FACTURA                 --
-- -------------------------------------------------------------------------- --
ALTER TABLE FACTURA ADD CONSTRAINT CLIENTE_FACTURA_FK FOREIGN KEY (FACIDCLIE)
REFERENCES CLIENTE (CLIIDCLIE) ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE FACTURA ADD CONSTRAINT METODOPAGO_FACTURA_FK FOREIGN KEY (FACCODMEP)
REFERENCES METODOPAGO (MEPCODIGO) ON DELETE RESTRICT ON UPDATE RESTRICT;

-- -------------------------------------------------------------------------- --
-- IR ENTRE TABLAS: FACTURA -> DETVENTA, PRODUCTO -> DETVENTA                 --
-- -------------------------------------------------------------------------- --
ALTER TABLE DETVENTA ADD CONSTRAINT FACTURA_DETVENTA_FK FOREIGN KEY (DEVNUMFAC)
REFERENCES FACTURA (FACNUMERO) ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE DETVENTA ADD CONSTRAINT PRODUCTO_DETVENTA_FK FOREIGN KEY (DEVIDPROD)
REFERENCES PRODUCTO (PROIDPROD) ON DELETE RESTRICT ON UPDATE RESTRICT;

-- -------------------------------------------------------------------------- --
-- IR ENTRE TABLAS: CATEGORIA -> PRODUCTO                                     --
-- -------------------------------------------------------------------------- --
ALTER TABLE PRODUCTO ADD CONSTRAINT CATEGORIA_PRODUCTO_FK
FOREIGN KEY (PROIDCATE)
REFERENCES CATEGORIA (CATIDCATE) ON DELETE RESTRICT ON UPDATE RESTRICT;
