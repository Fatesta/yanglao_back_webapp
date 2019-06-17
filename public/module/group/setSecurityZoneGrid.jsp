<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<style type="text/css">
	body, html {width: 100%;height: 100%;overflow: hidden;margin:0;font-family:"微软雅黑";}
	#map1_container,#map2_container {width:50%;height:100%;float:left;overflow: hidden;margin:0;}
</style>
</head>
<body>
	<iframe id="map1_container" frameborder=0 scrolling=auto height="100%" src="${urlPath }view/group/mapFrame1.do?deviceId=${deviceId}"></iframe>
	<iframe id="map2_container" frameborder=0 scrolling=auto height="100%" src="${urlPath }view/group/mapFrame2.do?deviceId=${deviceId}"></iframe>
</body>
</html>