Ext.ns('Wando.workshopReports');
Wando.workshopReports.index = { 
    init: function() { 
        Wando.mainPanel = { 
            layout: 'border',
            items: [this.createForm()]
            };
    },

    createForm: function() { 
        return Ext.create('Ext.form.Panel', {
            title: '板房车间日报表',
            region: 'center',
            height: 120,
            bodyPadding: '30, 0, 0, 40',
            frame: true,
            layout: 'column',
            items: [{
                columnWidth: .45,
                
                xtype: 'fieldcontainer',
                fieldLabel: '操作员',
                items: [{  
                    xtype: 'textfield',
                    width: 120,
                    disabled: true
                }]
            },
            {   
                columnWidth: .45,
                xtype: 'fieldcontainer',
                fieldLabel: '登记日期',
                items: [{ 
                    xtype: 'datefield',
                    width: 120,
                    allowBlank: false,
                    editable: true,
                    value: new Date(),
                    format: 'Y-m-d'
                }]
            },
            { 
                xtype: 'fieldcontainer',
                fieldLabel: '备注',
                items: [{ 
                    xtype: 'textarea',
                    width: 200,
                    height: 60
                }]
            }]
        });
    },

    createGrid: function() { 
        
    }
}
