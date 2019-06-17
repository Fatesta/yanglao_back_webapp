<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/module/common.jsp" %>
</head>
<body>
   <input type="hidden" id="masterId" value="" >
<table id="groupMemberGrid" class="easyui-datagrid"
	data-options="url:'${urlPath }group/listGroupMember.do?groupId=${groupId }',
				  fit:true,
				  multiSort:true,
				  singleSelect:true">
    <thead>
        <tr>
            <th data-options="field:'--',width:30,halign:'center',formatter:formatJob"></th>
            <th data-options="field:'aliasName',width:150,halign:'center'">群成员</th>
            <th data-options="field:'telphone',width:100,halign:'center'">手机号</th>
            <th data-options="field:'deviceCode',width:150,halign:'center'">设备号</th>
            <th data-options="field:'joinTime',width:150,halign:'center'">入群时间</th>
            <c:if test="${not empty ROLE_FUNC_MAP['group.deleteMember']}">
            <th data-options="field:'-',width:100,halign:'center',formatter:formatOp">操作</th>
            </c:if>
        </tr>
    </thead>
</table>
<script>

	function formatJob(value,rowData,rowIndex) {
		if (rowData.memberId == "${masterId}") {
			return '<div class=\'icon-master\'>&nbsp;</div>';
		}
		return '<div class=\'icon-member\'>&nbsp;</div>';
	}

	function formatOp(value,rowData,rowIndex) {
		if (rowData.memberId == "${masterId}") {
			return '';
		}
		return '<a href="#" class="easyui-linkbutton" data-options="iconCls:\'color:fff\'" onclick="deleteGroupMember(\'' + rowData.memberId + '\')"><div class=\'icon-relieve\'>&nbsp;</div></a>';
	}
	
	function deleteGroupMember(memberId) {
		var json = '{"groupId":"${groupId}","clientId":"'+ memberId +'","groupCreator":"${masterId}"}';
		showConfirm("确认操作", "确认剔除成员", function(){
			var rows = $("#groupMemberGrid").datagrid("getRows");
			// 设备用户数量
			var count = 0;
			for (var i = 0; i < rows.length; i++) {
				if (rows[i].deviceCode != null) {
					count ++;
				}
			}
			if (count > 1) {// 踢人
				post("${urlPath}group/deleteGroupMember.do", {json:json}, function(data){
		        	if (data.success) {
		        		showMessage("操作提示", "操作成功！");
		        		$('#dg').datagrid("reload");
		        	} else {
		        		showAlert("操作提示", "操作失败！");
		        	}
		        }, "json");
			} else {// 解散群
				post("${urlPath}group/deleteGroup.do", {json:json}, function(data){
					if (data.success) {
						showMessage("操作提示", "操作成功！");
						openTab("mainTab", "${urlPath}group/groupGrid.do", "群关系管理");
					} else {
						showAlert("操作提示", "操作失败！");
					}
				}, "json");
			}
		});
	}
	
</script>
</body>
</html>