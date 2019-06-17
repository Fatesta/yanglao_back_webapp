
window.onload = function() {
    if(typeof supportRole != 'undefined' && !supportRole) {
        $('#overlay').show().get(0).contentWindow.$.messager.alert('提示', '<br><br><h2 style="text-align:center;">此功能在社区端和医生端使用<h2>');
      return;
    }
    testActiveX();

    //发送心跳给服务器，解决长时间视频之后依然保持着网站会话
    setInterval(function() {
        heartbeat.beat();
    }, 60 * 30 * 1000);
}

function VideoCtrlMaster(options) {
    var self = this;
    var videoCtrls = [];//视频控制
    var mainIndex = 0;//当前主视频窗口的视频方索引
    var currVideoCtrl = null;
  
    options = options || {};
    
    //我方视频
    this.addMe = function(vc, callback) {
        videoCtrls[0] = vc;
        currVideoCtrl = vc;
        if(!vc.cameraCfgIsEmpty()) {
            vc.open(function() {
                vc.startRealPlay();
                callback && callback();
            });
        }
    };
    
    //对方视频
    this.addHe = function(vc, callback, before) {
        videoCtrls[1] = vc;
        if(!currVideoCtrl) {
            currVideoCtrl = vc;
        }
        if(!vc.cameraCfgIsEmpty()) {
            before && before();
            setTimeout(function() {
                vc.open(function(){
                    vc.startRealPlay();
                    if(callback) {
                        setTimeout(callback, 0);
                    }
                });
            }, 100);
        }
    };
    
    this.closeHe = function() {
        console.log("message videoCtrlMaster.closeHe");
        videoCtrls[1] && videoCtrls[1].closeAll();
        if(mainIndex == 1)
            this.switchMain();
    };
    
    this.closeAll = function() {
        console.log("message videoCtrlMaster.closeAll");
        videoCtrls[0] && videoCtrls[0].closeAll();
        videoCtrls[1] && videoCtrls[1].closeAll();
    };
    
    this.switchMain = function() {
        console.log("message videoCtrlMaster.switchMain");
        if(videoCtrls.length == 1)
            return;
        var plugin1 = $(videoCtrls[0].getVideoObject()).parent();
        var plugin2 = $(videoCtrls[1].getVideoObject()).parent();
    
        if(!videoCtrls[0].cameraCfgIsEmpty() && !videoCtrls[1].cameraCfgIsEmpty()) {
            plugin2.append(plugin1.children().eq(0));
            plugin1.append(plugin2.children().eq(0));
            mainIndex = +!mainIndex;
        }
        else if(videoCtrls[0].cameraCfgIsEmpty() && !videoCtrls[1].cameraCfgIsEmpty()) {
            if(plugin1.children().length == 0) {
                plugin1.append(plugin2.children().eq(0));
                mainIndex = 1;
            }
        }
    
        currVideoCtrl = videoCtrls[mainIndex];
    };
    
    initComponents(options);
    
    // 初始化界面组件
    function initComponents(options) {
        $("#btn-up, #btn-down, #btn-left, #btn-right").each(function(){
            var dir = $(this).attr('id').split('-')[1];
            var dirCmd = {'up': 0, 'down': 1, 'left': 2, 'right': 3}[dir];
            $(this).mousedown(function(){
                $(this).addClass('btn-' + dir + '-press');
                currVideoCtrl.doPTZControl(dirCmd);
            });
            $(this).mouseup(function(){
                $(this).removeClass('btn-' + dir + '-press');
                currVideoCtrl.stopPTZControl(dirCmd);
            });
        });
        
        if(options.talkButton) {
            $("#talkBtn").show().click(function(){
                currVideoCtrl.doPTZControl(9);
                if ($(this).is(".btn-off")) {
                    $(this).attr("title", "开启对讲");
                    $(this).removeClass("btn-off");
                    $(this).addClass("btn-on");
                    currVideoCtrl.stopVoiceTalk();
                } else {
                    $(this).attr("title", "关闭对讲");
                    $(this).removeClass("btn-on");
                    $(this).addClass("btn-off");
                    currVideoCtrl.startVoiceTalk();
                }
            });
        } else {
            $("#talkBtn").hide();
        }

        $(document).on("mousedown", function(){
            $(document).on("mousemove", function(e){
                e.preventDefault();
            });
        });
        
        $("#btnFullScreen").click(function(){
            currVideoCtrl.setFullScreen();
        });
        
        
        $('#btnStop').click(function(){
            if (currVideoCtrl.opened) {
                currVideoCtrl.stopRealPlay();
            } else {
                currVideoCtrl.startRealPlay();
            }
        });
        
        $("#btnVideoChange").click(function(){
            self.switchMain();
        });
        
        window.onunload = window.onbeforeunload = function () {
            self.closeAll();
        };
    }
}

