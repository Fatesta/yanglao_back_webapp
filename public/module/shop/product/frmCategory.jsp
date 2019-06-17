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
	<form id="frmCategory" method="post">
	    <input type="hidden" name="industryId" value="${category.industryId }">
    	<input type="hidden" name="categoryId" value="${category.categoryId }">
    	<input type="hidden" name="parentId" value="${category.parentId }">
    	<input type="hidden" name="level" value="${category.level}">
    	<input type="hidden" name="providerId" value="${category.providerId}">
    	<input type="hidden" name="isbottom" value="${category.isbottom }">
        <input type="hidden" name="pictureUrl" value="${category.pictureUrl}">
		<c:if test="${category.industryId != 'housekeeping' && category.industryId != 'catering'}">
			<input type="hidden" name="serviceType" value="04"><!--其它-->
		</c:if>
	    <table class="form">
	    	<tr>
	    		<td>名称</td>
	    		<td>
	    			<input class="easyui-textbox" name="name" value="${category.name}" style="width: 250px;"
	    				data-options="required:true,validType:'length[1,20]'">
	    		</td>
	    	</tr>
	        <tr style="height: 140px">
	            <td>图片</td>
	            <td>
	                <img id="image" src="${category.pictureUrl}" style="max-width:180px;max-height:140px">
	                <a id="uploadButton" class="easyui-linkbutton" data-options="iconCls:'icon-edit'" href="#">${category.categoryId == null ? "上传" : "修改"}</a>
	            </td>
	        </tr>
			<c:if test="${category.industryId == 'housekeeping' || category.industryId == 'catering'}">
			<tr>
				<td>服务类别</td>
				<td>
					<input name="serviceType" class="easyui-combobox" data-options="
						required:true,
						data:[
							{text:'助餐',value:'01'},
							{text:'助洁',value:'02'},
							{text:'助医',value:'03'},
							{text:'助急',value:'04'},
							{text:'远程照护',value:'07'}],
						value: '${category.serviceType}'" />
				</td>
			</tr>
			</c:if>
		 	<tr>
		 		<td>序号</td>
		 		<td><input class="easyui-numberbox" name="sort" value="${category.sort}" data-options="precision:0,required:true"  style="width: 50px;"></td>
		 	</tr>
	        <tr>
	            <td><label for="isvalid">是否显示</label></td>
	            <td><input id="isvalid" type="checkbox" name="isvalid" <c:if test="${category.isvalid == 1}">checked="checked"</c:if>></td>
	        </tr>
	    </table>
	</form>
</body>
</html>