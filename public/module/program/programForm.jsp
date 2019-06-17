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
    <form id="programForm" method="post" enctype="multipart/form-data">
    	<input type="hidden" name="programId" value="${program.programId }">
	    <table class="form">
	    	<tr>
	    		<td><label for="resourceName">节目名称</label></td>
	    		<td><input class="easyui-textbox" name="resourceName" value="${program.resourceName}" data-options="required:true,validType:'length[1,20]'" style="width: 250px;"></td>
	    	</tr>
	    	<tr>
	    		<td><label for="title">节目类型</label></td>
	    		<td>
	    			<input class="easyui-combobox filter" name="programType" value="${program.programType}" style="width: 250px;"
						data-options="required:true,valueField:'did',textField:'name',url:'${urlPath }program/listProgramType.do'">
				</td>
	    	</tr>
	    	<tr>
	    		<td><label for="author">作者</label></td>
	    		<td><input class="easyui-textbox" name="author" value="${program.author}" data-options="validType:'length[0,100]'" style="width: 250px;"></td>
	    	</tr>
	    	<tr>
	    		<td><label for="file">节目文件</label></td>
	    		<td><input class="easyui-filebox" name="file" data-options="<c:if test="${program.programId == null}">required:true,</c:if>buttonText:'选择文件',accept:'audio/mpeg,audio/x-wav'" style="width: 250px;"></td>
	    	</tr>
	    </table>
	</form>
</body>
</html>