
(function() {
    var buildings = null, nowBuildingIndex = -1;
    var floors = null, nowFloorIndex = -1;
    var isFloorTabClosing = false;
    
    var tabsBuilding = $('#tabsBuilding');
    tabsBuilding.tabs({
        onSelect: function(title, index) {
            var building = buildings[index];
            
            isFloorTabClosing = true;
            var tabsCount = tabsFloor.tabs('tabs').length;
            while (tabsCount--)
                tabsFloor.tabs('close', 0);
            isFloorTabClosing = false;
            
            floors = [];
            for (var n = building.floorsNum; n >= 1; n--) {
                floors.push({building: building, floorNo: n});
                tabsFloor.tabs('add', {
                    title: n + '层',
                    selected: false,
                    iconCls: 'icon-floor'
                });
            }
            nowBuildingIndex = index;
            nowFloorIndex = -1;
            $('#panelRooms').empty();
        }
    });
    
    var berthLoadedSignal = new Signal();
    var tabsFloor = $('#tabsFloor');
    tabsFloor.tabs({
        onSelect: function(title, index) {
            if (isFloorTabClosing) return;
            var floor = floors[index];
            
            var panelRooms = $('#panelRooms');
            panelRooms.empty();
            $.get(
                CONFIG.baseUrl + 'community/berth/checkin/rooms.do',
                {buildingId: floor.building.id, floorNo: floor.floorNo},
                function(rooms) {
                    if (rooms.length > 0) {
                        rooms.forEach(function(room, i) {
                            var room = new DrawbleRoom(room);
                            panelRooms.append(room);
                            room.fadeIn(i * 100);
                        });
                    } else {
                        panelRooms.append(template('emptyFloorInfoTpl', floor));
                    }
                    berthLoadedSignal.dispatch();
                });
            nowFloorIndex = index;
        }
    });

    $.messager.progress();
    $.get(CONFIG.baseUrl + 'community/berth/berthSetting/building/page.do?page=1&rows=100', function(page) {
        buildings = page.rows;
        buildings.forEach(function(building) {
            var tab = tabsBuilding.tabs('add', {
                title: building.buildingNo,
                selected: false,
                iconCls: 'icon-building'
            });
        });
        tabsBuilding.tabs('select', 0);
        if(floors)
            tabsFloor.tabs('select', floors.length - 1);
        $.messager.progress('close');
    });

    $('#selectUser').click(function() {
        var dlg = openUserSelectDialog({
            okButtonText: '查询',
            onSelectDone: function(user) {
                $.get(CONFIG.baseUrl + 'community/berth/checkinRecord/getPositionByUserId.do?userId=' + user.userId, function(pos) {
                    if (!pos) {
                        alertInfo('未查询到数据，可能因为 ' + user.realName + ' 没有当前入住记录');
                        return;
                    }
                    //showOpOkMessage(user.realName + '当前入住在 ' + pos.buildingNo + '栋' + pos.floorNo + '层' + pos.roomNo + '房' + pos.berthNo + '号床位');
                    berthLoadedSignal.addOnce(function() {
                        var berth = $('[data-room-no=' + pos.roomNo + '] [data-berth-no=' + pos.berthNo + ']');
                        (function blink(i, times) {
                            $.fn[i % 2 ? 'addClass' : 'removeClass'].call(berth, 'berth-selected');
                            if (i < times * 2 - 1) {
                                setTimeout(function() {
                                    blink(i + 1, times);
                                }, 100);
                            }
                        })(1, 4);
                    });
                    //根据返回位置定位
                    for (var i = 0; i < buildings.length; i++) {
                        if (buildings[i].buildingNo == pos.buildingNo) {
                            tabsBuilding.tabs('select', i);
                            for (var j = 0; j < floors.length; j++) {
                                if (floors[j].floorNo == pos.floorNo) {
                                    if (nowFloorIndex != j) {
                                        tabsFloor.tabs('select', j);
                                    } else {
                                        berthLoadedSignal.dispatch();
                                    }
                                    break;
                                }
                            }
                            break;
                        }
                    }
                });
                return true;
            }
        });
    });
    
    document.oncontextmenu = function() { return false; }
})();

