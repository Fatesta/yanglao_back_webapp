<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/module/common.jsp" %>
</head>
<body>
<div id="deviceRegisterGridToolbar">
<form id="searchDeviceRegister">
	<table class="form">
		<tr>
			<td>
				设备号
			</td>
			<td>
				<input class="easyui-textbox filter" name="deviceCode" type="text">
			</td>
			<td>
				状态
			</td>
			<td>
				<select class="easyui-combobox" name="status" style="width: 80px;">
			        <option value="" selected="selected">全部</option>
			        <option value="1">已激活</option>
			        <option value="0">未激活</option>
			    </select>
			</td>
			<td colspan="6">
				<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'"
			            onclick="searchDeviceRegister()">查询</a>
			    <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-code'"
			            onclick="generateQRCode()">生成二维码</a>
			</td>
		</tr>
	</table>
</form>
</div>
<table id="deviceRegisterGrid" class="easyui-datagrid"
	data-options="url:'${urlPath }device/listDeviceRegister.do',
				  multiSort:true,
				  fit:true,
				  toolbar:'#deviceRegisterGridToolbar'">
    <thead>
        <tr>
            <th data-options="field:'--',width:150,halign:'center',checkbox:true">ID</th>
            <th data-options="field:'deviceCode',width:150,halign:'center'">设备号</th>
            <th data-options="field:'factoryDate',width:150,halign:'center'">出厂日期</th>
            <th data-options="field:'status',width:50,halign:'center',formatter:formatStatus">状态</th>
            <th data-options="field:'-',width:50,halign:'center',formatter:formatOp">操作</th>
        </tr>
    </thead>
</table>
<div id="deviceRegisterDlg"></div>
<script>

	function generateQRCode() {
		var deviceGrid = $("#deviceRegisterGrid");
		var rows = deviceGrid.datagrid("getSelections");
		if (rows.length == 0) {
			showAlert('错误提示','必须选中一行才能生成二维码！','warning');
			return false;
		}
		var deviceCodeStr = getObjectsPropertyArray(rows, "deviceCode");
		window.location.href = "${urlPath}device/generateQRCode.do?deviceCodeStr=" + deviceCodeStr;
	}

	function formatStatus(value,rowData,rowIndex) {
		// 0、未激活；1、已激活；2、已挂失；3、已丢失
		if (value == 0) {
			return "<div title='未激活' class='icon-disable'>&nbsp</div>";
		} else if (value == 1) {
			return "<div title='已激活' class='icon-enable'>&nbsp</div>";
		}
	}

	function formatOp(value,rowData,rowIndex) {
		return '<a href="#" class="easyui-linkbutton" title="查看二维码" data-options="iconCls:\'color:fff\'" onclick="showQRCode(\'' + rowData.deviceCode + '\')"><div class=\'icon-code\'>&nbsp;</div></a>';
	}
	
	function searchDeviceRegister() {
		var d={};
		$("#searchDeviceRegister").find('input,select')
						  .each(function(){
							  if (this.name) {
							  	d[this.name]=this.value
							  }
						  });
		$("#deviceRegisterGrid").datagrid("load", d);
	}
	
	function showQRCode(deviceCode) {
		var href = "${urlPath }device/showQRCodeForm.do?deviceCode=" + deviceCode;
		var dlg = $("#deviceRegisterDlg").dialog({
		    title: "查看设备二维码",
		    width: 500,
		    height: 380,
		    closed: false,
		    cache: false,
		    href: href,
		    buttons:[{
				text:"取消",
				iconCls:'icon-cancel',
				handler:function(){
					dlg.dialog("close");	
				}
			}],
		    modal: true
		});
	}
	
</script>
</body>
</html>