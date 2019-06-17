<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/module/common.jsp" %>
</head>
<body>
<div id="logGridToolbar">
<form id="searchLog">
	<table class="form">
		<tr>
			<td>
				登录名
			</td>
			<td>
				<input class="easyui-textbox filter" name="creatorName" type="text">
			</td>
			<td>
				操作时间
			</td>
			<td>
				<input class="easyui-datebox filter" name="minCreateTime" type="text">&nbsp;至&nbsp;
			    <input class="easyui-datebox filter" name="maxCreateTime" type="text">
			</td>
			<td>
				<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'"
			            onclick="searchQuery()">查询</a>
			    <a href="#" id="clearStat" class="easyui-linkbutton" data-options="iconCls:'icon-clear'"
			            onclick="clearQuery()">清空</a>
			</td>
		</tr>
	</table>
</form>
</div>
<table id="logGrid" class="easyui-datagrid"
	data-options="url:'${urlPath }log/listLog.do',
				  multiSort:true,
				  fit:true,
				  sortName:'l.operation_time',
				  sortOrder:'desc',
				  toolbar:'#logGridToolbar'">
    <thead>
        <tr>
            <!-- <th data-options="field:'serialId',width:300,halign:'center'">ID</th> -->
            <th data-options="field:'username',width:150,halign:'center'">登录名</th>
            <th data-options="field:'creatorName',width:150,halign:'center'">操作人</th>
            <th data-options="field:'functionUrl',width:200,halign:'center'">功能名称</th>
            <th data-options="field:'ipAddr',width:150,halign:'center'">登录IP</th>
            <th data-options="field:'createTime',width:180,halign:'center'">操作时间</th>
        </tr>
    </thead>
</table>
<div id="adminDlg"></div>
<script>

	function searchQuery() {
		$(this).linkbutton('search', {grid:'#logGrid', form:'#searchLog'});
	}
	
	function clearQuery() {
		$(this).linkbutton('clearQuery', '#logGrid');
	}

</script>
</body>
</html>