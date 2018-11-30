<?php
/**
*@package pXP
*@file gen-DeptoRegionalSigema.php
*@author  (rchumacero)
*@date 31-08-2018 14:27:40
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.DeptoRegionalSigema=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.DeptoRegionalSigema.superclass.constructor.call(this,config);
		this.init();
		this.load({params:{start:0, limit:this.tam_pag}})
	},

	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_depto_regional_sigema'
			},
			type:'Field',
			form:true
		},
		{
			config:{
				name: 'codigo_regional_sigema',
				fieldLabel: 'Código Regional SIGEMA',
				allowBlank: true,
				anchor: '80%',
				gwidth: 150,
				maxLength:30
			},
				type:'TextField',
				filters:{pfiltro:'depreg.codigo_regional_sigema',type:'string'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config: {
				name: 'id_depto',
				fieldLabel: 'Depto. Contabilidad',
				allowBlank: false,
				emptyText: 'Elija una opción...',
				store: new Ext.data.JsonStore({
					url: '../../sis_parametros/control/Depto/listarDepto',
					id: 'id_depto',
					root: 'datos',
					sortInfo: {
						field: 'codigo',
						direction: 'ASC'
					},
					totalProperty: 'total',
					fields: ['id_depto', 'nombre', 'codigo'],
					remoteSort: true,
					baseParams: {par_filtro: 'depreg.nombre#depreg.codigo', codigo_subsistema: 'CONTA'}
				}),
				valueField: 'id_depto',
				displayField: 'codigo',
				gdisplayField: 'desc_depto',
				hiddenName: 'id_depto',
				forceSelection: true,
				typeAhead: false,
				triggerAction: 'all',
				lazyRender: true,
				mode: 'remote',
				pageSize: 15,
				queryDelay: 1000,
				anchor: '100%',
				gwidth: 250,
				minChars: 2,
				tpl: '<tpl for="."><div class="x-combo-list-item"><p>{codigo} - {nombre}</p></div></tpl>',
				renderer : function(value, p, record) {
					return String.format('{0}', record.data['desc_depto']);
				}
			},
			type: 'ComboBox',
			id_grupo: 0,
			filters: {pfiltro: 'dep.codigo',type: 'string'},
			grid: true,
			form: true
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
				filters:{pfiltro:'depreg.estado_reg',type:'string'},
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
				filters:{pfiltro:'depreg.fecha_reg',type:'date'},
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
				filters:{pfiltro:'depreg.usuario_ai',type:'string'},
				id_grupo:1,
				grid:true,
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
				name: 'id_usuario_ai',
				fieldLabel: 'Creado por',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:4
			},
				type:'Field',
				filters:{pfiltro:'depreg.id_usuario_ai',type:'numeric'},
				id_grupo:1,
				grid:false,
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
				filters:{pfiltro:'depreg.fecha_mod',type:'date'},
				id_grupo:1,
				grid:true,
				form:false
		}
	],
	tam_pag:50,
	title:'Depto. - Regional SIGEMA',
	ActSave:'../../sis_miscelaneo/control/DeptoRegionalSigema/insertarDeptoRegionalSigema',
	ActDel:'../../sis_miscelaneo/control/DeptoRegionalSigema/eliminarDeptoRegionalSigema',
	ActList:'../../sis_miscelaneo/control/DeptoRegionalSigema/listarDeptoRegionalSigema',
	id_store:'id_depto_regional_sigema',
	fields: [
		{name:'id_depto_regional_sigema', type: 'numeric'},
		{name:'estado_reg', type: 'string'},
		{name:'codigo_regional_sigema', type: 'string'},
		{name:'id_depto', type: 'numeric'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usuario_ai', type: 'string'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
		{name:'desc_depto', type: 'string'}
	],
	sortInfo:{
		field: 'id_depto_regional_sigema',
		direction: 'ASC'
	},
	bdel:true,
	bsave:true
	}
)
</script>

