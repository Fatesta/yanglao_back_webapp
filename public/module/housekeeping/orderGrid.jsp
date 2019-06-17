<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/module/common.jsp" %>
</head>
<body>
<div id="housekeepingOrderGridToolbar">
<form id="searchHousekeepingOrderForm">
	<table class="form">
		<tr>
			<td>
				雇主姓名
			</td>
			<td>
				<input class="easyui-textbox filter" name="employerName" type="text">
			</td>
			<td>
				服务类型
			</td>
			<td>
				<select class="easyui-combobox filter" name="type" style="width: 80px;">
			        <option value="" selected="selected">全部</option>
			        <option value="1">保姆</option>
			    </select>
			</td>
			<td>
				订单状态
			</td>
			<td>
				<select class="easyui-combobox filter" name="status" style="width: 80px;">
			        <option value="" selected="selected">全部</option>
			        <option value="1">未分配</option>
			        <option value="2">未执行</option>
			        <option value="3">执行中</option>
			        <option value="4">已完成</option>
			    </select>
			</td>
			<td>
				订单日期
			</td>
			<td>
			    <input class="easyui-datetimebox filter" name="startTime" type="text">&nbsp;至&nbsp;
			    <input class="easyui-datetimebox filter" name="endTime" type="text">
			</td>
			<td>
				<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'"
			            onclick="searchHousekeepingOrder()">查询</a>
			    <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-clear'"
			            onclick="clearQuery()">清空</a>
			</td>
		</tr>
		<tr>
			<td colspan="9">
				<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-order-unexecuted'"
			            onclick="showAllocationOrderForm()">分配订单</a>
			    <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-order-doing'"
			            onclick="doingOrder()">执行订单</a>
			    <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-order-done'"
			            onclick="doneOrder()">完成订单</a>
			</td>
		</tr>
	</table>
</form>
</div>
<table id="housekeepingOrderGrid" class="easyui-datagrid"
	data-options="url:'${urlPath }housekeeping/order/listOrder.do',
				  multiSort:true,
				  sortName:'create_time',
				  sortOrder:'desc',
				  fit:true,
				  toolbar:'#housekeepingOrderGridToolbar'">
    <thead>
        <tr>
            <th data-options="field:'orderId',width:120,halign:'center'">订单ID</th>
            <th data-options="field:'orderNo',width:120,halign:'center'">订单编号</th>
            <th data-options="field:'type',width:70,halign:'center',align:'center',formatter:formatType">服务类型</th>
            <th data-options="field:'status',width:70,halign:'center',align:'center',formatter:formatStatus">订单状态</th>
            <th data-options="field:'employerName',width:70,halign:'center'">雇主姓名</th>
            <th data-options="field:'employerTelphone',width:100,halign:'center'">雇主电话</th>
            <th data-options="field:'address',width:250,halign:'center'">服务地址</th>
            <th data-options="field:'worker',width:120,halign:'center'">雇员设备号</th>
            <th data-options="field:'reward',width:100,halign:'center',align:'right'">酬金</th>
            <th data-options="field:'startTime',width:130,halign:'center'">开始时间</th>
            <th data-options="field:'endTime',width:130,halign:'center'">结束时间</th>
            <th data-options="field:'createTime',width:130,halign:'center'">下单时间</th>
            <th data-options="field:'remark',width:300,halign:'center'">工作内容</th>
        </tr>
    </thead>
</table>
<div id="allocationOrderDlg"></div>
<script>

	function doingOrder() {
		var housekeepingOrderGrid = $("#housekeepingOrderGrid");
		var rows = housekeepingOrderGrid.datagrid("getSelections");
		if (rows.length == 0) {
			showAlert("操作提示", "您没有可以执行的订单！");
			return false;
		}
		if (rows[0].status == 4) {
			showAlert("操作提示", "不能执行已完成的订单！");
			return false;
		}
		showConfirm("确认操作", "确认执行订单！", function(){
			post("${urlPath }housekeeping/order/doingOrder.do", {orderId:rows[0].orderId}, function(data){
				$("#housekeepingOrderGrid").datagrid("load");
			   	showMessage('系统提示', data.message);
			});
		});
	}
	
	function doneOrder() {
		var housekeepingOrderGrid = $("#housekeepingOrderGrid");
		var rows = housekeepingOrderGrid.datagrid("getSelections");
		if (rows.length == 0) {
			showAlert("操作提示", "您没有可以完成的订单！");
			return false;
		}
		if (rows[0].status == 4) {
			showAlert("操作提示", "不能重复完成订单！");
			return false;
		}
		showConfirm("确认操作", "确认完成订单！", function(){
			post("${urlPath }housekeeping/order/doneOrder.do", {orderId:rows[0].orderId}, function(data){
				if (data.success) {
					$("#housekeepingOrderGrid").datagrid("load");
				   	showMessage('系统提示', data.message);
				} else {
					showAlert(data.title, data.message);					
				}
			});
		});
	}
	
	function showAllocationOrderForm() {
		var housekeepingOrderGrid = $("#housekeepingOrderGrid");
		var rows = housekeepingOrderGrid.datagrid("getSelections");
		if (rows.length == 0) {
			showAlert("操作提示", "您没有可以分配的订单！");
			return false;
		}
		if (rows[0].status != 1) {
			showAlert("操作提示", "只能分配未分配的订单！");
			return false;
		}
		var href = "${urlPath }housekeeping/order/showAllocationOrderForm.do?orderId=" + rows[0].orderId;
		var dlg = $("#allocationOrderDlg").dialog({
		    title: "分配订单",
		    width: 480,
		    height: 320,
		    closed: false,
		    cache: false,
		    href: href,
		    buttons:[{
				text:"提交",
				iconCls:"icon-save",
				handler:function(){
					$("#allocationOrderForm").form("submit", {
					    url:"${urlPath }housekeeping/order/allocationOrder.do",
					    success:function(data){
					    	var data = str2Json(data);
					    	if (data.success) {
					    		dlg.dialog("close");
					    		$("#housekeepingOrderGrid").datagrid("load");
					    		showMessage('系统提示', data.message);
					    	} else {
					    		showAlert(data.title,data.message,'error');
					    	}
					    } 
					});
				}
			},{
				text:"取消",
				iconCls:'icon-cancel',
				handler:function(){
					dlg.dialog("close");	
				}
			}],
		    modal: true
		});
	}

	function clearQuery() {
		$(".filter").each(function(){
		  	$(this).textbox("clear");
		});
		$("#housekeepingOrderGrid").datagrid("load", {});
	}

	function formatType(value,rowData,rowIndex) {
		if (value == 1) {
			return "保姆";
		}
	}
	
	function formatStatus(value,rowData,rowIndex) {
		if (value == 1) {
			return "未分配";
		} else if (value == 2) {
			return "未执行";
		} else if (value == 3) {
			return "执行中";
		} else if (value == 4) {
			return "已完成";
		}
		return value;
	}

	function searchHousekeepingOrder() {
		var d={};
		$("#searchHousekeepingOrderForm").find('input,select')
						  .each(function(){
							  if (this.name) {
							  	d[this.name]=this.value
							  }
						  });
		$("#housekeepingOrderGrid").datagrid("load", d);
	}
	
</script>
</body>
</html>