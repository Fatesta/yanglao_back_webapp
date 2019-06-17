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
    <form id="frmActivity" method="post" enctype="multipart/form-data">
    	<input type="hidden" name="id" value="${activity.id }" />
    	<input type="hidden" name="providerId" value="${activity.providerId}" />
    	<input type="hidden" name="status" value="${activity.status == null ? 1 : activity.status}" />
	    <table class="form">
	        <c:if test="${activity.id == null and activity.providerId == null}">
	        <tr>
	            <td>所属店铺</td>
	            <td id="selectProvider" colspan="3">
	                <input class="easyui-textbox" id="providerName" data-options="required:true,readonly:true" style="width:365px;">
	            </td>
	        </tr>
	        </c:if>
	    	<tr>
	    		<td>标题</td>
	    		<td colspan="3"><input class="easyui-textbox" name="title" value="${activity.title}" data-options="required:true,validType:'length[1,50]'" style="width: 365px;"></td>
	    	</tr>
	    	<tr>
	    		<td>活动地址</td>
	    		<td colspan="3"><input class="easyui-textbox" name="address" value="${activity.address}" data-options="required:true,validType:['length[1,200]']" style="width: 365px;"></td>
	    	</tr>
	    	<tr>
	    		<td>联系电话</td>
	    		<td><input class="easyui-textbox" name="telephone" value="${activity.telephone}" data-options="required:true,validType:'length[1,50]'"></td>
	    	</tr>
	    	<tr>
	    		<td>活动价格</td>
		 		<td><input class="easyui-numberbox" name="price" data-options="precision:2,required:true"  style="width: 50px;"></td>
	    	</tr>
            <tr>
                <td>分类</td>
                <td>
                    <input class="easyui-combobox" name="category"
                        data-options="
                            required: true,
                            data: DictMan.items('activity.category'),
                            value: '${activity.category}'"
                        style="width:100px;"/>
                </td>
            </tr>
	    	<tr>
	    		<td>开始时间</td>
	    		<td><input class="easyui-datetimebox" name="startTime" value="${activity.startTime}" data-options="required:true,showSeconds:false,editable:false" ></td>
	    	</tr>
            <tr>
                <td>结束时间</td>
                <td><input class="easyui-datetimebox" name="endTime" value="${activity.endTime}" data-options="required:true,showSeconds:false,editable:false" ></td>
            </tr>
	    	<!--
	    	<tr>
	    		<td>链接地址</td>
	    		<td colspan="3"><input class="easyui-textbox" name="linkUrl" value="${activity.linkUrl}" data-options="validType:['length[1,255]']" style="width: 365px;"></td>
	    	</tr>
	    	-->
	    	<tr>
	    		<td>活动图片</td>
	    		<td><a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-add'" onclick="addFileItem()">增加文件</a></td>
	    	</tr>
	    	<tr id="fileItems">
	    	</tr>
	    	<tr>
	    		<td>活动简介</td>
	    		<td colspan="3" class="form"><textarea rows="5" class="easyui-validatebox" name="description" data-options="required:true,validType:'length[1,1000]'" style="width: 365px;">${activity.description}</textarea></td>
	    	</tr>
            <tr>
                <td><label for="isLive">是否直播活动</label></td>
                <td><input id="isLive" type="checkbox" name="isLive" <c:if test="${activity.isLive}">checked="checked"</c:if>></td>
            </tr>
	        <tr>
	           <td><label for="communityLimit">限制社区</label></td>
	           <td>
	               <input id="communityLimit" type="checkbox" />
	               <input class="easyui-combobox" name="orgId" data-value="${activity.orgId}" style="width:250px;"/>
	           </td>
	        </tr>
	    </table>
	</form>
	
<script src="${libPath}template.js"></script>
<script id="fileFileInputTpl" type="text/html">
    <input type="file" name="mfile" style="width:200px" data-options="buttonText:'选择文件'" />
</script>
<script id="fileTextInputTpl" type="text/html">
    <span style="width:200px; display: inline;">{{fileName}}</span>
	<input type="hidden" name="fileId" value="{{fileId}}" />
</script>
<script id="fileItemTpl" type="text/html">
	<tr>
		<td></td>
		<td>
			{{inputType}}
			<a href="#" class="easyui-linkbutton" name="delFile" data-options="iconCls:'icon-delete'">删除</a>
		</td>
	</tr>
</script>
<script id="fileListTpl" type="text/json">
[
<c:forEach var="f" items="${files}" varStatus="st">
  {"fileName": "${f.fileName}", "imgPath": "${f.imgPath}", "fileId": "${f.fileId}"}
  <c:if test="${not st.last}">,</c:if>
</c:forEach>
]
</script>
<script>
function addFileItem() {
	var fileTypeHtml = $("#fileFileInputTpl").text();
	var newFileItem = $($("#fileItemTpl").text().replace(/{{inputType}}/g, fileTypeHtml));
	var btnDel = newFileItem.find("[name=delFile]");
	btnDel.click(function(){
		$(this).parent().parent().remove();
	});
	newFileItem.insertAfter("#fileItems");
}

$(function(){
	var files = JSON.parse($("#fileListTpl").text());
	for(var i = 0; i < files.length; i++) {
		(function(fileData) {
			var fileboxList = $("#fileItems");
			var fileTypeHtml = template('fileTextInputTpl', fileData);
			var newFilebox = $($("#fileboxTpl").text().replace(/{{inputType}}/g, fileTypeHtml));
			var btnDel = newFilebox.find("[name=delFile]");
			btnDel.click(function(){
				var fileId = $(this).prev("input[name=fileId]").val();
				$("#activityForm").append("<input type=hidden name=delFileId value=" + fileId + ">")
				$(this).parent().parent().remove();
			});
			fileboxList.append(newFilebox);
		})(files[i]);
	}
})
</script>
</body>
</html>