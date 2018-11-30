<?php
/**
*@package pXP
*@file gen-ACTContaAlm.php
*@author  (rchumacero)
*@date 23-08-2018 20:25:16
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTContaAlm extends ACTbase{

	function listarContaAlm(){
		$this->objParam->defecto('ordenacion','id_conta_alm');
		$this->objParam->defecto('dir_ordenacion','asc');

		if($this->objParam->getParametro('id_depto_conta')!=''){
			$this->objParam->addFiltro("conalm.id_depto_conta in (".$this->objParam->getParametro('id_depto_conta').")");
		}

		if($this->objParam->getParametro('id_gestion')!=''){
			$this->objParam->addFiltro("per.id_gestion = ".$this->objParam->getParametro('id_gestion'));
		}

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

	function siguienteEstado(){
        $this->objFunc=$this->create('MODContaAlm');
        $this->res=$this->objFunc->siguienteEstado($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

    function listarContaAlmDet(){
		$this->objParam->defecto('ordenacion','fecha');
		$this->objParam->defecto('dir_ordenacion','asc');

		/*if($this->objParam->getParametro('fecha_ini')!=''&&$this->objParam->getParametro('fecha_fin')!=''){
			//$this->objParam->addFiltro("conalmd.id_reg = ".$this->objParam->getParametro('id_reg'));
			$this->objParam->addFiltro("conalmd.fecha between ''".$this->objParam->getParametro('fecha_ini')."'' and ''".$this->objParam->getParametro('fecha_fin')."''");
		}

		if($this->objParam->getParametro('id_depto_conta')!=''){
			$this->objParam->addFiltro("rs.id_depto = ".$this->objParam->getParametro('id_depto_conta'));
		}*/

		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODContaAlm','listarContaAlmDet');
		} else{
			$this->objFunc=$this->create('MODContaAlm');
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

	function anteriorEstado(){
        $this->objFunc=$this->create('MODContaAlm');
        $this->res=$this->objFunc->anteriorEstado($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

}

?>