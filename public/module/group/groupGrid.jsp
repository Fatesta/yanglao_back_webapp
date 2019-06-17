<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/module/common.jsp" %>
</head>
<body>
<div id="groupGridToolbar">
<form id="searchGroup">
	<table class="form">
		<tr>
			<td>
				设备号
			</td>
			<td>
			    <input class="easyui-textbox filter" name="deviceCode" type="text">
			</td>
			<td>
				群名称
			</td>
			<td>
				<input class="easyui-textbox filter" name="name" type="text">
			</td>
			<td>
				群主昵称
			</td>
			<td>
				<input class="easyui-textbox filter" name="aliasName" type="text">
			</td>
			<td>
				手机号
			</td>
			<td>
				<input class="easyui-textbox filter" name="telphone" type="text">
			</td>
			<td colspan="6">
				<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'"
			            onclick="searchGroup()">查询</a>
			    <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-clear'"
			            onclick="clearQuery()">清空</a>
			</td>
		</tr>
	</table>
</form>
</div>
<table id="groupGrid" class="easyui-datagrid"
	data-options="url:'${urlPath }group/listGroup.do',
				  multiSort:true,
				  fit:true,
				  toolbar:'#groupGridToolbar'">
    <thead>
        <tr>
            <th data-options="field:'name',width:200,halign:'center',formatter:formatName">群名称</th>
            <th data-options="field:'aliasName',width:150,halign:'center'">群主昵称</th>
            <th data-options="field:'createTime',width:150,halign:'center'">创建时间</th>
            <th data-options="field:'-',width:80,halign:'center',formatter:formatOp">操作</th>
        </tr>
    </thead>
</table>
<div id="adminDlg"></div>
<script>

	function clearQuery() {
		$(".filter").each(function(){
		  	$(this).textbox("clear");
		});
		$("#groupGrid").datagrid("load", {});
	}

	function formatOp(value,row,index) {
	    var html = '';
		if("${not empty session_role_leaf_fn_map['61']}" === "true")
		    html += '<a href="#" class="easyui-linkbutton" data-options="iconCls:\'color:fff\'" onclick=deleteGroup("' + row.groupId + '","'+ row.appUserid + '")>'
		        +'<span title="解散群" class=\'icon-delete-group\' style="float:left;width:20px;">&nbsp;</span></a>';
		if("${not empty session_role_leaf_fn_map['93']}" === "true")
		    html += '<a href="#" class="easyui-linkbutton" data-options="iconCls:\'color:fff\'" onclick=showSafePositions("'+ row.appUserid +'","' + row.groupId + '")>'
				+'<span title="安全" class=\'icon-safe-location\' style="float:left;width:20px;">&nbsp;</span></a>';
		return html;
	}
	
	function showSafePositions(appUserid, groupId) {
		var url = "${urlPath}group/showSafePositionGrid.do?_func_id=${ROLE_FUNC.id}&groupCreator=" + appUserid + "&groupId=" + groupId;
		openTab("mainTab", url, "安全定位");
	}

	function formatName(value,row,index) {
		return '<a href="#" class="easyui-linkbutton" data-options="iconCls:\'color:fff\'" onclick=showGroupMemberGrid("' + row.groupId + '","'+ row.appUserid + '")>' + value + '</a>';
	}
	
	function showGroupMemberGrid(groupId, appUserid) {
		openTab("mainTab", "${urlPath}group/groupMemberGrid.do?_func_id=${ROLE_FUNC.id}&groupId=" + groupId + "&masterId=" + appUserid, "群成员列表");
	}
	
	function deleteGroup(groupId, appUserid){
		var json = '{"groupId":"'+groupId+'","groupCreator":"'+ appUserid+'"}';
		showConfirm("确认操作", "确认解散群", function() {
			post("${urlPath}group/deleteGroup.do", {json:json}, function(data){
				if (data.success) {
					showMessage("操作提示", "操作成功！");
					$("#groupGrid").datagrid("reload");
				} else {
					showAlert("操作提示", "操作失败！");
				}
			}, "json");
		});
	}

	function searchGroup() {
		var d={};
		$("#searchGroup").find('input,select')
						  .each(function(){
							  if (this.name) {
							  	d[this.name]=this.value
							  }
						  });
		$("#groupGrid").datagrid("load", d);
	}
	
</script>
</body>
</html>