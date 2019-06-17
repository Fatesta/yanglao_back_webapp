$('#selectUser').click(function() {
    openUserSelectDialog({
        onSelectDone: function(user){
            $('[name=userId]').val(user.userId);
            $('#userName').textbox('setValue', user.realName || user.aliasName);
            return true;
        }
    });
});

$('#submit').click(function() {
    var startTimeBox = $('#startTimeBox');
    $('[name=startTime]').val(startTimeBox.datebox('getValue'));
    formSubmit('#frmCheckin', {
        url: 'community/berth/checkin/new.do',
        success: function(code) {
            if (code <= 1) {
                showOpResultMessage(code);
                getModuleContext('community-berth-ruzhu').currOpBerth.update();
            } else if (code == 2) {
                showOpFailMessage('床位已有人入住');
            } else if (code == 3) {
                showOpFailMessage('该用户已在其它房间入住中');
            }
        }
    });
});

$('#back').click(function() {
    closeCurrentModule();
});