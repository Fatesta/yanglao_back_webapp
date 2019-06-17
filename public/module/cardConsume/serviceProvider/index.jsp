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
    data-options="url:'${urlPath}cardConsume/serviceProvider/page.do?serviceCode=${serviceCode}',
                  fit:true">
    <thead>
        <tr>
             <th data-options="field:'name',width:'14%',halign:'center'">店铺名称</th>
             <th data-options="field:'industryText',width:'6%',halign:'center'">所属行业</th>
             <th data-options="field:'address',width:'10%',halign:'center'">店铺地址</th>
             <th data-options="field:'telephone',width:'7%',halign:'center'">联系电话</th>
             
        	</tr>
    </thead>
</table>
<script>
var SERVICE_PROVIDER_PPAGE_CONFIG = {serviceCode: '${serviceCode}'};
</script>
<script src="${modulePath}shop/pro/select.js?v=1.2"></script>
<script src="${modulePath}cardConsume/serviceProvider/serviceProvider.js"></script>
</body>
</html>