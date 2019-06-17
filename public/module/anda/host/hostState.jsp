<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <%@ include file="/module/common.jsp" %>

    <style>
        body {
            font-size: 12px;
            color: #333;
        }
    .card {
        float: left;
        padding: 10px 0px 10px 10px;
        border: 1px solid #ccc;
        border-radius: 2px;
        box-shadow: 1px 2px 1px #ccc;
    }
    .card h2 {
        margin-bottom: 6px;
    }
    .card table td {
        padding: 10px 0px 10px 0px;
    }
    .card table th {
        padding-right: 10px;
    }

    .connections {
        font-weight: bold;
        padding: 10px 0px 10px 0px;
    }
    .connection-node {
        font-size: 1.1em;
    }
    .connection-state {
        padding: 0px 4px 0px 4px;
        color: orangered;
    }
</style>
</head>
<body>
    <div style="width:942px;margin: 40px auto;">
        <div class="card" style="width: 916px;margin-bottom: 20px;">
            <h2>连接状态</h2>
            <div class="connections">
                <span class="connection-node">后台</span>
                <span class="connection-state" id="connection1">───────正在连接───────</span>
                <span class="connection-node">电话实时报警消息接收/转发/控制服务器</span>
                <span class="connection-state" id="connection2">───────正在连接───────</span>
                <span class="connection-node">电话(${hostId})</span>
            </div>
            <p id="connection-info" style="color:orangered">正在连接到电话服务器 . . .</p>
        </div>
        <div class="card states" style="width:447px;height:300px">
            <h2>电话状态</h2>
            <table>
                <tr>
                    <th>在线状态：</th>
                    <td name="online">&nbsp;</td>
                </tr>
                <tr>
                    <th>设备状态：</th>
                    <td name="state">&nbsp;</td>
                </tr>
                <tr>
                    <th>信号强度：</th>
                    <td name="signalIntensity">&nbsp;</td>
                </tr>
                <tr>
                    <th>供电电压：</th>
                    <td name="supplyVoltage">&nbsp;</td>
                </tr>
                <tr>
                    <th>输出电压：</th>
                    <td name="outputVoltage">&nbsp;</td>
                </tr>
                <tr>
                    <th>电池电压：</th>
                    <td name="batteryVoltage">&nbsp;</td>
                </tr>
            </table>
            <div style="margin-top: 12px">
                <p style="display: none;margin-bottom: 4px">请等待电话心跳消息，间隔40秒左右，状态信息会自动更新，剩余<span name="heartbeatCountdownSecs" style="font-weight: bold;">40</span>秒</p>
                <p>最近更新时间：<span name="heartbeatLastTime"></span></p>
            </div>
        </div>

        <div class="card" style="width: 447px;height:300px;margin-left:10px;">
            <h2>电话控制</h2>
            <table>
                <tr>
                    <th>状态</th>
                    <td>
                        <input id="switchState" class="easyui-switchbutton" data-options="disabled:true, checked:true, onText:'布防',offText:'撤防'">
                    </td>
                </tr>
                <tr>
                    <th>警铃</th>
                    <td>
                        <input id="switchBellOpen" class="easyui-switchbutton" data-options="disabled:true, checked:false, onText:'开启',offText:'关闭'">
                    </td>
                </tr>
            </table>
        </div>
    </div>

    <script src="${libPath}socket.io.js"></script>
    <script src="${modulePath}anda/AndaAlarmReceiver.js?v=1.1"></script>
