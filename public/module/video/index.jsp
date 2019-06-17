<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <%@ include file="/module/common.jsp" %>
    <link rel="stylesheet" type="text/css" href="${libPath}video_array_player/style.css?v=1">
</head>

<body id="layout" class="easyui-layout">
    <div data-options="region:'west',title:'摄像头',split:true,collapsible:true" style="width:200px">
    	<ul id="tree" class="easyui-tree"></ul>
    </div>
    <div id="panelVideo" data-options="region:'center',split:true,collapsible:true">
    </div>
        
<script src="${libPath}EZUIKit/ezuikit.js"></script>
<script src="${libPath}EZUIKit/ez-common.js"></script>
<script src="${libPath}video_array_player/videoArrayPlayer.js?v=2.1"></script>
<script src="${modulePath}video/cameratree.js?v=1"></script>
<script src="${modulePath}video/main.js?v=1"></script>
</body>
</html>