<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <%@ include file="/module/common.jsp" %>
    <link rel="stylesheet" type="text/css" href="${libPath}video_array_player/style.css?v=1">
    <style>
    .controls .window-split-type-container {
      top: 2px;
    }
    </style>
</head>

<body>
<div id="main-container" style="position: relative;width:100%;height:100%;"></div>
<script src="${libPath}EZUIKit/ezuikit.js"></script>
<script src="${libPath}EZUIKit/ez-common.js"></script>
<script src="${libPath}video_array_player/videoArrayPlayer.js?v=2.1"></script>
<script>
var loaded = true;
var signals = {
    enterFullScreened: new Signal(),
    exitFullScreened: new Signal()
};
var videoArrayPlayer = new VideoArrayPlayer({
    infoFormatter: function(data) {
        return ' ' + data.aliasName + ' 的视频';
    },
    onEnterFullScreen: function() {
        signals.enterFullScreened.dispatch();
        videoArrayPlayer.resize();
    },
    onExitFullScreen: function() {
        signals.exitFullScreened.dispatch();
        videoArrayPlayer.resize();
    }
});
$('#main-container').append(videoArrayPlayer);
videoArrayPlayer.resize();
function play(deviceCode, aliasName) {
	$.get(CONFIG.baseUrl + "video/cameraInfo.do?deviceCode=" + deviceCode, function(cameraInfo){
	    videoArrayPlayer.play(cameraInfo, {aliasName: aliasName});
	});
}
</script>
</body>
</html>