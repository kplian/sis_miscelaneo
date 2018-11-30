<?php
/**
*@package pXP
*@file gen-ACTContaAlm.php
*@author  (rchumacero)
*@date 11-10-2018 16:02:45
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTContaAlm extends ACTbase{    
			
	function listarContaAlm(){
		$this->objParam->defecto('ordenacion','id_conta_alm');

		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODContaAlm','listarContaAlm');
		} else{
			$this->objFunc=$this->create('MODContaAlm');
			
			$this->res=$this->objFunc->listarContaAlm($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarContaAlm(){
		$this->objFunc=$this->create('MODContaAlm');	
		if($this->objParam->insertar('id_conta_alm')){
			$this->res=$this->objFunc->insertarContaAlm($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarContaAlm($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarContaAlm(){
			$this->objFunc=$this->create('MODContaAlm');	
		$this->res=$this->objFunc->eliminarContaAlm($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>