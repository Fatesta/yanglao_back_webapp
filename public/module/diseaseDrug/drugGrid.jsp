<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/module/common.jsp" %>
</head>
<body>
<div id="drugGridToolbar">
	<form id="uploadDiseaseDrugForm" enctype="multipart/form-data" method="post">
		<table class="form">
			<tr>
				<td>
					<input class="easyui-filebox" name="file" style="width:300px" data-options="buttonText:'选择文件'">
					<c:if test="${not empty ROLE_FUNC_MAP['diseaseDrug.import']}">
				    <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-import',accept:'application/zip'"
				            onclick="importDiseaseDrug()">导入</a>
				    </c:if>
				</td>
			</tr>
		</table>
	</form>
</div>
<table id="drugGrid" class="easyui-datagrid"
	data-options="url:'${urlPath }diseaseDrug/listDrug.do',
				  multiSort:true,
				  fit:true,
				  queryParams:{
				  	pid:'${pid }'
				  },
				  toolbar:'#drugGridToolbar'">
    <thead>
        <tr>
            <th data-options="field:'name',width:200,halign:'center'">药品名称</th>
            <th data-options="field:'url',width:110,halign:'center',formatter:formatImg">图像</th>
            <th data-options="field:'remark',width:350,halign:'center'">备注</th>
        </tr>
    </thead>
</table>
<script>

	function formatImg(value,row,index) {
		return "<img src='" + value + "' />";
	}
	
</script>
</body>
</html>