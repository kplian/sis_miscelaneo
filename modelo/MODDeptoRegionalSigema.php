<?php
/**
*@package pXP
*@file gen-MODDeptoRegionalSigema.php
*@author  (rchumacero)
*@date 31-08-2018 14:27:40
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODDeptoRegionalSigema extends MODbase{

	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}

	function listarDeptoRegionalSigema(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='misc.ft_depto_regional_sigema_sel';
		$this->transaccion='MIS_DEPREG_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion

		//Definicion de la lista del resultado del query
		$this->captura('id_depto_regional_sigema','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('codigo_regional_sigema','varchar');
		$this->captura('id_depto','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('usuario_ai','varchar');
		$this->captura('id_usuario_reg','int4');
		$this->captura('id_usuario_ai','int4');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('desc_depto','text');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}

	function insertarDeptoRegionalSigema(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='misc.ft_depto_regional_sigema_ime';
		$this->transaccion='MIS_DEPREG_INS';
		$this->tipo_procedimiento='IME';

		//Define los parametros para la funcion
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('codigo_regional_sigema','codigo_regional_sigema','varchar');
		$this->setParametro('id_depto','id_depto','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}

	function modificarDeptoRegionalSigema(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='misc.ft_depto_regional_sigema_ime';
		$this->transaccion='MIS_DEPREG_MOD';
		$this->tipo_procedimiento='IME';

		//Define los parametros para la funcion
		$this->setParametro('id_depto_regional_sigema','id_depto_regional_sigema','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('codigo_regional_sigema','codigo_regional_sigema','varchar');
		$this->setParametro('id_depto','id_depto','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}

	function eliminarDeptoRegionalSigema(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='misc.ft_depto_regional_sigema_ime';
		$this->transaccion='MIS_DEPREG_ELI';
		$this->tipo_procedimiento='IME';

		//Define los parametros para la funcion
		$this->setParametro('id_depto_regional_sigema','id_depto_regional_sigema','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}

}
?>