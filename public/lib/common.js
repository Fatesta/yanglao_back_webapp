/*TODO:不要在往这个文件里加代码，待重构*/

function inheritGlobalVars(window, parent) {
    /* https://github.com/hulang1024/notes/blob/master/about-iframe.md */
    /* 继承父级window全局变量 */
    [/*'require', 'define',*/
        'moment', '_', 'Signal', 'Base64',
     'sysDicts', 'sysFormatters', 'Dict', 'DictItem', 'DictMan',
     'Observer', 'Observable',
     'openTab',
     'getObjectsPropertyArray', 'post', 'get', 'getJSON', 'submitForm', 'formSubmit', 'TimeUtils', 'str2Json',
     'getModuleContext', 'closeCurrentModule', 'openModuleByCode',
     'UI'
     ].forEach(function(name) {
        window[name] = parent[name];
    });
    
    extendLang(window);
    window.jqueryExtend(window.$);
    if (typeof UI == 'function')
        UI(window);
}

extendLang(window);


/*
获取模块上下文,这里的模块是iframe
@param moduleCode 模块编码
*/
function getModuleContext(moduleCode, parent) {
    var iframe = (parent || window.top).document.querySelector('[id="module-iframe-' + moduleCode + '"]');
    return iframe ? iframe.contentWindow : null;
}

function closeCurrentModule() {

}

function extendLang(window) {
    var Math = window.Math;
    var String = window.String;
    var Array = window.Array;
    var String = window.String;
    var Object = window.Object;
    var console = window.console;
    
    /**
     * 四舍五入
     * 
     * @param number
     *            数值
     * @param precision
     *            精度
     * @returns {Number} 四舍五入后的数值
     */
    Math.roundFloat = function(number, precision) {
        if (number instanceof String) {
            number = parseFloat(number);
        }
        if (!precision) {
            precision = 2;
        }
        var multiple = 1;
        for (var i = 0; i < precision; i ++) {
            multiple *= 10;
        }
        return Math.round(number*multiple)/multiple;
    }
    /**
     * 判断字符串是否以suffix结尾
     * 
     */
    String.prototype.endWiths = function(suffix) {

        if (!suffix) {
            return false;
        }

        var d = this.length - suffix.length;
        return (d >= 0 && this.lastIndexOf(suffix) == d);

    }

    String.prototype.startsWith=function(str){    
        var reg=new RegExp("^"+str);    
        return reg.test(this);       
    } 

    String.leftPad0 = function(n) {
        return n > 9 ? n : '0' + n;
    }

    /*************************************************
     Function:        replaceAll
     Description:    替换所有
     Input:            szDir:源字符
     szTar:目标字符
     Output:            无
     return:            无
     *************************************************/
    String.prototype.replaceAll = function (szDir, szTar) {
        return this.replace(new RegExp(szDir, "g"), szTar);
    }

    /*************************************************
     Function:        toHex
     Description:    转换为16进制
     Input:            szStr:源字符
     Output:            无
     return:            无
     *************************************************/
    String.prototype.toHex = function () {
        var szRes = "";
        for (var i = 0; i < this.length; i++) {
            szRes += this.charCodeAt(i).toString(16);
        }
        return szRes;
    }

    /**
     * 字符串格式化（类方法）
     * 示例:
     * String.format("a_{0}b{1}", 1) == "a_1b{1}"
     * String.format("a_{0}b{1}", 1, 'cat') == "a_1bcat"
     * "a_{0}b{1}".format(1, 'cat') == "a_1bcat"
     * @param 包含占位的字符串 string
     * @param 实际参数 object
     * @return 格式化后的字符串 string
     * @author hulang
     * @date 2017-03-15
     * */
    String.format = function() {
      if(arguments.length == 0)
        return "";
      if(arguments.length == 1)
        return arguments[0];
      if(!arguments[0])
          return "";
      var result = arguments[0];
      for (var i = 1; i < arguments.length; i++) {
        result = result.replace(new RegExp('\\{' + (i - 1) + '\\}', 'gm'), arguments[i]);
      }
      return result;
    };
    /**
     * 字符串格式化
     * 示例:
     * "a_{0}b{1}".format(1, 'cat') == "a_1bcat"
     * @param 实际参数 object
     * @return 格式化后的字符串 string
     * @author hulang
     * @date 2017-03-15
     * */
    String.prototype.format = function() {
      if(arguments.length == 0) {
        return "";
      }
      var result = this;
      for (var i = 0; i < arguments.length; i++) {
          result = result.replace(new RegExp('\\{' + (i) + '\\}', 'gm'), arguments[i]);
      }
      return result;
    };

    /**
     * setup Array method
     * @author hulang
     * @date 2017-04-18
     * */
    Array.prototype.map = Array.prototype.map || function(fn) { return _.map(this, fn); };
    Array.prototype.forEach = Array.prototype.forEach || function(fn) { return _.forEach(this, fn); };
    Array.prototype.includes = Array.prototype.includes || function(fn) { return _.includes(this, fn); };

    Object.values = Object.values || function(o) {
        var values = [];
        for (var p in o)
            values.push(o[p]);
        return values;
    }

    console.log = console.log || function() {};
}

