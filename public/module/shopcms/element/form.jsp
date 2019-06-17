<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/module/common.jsp" %>
</head>
<body>
   <form id="form" method="post"  enctype="multipart/form-data">
   	<input type="hidden" name="elementId" value="${element.elementId}">
    <input type="hidden" name="blockType" value="${element.blockType}">
    <input type="hidden" name="pageLevel" value="${element.pageLevel}">
   	<input type="hidden" name="elementUrl" value="${element.elementUrl}">
   	<input type="hidden" name="sourceResource" value="${element.sourceResource}">
   	<input type="hidden" name="categoryId" value="${element.categoryId}" />
    <table class="form">
    	<tr>
    		<td>名称</td>
    		<td colspan="3" class="form"><input class="easyui-textbox" name="elementName" data-options="value:'${element.elementName}',required:true,validType:'length[1,50]'"  style="width: 250px;"></td>
    	</tr>
        <tr>
            <td><label for="sex">类型</label></td>
            <td><input id="elementType" class="easyui-combobox" name="elementType" value='${element.elementType == null ? "8" : element.elementType}' style="width:250px;">
            </td>
        </tr>
        <tr id="productSelectTr" style="display:none">
            <td>选择商品</td>
            <td>
                <span id="productName" style="display:inline"></span>
                <a id="selectProduct" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'"></a>
            </td>
        </tr>
        <tr id="categorySelectTr" style="display:none">
            <td>选择分类</td>
            <td>
	            <span id="categoryName" style="display:inline"></span>
                <a id="selectCategory" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'"></a>
            </td>
        </tr>
        <tr id="urlTr" style="display:none">
            <td>网址</td>
            <td colspan="3" class="form"><input class="easyui-textbox" id="url" data-options="value:'${element.sourceResource}',required:true,validType:'length[1,500]'"  style="width: 250px;"></td>
        </tr>
        <tr style="height: 140px">
            <td>图片</td>
            <td>
                <img id="image" src="${element.elementUrl}" style="max-width:180px;max-height:140px">
                <a id="uploadButton" class="easyui-linkbutton" data-options="iconCls:'icon-edit'" href="#">${element.elementId == null ? "上传" : "修改"}</a>
            </td>
        </tr>
        <tr>
            <td><label for="isvalid">是否显示</label></td>
            <td><input id="isvalid" type="checkbox" name="isvalid" <c:if test="${element.isvalid}">checked="checked"</c:if>></td>
        </tr>
    </table>
</form>

</body>
</html>