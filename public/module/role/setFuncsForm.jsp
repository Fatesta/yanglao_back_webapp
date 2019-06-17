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
    <form id="roleForm" method="post">
    	<input type="hidden" id="roleId" name="roleId" value="${role.id }">
    	<table class="form">
	    	<tr>
	    		<td>
	    			<ul id="funcMenu"></ul>
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
		
		$(function(){
			$('#funcMenu').tree({
				url:'${urlPath}role/listRoleFuncsTree.do?id=${role.id }',
			    checkbox:true,
			    animate:false,
			    cascadeCheck: false,
			    onLoadSuccess: function() {
			        $(this).tree('collapseAll');
			    }
			});
		});
		
	</script>
</body>
</html>