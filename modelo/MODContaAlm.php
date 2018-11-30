<?php
/**
*@package pXP
*@file gen-MODContaAlm.php
*@author  (rchumacero)
*@date 23-08-2018 20:25:16
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODContaAlm extends MODbase{

	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}

	function listarContaAlm(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='misc.ft_conta_alm_sel';
		$this->transaccion='MIS_CONALM_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion

		//Definicion de la lista del resultado del query
		$this->captura('id_conta_alm','int4');
		$this->captura('id_periodo','int4');
		$this->captura('id_int_comprobante','int4');
		$this->captura('tipo','varchar');
		$this->captura('estado','varchar');
		$this->captura('estado_reg','varchar');
		$this->captura('id_usuario_ai','int4');
		$this->captura('id_usuario_reg','int4');
		$this->captura('usuario_ai','varchar');
		$this->captura('fecha_reg','timestamp');
		$this->captura('fecha_mod','timestamp');
		$this->captura('id_usuario_mod','int4');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('desc_periodo','text');
		$this->captura('glosa','varchar');
		$this->captura('id_proceso_wf','int4');
		$this->captura('id_estado_wf','int4');
		$this->captura('num_tramite','varchar');
		$this->captura('id_depto_conta','int4');
		$this->captura('desc_depto_conta','varchar');
		$this->captura('id_moneda','int4');
		$this->captura('desc_moneda','varchar');
		$this->captura('id_reg','int4');
		$this->captura('fecha_ini','date');
		$this->captura('fecha_fin','date');
		$this->captura('id_proceso_wf_cbte','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}

	function insertarContaAlm(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='misc.ft_conta_alm_ime';
		$this->transaccion='MIS_CONALM_INS';
		$this->tipo_procedimiento='IME';

		//Define los parametros para la funcion
		//$this->setParametro('id_periodo','id_periodo','int4');
		$this->setParametro('id_int_comprobante','id_int_comprobante','int4');
		$this->setParametro('tipo','tipo','varchar');
		$this->setParametro('estado','estado','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('glosa','glosa','varchar');
		$this->setParametro('id_depto_conta','id_depto_conta','int4');
		$this->setParametro('id_moneda','id_moneda','int4');
		$this->setParametro('fecha_ini','fecha_ini','date');
		$this->setParametro('fecha_fin','fecha_fin','date');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}

	function modificarContaAlm(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='misc.ft_conta_alm_ime';
		$this->transaccion='MIS_CONALM_MOD';
		$this->tipo_procedimiento='IME';

		//Define los parametros para la funcion
		$this->setParametro('id_conta_alm','id_conta_alm','int4');
		//$this->setParametro('id_periodo','id_periodo','int4');
		$this->setParametro('id_int_comprobante','id_int_comprobante','int4');
		$this->setParametro('tipo','tipo','varchar');
		$this->setParametro('estado','estado','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('glosa','glosa','varchar');
		$this->setParametro('id_depto_conta','id_depto_conta','int4');
		$this->setParametro('id_moneda','id_moneda','int4');
		$this->setParametro('fecha_ini','fecha_ini','date');
		$this->setParametro('fecha_fin','fecha_fin','date');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}

	function eliminarContaAlm(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='misc.ft_conta_alm_ime';
		$this->transaccion='MIS_CONALM_ELI';
		$this->tipo_procedimiento='IME';

		//Define los parametros para la funcion
		$this->setParametro('id_conta_alm','id_conta_alm','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}

	function siguienteEstado(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento = 'misc.ft_conta_alm_ime';
        $this->transaccion = 'MIS_SIGEST_INS';
        $this->tipo_procedimiento = 'IME';

        //Define los parametros para la funcion
        $this->setParametro('id_conta_alm','id_conta_alm','integer');
        $this->setParametro('id_proceso_wf_act','id_proceso_wf_act','int4');
        $this->setParametro('id_estado_wf_act','id_estado_wf_act','int4');
        $this->setParametro('id_funcionario_usu','id_funcionario_usu','int4');
        $this->setParametro('id_tipo_estado','id_tipo_estado','int4');
        $this->setParametro('id_funcionario_wf','id_funcionario_wf','int4');
        $this->setParametro('id_depto_wf','id_depto_wf','int4');
        $this->setParametro('obs','obs','text');
        $this->setParametro('json_procesos','json_procesos','text');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();
        //Devuelve la respuesta
        return $this->respuesta;
    }

    function listarContaAlmDet(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='misc.ft_conta_alm_sel';
		$this->transaccion='MIS_CONALMDET_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion

		//captura parametros adicionales para el count
		$this->capturaCount('total_monto','numeric');

		$this->setParametro('id_depto_conta','id_depto_conta','integer');
		$this->setParametro('fecha_ini','fecha_ini','date');
		$this->setParametro('fecha_fin','fecha_fin','date');

		//Definicion de la lista del resultado del query
		$this->captura('id_reg','integer');
		$this->captura('fecha','date');
		$this->captura('nro_ot','varchar');
		$this->captura('codigo_material','varchar');
		$this->captura('nombre_material','varchar');
		$this->captura('precio_unitario','numeric');
		$this->captura('total','numeric');
		$this->captura('moneda','varchar');
		$this->captura('centro_costo','varchar');
		$this->captura('desc_cuenta_debe','text');
		$this->captura('desc_cuenta_haber','text');
		$this->captura('almacen','varchar');
		$this->captura('centro_almacen','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		//echo $this->consulta;exit;
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}

	 function anteriorEstado(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='misc.ft_conta_alm_ime';
        $this->transaccion='MIS_ANTEST_IME';
        $this->tipo_procedimiento='IME';
        //Define los parametros para la funcion
        $this->setParametro('id_proceso_wf','id_proceso_wf','int4');
        $this->setParametro('id_estado_wf','id_estado_wf','int4');
		$this->setParametro('obs','obs','varchar');
		$this->setParametro('estado_destino','estado_destino','varchar');
		$this->setParametro('id_conta_alm','id_conta_alm','int4');
		//Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

}
?>