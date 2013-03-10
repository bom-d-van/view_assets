Wando.toolbox.help ={ 
    init:function(){ 
        this.getUrl = this.getUrl(); 
    },

    launch:function(){
        url = this.getUrl;
        length = this.getUrl.length;
        window.open("/video/" + url[length-2]+ "_" + url[length-1] + ".html","_blank")
    },

    getUrl:function(){ 
        var url = location.href.split("/"); 
        return url;
    }

}
