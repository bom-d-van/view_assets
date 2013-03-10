Ext.ns("Wando.materialAttributes")

Wando.materialAttributes.index = {

    init: function() {
        this.tabPanel = this.createTab();
        Wando.mainPanel = Ext.create("Ext.Panel", {
            layout: "border",
            items: this.tabPanel
        });
    },

    createTab: function() {
        return Ext.create("Ext.tab.Panel", {
            region: "center",
            defaultVanCorrect: { layout: "fit" },
            items: [
                this.getGrid("color", "颜色管理", "颜色名称"),
                this.getGrid("count", "支数管理", "支数名称"),
                this.getGrid("variety", "品种管理", "品种名称"),
                this.getGrid("ingredient", "成分管理", "成分名称")
            ]
        });
    },

    getGrid: function(which, title, name) {

        var rowEditing = Ext.create('Ext.grid.plugin.RowEditing', {
            pluginId:'rowEditing',
            saveBtnText: '保存',
            cancelBtnText: "取消",
            autoCancel: false,
            clicksToEdit: 2
        });

        rowEditing.on('afteredit', function() {
            var record = Ext.getCmp(which).getSelectionModel().getSelection();
            var mName = record[0].get("name");
            var mId = record[0].get("id");
            var created_at = record[0].get("created_at");
            function trim(str) {
                return str.replace(/(^\s+)|(\s+$)/g, "");
            };
            if(trim(mName) != "") {
                if( created_at == "") {
                    Ext.Ajax.request({
                        url: "/material_attributes/save_material_attributes.json",
                        method: "post",
                        params: { name: mName, mtype: which },
                        success: function() {
                            Ext.getCmp(which).getStore().load();
                            Wando.msg.info("提示", "操作成功" );
                        },
                        failure: function() {
                            Wando.msg.error("错误", "操作失败");
                        }
                    });
                }else{
                    Ext.Ajax.request({
                        url: "/material_attributes/update_material_attributes.json",
                        method: "post",
                        params: { name: mName, mtype: which, mId: mId },
                        success: function() {
                            Ext.getCmp(which).getStore().load();
                            Wando.msg.info("提示", "操作成功" );
                        },
                        failure: function() {
                            Wando.msg.error("错误", "操作失败");
                        }
                    })
                }
            }else{
                Ext.Msg.alert("提示", "请输入" + name)
            }
        });

        var cm = [
            { header: name, dataIndex: "name", editor: { xtype: "textfield" } },
            { header: "创建日期", dataIndex: "created_at", xtype:"datecolumn", format:"Y-m-d" },
            { header: "修改日期", dataIndex: "updated_at", xtype:"datecolumn", format:"Y-m-d" }
        ];

        var store = Ext.create("Ext.data.JsonStore", {
            fields: ["id", "name", "created_at", "updated_at"],
            autoLoad: true,
            proxy: {
                type: "ajax",
                method: "post",
                url: "/material_attributes/get_material_attributes_grid.json",
                extraParams: { mtype: which },
                reader: { type: "json", root: which }
            }
        });

        var tbar = Ext.create("Wando.Tbar", {
            gridId: which,
            using: ["add", "delete"],
        		whenDelete: {
        			  handler: function() {
                    var r = Ext.getCmp(which).getSelectionModel().getSelection()[0];
                    if(r != undefined) {
                        Ext.Msg.confirm("请确认", "确定要删除该记录？",
                            function(btn) {
                                if(btn == "yes") {
                                    var mId = r.get("id");
                                    Ext.Ajax.request({
                                        url: "/material_attributes/delete_material_attributes.json",
                                        method: "post",
                                        params: { mId: mId, mtype: which },
                                        success: function() {
                                            Ext.getCmp(which).getStore().load();
                                            Wando.msg.info("提示", "操作成功" );
                                        },
                                        failure: function() {
                                            Wando.msg.error("错误", "操作失败");
                                        }
                                    });
                                }
                            }
                        )
                    }else{
                        Ext.Msg.alert("提示", "请选择要删除的记录");
                    }
                }
        		}
        });

        return Ext.create("Ext.grid.GridPanel", {
            id: which,
            title: title,
            forceFit: true,
            frame: true,
            store: store,
            columns: cm,
            tbar: tbar,
            plugins: [rowEditing],
   //         plugins: [ Ext.create("Ext.grid.plugin.CellEditing", { clicksToEdit: 1 }) ]
        });

    }
};
