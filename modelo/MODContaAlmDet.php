<?php
/**
*@package pXP
*@file gen-MODContaAlmDet.php
*@author  (rchumacero)
*@date 11-10-2018 13:47:00
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODContaAlmDet extends MODbase{

	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}

	function listarContaAlmDet(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='misc.ft_conta_alm_det_sel';
		$this->transaccion='MIS_CALMD_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion

		//captura parametros adicionales para el count
		$this->capturaCount('total_monto','numeric');

		$this->setParametro('id_depto_conta','id_depto_conta','integer');
		$this->setParametro('fecha_ini','fecha_ini','date');
		$this->setParametro('fecha_fin','fecha_fin','date');
		$this->setParametro('id_conta_alm','id_conta_alm','integer');

		//Definicion de la lista del resultado del query
		$this->captura('id_conta_alm_det','int4');
		$this->captura('moneda','varchar');
		$this->captura('centro_almacen','varchar');
		$this->captura('nombre_material','varchar');
		$this->captura('id_moneda','int4');
		$this->captura('id_centro_costo','int4');
		$this->captura('id_cuenta_debe','int4');
		$this->captura('precio_unitario','numeric');
		$this->captura('nro_ot','varchar');
		$this->captura('centro_costo','varchar');
		$this->captura('estado_reg','varchar');
		$this->captura('id_cuenta_haber','int4');
		$this->captura('total','numeric');
		$this->captura('almacen','varchar');
		$this->captura('desc_cuenta_haber','text');
		$this->captura('codigo_material','varchar');
		$this->captura('desc_cuenta_debe','text');
		$this->captura('fecha','date');
		$this->captura('id_conta_alm','int4');
		$this->captura('id_usuario_ai','int4');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('usuario_ai','varchar');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('codigo_centro_costo','varchar');
		$this->captura('cuenta_contable_debe','varchar');
		$this->captura('cuenta_contable_haber','varchar');
		$this->captura('id_documento','int4');
		$this->captura('tipo_documento','int4');
		$this->captura('tipo_material','varchar');
		$this->captura('cantidad_mat','numeric');

		//Ejecuta la instruccion
		$this->armarConsulta();
		//echo $this->consulta;exit;
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}

	function insertarContaAlmDet(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='misc.ft_conta_alm_det_ime';
		$this->transaccion='MIS_CALMD_INS';
		$this->tipo_procedimiento='IME';

		//Define los parametros para la funcion
		$this->setParametro('moneda','moneda','varchar');
		$this->setParametro('centro_almacen','centro_almacen','varchar');
		$this->setParametro('nombre_material','nombre_material','varchar');
		$this->setParametro('id_moneda','id_moneda','int4');
		$this->setParametro('id_centro_costo','id_centro_costo','int4');
		$this->setParametro('id_cuenta_debe','id_cuenta_debe','int4');
		$this->setParametro('precio_unitario','precio_unitario','numeric');
		$this->setParametro('nro_ot','nro_ot','varchar');
		$this->setParametro('centro_costo','centro_costo','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_cuenta_haber','id_cuenta_haber','int4');
		$this->setParametro('total','total','numeric');
		$this->setParametro('almacen','almacen','varchar');
		$this->setParametro('desc_cuenta_haber','desc_cuenta_haber','text');
		$this->setParametro('codigo_material','codigo_material','varchar');
		$this->setParametro('desc_cuenta_debe','desc_cuenta_debe','text');
		$this->setParametro('fecha','fecha','date');
		$this->setParametro('id_conta_alm','id_conta_alm','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}

	function modificarContaAlmDet(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='misc.ft_conta_alm_det_ime';
		$this->transaccion='MIS_CALMD_MOD';
		$this->tipo_procedimiento='IME';

		//Define los parametros para la funcion
		$this->setParametro('id_conta_alm_det','id_conta_alm_det','int4');
		$this->setParametro('moneda','moneda','varchar');
		$this->setParametro('centro_almacen','centro_almacen','varchar');
		$this->setParametro('nombre_material','nombre_material','varchar');
		$this->setParametro('id_moneda','id_moneda','int4');
		$this->setParametro('id_centro_costo','id_centro_costo','int4');
		$this->setParametro('id_cuenta_debe','id_cuenta_debe','int4');
		$this->setParametro('precio_unitario','precio_unitario','numeric');
		$this->setParametro('nro_ot','nro_ot','varchar');
		$this->setParametro('centro_costo','centro_costo','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_cuenta_haber','id_cuenta_haber','int4');
		$this->setParametro('total','total','numeric');
		$this->setParametro('almacen','almacen','varchar');
		$this->setParametro('desc_cuenta_haber','desc_cuenta_haber','text');
		$this->setParametro('codigo_material','codigo_material','varchar');
		$this->setParametro('desc_cuenta_debe','desc_cuenta_debe','text');
		$this->setParametro('fecha','fecha','date');
		$this->setParametro('id_conta_alm','id_conta_alm','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}

	function eliminarContaAlmDet(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='misc.ft_conta_alm_det_ime';
		$this->transaccion='MIS_CALMD_ELI';
		$this->tipo_procedimiento='IME';

		//Define los parametros para la funcion
		$this->setParametro('id_conta_alm_det','id_conta_alm_det','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}

}
?>