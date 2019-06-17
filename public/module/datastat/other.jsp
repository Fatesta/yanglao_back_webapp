<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<%@ include file="/module/common.jsp" %>
<script src="${libPath}utils/require.js"></script>
    <script><jsp:include page="/lib/utils/require-config.js" /></script>
<link rel="stylesheet" type="text/css" href="${modulePath}datastat/css/index.css">
</head>
<body>
	
	<div id="charts-layout" class="easyui-layout charts-bg" style="overflow: scroll;">
		<div id="charts">
		    <div class="title">
		        <div class="main-title">智慧养老大数据数据统计</div>
		    </div>
			<div class="grid">
                <div class="row" style="height: 50%;">
                    <div class="col-6">
                        <div class="chart total">
                            <p>订单交易总数</p>
                            <p id="orderTotal"></p>
                        </div>
                    </div>
                    <div class="col-6">
                        <div class="chart total">
                            <p>活动参与人数</p>
                            <p id="activityParticipantTotal"></p>
                        </div>
                    </div>
                </div>
			</div>
		</div>
	</div>
    <script src="${modulePath}datastat/js/other.js?v=1"></script>
</body>
</html>
