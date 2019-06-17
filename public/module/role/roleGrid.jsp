<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/module/common.jsp" %>
</head>
<body>
<div id="roleGridToolbar">
<form id="searchRole">
	<table class="form">
		<tr>
			<td colspan="7" class="form">
				<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-add'"
			            onclick="showRoleForm(false)">新增</a>
			    <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-edit'"
			            onclick="showRoleForm(true)">修改</a>
                <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-forbidden-btn'"
                        onclick="disableRole()">禁用</a>
                <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-active-btn'"
                        onclick="enableRole()">启用</a>
			    <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-allocate'"
			            onclick="showSetFuncsForm()">分配权限</a>   
			</td>
		</tr>
		<tr>
			<td>
				角色名
			</td>
			<td>
				<input class="easyui-textbox" name="roleName" type="text">
			</td>
			<td>
				状态
			</td>
			<td>
			    <select class="easyui-combobox" name="status" style="width: 80px;">
			        <option value="" selected="selected">全部</option>
			        <option value="1">激活</option>
			        <option value="0">禁用</option>
			    </select>
			</td>
			<td>
				<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'"
			            onclick="searchRole()">查询</a>
			</td>
		</tr>
	</table>
</form>
</div>
<table id="roleGrid" class="easyui-datagrid"
	data-options="url:'${urlPath }role/listRole.do',
				  multiSort:true,
				  fit:true,
				  toolbar:'#roleGridToolbar'">
    <thead>
        <tr>
            <th data-options="field:'roleName',width:100,halign:'center'">角色名</th>
            <th data-options="field:'status',width:80,halign:'center',formatter:formatStatus">是否激活</th>
            <th data-options="field:'remark',width:400,halign:'center'">备注</th>
        </tr>
    </thead>
</table>
<script>

	function formatStatus(value,rowData,rowIndex) {
		if (value == 1) {
    		return "<div class='icon-enable'>&nbsp</div>";
    	}
    	return "<div class='icon-disable'>&nbsp</div>";
	}

	function searchRole() {
		$("#roleGrid").datagrid("load", $("#searchRole").serializeObject());
	}

	function showRoleForm(edit) {
		var href = "role/showRoleForm.do";
		var roleGrid = $("#roleGrid");
		if (edit) {
			var rows = roleGrid.datagrid("getSelections");
			if (rows.length > 1) {
				showAlert('错误提示','不能同时编辑多行！','warning');
				return false;
			} else if (rows.length == 0) {
				showAlert('错误提示','必须选中一行才能进行编辑！','warning');
				return false;
			}
			href = href + "?id=" + rows[0].id;
		}
		var dlg = openEditDialog({
		    title: "编辑角色",
		    width: 450,
		    height: 200,
		    href: href,
		    onSave: function(){
				$("#roleForm").form("submit", {
				    url:"${urlPath }role/saveRole.do",
				    success:function(data){
				    	var data = str2Json(data);
				    	if (data.success) {
				    		dlg.dialog("close");
				    		roleGrid.datagrid("load");
				    		showMessage('系统提示', data.message);
				    	} else {
				    		showAlert(data.title,data.message,'error');
				    	}
				    }
				});
			}
		});
	}
	
	function showSetFuncsForm() {
		var href = "role/showSetFuncsForm.do";
		var roleGrid = $("#roleGrid");
		var rows = roleGrid.datagrid("getSelections");
		if (rows.length > 1) {
			showAlert('错误提示','不能同时编辑多行！','warning');
			return false;
		} else if (rows.length == 0) {
			showAlert('错误提示','必须选中一行才能进行编辑！','warning');
			return false;
		}
		href = href + "?id=" + rows[0].id;
		var dlg = openEditDialog({
		    title: "编辑角色权限",
		    width: 300,
		    height: 600,
		    href: href,
		    onSave:function(){
				var nodes = $('#funcMenu').tree('getChecked', ['checked','indeterminate']);
				var ids = new Array(nodes.length);
				for (var i = 0; i < nodes.length; i++) {
					ids[i] = nodes[i].id;
				}
				post("${urlPath}role/setRoleFunc.do", {roleId:$("#roleId").val(),funcIds:ids}, function(data){
			    	if (data.success) {
			    		dlg.dialog("close");
			    		roleGrid.datagrid("load");
			    		showMessage('系统提示', data.message);
			    	} else {
			    		showAlert(data.title,data.message,'error');
			    	}
				}, "json");
			}
		});
	}
	
	function enableRole(id) {
		var roleGrid = $("#roleGrid");
		showConfirm("确认操作", "确认激活角色！", function(){
			post("${urlPath }role/toggleRole.do", {id:id,status:1}, function(data){
				roleGrid.datagrid("load");
			   	showMessage('系统提示', data.message);
			});
		});
	}
	
	function disableRole(id) {
		var roleGrid = $("#roleGrid");
		showConfirm("确认操作", "确认禁用角色！", function(){
			post("${urlPath }role/toggleRole.do",{id:id,status:0},function(data){
				roleGrid.datagrid("load");
				showMessage('系统提示', data.message);
			});
		});
	}

</script>
</body>
</html>