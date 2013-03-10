/**
*   @class  Wando.callback 
*   @description
*       这个对象是用于封装一些共用性强的回调函数，DRY<br>
*       使用Wando.callback 之后不需要重写 Wando.loadMask.hide(), success与failure两个方法都默认配置<br>
*   @example
*       Wando.callback.success()
*       Wando.callback.failure(respone,opts)
*/
//= require_lib msg
Wando.callback = {
    /**
     *  请求成功的回调函数
     */
    success: function() {
        Wando.loadMask.hide();
        Wando.msg.info('', '操作成功');
    },
    
    /**
     *  请求失败的回调函数
     */
    failure: function(response, opts) {
        Wando.loadMask.hide();
        if(response.status == -1)
            var error_message = '操作超时，网络异常，检查后请重试...';
        else
            var error_message = Ext.decode(response.responseText).root.error_msg;
        Wando.msg.error(
            '', 
            error_message
        );
    },
    
    /**
     *  请求失败的回调函数
     */
    formFailure: function(form, action) {
        Wando.loadMask.hide();
        Wando.msg.error('', Ext.decode(action.response.responseText).root.error_msg);
    }
};
