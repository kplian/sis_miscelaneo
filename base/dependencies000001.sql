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


/***********************************I-DEP-CAP-MISC-0-04/12/2018****************************************/

--DROP VIEW misc.vconta_almacen;
CREATE OR REPLACE VIEW misc.vconta_almacen (
    fecha_cbte,
    id_conta_alm,
    fecha,
    id_depto_conta,
    id_moneda,
    id_gestion,
    glosa,
    num_tramite,
    codigo_depto,
    id_reg)
AS
 SELECT now()::date AS fecha_cbte,
    calm.id_conta_alm,
    date_trunc('month'::text, per.fecha_ini::timestamp with time zone)::date AS fecha,
    calm.id_depto_conta,
    calm.id_moneda,
    per.id_gestion,
    calm.glosa,
    calm.num_tramite,
    dep.codigo AS codigo_depto,
    date_trunc('month'::text, per.fecha_ini::timestamp with time zone)::date - '1900-01-01'::date AS id_reg
   FROM misc.tconta_alm calm
     JOIN param.tperiodo per ON per.id_periodo = calm.id_periodo
     JOIN param.tdepto dep ON dep.id_depto = calm.id_depto_conta;

--DROP VIEW misc.vconta_almacen_det;
CREATE OR REPLACE VIEW misc.vconta_almacen_det (
    id_conta_alm,
    fecha_cbte,
    id_gestion,
    importe,
    id_depto_conta,
    id_cuenta_debe,
    id_cuenta_haber,
    id_centro_costo,
    id_partida_debe,
    id_partida_haber,
    descripcion,
    tipo_pres)
AS
 WITH tdescrip AS (
         SELECT ca_1.id_conta_alm,
            cal_1.cuenta_contable_haber,
            cal_1.codigo_centro_costo,
            (pxp.list(DISTINCT cal_1.nro_ot::text) || ', Materiales: '::text) || pxp.list(DISTINCT cal_1.codigo_material::text) AS descripcion
           FROM misc.tconta_alm ca_1
             JOIN misc.tconta_alm_det cal_1 ON cal_1.id_conta_alm = ca_1.id_conta_alm
          GROUP BY ca_1.id_conta_alm, cal_1.cuenta_contable_haber, cal_1.codigo_centro_costo
        )
 SELECT ca.id_conta_alm,
    now()::date AS fecha_cbte,
    per.id_gestion,
    sum(cal.total) AS importe,
    ca.id_depto_conta,
    cal.id_cuenta_debe,
    cal.id_cuenta_haber,
    cal.id_centro_costo,
    par.id_partida AS id_partida_debe,
    par1.id_partida AS id_partida_haber,
    ( SELECT tdescrip.descripcion
           FROM tdescrip
          WHERE tdescrip.id_conta_alm = ca.id_conta_alm AND tdescrip.codigo_centro_costo::text = cal.codigo_centro_costo::text AND tdescrip.cuenta_contable_haber::text = cal.cuenta_contable_haber::text) AS descripcion,
    pre.tipo_pres
   FROM misc.tconta_alm ca
     JOIN misc.tconta_alm_det cal ON cal.id_conta_alm = ca.id_conta_alm
     JOIN param.tperiodo per ON per.id_periodo = ca.id_periodo
     JOIN pre.tpartida par ON par.codigo::text = '22900'::text AND par.id_gestion = per.id_gestion
     JOIN pre.tpartida par1 ON par1.codigo::text = '22900'::text AND par1.id_gestion = per.id_gestion
     JOIN pre.tpresupuesto pre ON pre.id_centro_costo = cal.id_centro_costo
  GROUP BY ca.id_conta_alm, per.id_gestion, cal.id_cuenta_debe, cal.id_cuenta_haber, cal.id_centro_costo, par.id_partida, par1.id_partida, cal.codigo_centro_costo, cal.cuenta_contable_haber, pre.tipo_pres;

--DROP VIEW misc.vconta_almacen_det_haber;
CREATE OR REPLACE VIEW misc.vconta_almacen_det_haber (
    id_conta_alm,
    fecha_cbte,
    id_gestion,
    importe,
    tipo_material,
    id_conta_alm_tipo_mat)
