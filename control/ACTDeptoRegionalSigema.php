<?php
/**
*@package pXP
*@file gen-ACTDeptoRegionalSigema.php
*@author  (rchumacero)
*@date 31-08-2018 14:27:40
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTDeptoRegionalSigema extends ACTbase{    
			
	function listarDeptoRegionalSigema(){
		$this->objParam->defecto('ordenacion','id_depto_regional_sigema');

		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODDeptoRegionalSigema','listarDeptoRegionalSigema');
		} else{
			$this->objFunc=$this->create('MODDeptoRegionalSigema');
			
			$this->res=$this->objFunc->listarDeptoRegionalSigema($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarDeptoRegionalSigema(){
		$this->objFunc=$this->create('MODDeptoRegionalSigema');	
		if($this->objParam->insertar('id_depto_regional_sigema')){
			$this->res=$this->objFunc->insertarDeptoRegionalSigema($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarDeptoRegionalSigema($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarDeptoRegionalSigema(){
			$this->objFunc=$this->create('MODDeptoRegionalSigema');	
		$this->res=$this->objFunc->eliminarDeptoRegionalSigema($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>