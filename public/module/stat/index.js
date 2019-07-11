var stat = {};
stat.onCollapseClick = function() {
    $('.summary-table-container').animate({
        top: "-52px"
    }, 500)
};
$('#statMapContainer').mousemove(function(e) {
    if (e.offsetY < 10) {
        $('.summary-table-container').animate({
            top: '2px'
        }, 500);
    }
});

//创建地图实例
var map = new BMap.Map("statMapContainer");
stat.map = map;
// 开启鼠标滚轮缩放
map.enableScrollWheelZoom(true);

// 添加地图控件
map.addControl(new BMap.NavigationControl({
    anchor: BMAP_ANCHOR_TOP_LEFT,
    offset: new BMap.Size(10, 60)
}));// 添加平移缩放控件
map.addControl(new BMap.ScaleControl());// 添加比例尺控件
map.addControl(new BMap.GeolocationControl());// 添加定位控件
map.addControl(new BMap.CityListControl({
    anchor: BMAP_ANCHOR_TOP_RIGHT,
    offset: new BMap.Size(10, 20)
}));
stat.mapMarkerInfoWindowManager = new MapUtils.MapMarkerInfoWindowManager(map, {delay: 0});
new BMap.LocalCity().get(function(result){
    var point = new BMap.Point(result.center.lng, result.center.lat);
    map.centerAndZoom(point, result.level);
});

/*
map.addEventListener('moveend', function() {
    stat.drawMapPoints();
});
map.addEventListener('dragend', function() {
    stat.drawMapPoints();
});
map.addEventListener('zoomend', function() {
    stat.drawMapPoints();
});*/
// 定位到地图的指定坐标
stat.gotoPosition = function (index, row, idField) {
    idField = idField || 'deviceId';
    var map = stat.map;
    setTimeout(function() {
        //stat.drawMapPoints(function() {
            var found = false;
            for (var i = 0, markers = map.getOverlays(); i < markers.length; i++) {
                var marker = markers[i];
                if (row[idField] == marker.id) {
                    panTo(marker.getPosition(), marker);
                    found = true;
                    break;
                }
            }
            if (!found && (row.longitude && row.latitude)) {
                var marker = stat.addMarkerByMapPoint({
                    id: row[idField],
                    type: row.role == -1 ? '2' : '1',
                    point: new BMap.Point(row.longitude, row.latitude)
                });
                panTo(new BMap.Point(row.longitude, row.latitude), marker);
            }
        //});
    }, 10);

    function panTo(point, marker) {
        map.setZoom(17);
        map.panTo(point);
        if (marker) {
            setTimeout(function () {
                stat.mapMarkerInfoWindowManager.toBounceMarker(marker);
            }, 200);
        }
    }
};

$.get('/api/datastat/numberInMap', function(ret) {
    $('#stat-numbers-table td').each(function() {
        $(this).text(ret[$(this).attr('name')]);
    });
});

stat.allMapPoints = [];
$.get('/api/stat/mapPoints', function(csv) {
    stat.allMapPoints = [];
    var mapPoints = stat.allMapPoints;
    var values = csv.split(',');
    var pointSet = new Set();

    var lng, lat;
    for (var i = 0; i < values.length; i += 4) {
        lng = values[i + 2];
        lat = values[i + 3];
        if (!pointSet.has(lng + lat)) {
            mapPoints.push({
                id: values[i + 0],
                type: values[i + 1],
                point: new BMap.Point(lng, lat)
            });
            pointSet.add(lng + lat);
        }
    }
    /*
    var importantMapPoints = [], otherMapPoints = [];
    stat.allMapPoints.forEach(function(p) {
        if (["1"].indexOf(p.type) == -1) {
            importantMapPoints.push(p);
        } else {
            otherMapPoints.push(p);
        }
    });

    //stat.allMapPoints = importantMapPoints.concat(otherMapPoints.slice(0, 3000));*/
    stat.drawMapPoints(function() {
        if (window.top.admin.roleId != 1) {
            $.get('/api/community/get?id=' + window.top.admin.orgId, function(ret) {
                if (ret.longitude && ret.latitude) {
                    var point = new BMap.Point(ret.longitude, ret.latitude);
                    map.panTo(point, {noAnimation: false});
                }
            });
        }
    });
});

