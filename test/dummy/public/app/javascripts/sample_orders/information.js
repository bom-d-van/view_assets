Ext.ns("Wando.sampleOrders");
Wando.sampleOrders.information = {

    init: function() {
        this.mainPanel = this.createGridPanel();
        this.indexPanel = this.createIndexPanel();
        Wando.mainPanel = Ext.create("Ext.Panel", {
            layout: 'border',
            items: [this.mainPanel, this.indexPanel]
        });
    },

    createGridPanel: function() {
        Ext.define('Storage', {
            extend: 'Ext.data.Model',
            fields: ('customer cardNum orderNum part fabric craft yarn_length').split(' ')
        });

        var store = Ext.create('Ext.data.Store', {
            model: 'Storage',
            autoLoad: true,
            data: []
        });

        return Ext.create('Ext.grid.Panel', {
            title: '部位信息',
            region: 'center',
            id: 'clothPartInfo',
            region: 'center',
            columns: [new Ext.grid.RowNumberer(), {
                header: '卡号',
                dataIndex: 'cardNum',
            },
            {
                header: '部位',
                dataIndex: 'part',
            },
            {
                header: '纱支',
                dataIndex: 'yarn',
            },
            {
                header: '颜色',
                dataIndex: 'color',
            },
            {
                header: '品种',
                dataIndex: 'type',
            },
            {
                header: '工艺',
                dataIndex: 'craft',
            }],
            //selModel: Ext.create('Ext.selection.CheckboxModel'),
            forceFit: true,
            store: store,
            tbar: [{
                xtype: 'button',
                text: '添加'
            },
            {
                xtype: 'button',
                text: '删除'
            },
            {
                xtype: 'button',
                text: '删除全部'
            }]
        });
    },

    createIndexPanel: function() {
        Ext.define('ProcessingTask', {
            extend: 'Ext.data.Model',
            fields: ['customer', 'order', 'color']
        });

        var processingTaskStore = Ext.create('Ext.data.Store', {
            model: 'ProcessingTask',
            autoLoad: true,
            data: []
        });

        return Ext.create('Ext.panel.Panel', {
            title: '制单列表',
            region: 'west',
            width: 350,
            layout: {
                type: 'accordion',
                animate: true
            },
            items: [Ext.create('Ext.grid.Panel', {
                title: '未制单',
                layout: 'fit',
                forceFit: true,
                tbar: [{
                    xtype: 'textfield'
                },
                {
                    xtype: 'button',
                    text: 'Search'
                }],
                store: processingTaskStore,
                columns: [new Ext.grid.RowNumberer(), {
                    header: '客户',
                    dataIndex: 'customer'
                },
                {
                    header: '制单',
                    dataIndex: 'order'
                },
                {
                    header: '颜色',
                    dataIndex: 'color'
                }]
            }), {
                title: '已制单',
                layout: 'fit',
                tbar: [{
                    xtype: 'textfield'
                },
                {
                    xtype: 'button',
                    text: 'Search'
                }]
            }]
        });
    }
};

