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
<form id="uploadHeadForm" enctype="multipart/form-data" method="post">
	<table>
		<tr>
			<td>请选择文件</td>
			<td>
				<input class="easyui-filebox" name="file" style="width:200px;" required="required" data-options="buttonText:'浏览',accept:'image/gif, image/jpeg, image/png'">
			</td>
		</tr>
	</table>
</form>
</body>
</html>