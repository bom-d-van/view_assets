/**
 * @class  Wando.renderer 
 * @description
 *     用于自定义某些渲染的效果<br>
 * 
 * @example
 *     <b>Grid的使用</b><br>
 *         created_at: { renderer: Wando.renderer.disable },<br>
 *         created_at: { renderer: Wando.renderer.displayDate },<br>
 *     <b>其他使用方法一样</b><br>
 **/
Ext.ns("Wando.renderer")

Wando.renderer = {
    /**
     * @description
     *    渲染背景色为灰黑色，一般在不可编辑元素使用<br>
     *    参数一般不用写
     * @return   value 
     */
    disable: function(value, metaData) {
        metaData.attr = "style='background-color: #e1e2e4'";
        return value;
    },

    /**
    * @description
    *     渲染为红色，一般在某些重要元素使用,例如不能为空<br>
    *     参数一般不用写
    * @return   value 
    */
    necessary: function(value) {
        if(!value) 
            return "<div style='color:RGB(255,0,0)'>*</div>";
        else 
            return value;
    },

    /**
     * @param string(combobox id, require)
     * @return void
     * @description
     *     这个函数是用于解决combobox在grid中的渲染问题的,在renderer中传入
     *     这个函数可避免这个问题
     */
    displayComboValue: function(comboId) { 
        var combo = Ext.getCmp(comboId);
        return function(value) {
            var record = combo.findRecord(combo.valueField, value);
            return record ? record.get(combo.displayField) : combo.valueNotFoundText;
        };
    },

    dateFormat: "Y-m-d",
    /**
     * @description
     *    date renderer configes
     *    这里不能使用 format 函数，因为 value 可能是字符串
     * @return   date 
     */
    displayDate: function(value) { 
        return Ext.util.Format.date(value, Wando.renderer.dateFormat);
    },
    
    getDateFormat: function() { 
        return Wando.renderer.dateFormat;
    },
    
    /**
    * @description
    *   For showing tips to display the value of a column
    * @return    data
    */
    showTipsForEaseLooking: function(data, metadata, record) {
        if(Ext.isArray(data) && data.length) {
            var tips = "ext:qtip = '";
            data.forEach(function(item) {
                tips += (item + ", ");
            });
            tips = tips.slice(0, tips.length - 2);
            tips += "'";
            metadata.attr = tips;
        }
        return data;
    },
    
    empty: function(data, metadata, record) {
        return Ext.isEmpty(data) ? " -- " : data;
    },
    
    /**
    * @description
    *   Span rows that have the same value in a specified column
    * @return data || ''
    */
    rowSpanning: function (v, meta, r, rowIndex, colIndex, s) {
        // Get dataindex 
        var dataIndex = s.fields.keys[r.json.indexOf(v)];
        
        // renderer row spanning effect
        var first = !rowIndex || v !== s.getAt(rowIndex - 1).get(dataIndex),
            last = rowIndex >= s.getCount() - 1 || v !== s.getAt(rowIndex + 1).get(dataIndex);
        meta.css += 'row-span' + (first ? ' row-span-first' : '') +  (last ? ' row-span-last' : '');
        if (first) {
            var i = rowIndex + 1;
            while (i < s.getCount() && v === s.getAt(i).get(dataIndex)) {
                i++;
            }
            var rowHeight = 20, padding = 6,
                height = (rowHeight * (i - rowIndex) - padding) + 'px';
            meta.attr = 'style="height:' + height + ';line-height:' + height + ';"';
        }
        return first ? v : '';
    }
};
