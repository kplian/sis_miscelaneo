CREATE OR REPLACE FUNCTION misc.ft_conta_alm_det_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Miscelaneo
 FUNCION: 		misc.ft_conta_alm_det_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'misc.tconta_alm_det'
 AUTOR: 		 (rchumacero)
 FECHA:	        11-10-2018 13:47:00
 COMENTARIOS:
***************************************************************************
 ISSUE  SIS       EMPRESA       FECHA       AUTOR       DESCRIPCION
 #4     MISC       ETR          11/10/2018  RCM         Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'misc.tconta_alm_det'
 #2     MISC       ETR          03/01/2020  RCM         Problema al generar cbte. No encuentra movimientos aunque si hay en el detalle
***************************************************************************/


DECLARE

	v_consulta    		varchar;
	v_parametros  		record;
	v_nombre_funcion   	text;
	v_resp				varchar;
	v_id_gestion		integer;

BEGIN

	v_nombre_funcion = 'misc.ft_conta_alm_det_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'MIS_CALMD_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		rchumacero
 	#FECHA:		11-10-2018 13:47:00
	***********************************/

	if(p_transaccion='MIS_CALMD_SEL')then

    	begin

    		--Verifica el estado de la contabilización
    		if exists(select 1 from misc.tconta_alm
    				where id_conta_alm = v_parametros.id_conta_alm
    				and estado = 'borrador') then

    			--Obtiene la gestión del registro de la contabilización
    			select per.id_gestion
    			into v_id_gestion
    			from misc.tconta_alm ca
    			inner join param.tperiodo per
    			on per.id_periodo = ca.id_periodo
    			where id_conta_alm = v_parametros.id_conta_alm; --#2

    			--Elimina los datos
    			delete from misc.tconta_alm_det where id_conta_alm = v_parametros.id_conta_alm;

    			--Carga nuevamente los datos
    			insert into misc.tconta_alm_det
				(
				  id_usuario_reg,
				  fecha_reg,
				  estado_reg,
				  id_conta_alm,
				  id_centro_costo,
				  id_moneda,
				  id_cuenta_debe,
				  id_cuenta_haber,
				  fecha,
				  nro_ot,
				  codigo_material,
				  nombre_material,
				  precio_unitario,
				  total,
				  moneda,
				  centro_costo,
				  desc_cuenta_debe,
				  desc_cuenta_haber,
				  almacen,
				  centro_almacen,
				  codigo_centro_costo,
				  cuenta_contable_debe,
				  cuenta_contable_haber,
				  id_documento,
				  tipo_documento,
				  tipo_material,
				  cantidad_mat
				)
				select
				p_id_usuario,
				now(),
				'activo',
				v_parametros.id_conta_alm,
				(select cc.id_centro_costo
				from param.ttipo_cc tcc
				inner join param.tcentro_costo cc
				on cc.id_tipo_cc = tcc.id_tipo_cc
				and cc.id_gestion = v_id_gestion
				where tcc.codigo = conalmd.codigo_centro_costo),
				(select id_moneda from param.tmoneda
				where codigo = conalmd.moneda),
				(select id_cuenta from conta.tcuenta cued
				where cued.nro_cuenta = conalmd.cuenta_debe
				and cued.id_gestion = v_id_gestion),
				(select id_cuenta from conta.tcuenta cued
				where cued.nro_cuenta = conalmd.cuenta_haber
				and cued.id_gestion = v_id_gestion),
			    conalmd.fecha,
			    conalmd.nro_ot,
			    conalmd.codigo_material,
			    convert_from(conalmd.nombre_material::bytea, 'LATIN1')::varchar as nombre_material,
			    conalmd.precio_unitario,
			    conalmd.total,
			    conalmd.moneda,
			    convert_from(conalmd.centro_costo::bytea, 'LATIN1')::varchar as centro_costo,
			    conalmd.desc_cuenta_debe,
			    conalmd.desc_cuenta_haber,
			    conalmd.almacen,
			    conalmd.centro_almacen,
			    conalmd.codigo_centro_costo,
			    conalmd.cuenta_contable_debe,
			    conalmd.cuenta_contable_haber,
			    conalmd.id_documento,
			    conalmd.tipo_documento,
			    conalmd.tipo_material,
			    conalmd.cantidad
				from misc.vconta_almacen_det_grid conalmd
				inner join misc.tdepto_regional_sigema rs
				on rs.codigo_regional_sigema = conalmd.centro_almacen
		        where rs.id_depto = v_parametros.id_depto_conta
		        and conalmd.id_detalle between date_trunc('day'::text, v_parametros.fecha_ini::timestamp with time zone)::date - '1900-01-01'::date and date_trunc('day'::text, v_parametros.fecha_fin::timestamp with time zone)::date - '1900-01-01'::date
		        and not exists (select *
			                   from misc.tconta_alm_det cad
			                   where cad.id_documento = conalmd.id_documento
			                   and cad.tipo_documento = conalmd.tipo_documento);

    		end if;

    		--Sentencia de la consulta
			v_consulta:='select
						conalmd.id_conta_alm_det,
						conalmd.moneda,
						conalmd.centro_almacen,
						conalmd.nombre_material,
						conalmd.id_moneda,
						conalmd.id_centro_costo,
						conalmd.id_cuenta_debe,
						conalmd.precio_unitario,
						conalmd.nro_ot,
						conalmd.centro_costo,
						conalmd.estado_reg,
						conalmd.id_cuenta_haber,
						conalmd.total,
						conalmd.almacen,
						conalmd.desc_cuenta_haber,
						conalmd.codigo_material,
						conalmd.desc_cuenta_debe,
						conalmd.fecha,
						conalmd.id_conta_alm,
						conalmd.id_usuario_ai,
						conalmd.id_usuario_reg,
						conalmd.fecha_reg,
						conalmd.usuario_ai,
						conalmd.id_usuario_mod,
						conalmd.fecha_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
						conalmd.codigo_centro_costo,
						conalmd.cuenta_contable_debe,
						conalmd.cuenta_contable_haber,
						conalmd.id_documento,
						conalmd.tipo_documento,
						conalmd.tipo_material,
						conalmd.cantidad_mat
						from misc.tconta_alm_det conalmd
						inner join segu.tusuario usu1 on usu1.id_usuario = conalmd.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = conalmd.id_usuario_mod
				        where conalmd.id_conta_alm = ' || v_parametros.id_conta_alm || ' and ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;

		end;

	/*********************************
 	#TRANSACCION:  'MIS_CALMD_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		rchumacero
 	#FECHA:		11-10-2018 13:47:00
	***********************************/

	elsif(p_transaccion='MIS_CALMD_CONT')then

		begin

			--Verifica el estado de la contabilización
    		/*if exists(select 1 from misc.tconta_alm
    				where id_conta_alm = v_parametros.id_conta_alm
    				and estado = 'borrador') then

    			--Elimina los datos
    			delete from misc.tconta_alm_det where id_conta_alm = v_parametros.id_conta_alm;

    			--Carga nuevamente los datos
    			insert into misc.tconta_alm_det
				(
				  id_usuario_reg,
				  fecha_reg,
				  estado_reg,
				  id_conta_alm,
				  id_centro_costo,
				  id_moneda,
				  id_cuenta_debe,
				  id_cuenta_haber,
				  fecha,
				  nro_ot,
				  codigo_material,
				  nombre_material,
				  precio_unitario,
				  total,
				  moneda,
				  centro_costo,
				  desc_cuenta_debe,
				  desc_cuenta_haber,
				  almacen,
				  centro_almacen
				)
				select
				p_id_usuario,
				now(),
				'activo',
				v_parametros.id_conta_alm,
				null,
				null,
				null,
				null,
			    fecha,
			    nro_ot,
			    codigo_material,
			    nombre_material,
			    precio_unitario,
			    total,
			    moneda,
			    convert_from(centro_costo::bytea, 'LATIN1')::varchar as centro_costo,
			    desc_cuenta_debe,
			    desc_cuenta_haber,
			    almacen,
			    centro_almacen
				from misc.vconta_almacen_det_grid conalmd
				inner join misc.tdepto_regional_sigema rs
				on rs.codigo_regional_sigema = conalmd.centro_almacen
		        where rs.id_depto = v_parametros.id_depto_conta
		        and conalmd.id_detalle between date_trunc('day'::text, v_parametros.fecha_ini::timestamp with time zone)::date - '1900-01-01'::date and date_trunc('day'::text, v_parametros.fecha_fin::timestamp with time zone)::date - '1900-01-01'::date;

    		end if;*/


			--Sentencia de la consulta de conteo de registros
			v_consulta:='select
						count(1), coalesce(sum(conalmd.total),0)::numeric as total_monto
					    from misc.tconta_alm_det conalmd
					    inner join segu.tusuario usu1 on usu1.id_usuario = conalmd.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = conalmd.id_usuario_mod
					    where conalmd.id_conta_alm = ' || v_parametros.id_conta_alm || ' and ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;

			--Devuelve la respuesta
			return v_consulta;

		end;

	else

		raise exception 'Transaccion inexistente';

	end if;

EXCEPTION

	WHEN OTHERS THEN
			v_resp='';
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje',SQLERRM);
			v_resp = pxp.f_agrega_clave(v_resp,'codigo_error',SQLSTATE);
			v_resp = pxp.f_agrega_clave(v_resp,'procedimientos',v_nombre_funcion);
			raise exception '%',v_resp;
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;

ALTER FUNCTION misc.ft_conta_alm_det_sel (p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
  OWNER TO postgres;