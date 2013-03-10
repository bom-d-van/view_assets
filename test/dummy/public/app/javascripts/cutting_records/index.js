Ext.ns("Wando.cuttingRecords");
Wando.cuttingRecords.index = { 

    init: function() { 
        this.form = this.createForm();
        this.grid = this.createGrid();
        this.panel = this.createPanel();
        Wando.mainPanel = Ext.create('Ext.Panel', { 
            layout: 'border',
            items: [this.panel]
         });
     },

     createForm: function() { 
         return Ext.create('Ext.form.Panel', { 
             id: 'form',
             bodyPadding:'30 0 0 40',
             labelAlign: 'left',
             labelWidth: 100,
             frame: true,
             height: 120,
             region: 'north',
             layout: 'column',
             items: [{ 
                 xtype: 'fieldcontainer',
                 columnWidth: .45,
                 fieldLabel: '操作员',
                 items: [{ 
                     id: 'employee_name',
                     xtype: 'textfield',
                     width: 120,
                     disabled: true
                 }]
             },
             { 
                 xtype: 'fieldcontainer',
                 columnWidth: .45,
                 fieldLabel: '登记日期',
                 items: [{ 
                     id: 'report_date',
                     xtype: 'datefield',
                     width: 120,
                     value: new Date(),
                     format: 'Y-m-d',
                     allowBlank: false,
                     editable: true
                }]
             },
             { 
                 xtype: 'fieldcontainer',
                 fieldLabel: '备注',
                 items: [{ 
                     id: 'remark',
                     xtype: 'textarea',
                     width: 200,
                     height: 60
                 }]
             }]
        });
     },
        
     createGrid: function() { 
         Ext.define('MyRecord', { 
             extend: 'Ext.data.Model',
             fields: ['group']
         });
         Ext.define('Record', { 
             extend: 'Ext.data.Model',
             fields: [ 'group', 'customer', 'number', 'cutting_process', 'quantity' ]
         });
         var data = [['A组']];
         var cm = [
                 {   text: '组别', dataIndex: 'group', name: 'group'},
                 {   text: '客户', dataIndex: 'customer',name: 'customer', editor: rowEditing},
                 {   text: '款号', dataIndex: 'number', name: 'number', editor: rowEditing},
                 {   text: '裁床工序', dataIndex: 'cutting_process', name: 'cutting_process', editor: rowEditing},
                 {   text: '件数', dataIndex: 'quantity', name: 'quantity', editor: rowEditing}
             ];
         var store = Ext.create('Ext.data.Store', { 
             model: 'Record',
             data: data,
             groupField: 'group',
             sortInfo: { 
                 field: 'group',
                 direction: 'ASC'
             }
         }); 

         var rowEditing = Ext.create('Ext.grid.plugin.RowEditing', { 
             clicksToMoveEditor: 1,
             autoCancel: false
         });

         var row = [];
         return Ext.create('Ext.grid.Panel', { 
             title: '分组信息',
             region: 'center',
             autuScroll: true,
             forceFit: true,
             store: Ext.data.StoreManager.lookup('RecordStore'),
             features: [{ ftype: 'grouping' }],
             columns: cm,
             listeners: {
                 afteredit: function(e) {
                     if (!row.isInclude(e.record)) {
                         row.push(e.record);
                         p = new MyRecord({
                         group: e.record.data.group,
                         });
                         e.grid.getStore().insert(e.row + 1, p)
                      }
                 }
              } 
         });
    },

     createPanel: function() { 
         return Ext.create('Ext.panel.Panel', { 
             id: 'cutting_panel',
             title: '板房裁床日报表',
             region: 'center',
             layout: 'border',
             tbar: Ext.create('Ext.toolbar.Toolbar', { 
                 items: [{ 
                     text: '保存' + '(<span style="text-decoration:underline">' + 'S' + '</span>)',
                      iconCls: Wando.icons.save,
                      handler: function() { 
                          Wando.msg.info("提示", "日报表填写成功", (function() { 
                     window.location = window.location})());
                 }
                 }]
             }),
             items: [this.form, this.grid]
         });
     }
}
