<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/module/common.jsp" %>
</head>
<body>
<div id="tbr">
    <form id="frmQuery">
		<table class="form">
		   <tr>
               <td><a id="add" class="easyui-linkbutton" data-options="iconCls:'icon-add'">增加</a></td>
               <td><a id="delete" class="easyui-linkbutton" data-options="iconCls:'icon-delete'">删除</a></td>
			</tr>
		</table>
    </form>
</div>
<table id="dg" class="easyui-datagrid" toolbar="#tbr"
    data-options="url:'${urlPath}cardConsume/serviceProduct/page.do?serviceCode=${serviceCode}',
                  fit:true">
    <thead>
        <tr>
             <th data-options="field:'imageFile',width:'80px',halign:'center', formatter: formatters.imageFile">商品图片</th>
             <th data-options="field:'name',width:'20%',halign:'center'">商品名称</th>
             <th data-options="field:'providerName',width:'14%',halign:'center'">店铺名称</th>
             <th data-options="field:'industryText',width:'6%',halign:'center'">所属行业</th>
             <th data-options="field:'providerAddress',width:'10%',halign:'center'">店铺地址</th>
             <th data-options="field:'providerTelephone',width:'7%',halign:'center'">联系电话</th>
             
        	</tr>
    </thead>
</table>
<script>
var SERVICE_PRODUCT_PPAGE_CONFIG = {serviceCode: '${serviceCode}'};
</script>
<script src="${modulePath}shop/product/product-formatters.js"></script>
<script src="${modulePath}shop/pro/providerToProductSelect.js?v=1"></script>
<script src="${modulePath}cardConsume/serviceProduct/serviceProduct.js"></script>

</body>
</html>