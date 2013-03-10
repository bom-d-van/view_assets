//= require_vendor string.min

/**
 * ## Javascript Uni-Page-Entry
 * 
 * 要理解什么是 **Uni-Page-Entry**，首先需要理解什么是 Namespace 以及 Wando.mainPanel。
 * 
 * ### Namespace
 * 
 * 对于命名空间的使用，创意项目不同于 Wando3，不要求统一在一个地方声明（Wando3 是在一个名为 `wando.js` 的文件中统一定义命名空间的）。我们需要用的时候就去声明。使用如下的方法 `Ext.ns('Wando.my.namespace')`。
 * 
 * 虽然没有声明限制，但是许多情况下建议还是使用接下来描述的约定去定义命名空间－－**即以每个页面对应的 controller 为二级命名空间，以其对应的 action 为三级命名空间**。一般**不建议使用太深**的命名空间。三级就可以满足大部分开发需求了。
 * 
 * ### Wando.mainPanel
 * 
 * #### What is a `Wando.mainPanel`?
 * 
 * 这个 `mainPanel` 的提出是有历史原因的。因为在我们实验室开发的许多基于 Extjs 的 web 程序中，我们都没有使用默认的 Extjs 的菜单去构造菜单（虽然那样很方便也更容易开发，但是历史已经成为历史），为了保证 `menu` 不被 Ext 的 `Panel` 覆盖，经过不断的开发和总结，我们使用了 `Ext.Viewport` 来解决这个问题。这样又带来另外一个问题，那就是如何将我们创建好的 `Panel` 渲染在页面中呢，当我们在 `application.html.erb`（这种是 Wando3 的处理方法，在创意项目中，我是将类似的定义声明在 `/public/lib/javascript/wando.js` 中） 中写了下面的代码的时候：
 * 
 * 	<script type='text/javascript'>
 * 		Ext.onReady(function() {
 * 			Ext.create('Ext.Viewport', {
 * 				layout: 'border',
 * 				items: [Wando.menuPanel, Wando.centerPanel]
 * 			});
 * 		});
 * 	</script>
 * 	
 * `Wando.menuPanel` 就是我们用来给 menu 菜单占位的面板。`Wando.centerPanel`是一个 `region` 值为 `center` 的一个普通 `Ext.Panel`。
 * 
 * 答案不难想象，就是对 Wando.centerPanel 赋值，将每个页面需要需然的主面板赋值给 `Wando.centerPanel`。而这个 `Wando.centerPanel` 在 Wando3 中叫做 `Wando.pages.currentInstance`，在创意项目中叫做 `Wando.mainPanel`。
 * 
 * 为什么要改名字？因为 `Wando.mainPanel` 的语意更强，而且可以少敲记下键盘。而且，它读起来很顺口。
 * 
 * #### How to use it?
 * 
 * 使用方法很简单，将面板的值赋给它就行了。
 * 
 * 	// It can be a simpel Object literal
 * 	Wando.mainPanel = { title: 'my silly panel' };
 * 	
 * 	// it can be a Ext.panel.Panel
 * 	Wando.mainPanel = Ext.create('Ext.panel.Panel', { title: 'my another silly panel' });
 * 	
 * 	// it can also be a Ext.grid.GridPanel
 * 	Wando.mainPanel = Ext.create('Ext.grid.GridPanel', { title: 'my silly grid' });
 * 
 * ### Uni-Page-Entry(Wando.:controller:action.init())
 * 
 * What is Uni-Page-Entry?
 * 
 * Uni-Page-Entry 其实指的就是我们定义的统一的 js 程序入口。
 * 
 * 使用原生的 Ext 开发方法，大部分情况下，我们都需要为每个页面使用与下面类似的方法初始化程序：
 * 
 * 	Ext.onReady(function() {
 * 		// create panel or do whatever you want as long as it is legal
 * 	});
 * 
 * 这个结合我们在对 `Wando.mainPanel` 的实现，其实我们可以少敲记下键盘，同时为了更好的方便其它开发人员为不是自己的开发的程序调试、debug 等，我们统一了每个页面的程序入口。即统一每个页面都会自动调用 `Wando.:controller.:action.init()` 这个函数。这个函数就是所谓的 Uni-Page-Entry。
 * 
 * 上面的 `:controller` 和 `:action` 指的就是该 js 所在的页面 controller 以及 actino 的名字。为了能够正确的执行到这个 `Wando.:controller.:action.init` 函数，我们需要使用 `Wando.declare` 定义声明命名空间。格式如下：
 * 
 * 	Wando.declare({
 * 		controller: 'customeControllerName',
 * 		action: 'customeActionName'
 * 	});
 * 
 * 同时为了支持使用默认的 namespace 定义，如果 controller 和 action 的和页面的 url 基本一致，即是和下面所列的规则一样的话，是可以默认不声明 controller 和 action 的：
 * 
 * 	// <page url> => <uni-page-entry>
 * 	'/order_items/show' 			 => 'Wando.orderItems.show'
 * 	'/orders' 						 => 'Wando.orders.index'
 * 	'/order_items/long_action_name'  => 'Wando.orderItems.longActionName'
 * 
 * 但是如果真的有特别需求，需要使用不一样的 uni-page-entry 名字的话，是可以通过 `Wando.declare` 函数解决的。
 * 
 * 另外， `Wando.declare` 函数允许只定义特别的 controller 或者 action 的。即如果只有 action 需要使用特别的名字，则可以像下面一样只定义 action，controller 则仍是按上面的规则自动形成。
 * 
 * 	Wando.declare({
 * 		action: 'myCustomActionName'
 * 	});
 * 
 * 同时，为了更好帮助队友阅读程序，提倡命名空间的定义以及 Uni-Page-Entry 是声明和实现在 [view_assets](http:192.168.1.107/view_assets.html) 的 manifest_file 中。
 * 
 * ### Wando Namespace
 * 
 * 这是一个后来确定的拓展，即每个页面都会有一个默认的命名空间，和上面的描述一样，默认的命名空间是
 * 
 * 	Wando.controller.action
 * 	
 * 有所限制的是，它支持默认的命名空间，如果有特殊要求，如想要使用自定义的 `controller` 和 `action` 名称，则需要自定义命名空间。下面的例子会列举不同情况下的开发方法。
 * 
 * ### 关于 "/" 页面
 * 
 * 在这个页面里，在改版后的约定中，这个页面不会有默认的明明空间，如果没有使用 declare 函数定义 `controller` 和 `action` 也不会自动调用 `Wando.controller.action.init` 函数，即使 `require` 了 `wando.js`。
 * 
 * ### A Typical Program for Each Page
 * 
 * 根据上面的描述，一个典型的创意 Extjs 程序就会像下面例子一样了。
 * 
 * 在只有一个 js 文件情况下的，比如 `/orders` 页面下，只有一个 js 文件（`/public/app/javascripts/orders.js`），在该页面的理想设计是：
 * 
 * 	Wando.orders.index = {
 * 		init: function() {
 * 			Wando.mainPanel = Ext.create("Ext.Panel", {
 * 				title: 'my first panel',
 * 				html: 'something magnificient go here'
 * 			});
 * 		}
 * 	};
 * 
 * 如果有多个页面，比如同样是 /orders/，但是它有多个 js 文件，列表如下：
 * 
 * 	/public/app/javascripts/orders/file1.js
 * 	/public/app/javascripts/orders/file2.js
 * 	
 * 在 `/public/app/javascripts/orders/file1.js`：
 * 
 * 	Ext.apply(Wando.orders.index, {
 * 		init: function() {
 * 			Wando.mainPanel = Ext.create("Ext.Panel", {
 * 				title: 'my first panel',
 * 				html: 'something magnificient go here'
 * 			});
 * 		}
 * 	});
 * 
 * 在 `/public/app/javascripts/orders/file2.js`：
 * 
 * 	Ext.apply(Wando.orders.index, {
 * 		// do whatever you want
 * 	});
 * 	
 * 如果在某个页面你希望有自定义的 controller 和 action，代价就会变大了，需要每个页面一开始都声明该明明空间，然后在使用 `apply` 方法。
 * 
 * 上面提供的建议是系统支持的开发方法，按照约定做可以减少开发难度。但是不一定这个方法就是最好的，有更好的方法就应该使用更好的方法，同时记得把好方法写成文档。
 */

