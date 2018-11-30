CREATE OR REPLACE FUNCTION "misc"."ft_conta_alm_det_ime" (	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$

/**************************************************************************
 SISTEMA:		Miscelaneo
 FUNCION: 		misc.ft_conta_alm_det_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'misc.tconta_alm_det'
 AUTOR: 		 (rchumacero)
 FECHA:	        11-10-2018 13:47:00
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				11-10-2018 13:47:00								Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'misc.tconta_alm_det'	
 #
 ***************************************************************************/

DECLARE

	v_nro_requerimiento    	integer;
	v_parametros           	record;
	v_id_requerimiento     	integer;
	v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
	v_id_conta_alm_det	integer;
			    
BEGIN

    v_nombre_funcion = 'misc.ft_conta_alm_det_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'MIS_CALMD_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		rchumacero	
 	#FECHA:		11-10-2018 13:47:00
	***********************************/

	if(p_transaccion='MIS_CALMD_INS')then
					
        begin
        	--Sentencia de la insercion
        	insert into misc.tconta_alm_det(
			moneda,
			centro_almacen,
			nombre_material,
			id_moneda,
			id_centro_costo,
			id_cuenta_debe,
			precio_unitario,
			nro_ot,
			centro_costo,
			estado_reg,
			id_cuenta_haber,
			total,
			almacen,
			desc_cuenta_haber,
			codigo_material,
			desc_cuenta_debe,
			fecha,
			id_conta_alm,
			id_usuario_ai,
			id_usuario_reg,
			fecha_reg,
			usuario_ai,
			id_usuario_mod,
			fecha_mod
          	) values(
			v_parametros.moneda,
			v_parametros.centro_almacen,
			v_parametros.nombre_material,
			v_parametros.id_moneda,
			v_parametros.id_centro_costo,
			v_parametros.id_cuenta_debe,
			v_parametros.precio_unitario,
			v_parametros.nro_ot,
			v_parametros.centro_costo,
			'activo',
			v_parametros.id_cuenta_haber,
			v_parametros.total,
			v_parametros.almacen,
			v_parametros.desc_cuenta_haber,
			v_parametros.codigo_material,
			v_parametros.desc_cuenta_debe,
			v_parametros.fecha,
			v_parametros.id_conta_alm,
			v_parametros._id_usuario_ai,
			p_id_usuario,
			now(),
			v_parametros._nombre_usuario_ai,
			null,
			null
							
			
			
			)RETURNING id_conta_alm_det into v_id_conta_alm_det;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Detalle Contabilización almacenado(a) con exito (id_conta_alm_det'||v_id_conta_alm_det||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_conta_alm_det',v_id_conta_alm_det::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'MIS_CALMD_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		rchumacero	
 	#FECHA:		11-10-2018 13:47:00
	***********************************/

	elsif(p_transaccion='MIS_CALMD_MOD')then

		begin
			--Sentencia de la modificacion
			update misc.tconta_alm_det set
			moneda = v_parametros.moneda,
			centro_almacen = v_parametros.centro_almacen,
			nombre_material = v_parametros.nombre_material,
			id_moneda = v_parametros.id_moneda,
			id_centro_costo = v_parametros.id_centro_costo,
			id_cuenta_debe = v_parametros.id_cuenta_debe,
			precio_unitario = v_parametros.precio_unitario,
			nro_ot = v_parametros.nro_ot,
			centro_costo = v_parametros.centro_costo,
			id_cuenta_haber = v_parametros.id_cuenta_haber,
			total = v_parametros.total,
			almacen = v_parametros.almacen,
			desc_cuenta_haber = v_parametros.desc_cuenta_haber,
			codigo_material = v_parametros.codigo_material,
			desc_cuenta_debe = v_parametros.desc_cuenta_debe,
			fecha = v_parametros.fecha,
			id_conta_alm = v_parametros.id_conta_alm,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now(),
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_conta_alm_det=v_parametros.id_conta_alm_det;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Detalle Contabilización modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_conta_alm_det',v_parametros.id_conta_alm_det::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'MIS_CALMD_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		rchumacero	
 	#FECHA:		11-10-2018 13:47:00
	***********************************/

	elsif(p_transaccion='MIS_CALMD_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from misc.tconta_alm_det
            where id_conta_alm_det=v_parametros.id_conta_alm_det;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Detalle Contabilización eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_conta_alm_det',v_parametros.id_conta_alm_det::varchar);
              
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
ALTER FUNCTION "misc"."ft_conta_alm_det_ime"(integer, integer, character varying, character varying) OWNER TO postgres;
