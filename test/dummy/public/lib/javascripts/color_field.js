/**
 * @class Wando.ColorField
 * 对 Ext.form.field.Picker 的拓展,一个可用的拾色器组件。<br />
 * 该组建用于grid下的columns的editor之后，其后必须添加renderer函数，其格式如下面的例子
 * # Example usage
 *     @example
 *     
 *     var grid = Ext.create('Ext.grid.Panel', {
 *     title: 'Simpsons',
 *     store: store,
 *     columns: [
 *         { text: 'Name',  dataIndex: 'name', field: 'textfield' },
 *         { text: 'Email', dataIndex: 'email', flex:1 },
 *         { text: 'Phone', dataIndex: 'phone',
 *           editor: Ext.create('Wando.ColorField', {
 *               renderer: function(value, cellmeta, record, rowIndex, columnIndex) {
 *                   if (value !== undefined){
 *                       var color = "#" + value;
 *                       cellmeta.style = 'background-color: ' + color + '; color: ' + color
 *                   }
 *                   return value;
 *               }
 *           }),
 *         }
 *     ],
 *     selType: 'cellmodel',
 *     plugins: [
 *         Ext.create('Ext.grid.plugin.CellEditing', {
 *             clicksToEdit: 1
 *         })
 *     ],
 *     height: 200,
 *     width: 400,
 *     });
 *
 */

Ext.define('Wando.ColorField', {
    extend:'Ext.form.field.Picker',
    alias:'widget.colorfield',
    requires:['Ext.picker.Color'],
    triggerCls:'x-form-color-trigger',
    createPicker:function () {
        var me = this;
        return Ext.create('Ext.picker.Color', {
            pickerField:me,
            renderTo:document.body,
            floating:true,
            hidden:true,
            focusOnShow:true,
            listeners:{
                select:function (picker, selColor) {
                    me.setValue(selColor);
                    me.setFieldStyle('background:#' + selColor);
                    picker.hide();
                }
            }
        });
    }
});
