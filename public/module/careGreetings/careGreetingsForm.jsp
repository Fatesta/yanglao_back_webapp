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
    <form id="careGreetingsForm" method="post">
	    <table class="form">
	    	<tr>
	    		<td><label for="content">问候语</label></td>
	    		<td><input class="easyui-textbox" name="content" value="${careGreetings.content}" data-options="required:true,validType:'length[1,200]'" style="width: 365px;"></td>
	    	</tr>
	    	<tr>
	    		<td><label for="logDate">问候日期</label></td>
	    		<td><input class="easyui-datebox" name="logDate" value="${careGreetings.logDate}" data-options="required:true<c:if test="${careGreetings.logDate != null}">,readonly:true</c:if>" style="width: 365px;"></td>
	    	</tr>
	    	<tr>
	    		<td><label for="remark">备注</label></td>
	    		<td><textarea rows="5" class="easyui-validatebox" name="remark" data-options="validType:'length[0,1024]'" style="width: 365px;">${careGreetings.remark}</textarea></td>
	    	</tr>
	    </table>
	</form>
</body>
</html>