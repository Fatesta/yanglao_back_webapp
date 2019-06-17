<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/module/common.jsp" %>
        <style>
        .resultPanel {
            position: absolute;
            overflow-y: auto;
            top: 40px;
            left: 80px;
            height: 300px;
            background-color: white;
            border: 1px solid #c4c7cc;
        }
        .result {
            border-width: 1px;
            border-color: #E0ECFF;
            border-style: solid;
            padding: 10px;
            width: 200px;
            font-size: 15px;
            color: #0E2D5F;
        }
    </style>
<script src="https://api.map.baidu.com/api?v=2.0&ak=eG3uGEnyuW1igyG7C9PemZ4LPV6pNCBc" ></script>
</head>
<body>
<div id="container" style="width: 100%;height:100%;"></div>
<div id="results" class="resultPanel" style="height: 42px;"></div>
<script>

	//创建地图实例
	var map = new BMap.Map("container");
	
	// 设置中心点坐标和地图级别
	map.centerAndZoom(new BMap.Point(116.404, 39.915), 18);
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
	
	refreshPosition();

	function refreshPosition() {
		$.get("${urlPath}device/loadDevicePosition.do", {deviceId:"${deviceId}"}, function(data) {
			updateMap(data);
			//setTimeout("refreshPosition()", 3000);
		});
	}
	
	function updateMap(data) {
	    if (!data)
	        return;
		var defaultImg = "${imagePath}my.png";
		map.clearOverlays();
		if (data && data.longitude && data.latitude) {
			var point = new BMap.Point(data.longitude,data.latitude);
			var marker = new BMap.Marker(point);// 创建标注
			map.addOverlay(marker);// 将标注添加到地图中
			var label = new BMap.Label(data.createTime, {offset: new BMap.Size(20,-10)});
			marker.setLabel(label);
			marker.setTitle("设备号：" + data.deviceCode);
			if (data.imagePath || data.imagePath == "") {// 设置默认图片
				data.imagePath = defaultImg;
			}
			map.panTo(point);
		}
		$("#results").empty();
		var dom = "<div class=\"result\" title=\"" + data.aliasName + "\">" + data.aliasName.substring(0, 9) + 
					"<img class=\"head_img\" src=\""+ defaultImg +"\">";
		if (data.deviceId[0] != '0')//不是子女用户
		    dom += "<div class='icon-set-security-zone' title=\"设置安全区域\" onclick=\"showSetSecurityZone('" + data.deviceId + "')\" style='float:right;width:20px;cursor:pointer'>&nbsp;</div>"
		dom += "<div class='icon-view-trace-information' title=\"查看轨迹\" onclick=\"showTrace('{0}','{1}')\" style='float:right;width:20px;cursor:pointer'>&nbsp;</div>".format(data.deviceCode, data.deviceId) +
			  	  "</div>";
		$("#results").append(dom);
	}
	
	function showTrace(deviceCode, deviceId) {
		openTab("mainTab", "${urlPath}group/showTraceGrid.do?deviceCode=" + deviceCode + "&deviceId=" + deviceId, "设备轨迹");
	}
	
	function showSetSecurityZone(deviceId) {
		openTab("mainTab", "${urlPath}group/showSetSecurityZoneGrid.do?deviceId=" + deviceId, "设置安全区域");
	}
	
</script>
</body>
</html>