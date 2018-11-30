CREATE OR REPLACE FUNCTION "misc"."ft_conta_alm_tipo_mat_sel"(	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$
/**************************************************************************
 SISTEMA:		Miscelaneo
 FUNCION: 		misc.ft_conta_alm_tipo_mat_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'misc.tconta_alm_tipo_mat'
 AUTOR: 		 (rchumacero)
 FECHA:	        31-10-2018 14:28:02
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				31-10-2018 14:28:02								Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'misc.tconta_alm_tipo_mat'	
 #
 ***************************************************************************/

DECLARE

	v_consulta    		varchar;
	v_parametros  		record;
	v_nombre_funcion   	text;
	v_resp				varchar;
			    
BEGIN

	v_nombre_funcion = 'misc.ft_conta_alm_tipo_mat_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'MIS_CATMAT_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		rchumacero	
 	#FECHA:		31-10-2018 14:28:02
	***********************************/

	if(p_transaccion='MIS_CATMAT_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						catmat.id_conta_alm_tipo_mat,
						catmat.descripcion,
						catmat.estado_reg,
						catmat.codigo,
						catmat.id_usuario_ai,
						catmat.id_usuario_reg,
						catmat.fecha_reg,
						catmat.usuario_ai,
						catmat.id_usuario_mod,
						catmat.fecha_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod	
						from misc.tconta_alm_tipo_mat catmat
						inner join segu.tusuario usu1 on usu1.id_usuario = catmat.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = catmat.id_usuario_mod
				        where  ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'MIS_CATMAT_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		rchumacero	
 	#FECHA:		31-10-2018 14:28:02
	***********************************/

	elsif(p_transaccion='MIS_CATMAT_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_conta_alm_tipo_mat)
					    from misc.tconta_alm_tipo_mat catmat
					    inner join segu.tusuario usu1 on usu1.id_usuario = catmat.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = catmat.id_usuario_mod
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
ALTER FUNCTION "misc"."ft_conta_alm_tipo_mat_sel"(integer, integer, character varying, character varying) OWNER TO postgres;
