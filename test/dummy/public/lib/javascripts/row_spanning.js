/**
 * This is grid feature for enabling row spanning effect in a common grid panel. It is done with adding some renderers and twist the original grid css.
 * 
 * Usage
 * 
 * In your js manifest file:
 * 
 * 	//= require_lib row_spanning
 * 	
 * In your css manifest file:
 * 
 * 	/*= require_lib row_spanning *／
 * 	
 * How to configure:
 * 
 * 	Ext.create('Ext.grid.Panel', {
 * 		id: 'myGridWithRowSpanning',
 * 		store: Ext.create('Ext.data.Store', {
 * 			fields: ["id", "customer", "number"]
 * 		}),
 * 		features: [Ext.create('Wando.RowSpanning', {
 * 			independences: ['customer'],
 * 			dependences: {
 * 				number: 'customer'
 * 			}
 * 		})]
 * 	});
 * 	
 * Explanation:
 * 
 * * `independences`: 是一个数组，用于配置独立的 rowSpanning。所谓独立的单元格就是指只要上下相邻的两个单元格只要数值相等，就会合并。该数组的每个元素是其对应单元格的 dataIndex 字符串。
 * * `dependences`: 是一个 hash，用于配置依赖的 rowSpanning。依赖指的是单元格在上下合并时需要考虑其依赖的单元格是否相同。如果上下值相等的两个单元格，但是其依赖的单元格值不同，他们也不会合并起来。配置的格式是 {需要合并的 dataIndex：依赖的 dataIndex}（可配置多个）。
 * 
 * 下面是一个例子：
 * 
 *     @example
 *     var fields = ["id", "customer", "number", "cloth_number"];
 *        
 *     Ext.define('Order', {
 *         extend: 'Ext.data.Model',
 *         fields: fields
 *     });
 *        
 *     var myStore = Ext.create('Ext.data.Store', {
 *         model: 'Order',
 *         data: [
 *             ["093A-1", "爱普苹果", "CY2016", "CT12SSZ392"],
 *             ["002B", "杰欧里顿", "CY2018", "CT12SSH442"],
 *             ["002B", "杰欧里顿", "CY2018", "CT12SSH442"],
 *             ["002B", "杰欧里顿", "CY2019", "CT12SSH368"],
 *             ["002B", "杰欧里顿", "CY2020", "CT12SSH4102"],
 *             ["002B", "杰欧里顿", "CY2020", "CT12SSH4103"],
 *             ["002B", "杰欧里顿", "CY2020", "CT12SSH4103"],
 *             ["002B", "杰欧里顿2", "CY2020", "CT12SSH4103"],
 *             ["002B", "杰欧里顿2", "CY2020", "CT12SSH4103"],
 *             ["002B", "杰欧里顿2", "CY2020", "CT12SSH4103"],
 *             ["002B2", "杰欧里顿2", "CY2018", "CT12SSH442"],
 *             ["002B2", "杰欧里顿2", "CY2018", "CT12SSH442"],
 *             ["101A", "景晖", "CY2011", "8012010122-01"]
 *         ]
 *     });
 *                
 *     Ext.create('Ext.grid.Panel', {
 *         store: myStore,
 *         id: "grid",
 *         title: '详情',
 *         features: [Ext.create('Wando.RowSpanning', {
 *             spanningId: 'id',
 *             independences: ['id'],
 *             dependences: {
 *                 customer: 'id',
 *                 number: 'customer',
 *                 cloth_number: 'customer'
 *             }
 *         })],
 *         renderTo: Ext.getBody(),
 *         columnLines: true,
 *         columns: [{
 *             header: "序号",
 *             dataIndex: "id"
 *         }, {
 *             header: "客户",
 *             dataIndex: "customer"
 *         }, {
 *             header: "制单号",
 *             dataIndex: "number"
 *         }, {
 *             header: "我司款号",
 *             dataIndex: "cloth_number"
 *         }, {
 *             header: "工艺",
 *             dataIndex: "craft",
 *             width: 250
 *         }]
 *     });
 */
