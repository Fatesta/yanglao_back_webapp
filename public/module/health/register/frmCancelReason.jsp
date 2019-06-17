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
    <form id="frm" method="post">
        <input type="hidden" name="id" value="${id}">
        <table class="form">
            <tr>
                <td>取消原因备注</td>
                <td><textarea rows="4" class="easyui-validatebox" name="remark" data-options=""  style="width:300px"></textarea></td>
            </tr>
        </table>
    </form>
</body>
</html>