<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/module/common.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<body id="layout" class="easyui-layout">
	<div class="easyui-layout" data-options="fit:true">
		<div data-options="region:'west',split:true,collapsible:true" title="分类" style="width:180px">
			<ul id="treeCategory"></ul>
		</div>
		<div data-options="region:'center'">
			<div id="tbrDgProduct">
				<form id="frmQueryProduct">
					<input type="hidden" name="categoryId" />
					<input type="hidden" name="providerId" value="${providerId}" />
					<table class="form">
						<tr>
							<td>
								商品名称
							</td>
							<td>
								<input class="easyui-textbox" name="name" type="text" />
							</td>
							<td colspan="6">
								<a id="query" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'">查询</a>
							</td>
						</tr>
					</table>
				</form>
			</div>
			<table id="dgProduct" class="easyui-datagrid" toolbar="#tbrDgProduct">
			    <thead>
			        <tr>
			            <th data-options="field:'imageFile',width:'80px',halign:'center', formatter:formatters.imageFile">商品图片</th>
			            <th data-options="field:'name',width:'60%',halign:'center'">名称</th>
				        <th data-options="field:'isvalid',width:60,align:'center', formatter:formatters.isvalid">是否上架</th>
				        <th data-options="field:'description',width:'20%',halign:'center', formatter:formatters.description">描述</th>
			        </tr>
			    </thead>
			</table>
		</div>
	</div>
	
<script>
var PAGE_CONFIG = {};
PAGE_CONFIG["providerId"] = '${providerId}';
PAGE_CONFIG["industryId"] = '${industryId}'
</script>
<script src="${modulePath}shop/product/category.manager.js"></script>
<script src="${modulePath}shop/product/product-formatters.js"></script>
<script src="${modulePath}shop/product/product-select.js"></script>
</body>
</html>