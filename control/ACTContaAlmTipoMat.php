<?php
/**
*@package pXP
*@file gen-ACTContaAlmTipoMat.php
*@author  (rchumacero)
*@date 31-10-2018 14:28:02
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTContaAlmTipoMat extends ACTbase{    
			
	function listarContaAlmTipoMat(){
		$this->objParam->defecto('ordenacion','id_conta_alm_tipo_mat');

		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODContaAlmTipoMat','listarContaAlmTipoMat');
		} else{
			$this->objFunc=$this->create('MODContaAlmTipoMat');
			
			$this->res=$this->objFunc->listarContaAlmTipoMat($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarContaAlmTipoMat(){
		$this->objFunc=$this->create('MODContaAlmTipoMat');	
		if($this->objParam->insertar('id_conta_alm_tipo_mat')){
			$this->res=$this->objFunc->insertarContaAlmTipoMat($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarContaAlmTipoMat($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarContaAlmTipoMat(){
			$this->objFunc=$this->create('MODContaAlmTipoMat');	
		$this->res=$this->objFunc->eliminarContaAlmTipoMat($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>