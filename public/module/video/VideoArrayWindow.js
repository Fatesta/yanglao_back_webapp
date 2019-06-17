function VideoArrayWindow() {
    var open = false;
    var win;
    return {
        openVideo: function(deviceCode, aliasName) {
            if(!open) {
                win = window.top.$('<div></div>');
                win.window({
                    title : '视频监控',
                    width : 800,
                    height : 600,
                    collapsible: true,
                    maximizable : true,
                    minimizable : false,
                    modal : false,
                    draggable : true,
                    resizable : false,
                    onClose : function() {
                        getModuleContext('video-array').videoArrayPlayer.exit();
                        win.window('destroy');
                        open = false;
                    },
                    onMaximize: function() {
                        getModuleContext('video-array').videoArrayPlayer.resize();
                    },
                    onRestore: function() {
                        getModuleContext('video-array').videoArrayPlayer.resize();
                    },
                    content: "<iframe id='module-iframe-video-array' src='" + CONFIG.baseUrl + "view/video/videoArray.do"
                        + "' style='overflow:auto;overflow-y:hidden;width:100%;height:100%;margin:0px;padding:0px;border-width:0px;'></iframe>"
                });
                win.window('open');
                open = true;
            }
            var ctx = getModuleContext('video-array');
            if (ctx.loaded) {
                ctx.play(deviceCode, aliasName);
            } else {
                ctx.onload = function() {
                    ctx.play(deviceCode, aliasName);
                    ctx.signals.enterFullScreened.add(function() {
                        win.window('maximize');
                    });
                    ctx.signals.exitFullScreened.add(function() {
                        win.window('restore');
                    });
                }
            }
        }
    };
}