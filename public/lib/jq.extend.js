function jqueryExtend($) {
    /**
     * $.arrayParam("p", [1,2,3]) == "p=1&p=2&p=3"
     * @author hulang
     */
    $.arrayParam = function(name, valueArray){
        return valueArray.map(function(val){
            return name + "=" + val;
        }).join("&");
    };
    /**
     * $.arrayPickParam("p", [{a:2},{a:2},{a:3}], "a") == "p=1&p=2&p=3"
     * @author hulang
     */
    $.arrayPickParam = function(name, objectArray, key){
        return $.arrayParam(name, objectArray.map(function(o) { return _.pick(o, key)[key]; }));
    }
    $.fn.extend({
        serializeObject: function(){  
            var a,o,h,i,e;  
            a=this.serializeArray();  
            o={};  
            h=o.hasOwnProperty;  
            for(i=0;i<a.length;i++){  
                e=a[i];  
                if(!h.call(o,e.name)){
                    o[e.name]=e.value;  
                }  
            }  
            return o;  
        }
    });
    //设置全局ajax
    $.ajaxSetup({
        timeout: 30000, //默认超时时间为30秒
        beforeSend: function (xhr) {
            xhr.setRequestHeader("If-Modified-Since", "0");
        },
        statusCode: {
            401: function () {
                /*var nowDate = new Date();
                window.top.location.href = "login.asp?_" + nowDate.getTime();*/
            }
        }
    });
}
