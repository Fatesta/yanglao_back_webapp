<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/module/common.jsp" %>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<body>
    <div id="deviceTabs" class="easyui-tabs" data-options="fit:true">
        <div title="已选择的设备" style="display:none;">
        	<table id="selectedDeviceGrid" class="easyui-datagrid"
				data-options="
							  fit:true,
							  fitColumns:true">
			    <thead>
			        <tr>
			            <th data-options="field:'deviceCode',width:200,halign:'center'">设备号</th>
			            <th data-options="field:'aliasName',width:150,halign:'center'">昵称</th>
			            <th data-options="field:'telphone',width:120,halign:'center'">手机号</th>
			            <th data-options="field:'-',width:100,halign:'center',formatter:formatOp">操作</th>
			        </tr>
			    </thead>
			</table>
        </div>
		<div title="选择设备" style="display:none;">
	       	<div id="deviceGridToolbar">
	        	<form id="deviceForm" method="post">
				    <table class="form">
				   		<tr>
				    		<td>设备号</td>
							<td><input class="easyui-textbox filter" name="deviceCode" type="text" style="width:100px"></td>
				    		<td>昵称</td>
							<td><input class="easyui-textbox filter" name="aliasName" type="text" style="width:100px"></td>
							<td>
								<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'"
				            		onclick="searchDevice()">查询</a>
				            	<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-add'"
				            		onclick="addSelectedDevices()">选择</a>
							</td>
						</tr>
				    </table>
				</form>
	       	</div>
	       	<table id="deviceGrid" class="easyui-datagrid"
				data-options="url:'${urlPath }broadcastMsg/listDevice.do',
							  fit:true,
							  singleSelect:false,
							  toolbar:'#deviceGridToolbar',
							  fitColumns:true">
			    <thead>
			        <tr>
			            <th data-options="field:'id',checkbox:true"></th>
			            <th data-options="field:'deviceCode',width:200,halign:'center'">设备号</th>
			            <th data-options="field:'aliasName',width:150,halign:'center'">昵称</th>
			            <th data-options="field:'telphone',width:120,halign:'center'">手机号</th>
			        </tr>
			    </thead>
			</table>
		</div>
    </div>
<script>
$(function(){
	if(selectedDeviceGridData != null) {
		$("#selectedDeviceGrid").datagrid({
			data: selectedDeviceGridData
		});
	}
})

function formatOp(value,row,index) {
	return '<a href="#" class="easyui-linkbutton" onclick="deleteSelectedDevice(' + row.deviceCode + ')"><div class=\'icon-delete\'>&nbsp;</div></a>';
}

function deleteSelectedDevice(deviceCode) {
	var delRow = $("#selectedDeviceGrid").datagrid("getRows").filter(function(row){
		return row.deviceCode == deviceCode;
	})[0];
	$("#selectedDeviceGrid").datagrid("deleteRow",
			$("#selectedDeviceGrid").datagrid("getRowIndex", delRow));
	$("#deviceGrid").datagrid("appendRow", delRow);
}

function addSelectedDevices() {
	var aRows = $("#deviceGrid").datagrid("getSelections");
	var sRows = $("#selectedDeviceGrid").datagrid("getRows");
	var hasAdd = false;
	aRows.forEach(function(aRow){
		var contains = false;
		for(var i = 0; !contains && i < sRows.length; i++)
			contains = sRows[i].deviceCode == aRow.deviceCode;
		if(!contains) {
			$("#deviceGrid").datagrid("deleteRow",
				$("#deviceGrid").datagrid("getRowIndex", aRow));
			$("#selectedDeviceGrid").datagrid("appendRow", aRow);
			hasAdd = true;
		}
	});
	if(hasAdd)
		$("#deviceTabs").tabs("select", 0);
}

function searchDevice() {
	$("#deviceGrid").datagrid("load", $("#deviceForm").serializeObject());
}
</script>
</body>
</html>