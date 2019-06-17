<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
    <%@ include file="/module/common.jsp" %>
    <style>
        #summary {
            width: 100%;
            height: 100%;
        }
        .query-container {
            position: absolute;
            right: 70px;
            top: 4px;
            z-index: 2;
            font-size: 12px;
        }
    </style>
</head>
<body>
    <div class="query-container">
	    <span>时间：</span>
	    <select class="easyui-combobox" id="timeRange" style="width: 80px;">
	        <option value="today">当日</option>
	        <option value="this_week">本周</option>
	        <option value="this_month">本月</option>
            <option value="last_7days">最近7日</option>
	    </select>
    </div>
    <div id="summary"></div>

	<script src="${libPath}echarts/echarts.min.js"></script>
	<script src="${modulePath}callcenter/monitor/index.js?v=1"></script>
</body>
</html>