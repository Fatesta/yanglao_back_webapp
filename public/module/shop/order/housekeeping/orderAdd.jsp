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
<div id="step1" data-options="region:'center', collapsible:false, fit:true" style="height:100%;">
    <div class="easyui-layout" data-options="fit:true">
        <div data-options="region:'west',collapsible:true" title="分类" style="width:180px">
        	<ul id="treeCategory"></ul>
        </div>
        <div data-options="region:'center'">
			<div id="tbrDgProduct">
				<table class="form">
					<tr>
						<td colspan="6">
							<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-add'"
						            onclick="orderAdd.nextStep()">下一步</a>
						</td>
					</tr>
				</table>
			</div>
			<table id="dgProduct" class="easyui-datagrid" toolbar="#tbrDgProduct">
			    <thead>
			        <tr>
			            <th data-options="field:'imageFile',width:'100px',align:'center', formatter:orderAdd.formatters.imageFile">图片</th>
			            <th data-options="field:'name',width:'15%',halign:'center'">名称</th>
			            <th data-options="field:'description',width:'50%',halign:'center', formatter:orderAdd.formatters.description">描述</th>
			            <th data-options="field:'-',align:'center', formatter:orderAdd.formatters.check">选择</th>
			        </tr>
			    </thead>
			</table>
        </div>
    </div>
</div>

<script>
var PAGE_CONFIG = {
    providerId: "${provider.providerId}",
    fastOrderMode: '${fastOrderMode}',
    userId: '${userId}'
};
</script>
<script src="${modulePath}shop/order/order.add.common.js?v=1.1"></script>
<script src="${modulePath}shop/product/category.manager.js?v=1"></script>
<script src="${modulePath}shop/order/housekeeping/order.add.js?v=1.4"></script>
<script src="${modulePath}user/select.js"></script>
<script src="${libPath}jquery.base64.js"></script>
</body>
</html>