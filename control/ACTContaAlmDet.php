<?php
/**
*@package pXP
*@file gen-ACTContaAlmDet.php
*@author  (rchumacero)
*@date 11-10-2018 13:47:00
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTContaAlmDet extends ACTbase{

	function listarContaAlmDet(){
		$this->objParam->defecto('ordenacion','id_conta_alm_det');
		$this->objParam->defecto('dir_ordenacion','asc');

		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODContaAlmDet','listarContaAlmDet');
		} else{
			$this->objFunc=$this->create('MODContaAlmDet');
			$this->res=$this->objFunc->listarContaAlmDet($this->objParam);
		}

		//Se agrega fila del total al final del store
		$temp = Array();
		$temp['precio_unitario'] = 'TOTAL';
		$temp['total'] = $this->res->extraData['total_monto'];
		$temp['tipo_reg'] = 'summary';
		$temp['id_conta_alm'] = 0;
		$this->res->total++;
		$this->res->addLastRecDatos($temp);

		$this->res->imprimirRespuesta($this->res->generarJson());
	}

	function insertarContaAlmDet(){
		$this->objFunc=$this->create('MODContaAlmDet');
		if($this->objParam->insertar('id_conta_alm_det')){
			$this->res=$this->objFunc->insertarContaAlmDet($this->objParam);
		} else{
			$this->res=$this->objFunc->modificarContaAlmDet($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}

	function eliminarContaAlmDet(){
			$this->objFunc=$this->create('MODContaAlmDet');
		$this->res=$this->objFunc->eliminarContaAlmDet($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}

}

?>