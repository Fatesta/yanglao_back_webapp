init();
function init() {
    var isChrome = (navigator.userAgent.indexOf('Chrome/')>=0 && navigator.userAgent.indexOf('WebKit')>=0);
    if (!isChrome) {
        setTimeout(function() {
            $.messager.alert('提示', '<h2>呼叫中心只支持Chrome浏览器<h2>');
        }, 500);
    }

    top.$('#module-iframe-callcenter_workbench').attr('allow', 'microphone');

    
    var lastCallComingUser = null;

    require([
        'https://g.alicdn.com/acca/workbench-sdk/0.4.3/'
            + (isDevMode ? 'workbenchSdk.js' : 'workbenchSdk.min.js')], function(){
        //var calleeNumberNotifs = {};
        var workbench = new WorkbenchSdk({
            width: '280px',
            dom: 'workbench',
            instanceId: cccInstanceId,
            ajaxPath: '/callcenter/workbench/api.do',
            ajaxMethod: 'post',
            afterCallRule: 10,
            header: true,
            //autoAnswerCall: 5,
            moreActionList: ['mobilePhoneAnswer', 'break', 'offline'],
            /*
            outsideComponents: [{
              componentName: 'transfer',
              dom: 'test',
              btnStyle: {}
            }],*/
            onInit: function() {
                console.log('WorkbenchSdk onInit');
            },
            onErrorNotify: function (error) {
                console.warn(error)
            },
            onCallComing: function (connid, callerNumber, calleeNumber, contacId) {
                $('#leftTabs').tabs('select', 0);//select workbench
                
                setTimeout(function() {
                    if (lastCallComingUser)
                        getModuleContext('taishitu').stat.deviceQuery.gotoPositionByTelephone(callerNumber);                        
                }, 500);

                if(!(window.Notification && Notification.permission !== "denied")) {
                    return;
                }
                Notification.requestPermission(function(status) {
                    if(status != 'granted')
                        return;
                    $.get(CONFIG.baseUrl + 'user/getUserByPhone.do?phone=' + callerNumber, function(user) {
                        lastCallComingUser = user;
                        var foundUser = !!user;
                        var body = '来电话了！' + '号码：' + callerNumber;
                        if (foundUser) {
                            if (user.realName) {
                                body += '\n姓名：' + user.realName;
                            } else if (user.aliasName) {
                                body += '\n用户名：' + user.aliasName;
                            } else {
                                body += user.aliasName;
                            }
                            body += '\n性别：' + (user.sex == 0 ? '男' : '女');
                            body += '\n年龄：' + user.age + '岁';
                            body += '\n家庭地址：' + user.address;
                            //body += '\n所在社区：' + user.orgName;
                        } else {
                            body += '\n未查询到用户信息，可能为非平台用户';
                        }
                        // 弹出一个通知
                        var notif = new Notification('呼叫中心', {
                            body : body,
                            icon : CONFIG.imagePath + 'callcoming.png'
                        });
                        // 自动关闭通知
                        var timer = setTimeout(function() {
                            notif.close();
                        }, 1000*60*2);
                        notif.onclick = function() {
                            openModuleByCode('callcenter_workbench');
                            setTimeout(function() {
                                getModuleContext('callcenter_workbench').$('#leftTabs').tabs('select', 0);
                            }, 10);
                        };
                    });
                });
            },
            onCallDialing: function (aa, bb, cc, dd) {
              console.log(aa, bb, cc, dd);
            },
            onCallRelease: function() {
              lastCallComingUser = null;
            },
            onCallEstablish: function (connid, caller, calee, contactId) {
                setTimeout(function() {
                  if (lastCallComingUser) {
                      showOpButtons(lastCallComingUser);
                  }
                }, 1000);
            },
            onStatusChange: function (code, lastCode, context){
              console.log(code, lastCode, context);
            },
            onHangUp: function() {
                
            }
        });
        workbench.showWebNotification = function() {};
        
        //初始化座席状态
        $.get(CONFIG.baseUrl + 'callcenter/agentConfig/getCurrentAgent.do', function(agent) {
            $('.info .name').text(agent.displayName);
        });
        
        $.get(CONFIG.baseUrl + 'callcenter/agentConfig/agents.do', function(agents) {
            $('.group [name=countAgent]').text(agents.length);
            $('.group [name=onlineAgent]').text(agents.length);
            
            var html = '';
            agents.forEach(function(agent) {
                html += '<ul><li>' +
                '<span class="icon status_free"></span>' +
                '<span class="name" style="width: 100px;" title="' + agent.displayName + '">' + agent.displayName + '</span>' +
                //'<span class="tel_num">[2006]</span>'
                '</li></ul>';
            });
            $('#seatDiv .group>span').append(html);
        });

        setInterval(function() {
            var agentSkillGroupId = 'fc15cdd6-5ebf-47ae-b5e5-a891f7c9f867';
            $.get(CONFIG.baseUrl + 'callcenter/report/ListSkillGroupStates.do?SkillGroupIds=' + agentSkillGroupId, function(data) {
                if (data.code != 'OK') return;
                $('#onlineCount').text( data.data.list[0].loggedInAgents );
            });
        }, 1000 * 60 * 5);

        (function() {
            // 计时
            var nowTimeDiv = $('#nowTime');
            var startTime = +new Date();
            setInterval(function () {
                var dhms = TimeUtils.durationToDHMS(+new Date() - startTime);
                nowTimeDiv.html(String.leftPad0(dhms.hours)
                    + ':' + String.leftPad0(dhms.minutes)
                    + ':' + String.leftPad0(dhms.seconds));
            }, 1000);
        })();
    });
    
    
   function showOpButtons(user) {
       //找到插入位置
       var parent = $('.workbench_sdk_components-BtnCallHold-___style__btns-call-box___2cHF3').parent();
       if (parent.length == 0) {
         return;
       }
       
       var btnBox = $(
           '<div class="workbench_sdk_components-BtnCallHold-___style__btns-call-box___2cHF3" ' +
             'style="display: block;">' +
             '<button type="button" class="next-btn next-btn-normal next-btn-medium" style="display: block;color: #fff;background: rgb(0, 193, 222);">' +
             '用户信息</button></div>');
       btnBox.click(function() {
           openUserBasicInfo(user.userId);
       });
       parent.append(btnBox);
         
       var btnBox = $(
           '<div class="workbench_sdk_components-BtnCallHold-___style__btns-call-box___2cHF3" ' +
             'style="display: block;">' +
             '<button type="button" class="next-btn next-btn-normal next-btn-medium" style="display: block;color: #fff;background: rgb(0, 193, 222);">' +
             '定位用户</button></div>');
       btnBox.click(function() {
          getModuleContext('taishitu').deviceQuery.gotoPositionByTelephone(user.telphone);
       });
       parent.append(btnBox);

       var btnBox = $(
           '<div class="workbench_sdk_components-BtnCallHold-___style__btns-call-box___2cHF3" ' +
             'style="display: block;">' +
             '<button type="button" class="next-btn next-btn-normal next-btn-medium" style="display: block;color: #fff;background:rgb(53, 179, 74);">' +
             '快速下单</button></div>');
       btnBox.click(function() {
           openFastOrder(user);
       });
       parent.append(btnBox);
   }

}

function openFastOrder(user) {
    openTab({
        title: '快速下单-选择店铺',
        url: CONFIG.baseUrl + 'shop/order/index.do?_func_code=shop.orderManage&fastOrderMode=1&userId='
            + user.userId +'&orgId=' + (user.orgId || '')
      });
}