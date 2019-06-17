function openCardChange(userId) {
    var dlg = openEditDialog({
        width: 300,
        height: 280,
        title: '更换会员卡',
        href: 'user/vipcard/change/changeForm.do?userId=' + userId,
        onSave: function() {
            formSubmit("#vipCardUserChangeCardForm", {
                url: "user/vipcard/change/change.do",
                success: function(ret) {
                    if (ret.code == 0) {
                        showOpOkMessage();
                        dlg.dialog('destroy');
                    } else {
                        showOpFailMessage({1: '卡号未被登记', 2: '卡号已被其它用户使用'}[ret.code]);
                    }
                }
            });
        }
    });
}