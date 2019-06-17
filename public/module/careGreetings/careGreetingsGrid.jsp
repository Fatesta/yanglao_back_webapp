<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/module/common.jsp" %>
</head>
<body>
<div id="careGreetingsDlg"></div>
<div id="careGreetingsGridToolbar">
	<form id="searchCareGreetingsForm">
		<table class="form">
			<tr>
				<td>日期</td>
				<td><input class="easyui-datebox filter" name="logDate" type="text" style="width: 100px;"></td>
				<td>
					<a href="#" id="searchCareGreetingsBtn" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="searchCareGreetingsQuery()">查询</a> 
					<a href="#" id="clearCareGreetingsBtn" class="easyui-linkbutton" data-options="iconCls:'icon-clear'" onclick="clearCareGreetingsQuery()">清空</a>
					<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-add'" onclick="showSaveCareGreetingsForm(false)">添加</a>
					<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-edit'" onclick="showSaveCareGreetingsForm(true)">修改</a>
					<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-delete'" onclick="delCareGreetings()">删除</a>  
				</td>
			</tr>
		</table>
	</form>
</div>
<table id="careGreetingsGrid" class="easyui-datagrid"
	data-options="url:'${urlPath }careGreetings/listCareGreetings.do',
				  fit:true,
				  singleSelect:false,
				  sortName:'c.create_time',
				  sortOrder:'desc',
				  fitColumns:true,
				  toolbar:'#careGreetingsGridToolbar'
				  ">
	<thead>
		<tr>
			<th data-options="field:'-',width:150,halign:'center',checkbox:true"></th>
			<th data-options="field:'logDate',width:100,halign:'center',align:'center'">日期</th>
			<th data-options="field:'creatorName',width:100,halign:'center'">创建者</th>
			<th data-options="field:'content',width:900,halign:'center',formatter:formatContent">问候语</th>
			<!-- <th data-options="field:'remark',width:500,halign:'center'">备注</th> -->
		</tr>
	</thead>
</table>
<script>

	function searchCareGreetingsQuery() {
		$(this).linkbutton('search', {grid:'#careGreetingsGrid', form:'#searchCareGreetingsForm'});
	}
	
	function clearCareGreetingsQuery() {
		$(this).linkbutton('clearQuery', '#careGreetingsGrid');
	}

	function showSaveCareGreetingsForm(edit) {
		var href = "${urlPath }careGreetings/careGreetingsForm.do";
		var careGreetingsGrid = $("#careGreetingsGrid");
		var rows = careGreetingsGrid.datagrid("getSelections");
		if (edit) {
			if (rows.length > 1) {
				showAlert('错误提示','不能同时编辑多行！','warning');
				return false;
			} else if (rows.length == 0) {
				showAlert('错误提示','必须选中一行才能进行编辑！','warning');
				return false;
			}
			href = href + "?logDate=" + rows[0].logDate;
		}
		var dlg = $("#careGreetingsDlg").dialog({
		    title: "编辑问候语",
		    width: 500,
		    height: 280,
		    closed: false,
		    cache: false,
		    href: href,
		    buttons:[{
				text:"提交",
				iconCls:"icon-save",
				handler:function(){
					$("#careGreetingsForm").form("submit", {
					    url:(edit?"${urlPath }careGreetings/updateCareGreetings.do":"${urlPath }careGreetings/insertCareGreetings.do"),
					    success:function(data){
					    	var data = str2Json(data);
					    	if (data.success) {
					    		dlg.dialog("close");
					    		$("#searchCareGreetingsBtn").trigger("click");
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
	
	function delCareGreetings() {
		var careGreetingsGrid = $("#careGreetingsGrid");
		var rows = careGreetingsGrid.datagrid("getSelections");
		if (rows.length == 0) {
			return false;
		}
		showConfirm("确认操作", "确认删除问候语", function(){
			post("${urlPath}careGreetings/deleteCareGreetings.do", {logDates:getObjectsPropertyArray(rows, "logDate")}, function(){
				$("#searchCareGreetingsBtn").trigger("click");
			}, "json");
		});
	}
	
	function formatContent(value,row,index) {
		return "<span title='" + value + "'>" + value + "</span>";
	}
</script>
</body>
</html>