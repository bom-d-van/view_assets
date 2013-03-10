/**
 * @class Array
 * 对 Js Array 的拓展
 */
Ext.ns("Wando.util");
Ext.apply(Array.prototype, { 
    
    /**
     * 去除重复元素
     *      var foo = [1,2,2];
     *      foo.uniq(); // ==> [1,2]
     * @return {Array} 唯一化后的数组
     */
    uniq: function() { 
        var i, j;
        for(i = 0; i < this.length; i++) { 
            for(j = i + 1; j < this.length; j++) { 
                if(this[i] === this[j]) { 
                    this.splice(j, 1);
                    j--;
                };
            };
        };
        return this;
    },
    
    /**
     * 是否包含某个元素
     *      var foo = [1,2,2];
     *      foo.isInclude(1); // ==> true
     * @return {Boolean} 判断结果
     */
    isInclude: function(value) { 
        return (this.indexOf(value) === -1) ? false : true;
    },
    
    /**
     * 数组是否为空(类似这种方法的设计是为了是代码语意化更强)
     *      var foo = [1,2,2];
     *      foo.isEmpty(); // ==> false
     * @return {Boolean} 判断结果
     */
    isEmpty: function() { 
        return !this.length;
    },
    
    /**
     * 数组是否不为空
     *      var foo = [1,2,2];
     *      foo.isNotEmpty(); // ==> true
     * @return {Boolean} 判断结果
     */
    isNotEmpty: function() { 
        return !!this.length;
    },
    
    // flatten: function () {
    //     var flat = [];
    //     for (var i = 0, l = this.length; i < l; i++){
    //         var type = Object.prototype.toString.call(this[i]).split(' ').pop().split(']').shift().toLowerCase();
    //         if (type) { flat = flat.concat(/^(array|collection|arguments|object)$/.test(type) ? flatten.call(this[i]) : this[i]); }
    //   }
    //     return flat;
    // }
});


/**
 * @class Number
 * 对 Js Number 的拓展
 */
Ext.apply(Number.prototype, { 
    /**
     * 类似于 Ruby 的 times 方法，循环执行函数
     *      10.times(function(i) {
     *          console.log(i);
     *      })
     * @param {Function} [handler] 循环函数
     * @param {Object} [scope] 函数的作用域
     */
    times: function(handler, scope) { 
        var r = [];
        if(!scope) { 
            for(var i = 0; i < this; i++) { 
                r.push(handler(i, this));
            }
        } else { 
            for(var i = 0; i < this; i++) { 
                r.push(handler.call(scope, i, this));
            }
        }
        return r;
    }
});

/**
 * @class Wando.util
 * 封装了一些常用的一些拓展方法
 */
