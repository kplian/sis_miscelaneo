CREATE OR REPLACE FUNCTION "misc"."ft_depto_regional_sigema_ime" (	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$

/**************************************************************************
 SISTEMA:		Miscelaneo
 FUNCION: 		misc.ft_depto_regional_sigema_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'misc.tdepto_regional_sigema'
 AUTOR: 		 (rchumacero)
 FECHA:	        31-08-2018 14:27:40
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				31-08-2018 14:27:40								Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'misc.tdepto_regional_sigema'	
 #
 ***************************************************************************/

DECLARE

	v_nro_requerimiento    	integer;
	v_parametros           	record;
	v_id_requerimiento     	integer;
	v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
	v_id_depto_regional_sigema	integer;
			    
BEGIN

    v_nombre_funcion = 'misc.ft_depto_regional_sigema_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'MIS_DEPREG_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		rchumacero	
 	#FECHA:		31-08-2018 14:27:40
	***********************************/

	if(p_transaccion='MIS_DEPREG_INS')then
					
        begin
        	--Sentencia de la insercion
        	insert into misc.tdepto_regional_sigema(
			estado_reg,
			codigo_regional_sigema,
			id_depto,
			fecha_reg,
			usuario_ai,
			id_usuario_reg,
			id_usuario_ai,
			id_usuario_mod,
			fecha_mod
          	) values(
			'activo',
			v_parametros.codigo_regional_sigema,
			v_parametros.id_depto,
			now(),
			v_parametros._nombre_usuario_ai,
			p_id_usuario,
			v_parametros._id_usuario_ai,
			null,
			null
							
			
			
			)RETURNING id_depto_regional_sigema into v_id_depto_regional_sigema;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Depto. - Regional SIGEMA almacenado(a) con exito (id_depto_regional_sigema'||v_id_depto_regional_sigema||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_depto_regional_sigema',v_id_depto_regional_sigema::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'MIS_DEPREG_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		rchumacero	
 	#FECHA:		31-08-2018 14:27:40
	***********************************/

	elsif(p_transaccion='MIS_DEPREG_MOD')then

		begin
			--Sentencia de la modificacion
			update misc.tdepto_regional_sigema set
			codigo_regional_sigema = v_parametros.codigo_regional_sigema,
			id_depto = v_parametros.id_depto,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now(),
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_depto_regional_sigema=v_parametros.id_depto_regional_sigema;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Depto. - Regional SIGEMA modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_depto_regional_sigema',v_parametros.id_depto_regional_sigema::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'MIS_DEPREG_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		rchumacero	
 	#FECHA:		31-08-2018 14:27:40
	***********************************/

	elsif(p_transaccion='MIS_DEPREG_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from misc.tdepto_regional_sigema
            where id_depto_regional_sigema=v_parametros.id_depto_regional_sigema;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Depto. - Regional SIGEMA eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_depto_regional_sigema',v_parametros.id_depto_regional_sigema::varchar);
              
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
ALTER FUNCTION "misc"."ft_depto_regional_sigema_ime"(integer, integer, character varying, character varying) OWNER TO postgres;