function VideoCtrl(obj, options) {
    //private
    var cameraCfg = options.cameraCfg;

    //public
    
    this.opened = false;
    
    this.getVideoObject = function() { return obj; }
    
    this.setCameraCfg = function(cameraConfig) {
        cameraCfg = cameraConfig;
    };
    this.cameraCfgIsEmpty = function() {
        return cameraCfg == null;
    };

    //打开当前摄像头配置的视频
    this.open = function(onOpenSuccess) {
        debugLog("open called");
        if(this.opened)
            return;
        if(this.cameraCfgIsEmpty()) {
            debugLog("cameraCfg is empty");
            return;
        }
        
        var self = this;
        AuthManager.get(function(authInfo) {
            authInfo = options.authInfo || authInfo;
            try {
            if (obj && !obj.inited) {
                obj.InitWithAppKey(authInfo.appKey);
                obj.SetAccessToken(authInfo.accessToken.string);
                obj.inited = true;
            }
            } catch(e) {}
            onOpenSuccess && onOpenSuccess();
        });
    };

    this.startRealPlay = function(params) {
        var ezurl = 'ezopen://' + cameraCfg.validateCode + '@open.ys7.com/' + cameraCfg.deviceSerial + '/1.hd.live'
        if (params) {
            ezurl += '?' + $.param(params);
        }
        var ret = obj.StartPlay(ezurl);
        this.opened = true;
        debugLog("StartPlay return " + ret);
    };
    
    this.stopRealPlay = function() {
        var ret = obj.StopPlay();
        this.opened = false;
        return ret== 0;
    };

    this.doPTZControl = function(dirCmd) {
        obj.PTZCtrl(dirCmd, 0, 3);
    };

    // 方向PTZ停止
    this.stopPTZControl = function(dirCmd) {
        obj.PTZCtrl(dirCmd, 1, 3);
    };
    
    // 开始对讲
    this.startVoiceTalk = function() {
        debugLog("开始语音对讲");
        var ret = obj.StartTalk();
        return ret;
    };
    
    // 停止对讲
    this.stopVoiceTalk = function(){
        debugLog("停止语音对讲");
        obj.StopTalk();
    }
    
    this.closeAll = function() {
        debugLog("closeAll");
        this.stopVoiceTalk();
        this.stopRealPlay();
    };
    
    $(document).bind('keyup', function() {
        if (fullScreenEntered) {
            $('object').hide();
            obj.width = '100%';
            obj.height = '100%';
            $(obj).css({
                position: 'relative'
            });
            $('object').show();
            fullScreenEntered = false;
        }
    });
    
    var fullScreenEntered = false;
    // 全屏
    this.setFullScreen = function() {
        $('object').hide();

        $(obj).css({
            position: 'fixed',
            left: 0,
            top: 0
        });
        obj.width = $(window).width();
        obj.height = $(window).height();
        
        $(obj).show();

        fullScreenEntered = true;
    };
    
    //private
    
    var debugMode = true;
    function debugLog(s, s2) {
        if(debugMode)
            s2 ? console.log(s, s2) : console.log(s);
    }
}

function showMessage(msg) {
    $.messager.show({
        title: '提示',
        msg:msg,
        timeout:3000,
        showType:'slide'
    });
}

function ActiveUserInfoPanel() {
    var self = this;
    var user = null;
    
    this.signals = {
        updated: new signals.Signal()
    };
    
    this.loadUser = function(_user) {
        user = _user;
        $("#userName").text(user.userName);
        $("#sex").text(user.sex == 0 ? "男" : "女");
        $("#age").text(user.age);
        $("#telephone").text(user.telephone);
        if (user.remark) {
            $('#viewRemark').show();
        } else {
            $('#viewRemark').hide();
        }
    }
    
    this.getUser = function() {
        return user;
    }
    
    this.clear = function() {
        $("#userName").empty();
        $("#sex").empty();
        $("#age").empty();
        $("#telephone").empty();
        $('#viewRemark').hide();
    }

    this.infoDialog = function(field) {
        var overlayIframe = $('#overlay').get(0);
        $(overlayIframe).show();
        var html = user[field].replaceAll('\n', '<br>').replaceAll(' ', '&nbsp;&nbsp;');
        var dlg = overlayIframe.contentWindow.DialogManager.openSimpleDialog({
            title: "病史信息",
            width: 600,
            height: 420,
            content: html,
            closed: false,
            cache: false,  
            modal: false,
            resizable: true,
            maximizable: true,
            onSave: function(){
                dlg.dialog('destroy');
                $(overlayIframe).hide();
            },
            onClose: function() {
                dlg.dialog('destroy');
                $(overlayIframe).hide();
            }
        });
    }
    
    $('#editProfile').click(function() {
        var overlayIframe = $('#overlay').get(0);
        $(overlayIframe).show();
        var dlg = overlayIframe.contentWindow.openEditDialog({
            id: 'infoDialog',
            title: "编辑",
            width: 400,
            height: 400,
            modal: true,
            href: 'view/health/chat/editProfile.do',
            onLoad: function() {
                overlayIframe.contentWindow.$('#profileForm', overlayIframe.contentDocument).form('load', user);
            },
            onSave: function(){
                var user = $('#profileForm', overlayIframe.contentDocument).serializeObject();
                self.loadUser(user);
                self.signals.updated.dispatch();

                dlg.dialog('destroy');
                $(overlayIframe).hide();
            },
            onClose: function() {
                dlg.dialog('destroy');
                $(overlayIframe).hide();
            },
            onCancel: function() {
                dlg.dialog('destroy');
                $(overlayIframe).hide();
            }
        });
    });
    
    $('#viewRemark').click(function() {
        self.infoDialog('remark');
    });
}