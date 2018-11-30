<?php
/**
*@package pXP
*@file ContaAlmDet.php
*@author  RCM
*@date 03/09/2018
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.ContaAlmDet=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.ContaAlmDet.superclass.constructor.call(this,config);
		this.init();
		this.grid.getTopToolbar().disable();
        this.grid.getBottomToolbar().disable();

        var dataPadre = Phx.CP.getPagina(this.idContenedorPadre).getSelectedData()
        if(dataPadre){
            this.onEnablePanel(this, dataPadre);
        } else {
           this.bloquearMenus();
        }
	},

	Atributos:[
		{
		    config:{
		        labelSeparator:'',
		        inputType:'hidden',
		        name: 'id_reg'
		    },
		    type:'Field',
		    form:true
		},
		{
		    config:{
		        name: 'fecha',
		        fieldLabel: 'Fecha',
		        allowBlank: true,
		        anchor: '80%',
		        gwidth: 80,
		        renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
		    },
		    type:'TextField',
		    filters:{pfiltro:'conalmd.fecha',type:'date'},
		    id_grupo:1,
		    grid:true,
		    form:false
		},
		{
		    config:{
		        name: 'nro_ot',
		        fieldLabel: 'OT',
		        allowBlank: true,
		        anchor: '80%',
		        gwidth: 100
		    },
		    type:'TextField',
		    filters:{pfiltro:'conalmd.nro_ot',type:'string'},
		    id_grupo:1,
		    grid:true,
		    form:false,
		    bottom_filter: true
		},
		{
		    config:{
		        name: 'codigo_material',
		        fieldLabel: 'Código Material',
		        allowBlank: true,
		        anchor: '80%',
		        gwidth: 100
		    },
		    type:'TextField',
		    filters:{pfiltro:'conalmd.codigo_material',type:'string'},
		    id_grupo:1,
		    grid:true,
		    form:false,
		    bottom_filter: true
		},
		{
		    config:{
		        name: 'nombre_material',
		        fieldLabel: 'Material',
		        allowBlank: true,
		        anchor: '80%',
		        gwidth: 150
		    },
		    type:'TextField',
		    filters:{pfiltro:'conalmd.nombre_material',type:'string'},
		    id_grupo:1,
		    grid:true,
		    form:false,
		    bottom_filter: true
		},
		{
		    config:{
		        name: 'precio_unitario',
		        fieldLabel: 'Precio Unitario',
		        allowBlank: true,
		        anchor: '80%',
		        gwidth: 150,
		        renderer:function (value,p,record){
		        	var resp;
		        	resp = Math.round(value * 100) / 100;
		        	if(isNaN(value)){
		        		resp = value;
		        	}
		        	return resp;
		        }
		    },
		    type:'TextField',
		    filters:{pfiltro:'conalmd.precio_unitario',type:'numeric'},
		    id_grupo:1,
		    grid:true,
		    form:false
		},
		{
		    config:{
		        name: 'total',
		        fieldLabel: 'Precio Total',
		        allowBlank: true,
		        anchor: '80%',
		        gwidth: 150,
		        renderer:function (value,p,record){
		        	return  Math.round(value * 100) / 100
		        }
		    },
		    type:'TextField',
		    filters:{pfiltro:'conalmd.total',type:'numeric'},
		    id_grupo:1,
		    grid:true,
		    form:false
		},
		{
		    config:{
		        name: 'moneda',
		        fieldLabel: 'Moneda',
		        allowBlank: true,
		        anchor: '80%',
		        gwidth: 60
		    },
		    type:'TextField',
		    filters:{pfiltro:'conalmd.moneda',type:'string'},
		    id_grupo:1,
		    grid:true,
		    form:false
		},
		{
		    config:{
		        name: 'centro_costo',
		        fieldLabel: 'Centro de Costo',
		        allowBlank: true,
		        anchor: '80%',
		        gwidth: 150,
		        maxLength:30
		    },
		    type:'TextField',
		    filters:{pfiltro:'conalmd.centro_costo',type:'string'},
		    id_grupo:1,
		    grid:true,
		    form:false,
		    bottom_filter: true
		},
		{
		    config:{
		        name: 'desc_cuenta_debe',
		        fieldLabel: 'Cuenta Debe',
		        allowBlank: true,
		        anchor: '80%',
		        gwidth: 190
		    },
		    type:'TextField',
		    filters:{pfiltro:'conalmd.desc_cuenta_debe',type:'string'},
		    id_grupo:1,
		    grid:true,
		    form:false
		},
		{
		    config:{
		        name: 'desc_cuenta_haber',
		        fieldLabel: 'Cuenta Haber',
		        allowBlank: true,
		        anchor: '80%',
		        gwidth: 190,
		        maxLength:30
		    },
		    type:'TextField',
		    filters:{pfiltro:'conalmd.desc_cuenta_haber',type:'string'},
		    id_grupo:1,
		    grid:true,
		    form:false
		},
		{
		    config:{
		        name: 'almacen',
		        fieldLabel: 'Almacén',
		        allowBlank: true,
		        anchor: '80%',
		        gwidth: 90
		    },
		    type:'TextField',
		    filters:{pfiltro:'conalmd.almacen',type:'string'},
		    id_grupo:1,
		    grid:true,
		    form:false
		},
		{
		    config:{
		        name: 'centro_almacen',
		        fieldLabel: 'Regional',
		        allowBlank: true,
		        anchor: '80%',
		        gwidth: 90
		    },
		    type:'TextField',
		    filters:{pfiltro:'conalmd.centro_almacen',type:'string'},
		    id_grupo:1,
		    grid:true,
		    form:false
		}
	],
	tam_pag:50,
	title:'Itinerario',
	ActList:'../../sis_miscelaneo/control/ContaAlm/listarContaAlmDet',
	//id_store:'id_cuenta_doc_itinerario',
	fields: [
		{name:'id_reg', type: 'numeric'},
		{name:'fecha', type: 'date', dateFormat:'Y-m-d'},
		{name:'nro_ot', type: 'string'},
		{name:'codigo_material', type: 'string'},
		{name:'nombre_material', type: 'string'},
		{name:'precio_unitario', type: 'numeric'},
		{name:'total', type: 'numeric'},
		{name:'moneda', type: 'string'},
		{name:'centro_costo', type: 'string'},
		{name:'desc_cuenta_debe', type: 'string'},
		{name:'desc_cuenta_haber', type: 'string'},
		{name:'almacen', type: 'string'},
		{name:'centro_almacen', type: 'string'}
	],
	sortInfo:{
		field: 'id_reg',
		direction: 'ASC'
	},
	bdel:false,
	bsave:false,
	bedit: false,
	onReloadPage: function(m) {
        this.maestro = m;
        this.Atributos[0].valorInicial = this.maestro.id_reg;

        //Filtro para los datos
        this.store.baseParams = {
            id_reg: this.maestro.id_reg,
            id_depto_conta: this.maestro.id_depto_conta,
            fecha_ini: this.maestro.fecha_ini,
            fecha_fin: this.maestro.fecha_fin,
            id_depto_conta: this.maestro.id_depto_conta
        };
        this.load({
            params: {
                start: 0,
                limit: 50
            }
        });

    }
})
</script>

