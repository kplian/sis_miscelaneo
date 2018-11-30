<?php
/**
*@package pXP
*@file gen-ContaAlm.php
*@author  (rchumacero)
*@date 23-08-2018 20:25:16
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.ContaAlmAdm=Ext.extend(Phx.gridInterfaz,{
	nombreVista: 'ContaAlmAdm',
	constructor:function(config){
		this.maestro = config.maestro;
		this.historico = 'no';
    	//llama al constructor de la clase padre
		Phx.vista.ContaAlmAdm.superclass.constructor.call(this,config);
		this.init();
		this.load({params:{start:0, limit:this.tam_pag}})
        this.addBotonesGantt();

        //Botón para Imprimir el Comprobante
		this.addButton('btnImprimir', {
			text : 'Cbte.',
			iconCls : 'bprint',
			disabled : true,
			handler : this.imprimirCbte,
			tooltip : '<b>Imprimir Comprobante</b><br/>Imprime el Comprobante en el formato oficial'
		});


	},

	Atributos:[
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
			//configuracion del componente
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
				name: 'num_tramite',
				fieldLabel: 'Num.Trámite',
				allowBlank: true,
				anchor: '80%',
				gwidth: 150,
				maxLength:30
			},
			type:'TextField',
			filters:{pfiltro:'conalm.num_tramite',type:'string'},
			id_grupo:1,
			grid:true,
			form:false
		},
		{
			config: {
				name: 'id_periodo',
				fieldLabel: 'Período',
				allowBlank: false,
				emptyText: 'Elija una opción...',
				store:new Ext.data.JsonStore(
				{
					url: '../../sis_parametros/control/Periodo/listarPeriodo',
					id: 'id_periodo',
					root: 'datos',
					sortInfo:{
						field: 'periodo',
						direction: 'ASC'
					},
					totalProperty: 'total',
					fields: ['id_periodo','periodo','id_gestion','literal'],
					// turn on remote sorting
					remoteSort: true,
					baseParams:{par_filtro:'gestion',id_gestion: 0}
				}),
				valueField: 'id_periodo',
				triggerAction: 'all',
				displayField: 'literal',
			    hiddenName: 'id_periodo',
    			mode:'remote',
				pageSize:50,
				queryDelay:500,
				listWidth:'280',
				width:'97%',
				renderer: function(value, p, record) {
					return String.format('{0}', record.data['desc_periodo']);
				}
			},
			type: 'ComboBox',
			id_grupo: 0,
			filters: {pfiltro: 'per.periodo#per.gestion',type: 'string'},
			grid: true,
			form: false
		},
		{
			config:{
				name: 'fecha_ini',
				fieldLabel: 'Desde',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				format: 'd/m/Y',
				renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
			},
			type:'DateField',
			filters:{pfiltro:'conalm.fecha_ini',type:'date'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'fecha_fin',
				fieldLabel: 'Hasta',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				format: 'd/m/Y',
				renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
			},
			type:'DateField',
			filters:{pfiltro:'conalm.fecha_ini',type:'date'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'estado',
				fieldLabel: 'Estado',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:30
			},
			type:'TextField',
			filters:{pfiltro:'conalm.estado',type:'string'},
			id_grupo:1,
			grid:true,
			form:false
		},
		{
			config: {
				name: 'tipo',
				fieldLabel: 'Tipo',
				anchor: '95%',
				tinit: false,
				allowBlank: false,
				origen: 'CATALOGO',
				gdisplayField: 'tipo',
				hiddenName: 'id_tipo',
				gwidth: 55,
				baseParams:{
					cod_subsistema:'MISC',
					catalogo_tipo:'tconta_alm__tipo'
				},
				valueField: 'codigo'
			},
			type: 'ComboRec',
			id_grupo: 0,
			filters:{pfiltro:'conalm.tipo',type:'string'},
			grid: true,
			form: true
		},
		{
			config:{
				name: 'glosa',
				fieldLabel: 'Glosa',
				allowBlank: false,
				anchor: '97%',
				gwidth: 300,
				maxLength: 2000
			},
			type:'TextArea',
			filters:{ pfiltro:'conalm.glosa',type:'string' },
			id_grupo:0,
			grid: true,
			bottom_filter: true,
			form: true
		},
		{
   			config:{
   				name: 'id_depto_conta',
   				hiddenName: 'Depto.Contabilidad',
   				url: '../../sis_parametros/control/Depto/listarDeptoFiltradoXUsuario',
	   			origen: 'DEPTO',
	   			allowBlank: false,
	   			fieldLabel: 'Depto',
	   			anchor: '100%',
	   			gdisplayField: 'desc_depto_conta',//dibuja el campo extra de la consulta al hacer un inner join con orra tabla
	   			width: 250,
   			    gwidth: 180,
	   			baseParams: { estado:'activo',codigo_subsistema:'CONTA'},//parametros adicionales que se le pasan al store
	      		renderer: function (value, p, record){return String.format('{0}', record.data['desc_depto_conta']);}
   			},
   			type: 'ComboRec',
   			id_grupo: 0,
   			filters: { pfiltro:'dep.nombre#dep.codigo', type:'string'},
   		    grid: true,
   			form: true
       	},
       	{
            config:{
                name: 'id_moneda',
                origen: 'MONEDA',
                allowBlank: false,
                fieldLabel: 'Moneda',
                anchor: '100%',
                gdisplayField: 'desc_moneda',//mapea al store del grid
                gwidth: 50,
                //baseParams: { 'filtrar_base': 'si' },
                renderer: function (value, p, record){return String.format('{0}', record.data['desc_moneda']);}
             },
            type: 'ComboRec',
            id_grupo: 1,
            filters: { pfiltro:'mon.codigo',type:'string'},
            grid: true,
            form: true
        },
		{
			config:{
				name: 'id_int_comprobante',
				fieldLabel: 'Id.Cbte.',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:30
			},
			type:'TextField',
			filters:{pfiltro:'conalm.id_int_comprobante',type:'numeric'},
			id_grupo:1,
			grid:true,
			form:false
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
			filters:{pfiltro:'conalm.estado_reg',type:'string'},
			id_grupo:1,
			grid:true,
			form:false
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
			filters:{pfiltro:'conalm.id_usuario_ai',type:'numeric'},
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
				name: 'usuario_ai',
				fieldLabel: 'Funcionaro AI',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:300
			},
			type:'TextField',
			filters:{pfiltro:'conalm.usuario_ai',type:'string'},
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
			filters:{pfiltro:'conalm.fecha_reg',type:'date'},
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
			filters:{pfiltro:'conalm.fecha_mod',type:'date'},
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
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_proceso_wf'
			},
			type:'Field',
			form:true
		},
		{
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_estado_wf'
			},
			type:'Field',
			form:true
		}
	],
	tam_pag:50,
	title:'Contabilizar Movimientos Almacén',
	ActSave:'../../sis_miscelaneo/control/ContaAlm/insertarContaAlm',
	ActDel:'../../sis_miscelaneo/control/ContaAlm/eliminarContaAlm',
	ActList:'../../sis_miscelaneo/control/ContaAlm/listarContaAlm',
	id_store:'id_conta_alm',
	fields: [
		{name:'id_conta_alm', type: 'numeric'},
		{name:'id_periodo', type: 'numeric'},
		{name:'id_int_comprobante', type: 'numeric'},
		{name:'tipo', type: 'string'},
		{name:'estado', type: 'string'},
		{name:'estado_reg', type: 'string'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'usuario_ai', type: 'string'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
		{name:'desc_periodo', type: 'string'},
		{name:'glosa', type: 'string'},
		{name:'id_proceso_wf', type: 'numeric'},
		{name:'id_estado_wf', type: 'numeric'},
		{name:'num_tramite', type: 'string'},
		{name:'id_depto_conta', type: 'numeric'},
		{name:'desc_depto_conta', type: 'string'},
		{name:'id_moneda', type: 'numeric'},
		{name:'desc_moneda', type: 'string'},
		{name:'id_reg', type: 'numeric'},
		{name:'fecha_ini', type: 'date',dateFormat:'Y-m-d'},
		{name:'fecha_fin', type: 'date',dateFormat:'Y-m-d'},
		{name:'id_proceso_wf_cbte', type: 'numeric'}
	],
	sortInfo:{
		field: 'id_conta_alm',
		direction: 'ASC'
	},
	bdel:false,
	bedit:false,
	bsave:false,

	addBotonesGantt: function() {
        this.menuAdqGantt = new Ext.Toolbar.SplitButton({
            id: 'b-diagrama_gantt-' + this.idContenedor,
            text: 'Gantt',
            disabled: true,
            grupo:[0,1,2,3],
            iconCls: 'bgantt',
            handler:this.diagramGanttDinamico,
            scope: this,
            menu:{
	            items: [{
	                id:'b-gantti-' + this.idContenedor,
	                text: 'Gantt Imagen',
	                tooltip: '<b>Muestra un reporte gantt en formato de imagen</b>',
	                handler:this.diagramGantt,
	                scope: this
	            }, {
	                id:'b-ganttd-' + this.idContenedor,
	                text: 'Gantt Dinámico',
	                tooltip: '<b>Muestra el reporte gantt facil de entender</b>',
	                handler:this.diagramGanttDinamico,
	                scope: this
	            }]
            }
        });
		this.tbar.add(this.menuAdqGantt);
    },

	south: {
        url: '../../../sis_miscelaneo/vista/conta_alm_det/ContaAlmDet.php',
        title: 'Detalle de Movimiento',
        height: '50%',
        cls: 'ContaAlmDet'
    },

     imprimirCbte : function() {
		var rec = this.sm.getSelected();
		var data = rec.data;
		if (data) {
			Phx.CP.loadingShow();
			Ext.Ajax.request({
				url : '../../sis_contabilidad/control/IntComprobante/reporteCbte',
				params : {
					'id_proceso_wf' : data.id_proceso_wf_cbte
				},
				success : this.successExport,
				failure : this.conexionFailure,
				timeout : this.timeout,
				scope : this
			});
		}

	},

	preparaMenu: function(n) {
		var data = this.getSelectedData();
		var tb = this.tbar;
		Phx.vista.ContaAlmAdm.superclass.preparaMenu.call(this, n);

		this.getBoton('btnImprimir').disable();
		//Botón de comprobante
		if(data.id_int_comprobante){
			this.getBoton('btnImprimir').enable();
		}

		return tb;
	},

})
</script>