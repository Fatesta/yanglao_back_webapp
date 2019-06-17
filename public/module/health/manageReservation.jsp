<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/module/common.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<body>

<div id="reservationGridToolbar">
<form id="searchReservationForm">
	<table class="form">
		<tr>
			<td>医生</td>
			<td>
				<input class="easyui-textbox filter" name="doctorName" type="text">
			</td>
			<td>预约时间</td>
			<td>
				<input class="easyui-datebox filter" name="reservationTime" type="text">
			</td>
			<td colspan="6">
				<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'"
			            onclick="searchReservation()">查询</a>
			    <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-add'"
			            onclick="addReservation()">增加预约</a>
			    <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-add'"
			            onclick="deleteReservation()">删除</a>
			</td>
		</tr>
	</table>
</form>
</div>
<table id="reservationGrid" class="easyui-datagrid"
	data-options="url:'${urlPath }health/listReservation.do?userId=${medicalUser.userId}',
				  multiSort:true,
				  fit:true,
				  singleSelect:false,
				  toolbar:'#reservationGridToolbar'">
    <thead>
        <tr>
        	<th data-options="field:'-',width:'2%',align:'center',checkbox:true"></th>
            <th data-options="field:'reservationTime',width:'10%',align:'left'">预约时间</th>
            <th data-options="field:'doctorName',width:'10%',align:'left'">预约医生</th>
            <th data-options="field:'remark',width:'30%',align:'left'">备注</th>
            <th data-options="field:'createTime',width:'10%',align:'left'">创建时间</th>
            <th data-options="field:'--',width:'5%',align:'left',formatter:formatOp">操作</th>
        </tr>
    </thead>
</table>
<div id="reservationDlg"></div>
<script>
var pageConfig = {
	userId: "${medicalUser.userId}"
};

function formatOp(value,rowData,rowIndex) {
	var html =
		'<a href="#" class="easyui-linkbutton" data-options="iconCls:\'color:fff\'" onclick="updateReservation(\'' + rowData.resId + '\')">'
		+'<span title="修改" class=\'icon-edit\' style=\'float:left;width:20px;\'>&nbsp;</span></a>';
	return html;
}

function searchReservation() {
	$("#reservationGrid").datagrid("load", $("#searchReservationForm").serializeObject());
}

function addReservation() {
	editReservation();
}

function updateReservation(resId) {
	editReservation(resId);
}
function editReservation(resId) {
	$.get("${urlPath}health/checkFullMedicalUserInfo.do?userId=" + pageConfig.userId, function(ret){
		if(ret) {
			openReservationForm();
		} else {
			showAlert("提示", "请先完善个人健康档案", "warning");
		}
	});
		
	function openReservationForm() {
		var mode = resId ? "update" : "add";
		var url = "${urlPath }health/reservationForm.do";
		url += "?mode=" + mode + "&userId=" + pageConfig.userId + "&resId="+(resId || "");
		var dlg = $("#reservationDlg").dialog({
		    title: "编辑预约",
		    width: 600,
		    height: 300,
		    closed: false,
		    cache: false,
		    href: url,
		    buttons:[{
				text:"确定",
				iconCls:'icon-ok',
				handler:function(){
					if(!$("#reservationForm").form("validate"))
						return;
					submitForm("reservationForm", "${urlPath}health/saveReservation.do?mode="+mode, function(ret){
						ret = JSON.parse(ret);
						showMessage("操作提示", ret.message);
						if (ret.success) {
							dlg.dialog("close");
							$("#reservationGrid").datagrid('reload');
						}
					});
				}
			},
			{
				text:"取消",
				iconCls:'icon-cancel',
				handler:function(){
					dlg.dialog("close");	
				}
			}],
		    modal: true
		});
	}
}

function deleteReservation(){
	var ress = $("#reservationGrid").datagrid("getSelections");
	if(ress.length == 0)
		return;
	showConfirm("提示","您真的要删除吗？", function(){
		$.post("${urlPath}health/deleteReservations.do?" + $.arrayPickParam("resId", ress, "resId"), function(ret){
			showMessage("操作提示", ret.message);
			$("#reservationGrid").datagrid('reload');
		})
	})
}
</script>
</body>
</html>