/**
 *= require_vendor ext-all-debug, jquery
 *= require_vendor menu
 *= require_vendor gridfilters/FiltersFeature.js
 *= require_lib wando
 *= require_lib icons
 *= require_lib msg
 *= require_lib tool_box/app_info
 *= require_lib tool_box/data_view_more
 *= require_lib tool_box/help
 *= require_lib tool_box/init
 *= require_lib desktop_notifications
 *= require_lib js_extension
 *= require_lib callback
 *= require_lib renderer
 *= require_lib color_field
 *= require_lib tbar
 */
Ext.onReady(function() {
    //规范Ext.Ajax请求传至后台参数
    Ext.Ajax.extraParams = { 
        authenticity_token: Wando.ajaxToken,
        offeset:0,
        limit:20
    }

    //初始化统一接口
    Wando.init();

});

