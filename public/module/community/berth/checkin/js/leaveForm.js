$(function() {
    var startTime = moment($('#startTimeBox').datebox('getValue')).valueOf();
    var endTimeBox = $('#endTimeBox');
    endTimeBox.datebox({
        onChange: function() {
            calcDuration();
            getYingFu();
        }
    });
    $('#yingfu').numberbox('textbox').bind('keyup', function() {
        $('#yingfu').numberbox('setValue', this.value);
        calcPayMoney();
    });
    $('[textboxname=paidMoney]').numberbox('textbox').bind('keyup', function() {
        $('[textboxname=paidMoney]').numberbox('setValue', this.value);
        calcPayMoney();
    });

    calcDuration();
    getYingFu(calcPayMoney);
        
    function getYingFu(callback) {
        $('#yingfu').numberbox('clear');
        $.get(CONFIG.baseUrl + 'community/berth/checkin/calcPayMoney.do',
            {checkinId: berthCheckinId, endTime: endTimeBox.datebox('getValue')},
            function(money) {
                $('#yingfu').numberbox('setValue', money);
                $('#calcMoney').text(money.toFixed(2));
                callback && callback();
            });
    }
    function calcPayMoney() {
        var yingfu = $('#yingfu').numberbox('getValue');
        var paidMoney = +$('[name=paidMoney]').val();
        var deposit = +$('#deposit').numberbox('getValue');
        var qiankuan = (yingfu - paidMoney - deposit);
        var qiankuanDesc = '';
        if(qiankuan > 0) {
            quankuanDesc = '未交清';
            $('#qiankuanDesc').css('color', 'red').text();
        } else if(qiankuan == 0) {
            quankuanDesc = '已交清';
            $('#qiankuanDesc').css('color', 'green');
        } else {
            quankuanDesc = '已交清';
            quankuanDesc += ', 需退款' + (-qiankuan).toFixed(2);
            $('#qiankuanDesc').css('color', '#FF5722');
        }
        $('#qiankuanDesc').text(quankuanDesc);
        $('#qiankuan').numberbox('setValue', qiankuan.toFixed(2));
    }
    
    function calcDuration() {
        $('[name=duration]').empty();
        var endTime = moment(endTimeBox.datebox('getValue')).valueOf();
        $('[name=duration]').text(berth.tool.toDuration(endTime - startTime, 'ms'));
    }

    $('#submit').click(function() {
        var endTimeBox = $('#endTimeBox');
        $('[name=endTime]').val(endTimeBox.datebox('getValue'));
        formSubmit('#frmBerthLeave', {
            url: 'community/berth/checkin/leave.do',
            success: function(success) {
                if (success) {
                    getModuleContext('community-berth-ruzhu').currOpBerth.update();
                }
                showOpResultMessage(success);
            }
        });
    });

    $('#back').click(function() {
        closeCurrentModule();
    });
});

