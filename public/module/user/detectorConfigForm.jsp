<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/module/common.jsp" %>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<body>
	<form id="frmDetectorConfig" method="post">
		<input type="hidden" name="userId" value="${userYsDetectorConfig.userId }">
		<table class="form">
	    	<tr>
	    		<td>探测器序列号</td>
	    		<td><input class="easyui-textbox" value="${userYsDetectorConfig.deviceSerial }" name="deviceSerial" data-options="validType:'length[9,9]'" ></td>
	    	</tr>
	    </table>
	</form>
</body>
</html>