Ext.define('Wando.RowSpanning', {
    extend: 'Ext.grid.feature.Feature',
    alias: 'feature.rowspanning',

    init: function() {
        // TODO: add a listener for sorting data with spanningId on store
        // if (this.spanningId) { this.grid.store.sort(this.spanningId); }
        // if (this.spanningId && this.independences.indexOf(this.spanningId) != -1) { this.independences.push(this.spanningId); }
        
        /**
         * @cfg {Array} independences
         *
         * 用于配置独立的 rowSpanning。所谓独立的单元格就是指只要上下相邻的两个单元格只要数值相等，就会合并。该数组的每个元素是其对应单元格的 dataIndex 字符串。
         */
        /**
         * @cfg {Object} dependences
         *
         * 用于配置依赖的 rowSpanning。依赖指的是单元格在上下合并时需要考虑其依赖的单元格是否相同。如果上下值相等的两个单元格，但是其依赖的单元格值不同，他们也不会合并起来。配置的格式是 {需要合并的 dataIndex：依赖的 dataIndex}（可配置多个）。
         */
        if (this.independences && this.independences.length) { 
            this.independences.forEach(function(field) {
                this.dependences[field] = null;
            }, this);
        }
        
        // add extra stylesheet
        this.grid.addCls('grid-row-span');
        
        // equip each targeted column with renderer
        this.grid.columns.forEach(function(col) {
            if (this.dependences[col.dataIndex] || this.independences.indexOf(col.dataIndex) != -1) {
                col.renderer = this.genRenderer(col.renderer);
            };
        }, this);
    },
    
    genRenderer: function(oldRenderer) {
        var spanner = this;
        
        return function (v, meta, r, rowIndex, colIndex, s) {
            var dataIndex = s.model.getFields()[colIndex].name,
                startf = spanner.isStart(dataIndex, rowIndex),
                endf = spanner.isEnd(dataIndex, rowIndex);
            
            meta.tdCls += 'row-span' + (startf ? ' row-span-first' : '') +  (endf ? ' row-span-last' : '');
            
            var spanningPrefix = '',
                spanningPostfix = '';
            if (startf) {
                spanningPrefix = "<div style='position: absolute; margin-top: " + spanner.getSpanningHeight(dataIndex, rowIndex) + "px;'>";
                spanningPostfix = "</div>";
            }
            
            // handle return with old renderer
            if (startf) {
                var value = oldRenderer ? oldRenderer.apply(this, arguments) : v;
                
                return spanningPrefix + value + spanningPostfix;
            } else {
                return '';
            }
        };
    },
    
    isStart: function(field, rowIndex) {
        // the first row in the grid
        if (!rowIndex) { return true; }
        
        // depended field coordination
        var record = this.grid.store.getAt(rowIndex),
            dependedField = this.dependences[field];
        
        if (dependedField && this.isStart(dependedField, rowIndex)) { return true; }
        
        var previousRecord = this.grid.store.getAt(rowIndex - 1),
            hasSameParent = (!dependedField || record.get(dependedField) !== previousRecord.get(dependedField)),
            hasSameValue = (record.get(field) !== previousRecord.get(field));
        
        return !dependedField ? hasSameValue : (hasSameParent || hasSameValue);
    },
    
    isEnd: function(field, rowIndex) {
        var store = this.grid.store;
        if (rowIndex >= store.getCount() - 1) { return true; }
        
        var record = store.getAt(rowIndex),
            dependedField = this.dependences[field];
        
        if (dependedField && this.isEnd(dependedField, rowIndex)) { return true; }
        
        var nextRecord = store.getAt(rowIndex + 1),
            hasSameParent = (!dependedField || record.get(dependedField) !== nextRecord.get(dependedField)),
            hasSameValue = (record.get(field) !== nextRecord.get(field));
        
        return !dependedField ? hasSameValue : (hasSameParent || hasSameValue);
    },
    
    getSpanningHeight: function(field, rowIndex) {
        var nextRow = rowIndex + 1,
            store = this.grid.store,
            dependedField = this.dependences[field];
        if (!this.isEnd(field, rowIndex)) { 
            while (!this.isEnd(field, nextRow)) { nextRow++; }
            nextRow++;
        }
                
        var rowHeight = 20, padding = 10;
        return (rowHeight * (nextRow - rowIndex) / 2  - padding);
    }
});