Wando = {
	/**
	 * @property {Ext.Component}
	 * 菜单面板。用于占位，防止菜单被 Ext.Viewport 覆盖。
	 */
	menuPanel: Ext.create('Ext.Component', {
		region: 'north',
		border: false,
		height: 32
	}),
	
	controller: S(''),
	action: S(''),
	
	/**
	 * @property {Object/Ext.Component/Ext.container.Container/Ext.panel.Panel} [mainPanel=null]
	 * 每个页面的主要面板，每个页面的统一 Viewport 入口。
	 */
	mainPanel: null,
	
	/**
	 * @method
	 * @static
	 * Wando 的配置声明函数。用于配置如 controller 或者 action 等变量。
	 * 比如：
	 * 		Wando.declare({
	 * 			controller: 'customeControllerName',
	 * 			action: 'customeActionName'
	 * 		});
	 */
	declare: function(cfg) {
		// make sure Wando.controller and Wando.action is an string.js Object
		if (!cfg.controller || Ext.isString(cfg.controller)) { cfg.controller = S(cfg.controller); }
		if (!cfg.action || Ext.isString(cfg.action)) { cfg.action = S(cfg.action); }
		
		Ext.apply(this, cfg);
	},
	
	/**
	 * @method
	 * @static
	 * 获取当前页面的命名空间字符串
	 *
	 * @return {String}
	 */
	ns: function() {
		return 'Wando.' + this.controller.s + '.' + this.action.s;
	},
	
	/**
	 * @method
	 * @static
	 * 页面的统一入口函数。
	 */
	init: function() {
        if (this.controller.isEmpty() || this.action.isEmpty()) { return; }
		// page controller initialization(每个页面程序逻辑的统一执行入口)
		this[this.controller][this.action].init();
		
		// mainPanel & Viewport initialization
		if (this.mainPanel == null) {throw('You Should Define Wando.mainPanel')};
		this.mainPanel.region = 'center';
		Ext.create('Ext.container.Viewport', {
			layout: 'border',
			items: [this.menuPanel, this.mainPanel],
            listeners: { 
                'afterlayout': function() { 
                    hidden_button_ids.forEach(function(id){ 
                        if (Ext.getCmp(id)) { 
                            Ext.getCmp(id).hide();
                        }
                    });
                }
            }
		});
	},
    
    isOnRoot: function() {
        return window.location.pathname === "/";
    },

    /**
	 * @config
	 * @static
	 * 系统当前用户。
	 */
    user: {}
};

// default setup of Wando Namespace
(function() {
    if (this.isOnRoot()) { return; }
    
	var paths = window.location.pathname.split('/').slice(1),
		controller = paths[0],
		action = paths[1];
			
	if (!controller) { throw "Can't detect controller name, must define Wando.pageNs manually."; };
	if (!action) { action = 'index'; };
			
	// condiction checking again for omitted declarations of controller or action
	this.controller = S(controller).camelize();
	this.action = S(action).camelize();
    
    Ext.ns(Ext.String.format("Wando.{0}.{1}", this.controller, this.action));
}).call(Wando);
