<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/module/common.jsp" %>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<body>
<table class="form">
	<tr>
		<td><img src="${urlPath }device/getCodeImg.do?deviceCode=${deviceCode}"></td>
		<td><label for="deviceCode">设备号：${deviceCode}</label></td>
	</tr>
</table>
</body>
</html>