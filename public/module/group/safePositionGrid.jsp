<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/module/common.jsp" %>
	<style>
		.resultPanel_header {
			position: absolute;
			top: 50px;
			left: 80px;
			width: 200px;
			height: 30px;
			background-color: white;
		}
		.resultPanel {
			position: absolute;
			overflow-y: auto;
			top: 80px;
			right: 100px;
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
<div class="resultPanel_header">
	<table class="form">
		<tr>
			<td>
				<input id="ss" style="width:185px;"
        			data-options="searcher:search,prompt:'搜索呼贝'"></input>
			</td>
		</tr>
	</table>
</div>
<div id="results" class="resultPanel">
	
</div>
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
	
	$("#ss").searchbox({});
	refreshPosition();

	function refreshPosition() {
		var aliasName = $("#ss").searchbox("getValue");
		$.get("${urlPath}group/listDevicePositionByGroup.do", {groupCreator:"${groupCreator}", groupId:"${groupId}", aliasName:aliasName}, function(data) {
			updateMap(data);
			setTimeout("refreshPosition()", 3000);
		});
	}
	
	function updateMap(data) {
		var defaultImg = "${imagePath}my.png";
		$("#results").empty();
		map.clearOverlays();
		$.each(data, function(i, v){
			if (v.longitude && v.latitude) {
				var point = new BMap.Point(v.longitude,v.latitude);
				var marker = new BMap.Marker(point);// 创建标注
				map.addOverlay(marker);// 将标注添加到地图中
				var label = new BMap.Label(v.createTime, {offset: new BMap.Size(20,-10)});
				marker.setLabel(label);
				marker.setTitle("设备号：" + v.deviceCode);
				if (v.imagePath || v.imagePath == "") {// 设置默认图片
					v.imagePath = defaultImg;
				}
				if (i == 0) {
					map.panTo(point);
				}
			}
			var dom = "<div class=\"result\" title=\"" + v.aliasName + "\" onclick=\"gotoPosition('" + v.longitude + "','" + v.latitude + "')\">" + v.aliasName.substring(0, 9) + 
				"<img class=\"head_img\" src=\""+ defaultImg +"\">";
	        if (v.deviceId[0] != '0')//不是子女用户
	            dom += "<div class='icon-set-security-zone' title=\"设置安全区域\" onclick=\"showSetSecurityZone('" + v.deviceId + "')\" style='float:right;width:20px;cursor: pointer;'>&nbsp;</div>";
		    dom += "<div class='icon-view-trace-information' title=\"查看轨迹\" onclick=\"showTrace('{0}','{1}')\" style='float:right;width:20px;cursor: pointer;'>&nbsp;</div></div>".format(v.deviceCode, v.deviceId)
			$("#results").append(dom);
		});
	}
	
	function gotoPosition(longitude, latitude) {
		if (longitude && latitude && longitude != 0 && latitude != 0) {
			map.panTo(new BMap.Point(longitude,latitude));
		}
	}
	
	function showTrace(deviceCode, deviceId) {
		openTab("mainTab", "${urlPath}group/showTraceGrid.do?deviceCode=" + deviceCode + "&deviceId=" + deviceId, "设备轨迹");
	}
	
	function showSetSecurityZone(deviceId) {
		openTab("mainTab", "${urlPath}group/showSetSecurityZoneGrid.do?deviceId=" + deviceId, "设置安全区域");
	}
	
	function search(aliasName) {
		$.get("${urlPath}group/listDevicePositionByGroup.do", {groupCreator:"${groupCreator}", groupId:"${groupId}", aliasName:aliasName}, function(data) {
			updateMap(data);
		});
	}
	
</script>
</body>
</html>