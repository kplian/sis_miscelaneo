CREATE OR REPLACE FUNCTION "misc"."ft_depto_regional_sigema_sel"(
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$
/**************************************************************************
 SISTEMA:		Miscelaneo
 FUNCION: 		misc.ft_depto_regional_sigema_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'misc.tdepto_regional_sigema'
 AUTOR: 		 (rchumacero)
 FECHA:	        31-08-2018 14:27:40
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				31-08-2018 14:27:40								Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'misc.tdepto_regional_sigema'
 #
 ***************************************************************************/

DECLARE

	v_consulta    		varchar;
	v_parametros  		record;
	v_nombre_funcion   	text;
	v_resp				varchar;

BEGIN

	v_nombre_funcion = 'misc.ft_depto_regional_sigema_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'MIS_DEPREG_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		rchumacero
 	#FECHA:		31-08-2018 14:27:40
	***********************************/

	if(p_transaccion='MIS_DEPREG_SEL')then

    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						depreg.id_depto_regional_sigema,
						depreg.estado_reg,
						depreg.codigo_regional_sigema,
						depreg.id_depto,
						depreg.fecha_reg,
						depreg.usuario_ai,
						depreg.id_usuario_reg,
						depreg.id_usuario_ai,
						depreg.id_usuario_mod,
						depreg.fecha_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
						dep.codigo || '' - '' || dep.nombre as desc_depto
						from misc.tdepto_regional_sigema depreg
						inner join segu.tusuario usu1 on usu1.id_usuario = depreg.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = depreg.id_usuario_mod
						inner join param.tdepto dep on dep.id_depto = depreg.id_depto
				        where  ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;

		end;

	/*********************************
 	#TRANSACCION:  'MIS_DEPREG_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		rchumacero
 	#FECHA:		31-08-2018 14:27:40
	***********************************/

	elsif(p_transaccion='MIS_DEPREG_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_depto_regional_sigema)
					    from misc.tdepto_regional_sigema depreg
					    inner join segu.tusuario usu1 on usu1.id_usuario = depreg.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = depreg.id_usuario_mod
						inner join param.tdepto dep on dep.id_depto = depreg.id_depto
					    where ';

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
ALTER FUNCTION "misc"."ft_depto_regional_sigema_sel"(integer, integer, character varying, character varying) OWNER TO postgres;
