<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/module/common.jsp" %>
</head>
<body class="easyui-layout">
<div data-options="title: '服务计划用户',region: 'west', split: true, collapsible: true" style="width: 36%;">
	<div id="tbr">
	    <form id="frmQuery">
			<input name="userId" type="hidden" />
	        <table class="form">
	           <tr>
	               <td>用户</td>
	               <td id="selectUser">
	                   <input id="userAliasName" class="easyui-textbox" data-options="readonly:true" style="width:100px"/>
	               </td>
	              <td>
	                   <a id="query" class="easyui-linkbutton" data-options="iconCls:'icon-search'">查询</a>
	               </td>
	            </tr>
	        </table>
	    </form>
	</div>
	<table id="dg" class="easyui-datagrid" toolbar="#tbr"
	    data-options="url:'${urlPath}servicePlan/page.do',
	                  idField: 'userId',
	                  fit:true,
	                  pageSize: 30,
                      onSelect: onSelect,
                      onLoadSuccess: onLoadSuccess">
	    <thead>
	        <tr>
				<th data-options="field:'aliasName',width:100,halign:'center'">昵称</th>
				<th data-options="field:'realName',width:60,halign:'center'">姓名</th>
                <th data-options="field:'idcard',width:150,align:'center',halign:'center'">身份证号码</th>
                <th data-options="field:'telphone',width:100,halign:'center'">手机号码</th>
	            </tr>
	    </thead>
	</table>
</div>
<div data-options="title: '服务计划', region: 'center', split: true" style="width: 64%;">
	<%@ include file="servicePlanTable.jsp" %>
</div>

<script src="${modulePath}user/select.js"></script>
<script src="${modulePath}shop/pro/providerToProductSelect.js"></script>
<script src="${modulePath}servicePlan/servicePlanTable.js"></script>
<script src="${modulePath}servicePlan/index.js"></script>
</body>
</html>