stat.addMarkerByMapPoint = (function() {
    var Marker = BMap.Marker;
    var Icon = BMap.Icon;
    var Size = BMap.Size;
    var map = stat.map;

    var serviceResourceTypeMap = DictMan.itemDetailMap('serviceResource.type');

    var mapPointTypeMarkerSetters = {
        'user': function (marker, mapPoint) {
            marker.addEventListener("mouseover", function () {
                if (mapPoint.details) {
                    showInfo(mapPoint.details);
                } else {
                    $.get(CONFIG.baseUrl + 'api/user/profileWithEval?userId=' + mapPoint.id, function (ret) {
                        showInfo(ret);
                        mapPoint.details = ret;
                    });
                }
            });

            function showInfo(userInfo) {
                stat.mapMarkerInfoWindowManager.showInfoWindow(marker, new MapUtils.WindowOverlay({
                    center: marker.getPosition(),
                    width: 400,
                    height: userInfo.evalInfo ? 410 : 240,
                    title: "用户信息",
                    content: template('marker-info-user', userInfo)
                }));
            }
        },
        serviceResource: (function () {
            return function (marker, mapPoint) {
                marker.addEventListener("mouseover", function () {
                    if (mapPoint.details) {
                        showInfo(mapPoint.details);
                    } else {
                        $.get(CONFIG.baseUrl + 'api/serviceResource?id=' + mapPoint.id, function (serviceResource) {
                            serviceResource.type = serviceResourceTypeMap[serviceResource.serviceType].value;
                            showInfo(serviceResource);
                            mapPoint.details = serviceResource;
                        });
                    }
                });

                function showInfo(serviceResource) {
                    stat.mapMarkerInfoWindowManager.showInfoWindow(marker, new MapUtils.WindowOverlay({
                        center: marker.getPosition(),
                        width: 400,
                        height: 240,
                        title: "服务资源信息",
                        content: template('marker-info-serviceResource', serviceResource)
                    }));
                }
            }
        })()
    };

    return function(mapPoint) {
        let marker = makeMarker(mapPoint);
        map.addOverlay(marker);
        return marker;
    };

    function makeMarker(mapPoint) {
        if (mapPoint.marker)
            return mapPoint.marker;

        // 根据类型获取图标
        var iconName = 'location';
        switch (mapPoint.type) {
            case '1':
                iconName = 'location';
                break;
            case '2':
                iconName = 'special_man_location';
                break;
            default:
                iconName = serviceResourceTypeMap[mapPoint.type] ? serviceResourceTypeMap[mapPoint.type].note : 'otherservice';
                break;
        }
        var marker = new Marker(mapPoint.point,
            {icon: new Icon(
                    CONFIG.modulePath + 'stat/img/' + iconName + '.png?v=1',
                    new BMap.Size(30, 30),
                    {offset: new Size(15, 30)})});
        marker.setTitle('');
        switch (mapPoint.type) {
            case '1':
                mapPointTypeMarkerSetters['user'](marker, mapPoint);
                break;
            case '2':
                mapPointTypeMarkerSetters['user'](marker, mapPoint);
                break;
            default:
                mapPointTypeMarkerSetters['serviceResource'](marker, mapPoint);
                break;
        }
        marker.id = mapPoint.id;
        stat.mapMarkerInfoWindowManager.setDefaultEventHandlers(marker);
        mapPoint.marker = marker;
        return marker;
    }
})();

