/**
 * @class Wando.msg
 * @example
 *       Wando.msg.info("提示","操作成功") 自定义title,自定义msg
 *       Wando.msg.warning("警告","必须选中例子") 自定义title,自定义msg
 *       Wando.msg.confirm(null,"是否确定",function(btn){ 
 *          if(btn !== "ok") handler
 *          else handler
 *       })
 *       Wando.msg.error("错误","提交错误，请检查！") 自定义title,自定义msg
 *       Wando.msg.question("确定","确定要删除？") 自定义title,自定义msg
 *
 * @description
 * 自定义Msg，类型有: "warning"、"error"、"question"、"info"、"confirm"
 * 1.info类型只有2个参数title和msg,title为标题，一般都是"提示"，msg为提示的内容
 * 2.其它类型有四个参数
 * 3.第一个参数为标题,不填写时，必须以""传入,默认为type的标题,如warning = 警告
 * 3.第二个参数为msg主要内容
 * 4.第三个参数为回调函数
 * 5.第四个参数为该范围内的作用域,默认为window
 * 6.对于可以选择是否的提示框，统一使用confirm，info只供提示作用
 */

Ext.ns("Wando.msg")

Wando.msg = {
    /**
     * @protected
     */
    msgCt:undefined,

    /**
     * @protected
     * 信息提示
     */
    showInfo: function(title,msg){
        if(!this.msgCt){
            this.msgCt = Ext.DomHelper.insertFirst(document.body, {id:'msg-div'}, true);
        }
        var s = Ext.String.format.apply(String, Array.prototype.slice.call(arguments, 1));
        var m = Ext.DomHelper.append(this.msgCt, this.createBox(title, s), true);
        m.hide();
        m.slideIn('t').ghost("t", { delay: 1000, remove: true});
    },
    
    /**
     * @protected
     * 创建消息框，使info的信息居中
     */
    createBox: function createBox(t, s){
        return '<div class="msg"><h3>' + t + '</h3><p align=center>' + s + '</p></div>';
    },
    
    /**
     * @method info
     * 信息提示
     */
    info: function(title, msg){ 
        this.showInfo(title, msg);
    },

    /**
     * @method warning
     * 警告提示
     */
    warning: function(title, msg, fn, scope){ 
        this.alertMsg("warning", title, msg, fn, scope);
    },

    /**
     * @method error
     * 错误提示
     */
    error: function(title, msg, fn, scope){ 
        this.alertMsg("error", title, msg, fn, scope);
    },

    /**
     * @method question
     *问题提示
     */
    question: function(title, msg, fn, scope){ 
        this.alertMsg("question", title, msg, fn, scope);
    },

    /**
     * @method confirm
     * 确认提示
     */
    confirm: function(title, msg, fn, scope){ 
        this.alertMsg("confirm", title, msg, fn, scope);
    },

    /**
     * @protected
     */
    alertMsg: function(type, title, msg, fn, scope) {
        Ext.MessageBox.show({ 
            title: !title ? this[type + "Title"]() : title,
            msg: msg,
            buttons: this.getButtons(type),
            icon: this[type + "Icon"](),
            fn: fn,
            scope: scope ? scope : window
        });
    },

    /**
     * @protected
     *获取buttons,type ==="confirm",返回确定和取消,否则返回ok
     */
    getButtons: function(type) {
        return type === "confirm" ? Ext.MessageBox.OKCANCEL : Ext.MessageBox.OK;
    },
    
    /**
     * @protected
     * @return { confirmIcon }
     */
    confirmIcon: function(){ 
        return Ext.MessageBox.QUESTION;
    },

    /**
     * @protected
     * @return { confirmTitle }
     */
    confirmTitle: function(){ 
        return "确认";
    },

    /**
     * @protected
     * @return { warningIcon }
     */
    warningIcon: function() {
        return Ext.MessageBox.WARNING;
    },

   /**
    * @protected
    * @return { warningTitle }
    */
    warningTitle: function() {
        return "警告";
    },

    /**
     * @protected
     * @return { questionIcon }
     */
    questionIcon: function() {
        return Ext.MessageBox.QUESTION;
    },

    /**
     * @protected
     * @return { questionTitle }
     */
    questionTitle: function() {
        return "确定";
    },

    /**
     * @protected
     * @return { errorIcon }
     */
    errorIcon: function() {
        return Ext.MessageBox.ERROR;
    },

    /**
     * @protected
     * @return { errorTitle }
     */
    errorTitle: function() {
        return "错误";
    }
};
