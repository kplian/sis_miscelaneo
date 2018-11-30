/***********************************I-DAT-RCM-MISC-1-23/08/2018****************************************/
INSERT INTO segu.tsubsistema ("codigo", "nombre", "fecha_reg", "prefijo", "estado_reg", "nombre_carpeta", "id_subsis_orig")
VALUES (E'MISC', E'Sistema Misceláneos', E'2018-08-23', E'MIS', E'activo', E'miscelaneo', NULL);

-----------------------------------
--DEFINICION DE INTERFACES
-----------------------------------
select pxp.f_insert_tgui ('VARIOS', '', 'MISC_1', 'si',1 , '', 1, '../../../lib/imagenes/alma32x32.png', '', 'MISC');
select pxp.f_insert_tgui ('Almacenes SIGEMA', 'Almacenes SIGEMA', 'MISC_1.1', 'si', 1, '', 2, '', '', 'MISC');
select pxp.f_insert_tgui ('Contabilizar Almacenes', '', 'MISC_1.1.1', 'si', 1, 'sis_miscelaneo/vista/conta_alm/ContaAlm.php', 3, '', 'ContaAlm', 'MISC');
select pxp.f_insert_tgui ('Relación Depto. Regional SIGEMA', '', 'MISC_1.1.2', 'si', 2, 'sis_miscelaneo/vista/depto_regional_sigema/DeptoRegionalSigema.php', 3, '', 'DeptoRegionalSigema', 'MISC');

select pxp.f_insert_testructura_gui ('MISC_1', 'SISTEMA');
select pxp.f_insert_testructura_gui ('MISC_1.1', 'MISC_1');
select pxp.f_insert_testructura_gui ('MISC_1.1.1', 'MISC_1.1');
select pxp.f_insert_testructura_gui ('MISC_1.1.2', 'MISC_1.1');

select pxp.f_add_catalog('MISC','tconta_alm__tipo','Ingreso','ingreso');
select pxp.f_add_catalog('MISC','tconta_alm__tipo','Salida','salida');
/***********************************F-DAT-RCM-PRO-1-23/08/2018****************************************/

/***********************************I-DAT-RCM-PRO-1-11/10/2018****************************************/
select pxp.f_insert_tgui ('Todas Contabilizaciones', '', 'MISC_1.1.3', 'si', 3, 'sis_miscelaneo/vista/conta_alm/ContaAlmAdm.php', 3, '', 'ContaAlmAdm', 'MISC');
select pxp.f_insert_testructura_gui ('MISC_1.1.3', 'MISC_1.1');
/***********************************F-DAT-RCM-PRO-1-11/10/2018****************************************/

/***********************************I-DAT-RCM-PRO-1-31/10/2018****************************************/
select pxp.f_insert_tgui ('Tipo Material - Cuenta', '', 'MISC_1.1.4', 'si', 4, 'sis_miscelaneo/vista/conta_alm_tipo_mat/ContaAlmTipoMat.php', 3, '', 'ContaAlmTipoMat', 'MISC');
select pxp.f_insert_testructura_gui ('MISC_1.1.4', 'MISC_1.1');
/***********************************F-DAT-RCM-PRO-1-31/10/2018****************************************/