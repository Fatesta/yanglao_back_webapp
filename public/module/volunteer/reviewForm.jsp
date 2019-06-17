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
    <form id="form" method="post">
    	<input type="hidden" name="orderno" value="${orderno}">
    	<input type="hidden" name="serviceId" value="${serviceId}">
	    <table class="form">
            <tr>
                <td>审核</td>
                <td>
                    <input id="status4" name="status" value="4" type="radio"><label for="status4" style="color:green">结束</label>
                    &nbsp;
                    <input id="status5" name="status" value="5" type="radio"><label for="status5" style="color:red">审核未通过</label>
                </td>
            </tr>
	    	<tr>
	    		<td>备注</td>
	    		<td><textarea rows="5" cols="50" class="easyui-validatebox" name="reviewNotes" data-options="validType:'length[0,500]'"></textarea></td>
	    	</tr>
	    </table>
	</form>
</body>
</html>