function getObjectsPropertyArray(objs, propertyName) {
    var arr = typeof objs.length == 'undefined' ? [objs] : objs;
    return arr.map(function(o) {
        return o[propertyName];
    });
}

/**
 * POST请求
 * 
 * @param url
 *            请求地址
 * @param data
 *            请求数据
 * @param success
 *            回调函数
 * @param dataType
 *            响应类型
 */
function post(url, data, success, dataType) {
    if (!dataType) {
        dataType = "json";
    }
    if (!success) {
        success = new Function();
    }
    $.ajax({
        type:"POST",
        url:url,
        traditional:true,
        data:data,
        dataType:dataType,
        success:success,
        async:false
    });
}

function get(url, data, success) {
    return $.get('/' + url, data, success);
}

function getJSON(url, data, success) {
    return $.getJSON('/' + url, data, success);
}

/**
 * URL字符串转JSON对象
 * 
 * @param url
 *            URL字符串
 * @returns JSON对象
 */
function url2Json(url) {
    // username=aaa&realname=ccc&username=ddd
    var pairs = url.split("&");
    var json = "{";
    for (var i = 0; i < pairs.length; i++) {
        var pair = pairs[i];
        var entry = pair.split("=");
        json = json + entry[0] + ":'" + entry[1] + "',";
    }
    if (json.length > 0) {
        json = json.substring(0, json.length - 1);
    }
    json = json + "}";
    return str2Json(json);
}

/**
 * 字符串转JSON对象
 * 
 * @param str
 *            JSON字符串
 * @returns JSON对象
 */
function str2Json(str) {
    return new Function("return " + str)();
}

var TimeUtils = (function() {
    return {
        /*
        @param time 毫秒 
         */
        formatToDurationText: function(time, format) {
            var dhms = durationToDHMS(time);
            var d = dhms.days;
            var h = dhms.hours;
            var m = dhms.minutes;
            var s = dhms.seconds;
            var text = '';
            if (d > 0) text += d + '天';
            if (h > 0) text += h + '小时';
            if (m > 0) text += m + '分钟';
            if (!text)
                if (s > 0) text += s + '秒';
            
            return text;
        },
        durationToDHMS: durationToDHMS
    }
    
    function durationToDHMS(time) {
        var ONE_SECOND = 1000,
            ONE_MINUTE = ONE_SECOND * 60,
            ONE_HOUR = ONE_MINUTE * 60,
            ONE_DAY = ONE_HOUR * 24;
        var d = Math.floor(time / ONE_DAY);
        var h = Math.floor(time % ONE_DAY / ONE_HOUR);
        var m = Math.floor(time % ONE_DAY % ONE_HOUR / ONE_MINUTE);
        var s = Math.floor(time % ONE_DAY % ONE_HOUR % ONE_MINUTE / ONE_SECOND);
        
        return {days: d, hours: h, minutes: m, seconds: s};
    }
})();