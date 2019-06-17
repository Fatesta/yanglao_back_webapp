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
    <form id="changePwdForm" method="post">
    	<table class="form">
	    	<tr>
	    		<td><label for="passwd">输入新密码</label></td>
	    		<td><input id="changePwdForm_passwd" class="easyui-textbox" name="passwd" style="width:150px;" 
	    			data-options="required:true,validType:'length[6,36]'" >
	    		</td>
	    	</tr>
	    	<tr>
	    		<td><label for="repasswd">确认新密码</label></td>
	    		<td><input class="easyui-textbox" name="repasswd" style="width:150px;" 
	    			data-options="required:true,validType:{length:[6,36],equals:['#changePwdForm_passwd']}" >
	    		</td>
	    	</tr>
	    </table>
	</form>
</body>
</html>