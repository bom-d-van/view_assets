/**
 * @author CKJ
 *
 * @class Wando.Tbar
 * @extends Ext.toolbar.Toolbar
 *
 *		Extension Methods: getTbarItems, disableItems, enableItems, getTbarItem, resetHandler, enableAll, disableAll, getButtonByItemId, hideButtonByItemId, showButtonByItemId, hideAll <br />
 *		注意：使用 disableItems 或者 enableItems 时，需要为 item 配置itemId<br />
 *		P.S. <br/>
 *			default action support grid only<br />
 *			default delete action support cellSeNectionModel only<br />
 *			default using => "query", "expand", "save", "add", "edit", "delete", "deleteAll",
				"select", "backup", "copy", "excel", "import", "print", "calculate" <br />
 * # Example usage
 *  @example
 *
 *	config = {
 *		gridId: 'gridId',	                // <font color="red">这个id不能缺少，如果是在grid使用</font>
 *		using : ["query", "expand", "save", "add", "edit", "delete", "deleteAll",
				"select", "backup", "copy", "excel", "import", "print", "calculate" ],
 *		defaultScope: object,
 *		queryType: 'grid',					// 'grid'(defaults) || 'tree'
 *		condiction: [field, emptyValue],
 *
 *		whenSave: {							// you can chose this way
 *			handler: yourHandler,
 *			scope: object,
 *		},
 *		whenSave: function() {...},			// or this way to implement your function
 *		extraItems: [{
 *			text: '',
 *			iconCls: '',
 *			handler: function() {},
 *		}],
 *	}
 */

