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
   <form id="frmProduct" method="post"  enctype="multipart/form-data">
	<input type="hidden" name="productId" value="${product.productId}">
   	<input type="hidden" name="providerId" value="${product.providerId}">
   	<input type="hidden" name="categoryId" value="${product.categoryId}">
   	<input type="hidden" name="imageFile" value="${product.imageFile}">
	<input type="hidden" name="isvalid" value='1'>
	<input type="hidden" name="productStatus" value='${product.productStatus}'>
	<input type="hidden" name="productQuantity" value="${product.productQuantity}">
	   <input type="hidden" name="discountedPrice" value="${product.discountedPrice}"/>
    <table class="form">
    	<tr>
    		<td>名称</td>
    		<td><input class="easyui-textbox" name="name" data-options="value:'${product.name}',required:true,validType:'length[1,100]'"  style="width: 250px;"></td>
    	</tr>
		<tr>
			<td>价格</td>
			<td><input class="easyui-numberbox" name="price" value="${product.price == null ? 0 : product.price}" data-options="precision:2,required:true"  style="width: 80px;"><span class="tip-info">0表示无价格</span></td>
		</tr>
    	<tr>
    		<td>图片</td>
    		<td colspan="3">
    			<input class="easyui-filebox" name="file" style="width: 200px;" data-options="buttonText:'选择文件',accept:'image/gif, image/jpeg, image/png'">
    		    <span class="tip-info">提示：为了APP端美观显示，图片尺寸最好为正方形，建议尺寸：300x300、400x400</span>
    		</td>
    	</tr>
    	<tr>
    		<td>简要描述</td>
    		<td>
    			<textarea style="width: 600px;" rows="4" class="easyui-validatebox" name="simpleDescription" data-options="validType:'length[0,500]'">${product.simpleDescription}</textarea>
    		</td>
    	</tr>
        <tr>
            <td>主要描述</td>
            <td>
                <textarea style="width: 600px;" rows="12" class="easyui-validatebox" name="description" data-options="validType:'length[0,500]'">${product.description}</textarea>
            </td>
        </tr>
    </table>
</form>
<div id="dlgUploadImg"></div>


</body>
</html>