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
	    		<td><label for="roleIds">组织</label></td>
	    		<td>
	    			<input class="easyui-combotree" name="orgId" style="width:308px;"
        				data-options="
				            	valueField:'id',
				            	textField:'text',
				            	url:'${urlPath }admin/listOrg.do',
				            	value:'${admin.orgIds }',
				            	checkbox: true,
				            	multiple: ${admin.roleIds == '9' ? false : true}, <%-- 社区管理员单选社区 --%>
				            	cascadeCheck: false" />
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