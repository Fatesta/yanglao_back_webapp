<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/module/common.jsp" %>
</head>
<body>
<div id="tbrClientLog">
<form id="frmQuery">
	<table class="form">
		<tr>
			<td>用户昵称</td>
			<td>
				<input class="easyui-textbox" name="userName" type="text" style="width: 100px" >
			</td>
            <td>平台类型</td>
            <td>
                <input class="easyui-combobox" name="platformType" style="width: 100px" />
            </td>
            <td>角色</td>
            <td>
                <input class="easyui-combobox" name="roleName" style="width: 100px" />
            </td>
			<td>操作时间</td>
			<td>
				<input class="easyui-datetimebox" name="startOpTime" type="text" style="width: 150px" >&nbsp;至&nbsp;
			    <input class="easyui-datetimebox" name="endOpTime" type="text" style="width: 150px" >
			</td>
			<td>
				<a id="query" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'">查询</a>
			</td>
		</tr>
	</table>
</form>
</div>
<table id="dgClientLog" class="easyui-datagrid"
	data-options="url:'${urlPath}clientLog/page.do',
	              queryParams: {startOpTime: '', endOpTime: ''},
	              pageSize: 30,
				  multiSort:true,
				  fit:true,
				  toolbar:'#tbrClientLog'">
    <thead>
        <tr>
            <th data-options="field:'userName',width:120,halign:'center'">操作人昵称</th>
            <th data-options="field:'clientLogo',width:200,halign:'center'">终端型号标识</th>
            <th data-options="field:'platformType',width:80,halign:'center', formatter: clientLog.formatters.platformType">平台类型</th>
            <th data-options="field:'roleName',width:90,halign:'center'">角色名称</th>
            <th data-options="field:'functionName',width:150,halign:'center'">操作描述</th>
            <th data-options="field:'operationTime',width:130,align:'center'">操作时间</th>
        </tr>
    </thead>
</table>
<script src="${modulePath}clientLog/index.js"></script>
</body>
</html>