AS
 SELECT ca.id_conta_alm,
    now()::date AS fecha_cbte,
    per.id_gestion,
    sum(cal.total) AS importe,
    cal.tipo_material,
    cat.id_conta_alm_tipo_mat
   FROM misc.tconta_alm ca
     JOIN misc.tconta_alm_det cal ON cal.id_conta_alm = ca.id_conta_alm
     JOIN param.tperiodo per ON per.id_periodo = ca.id_periodo
     JOIN misc.tconta_alm_tipo_mat cat ON cat.codigo::text = cal.tipo_material::text
  GROUP BY ca.id_conta_alm, per.id_gestion, cal.tipo_material, cat.id_conta_alm_tipo_mat;


/***********************************F-DEP-CAP-MISC-0-04/12/2018****************************************/

/***********************************I-DEP-RCM-MISC-0-05/02/2019****************************************/
CREATE OR REPLACE VIEW misc.vconta_almacen_det(
    id_conta_alm,
    fecha_cbte,
    id_gestion,
    importe,
    id_depto_conta,
    id_cuenta_debe,
    id_cuenta_haber,
    id_centro_costo,
    id_partida_debe,
    id_partida_haber,
    descripcion,
    tipo_pres)
AS
WITH tdescrip AS(
  SELECT ca_1.id_conta_alm,
         cal_1.cuenta_contable_haber,
         cal_1.codigo_centro_costo,
         (pxp.list(DISTINCT cal_1.nro_ot::text) || ', Materiales: '::text) ||
           pxp.list(DISTINCT cal_1.codigo_material::text) AS descripcion
  FROM misc.tconta_alm ca_1
       JOIN misc.tconta_alm_det cal_1 ON cal_1.id_conta_alm = ca_1.id_conta_alm
  GROUP BY ca_1.id_conta_alm,
           cal_1.cuenta_contable_haber,
           cal_1.codigo_centro_costo)
    SELECT ca.id_conta_alm,
           now()::date AS fecha_cbte,
           per.id_gestion,
           sum(cal.total) AS importe,
           ca.id_depto_conta,
           cal.id_cuenta_debe,
           cal.id_cuenta_haber,
           cc1.id_centro_costo,
           par.id_partida AS id_partida_debe,
           par1.id_partida AS id_partida_haber,
           (
             SELECT tdescrip.descripcion
             FROM tdescrip
             WHERE tdescrip.id_conta_alm = ca.id_conta_alm AND
                   tdescrip.codigo_centro_costo::text = cal.codigo_centro_costo
                     ::text AND
                   tdescrip.cuenta_contable_haber::text =
                     cal.cuenta_contable_haber::text
           ) AS descripcion,
           pre.tipo_pres
    FROM misc.tconta_alm ca
         JOIN misc.tconta_alm_det cal ON cal.id_conta_alm = ca.id_conta_alm
         JOIN param.tperiodo per ON per.id_periodo = ca.id_periodo
         LEFT JOIN pre.tpartida par ON par.codigo::text = '22900'::text AND
           par.id_gestion = per.id_gestion
         LEFT JOIN pre.tpartida par1 ON par1.codigo::text = '22900'::text AND
           par1.id_gestion = per.id_gestion
         JOIN pre.tpresupuesto pre ON pre.id_centro_costo = cal.id_centro_costo
         JOIN param.tcentro_costo cc ON cc.id_centro_costo = cal.id_centro_costo
         JOIN param.tcentro_costo cc1 ON cc1.id_tipo_cc = cc.id_tipo_cc AND
           cc1.id_gestion =((
                              SELECT tgestion.id_gestion
                              FROM param.tgestion
                              WHERE date_trunc('year'::text, tgestion.fecha_ini
                                ::timestamp with time zone) = date_trunc('year'
                                ::text, ca.fecha_fin::timestamp with time zone)
         ))
    GROUP BY ca.id_conta_alm,
             per.id_gestion,
             cal.id_cuenta_debe,
             cal.id_cuenta_haber,
             cc1.id_centro_costo,
             par.id_partida,
             par1.id_partida,
             cal.codigo_centro_costo,
             cal.cuenta_contable_haber,
             pre.tipo_pres;
/***********************************F-DEP-RCM-MISC-0-05/02/2019****************************************/