stat.drawMapPoints = function(onDone) {
    setTimeout(function () {
        if (stat.allMapPoints.length == 0) {
            setTimeout(stat.drawMapPoints, 100);
            return;
        }

        map.clearOverlays();
        //var containsPoint = map.getBounds().containsPoint.bind(map.getBounds());

        var addMarkerByMapPoint = stat.addMarkerByMapPoint;
        stat.allMapPoints.forEach(function (mapPoint) {
            addMarkerByMapPoint(mapPoint);
        });
        onDone && onDone();
        /*
        var BATCH_COUNT = 100;
        for (var i = 0, mapPoints = stat.allMapPoints; i < mapPoints.length; i += BATCH_COUNT) {
            (function(j){
                setTimeout(function() {
                    var k = j + BATCH_COUNT;
                    k = k < mapPoints.length ? k : mapPoints.length;
                    console.log('开始画第%d批的点, 索引%d~%d', (j / BATCH_COUNT) + 1, j, k);
                    for (; j < k; j++) {
                        addMarkerByMapPoint(mapPoints[j]);
                    }
                    if (j >= mapPoints.length) {
                        console.log('done');
                        onDone && onDone();
                    }
                }, 100);
            })(i);
        }*/

    }, 10);
}

/* 设备搜索 */
stat.deviceQuery = (function(){
    var inited = false;
    $('#deviceGridToolbar').find('[name=query]').click(function() {
        var params = $("#searchDeviceForm").serializeObject();
        if (!inited) {
            $('#deviceGrid').datagrid({queryParams: params});
            inited = true;
        } else {
            $('#deviceGrid').datagrid('load', params);
        }
    });
    $('#deviceGridToolbar').find('[name=clear]').click(function() {
        $(this).linkbutton('clearQuery', '#deviceGrid');
    });

    initUserQuerier($('#deviceGridToolbar [name=userQuerier]'), '#searchDeviceForm', $('#deviceGrid'), null,{
        allUserTypeValue: -3,
        disableApplyTypes: true
    });

    return {
        formatters: {
            op: function(value, row, index) {
                return genShowMonitorButton(row);
            },
            aliasName: function(text, row) {
                return row.role == -1 ? '<span style="color:#ef5238">' + text + '</span>' : text;
            },
            onLine: (function() {
                var iconTable = {
                    0: ['icon-app-user', 'icon-app-user'],
                    1: ['icon-app-user','icon-app-user'],
                    2: ['icon-vipcard', 'icon-vipcard'],
                    3: ['icon-telephone-offline', 'icon-telephone-online'],
                    9: ['icon-offline', 'icon-online']
                };
                return function(value, row) {
                    return '<div title=' + (value ? '在线' : '离线')
                        + ' class=' + iconTable[row.deviceId[0]][+value] + '>&nbsp;</div>';
                }
            })()
        },
        gotoPositionByTelephone: function(number) {
            openModuleByCode('taishitu');
            $.get(CONFIG.baseUrl + 'stat/listDevice.do?telphone=' + number, function(page) {
                if (page.rows.length == 0) {
                    return;
                }
                var userLoc = page.rows[0];
                stat.gotoPosition(0, userLoc, 'userId');
            });
        },
        gotoPositionByUserId: function(userId) {
            openModuleByCode('taishitu');
            $.get(CONFIG.baseUrl + 'stat/listDevice.do?userId=' + userId, function(page) {
                if (page.rows.length == 0) {
                    return;
                }
                var userLoc = page.rows[0];
                stat.gotoPosition(0, userLoc, 'userId');
            });
        }
    };
})();

(function() {
    stat.refresh = function() {
        var tab = $("#statTabs").tabs("getSelected");
        var title = tab.panel("options").title;
        if (title == "系统告警") {
            $('#statGridToolbar').find('[name=query]').trigger("click");
        } else if (title == "告警处理记录") {
            deviceAlarmManager.query();
        } else {
            $('#deviceGridToolbar').find('[name=query]').trigger("click");
        }
    }
    
    $('#statTabs').tabs({
        selected: 2,
        onSelect: stat.refresh
    });

    setInterval(function refreshData() {
        stat.refresh();
    }, 600000);

    window.genShowMonitorButton = function(row) {
        if (row.monitorOk && row.deviceSerial) {
            return '<a href="#" class="easyui-linkbutton" data-options="iconCls:\'color:fff\'" onclick=stat.openVideo("'
                        + row.deviceCode + '","' + row.aliasName + '")>'+ 
                        '<div title="查看监控" class=\'icon-camera\' style="float:left;width:20px;">&nbsp;</div></a>';
        }
        return "";
    }

    stat.openVideo = new VideoArrayWindow().openVideo;
})();

