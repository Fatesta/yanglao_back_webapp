<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/module/common.jsp" %>
</head>
<body>
<div id="adminGridToolbar">
<form id="searchAdmin">
	<table class="form">
		<c:if test="${ROLE_FUNC.code == 'system.admin'}">
		<tr>
			<td colspan="7" class="form">
				<c:forEach var="func" items="${ROLE_FUNCS}">
				    <a name="${func.code}" class="easyui-linkbutton" data-options="iconCls:'${func.icon}'">${func.funcName}</a>
				</c:forEach>
			</td>
		</tr>
		</c:if>

		<tr>
			<td>
				用户名
			</td>
			<td>
				<input class="easyui-textbox" name="username" type="text" style="width: 100px;">
			</td>
			<td>
				姓名
			</td>
			<td>
				<input class="easyui-textbox" name="realName" type="text" type="text" style="width: 100px;">
			</td>
			<td>角色</td>
			<td>
				<input class="easyui-combobox" name="roleId" style="width:100px;"
						data-options="
				            	valueField:'id',
				            	textField:'roleName',
				            	url:'${urlPath }role/listRole.do',
				            	loadFilter: function(page) {
				            		return [{id: '', roleName: '全部'}].concat(page.rows
				            			.filter(function(role){ return [2,3,4].indexOf(role.id) == -1 }));
				            	}">
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
			<td colspan="6">
				<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'"
			            onclick="searchAdmin()">查询</a>
			</td>
		</tr>
	</table>
</form>
</div>
<table id="adminGrid" class="easyui-datagrid"
	data-options="url:'${urlPath }admin/listAdmin.do',
				  multiSort:true,
				  fit:true,
				  pageSize: 50,
				  toolbar:'#adminGridToolbar'">
    <thead>
        <tr>
            <th data-options="field:'username',width:140,halign:'center'">用户名</th>
			<th data-options="field:'roleNames',width:110,align:'center', formatter: UICommon.datagrid.formatter.wraptip">角色</th>
			<th data-options="field:'status',width:60,halign:'center',formatter:formatStatus">是否激活</th>
			<th data-options="field:'realName',width:240,halign:'center'">姓名</th>
            <th data-options="field:'phone',width:90,halign:'center'">手机号码</th>
            <th data-options="field:'email',width:150,halign:'center'">邮箱地址</th>
        </tr>
    </thead>
</table>
<script>

	$('[name=add]').click(function() {
        showAdminForm(false);
	});
    $('[name=update]').click(function() {
        showAdminForm(true);
    });
    $('[name=allocateRole]').click(function() {
        showSetRolesForm();
    });
    $('[name=joinOrg]').click(function() {
        showJoinOrgForm();
    });
    $('[name=disableAdmin]').click(function() {
        enableAdmin(0);
    });
    $('[name=enableAdmin]').click(function() {
        enableAdmin(1);
    });
    $('[name=configCamera]').click(function() {
        showCameraConfigForm();
    });

	function formatStatus(value,rowData,rowIndex) {
		if (value == 1) {
			return "<div class='icon-enable'>&nbsp</div>";
		}
		return "<div class='icon-disable'>&nbsp</div>";
	}

	function searchAdmin() {
		$("#adminGrid").datagrid("load", $("#searchAdmin").serializeObject());
	}
	
	function showSetRolesForm() {
		var href = "admin/showSetRolesForm.do";
		var adminGrid = $("#adminGrid");
		var rows = adminGrid.datagrid("getSelections");
		if (rows.length > 1) {
			showAlert('错误提示','不能同时编辑多行！','warning');
			return false;
		} else if (rows.length == 0) {
			showAlert('错误提示','必须选中一行才能进行编辑！','warning');
			return false;
		}
		href = href + "?id=" + rows[0].id;
		var dlg = openEditDialog({
		    title: "编辑用户角色",
		    width: 450,
		    height: 300,
		    href: href,
		    onSave: function(){
				$("#adminForm").form("submit", {
				    url:"${urlPath }admin/setRoles.do",
				    success:function(data){
				    	var data = str2Json(data);
				    	if (data.success) {
				    		dlg.dialog("close");
				    		adminGrid.datagrid("load");
				    		showMessage('系统提示', data.message);
				    	} else {
				    		showAlert(data.title,data.message,'error');
				    	}
				    }
				});
			}
		});
	}

	function showJoinOrgForm() {
		var href = "admin/showJoinOrgForm.do";
		var adminGrid = $("#adminGrid");
		var row = adminGrid.datagrid("getSelected");
		if (!row) {
			return ;
		}
		if (row.roleId == 1) {
		    alertInfo('无需设置组织');
		    return;
		}
		href = href + "?id=" + row.id + '&roleIds=' + row.roleId;
		var dlg = openEditDialog({
		    title: "加入组织",
		    width: 450,
		    height: 300,
		    href: href,
		    onSave: function(){
				$("#adminForm").form("submit", {
				    url:"${urlPath }admin/joinOrg.do",
				    success:function(data){
				    	var data = str2Json(data);
				    	if (data.success) {
				    		dlg.dialog("close");
				    		adminGrid.datagrid("load");
				    		showMessage('系统提示', data.message);
				    	} else {
				    		showAlert(data.title,data.message,'error');
				    	}
				    }
				});
			}
		});
	}
	
	function showAdminForm(edit) {
		var href = "admin/showAdminForm.do";
		var adminGrid = $("#adminGrid");
		if (edit) {
			var rows = adminGrid.datagrid("getSelections");
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
		    title: "编辑用户",
		    width: 360,
		    height: 360,
		    href: href,
		    onSave: function(){
				$("#adminForm").form("submit", {
				    url:"${urlPath }admin/saveAdmin.do",
				    success:function(data){
				    	var data = str2Json(data);
				    	if (data.success) {
				    		dlg.dialog("close");
				    		adminGrid.datagrid("load");
				    		showMessage('系统提示', data.message);
				    	} else {
				    		showAlert(data.title,data.message,'error');
				    	}
				    }
				});
			}
		});
	}
	
	function showCameraConfigForm() {
        var row = $("#adminGrid").datagrid('getSelected');
        if (!row) return;
        if (!(row.roleId && row.orgIds)) {
            alertInfo('未设置角色或加入组织');
            return;
        }
		var url = "admin/cameraConfigForm.do?admin_id="+row.id;
		url += "&role_id="+(row.roleId || "")+ "&org_id="+(row.orgId || "");
		var dlg = openEditDialog({
		    title: "配置摄像头信息",
		    width: 300,
		    height: 180,
		    href: url,
		    onSave: function(){
				submitForm("cameraConfigForm", "${urlPath}admin/saveCameraConfig.do", function(data){
					data = JSON.parse(data);
					if (data.success) {
						showMessage("操作提示", "操作成功");
						dlg.dialog("close");
					} else {
						showAlert("错误提示", data.message, "warning");
					}
					
				});
			}
		});
	}
	
	function enableAdmin(enable) {
		var row = $("#adminGrid").datagrid('getSelected');
		if (!row || row.status == +enable) return;
		showConfirm("确认操作", enable ? "确认激活系统用户！" : "确认禁用系统用户！", function(){
			post("${urlPath }admin/toggleAdmin.do",{id: row.id, status: +enable},function(data){
			    $("#adminGrid").datagrid("load");
				showMessage('系统提示', data.message);
			});
		});
	}

</script>
</body>
</html>