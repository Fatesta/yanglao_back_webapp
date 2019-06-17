<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>

<%@ include file="/module/common.jsp" %>


</head>
<body>
<div id="userGridToolbar">
<form id="searchUser">
	<table class="form">
		<tr>
			<td>姓名</td>
			<td>
				<input class="easyui-textbox filter" name="realName" type="text">
			</td>
			<td>手机号</td>
			<td>
				<input class="easyui-textbox filter" name="telphone" type="text">
			</td>
			<td>
				用户类型
			</td>
			<td>
				<input id="userType" class="easyui-combobox filter" name="userType" style="width: 100px;">
			</td>
			<td colspan="6">
				<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'"
			            onclick="reservation.search.query()">查询</a>
			    <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-clear'"
			            onclick="reservation.search.clear()">清空</a>
			    <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-add'"
			            onclick="batchAddReservation()">批量预约</a>
			</td>
		</tr>
	</table>
</form>
</div>
<table id="userGrid" class="easyui-datagrid"
	data-options="url:'${urlPath }health/listUser.do',
				  multiSort:true,
				  fit:true,
				  singleSelect:false,
				  toolbar:'#userGridToolbar'">
    <thead>
        <tr>
        	<th data-options="field:'-',width:'2%',align:'center',checkbox:true"></th>
            <th data-options="field:'aliasName',width:'100', halign:'center', align:'left'">昵称</th>
            <th data-options="field:'realName',width:'6%', halign:'center', align:'left'">姓名</th>
            <th data-options="field:'telphone',width:'100', halign:'center', align:'left'">手机号码</th>
            <th data-options="field:'userType',width:'6%', halign:'center', align:'center',formatter:UICommon.datagrid.formatter.generators.dict(DictMan.itemMap('user.type'))">用户类型</th>
            <th data-options="field:'sex',width:'4%', halign:'center', align:'center',formatter:reservation.formatters.sex">性别</th>
            <th data-options="field:'birthday',width:'130', halign:'center', align:'center'">出生日期</th>
            <th data-options="field:'address',width:'20%', halign:'center', align:'left'">家庭地址</th>
            <th data-options="field:'registerTime',width:'130', halign:'center', align:'center'">注册时间</th>
            <th data-options="field:'--',width:'80', halign:'center', align:'left',formatter:reservation.formatters.op">操作</th>
        </tr>
    </thead>
</table>
<script>
$('#userType').comboboxFromDict({
    dict: DictMan.items('user.type').filter(function(item) { return [1, 9].includes(+item.value)})
});

var reservation = {};
(function(exports){
exports.formatters = {
	sex: function(value,rowData,rowIndex) {
		return value == '0' ? "男" : "女";
	},
	op: function(value,rowData,rowIndex) {
		var html =
			'<a href="#" class="easyui-linkbutton" data-options="iconCls:\'color:fff\'" onclick=reservation.user.makeReservation("{0}","{1}")>'.format(rowData.userId, rowData.aliasName)
				+'<span title="预约管理" class=\'icon-add\' style=\'float:left;width:20px;\'>&nbsp;</span></a>'
		return html;
	}
};
exports.search = {
	query: function() {
		$("#userGrid").datagrid("load", $("#searchUser").serializeObject());
	},
	clear: function() {
		$(".filter").each(function(){
		  	$(this).textbox("clear");
		});
	}
};

exports.user = {
	add: function() {
		edit();
	},
	update: function(userId) {
		edit(userId);
	},
	del: function(){
		var users = $("#userGrid").datagrid("getSelections");
		if(users.length == 0)
			return;
		showConfirm("提示","您真的要删除吗？", function(){
			$.post("${urlPath}health/deleteMedicalUsers.do?" + $.arrayPickParam("userIds", users, "userId"), function(ret){
				showMessage("操作提示", ret.message);
				$("#userGrid").datagrid('reload');
			})
		})
	},
	//预约
	makeReservation: function(userId, userName) {
		openTab("mainTab", "${urlPath }health/manageReservation.do?userId=" +userId, userName+" - 预约管理");
	}
};

})(reservation);

function batchAddReservation() {
	var users = $("#userGrid").datagrid("getSelections");
	if(users.length == 0) {
		showMessage("提示", "请选择用户");
		return;
	}
	var url = "health/reservationForm.do";
	url += "?mode=batchAdd&userIds=" + users.map(function(u){ return u.userId; }).join(",");
	var dlg = openEditDialog({
	    title: "批量预约",
	    width: 600,
	    height: 300,
	    href: url,
	    onSave: function(){
			if(!$("#reservationForm").form("validate"))
				return;
			submitForm("reservationForm", "${urlPath}health/saveReservation.do?mode=batchAdd", function(ret){
				ret = JSON.parse(ret);
				if (ret.success) {
					showMessage("操作提示", ret.message);
				} else {
					showAlert("操作提示", $('<div/>').html(ret.message).text(), "info");
				}
				dlg.dialog("close");
			});
		}
	});
}
</script>
</body>
</html>