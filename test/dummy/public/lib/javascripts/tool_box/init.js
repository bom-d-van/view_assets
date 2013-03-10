// 描述：Wando.toolbox
// Author: Van
// Date: 2012-04-03
// 备注：目前仅约束了前台
// 添加规则:
// #1. 所有 app 的 js 文件都需放在 /public/javascripts/wando/global/toolbox 文件夹中
// #2. 当该 app 有多个文件时，须将该 app 文件放在一个文件夹中
// #3. 每个应用的命名空间都必须是 Wando.toolbox.{appName}，appName 指的是你的应用名字
// #4. appName 在单个 js 文件时必须和该 app 的 js 文件名一致，在多个文件时和该文件夹名一致
// #5. 每个 app 都必须提供两个方法：一个是 init 方法，一个是 launch 方法，init 方法用于初始化 app，launch 方法用于打开 app
//    注意: 这两个方法必须处于 Wando.toolbox.{appName} 的命名空间中，既可以直接这样调用
//    Wando.toolbox.{appName}.init() || Wando.toolbox.{appName}.launch()
// #6. 所有 app 都必须提供一个图标图片，存放地点为 /public/images/wando_tool_box
// #7. 在 app_info.js 文件中配置信息，配置规则如下
//     #a. appCfgs 有四个参数可以配置：@name, @displayName, @icon, @jsFiles(options)
//     #b. 除了 @jsFiles 以外，其他三个参数是必填的，而且 @name 参数不能重复的
//     #c. @name (String) = 该 app 的执行文件名或者文件夹名，即在 #3 中提及的 appName
//     #d. @displayName (String) = 该 app 的显示名
//     #e. @icon (String) = 是该 app 的在 #6 中所添加的图标名(包含后缀名)
//     #f. @jsFiles (Array) = 该 app 所要调用的 js 文件执行列表，按顺序调用，这个参数只用于该 app 包含多个 js 文件时才需要的
Ext.ns("Wando.toolbox")
Wando.toolbox = {
    isInited: false,
    isShowed: false,
    appCfgs: [],
    init: function () {
        this.appDv = this.createAppDV();
        this.self = this.createWin();
        this.isInited = true;
        this.appCfgs.forEach(function (app) { app.isLoaded = false; });
    },
    
    createWin: function() {
        var wtb = Ext.get("wando-tool-box");
        return Ext.create('Ext.Window',{ 
            height: 300,
            width: 320,
            closable: false,
            shadow: false,
            autoScroll: true,
            draggable: false,
            resizable: false,
            layout: "fit",
            bodyStyle: "background-color: white;",
            items: this.appDv,
            x: Ext.getBody().getWidth() - 320,
            y: wtb.getTop() + wtb.getHeight() + 8
        })
    },
    
    createAppDV: function() {
        return new Ext.DataView({
            store: Ext.create('Ext.data.JsonStore',{ 
                autoLoad: true,
                fields: ["name", "displayName", "icon"],
                data: this.appCfgs
            }),
            id: "wandoToolboxDataView",
            cls: "thumb-view",
            multiSelect: true,
            plugins: [ new Ext.ux.DataView.DragSelector() ],
            tpl: new Ext.XTemplate(
        		'<tpl for=".">',
            		'<div class="thumb-wrap" id="{name}" ondblclick="Wando.toolbox.launchApp(\'{name}\')">',
            		    '<div class="thumb"><img src="/lib/images/tool_box/{icon}" title="{displayName}"></div>',
            		    '<span class="app-title">{displayName}</span>',
        		    '</div>',
                '</tpl>',
                '<div class="x-clear"></div>'
        	),
            overClass: "x-view-over",
            itemSelector: "div.thumb-wrap"
        });
    },
    
    launchApp: function(appName) {
        this.appCfgs.forEach(function (appCfg) {
            if (appCfg.name === appName) {
                appCfg.isLoaded ? this[appName].launch() : this.loadAndLaunchApp(appName);
                appCfg.isLoaded = true;
            }
        }, this);
    },
    
    loadAndLaunchApp: function(appName) {
        var cfg = this.getSpecificAppCfg(appName),
            jsFiles = [];
        if (cfg.jses) {
            jsFiles = jsFiles.concat(cfg.jses.map(function (js) {
                return "/javascripts/wando/global/toolbox/" + appName + "/" + js + ".js"
            }));
        } else
            jsFiles.push("/javascripts/wando/global/toolbox/" + appName + ".js");
        Ext.Loader.load(jsFiles, function () {
            this[appName].init();
            this[appName].launch();
        }, this, true);
    },
    
    getSpecificAppCfg: function(appName) {
        var cfg;
        this.appCfgs.forEach(function (cfgI) {
            if (cfgI.name === appName) cfg = cfgI;
        })
        return cfg;
    },
    
    showOrHide: function() {
        if (!this.isInited) this.init();
        if (this.isShowed) {
            this.self.getEl().slideOut();
            this.isShowed = false;
        } else {
            this.self.show();
            this.self.getEl().slideIn();
            this.isShowed = true;
        }
    }
    
};
