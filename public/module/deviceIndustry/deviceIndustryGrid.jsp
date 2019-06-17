<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/module/common.jsp" %>
</head>
<body>
<div id="industryDeviceTab" class="easyui-tabs" data-options="fit:true" style="fit:true">
	<div title="行业设备">
		<div id="industryDeviceGridToolbar">
			<form id="searchIndustryDeviceForm">
				<table class="form">
					<tr>
						<td>
							设备号
						</td>
						<td>
							<input class="easyui-textbox" name="deviceCode" type="text">
						</td>
						<td>
							行业
						</td>
						<td>
						    <select class="easyui-combobox" name="industry" style="width: 80px;">
						        <option value="" selected="selected">全部</option>
						        <option value="1">旅游版</option>
						        <option value="2">幼儿版</option>
						        <option value="3">家政版</option>
						    </select>
						</td>
						<td>
							<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'"
						            onclick="searchIndustryDevice()">查询</a>
						    <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-download'"
									onclick="downloadTemplate()">下载模板</a>
						</td>
					</tr>
				</table>
			</form>
			<form id="uploadIndustryDeviceForm" method="post" enctype="multipart/form-data">
				<input class="easyui-filebox" name="file" style="width:300px" data-options="buttonText:'选择文件'">
		 		<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-import'"
		            onclick="importDevice()">导入</a>
			</form>
		</div>
		<table id="industryDeviceGrid" class="easyui-datagrid"
			data-options="url:'${urlPath }deviceIndustry/listIndustryDevice.do',
						  multiSort:true,
						  sortName:'create_time',
						  sortOrder:'desc',
						  fit:true,
						  toolbar:'#industryDeviceGridToolbar'">
		    <thead>
		        <tr>
		            <th data-options="field:'deviceCode',width:150,halign:'center'">设备号</th>
		            <th data-options="field:'industry',width:100,halign:'center',align:'center',formatter:formatIndustry">所属行业</th>
		            <th data-options="field:'-',width:100,halign:'center',formatter:formatOp">操作</th>
		        </tr>
		    </thead>
		</table>
	</div>
	
	<div title="非行业设备">
		<div id="unindustryDeviceGridToolbar">
			<form id="searchUnindustryDeviceForm">
				<table class="form">
					<tr>
						<td>
							设备号
						</td>
						<td>
							<input class="easyui-textbox" name="deviceCode" type="text">
						</td>
						<td>
							<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'"
						            onclick="searchUnindustryDevice()">查询</a>
						    <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-add'"
						            onclick="addIndustryDevice()">添加到</a>
						    <select class="easyui-combobox" id="industry" name="industry" style="width: 80px;">
						        <option value="1">旅游版</option>
						        <option value="2">幼儿版</option>
						        <option value="3">家政版</option>
						    </select>
						</td>
					</tr>
				</table>
			</form>
		</div>
		<table id="unindustryDeviceGrid" class="easyui-datagrid"
			data-options="url:'${urlPath }deviceIndustry/listUnindustryDevice.do',
						  multiSort:true,
						  fit:true,
						  toolbar:'#unindustryDeviceGridToolbar'">
		    <thead>
		        <tr>
		        	<th data-options="field:'-',width:150,halign:'center',checkbox:true"></th>
		            <th data-options="field:'deviceCode',width:150,halign:'center'">设备号</th>
		        </tr>
		    </thead>
		</table>
	</div>
</div>

<script>

	function formatIndustry(value,rowData,rowIndex) {
		if (value == 1) {
			return "旅游版";
		} else if (value == 2) {
			return "幼儿版";
		} else if (value == 3) {
			return "家政版";
		}
	}

	function formatOp(value,rowData,rowIndex) {
		return '<a href="#" title="删除"  class="easyui-linkbutton" data-options="iconCls:\'color:fff\'" onclick="deleteIndustryDevice(' + rowData.deviceCode + ')"><div class=\'icon-delete\'>&nbsp;</div></a>';
	}

	function searchIndustryDevice() {
		$("#industryDeviceGrid").datagrid("load", url2Json($("#searchIndustryDeviceForm").serialize()));
	}
	
	function searchUnindustryDevice() {
		$("#unindustryDeviceGrid").datagrid("load", url2Json($("#searchUnindustryDeviceForm").serialize()));
	}
	
	function addIndustryDevice() {
		var unindustryDeviceGrid = $("#unindustryDeviceGrid");
		var rows = unindustryDeviceGrid.datagrid("getSelections");
		if (rows.length == 0) {
			showAlert('错误提示','至少选中一行才能进行编辑！','warning');
			return false;
		}
		
		showConfirm("确认操作", "确认添加行业设备！", function(){
			post("${urlPath }deviceIndustry/addIndustryDevice.do", {deviceCodes:getObjectsPropertyArray(rows, "deviceCode"),industry:$("#industry").combobox("getValue")}, function(data){
				if (data.success) {
					unindustryDeviceGrid.datagrid("load");
					$("#industryDeviceGrid").datagrid("load");
					$("#industryDeviceTab").tabs("select", 0);
				   	showMessage('系统提示', data.message);
				} else {
					showAlert("错误提示", data.message);
				}
			});
		});
	}
	
	function deleteIndustryDevice(deviceCode) {
		showConfirm("确认操作", "确认删除行业设备！", function(){
			post("${urlPath }deviceIndustry/deleteIndustryDevice.do", {deviceCode:deviceCode}, function(data){
				if (data.success) {
					$("#unindustryDeviceGrid").datagrid("load");
					$("#industryDeviceGrid").datagrid("load");
					$("#industryDeviceTab").tabs("select", 0);
				   	showMessage('系统提示', data.message);
				} else {
					showAlert("错误提示", data.message);
				}
			});
		});
	}
	
	function downloadTemplate() {
		location.href = CONFIG.modulePath + "deviceIndustry/industry_device_template.xls";
	}
	
	function importDevice() {
		$.messager.progress();
		submitForm("uploadIndustryDeviceForm", "${urlPath}deviceIndustry/importIndustryDevice.do", function(data){
			data = str2Json(data);
			if (data.success) {
				showMessage("操作提示", "操作成功");
			} else {
				showAlert("错误提示", data.message, "warning");
			}
			$.messager.progress('close');
			$("[name=file]").filebox("clear");
			$("#industryDeviceGrid").datagrid("load");
			$("#unindustryDeviceGrid").datagrid("load");
		});
	}
	
</script>
</body>
</html>