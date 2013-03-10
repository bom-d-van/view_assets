Ext.ns('Wando.cuttingRecords');
Wando.cuttingRecords.cuttingCalculate = { 

    init: function() { 
        Wando.mainPanel = Ext.create('Ext.Panel', {   
            layout: 'border',
            items: [this.createIndexPanel(), this.createGrid()]
        });
    },
        
    createIndexPanel: function() {
        Ext.define('ProcessingTask', {
            extend: 'Ext.data.Model',
            fields: ['date']
        });

        var processingTaskStore = Ext.create('Ext.data.Store', {
            model: 'ProcessingTask',
            autoLoad: true,
            data: [["2013-01-01"],["2013-01-02"]]
        });

        return Ext.create('Ext.panel.Panel', {
            title: '分类索引',
            region: 'west',
            width: 350,
            layout: {
                type: 'accordion',
                animate: true
            },
            items: [Ext.create('Ext.grid.Panel', {
                title: 'A组',
                layout: 'fit',
                forceFit: true,
                store: processingTaskStore,
                tbar: [{
                    xtype: 'textfield'
                },
                {
                    xtype: 'button',
                    text: 'Search',
                    iconCls: Wando.icons.query 
                }],
                columns: [{ header: '日期', dataIndex: 'date' }]
            })
        ]
        });
    },
        
    createGrid: function() { 
        var grid = Ext.create('Ext.grid.Panel', {
            id: 'cutting_grid',
            title: '板房裁床',
            region: 'center',
            autoScroll: true,
            forceFit: true,
            store: Ext.data.StoreManager.lookup('simpsonsStore'),
            columns: [
                { text: '日期',  dataIndex: '' },
                { text: '单价', dataIndex: '' },
                { text: '件数', dataIndex: '' },
                { text: '总价', dateIndex: '' }
            ],
            tbar: Ext.create('Wando.Tbar', { 
                defaultScope: this,
                using:['print'],
                extraItems: [{
                    text: '计件工资',
                    iconCls: Wando.icons.calculator,
                    handler: function(){
                          //    this.createCalculateWin().show()
                    }
                }]
            }) 
        });

        return grid
  
    }
}
