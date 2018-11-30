<?php
/**
*@package pXP
*@file gen-ContaAlmDet.php
*@author  (rchumacero)
*@date 11-10-2018 13:47:00
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

		var dataPadre = Phx.CP.getPagina(this.idContenedorPadre).getSelectedData()
        if(dataPadre){
            this.onEnablePanel(this, dataPadre);
        } else {
           this.bloquearMenus();
        }
	},

	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_conta_alm_det'
			},
			type:'Field',
			form:true
		},
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_conta_alm'
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
				gwidth: 100,
				format: 'd/m/Y',
				renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
			},
			type:'DateField',
			filters:{pfiltro:'calmd.fecha',type:'date'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'nro_ot',
				fieldLabel: 'OT',
				allowBlank: true,
				anchor: '80%',
				gwidth: 115,
				maxLength:-5
			},
			type:'TextField',
			filters:{pfiltro:'calmd.nro_ot',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'codigo_material',
				fieldLabel: 'Cod.Material',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:50
			},
			type:'TextField',
			filters:{pfiltro:'calmd.codigo_material',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'nombre_material',
				fieldLabel: 'Material',
				allowBlank: true,
				anchor: '80%',
				gwidth: 300,
				maxLength:200
			},
			type:'TextField',
			filters:{pfiltro:'calmd.nombre_material',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'precio_unitario',
				fieldLabel: 'Precio Unitario',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:-5
			},
			type:'NumberField',
			filters:{pfiltro:'calmd.precio_unitario',type:'numeric'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'cantidad_mat',
				fieldLabel: 'Cantidad',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:-5
			},
			type:'NumberField',
			filters:{pfiltro:'calmd.cantidad_mat',type:'numeric'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'total',
				fieldLabel: 'Precio Total',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:-5
			},
			type:'NumberField',
			filters:{pfiltro:'calmd.total',type:'numeric'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'moneda',
				fieldLabel: 'Moneda',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:30
			},
			type:'TextField',
			filters:{pfiltro:'calmd.moneda',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'centro_costo',
				fieldLabel: 'Centro de Costo',
				allowBlank: true,
				anchor: '80%',
				gwidth: 200,
				maxLength:200
			},
			type:'TextField',
			filters:{pfiltro:'calmd.centro_costo',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'desc_cuenta_debe',
				fieldLabel: 'Cuenta Debe',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:-5
			},
			type:'TextField',
			filters:{pfiltro:'calmd.desc_cuenta_debe',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'desc_cuenta_haber',
				fieldLabel: 'Cuenta Haber',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:-5
			},
			type:'TextField',
			filters:{pfiltro:'calmd.desc_cuenta_haber',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'centro_almacen',
				fieldLabel: 'Regional',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:100
			},
			type:'TextField',
			filters:{pfiltro:'calmd.centro_almacen',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'almacen',
				fieldLabel: 'Almacén',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:100
			},
			type:'TextField',
			filters:{pfiltro:'calmd.almacen',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'tipo_material',
				fieldLabel: 'Tipo Material',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:100
			},
			type:'TextField',
			filters:{pfiltro:'calmd.tipo_material',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'estado_reg',
				fieldLabel: 'Estado Reg.',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:10
			},
			type:'TextField',
			filters:{pfiltro:'calmd.estado_reg',type:'string'},
			id_grupo:1,
			grid:true,
			form:false
		},
		{
			config:{
				name: 'id_documento',
				fieldLabel: 'ID Doc.',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:-5
			},
			type:'TextField',
			filters:{pfiltro:'calmd.id_documento',type:'numeric'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'tipo_documento',
				fieldLabel: 'Tipo Doc.',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:-5
			},
			type:'TextField',
			filters:{pfiltro:'calmd.tipo_documento',type:'numeric'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'id_usuario_ai',
				fieldLabel: '',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:4
			},
			type:'Field',
			filters:{pfiltro:'calmd.id_usuario_ai',type:'numeric'},
			id_grupo:1,
			grid:false,
			form:false
		},
		{
			config:{
				name: 'usr_reg',
				fieldLabel: 'Creado por',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:4
			},
			type:'Field',
			filters:{pfiltro:'usu1.cuenta',type:'string'},
			id_grupo:1,
			grid:true,
			form:false
		},
		{
			config:{
				name: 'fecha_reg',
				fieldLabel: 'Fecha creación',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				format: 'd/m/Y',
				renderer:function (value,p,record){return value?value.dateFormat('d/m/Y H:i:s'):''}
			},
			type:'DateField',
			filters:{pfiltro:'calmd.fecha_reg',type:'date'},
			id_grupo:1,
			grid:true,
			form:false
		},
		{
			config:{
				name: 'usuario_ai',
				fieldLabel: 'Funcionaro AI',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:300
			},
			type:'TextField',
			filters:{pfiltro:'calmd.usuario_ai',type:'string'},
			id_grupo:1,
			grid:true,
			form:false
		},
		{
			config:{
				name: 'usr_mod',
				fieldLabel: 'Modificado por',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:4
			},
			type:'Field',
			filters:{pfiltro:'usu2.cuenta',type:'string'},
			id_grupo:1,
			grid:true,
			form:false
		},
		{
			config:{
				name: 'fecha_mod',
				fieldLabel: 'Fecha Modif.',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				format: 'd/m/Y',
				renderer:function (value,p,record){return value?value.dateFormat('d/m/Y H:i:s'):''}
			},
			type:'DateField',
			filters:{pfiltro:'calmd.fecha_mod',type:'date'},
			id_grupo:1,
			grid:true,
			form:false
		}
	],
	tam_pag:50,
	title:'Detalle Contabilización',
	ActSave:'../../sis_miscelaneo/control/ContaAlmDet/insertarContaAlmDet',
	ActDel:'../../sis_miscelaneo/control/ContaAlmDet/eliminarContaAlmDet',
	ActList:'../../sis_miscelaneo/control/ContaAlmDet/listarContaAlmDet',
	id_store:'id_conta_alm_det',
	fields: [
		{name:'id_conta_alm_det', type: 'numeric'},
		{name:'moneda', type: 'string'},
		{name:'centro_almacen', type: 'string'},
		{name:'nombre_material', type: 'string'},
		{name:'id_moneda', type: 'numeric'},
		{name:'id_centro_costo', type: 'numeric'},
		{name:'id_cuenta_debe', type: 'numeric'},
		{name:'precio_unitario', type: 'numeric'},
		{name:'nro_ot', type: 'string'},
		{name:'centro_costo', type: 'string'},
		{name:'estado_reg', type: 'string'},
		{name:'id_cuenta_haber', type: 'numeric'},
		{name:'total', type: 'numeric'},
		{name:'almacen', type: 'string'},
		{name:'desc_cuenta_haber', type: 'string'},
		{name:'codigo_material', type: 'string'},
		{name:'desc_cuenta_debe', type: 'string'},
		{name:'fecha', type: 'date',dateFormat:'Y-m-d'},
		{name:'id_conta_alm', type: 'numeric'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usuario_ai', type: 'string'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
		{name:'id_documento', type: 'numeric'},
		{name:'tipo_documento', type: 'numeric'},
		{name:'tipo_material', type: 'string'},
		{name:'cantidad_mat', type: 'numeric'}
	],
	sortInfo:{
		field: 'fecha',
		direction: 'ASC'
	},
	bdel:false,
	bsave:false,
	bnew:false,
	bedit: false,
	onReloadPage: function(m) {
        this.maestro = m;
        this.Atributos[0].valorInicial = this.maestro.id_conta_alm;

        //Filtro para los datos
        this.store.baseParams = {
            id_reg: this.maestro.id_reg,
            id_depto_conta: this.maestro.id_depto_conta,
            fecha_ini: this.maestro.fecha_ini,
            fecha_fin: this.maestro.fecha_fin,
            id_conta_alm: this.maestro.id_conta_alm
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

