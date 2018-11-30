	CREATE OR REPLACE FUNCTION "misc"."ft_conta_alm_ime" (
					p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
	RETURNS character varying AS
	$BODY$

	/**************************************************************************
	 SISTEMA:		Miscelaneo
	 FUNCION: 		misc.ft_conta_alm_ime
	 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'misc.tconta_alm'
	 AUTOR: 		 (rchumacero)
	 FECHA:	        23-08-2018 20:25:16
	 COMENTARIOS:
	***************************************************************************
	 HISTORIAL DE MODIFICACIONES:
	#ISSUE				FECHA				AUTOR				DESCRIPCION
	 #0				23-08-2018 20:25:16								Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'misc.tconta_alm'
	 #
	 ***************************************************************************/

	DECLARE

		v_nro_requerimiento    	integer;
		v_parametros           	record;
		v_id_requerimiento     	integer;
		v_resp		            varchar;
		v_nombre_funcion        text;
		v_mensaje_error         text;
		v_id_conta_alm			integer;
		v_codigo_tipo_proceso 	varchar;
		v_id_proceso_macro		integer;
		v_codigo_proceso_macro	varchar;
		v_num_tramite           varchar;
	    v_id_proceso_wf         integer;
	    v_id_estado_wf          integer;
	    v_codigo_estado         varchar;
	    v_id_tipo_estado		integer;
	    v_codigo_estado_siguiente varchar;
	    v_id_gestion			integer;
	    v_fecha_fin				date;
	    v_id_depto 				integer;
	    v_obs 					varchar;
	    v_acceso_directo        varchar;
	    v_clase             	varchar;
	    v_parametros_ad         varchar;
	    v_tipo_noti           	varchar;
	    v_titulo              	varchar;
	    v_id_estado_actual		integer;
	    v_codigo_tipo_pro 		varchar;
	    v_registros_proc		record;
	    v_id_funcionario		integer;
	    v_id_usuario_reg 		integer;
	    v_id_estado_wf_ant		integer;
	    v_id_periodo 			integer;

	BEGIN

	    v_nombre_funcion = 'misc.ft_conta_alm_ime';
	    v_parametros = pxp.f_get_record(p_tabla);
	    v_codigo_proceso_macro = 'ALMCON';

		/*********************************
	 	#TRANSACCION:  'MIS_CONALM_INS'
	 	#DESCRIPCION:	Insercion de registros
	 	#AUTOR:		rchumacero
	 	#FECHA:		23-08-2018 20:25:16
		***********************************/

		if(p_transaccion='MIS_CONALM_INS')then

	        begin

	        	--Verifica que las fechas sean en el mismo mes
	        	/*if date_trunc('month',v_parametros.fecha_ini) != date_trunc('month',v_parametros.fecha_fin) then
	        		raise exception 'Las fechas deben estar en el mismo mes';
	        	end if;*/

	        	--Verifica que no se repitan fechas
	        	/*if exists(select 1 from misc.tconta_alm calm
	        			where calm.id_depto_conta = v_parametros.id_depto_conta
	        			and calm.fecha_fin >= v_parametros.fecha_ini) then
	        		raise exception 'Ya se generó contabilización posterior a la fecha de inicio';
	        	end if;*/

	        	--Obtención del id del periodo
			    select id_periodo
			    into v_id_periodo
			    from param.tperiodo
			    where date_trunc('month',fecha_ini) = date_trunc('month',v_parametros.fecha_fin);

			    if v_id_periodo is null then
			    	raise exception 'Periodo inexistente';
			    end if;

	        	--Obtener id del proceso macro
	            select
	            pm.id_proceso_macro
	            into
	            v_id_proceso_macro
	            from wf.tproceso_macro pm
	            where pm.codigo = v_codigo_proceso_macro;

	            if v_id_proceso_macro is null then
	                raise exception 'El proceso macro de codigo % no esta configurado en el sistema WF',v_codigo_proceso_macro;
	            end if;

	            --Obtener el codigo del tipo_proceso
	            select tp.codigo
	            into v_codigo_tipo_proceso
	            from wf.ttipo_proceso tp
	            where tp.id_proceso_macro = v_id_proceso_macro
	            and tp.estado_reg = 'activo'
	            and tp.inicio = 'si';

	            if v_codigo_tipo_proceso is NULL THEN
	                raise exception 'No existe un proceso inicial para el proceso macro indicado % (Revise la configuración)',v_codigo_proceso_macro;
	            end if;

	            select
	            per.id_gestion, per.fecha_fin
	            into
	            v_id_gestion, v_fecha_fin
	            from param.tperiodo per
	            where per.id_periodo = v_id_periodo
	            limit 1 offset 0;

	            ----------------------
	            --Inicio tramite en WF
			    ----------------------
			    SELECT
				    ps_num_tramite ,
				    ps_id_proceso_wf,
				    ps_id_estado_wf,
				    ps_codigo_estado
			    into
				    v_num_tramite,
				    v_id_proceso_wf,
				    v_id_estado_wf,
				    v_codigo_estado
			    FROM wf.f_inicia_tramite(
				    p_id_usuario,
				    v_parametros._id_usuario_ai,
				    v_parametros._nombre_usuario_ai,
				    v_id_gestion,
				    v_codigo_tipo_proceso,
				    NULL,
				    v_parametros.id_depto_conta,
				    'Contabilización de almacenes de : '''||v_parametros.tipo||''' correspondiente a '||to_char(v_fecha_fin,'mm/yyyy'),
				    'S/N'
			    );

	        	--Sentencia de la insercion
	        	insert into misc.tconta_alm(
				id_periodo,
				tipo,
				estado,
				estado_reg,
				id_usuario_ai,
				id_usuario_reg,
				usuario_ai,
				fecha_reg,
				fecha_mod,
				id_usuario_mod,
				glosa,
				id_proceso_wf,
				id_estado_wf,
				num_tramite,
				id_depto_conta,
				id_moneda,
				fecha_ini,
				fecha_fin
	          	) values(
				v_id_periodo,
				v_parametros.tipo,
				v_codigo_estado,
				'activo',
				v_parametros._id_usuario_ai,
				p_id_usuario,
				v_parametros._nombre_usuario_ai,
				now(),
				null,
				null,
				v_parametros.glosa,
				v_id_proceso_wf,
				v_id_estado_wf,
				v_num_tramite,
				v_parametros.id_depto_conta,
				v_parametros.id_moneda,
				v_parametros.fecha_ini,
				v_parametros.fecha_fin
				)RETURNING id_conta_alm into v_id_conta_alm;

				--Definicion de la respuesta
				v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Contabilizar Movimientos Almacén almacenado(a) con exito (id_conta_alm'||v_id_conta_alm||')');
	            v_resp = pxp.f_agrega_clave(v_resp,'id_conta_alm',v_id_conta_alm::varchar);

	            --Devuelve la respuesta
	            return v_resp;

			end;

		/*********************************
	 	#TRANSACCION:  'MIS_CONALM_MOD'
	 	#DESCRIPCION:	Modificacion de registros
	 	#AUTOR:		rchumacero
	 	#FECHA:		23-08-2018 20:25:16
		***********************************/

		elsif(p_transaccion='MIS_CONALM_MOD')then

			begin

				--Verifica que las fechas sean en el mismo mes
	        	/*if date_trunc('month',v_parametros.fecha_ini) != date_trunc('month',v_parametros.fecha_fin) then
	        		raise exception 'Las fechas deben estar en el mismo mes';
	        	end if;*/

	        	--Verifica que no se repitan fechas
	        	/*if exists(select 1 from misc.tconta_alm calm
	        			where calm.id_depto_conta = v_parametros.id_depto_conta
	        			and calm.fecha_fin >= v_parametros.fecha_ini
	        			and calm.id_conta_alm <> v_parametros.id_conta_alm) then
	        		raise exception 'Ya se generó contabilización posterior a la fecha de inicio';
	        	end if;*/

	        	--Obtención del id del periodo
			    select id_periodo
			    into v_id_periodo
			    from param.tperiodo
			    where date_trunc('month',fecha_ini) = date_trunc('month',v_parametros.fecha_fin);

			    if v_id_periodo is null then
			    	raise exception 'Periodo inexistente';
			    end if;

				--Sentencia de la modificacion
				update misc.tconta_alm set
				id_periodo = v_id_periodo,
				tipo = v_parametros.tipo,
				fecha_mod = now(),
				id_usuario_mod = p_id_usuario,
				id_usuario_ai = v_parametros._id_usuario_ai,
				usuario_ai = v_parametros._nombre_usuario_ai,
				glosa = v_parametros.glosa,
				id_depto_conta = v_parametros.id_depto_conta,
				id_moneda = v_parametros.id_moneda,
				fecha_ini = v_parametros.fecha_ini,
				fecha_fin = v_parametros.fecha_fin
				where id_conta_alm=v_parametros.id_conta_alm;

				--Definicion de la respuesta
	            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Contabilizar Movimientos Almacén modificado(a)');
	            v_resp = pxp.f_agrega_clave(v_resp,'id_conta_alm',v_parametros.id_conta_alm::varchar);

	            --Devuelve la respuesta
	            return v_resp;

			end;

		/*********************************
	 	#TRANSACCION:  'MIS_CONALM_ELI'
	 	#DESCRIPCION:	Eliminacion de registros
	 	#AUTOR:		rchumacero
	 	#FECHA:		23-08-2018 20:25:16
		***********************************/

		elsif(p_transaccion='MIS_CONALM_ELI')then

			begin

				--Verifica que esté en Borrador
				if not exists(select 1 from misc.tconta_alm
							where id_conta_alm = v_parametros.id_conta_alm
							and estado = 'borrador') then
					raise exception 'No es posible borrar el registro por no estar en estado Borrador';
				end if;

				--Sentencia de la eliminacion
				delete from misc.tconta_alm_det
				where id_conta_alm = v_parametros.id_conta_alm;

				delete from misc.tconta_alm
	            where id_conta_alm=v_parametros.id_conta_alm;

	            --Definicion de la respuesta
	            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Contabilizar Movimientos Almacén eliminado(a)');
	            v_resp = pxp.f_agrega_clave(v_resp,'id_conta_alm',v_parametros.id_conta_alm::varchar);

	            --Devuelve la respuesta
	            return v_resp;

			end;

		/*********************************
		#TRANSACCION:  	'MIS_SIGEST_INS'
		#DESCRIPCION:  	Controla el cambio al siguiente estado
		#AUTOR:   		RCM
		#FECHA:   		27/08/2018
		***********************************/

	  	elseif(p_transaccion='MIS_SIGEST_INS')then

	        begin

		        /*   PARAMETROS

		        $this->setParametro('id_proceso_wf_act','id_proceso_wf_act','int4');
		        $this->setParametro('id_tipo_estado','id_tipo_estado','int4');
		        $this->setParametro('id_funcionario_wf','id_funcionario_wf','int4');
		        $this->setParametro('id_depto_wf','id_depto_wf','int4');
		        $this->setParametro('obs','obs','text');
		        $this->setParametro('json_procesos','json_procesos','text');
		        */

		        --Obtenemos datos basicos
				select
				c.id_proceso_wf,
				c.id_estado_wf,
				c.estado
				into
				v_id_proceso_wf,
				v_id_estado_wf,
				v_codigo_estado
				from misc.tconta_alm c
				where c.id_conta_alm = v_parametros.id_conta_alm;

		        --Recupera datos del estado
				select
				ew.id_tipo_estado,
				te.codigo
				into
				v_id_tipo_estado,
				v_codigo_estado
				from wf.testado_wf ew
				inner join wf.ttipo_estado te on te.id_tipo_estado = ew.id_tipo_estado
				where ew.id_estado_wf = v_parametros.id_estado_wf_act;


				-- obtener datos tipo estado
				select
				te.codigo
				into
				v_codigo_estado_siguiente
				from wf.ttipo_estado te
				where te.id_tipo_estado = v_parametros.id_tipo_estado;

				if pxp.f_existe_parametro(p_tabla,'id_depto_wf') then
					v_id_depto = v_parametros.id_depto_wf;
				end if;

				if pxp.f_existe_parametro(p_tabla,'obs') then
					v_obs=v_parametros.obs;
				else
					v_obs='---';
				end if;

				--Acciones por estado siguiente que podrian realizarse
				if v_codigo_estado_siguiente in ('') then

				end if;

				---------------------------------------
				-- REGISTRA EL SIGUIENTE ESTADO DEL WF
				---------------------------------------
				--Configurar acceso directo para la alarma
				v_acceso_directo = '';
				v_clase = '';
				v_parametros_ad = '';
				v_tipo_noti = 'notificacion';
				v_titulo  = 'Visto Bueno';

				if v_codigo_estado_siguiente not in('borrador','finalizado','anulado') then

					v_acceso_directo = '../../../sis_miscelano/vista/conta_alm/ContaAlm.php';
					v_clase = 'ContaAlm';
					v_parametros_ad = '{filtro_directo:{campo:"cd.id_proceso_wf",valor:"'||v_id_proceso_wf::varchar||'"}}';
					v_tipo_noti = 'notificacion';
					v_titulo  = 'Visto Bueno';

				end if;

				v_id_estado_actual = wf.f_registra_estado_wf
									(
										v_parametros.id_tipo_estado,
										v_parametros.id_funcionario_wf,
										v_parametros.id_estado_wf_act,
										v_id_proceso_wf,
										p_id_usuario,
										v_parametros._id_usuario_ai,
										v_parametros._nombre_usuario_ai,
										v_id_depto,--depto del estado anterior
										v_obs,
										v_acceso_directo,
										v_clase,
										v_parametros_ad,
										v_tipo_noti,
										v_titulo
									);

				--------------------------------------
				-- Registra los procesos disparados
				--------------------------------------
				for v_registros_proc in ( select * from json_populate_recordset(null::wf.proceso_disparado_wf, v_parametros.json_procesos::json)) loop

					--Obtencion del codigo tipo proceso
					select
					tp.codigo
					into
					v_codigo_tipo_pro
					from wf.ttipo_proceso tp
					where tp.id_tipo_proceso =  v_registros_proc.id_tipo_proceso_pro;

					--Disparar creacion de procesos seleccionados
					select
					ps_id_proceso_wf,
					ps_id_estado_wf,
					ps_codigo_estado
					into
					v_id_proceso_wf,
					v_id_estado_wf,
					v_codigo_estado
					from wf.f_registra_proceso_disparado_wf(
					p_id_usuario,
					v_parametros._id_usuario_ai,
					v_parametros._nombre_usuario_ai,
					v_id_estado_actual,
					v_registros_proc.id_funcionario_wf_pro,
					v_registros_proc.id_depto_wf_pro,
					v_registros_proc.obs_pro,
					v_codigo_tipo_pro,
					v_codigo_tipo_pro);

				end loop;

				--------------------------------------------
				--  ACTUALIZA EL NUEVO ESTADO DEL REGISTRO
				--------------------------------------------
				if misc.f_fun_inicio_conta_alm_wf(
						p_id_usuario,
						v_parametros._id_usuario_ai,
						v_parametros._nombre_usuario_ai,
						v_id_estado_actual,
						v_id_proceso_wf,
						v_codigo_estado_siguiente,
						null,
		                null,
		                v_codigo_estado
					) then

				end if;

				-- si hay mas de un estado disponible  preguntamos al usuario
				v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Se realizó el cambio de estado del registro id_conta_alm = '||v_parametros.id_conta_alm);
				v_resp = pxp.f_agrega_clave(v_resp,'operacion','cambio_exitoso');

				-- Devuelve la respuesta
				return v_resp;

	     	end;

		/*********************************
		#TRANSACCION:  	'MIS_ANTEST_IME'
		#DESCRIPCION: 	Retrocede el estado del pago simple
		#AUTOR:   		RCM
		#FECHA:   		27/08/2018
		***********************************/

	  	elseif(p_transaccion='MIS_ANTEST_IME')then

	        begin

				--Obtenemos datos basicos
				select
				c.id_conta_alm,
				c.id_proceso_wf,
				c.estado,
				pwf.id_tipo_proceso
				into
				v_registros_proc
				from misc.tconta_alm c
				inner join wf.tproceso_wf pwf on  pwf.id_proceso_wf = c.id_proceso_wf
				where c.id_proceso_wf = v_parametros.id_proceso_wf;

	        	v_id_proceso_wf = v_registros_proc.id_proceso_wf;

	            --------------------------------------------------
	            --Retrocede al estado inmediatamente anterior
	            -------------------------------------------------
	           	--recupera estado anterior segun Log del WF
				select
				ps_id_tipo_estado,
				ps_id_funcionario,
				ps_id_usuario_reg,
				ps_id_depto,
				ps_codigo_estado,
				ps_id_estado_wf_ant
				into
				v_id_tipo_estado,
				v_id_funcionario,
				v_id_usuario_reg,
				v_id_depto,
				v_codigo_estado,
				v_id_estado_wf_ant
				from wf.f_obtener_estado_ant_log_wf(v_parametros.id_estado_wf);

				--Configurar acceso directo para la alarma
				v_acceso_directo = '';
				v_clase = '';
				v_parametros_ad = '';
				v_tipo_noti = 'notificacion';
				v_titulo  = 'Visto Bueno';

				if v_codigo_estado_siguiente not in('borrador','finalizado','anulado') then
					v_acceso_directo = '../../../sis_miscelano/vista/conta_alm/ContaAlm.php';
					v_clase = 'ContaAlm';
					v_parametros_ad = '{filtro_directo:{campo:"cd.id_proceso_wf",valor:"'||v_id_proceso_wf::varchar||'"}}';
					v_tipo_noti = 'notificacion';
					v_titulo  = 'Visto Bueno';
				end if;

	          	--Registra nuevo estado
				v_id_estado_actual = wf.f_registra_estado_wf
									(
									    v_id_tipo_estado,                --  id_tipo_estado al que retrocede
									    v_id_funcionario,                --  funcionario del estado anterior
									    v_parametros.id_estado_wf,       --  estado actual ...
									    v_id_proceso_wf,                 --  id del proceso actual
									    p_id_usuario,                    -- usuario que registra
									    v_parametros._id_usuario_ai,
									    v_parametros._nombre_usuario_ai,
									    v_id_depto,                       --depto del estado anterior
									    '[RETROCESO] '|| v_parametros.obs,
									    v_acceso_directo,
									    v_clase,
									    v_parametros_ad,
									    v_tipo_noti,
									    v_titulo
									);

				if not misc.f_fun_regreso_conta_alm_wf(p_id_usuario,
													v_parametros._id_usuario_ai,
													v_parametros._nombre_usuario_ai,
													v_id_estado_actual,
													v_parametros.id_proceso_wf,
													v_codigo_estado) then

					raise exception 'Error al retroceder estado';

				end if;

				v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Se realizó el cambio de estado del registro id_conta_alm = '||v_parametros.id_conta_alm);
				v_resp = pxp.f_agrega_clave(v_resp,'operacion','cambio_exitoso');

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
	ALTER FUNCTION "misc"."ft_conta_alm_ime"(integer, integer, character varying, character varying) OWNER TO postgres;