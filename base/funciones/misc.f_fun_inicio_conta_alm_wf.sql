CREATE OR REPLACE FUNCTION misc.f_fun_inicio_conta_alm_wf (
  p_id_usuario integer,
  p_id_usuario_ai integer,
  p_usuario_ai varchar,
  p_id_estado_wf integer,
  p_id_proceso_wf integer,
  p_codigo_estado varchar,
  p_id_depto_lb integer = NULL::integer,
  p_id_cuenta_bancaria integer = NULL::integer,
  p_estado_anterior varchar = 'no'::character varying
)
RETURNS boolean AS
$body$
/**************************************************************************
 SISTEMA:       Misceláneo
 FUNCION:       misc.f_fun_inicio_conta_alm_wf

 DESCRIPCION:   Actualiza los estados despues del registro de estado en tabla transaccional
 FECHA:         05/01/2018
 COMENTARIOS:

 ***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:
 AUTOR:
 FECHA:
***************************************************************************/
DECLARE

    v_nombre_funcion                text;
    v_resp                          varchar;
    v_rec                           record;
    v_id_int_comprobante            integer;
    v_plantilla_cbte                varchar;

BEGIN

    --Identificación del nombre de la función
    v_nombre_funcion = 'misc.f_fun_inicio_conta_alm_wf';
    v_plantilla_cbte = 'MI-ALSAL';

    ----------------------------------------------
    --Obtención de datos de la cuenta documentada
    ----------------------------------------------
    select
    c.id_conta_alm,
    c.estado,
    c.id_estado_wf,
    c.tipo,
    per.periodo || ' / ' || ges.gestion as desc_periodo
    into v_rec
    from misc.tconta_alm c
    inner join param.tperiodo per
    on per.id_periodo = c.id_periodo
    inner join param.tgestion ges
    on ges.id_gestion = per.id_gestion
    where c.id_proceso_wf = p_id_proceso_wf;

    --Actualización del estado de la solicitud
    update misc.tconta_alm set
    id_estado_wf    = p_id_estado_wf,
    estado          = p_codigo_estado,
    id_usuario_mod  = p_id_usuario,
    id_usuario_ai   = p_id_usuario_ai,
    usuario_ai      = p_usuario_ai,
    fecha_mod       = now()
    where id_proceso_wf = p_id_proceso_wf;

    ---------------------------------
    ---Lógica específica por estado
    ---------------------------------

    if p_codigo_estado = 'cbte' then

        --Si es de tipo ingreso lanza una excepción
        if v_rec.tipo = 'ingreso' then
            raise exception 'Contabilización de Ingresos aún no implementado.';
        end if;

        --Verifica que exista información en la tabla del SIGEMA
        if not exists(select 1
                    from misc.vconta_almacen_det
                    where id_conta_alm = v_rec.id_conta_alm) then
            raise exception 'No existen movimientos de % de almacén en el período % para contabilizar.', v_rec.tipo, v_rec.desc_periodo;
        end if;

        --Genera el comprobante
        v_id_int_comprobante = conta.f_gen_comprobante
                                (
                                    v_rec.id_conta_alm,
                                    v_plantilla_cbte,
                                    p_id_estado_wf,
                                    p_id_usuario,
                                    p_id_usuario_ai,
                                    p_usuario_ai
                                );

        --Actualización del Id del comprobante en la cuenta documentada
        update misc.tconta_alm set
        id_int_comprobante = v_id_int_comprobante
        where id_proceso_wf = p_id_proceso_wf;

    elsif p_codigo_estado = 'finalizado' then


    end if;

    --Respuesta
    return true;

EXCEPTION

    WHEN OTHERS THEN

        v_resp = '';
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