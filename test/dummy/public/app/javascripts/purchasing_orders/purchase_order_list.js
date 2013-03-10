Ext.ns("Wando.purchasingOrders");

Wando.purchasingOrders.purchaseOrderList = {
	init: function() {
		this.puroListPanel = this.createPuroListPanel();
		this.puroState = this.createPuroState();
		Wando.mainPanel = Ext.create("Ext.Panel", {
			layout: 'border',
			items: [
				this.puroListPanel, 
				this.puroState
			]
		});
	},

	createPuroListPanel: function() {
		this.puroList = this.createPuroList();
		this.puroItems = this.createPuroItems();
		return Ext.create("Ext.panel.Panel", {
			layout: 'anchor',
			region: 'center',
			items: [this.puroList, this.puroItems]
		});
	},

	createPuroList: function() {
		Ext.define("puroListModel", {
			extend: 'Ext.data.Model',
			fields: [],
		});

		var store = Ext.create("Ext.data.Store", {
			model: puroListModel,
			storeId: "puroListStore",
			pageSize: 25,
			proxy: {
				type: 'ajax',
				url: '',
				render: {
					type: 'json',
					root: '',
				},
			},
			autoLoad: {
				start: 0,
				limit: 25,
			},
		});

		return Ext.create("Ext.grid.Panel", {
			id: 'puroList',
			title: '采购单列表',
			anchor: '100% 50%',
			viewConfig: { forceFit: true },
			store: store,
			columns: [],
			tbar: this.createPuroListTbar(),
			dockedItems: [{
				xtype: 'pagingtoolbar',
			    store: store,
			    dock: 'bottom',
			    displayInfo: true,
			}],
		});
	},

	createPuroListTbar: function() {
		return Ext.create("Wando.Tbar", {
				using: ["query", "edit"],
				extraItems: [{
					text: '批准',
					handler: function() {
					}
				}, {
					text: '不批准',
					handler: function() {
					}
				}, {
					text: '采购结束',
					handler: function() {
					}
				}],
		});
	},

	createPuroItems: function() {
		Ext.define("puroItemsModel", {
			extend: Ext.data.Model,
			fields: [],
		});

		var store = Ext.create("Ext.data.Store", {
			storeId: 'puroItemsStore',
			model: 'puroItemsModel',
			pageSize: 25,
			proxy: {
				type: 'ajax',
				url: '',
				render: {
					type: 'json',
					root: '',
				},
			},
			autoLoad: {
				start: 0,
				limit: 0,
			},
		});

		return Ext.create("Ext.grid.Panel", {
			id: 'puroItems',
			title: '采购单项',
			autoHeight: true,
			anchor: '100% 50%',
			viewConfig: { forceFit:true },
			columns: [],
			tbar: Ext.create("Wando.Tbar", {
				extraItems: [{
					text: '入库通知',
					handler: function() {
					}
				}]
			}),
			dockedItems: [{
				xtype: 'pagingtoolbar',
			    store: store,
			    dock: 'bottom',
			    displayInfo: true,
			}],
		});
	},

	createPuroState: function() {
		var store = Ext.create("Ext.data.TreeStore", {
			root: {
				text: '类型',
				expanded: true,
				rootVisible: false,
				children: [{
					text: "审核", leaf: true
				}, {
					text: "未审核", leaf: true
				}, {
					text: "采购结束", leaf: true
				}],
			},
		});

		return Ext.create("Ext.tree.Panel", {
			id: 'puroState',
			title: '采购单状态',
			region: 'west',
			width: 220,
			store: store,
			listeners: {
				itemclick: {
					fn: function(node) {
						a=node;
						console.log(node);
					}
				}
			},
		});
	},
};
