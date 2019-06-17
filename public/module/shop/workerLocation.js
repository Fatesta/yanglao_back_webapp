define(['/lib/utils/template.js'], function(template) {
    return function() {
        //创建地图实例
        var map = new BMap.Map("workerLocationMapContainer");
        // 设置中心点坐标和地图级别
        map.centerAndZoom(new BMap.Point(116.404, 39.915), 11);
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
        
        $('#workerLocationLayout #workerLocationDatagrid').datagrid({
            url: CONFIG.baseUrl + 'shop/location/page.do?type=employee',
              pageSize:100,
              pageList:[10,20,50,100,200],
              rownumbers: false,
              fit:true,
              onLoadSuccess: function (page) {
                  page.rows.forEach(function(v) {
                      v.providerName = v.providerName && v.providerName.replaceAll(',', '、');
                      v.orderCodes = v.orderCodes && v.orderCodes.replaceAll(',', '、');
                  });
                  drawMap(map, page.rows);
              },
              onClickRow: function(index, row) {
                  gotoPosition(map, index, row);
              }
        });

        setInterval(function() {
            $('#workerLocationDatagrid').datagrid('load');
        }, 1000 * 60);
        
        $(function() {
            $('#workerLocationLayout #query').click(function(){
                $('#workerLocationDatagrid').datagrid('load', $('#queryForm').serializeObject());
            });
        });
    };
    
    function drawMap(map, array) {
        map.clearOverlays();
        
        var icons = {
            busy_employee: 
                new BMap.Icon(CONFIG.imagePath + "employer_busy.png", // 图标地址
                    new BMap.Size(30, 30),
                    {
                         offset : new BMap.Size(15, 30) // 定位的位置与图标左上角的偏移量
                    }),
                    
            idel_employee:
                new BMap.Icon(CONFIG.imagePath + "employer_idle.png",
                    new BMap.Size(30, 30),
                    {
                         offset : new BMap.Size(15, 30)
                    }),
        };
        
        array = array.filter(function(v) {
            return v.longitude && v.latitude;
        });

        var mapMarkerInfoWindowManager = new MapUtils.MapMarkerInfoWindowManager(map);
        array.forEach(function(v, i) {
            var type = v.state == 0 ? 'idel_employee' : 'busy_employee';
            var point = new BMap.Point(v.longitude, v.latitude);
            var marker = new BMap.Marker(point, { icon : icons[type] });
            
            marker.setTitle(v.realName);

            mapMarkerInfoWindowManager.setDefaultEventHandlers(marker);
            marker.addEventListener("mouseover", function() {
                mapMarkerInfoWindowManager.showInfoWindow(marker, new MapUtils.WindowOverlay({
                    center: point,
                    width: 400,
                    height: 240,
                    title: "服务人员信息",
                    content: template('workerInfo.html', v)
                }));
            });

            marker.markerId = v.workerId;
            
            var label = new BMap.Label(v.realName, {
                position: point,
                offset: new BMap.Size(-15, 30)
            });
            label.setStyle({
                fontWeight: 'bold',
                color : "black",
                border: '1px solid black'
            });
            marker.setLabel(label);
            map.addOverlay(marker);// 将标注添加到地图中
            //map.addOverlay(label);
        });
        
        var v = array[0];
        map.panTo(new BMap.Point(v.longitude, v.latitude));
    }
    
    // 定位到地图的指定坐标
    function gotoPosition(map, index, row) {
        if (row.longitude && row.latitude && row.longitude != 0
                && row.latitude != 0) {
            var point = new BMap.Point(row.longitude, row.latitude);
            map.panTo(point);
            var overlays = map.getOverlays();
            if (overlays && overlays.length > 0) {
                for (var i = 0; i < overlays.length; i++) {
                    var marker = overlays[i];
                    if (marker.markerId && row.workerId == marker.markerId) {
                        toBounceMarker(marker);
                    }
                }
            }
        }
    }
});