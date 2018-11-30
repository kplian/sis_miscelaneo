CREATE OR REPLACE FUNCTION "misc"."ft_conta_alm_sel"(
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$
/**************************************************************************
 SISTEMA:		Miscelaneo
 FUNCION: 		misc.ft_conta_alm_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'misc.tconta_alm'
 AUTOR: 		(rchumacero)
 FECHA:	        23-08-2018 20:25:16
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				23-08-2018 20:25:16								Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'misc.tconta_alm'
 #
 ***************************************************************************/

DECLARE

	v_consulta    		varchar;
	v_parametros  		record;
	v_nombre_funcion   	text;
	v_resp				varchar;

BEGIN

	v_nombre_funcion = 'misc.ft_conta_alm_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'MIS_CONALM_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		rchumacero
 	#FECHA:		23-08-2018 20:25:16
	***********************************/

	if(p_transaccion='MIS_CONALM_SEL')then

    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						conalm.id_conta_alm,
						conalm.id_periodo,
						conalm.id_int_comprobante,
						conalm.tipo,
						conalm.estado,
						conalm.estado_reg,
						conalm.id_usuario_ai,
						conalm.id_usuario_reg,
						conalm.usuario_ai,
						conalm.fecha_reg,
						conalm.fecha_mod,
						conalm.id_usuario_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
						per.periodo || '' / '' || ges.gestion as desc_periodo,
						conalm.glosa,
						conalm.id_proceso_wf,
						conalm.id_estado_wf,
						conalm.num_tramite,
						conalm.id_depto_conta,
						dep.codigo as desc_depto_conta,
						conalm.id_moneda,
						mon.codigo as desc_moneda,
						date_trunc(''month''::text, per.fecha_ini)::date - ''1900-01-01''::date AS id_reg,
						conalm.fecha_ini,
						conalm.fecha_fin,
						cb.id_proceso_wf as id_proceso_wf_cbte
						from misc.tconta_alm conalm
						inner join segu.tusuario usu1 on usu1.id_usuario = conalm.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = conalm.id_usuario_mod
						inner join param.tperiodo per on per.id_periodo = conalm.id_periodo
						inner join param.tgestion ges on ges.id_gestion = per.id_gestion
						inner join param.tdepto dep on dep.id_depto = conalm.id_depto_conta
						inner join param.tmoneda mon on mon.id_moneda = conalm.id_moneda
						left join conta.tint_comprobante cb on cb.id_int_comprobante = conalm.id_int_comprobante
				        where  ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;

		end;

	/*********************************
 	#TRANSACCION:  'MIS_CONALM_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		rchumacero
 	#FECHA:		23-08-2018 20:25:16
	***********************************/

	elsif(p_transaccion='MIS_CONALM_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_conta_alm)
					    from misc.tconta_alm conalm
					    inner join segu.tusuario usu1 on usu1.id_usuario = conalm.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = conalm.id_usuario_mod
						inner join param.tperiodo per on per.id_periodo = conalm.id_periodo
						inner join param.tgestion ges on ges.id_gestion = per.id_gestion
						inner join param.tdepto dep on dep.id_depto = conalm.id_depto_conta
						inner join param.tmoneda mon on mon.id_moneda = conalm.id_moneda
						left join conta.tint_comprobante cb on cb.id_int_comprobante = conalm.id_int_comprobante
					    where ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;

			--Devuelve la respuesta
			return v_consulta;

		end;

	/*********************************
 	#TRANSACCION:  'MIS_CONALMDET_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:			rchumacero
 	#FECHA:			03/09/2018
	***********************************/
	elsif(p_transaccion='MIS_CONALMDET_SEL')then

    	begin

    		--Verifica el estado de la contabilización
    		if exists(select 1 from misc.tconta_alm
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

    		end if;

    		--Sentencia de la consulta
			v_consulta:='select
						conalmd.id_usuario_reg,
						conalmd.fecha_reg,
						conalmd.estado_reg,
						conalmd.id_conta_alm,
						conalmd.id_centro_costo,
						conalmd.id_moneda,
						conalmd.id_cuenta_debe,
						conalmd.id_cuenta_haber,
						conalmd.fecha,
						conalmd.nro_ot,
						conalmd.codigo_material,
						conalmd.nombre_material,
						conalmd.precio_unitario,
						conalmd.total,
						conalmd.moneda,
						conalmd.centro_costo,
						conalmd.desc_cuenta_debe,
						conalmd.desc_cuenta_haber,
						conalmd.almacen,
						conalmd.centro_almacen
						from misc.tconta_alm_det conalmd
				        where conalmd.id_conta_alm = ' || v_parametros.id_conta_alm || ' and ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;

		end;

	/*********************************
 	#TRANSACCION:  'MIS_CONALMDET_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:			rchumacero
 	#FECHA:			03/06/2018
	***********************************/

	elsif(p_transaccion='MIS_CONALMDET_CONT')then

		begin

			--Verifica el estado de la contabilización
    		if exists(select 1 from misc.tconta_alm
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

    		end if;


			--Sentencia de la consulta de conteo de registros
			v_consulta:='select
						count(1), coalesce(sum(conalmd.total),0)::numeric as total_monto
					    from misc.tconta_alm_det conalmd
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
$BODY$
LANGUAGE 'plpgsql' VOLATILE
COST 100;
ALTER FUNCTION "misc"."ft_conta_alm_sel"(integer, integer, character varying, character varying) OWNER TO postgres;