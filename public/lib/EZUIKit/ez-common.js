/*
@author hulang
*/
function testActiveX() {
    try {
        var ax = new ActiveXObject("EZOPENUIACTIVEXK.EzOpenUIActiveXKCtrl.1");
        return true;
    } catch(e) {
        var agent = navigator.userAgent.toLowerCase();
        var isie = !(/(msie\s|trident.*rv:)([\w.]+)/.exec(agent) == null) || agent.indexOf('edge') != -1;
        if (!isie) {
            $.messager.alert('提示', '<h2>该功能只支持IE浏览器(IE9以上)<h2>');
            return;
        }
        setTimeout(function(){
            window.location.href = CONFIG.baseUrl + 'EZUIKit.exe';
            setTimeout(function(){
                $.messager.alert("提示", "<h1>该功能所需要的相关插件未能成功运行</h1><br><br><br>"
                    + "请安装后允许运行<br><br>"
                    + "在确认已安装插件之后尝试下面的步骤：<br>"
                    + "<br>"
                    + "  ● 对IE浏览器的设置的步骤：<br>"
                    + "    &nbsp;&nbsp;1. Internet选项 -> 安全 -> 受信任站点 -> 点击[站点]按钮 -> 添加本网址<br>"
                    + "    &nbsp;&nbsp;2. Internet选项 -> 受信任站点 -> 自定义级别, 将 ActiveX控件或插件 下面的子选项 都设为启用<br>"
                    + "    &nbsp;&nbsp;3. 重新进入<br>"
                    + "<br>"
                    + "  ● 联系平台技术人员", "info");
            }, 10);
            console.log(e);
        }, 0);
        return false;
    }
}

var AuthManager = (function() {
    var authInfo = null;

    var o = {};
    o.get = function(callback) {
        if (!authInfo || new Date().getTime() > authInfo.accessToken.expireTime - 1000 * 60) {
            $.get(CONFIG.baseUrl + 'ys/auth.do', function(ret){
                authInfo = ret;
                callback(authInfo);
            });
        } else {
            callback(authInfo);
        }
    };

    return o;
})();
