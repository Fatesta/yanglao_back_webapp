<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
	<div class="videoPlugin">
	   <object id="mainVideoObject" classid="clsid:54FC7795-1014-4BF6-8BA3-500C61EC1A05" width="100%" height="100%"></object>
	</div>
	<div class="videoPluginButtons">
		<div>
			<div id="btn-up" class="btn-up" title="上"></div>
			<div id="btn-down" class="btn-down" title="下"></div>
			<div id="btn-left" class="btn-left" title="左"></div>
			<div id="btn-right" class="btn-right" title="右"></div>
			<div id="talkBtn" class="btn-off" style="display:none" title="关闭对讲"></div>
            <div id="btnStop" class="icon-on-off" title="停止/开始预览"></div>

            <!--    <div class="btn-video" style="width: 30px;height: 30px;"></div> -->
		</div>
		<!--      
		<div style="float: left; margin-top: 15px;margin-left: 5px;position: relative;top: 8px;">
			<div class="slider">
				<div class="slider-done"></div>
				<div class="slider-bar"></div>
			</div>
		</div>
        <div id="volume" style="float: left;position: relative;top: 18px;left: 5px;width: 20px;">50%</div> -->
		<div style="float: left;height: 30px;position:relative; top: 10px;left: 20px;">
			<div class="select" data-select="selectFn" style="display:none">
				<div class="select-item-list">
					<div class="select-item select-active" data-value=1>清晰</div>
					<div class="select-item" data-value=2>流畅</div>
				</div>
				<!-- <div class="select-selected">高清</div> -->
			</div> 
		</div>
		<div id="btnFullScreen" title="全屏" class="btn-full-screen" style="float: right;width: 30px;height: 30px;margin-right:1px"></div>
		<div id="btnVideoChange" class="video_change" style="float: right;width: 30px;height: 30px;" title="切换视角"></div>
	</div>