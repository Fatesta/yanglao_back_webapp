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
    <form id="adminForm" method="post">
    	<input type="hidden" name="adminId" value="${admin.id }">
    	<table class="form">
	    	<tr>
	    		<td><label for="username">用户名</label></td>
	    		<td><input class="easyui-textbox" name="username" value="${admin.username}" style="width:250px;" 
	    			data-options="required:true,validType:'length[6,20]'<c:if test="${admin.id != null}">,disabled:true</c:if>" >
	    		</td>
	    	</tr>
	    	<tr>
	    		<td><label for="roleIds">角色</label></td>
	    		<td>
	    			<select class="easyui-combogrid" name="roleIds" style="width:250px;"
        				data-options="
				        		multiple:false,
				            	panelWidth:450,
				            	idField:'id',
				            	textField:'roleName',
				            	url:'${urlPath }role/listRole.do?id=${admin.id }',
				            	value:'${roleId}',
				            	columns:[[
					                {field:'id',title:'ID'},
					                {field:'roleName',title:'角色名',width:100,halign:'center'},
					                {field:'status',title:'是否激活',width:50,halign:'center',formatter:formatStatus},
					                {field:'remark',title:'备注',width:250,halign:'center'}
					            ]]"></select>
	    		</td>
	    	</tr>
	    </table>
	</form>
	<script>

		function formatStatus(value,rowData,rowIndex) {
			if (value == 1) {
	    		return "<div class='icon-ok'>&nbsp</div>";
	    	}
	    	return "<div class='icon-cancel'>&nbsp</div>";
		}
	
	</script>
</body>
</html>