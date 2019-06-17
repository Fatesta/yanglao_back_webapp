<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<form id="form" method="post"  enctype="multipart/form-data">
   	<input type="hidden" name="categoryId" value="${category.categoryId}">
    <input type="hidden" name="parentId" value="${empty category.parentId ? -1 : category.parentId}">
    <input type="hidden" name="industryId" value="${category.industryId}">
   	<input type="hidden" name="pictureUrl" value="${category.pictureUrl}">
   	<input type="hidden" name="level" value="${category.level}">
    <input type="hidden" name="providerId" value="${category.providerId}">
    <table class="form">
    	<tr>
    		<td>名称</td>
    		<td colspan="3" class="form"><input class="easyui-textbox" name="name" data-options="value:'${category.name}',required:true,validType:'length[1,100]'"  style="width: 250px;"></td>
    	</tr>
    	<tr style="height: 140px">
    		<td>图片</td>
    		<td>
	    		<img id="image" src="${category.pictureUrl}" style="max-width:180px;max-height:140px">
    			<a id="uploadButton" class="easyui-linkbutton" data-options="iconCls:'icon-edit'" href="#">${category.categoryId == null ? "上传" : "修改"}</a>
    		</td>
    	</tr>
        <tr>
            <td><label for="isbottom">是否底层分类</label></td>
            <td><input id="isbottom" type="checkbox" name="isbottom" <c:if test="${category.isbottom == 1}">checked="checked"</c:if>></td>
        </tr>
        <tr>
            <td><label for="isvalid">是否显示</label></td>
            <td><input id="isvalid" type="checkbox" name="isvalid" <c:if test="${category.isvalid == 1}">checked="checked"</c:if>></td>
        </tr>
    </table>
</form>
