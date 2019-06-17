<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/module/common.jsp" %>
</head>
<body class="easyui-layout">
    <div data-options="region:'west',title:'节目分类',split:true" style="width:150px;">
    	<table id="programTypeGrid" class="easyui-datagrid"
			data-options="url:'${urlPath }program/listProgramType.do',
				  pagination:false,
				  fit:true,
				  fitColumns:true,
				  onClickRow:selectType
				  ">
			<thead>
				<tr>
					<th data-options="field:'name',width:100,halign:'center',formatter:formatResourceType">节目分类</th>
				</tr>
			</thead>
		</table>
    </div>
    <div data-options="region:'center',title:'节目列表'" style="padding:5px;">
    	<div id="programDlg"></div>
		<div id="programGridToolbar">
			<form id="searchProgramForm">
				<table class="form">
					<tr>
						<td>节目类型</td>
						<td>
							<input id="searchProgramTypeCombobox" class="easyui-combobox filter" name="programType" style="width: 150px;"
								data-options="valueField:'did',textField:'name',url:'${urlPath }program/listProgramType.do'">
						</td>
						<td>节目名称</td>
						<td><input class="easyui-textbox filter" name="resourceName" type="text" style="width: 150px;"></td>
						<td>作者</td>
						<td><input class="easyui-textbox filter" name="author" type="text" style="width: 150px;"></td>
						<td>
							<a href="#" id="searchProgramBtn" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="searchProgramQuery()">查询</a> 
							<a href="#" id="clearProgramBtn" class="easyui-linkbutton" data-options="iconCls:'icon-clear'" onclick="clearProgramQuery()">清空</a>
							<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-add'" onclick="showSaveProgramForm(false)">添加</a>
							<!-- <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-add'" onclick="showSaveProgramForm(true)">修改</a> -->
							<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-delete'" onclick="delProgram()">删除</a>
							<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-radio'" onclick="notify()">通知</a>
						</td>
					</tr>
				</table>
			</form>
			<form id="uploadProgramForm" enctype="multipart/form-data" method="post">
				<table class="form">
					<tr>
						<td>
							<input class="easyui-filebox" name="file" style="width:300px" data-options="buttonText:'选择文件'">
						    <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-import',accept:'application/zip'"
						            onclick="importProgram()">导入</a>
						    <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-download'"
			            		onclick="downloadTemplate()">下载模板</a>
						</td>
					</tr>
				</table>
			</form>
		</div>
		<table id="programGrid" class="easyui-datagrid"
			data-options="url:'${urlPath }program/listProgram.do',
				  fit:true,
				  singleSelect:false,
				  toolbar:'#programGridToolbar'
				  ">
			<thead>
				<tr>
					<th data-options="field:'-',width:150,halign:'center',checkbox:true"></th>
					<th data-options="field:'resourceName',width:300,halign:'center',formatter:formatResourceName">节目名称</th>
					<th data-options="field:'programType',width:130,halign:'center'">节目类型</th>
					<th data-options="field:'resourceSize',width:130,halign:'center',formatter:formatSize">文件大小</th>
					<th data-options="field:'author',width:130,halign:'center'">作者</th>
					<th data-options="field:'createTime',width:150,halign:'center'">创建时间</th>
				</tr>
			</thead>
		</table>
    </div>
</body>
<script>

	function selectType(index, row) {
		$("#searchProgramTypeCombobox").combobox("select", row.did);
		$("#searchProgramBtn").trigger("click");
	}

	function searchProgramQuery() {
		$(this).linkbutton('search', {grid:'#programGrid', form:'#searchProgramForm'});
	}
	
	function clearProgramQuery() {
		$(this).linkbutton('clearQuery', '#programGrid');
	}
	
	function formatResourceName(value,row,index) {
		return value.substr(0, value.lastIndexOf("."));
	}
	
	function formatSize(value,row,index) {
		return Math.roundFloat(value / 1024 / 1024, 1) +"MB";
	}
	
	function formatResourceType(value,row,index) {
		return "<div class='icon-program' style='float:left;displan:block;width:16px;'>&nbsp</div>" + value;
	}

	function showSaveProgramForm(edit) {
		var href = "${urlPath }program/programForm.do";
		var programGrid = $("#programGrid");
		var rows = programGrid.datagrid("getSelections");
		if (edit) {
			if (rows.length > 1) {
				showAlert('错误提示','不能同时编辑多行！','warning');
				return false;
			} else if (rows.length == 0) {
				showAlert('错误提示','必须选中一行才能进行编辑！','warning');
				return false;
			}
			href = href + "?programId=" + rows[0].programId;
		}
		var dlg = $("#programDlg").dialog({
		    title: "编辑节目",
		    width: 350,
		    height: 240,
		    closed: false,
		    cache: false,
		    href: href,
		    buttons:[{
				text:"提交",
				iconCls:"icon-save",
				handler:function(){
					$("#programForm").form("submit", {
					    url:"${urlPath }program/saveProgram.do",
					    success:function(data){
					    	var data = str2Json(data);
					    	if (data.success) {
					    		dlg.dialog("close");
					    		$("#searchProgramBtn").trigger("click");
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
	
	function delProgram() {
		var programGrid = $("#programGrid");
		var rows = programGrid.datagrid("getSelections");
		if (rows.length == 0) {
			return false;
		}
		showConfirm("确认操作", "确认删除节目信息", function(){
			post("${urlPath}program/deleteProgram.do", {ids:getObjectsPropertyArray(rows, "programId")}, function(){
				$("#searchProgramBtn").trigger("click");
			}, "json");
		});
	}
	
	function notify() {
		post("${urlPath}program/notify.do", null, function(){
			showMessage('系统提示', "通知消息发送成功！");
		});
	}
	
	function importProgram() {
		submitForm("uploadProgramForm", "${urlPath}program/importProgram.do", function(data){
			$("#searchProgramBtn").trigger("click");
			showMessage('系统提示', "导入节目成功！");
		});
	}
	
	function downloadTemplate() {
		location.href = CONFIG.modulePath + "program/program_template.zip";
	}
</script>
</html>