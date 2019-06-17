(function() {
    //创建地图实例
    var map = new BMap.Map("orderLocationMapContainer");
    // 设置中心点坐标和地图级别
    map.centerAndZoom(new BMap.Point(116.404, 39.915), 16);
    // 开启鼠标滚轮缩放
    map.enableScrollWheelZoom(true);
    
    // 添加地图控件
    map.addControl(new BMap.NavigationControl());// 添加平移缩放控件
    map.addControl(new BMap.ScaleControl());// 添加比例尺控件
    map.addControl(new BMap.GeolocationControl());// 添加定位控件
    map.addControl(new BMap.CityListControl({
        anchor: BMAP_ANCHOR_TOP_RIGHT,
        offset: BMap.Size(10, 20)
    }));
    var mapMarkerInfoWindowManager = new MapUtils.MapMarkerInfoWindowManager(map);

    var queryParams = {
        startCreateTime: moment().subtract(7, 'd').format('YYYY-MM-DD 00:00:00'),
        endCreateTime: moment().format('YYYY-MM-DD HH:mm:ss')
        //lineState: 0,
    };
    
    $('#order-location-layout [name=query]').click(function() {
        queryParams = $('#frmQueryOrderLocation').serializeObject();
        query();
    });
    
    query();
    setInterval(function() {
        query();
    }, 1000 * 10);
    
    var inited = false;
    var gotoOrderAddressOnLoadSuccess = null;

    function query() {
        $.get(CONFIG.baseUrl + 'shop/order/locationPage.do', queryParams, function (page) {
              page.rows.forEach(function(v) {
                  v.statusColor = workOrder.statusCssByValue(v.status).color;
                  v.statusText = workOrder.statusTextByValue(v.status);
              });
              drawMap(map, page.rows);
        });
    }

    var icons = [];
    ['blue', 'orange', 'green', 'red'].forEach(function(c) {
        icons[c] = new BMap.Icon(CONFIG.baseUrl + "module/shop/order/img/order_" + c + ".png",
            new BMap.Size(30, 30),
            {
                 offset : new BMap.Size(15, 30)
            });
    });
    
    function drawMap(map, array) {
        map.getOverlays().forEach(function(overlay) {
            
            if (!overlay.notclear) {
                map.removeOverlay(overlay);
            }
        });
        
        array = array.filter(function(v) {
            return v.longitude && v.latitude;
        });
        
        array.forEach(function(v, i) {
            var overlay = addOverlay(v);
            overlay.setZIndex(array.length - i + 100);//越新的时间越上层,array按时间降序排序
        });
        
        if (gotoOrderAddressOnLoadSuccess) {
            setTimeout(gotoOrderAddressOnLoadSuccess, 0);
            gotoOrderAddressOnLoadSuccess = null;
            inited = true;
        } else if (!inited || array.length == 1) {
            if (array.length > 0) {
                setTimeout(function() {
                    var v = array[0];
                    map.panTo(new BMap.Point(v.longitude, v.latitude));
                }, 10);
            }
            inited = true;
        }
    }
    
    function addOverlay(v, isTop) {
        var color = workOrder.statusCssByValue(v.status).color;
        var point = new BMap.Point(v.longitude, v.latitude);
        var marker = new BMap.Marker(point, { icon : icons[color] });

        marker.setTitle(v.orderno);

        mapMarkerInfoWindowManager.setDefaultEventHandlers(marker);
        marker.addEventListener("mouseover", function() {
            mapMarkerInfoWindowManager.showInfoWindow(marker, new MapUtils.WindowOverlay({
                center: point,
                width: 400,
                height: 140,
                title: "服务信息",
                content: template('orderInfo.html', v)
            }));
        });

        marker.markerId = v.orderno;
        
        var label = new BMap.Label(v.orderno, {
            position: point,
            offset: new BMap.Size(-47, 30)
        });
        label.setStyle({
            fontWeight: 'bold',
            color : color,
            border: '1px solid ' + '#aaa'
        });
        marker.setLabel(label);
        if (isTop) {
            marker.setTop(true);
        }
        map.addOverlay(marker);// 将标注添加到地图中
        return marker;
    }
    
    var queryOpened = false;
    window.openQuery = function() {
            if (!queryOpened) {
                $('.order-location-query-form').fadeIn('fast');
                queryOpened = !queryOpened;
            } else {
                $('.order-location-query-form').fadeOut('fast');
                queryOpened = !queryOpened;
                return;
            }
            
            $('#frmQueryOrderLocation #statuses').comboboxFromDict({
                dict: workOrder.statusItems,
                enableEmptyItem: false,
                emptyItem: {text: '全部', value: ''},
                value: '',
                formatter: function(row) {
                    return row.value ? workOrder.statusHtmlByValue(row.value.split(',')[0]) : row.text;
                },
                onSelect: function(row) {
                    var textbox = $(this).next().find('.textbox-text');
                    if (row.value)
                        textbox.css(workOrder.statusCssByValue(row.value.split(',')[0]));
                    else {
                        textbox.css({color: 'black'});
                    }
                }
            });
            $('#frmQueryOrderLocation').form('load', queryParams);
        };

    window.gotoOrder = function(orderno) {
            gotoOrderAddressOnLoadSuccess = function() {
                var marker = null;
                var overlays = map.getOverlays();
                if (overlays && overlays.length > 0) {
                    for (var i = 0; i < overlays.length; i++) {
                        if (overlays[i].markerId && orderno == overlays[i].markerId) {
                            marker = overlays[i];
                            break;
                        }
                    }
                }
                if (!marker) {
                    $.get(CONFIG.baseUrl + 'shop/order/detail.do?orderCode=' + orderno, function(order) {
                        order.statusColor = workOrder.statusCssByValue(order.status).color;
                        order.statusText = workOrder.statusTextByValue(order.status);
                        var overlay = addOverlay(order, true);
                        overlay.notclear = true;
                        map.panTo(new BMap.Point(order.longitude, order.latitude));
                        mapMarkerInfoWindowManager.toBounceMarker(overlay);
                    });
                } else {
                    marker.setTop(true);
                    map.panTo(marker.getPosition());
                    mapMarkerInfoWindowManager.toBounceMarker(marker);
                }
            }
 
            //如果地图已经初始化,立即执行
            if (inited) {
                setTimeout(gotoOrderAddressOnLoadSuccess, 0);
                gotoOrderAddressOnLoadSuccess = null;
            }
        };

    window.isCreated = function() {
            return $('#orderLocationMapContainer').length != 0;
    };
})();