<script>
    var hostId = '${hostId}';
    init(hostId);

    function init(hostId) {
        var heartbeatCountdown = (function() {
            var timer;
            var COUNT_DOWN_START = 40;
            var elem = $('[name=heartbeatCountdownSecs]');
            elem.restart = function() {
                if (timer) {
                    clearInterval(timer);
                }
                elem.text(COUNT_DOWN_START);
                elem.parent().fadeIn();
                timer = setInterval(function () {
                    var n = elem.text() - 1;
                    if (n == 0) n = COUNT_DOWN_START;
                    elem.text(n);
                }, 1000);
            };
            elem.stop = function() {
                clearInterval(timer);
                elem.parent().hide();
            };
            return elem;

        })();

        var andaAlarmReceiver = new AndaAlarmReceiver();
        var statesCard = $('.states');
        var isUserTiggerMode = true;
        andaAlarmReceiver.subscribe({
            messageType: 'heartbeat',
            hostId: hostId,
            onMessage: function (states) {
                isUserTiggerMode = false;
                $('#switchState').switchbutton('enable').switchbutton(states.state ? 'check' : 'uncheck');
                isUserTiggerMode = true;

                setOnlineState(1);
                changeConnectionState(2, 0);
                states.state = states.state == 0 ? '撤防中' : '布防中';
                ['supplyVoltage', 'outputVoltage', 'batteryVoltage'].forEach(function(p) {
                    states[p] = (states[p] * 0.01).toFixed(1) + 'V';
                });
                if (states.signalIntensity == 0)
                    states.signalIntensity = '可能没有使用GSM信号，而使用WiFi中';
                for (var p in states) {
                    statesCard.find('[name=' + p + ']').text(states[p]);
                }
                $('[name=heartbeatLastTime]').text(moment().format('YYYY-MM-DD HH:mm:ss'));
                heartbeatCountdown.restart();
            }
        });
        andaAlarmReceiver.subscribe({
            messageType: 'idle',
            hostId: hostId,
            onMessage: function () {
                setOnlineState(0);
                changeConnectionState(2, 2);
                heartbeatCountdown.stop();
            }
        });

        andaAlarmReceiver.subscribe({
            messageType: 'event',
            subTypes: [5133, 13325, 5132, 13324, 5127, 13319],
            hostId: hostId,
            onMessage: function (message) {
                statesCard.find('[name=state]').text(
                    [5133,5132,5127].indexOf(message.eventType) > -1 ? '撤防中' : '布防中');
                isUserTiggerMode = false;
                $('#switchState').switchbutton('enable').switchbutton(
                    message.eventType == 5133 ? 'uncheck' : 'check');
                isUserTiggerMode = true;
            }
        });
        andaAlarmReceiver.subscribe({
            messageType: 'command_result',
            hostId: hostId,
            onMessage: function (msg) {
                var cmdNameMap = {0x01: '布防', 0x02: '撤防', 0x06: '启动警铃',  0x07: '关闭警铃'};
                showOpResultMessage(cmdNameMap[msg.cmdType] + (msg.resultCode == 0x01 ? '成功' : '失败'));
            }
        });

        $('#switchState').switchbutton({
            onChange: function(checked) {
                if (!isUserTiggerMode) return;
                andaAlarmReceiver.send('hostCommand',
                    {hostId: hostId, cmdType: checked ? 0x01 : 0x02});
            }
        });
        $('#switchBellOpen').switchbutton({
            onChange: function(checked) {
                if (!isUserTiggerMode) return;
                andaAlarmReceiver.send('hostCommand',
                    {hostId: hostId, cmdType: checked ? 0x06 : 0x07});
            }
        });

        function setOnlineState(state) {
            var html = '';
            if (state) {
                html = '<span style="color:green">在线（电话已连接到电话服务器，现在可以接收实时消息）</span>';
            } else {
                html = '<span style="color:red">离线（电话未连接到电话服务器，暂时无法接收实时消息）</span>';
            }
            statesCard.find('[name=online]').html(html);
        }

        /*
        state 0=连接成功,1=正在连接,2=未连接
        */
        function changeConnectionState(connectionId, state) {
            $('#connection' + connectionId)
                .css('color', state == 0 ? 'forestgreen' : 'orangered')
                .text('───────' + {0: '成功连接', 1:'正在连接', 2: '没有连接'}[state] + '───────');
        }

        andaAlarmReceiver.onSocketEvent('onlineState', function(isOnline) {
            changeConnectionState(2, isOnline ? 0 : 2);
            setOnlineState(isOnline);
        });
        andaAlarmReceiver.onSocketEvent('commandReqRet', function(ret) {
            if (ret != 0)
                alertInfo('控制指令执行失败');
        });
        andaAlarmReceiver.onSocketEvent('connect_ok', function() {
            $('#connection-info').css('color', 'forestgreen').fadeOut();
            changeConnectionState(1, 0);
            $('#switchBellOpen').switchbutton('enable');
            andaAlarmReceiver.send('onlineStateQuery', hostId);
            heartbeatCountdown.restart();
        });
        andaAlarmReceiver.onSocketEvent('connect_error', function() {
            setOnlineState(0);
            changeConnectionState(1, 1);
            changeConnectionState(2, 1);
            $('#connection-info').fadeIn().css('color', 'orangered').text('到电话服务器的连接失败，重连中 . . .');
            heartbeatCountdown.stop();
            $('#switchBellOpen').switchbutton('disable');
            $('#switchState').switchbutton('disable');
        });

        andaAlarmReceiver.connect();
    }
</script>
</body>
</html>