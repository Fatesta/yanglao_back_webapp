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
	<div data-options="region:'north',collapsible:true" style="height:60%;">
	   <div class="easyui-layout" data-options="fit:true">
			<div data-options="region:'west',split:true,collapsible:true" title="分类" style="width:200px">
				<ul id="treeCategory"></ul>
			</div>
			<div data-options="region:'center'" title="本店商品">
			<div id="tbrDgProduct">
				<form id="frmQueryProduct">
					<input type="hidden" name="categoryId" />
					<input type="hidden" name="providerId" value="${provider.providerId}" />
					<table class="form">
						<tr>
							<td>
								名称
							</td>
							<td>
								<input class="easyui-textbox" name="name" type="text" />
							</td>
							<td colspan="6">
								<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'"
							            onclick="productManager.query()">查询</a>
							</td>
							<c:forEach var="fn" items="${session_role_leaf_fn_list}">
								<c:if test="${fn.parentId == 152 && fn.id != 156}">
									<td>
										<a href="#" class="easyui-linkbutton" data-options="iconCls:'${fn.icon}'" name="${fn.code}">${fn.funcName}</a>
									</td>
								</c:if>
							</c:forEach>
						</tr>
					</table>
				</form>
			</div>
			<table id="dgProduct" class="easyui-datagrid" toolbar="#tbrDgProduct">
			    <thead>
			        <tr>
			            <th data-options="field:'imageFile',width:'80px',halign:'center', formatter:productManager.formatters.imageFile">图片</th>
			            <th data-options="field:'name',width:'15%',halign:'center'">名称</th>
						<th data-options="field:'price',width:'6%',halign:'center', formatter:productManager.formatters.price">单价(¥)</th>
				        <th data-options="field:'simpleDescription',width:'15%',halign:'center', formatter:productManager.formatters.simpleDescription">简要描述</th>
                        <th data-options="field:'description',width:'35%',align:'center', formatter:productManager.formatters.description">主要描述</th>
			        </tr>
			    </thead>
			</table>
		</div>
	   </div>
	</div>
    <jsp:include page="../dgImage.jsp" />
    
	<!-- 分类管理菜单 -->
	<div id="menuCategory" class="easyui-menu" style="width:120px;">
	</div>

<script>
var PAGE_CONFIG = {};
PAGE_CONFIG["provider"] = {
	providerId: "${provider.providerId}",
};
</script>
<script src="${modulePath}shop/product/category.manager.js?v=1.2"></script>
<script src="${modulePath}shop/product/image.manager.js"></script>
<script src="${modulePath}shop/product/housekeeping/product.manager.js?v=1.2"></script>
</body>
</html>