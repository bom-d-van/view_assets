Ext.ns("Wando.purchasingOrders");
Wando.purchasingOrders.materialPurchasing = { init: function() { this.purchaseForm = this.createPurchaseForm();
		this.purchaseGrid = this.createPurchaseGrid();
		Wando.mainPanel = Ext.create("Ext.Panel", {
			title: '采购单',
			layout: 'border',
			items: [this.purchaseForm, this.purchaseGrid],
			tbar: Ext.create("Ext.toolbar.Toolbar", {
				items: [{
					text: '保存',
					itemsCls: 'save',
					iconCls: Wando.icons.save,
					handler: function() {
						var puroForm = Ext.getCmp("purchaseOrderForm");
						var puroGrid = Ext.getCmp("purchaseInfo");
						puroGrid.getStore().save();
						puroData = puroForm.getValues();
					}
				}],
			}) 
		});
	},

	createPurchaseForm: function() {
		var employeeFieldSet = {
			xtype: 'fieldset',
			style: 'border: 0px; margin: 0px 50px;',
			padding: '0 30px',
			layout: 'form',
			columnWidth: 0.33,
			height: 150,
			items: [{
				fieldLabel: '供应商',
				xtype: 'combobox',
				draggable: true,
				store: {
					xtype: 'jsonstore',
					fields: ['name'],
					proxy: {
						type: 'ajax',
						url: '/suppliers/index.json',
						reader: {
							type: 'json',
							root: 'suppliers',
						},
					},
				},
				displayField: 'name',
				queryMode: 'remote',
				valueFields: 'name',
				triggerAction: 'all',
			}, {
				xtype: 'textfield',
				id: 'clerk_id',
				name: 'clerk_id',
				fieldLabel: '制单员',
				emptyText: '管理员',
				readOnly: true,
			}, {
				xtype: 'textfield',
				name: 'place',
				fieldLabel: '发往地',
			}]
		}; 

		var infoFieldSet = {
			id: 'infoFieldSet',
			style: 'border: 0px; margin: 0px 50px;',
			xtype: 'fieldset',
			columnWidth: 0.33,
			height: 150,
			items: [{
				xtype: 'datefield',
				fieldLabel: '下单时间',
				name: 'make_at',
                value : new Date,
				format: "Y-m-d"
			},{
				fieldLabel: '采购交期',
				name: 'delivery_time',
				xtype: 'datefield',
				format: "Y-m-d"
			}]
		};

		var otherRemarkFieldSet = {
			id: 'otherRemarkFieldSet',
			style: 'border: 1px; margin:0px 50px;',
			xtype: 'fieldset',
			columnWidth: 0.33,
			height: 150,
			items: [{
				fieldLabel: '统计表所属',
				xtype: 'combobox',
				store: {
					xtype: 'jsonstore',
					fields: ['name'],
					proxy: {
						type: 'ajax',
						url: '/dyed_yarn_statistical_reports/index.json',
						reader: {
							type: 'json',
							root: 'reports',
						},
					},
				},
				displayField: 'name',
				valueField: 'name',
				triggerAction: 'all',
			}, {
				fieldLabel: '备注',
				name: 'remark',
				xtype: 'textarea',
				height: 80,
			}],
		};

		return Ext.create("Ext.form.Panel", {
			id: 'purchaseOrderForm',
			labelAlign: 'right',
			region: 'north',
			layout: 'column',
			height: 150,
			frame: true,
			items: [
				employeeFieldSet,
				infoFieldSet,
				otherRemarkFieldSet,
			],
		});
	},

	createPurchaseGrid: function() {
		Ext.define("purchaseInfoModel", {
			extend: 'Ext.data.Model',
			fields: ["color_number", "count","variety", "color", "request_quantity", "inform_quantity",
	   	"price", "total_price", "quantity", "cotton_color_num", "remark" ],
		});
		
		var cellEditing = Ext.create("Ext.grid.plugin.CellEditing", {
			clicksToEditing: 1
		});

		var store = Ext.create("Ext.data.Store", {
			model: 'purchaseInfoModel',
			storeId: 'purchaseInfoStore',
			proxy: {
				type: 'ajax',
				url: '/purchasing_order_items/index.json',
				reader: {
					type: 'json',
					root: 'purchasing_order_items',
				}
			},
			autoLoad: true,
		});

		return Ext.create("Ext.grid.Panel", {
			id: "purchaseInfo",
			title: "采购信息",
			region: "center",
			store: store,
			forceFit: true,
			columns: [
				{ header: '制单号', dataIndex: '', editor: 'textfield' },
				{ header: '色号', dataIndex: 'color_number' },
				{ header: '纱支', dataIndex: 'count' },
				{ header: '品种', dataIndex: 'variety' },
				{ header: '颜色', dataIndex: 'color' },
				{ header: '计划数量', dataIndex: 'request_quantity' },
				{ header: '入库通知数', dataIndex: 'inform_quantity' },
				{ header: '单价', dataIndex: 'price', editor: 'textfield' },
				{ header: '总价', dataIndex: 'total_price', editor: 'textfield' },
				{ header: '采购数量', dataIndex: 'quantity', editor: 'textfield' },
				{ header: '纱厂色号', dataIndex: 'cotton_color_num', editor: 'textfield' },
				{ header: '备注', dataIndex: 'remark', editor: 'textfield'},
		    ], 
			selType: 'cellmodel',
			plugins: [cellEditing],
		});
	},

}
