Ext.ns("Wando.msg");Wando.msg={msgCt:undefined,showInfo:function(d,c){if(!this.msgCt){this.msgCt=Ext.DomHelper.insertFirst(document.body,{id:"msg-div"},true)}var b=Ext.String.format.apply(String,Array.prototype.slice.call(arguments,1));var a=Ext.DomHelper.append(this.msgCt,this.createBox(d,b),true);a.hide();a.slideIn("t").ghost("t",{delay:1000,remove:true})},createBox:function createBox(a,b){return'<div class="msg"><h3>'+a+"</h3><p align=center>"+b+"</p></div>"},info:function(b,a){this.showInfo(b,a)},warning:function(d,c,b,a){this.alertMsg("warning",d,c,b,a)},error:function(d,c,b,a){this.alertMsg("error",d,c,b,a)},question:function(d,c,b,a){this.alertMsg("question",d,c,b,a)},confirm:function(d,c,b,a){this.alertMsg("confirm",d,c,b,a)},alertMsg:function(c,e,d,b,a){Ext.MessageBox.show({title:!e?this[c+"Title"]():e,msg:d,buttons:this.getButtons(c),icon:this[c+"Icon"](),fn:b,scope:a?a:window})},getButtons:function(a){return a==="confirm"?Ext.MessageBox.OKCANCEL:Ext.MessageBox.OK},confirmIcon:function(){return Ext.MessageBox.QUESTION},confirmTitle:function(){return"确认"},warningIcon:function(){return Ext.MessageBox.WARNING},warningTitle:function(){return"警告"},questionIcon:function(){return Ext.MessageBox.QUESTION},questionTitle:function(){return"确定"},errorIcon:function(){return Ext.MessageBox.ERROR},errorTitle:function(){return"错误"}};