Ext.define('Wando.Tbar', {
	extend: 'Ext.toolbar.Toolbar',
/**
 * @constructor create a new toolbar instance
 * @params { hash } This is a hash of your config which can create a toolbar
 */
	constructor: function(config) {
		Ext.applyIf(config, { queryType: 'grid' });
		this.tbarItemsArray = [];
		this.itemsConfiger = config;
		this.defaultScope = Ext.isDefined(config.defaultScope) ? config.defaultScope : this;

		this.createItems();
		Ext.apply(config, { items: this.tbarItemsArray });
        //Wando.Tbar.superclass.constructor.call(this, config);
		if(this.itemsConfiger.qureyType == "tree") this.on("render", this.createTreeSearchBar);
		this.callParent(arguments);
	},

	/*====================================*/
	/*   系统提供的按钮及所需内部函数     */
	/*====================================*/

  /**
   * @cfg { Object/Array } using 添加按钮
   * @example
   *
   * using: ["query", "expand", "save", "add", "edit", "delete", "deleteAll",
				"select", "backup", "copy", "excel", "import", "print", "calculate" ];
   *
   */
	getDefaultItemsSequence: function() {
		return ["query", "expand", "save", "add", "edit", "delete", "deleteAll",
				"select", "backup", "copy", "excel", "import", "print", "calculate" ];
	},

   /**
	* @cfg { String } gridId 默认给"gridId",
	*/
   /**
	* @cfg { String } queryType 赋予查询的类型，value 可以是 grid 或 tree
    */
   /**
	* @cfg { Array/String } condiction 查询条件
    */
   /**
	* @cfg { Object } defaultScope 默认作用域
	*/

	/**
	 * @property { String }
	 * @param { String } This string is a stylesheet about shortcut tip
	 * @return { String } This string is a stylesheet about shortcut tip
	 */
	getShortcutTip: function(shortcutTip) {
		return '(<span style="text-decoration:underline">' + shortcutTip + '</span>)';
	},

	/**
	 * @property { Object }
	 * @param { String } This string is a stylesheet about shortcut tip
	 * @return { Object } This string is a stylesheet about shortcut tip
	 */
	getScope: function(type) {
		return Ext.isDefined(this.itemsConfiger["when" + Ext.String.capitalize(type)]) ? this.defaultScope : this;
	},

	/*==================================*/
	/*	构造内部按钮空间及其功能方法    */
	/*==================================*/

	createItems: function() {
		if(Ext.isDefined(this.itemsConfiger.using))
			this.createUsingItems();
		if(Ext.isDefined(this.itemsConfiger.extraItems))
			this.mergeExtraItems();

	},

    createUsingItems: function() {
        // if(!Ext.isArray(this.itemsConfiger.using)) this.itemsConfiger.using = [this.itemsConfiger.using];
        var using = this.itemsConfiger.using;
        if(Ext.isString()) using = using.split(' ').filter(String);
        this.getDefaultItemsSequence().forEach(function(item) {
			if(using.isInclude(item))
				this.tbarItemsArray.push(this["create" + Ext.String.capitalize(item) + "Item"]());
        }, this);
    },

	/**
	 * @cfg { Object } 添加items对象，
	 * @example
	 * extraItems: [{
	 *     text: '入库',
	 *     iconCls: Wando.icons.inbound,
	 *     handler: function() {
	 *     }
	 * }]
	 */
	mergeExtraItems: function() {
		this.itemsConfiger.extraItems.forEach(function(item) {
			Ext.applyIf(item, { scope: this.defaultScope });
			this.tbarItemsArray.push(item);
		}, this);
	},

 /**
  * @cfg { Function } whenAdd 添加添加功能
  */
	createAddItem: function() {
		var item = {
			text: '添加' + this.getShortcutTip('A'),
			iconCls: Wando.icons.add,
			itemId: 'add',
			scope: this.getScope('add'),
			handler: this.defaultAddAction
		};
		var whenAdd = this.itemsConfiger.whenAdd;
		if(Ext.isDefined(whenAdd)) {
			if(Ext.isFunction(whenAdd)) whenAdd = { handler: whenAdd };
			Ext.apply(item, whenAdd);
		}
		return item;
	},

	// 默认的添加功能
	defaultAddAction: function() {
		if(!this.itemsConfiger.gridId) return;
		var grid = Ext.getCmp(this.itemsConfiger.gridId);
		var store = grid.getStore();
		store.add({});
	},

 /**
  * @cfg { Function } whenDelete 添加删除功能
  */
	createDeleteItem: function() {
		var item = {
			text: '删除' + this.getShortcutTip("d"),
			iconCls: Wando.icons.deleteVanCorrect,
			itemId: 'delete',
			scope: this.getScope('delete'),
			handler: this.defaultDeleteAction
		};
		var whenDelete = this.itemsConfiger.whenDelete;
		if(Ext.isDefined(whenDelete)) {
			if(Ext.isFunction(whenDelete)) whenDelete = { handler: whenDelte }
			Ext.apply(item, whenDelete);
		}
		return item;
	},

	// 默认的删除方法
	defaultDeleteAction: function() {
		if(!this.itemsConfiger.gridId) return;
		var grid = Ext.getCmp(this.itemsConfiger.gridId);
		var sm = grid.getSelectionModel();
		var store = grid.getStore();
		var selected = sm.getSelection();

		if(selected != false) {
			Wando.msg.question("Warning", "是否要删除选中记录？", function(btn) {
				if(btn !== "ok") return false;
				store.remove(selected);
				return true;
			});
		}else {
			Wando.msg.warning("Warning","没有选中记录");
		}
	},

 /**
  * @cfg { Function } whenDeleteAll 添加全部删除功能
  */
	createDeleteAllItem: function() {
		var item = {
			text: '删除全部' + this.getShortcutTip('D'),
			iconCls: Wando.icons.deleteAll,
			itemCls: 'deleteAll',
			scope: this.getScope('deleteAll'),
			handler: this.defaultDeleteAllAction
		};
		var whenDeleteAll = this.itemsConfiger.whenDeleteAll;
		if(Ext.isDefined(whenDeleteAll)) {
			if(Ext.isFunction(whenDeleteAll)) whenDeleteAll = { handler: whenDeleteAll };
			Ext.apply(item, whenDeleteAll);
		}
		return item;
	},

	// 默认删除全部的方法
	defaultDeleteAllAction: function() {
		if(!this.itemsConfiger.gridId) return;
		var grid = Ext.getCmp(this.itemsConfiger.gridId);
		var store = grid.getStore();
		Wando.msg.question("Warning", "确定要删除全部记录吗?", function(btn) {
			if(btn !== 'ok') return false;
			store.removeAll();
			return true;
		});
	},

 /**
  * @cfg { Function } whenSelect 添加选择功能
  */
	createSelectItem: function() {
		var item = {
			text: '选择',
			iconCls: Wando.icons.select,
			itemCls: 'select',
			scope: this.getScope('select'),
			handler: this.defaultSelectAction
		};
		var whenSelect = this.itemsConfiger.whenSelect;
		if(Ext.isDefined(whenSelect)) {
			if(Ext.isFunction(whenSelect)) whenSelect = { handler: whenSelect };
			Ext.apply(item, whenSelect);
		}
		return item;
	},

	defaultSelectAction: function() {
		console.log("EMPTY: TO DO");
	},

 /**
  * @cfg { Function } whenEdit 添加修改功能
  */
	createEditItem: function() {
		var item = {
			text: '修改' + this.getShortcutTip("e"),
			iconCls: Wando.icons.edit,
			itemsId: "edit",
			scope: this.getScope("edit"),
			handler: this.defaultEditAction
		};
		var whenEdit = this.itemsConfiger.whenEdit;
		if(Ext.isDefined(whenEdit)) {
			if(Ext.isFunction(whenEdit)) return whenEdit = { handler: whenEdit };
			Ext.apply(item, whenEdit);
		}
		return item;
	},
	// 创建默认修改功能
	defaultEditAction: function() {
		console.log("EMPTY: TO DO");
	},

 /**
  * @cfg { Function } whenSave 添加保存功能
  */
	createSaveItem: function() {
		var item = {
			text: '保存' + this.getShortcutTip("S"),
			iconCls: Wando.icons.save,
			itemsId: "save",
			scope: this.getScope("save"),
			handler: this.defaultSaveAction
		};
		var whenSave = this.itemsConfiger.whenSave;
		if(Ext.isDefined(whenSave)) {
			if(Ext.isFunction(whenSave)) return whenSave = { handler: whenSave };
			Ext.apply(item, whenSave);
		}
		return item;
	},

	// 创建默认保存
	defaultSaveAction: function() {
		Ext.getCmp(this.itemsConfiger.gridId).getStore().save();
		Wando.msg.info("Congratulation!", "保存成功！");
	},

 /**
  * @cfg { Function } whenBackup 添加备份功能
  */
	createBackupItem: function() {
		item = {
			text: '数据库备份' + this.getShortcutTip("b"),
			iconCls: Wando.icons.backup,
			itemCls: 'backup',
			scope: this.getScope('backup'),
			handler: this.defaultBackupAction
		};
		var whenBackup = this.itemsConfiger.whenBackup;
		if(Ext.isDefined(whenBackup)) {
			if(Ext.isFunction(whenBackup)) return whenBackup = { handler: whenBackup };
			Ext.apply(item, whenBackup);
		}
		return item;
	},

	// 创建默认备份数据功能
	defaultBackupAction: function() {
		if(!this.itemsConfiger.gridId) return;
		var requestForBackupSystem = function() {
			Ext.Ajax.request({
				method: 'POST',
				url: "/backups/backup",
				success: Wando.callback.success,
				failure: Wando.callback.failure,
			});
		};
		Ext.Msg.confirm("注意", "确定要备份数据库", function(btn) {
			if(btn == 'yes') requestForBackupSystem;
		});
	},

	 /**
	  * @cfg { Function } whenPrint 添加打印功能
	  */
	createPrintItem: function() {
		var item = {
			text: '打印' + this.getShortcutTip("p"),
			iconCls: Wando.icons.print,
			itemCls: 'print',
			scope: this.getScope("print"),
			handler: this.defaultPrintAction
		};
		var whenPrint = this.itemsConfiger.whenPrint;
		if(Ext.isDefined(whenPrint)) {
			if(Ext.isFunction(whenPrint)) whenPrint = { handler: whenPrint };
			Ext.apply(item, whenPrint);
		}
		return item;
	},
	// 创建默认打印功能
	defaultPrintAction: function() {
		console.log("EMPTY: TO DO");
	},

	 /**
	  * @cfg { Function } whenCopy 添加复制功能
	  */
	createCopyItem: function() {
		var item = {
			text: '复制' + this.getShortcutTip("C"),
			iconCls: Wando.icons.copy,
			itemCls: 'copy',
			scope: this.getScope("copy"),
			handler: this.defaultCopyAction
		};
		var whenCopy = this.itemsConfiger.whenCopy;
		if(Ext.isDefined(whenCopy)) {
			if(Ext.isFunction(whenCopy)) whenCopy = { handler: whenCopy };
			Ext.apply(item, whenCopy);
		}
		return item;
	},
	// 默认复制功能
	defaultCopyAction: function() {
		console.log("EMPTY: TO DO");
	},

	 /**
	  * @cfg { Function } whenExcel 添加导出Excel功能
	  */
	createExcelItem: function() {
		var item = {
			text: '导出Excel',
			iconCls: Wando.icons.excel,
			itemCls: 'excel',
			scope: this.getScope("excel"),
			handler: this.defaultExcelAction
		};
		var whenExcel = this.itemsConfiger.whenExcel;
		if(Ext.isDefined(whenExcel)) {
			if(Ext.isFunction(whenExcel)) whenExcel = { handler: whenExcel };
			Ext.apply(item, whenExcel);
		}
		return item;
	},
	// 创建导出Excel默认功能
	defaultExcelAction: function() {
		console.log("EMPTY: TO DO");
	},

	 /**
	  * @cfg { Function } whenImport 添加导入功能
	  */
	createImportItem: function() {
		var item = {
			text: '导入',
			iconCls: Wando.icons.importVanCorrect,
			itemCls: 'import',
			scope: this.getScope("import"),
			handler: this.defaultImportAction
		};
		var whenImport = this.itemsConfiger.whenImport;
		if(Ext.isDefined(whenImport)) {
			if(Ext.isFunction(whenImport)) whenImport = { handler: whenImport };
			Ext.apply(item, whenImport);
		}
		return item;

	},
	// 创建默认导入功能
	defaultImportAction: function() {
		console.log("EMPTY: TO DO");
	},

	 /**
	  * @cfg { Function } whenCalculate 添加计算功能
	  */
	createCalculateItem: function() {
		var item = {
			text: '计算',
			iconCls: Wando.icons.calculator,
			itemCls: 'calculate',
			scope: this.getScope("calculate"),
			handler: this.defaultImportAction
		};
		var whenCalculate = this.itemsConfiger.whenCalculate;
		if(Ext.isDefined(whenCalculate)) {
			if(Ext.isFunction(whenCalculate)) whenCalculate = { handler: whenCalculate };
			Ext.apply(item, whenCalculate);
		}
		return item;
	},
	// 创建默认计算功能
	defaultCalculateAction: function() {
		console.log("EMPTY: TO DO");
	},
	/*==================================*/
	/*       Tree && Grid   query       */
	/*==================================*/
	createQueryItem: function() {
		var item = {};
		if(this.itemsConfiger.queryType === "tree") {
			item = {
				enableToggle: true,
				toggleHandler: this.queryForTree
			};
		}else {
			item.handler = this.itemsConfiger.queryForGrid;
		}
		Ext.applyIf(item, {
			text: '查询' + this.getShortcutTip('F'),
			iconCls: Wando.icons.query,
			itemId: 'query',
			scope: this,
		});
		return item;
	},

	queryForGrid: function() {
		var win = Ext.getCmp(this.itemsConfiger.gridId + "Win");
		if(Ext.isDefined(win)) win.show();
		else console.log("封装的搜索");
	},

	createTreeSearchBar: function() {
		var treePanel = this.findParentByType("treepanel");
		this.treeSearchBar = new Ext.toolbar.Toolbar({
			items: [{
				xtype: 'textfield',
				id: 'tbarSearchConditionField',
				emptyText: this.itemsConfiger.condition[1],
			}, {
				text: '搜索',
				scope: this,
				handler: this.searchByCondition,
			}, {
				text: '清空',
				scope: this,
				handler: function() {
					treePanel.getRootNode().reload(function() {
						Ext.getCmp("tbarSearchConditionField").reset();
						treePanel.expandAll();
					});
				}
			}]
		});
		treePanel.add(this.treeSearchBar);
		treePanel.doLayout();
		this.treeSearchBar.getEl().slideOut();
		this.treeSearchBar.hide();
		this.treeSearchBar.on("show", function() {
			this.treeSearchBar.getEl().slideIn("t", { callback: function() {
				Ext.getCmp("tbarSearchConditionField").focus();
			} });
		}, this);
	},

	searchByCondition: function() {
		var value = Ext.getCmp("tbarSearchConditionField").getValue();
		var treePanel = this.findParentByType("treepanel");
		var url = treePanel.getLoader().dataUrl;
		if(!url.isInclude("?")) url += "?";
		url += "&queryConditions=" + JSON.stringify([{
			content: this.itemsConfiger.condition[0],
			value: value,
			condition: "like",
		}]);
		var lm = new Ext.LoadMask(treePanel.getEl(), { msg: '加载中...' });
		lm.show();
		(new Ext.tree.TreeLoader({
		})).load(treePanel.getRootNode(), function() { lm.hide(); treePanel.getRootNode().expand(true); });
	},

	createExpandItem: function() {
		var item = {
			text: '合并',
			iconCls: Wando.icons.expand,
			itemId: "expand",
			scope: this.getScope("expand"),
			handler: this.defaultExpandAction
		};
		var whenExpand = this.itemsConfiger.whenExpand;
		if(Ext.isDefined(whenExpand)) {
			if(Ext.isFunction(whenExpand)) whenExpand = { handler: whenExpand };
			Ext.apply(item, whenExpand);
		}
		return item;
	},

	defaultExpandAction: function(btn) {
		var treePanel = this.findParentByType("treepanel");
		if(btn.getText() === "展开") {
			treePanel.expandAll();
			btn.setText("合并");
		}else {
			treePanel.collapseAll();
			btn.setText("展开");
		};
	},
	/*===============================*/
	/*      供外部使用的方法         */
	/*===============================*/
	/**
	 * @param { String } 所添加按钮的text是否有此text的按钮
	 * @return { Boolean } 是否存在此按钮
	 */
	getTbarItems: function(skips) {
		if(!Ext.isDefined(skips)) skips = ['->'];
		return this.tbarItemsArray.filter(function(item) {
			return !skips.isInclude(item);
		}, this);
	},

	/**
	 * @description 通过按钮的text获取是否有此id的按钮
	 * @param { String } 按钮的itemIds
	 * @return { Boolean } 是否有此itemIds的按钮
	 */
	getTbarItem: function(itemId) {
		return this.tbarItemsArray.filter(function(itemId) {
			return item.itemId === itemId;
		}, this)[0];
	},

	/**
	 * @description 通过按钮的itemIds禁用按钮
	 * @param { String } 按钮的itemIds
	 * @return { Boolean } 是否成共禁用按钮
	 */
	disableItems: function(itemsIds) {
		if(!Ext.isArray(itemIds)) itemIds = [itemIds];
		this.findBy(function(item) {
			if(itemIds.isInclude(item.itemId)) {
				this.getTbarItem(item.itemId).disabled = true;
				item.disable();
				return true;
			}else {
				return false;
			}
		}, this);
	},

	/**
	 * @description 禁用全部按钮
	 */
	disableAll: function() {
		this.findBy(function(item) { item.disable(); });
		this.tbarItemsArray.forEach(function(item) { item.disable = true; });
	},

	/**
	 * @description 启用按钮
	 * @param { String } 按钮的itemIds
	 * @return { Boolean } 是否成功启用按钮
	 */
	enableItems: function(itemIds) {
		if(!Ext.isArray(itemIds)) itemIds = [itemIds];
		this.findBy(function(item) {
			if(itemIds.isInclude(item.itemId)) {
				this.getTbarItem(item.itemId).disable = false;
				item.enable();
				return true;
			}else {
				return false;
			}
		});
	},

	/**
	 * @description 启用全部按钮
	 */
	enableAll: function() {
		this.findBy(function(item) { item.enable() });
		this.tbarItemsArray.forEach(function(item) { item.disable = false; });
	},

	getButtonByItemId: function(itemId) {
		return this.findBy(function(item) {
			return item.itemId === itemId;
		})[0];
	},

	/**
	 * @description 通过itemIds隐藏按钮
	 * @param { Array or String } itemIds
	 * @return { Boolean } 是否隐藏成功
	 */
	hideButtonByItemId: function(itemIds) {
		if(!Ext.isArray(itemIds)) itemIds = [itemIds];
		this.findBy(function(item) {
			if(itemIds.isInclude(item.itemId)) {
				item.hide();
				return true;
			}else {
				return false;
			}
		}, this);
	},

	/**
	 * @description 通过itemIds显示按钮
	 * @return { Boolean } 是否成功显示按钮
	 * @param { Array or String } itemIds
	 */
	showButtonByItemId: function(itemIds) {
		if(!Ext.isArray(itemIds)) itemIds = [itemIds];
		this.findBy(function(item) {
			if(itemIds.isInclude(item)) {
				item.show();
				return true;
			}else {
				return false;
			}
		}, this);
	},
	/**
	 * @description 隐藏所有按钮
	 */
	hideAll: function() {
		this.findBy(function(items) { item.hide(); });
		this.tbarItemsArray.forEach(function(item) { item.hide = true; });
	},

	/**
	 * @description 重置按钮方法
	 * @param { Array or String, Function, Object } 1.itemIds 2.按钮方法 3.作用域
	 */
	resetHandler: function(itemIds, handler, scope) {
		if(!Ext.isArray(itemIds)) itemIds = [itemIds];
		this.findBy(function(item) {
			if(item.itemId === itemIds)
				item.setHandler(handler, scope);
		}, this);
	},

});
