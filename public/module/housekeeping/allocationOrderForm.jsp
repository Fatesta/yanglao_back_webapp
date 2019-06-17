<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/module/common.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<body>
    <form id="allocationOrderForm" method="post">
    	<input type="hidden" name="orderId" value="${orderId }">
	    <table class="form">
	    	<tr>
	    		<td><label for="type">选择设备</label></td>
	    		<td>
					<select class="easyui-combogrid" name="worker" style="width:150px;"
        				data-options="panelWidth:200,mode: 'remote',idField:'deviceCode',textField:'deviceCode',url:'${urlPath }housekeeping/order/listDevice.do',
				            columns:[[
				                {field:'deviceCode',title:'Code',width:120},
				            ]]
				        "></select>
	    		</td>
	    	</tr>
	    </table>
	</form>
</body>
</html>