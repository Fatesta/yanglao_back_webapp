<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/module/common.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<body>
	<form id="frmQuery" style="margin-left: 14px;">
		<input type="hidden" name="broadcastType" value="${broadcastMsg.broadcastType}">
		<table class="form">
			<tr>
				<td>
					开始时间
				</td>
				<td>
					<input class="easyui-datebox filter" id="startCreateTime" name="startCreateTime" type="text">
				</td>
				<td>
					结束时间
				</td>
				<td>
					<input class="easyui-datebox filter" id="endCreateTime" name="endCreateTime" type="text">
				</td>
				<td>
					<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" name="query">查询</a>
				</td>
			</tr>
		</table>
	</form>

	<div id="canvasDiv"></div>
<script src="${libPath}ichart.1.2.1.min.js"></script>
<script src="${modulePath}broadcastMsg/stat.js?v=1"></script>
</body>
</html>