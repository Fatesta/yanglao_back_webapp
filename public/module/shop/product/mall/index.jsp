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
	<div data-options="region:'north',collapsible:true">
		<div class="easyui-layout" data-options="fit:true"  style="height:100%">
			<div data-options="region:'west',split:true,collapsible:true" title="分类" style="width:200px">
				<ul id="treeCategory"></ul>
			</div>
			<div data-options="region:'center'" title="本店商品">
				<div id="tbrDgProduct">
					<form id="frmQueryProduct">
						<input type="hidden" name="categoryId" />
						<input type="hidden" name="providerId" value="${provider.providerId}" />
						<input type="hidden" name="configProviderId" value="0" />
						<table class="form">
							<tr>
								<td>
									商品名称
								</td>
								<td>
									<input class="easyui-textbox" name="name" type="text" />
								</td>
								<td colspan="6">
									<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'"
								            onclick="productManager.query()">查询</a>
								</td>
								<c:forEach var="fn" items="${session_role_leaf_fn_list}">
									<c:if test="${fn.parentId == 152}">
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
				            <th data-options="field:'imageFile',width:'80px',halign:'center', formatter:productManager.formatters.imageFile">商品图片</th>
				            <th data-options="field:'name',width:'20%',halign:'center'">名称</th>
				            <th data-options="field:'price',width:'6%',halign:'center', formatter:productManager.formatters.price">单价(¥)</th>
                            <th data-options="field:'discountedPrice',width:'6%',halign:'center', formatter:productManager.formatters.discountedPrice">折后价(¥)</th>
				            <th data-options="field:'isvalid',width:'5%',align:'center', formatter:productManager.formatters.isvalid">是否上架</th>
				            <th data-options="field:'description',width:'10%',halign:'center', formatter:productManager.formatters.description">描述</th>
				            <th data-options="field:'productQuantity',width:'6%',align:'center'">库存</th>
				        </tr>
				    </thead>
				</table>
			</div>
       </div>
    </div>
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
<script src="${modulePath}shop/product/mall/product.manager.js?v=1"></script>
</body>
</html>