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
    <form id="frmAudit" method="post">
    	<input type="hidden" name="id" value="${id}">
    	<input type="hidden" name="status" value="${status}">
	    <table class="form">
	    	<tr>
	    		<td>${status == 2 ? '通过' : status == 3 ? '驳回' : ''}审批说明</td>
	    		<td><textarea rows="5" cols="50" class="easyui-validatebox" name="auditDesc" data-options="validType:'length[0,500]'"></textarea></td>
	    	</tr>
	    </table>
	</form>
</body>
</html>