Wando.util = {
    /**
     * 克隆一个 Js 对象
     *      // Before
     *      var obj1 = { p: "obj1.p" };
     *      var obj2 = obj1;
     *      console.log(obj1.p);  // => "obj1.p"
     *      console.log(obj2.p);  // => "obj1.p"
     *      obj2.p = "obj2.p";
     *      console.log(obj1.p);  // => "obj2.p"
     *      console.log(obj2.p);  // => "obj2.p"
     *      // After
     *      var obj1 = { p: "obj1.p" };
     *      var obj2 = Wando.util.clone(obj1);
     *      console.log(obj1.p);  // => "obj1.p"
     *      console.log(obj2.p);  // => "obj1.p"
     *      obj2.p = "obj2.p";
     *      console.log(obj1.p);  // => "obj1.p"
     *      console.log(obj2.p);  // => "obj2.p"
     * @param {Object/Array/..} [obj] 被复制对象
     * @return {Object/Array/..} [obj] 复制对象
     */
    clone: function(obj) {
        var newObj;
        if(Ext.isArray(obj)) {
            newObj = obj.map(function (e) {
                return this.clone(e);
            }, this);
        }
        else if(Ext.isDate(obj))
            newObj = new Date(obj);
        else if(Ext.isObject(obj))
            newObj = this.cloneObj(obj);
        else
            newObj = obj;
        return newObj;
    },
    
    /**
     * clone 方法的内部使用函数
     * @protected
     * @param {Object/Array/..} [params] 需要字符串化的对象
     * @return {String} [urlParams] 字符串化结果
     */
    notCloningZone: 'scope',
    cloneObj: function(obj) {
        var newObj = {};
        for(p in obj) {
            if (this.notCloningZone.isInclude(p))
                newObj[p] = obj[p];
            else if (obj.hasOwnProperty(p))
                newObj[p] = this.clone(obj[p]);
        };
        return newObj;
    },
    
    /**
     * 将对象转化成字符串，用于发送 GET 请求时嵌入参数，连接在 URL 后
     * <font color="red">注意不能函数不支持嵌套对象，即对象的属性值不能也为一个对象，只能是基本数据类型：String, Number 等</font>
     *      params = { a: 1, b: 2 };
     *      Wando.util.urlStringize(params);  // ==> "?a=1&b=2"
     * @param {Object/Array/..} params 需要字符串化的对象
     * @return {String} urlParams 字符串化结果
     */
    urlStringize: function(params) { 
        var urlParams = '?';
        if(params instanceof Object) { 
            for(i in params) { 
                if(params.hasOwnProperty(i))
                    urlParams += i + '=' + params[i] + '&';
            };
            urlParams = urlParams.substring(0, urlParams.length - 1); // 去除z最后一个 '&'
        } else if(!params)
            urlParams = '';
        else
            urlParams += params;
        return urlParams;
    },
    
    /**
     * 创建作用域
     * @author Eric
     * @param {Object} scope 作用域
     * @return {Function} fun 作用函数
     */
    createScope: function(scope, fun) {
        return fun.createDelegate(scope);
    },

    /**
     * <font color="red">仅用于调试代码</font>  
     * 将传入这个函数的参数打印在控制台上，同时将所有参数赋值在全局变量中，支持无限参数
     * 作用不大，带有个人喜好  
     *      Wando.util.test(a, b, c);
     *      // 在 console 中会输出 a, b, c;
     *      // 同时可以通过 Wando.foo1, Wando.foo2, Wando.foo3 直接获取 a, b, c 参数
     * @author Van
     * @param {Object} [obj1] 参数1
     * @param {Object} [..] 参数1
     */
    test: function() {
        for(var i = 0, l = arguments.length; i < l; i++) {
            c.l(arguments[i]);
            Wando["foo" + i] = arguments[i];
        }
    },

    /**
     * Used to judge blank obj.  
     * 如果是 Ext 组件, 建议使用 Ext 已封装好的方法。
     * @author liwen 2012-4-18
     * @param {Object} scope 作用域
     * @return {Boolean} 判断结果
     */
    isBlankObj : function(obj) { 
        for ( var name in obj ) return false; 
        return true; 
    },
    
    isLike: function(obj1, obj2) {
        var like = true;
        Ext.iterate(obj1, function (k, v) {
            if (obj2[k] != v) like = false;
        });
        return like;
    },

    /**
     * @author ZhuDongqiao
     *用来获取已经格式化后的数据
     *像form里的datefield，可能显示的数据可以按'Y-m-d'格式显示，但取出的数据是Date的原始数据，这是将取出的数据用dataFormat()去格式化一下，就可以获得与显示一样的'Y-m-d'格式的日期
     *@return 'Y-m-d'格式的日期
     */
    dateFormat: function(value) { 
        if(value != null) { 
            return Ext.Date.format(new Date(value),'Y-m-d');
        }else{ 
            return null;
        }
    }
    
};

// a shortcut for console.log function
c = console;
c.l = c.log;
w = Wando;
w.t = Wando.util.test;
Ext.applyIf(Wando, Wando.util);
