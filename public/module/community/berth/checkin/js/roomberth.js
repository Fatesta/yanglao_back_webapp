$('#berthMenu > [name=checkinRecord]').click(function() {
    openTab({
        url: 'view/community/berth/checkinRecord.do?berthId=' + $('#berthMenu').data('berth').id,
        title: '入住记录'
    });
});
$('#berthMenu > [name=checkinPayRecord]').click(function() {
    openTab({
        url: 'view/community/berth/checkinPayRecord.do?berthId=' + $('#berthMenu').data('berth').id,
        title: '床位' + $('#berthMenu').data('berth').berthNo + ' - 历史账单'
    });
});
$('#berthMenu > [name=userInfo]').click(function() {
    openUserBasicInfo($('#berthMenu').data('berth').berthCheckin.userId);
});
$('#berthMenu > [name=updateDeposit]').click(function() {
    var dlg = openEditDialog({
        title: "交押金",
        width: 240,
        height: 180,
        href: 'community/berth/checkin/depositForm.do?checkinId=' + $('#berthMenu').data('berth').berthCheckin.id,
        onLoad: function() {
            $('#frmCheckinDeposit #berthNo').text($('#berthMenu').data('berth').berthNo);
        },
        onSave: function() {
            formSubmit('#frmCheckinDeposit', {
                url: 'community/berth/checkin/updateDeposit.do',
                success: function(code) {
                    showOpResultMessage(code);
                    dlg.dialog('destroy');
                }
            });
        }
    });
});
$('#berthMenu > [name=setServicePlan]').click(function() {
    openModuleByCode('servicePlan');
});
$('#berthMenu > [name=setSmartDevice]').click(function() {
    openTab({
        url: 'view/community/berth/berthDevice/index.do?berthId=' + $('#berthMenu').data('berth').id,
        title: '床位' + $('#berthMenu').data('berth').berthNo + ' - 绑定和配置智能设置'
    });
});

var currOpBerth = null;

function DrawbleRoom(room) {
    var el = $(template('roomTpl', room));
    el.hide();
    
    room.berths.forEach(function(berth) {
        var dberth = new DrawbleBerth(berth);
        el.append(dberth);
    });

    return el;
}

function DrawbleBerth(berth) {
    var self = {};
    var container;
    function load(berth) {
        if (!berth.isEmpty) {
            if (berth.berthCheckin == null) {
                berth.berthCheckin = {userInfo: null};
            }
        }
        container = $(document.createElement('div'));
        container
            .addClass('berth')
            .data('berth-no', berth.berthNo)
            .attr('data-berth-no', berth.berthNo)
            .attr('title', '床位' + berth.berthNo);
        container.append('<h2>' + berth.berthNo + '</h2>');
        updateContent(berth);
        
        container.find('.berth-user-photo').click(function(){
            openUserBasicInfo($(this).data('userId'));
        });
    }
    
    function updateContent(berth) {
        container.mousedown(function(e) {
            e.preventDefault();
            if (e.button == 2) {
                $('#berthMenu').data('berth', berth);
                if (berth.isEmpty) {
                    $('#berthMenu > [name=userInfo]').hide();
                    $('#berthMenu > [name=updateDeposit]').hide();
                } else {
                    $('#berthMenu > [name=userInfo]').show();
                    $('#berthMenu > [name=updateDeposit]').show();
                }
                $('#berthMenu').menu('show', {
                    left: e.pageX,
                    top: e.pageY
                }).show();
                return false;
            }
        });
        container.mouseover(function() {
            if ($(this).is('.berth-selected'))
                $(this).removeClass('berth-selected');
        });
        container.removeClass().addClass('berth');
        if (berth.isEmpty) {
            container.addClass('state-empty');
            container.append($(template('emptyBerthTpl', {berth: berth})));
            container.find('[name=ruzhu]').click(function() {
                currOpBerth = self;
                openTab({
                    url: 'view/community/berth/checkin/checkinForm.do?berthId=' + berth.id + '&berthNo=' + berth.berthNo,
                    title: '登记入住'
                });
            });
        } else {
            container.addClass('state-used');
            container.append($(template('usedBerthTpl', {berth: berth})));
            container.find('[name=tuizhu]').click(function() {
                currOpBerth = self;
                openTab({
                    url: 'community/berth/checkin/leaveForm.do?berthId=' + berth.id,
                    title: '办理退住'
                });
            });
            container.find('[name=options]').click(function() {
                alert('options')
            });
        }
    }

    self.update = function() {
        $.get(CONFIG.baseUrl + 'community/berth/checkin/berthStateDetail.do?id=' + berth.id, function(berth) {
            container.find('.box-l, .box-r').remove();
            updateContent(berth);
        });
    }

    load(berth);

    return container;
}