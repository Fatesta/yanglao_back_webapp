<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/module/common.jsp" %>
<script src="https://api.map.baidu.com/api?v=2.0&ak=eG3uGEnyuW1igyG7C9PemZ4LPV6pNCBc" ></script>
<style type="text/css">
	body, html {width: 100%;height: 100%;overflow: hidden;margin:0;font-family:"微软雅黑";}
	#map1_container,#map2_container {width:100%;height:100%;overflow: hidden;margin:0;position:absolute;}
	#allmap1{margin:0 5px 0 0 ;height:100%;}
	#allmap2{margin:0 0 5px 0;height:100%;}
</style>
</head>
<body>
<div id="map2_container">
	<div id="allmap2"></div>
</div>
<script>
	//加载第二张地图
	var map2 = new BMap.Map("allmap2");            // 创建Map实例
	var point2 = new BMap.Point(116.404, 39.915);  
	map2.centerAndZoom(point2, 15);                 
	map2.enableScrollWheelZoom(true);                  //启用滚轮放大缩小
	// 添加地图控件
	map2.addControl(new BMap.NavigationControl());// 添加平移缩放控件
	map2.addControl(new BMap.ScaleControl());// 添加比例尺控件
	map2.addControl(new BMap.GeolocationControl());// 添加定位控件
	map2.addControl(new BMap.CityListControl({
    	anchor: BMAP_ANCHOR_TOP_RIGHT,
    	offset: BMap.Size(10, 20)
	}));
	var activeZoneSecurityInfo = {radius: 500};
    map2.addEventListener("click", function(e) {
        activeZoneSecurityInfo.longitude = e.point.lng;
        activeZoneSecurityInfo.latitude = e.point.lat;
        setActiveZone(activeZoneSecurityInfo);
    });
	refreshActiveZone();
	
	function setActiveZone(s) {
		var dlg = openEditDialog({
		    title: "设活动区域",
		    width: 480,
		    height: 300,
		    href: "group/showSetActiveZoneForm.do?deviceUserId=${deviceId}&longitude="
                + s.longitude + "&latitude=" + s.latitude + '&radius=' + s.radius,
		    onSave: function(){
				$("#setAvtiveZoneForm").form("submit", {
					url:"${urlPath }group/setActiveZone.do",
					success:function(data){
						var data = str2Json(data);
						if (data.success) {
							dlg.dialog("destroy");
							refreshActiveZone();
							showMessage('系统提示', data.message);
						} else {
							showAlert(data.title,data.message,'error');
						}
					}
				});
			}
		});
	}
	
	function refreshActiveZone() {
		$.get("${urlPath}group/getSecurity.do", {deviceUserId:"${deviceId}", orderId:"2"}, function(data) {
			if (data) {
                activeZoneSecurityInfo = data;
				map2.clearOverlays();
				var point = new BMap.Point(data.longitude,data.latitude);
				var marker = new BMap.Marker(point);// 创建标注
				marker.setIcon(new BMap.Icon("${imagePath}safe_school.png", new BMap.Size(60, 60)));
				var c = new BMap.Circle(point, data.radius);
				map2.addOverlay(marker);// 将标注添加到地图中
				map2.addOverlay(c);
				map2.panTo(point);
			}
		});
	}
</script>
</body>
</html>