<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
	<%@ include file="/module/common.jsp" %>
</head>

<body class="easyui-layout">
	<div id="userGridToolbar">
		<form id="frmQuery">
			<table class="form">
				<tr>
					<td>昵称</td>
					<td>
						<input class="easyui-textbox filter" name="aliasName" type="text"  style="width:100px;">
					</td>
					<td>手机号码</td>
					<td>
						<input class="easyui-textbox filter" name="telphone" type="text"  style="width: 100px;">
					</td>
					<td colspan="2">
						<a id="user-query" class="easyui-linkbutton" data-options="iconCls:'icon-search'">查询</a>
						<a id="userQuerier" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'">高级查询</a>
						<a id="enter" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-care'">远程看护</a>
						<a id="userConfig" class="easyui-linkbutton" data-options="iconCls:'icon-set'">远程看护配置</a>
					</td>
				</tr>
			</table>
		</form>
	</div>
	<table id="dgUser" class="easyui-datagrid" toolbar="#userGridToolbar"
		   data-options="
		   url: '${urlPath}user/listUser.do?userType=-1',
		   pageSize: 50">
		<thead>
		<tr>
			<th data-options="field:'aliasName',width:100,halign:'center'">昵称</th>
			<th data-options="field:'realName',width:60,halign:'center'">姓名</th>
			<th data-options="field:'sex',width:50,halign:'center',align:'center',formatter: userManage.formatters.sex">性别</th>
			<th data-options="field:'age',width:50,halign:'center',align:'center',formatter: userManage.formatters.age">年龄</th>
			<th data-options="field:'idcard',width:150,align:'center',halign:'center'">身份证号码</th>
			<th data-options="field:'telphone',width:100,halign:'center', formatter: userManage.formatters.telphone">手机号码</th>
			<th data-options="field:'address',width:230,halign:'center'">家庭住址</th>
			<th data-options="field:'orgName',width:140,halign:'center'">所属社区</th>
		</tr>
		</thead>
	</table>

	<script src="${modulePath}user/formatters.js?v=1"></script>
	<script src="${modulePath}user/querier.js"></script>
	<script src="${modulePath}telecare/index.js"></script>
</body>
</html>