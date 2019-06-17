<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ include file="/module/common.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<body id="layout" class="easyui-layout">
<div id="step1" data-options="region:'north', collapsible:false,fit:true" style="height:100%;">
    <div class="easyui-layout" data-options="fit:true">
        <div data-options="region:'west',collapsible:true" title="分类" style="width:180px">
        	<ul id="treeCategory"></ul>
        </div>
        <div data-options="region:'center'">
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
								<input class="easyui-textbox" name="productName" type="text" />
							</td>
							<td colspan="6">
								<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'"
							            onclick="orderAdd.query()">查询</a>
							</td>
							<td colspan="6">
								<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-add'"
							            onclick="orderAdd.nextStep()">下一步</a>
							</td>
						</tr>
					</table>
				</form>
			</div>
			<table id="dgProduct" class="easyui-datagrid" toolbar="#tbrDgProduct">
			    <thead>
			        <tr>
			            <th data-options="field:'imageFile',width:'80px',align:'center', formatter:orderAdd.formatters.imageFile">商品图片</th>
			            <th data-options="field:'name',width:'20%',halign:'center'">名称</th>
			            <th data-options="field:'price',width:'6%',halign:'center', formatter: UICommon.datagrid.formatter.integer">积分</th>
			            <th data-options="field:'productQuantity',width:'6%',halign:'center'">库存</th>
			            <th data-options="field:'-',width:'6%',halign:'center', formatter:orderAdd.formatters.op">操作</th>
			        </tr>
			    </thead>
			</table>
        </div>
    </div>
</div>


<script id="productDetailTpl" type="text/html">
	<form id="frmProductDetail" method="post">
		<table class="form">
			{{each productAttrs as attr attrIndex}}
				<tr>
					<td name="attrName" data-type="{{attr.name}}" class="form" style="font-weight:bold">{{attr.name}}</td>
				</tr>
				<tr>
					<td></td>
					<td>
					{{each attr.values as value index}}
						<a name="attrValue" data-value="{{value}}" href="#" data-options="">{{value}}</a>
					{{/each}}
					</td>
				</tr>
			{{/each}}
			<tr><td><br></td></tr>
			<tr>
				<td>购买数量</td>
				<td>
					<input id="quantity" class="easyui-numberspinner" style="width:50px;" required="required" value=1
						data-options="editable: false, min:0" />
				</td>
			</tr>
		</table>
	</form>
</script>
<script>
var PAGE_CONFIG = {};
PAGE_CONFIG["provider"] = {
	providerId: "${provider.providerId}",
	industryId: "${provider.industryId}"
};
PAGE_CONFIG['fastOrderMode'] = '${fastOrderMode}';
PAGE_CONFIG['userId'] = '${userId}';
</script>
<script src="${modulePath}shop/product/category.manager.js?v=1.1"></script>
<script src="${modulePath}shop/order/order.add.common.js?v=1"></script>
<script src="${modulePath}shop/order/integral_mall/order.add.js?v=1.1"></script>
<script src="${modulePath}shop/product/integral_mall/product.manager.js?v=1"></script>
<script src="${libPath}template.js"></script>
<script src="${libPath}jquery.base64.js"></script>
</body>
</html>