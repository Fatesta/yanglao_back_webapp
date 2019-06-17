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
      	<div id="doctorToolbar">
       	<form id="searchDoctorForm" method="post">
		    <table class="form">
		   		<tr>
		    		<td>
						医生姓名
					</td>
					<td style="width: 550px;">
						<input class="easyui-textbox filter" name="realName" type="text">
						<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'"
		            		onclick="searchDoctor()">查询</a>
					</td>
				</tr>
		    </table>
		</form>
      	</div>
       	<table id="doctorGrid" class="easyui-datagrid"
			data-options="url:'${urlPath }health/listDoctor.do',
						  fit:true,
						  fitColumns:true,
						  queryParams:{
						  	orgId:'${org.id }'
						  },
						  toolbar:'#doctorToolbar'">
		    <thead>
		        <tr>
		            <th data-options="field:'realName',width:'16%',halign:'center'">姓名</th>
		            <th data-options="field:'phone',width:'25%',halign:'center'">电话</th>
		            <th data-options="field:'email',width:'25%',halign:'center'">邮箱</th>
		            <th data-options="field:'remark',width:'34%',halign:'center'" formatter="formatters.remark">备注</th>
		        </tr>
		    </thead>
		</table>

<script>
var formatters = {
	remark: function(value) {
		return "<span href=javascript:; class=easyui-tooltip title='{0}'>{1}</span>".format(value, value);
	}
}

function searchDoctor() {
	$("#doctorGrid").datagrid("load", $("#searchDoctorForm").serializeObject());
}

</script>
</body>
</html>