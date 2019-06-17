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
	<form id="orgForm" method="post">
    	<input type="hidden" name="id" value="${org.id }">
		<input type="hidden" name="parentId" value="${org.parentId}">
		<input type="hidden" name="level" value="${org.level }">
		<input type="hidden" name="isCommunity" value="${org.isCommunity}">
	    <table class="form">
	    	<tr>
	    		<td>名称</td>
	    		<td>
	    			<input class="easyui-textbox" name="name" value="${org.name}" style="width: 250px;"
	    				data-options="required:true,validType:'length[1,50]'">
	    		</td>
	    	</tr>
	    	<c:if test="${org.isCommunity}">
				<tr>
					<td><label for="isOpenCommunity">是否开放性社区</label></td>
					<td>
						<input id="isOpenCommunity" name="openState" ${org.openState ? "checked" : ""} type="checkbox"
							   data-options="required:true">
					</td>
				</tr>
	            <tr>
	                <td>电话</td>
	                <td>
	                    <input name="telephone" class="easyui-textbox" value="${orgPhone.telephone}" data-options="validType:{length:[5,20]},precision:0">
	                </td>
	            </tr>
	    	</c:if>
	    </table>
	</form>
</body>
</html>