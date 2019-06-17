var volunteerLocation = (function() {
	// 创建地图实例
	var map = new BMap.Map("volunteerLocationMapContainer");
	// 设置中心点坐标和地图级别
	map.centerAndZoom(new BMap.Point(116.404, 39.915), 16);
	// 开启鼠标滚轮缩放
	map.enableScrollWheelZoom(true);

	// 添加地图控件
	map.addControl(new BMap.NavigationControl());// 添加平移缩放控件
	map.addControl(new BMap.ScaleControl());// 添加比例尺控件
	map.addControl(new BMap.GeolocationControl());// 添加定位控件
	map.addControl(new BMap.CityListControl({
		anchor : BMAP_ANCHOR_TOP_RIGHT,
		offset : BMap.Size(10, 20)
	}));
    setTimeout(function() {
	$('#volunteerLocationLayout #volunteerLocationDatagrid').datagrid({
		url : CONFIG.baseUrl + 'shop/volunteer/page.do',
		pagination : true,
		pagePosition : 'bottom',
		pageNumber : 1,
		pageSize : 100,
		pageList : [ 10, 20, 50, 100, 200 ],
		fit : true,
		onLoadSuccess : function(page) {
			drawMap(map, page.rows);
		},
		onClickRow : function(index, row) {
			gotoPosition(map, index, row);
		},
		singleSelect : true,
		toolbar : '#volunteerLocationLayout [name=tbr]'
	});
    }, 0);
	setInterval(function() {
		$('#volunteerLocationDatagrid').datagrid('load');
	}, 1000 * 60);
	$(function() {
		$('#volunteerLocationLayout #query').click(function() {
		    $('#volunteerLocationDatagrid').datagrid('load', $('#queryForm').serializeObject());
		});
	});
    var mapMarkerInfoWindowManager = new MapUtils.MapMarkerInfoWindowManager(map);
	function drawMap(map, array) {
		map.clearOverlays();
		var myIcon = new BMap.Icon(CONFIG.imagePath + "employer_busy.png",
				new BMap.Size(23, 25), {
					offset : new BMap.Size(15, 30)
				});
		array = array.filter(function(v) {
			return v.longitude && v.latitude;
		});
		array.forEach(function(v, i) {
					var point = new BMap.Point(v.longitude, v.latitude);
					var marker = new BMap.Marker(point);
					marker.setTitle(v.realName);
					mapMarkerInfoWindowManager.setDefaultEventHandlers(marker);
					marker.addEventListener("mouseover", function() {
						mapMarkerInfoWindowManager.showInfoWindow(marker, new MapUtils.WindowOverlay({
							center: point,
							width: 400,
							height: 360,
							title: "志愿者信息",
							content: template('volunteerInfo.html', v)
						}));
					});

					marker.markerId = v.userId;
					var label = new BMap.Label(v.realName, {
						position : point,
						offset : new BMap.Size(marker.getTitle().length == 2 ? -4.5 : -10.5, 30)
					});
					label.setStyle({
						fontWeight : 'bold',
						color : 'black',
						border : '1px solid red'
					});
					marker.setLabel(label);
					map.addOverlay(marker);// 将标注添加到地图中
					// map.addOverlay(label);
				});
		if (array.length > 0) {
            var v = array[0];
            map.panTo(new BMap.Point(v.longitude, v.latitude));
        }
	}
	;
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
					if (marker.markerId && row.userId == marker.markerId) {
						toBounceMarker(marker);
					}
				}
			}
		}
	}

	return {
	    formatters: {
	        status: function(v) {
	            return v ? '<span style="color:gray">离线</span>' : '<span style="color:green">空闲</span>';
	        }
	    }
	}
})();