var dangerManage = (function(){
    $.get(CONFIG.baseUrl + "stat/countDanger.do", {}, function(items) {
        var total = items.reduce(function (total, item) {
            $('#dangerStatTable [data-key=' + item.dangerType + ']').text(item.dangerCount);
            return total + item.dangerCount;
        }, 0);
        $('#dangerStatTable [data-key=0]').text(total);
    });

    $('#statGridToolbar').find('[name=query]').click(searchQuery);
    
    $('#stat').find('[name=clear]').click(function() {
        $(this).linkbutton('clearQuery', '#statGrid');
    });
    
    function searchQuery() {
        $(this).linkbutton('search', {grid:'#statGrid', form:'#searchStatForm'});
    }
    
    setTimeout(timeRefresh, 600000);
    
    function timeRefresh() {
        searchQuery();
        setTimeout(timeRefresh, 600000);
    }

    return {
        formatters: {
            deviceCode: function(value, row, index) {
                return "<span title='" + (row.deviceCode == null ? "" : row.deviceCode) + "'>" + value + "</span>";
            },
            remark: function(value, row, index) {
                var html = '<img src="' + CONFIG.imagePath
                    + {1:"off_line", 2: "out_security", 4:"battery_low", 6:"health"}[row.dangerType]
                    + '.png" width=16 height=18/>';
                return html + "&nbsp;<span style='display:inline' title='" + (row.remark == null ? "" : row.remark) + "'>"
                        + value + "</span>";
            },
            op: function(value, row, index) {
                return '<a href="#" class="easyui-linkbutton" data-options="iconCls:\'color:fff\'"'
                    + 'onclick=dangerManage.handleAlarm({0},"{1}","{2}",{3})>'.format(row.id, row.userId, row.deviceId, row.dangerType)
                    + '<div title="处理" class=\'icon-edit\' style="float:left;width:20px;">&nbsp;</div></a>'
                    + genShowMonitorButton(row);
            }
        },
        handleAlarm: function(deviceStatId, userId, deviceId, dangerType) {
            var param = {id: deviceStatId, userId: userId, deviceId: deviceId, dangerType: dangerType};
            window.dlgHandleAlarm = openEditDialog({
                title: "处理告警",
                width: 540,
                height: '80%',
                href: "stat/frmHandleAlarm.do?" + $.param(param),
                onSave: function(){
                    submitForm("frmHandleAlarm", CONFIG.baseUrl + "stat/saveDeviceAlarmOp.do", function(ret){
                        ret = JSON.parse(ret);
                        if (ret.success) {
                            showMessage("操作提示", ret.message);
                            dlgHandleAlarm.dialog("close");
                            var dg = $("#statGrid");
                            if(ret.data)
                                dg.datagrid("deleteRow", dg.datagrid("getRowIndex", dg.datagrid("getSelected")));
                            else
                                dg.datagrid("reload");
                            setCount();//重设总统计
                        } else {
                            showMessage("操作提示", ret.message + ", 请刷新系统告警列表后重试");
                        }
                    });
                }
            });
        }
            
    };
})();
$('#statGrid').datagrid();

/* 告警 */
var deviceAlarmManager = (function(){
    var that = {};
    
    var inited = false;
    that.query = function() {
        var params = $("#frmQuery").serializeObject();
        if (!inited) {
            $('#dgDeviceAlarmOp').datagrid({queryParams: params});
            inited = true;
        } else {
            $("#dgDeviceAlarmOp").datagrid("load", params);
        }
    }
    
    return that;
})();
deviceAlarmManager.formatters = {
    remark: UICommon.datagrid.formatter.generators.omit({dgId: "dgDeviceAlarmOp", field: "remark"}),
    operation: UICommon.datagrid.formatter.generators.omit({dgId: "dgDeviceAlarmOp", field: "operation"})
};