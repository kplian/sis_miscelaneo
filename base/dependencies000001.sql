/***********************************I-DEP-RCM-MISC-1-23/08/2018****************************************/
ALTER TABLE misc.tconta_alm
  ADD CONSTRAINT fk_tconta_alm__id_periodo FOREIGN KEY (id_periodo)
    REFERENCES param.tperiodo(id_periodo)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
ALTER TABLE misc.tconta_alm
  ADD CONSTRAINT fk_tconta_alm__id_int_comprobante FOREIGN KEY (id_int_comprobante)
    REFERENCES conta.tint_comprobante(id_int_comprobante)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
/***********************************F-DEP-RCM-MISC-1-23/08/2018****************************************/


/***********************************I-DEP-RCM-MISC-1-12/10/2018****************************************/
ALTER TABLE misc.tconta_alm_det
  ADD CONSTRAINT fk_tconta_alm_det__id_conta_alm FOREIGN KEY (id_conta_alm)
    REFERENCES misc.tconta_alm(id_conta_alm)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE misc.tconta_alm_det
  ADD CONSTRAINT fk_tconta_alm_det__id_centro_costo FOREIGN KEY (id_centro_costo)
    REFERENCES param.tcentro_costo(id_centro_costo)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE misc.tconta_alm_det
  ADD CONSTRAINT fk_tconta_alm_det__id_moneda FOREIGN KEY (id_moneda)
    REFERENCES param.tmoneda(id_moneda)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE misc.tconta_alm_det
  ADD CONSTRAINT fk_tconta_alm_det__id_cuenta_debe FOREIGN KEY (id_cuenta_debe)
    REFERENCES conta.tcuenta(id_cuenta)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE misc.tconta_alm_det
  ADD CONSTRAINT fk_tconta_alm_det__id_cuenta_haber FOREIGN KEY (id_cuenta_haber)
    REFERENCES conta.tcuenta(id_cuenta)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
/***********************************F-DEP-RCM-MISC-1-12/10/2018****************************************/