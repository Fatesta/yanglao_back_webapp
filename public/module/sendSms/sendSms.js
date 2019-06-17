$('#mobileInputType').combobox({
    onChange: function(value) {
        $('#importMobileTr, #mobileTr').hide();
        $('#frmSendSms [name=mobileCsv]').validatebox({required: false});
        $(this).parent().find('.tip-info').hide();
        $('[textboxname=mobileCsvFile]').filebox({required: false});
        if(value == 'csv') {
            $('#mobileTr').show();
            $('#frmSendSms [name=mobileCsv]').validatebox({required: true});
        } else if(value == 'csvFile') {
            $('#importMobileTr').show();
            $(this).parent().find('.tip-info').show();
            $('[textboxname=mobileCsvFile]').filebox({required: true});
        }
    }
});

$('#submit').click(function() {
    if($('#mobileInputType').combobox('getValue') == 'csv') {
        //验证手机号
        var mobiles = $('#frmSendSms [name=mobileCsv]').val().replaceAll('，', ',');
        mobiles = mobiles.split(',');
        var mobileReg = /^(13[0-9]|14[579]|15[0-3,5-9]|16[6]|17[0135678]|18[0-9]|19[89])\d{8}$/;
        var invalidIndex = _.findIndex(mobiles, function(s) {
            return !mobileReg.test(s);
        });
        
        if(invalidIndex != -1) {//有无效手机号
            alertInfo('第' + (invalidIndex + 1) + '个手机号无效');
            return;
        }
    
        //检查重复手机号
        var mobileCounts = {};
        mobiles.forEach(function(m) {
            if(typeof mobileCounts[m] == 'undefined')
                mobileCounts[m] = 0;
            mobileCounts[m]++;
        });
        var duplicates = [];
        _.forEach(mobileCounts, function(count, mobile) {
            if(count > 1)
                duplicates.push(mobile);
        });
        if(duplicates.length > 0) {
            alertInfo('存在重复手机号:<br>' + duplicates.join('<br>'));
            return;
        }
        
        $('#frmSendSms [name=mobileCsv]').val(mobiles.join(','));
        submitSend(mobiles.length);
    } else {
        $('#frmSendSms [name=mobileCsv]').val('');
        checkCvsFile(function(ret) {
            submitSend(ret.totalCount);
        });
    }
    
    function submitSend(mobileCount) {
        $('#frmSendSms [name=content]').validatebox({required: true});
        if(!$("#frmSendSms").form('validate')) {
            return;
        }
        openConfirmDialog('确认发送短信到 <span style="font-weight:bold">' + mobileCount + '</span> 个手机号?', function(){
            formSubmit("#frmSendSms", {
                url: "sendSms/send.do",
                success: function(ret) {
                    if (ret[0] != '-') {
                        showOpOkMessage();
                    } else {
                        showOpFailMessage();
                    }
                }
            });
        });
    }
    
});

$('#checkCsvFile').click(function() {
    checkCvsFile(function(ret) {
        alertInfo(
            '未发现无效手机号' + '<br>' +
            '读取到有效手机号个数：' + ret.totalCount);
    });
});

$('#close').click(function() {
    closeCurrentModule();
});

function checkCvsFile(onOk) {
    if(!$('[textboxname=mobileCsvFile]').filebox('getValue')) {
        return;
    }
    $('#frmSendSms [name=content]').validatebox({required: false});
    formSubmit("#frmSendSms", {
        url: "sendSms/checkCsvFile.do",
        success: function(ret) {
            if(ret.isOk) {
                onOk && onOk(ret);
            } else {
                alertInfo(
                    '读取到无效手机号个数：' + ret.invalidCount + '<br>' +
                    '第一个出现的无效手机号： ' + '[<strong>' + ret.firstInvalid + '</strong>]' + '<br>' +
                    '请修正再发送短信');
            }
        }
    });
}