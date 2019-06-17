<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/module/common.jsp" %>
</head>
<body>
<div id="serviceResourceOrderGridToolbar">
<form id="searchServiceResourceOrderForm">
	<table class="form">
		<tr>
			<td>
				城市
			</td>
			<td>
				<select class="easyui-combobox filter" name="city" style="width: 80px;">
			        <option value="" selected="selected">全部</option>
			        <option value="北京">北京</option>
			        <option value="上海">上海</option>
			        <option value="广州">广州</option>
			        <option value="深圳">深圳</option>
			        <option value="武汉">武汉</option>
			    </select>
			</td>
			<td>
				类型
			</td>
			<td>
				<select class="easyui-combobox filter" name="serviceType" style="width: 80px;">
			        <option value="" selected="selected">全部</option>
			        <option value="1">衣</option>
			        <option value="2">食</option>
			        <option value="3">住</option>
			        <option value="4">行</option>
			    </select>
			</td>
			<td>
				订单状态
			</td>
			<td>
				<select class="easyui-combobox filter" name="status" style="width: 80px;">
			        <option value="" selected="selected">全部</option>
			        <option value="0">已取消</option>
			        <option value="1">已下单</option>
			        <option value="2">已完成</option>
			    </select>
			</td>
			<td>
				资源名称
			</td>
			<td>
				<input class="easyui-textbox filter" name="orgName" type="text">
			</td>
			<td>
				收货人手机号
			</td>
			<td>
				<input class="easyui-textbox filter" name="deviceTel" type="text">
			</td>
			<td>
			    <a href="#" id="queryBtn" class="easyui-linkbutton" data-options="iconCls:'icon-search'"
			            onclick="searchQuery()">查询</a>
			    <a href="#" id="clearStat" class="easyui-linkbutton" data-options="iconCls:'icon-clear'"
			            onclick="clearQuery()">清空</a>
			    <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-cancel-order'"
			            onclick="cancelOrder()">取消订单</a>
			    <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-done-order'"
			            onclick="doneOrder()">完成订单</a>
			</td>
		</tr>
	</table>
</form>
</div>
<table id="serviceResourceOrderGrid" class="easyui-datagrid"
	data-options="url:'${urlPath }serviceResourceOrder/listOrder.do',
				  sortName:'o.create_time',
				  sortOrder:'desc',
				  fit:true,
				  toolbar:'#serviceResourceOrderGridToolbar'">
    <thead>
        <tr>
            <th data-options="field:'orderId',width:150,halign:'center'">订单ID</th>
            <th data-options="field:'status',width:50,halign:'center',align:'center',formatter:formatStatus">状态</th>
            <th data-options="field:'serviceType',width:50,halign:'center',align:'center',formatter:formatType">类型</th>
            <th data-options="field:'--',width:300,halign:'center',formatter:formatBusiness">商家信息</th>
            <!-- <th data-options="field:'city',width:80,halign:'center'">城市</th>
            <th data-options="field:'orgName',width:250,halign:'center'">资源名称</th>
            <th data-options="field:'contactName',width:80,halign:'center'">联系人</th>
            <th data-options="field:'contactTel',width:120,halign:'center'">手机号</th>
            <th data-options="field:'contactFixPhone',width:120,halign:'center'">固话</th> -->
            <th data-options="field:'-',width:400,halign:'center',formatter:formatReceiver">收货人信息</th>
            <th data-options="field:'createTime',width:150,halign:'center'">下单时间</th>
            <!-- <th data-options="field:'deviceTel',width:130,halign:'center'">收货人手机号</th>
            <th data-options="field:'aliasName',width:130,halign:'center'">收货人昵称</th>
            <th data-options="field:'address',width:300,halign:'center',formatter:formatTitle">收货地址</th> -->
            <th data-options="field:'remark',width:500,halign:'center',formatter:formatTitle">备注</th>
        </tr>
    </thead>
</table>
<script>

	function searchQuery() {
		$(this).linkbutton('search', {grid:'#serviceResourceOrderGrid', form:'#searchServiceResourceOrderForm'});
	}
	
	function clearQuery() {
		$(this).linkbutton('clearQuery', '#serviceResourceOrderGrid');
	}

	function formatType(value,rowData,rowIndex) {
		if (value == 1) {
			return "衣";
		} else if (value == 2) {
			return "食";
		} else if (value == 3) {
			return "住";
		} else if (value == 4) {
			return "行";
		}
	}
	
	function formatStatus(value,rowData,rowIndex) {
		if (value == 1) {
			return "已下单";
		} else if (value == 2) {
			return "已完成";
		} else if (value == 0) {
			return "已取消";
		}
	}
	
	function formatBusiness(value,rowData,rowIndex) {
		return "[" + rowData.city + "] " + rowData.orgName + " " + (rowData.contactName == null ? "" : rowData.contactName + " ") + (rowData.contactTel == null ? "" : rowData.contactTel + " ") + (rowData.contactFixPhone == null ? "" : rowData.contactFixPhone);
	}
	
	function formatReceiver(value,rowData,rowIndex) {
		return rowData.aliasName + " (" + rowData.deviceTel + ") " + rowData.address;
	}
	
	function formatTitle(value,rowData,rowIndex) {
		return "<span title='" + (value == null ? "" : value) + "'>" + (value == null ? "" : value) + "</span>";
	}
	
	function cancelOrder() {
		var grid = $("#serviceResourceOrderGrid");
		var rows = grid.datagrid("getSelections");
		if (rows.length == 0) {
			showAlert("操作提示", "您没有可以完成的订单！");
			return false;
		}
		if (rows[0].status == 0) {
			showAlert("操作提示", "不能重复取消订单！");
			return false;
		}
		if (rows[0].status == 2) {
			showAlert("操作提示", "不能取消已完成的订单！");
			return false;
		}
		showConfirm("确认操作", "确认取消订单！", function(){
			post("${urlPath }serviceResourceOrder/cancelOrder.do", {orderId:rows[0].orderId}, function(data){
				if (data.success) {
					$("#queryBtn").trigger("click");
				   	showMessage('系统提示', data.message);
				} else {
					showAlert(data.title, data.message);					
				}
			});
		});
	}
	
	function doneOrder() {
		var grid = $("#serviceResourceOrderGrid");
		var rows = grid.datagrid("getSelections");
		if (rows.length == 0) {
			showAlert("操作提示", "您没有可以完成的订单！");
			return false;
		}
		if (rows[0].status == 0) {
			showAlert("操作提示", "不能完成已取消的订单！");
			return false;
		}
		if (rows[0].status == 2) {
			showAlert("操作提示", "不能重复完成订单！");
			return false;
		}
		showConfirm("确认操作", "确认取消订单！", function(){
			post("${urlPath }serviceResourceOrder/doneOrder.do", {orderId:rows[0].orderId}, function(data){
				if (data.success) {
					$("#queryBtn").trigger("click");
				   	showMessage('系统提示', data.message);
				} else {
					showAlert(data.title, data.message);					
				}
			});
		});
	}
	
</script>
</body>
</html>