/***********************************I-SCP-RCM-MISC-1-23/08/2018****************************************/
create table misc.tconta_alm (
	id_conta_alm serial,
	id_periodo integer NOT NULL,
	id_int_comprobante integer,
	estado varchar(30),
	tipo varchar(30) NOT NULL,
	glosa VARCHAR(2000) NOT NULL,
	constraint pk_tconta_alm__id_conta_alm primary key (id_conta_alm)
) inherits (pxp.tbase) without oids;

COMMENT ON COLUMN misc.tconta_alm.tipo
IS 'Tipo de contabilización: ingreso, salida';

ALTER TABLE misc.tconta_alm
  ADD CONSTRAINT uq_tconta_alm__id_periodo__tipo
    UNIQUE (id_periodo, tipo) NOT DEFERRABLE;

ALTER TABLE misc.tconta_alm
  ADD COLUMN id_proceso_wf INTEGER;
ALTER TABLE misc.tconta_alm
  ADD COLUMN id_estado_wf INTEGER;
ALTER TABLE misc.tconta_alm
  ADD COLUMN num_tramite VARCHAR(200);
ALTER TABLE misc.tconta_alm
  ADD COLUMN id_depto_conta INTEGER;
ALTER TABLE misc.tconta_alm
  ADD COLUMN id_moneda INTEGER;
/***********************************F-SCP-RCM-MISC-1-23/08/2018****************************************/

/***********************************I-SCP-RCM-MISC-1-31/08/2018****************************************/
--Todo lo relacionado al SIGEMA (datawrapper a MSSQL). TODO: aumentar lógica para crear estos objetos en función de alguna bandera
/*CREATE FOREIGN TABLE misc.sigema_almacen_salida (
  fecha DATE,
  nro_ot VARCHAR,
  centro_costo VARCHAR,
  tipo_centro_costo VARCHAR,
  cuenta_contable_debe VARCHAR,
  cuenta_contable_haber VARCHAR,
  codigo_material VARCHAR,
  nombre_material VARCHAR,
  precio_unitario NUMERIC,
  total NUMERIC,
  moneda VARCHAR,
  codigo_centro_costo VARCHAR,
  almacen VARCHAR,
  centro_almacen VARCHAR
)
SERVER mssql_sigema
OPTIONS (query 'SELECT
fecha,
nro_ot,
centro_costo,
tipo_centro_costo,
cuenta_contable_debe,
cuenta_contable_haber,
codigo_material,
nombre_material,
precio_unitario,
total,
moneda,
codigo_centro_costo,
almacen,
centro_almacen
FROM SIGEMA_PROD..VW_SalidasMateriales');

create table misc.tdepto_regional_sigema (
	id_depto_regional_sigema serial,
	id_depto integer NOT NULL,
	codigo_regional_sigema varchar(30),
	constraint pk_tdepto_regional_sigema__id_depto_regional_sigema primary key (id_depto_regional_sigema)
) inherits (pxp.tbase) without oids;*/

/***********************************F-SCP-RCM-MISC-1-31/08/2018****************************************/

/***********************************I-SCP-RCM-MISC-1-12/09/2018****************************************/
ALTER TABLE misc.tconta_alm
  ADD COLUMN fecha_ini DATE;
ALTER TABLE misc.tconta_alm
  ADD COLUMN fecha_fin DATE;
/***********************************F-SCP-RCM-MISC-1-12/09/2018****************************************/

/***********************************I-SCP-RCM-MISC-1-11/10/2018****************************************/
CREATE TABLE misc.tconta_alm_det (
  id_conta_alm_det SERIAL,
  id_conta_alm INTEGER,
  id_centro_costo INTEGER,
  id_moneda INTEGER,
  id_cuenta_debe INTEGER,
  id_cuenta_haber INTEGER,
  fecha DATE,
  nro_ot VARCHAR,
  codigo_material VARCHAR(50),
  nombre_material VARCHAR(200),
  precio_unitario NUMERIC,
  total NUMERIC,
  moneda VARCHAR(30),
  centro_costo VARCHAR(200),
  desc_cuenta_debe TEXT,
  desc_cuenta_haber TEXT,
  almacen VARCHAR(100),
  centro_almacen VARCHAR(100),
  codigo_centro_costo VARCHAR(100),
  cuenta_contable_debe VARCHAR(150),
  cuenta_contable_haber VARCHAR(150),
  id_documento INTEGER,
  tipo_documento INTEGER,
  PRIMARY KEY(id_conta_alm_det)
) INHERITS (pxp.tbase)

WITH (oids = false);
/***********************************F-SCP-RCM-MISC-1-11/10/2018****************************************/

/***********************************I-SCP-RCM-MISC-1-31/10/2018****************************************/
CREATE TABLE misc.tconta_alm_tipo_mat (
  id_conta_alm_tipo_mat SERIAL,
  codigo VARCHAR(50),
  descripcion VARCHAR(200),
  PRIMARY KEY(id_conta_alm_tipo_mat)
) INHERITS (pxp.tbase)
WITH (oids = false);

ALTER TABLE misc.tconta_alm_det
  ADD COLUMN tipo_material VARCHAR(50);
/***********************************F-SCP-RCM-MISC-1-31/10/2018****************************************/

/***********************************I-SCP-RCM-MISC-1-09/11/2018****************************************/
ALTER TABLE misc.tconta_alm_det
  ADD COLUMN cantidad_mat NUMERIC;
/***********************************F-SCP-RCM-MISC-1-09/11/2018****************************************/