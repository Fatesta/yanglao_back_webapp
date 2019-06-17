var berthCheckin = {
    formatters: {
        berthNo: function(berthNo, r) {
            return r.buildingNo + '栋' + r.floorNo + '层' + r.roomNo + '房-床位' + r.berthNo;
        },
        endTime: function(t) {
            return t || '-';
        },
        days: function(days) {
            return berth.tool.toDuration(days, 'day');
        },
        amount: function(_, checkin) {
            return checkin.endTime == null ? '-' : checkin.amount;
        },
        state: function(v, checkin) {
            var text = {0: '入住中', 1: '费用已交清', 2: '费用未交清'}[v];
            if (checkin.diffMoney == 0)
                return text;
            else if(checkin.diffMoney > 0) {
                text += '，还欠款' + +checkin.diffMoney.toFixed(2);
            } else {
                text += '，需退款' + -checkin.diffMoney.toFixed(2);
            }
            return text;
        },
        op: function(_0, checkin, index) {
            var html = '';
            if (checkin.state == 2 || checkin.diffMoney < 0)
                html += UICommon.linkHtml({text: '交费', clickCode: 'berthCheckin.pay(' + index + ')'});
            html += '&nbsp;' + UICommon.linkHtml({text: '账单', clickCode: 'berthCheckin.payRecord(' + index + ')'});
            //html += '&nbsp;' + UICommon.linkHtml({text: '详情', clickCode: 'berthCheckin.detail(' + index + ')'});
            return html;
        }
    },
    pay: function(rowIndex) {
        var checkin = $('#dgBerthCheckin').datagrid('getRows')[rowIndex];
        var dlg = openEditDialog({
            title: "交费",
            width: 240,
            height: 180,
            href: 'community/berth/checkin/payForm.do?checkinId=' + checkin.id,
            onLoad: function() {
                $('#frmCheckinPay #berthNo').text(checkin.berthNo);
            },
            onSave: function() {
                formSubmit('#frmCheckinPay', {
                    url: 'community/berth/checkin/payMoney.do',
                    success: function(code) {
                        showOpResultMessage(code);
                        $('#dgBerthCheckinPayRecord').datagrid('reload');
                        dlg.dialog('destroy');
                    }
                });
            }
        });
    },
    payRecord: function(rowIndex) {
        var checkin = $('#dgBerthCheckin').datagrid('getRows')[rowIndex];
        openSimpleDialog({
            width: '50%',
            height: '50%',
            href: 'view/community/berth/checkinPayRecord.do?checkinId=' + checkin.id,
            title: checkin.id + ' - 入住账单'
        });
    },
    detail: function(rowIndex) {
        var checkin = $('#dgBerthCheckin').datagrid('getRows')[rowIndex];
        openSimpleDialog({
            width: '50%',
            height: '50%',
            href: 'view/community/xx' + checkin.id,
            title: checkin.id + ' - 详情'
        });
    }
}