CREATE OR REPLACE FUNCTION "misc"."ft_conta_alm_tipo_mat_ime" (	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$

/**************************************************************************
 SISTEMA:		Miscelaneo
 FUNCION: 		misc.ft_conta_alm_tipo_mat_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'misc.tconta_alm_tipo_mat'
 AUTOR: 		 (rchumacero)
 FECHA:	        31-10-2018 14:28:02
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				31-10-2018 14:28:02								Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'misc.tconta_alm_tipo_mat'	
 #
 ***************************************************************************/

DECLARE

	v_nro_requerimiento    	integer;
	v_parametros           	record;
	v_id_requerimiento     	integer;
	v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
	v_id_conta_alm_tipo_mat	integer;
			    
BEGIN

    v_nombre_funcion = 'misc.ft_conta_alm_tipo_mat_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'MIS_CATMAT_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		rchumacero	
 	#FECHA:		31-10-2018 14:28:02
	***********************************/

	if(p_transaccion='MIS_CATMAT_INS')then
					
        begin
        	--Sentencia de la insercion
        	insert into misc.tconta_alm_tipo_mat(
			descripcion,
			estado_reg,
			codigo,
			id_usuario_ai,
			id_usuario_reg,
			fecha_reg,
			usuario_ai,
			id_usuario_mod,
			fecha_mod
          	) values(
			v_parametros.descripcion,
			'activo',
			v_parametros.codigo,
			v_parametros._id_usuario_ai,
			p_id_usuario,
			now(),
			v_parametros._nombre_usuario_ai,
			null,
			null
							
			
			
			)RETURNING id_conta_alm_tipo_mat into v_id_conta_alm_tipo_mat;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Tipo Material almacenado(a) con exito (id_conta_alm_tipo_mat'||v_id_conta_alm_tipo_mat||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_conta_alm_tipo_mat',v_id_conta_alm_tipo_mat::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'MIS_CATMAT_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		rchumacero	
 	#FECHA:		31-10-2018 14:28:02
	***********************************/

	elsif(p_transaccion='MIS_CATMAT_MOD')then

		begin
			--Sentencia de la modificacion
			update misc.tconta_alm_tipo_mat set
			descripcion = v_parametros.descripcion,
			codigo = v_parametros.codigo,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now(),
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_conta_alm_tipo_mat=v_parametros.id_conta_alm_tipo_mat;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Tipo Material modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_conta_alm_tipo_mat',v_parametros.id_conta_alm_tipo_mat::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'MIS_CATMAT_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		rchumacero	
 	#FECHA:		31-10-2018 14:28:02
	***********************************/

	elsif(p_transaccion='MIS_CATMAT_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from misc.tconta_alm_tipo_mat
            where id_conta_alm_tipo_mat=v_parametros.id_conta_alm_tipo_mat;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Tipo Material eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_conta_alm_tipo_mat',v_parametros.id_conta_alm_tipo_mat::varchar);
              
            --Devuelve la respuesta
            return v_resp;

		end;
         
	else
     
    	raise exception 'Transaccion inexistente: %',p_transaccion;

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
ALTER FUNCTION "misc"."ft_conta_alm_tipo_mat_ime"(integer, integer, character varying, character varying) OWNER TO postgres;
