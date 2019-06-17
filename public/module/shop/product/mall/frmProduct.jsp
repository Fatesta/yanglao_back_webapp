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
   	<input type="hidden" name="productStatus" value='${product.productStatus}'>
    <table class="form">
    	<tr>
    		<td>名称</td>
    		<td><input class="easyui-textbox" name="name" data-options="value:'${product.name}',required:true,validType:'length[1,100]'"  style="width: 250px;"></td>
    	</tr>
	 	<tr>
	 		<td>价格</td>
	 		<td><input class="easyui-numberbox" name="price" value="${product.price}" data-options="precision:2,required:true"  style="width: 80px;"></td>
	 	</tr>
        <tr>
            <td>折后价</td>
            <td><input class="easyui-numberbox" name="discountedPrice" value="${product.discountedPrice}" data-options="precision:2"  style="width: 80px;"></td>
        </tr>
	 	<tr>
	 		<td>库存</td>
	 		<td><input class="easyui-numberbox" name="productQuantity" value="${product.productQuantity}" data-options="precision:0,required:true"  style="width: 50px;"></td>
	 	</tr>
    	<tr>
    		<td>是否上架</td>
    		<td><input class="easyui-combobox" name="isvalid" value='${product.isvalid}' 
    			data-options="required:true,editable:false,valueField:'value',textField:'text',
							data:[{text:'是',value:'1'},{text:'否',value:'0'}]" style="width:50px;">
			</td>
    	</tr>
    	<tr>
    		<td>商品封面图</td>
    		<td colspan="3">
    			<input class="easyui-filebox" name="file" style="width: 200px;" data-options="<c:if test="${product.productId == null}">required:true,</c:if>buttonText:'选择文件',accept:'image/gif, image/jpeg, image/png'">
    		</td>
    	</tr>
    	<tr>
    		<td>描述</td>
    		<td>
    			<textarea style="width: 400px;" rows="4" class="easyui-validatebox" name="description" data-options="validType:'length[0,500]'">${product.description}</textarea>
    		</td>
    	</tr>
    </table>
</form>
<div id="dlgUploadImg"></div>


</body>
</html>