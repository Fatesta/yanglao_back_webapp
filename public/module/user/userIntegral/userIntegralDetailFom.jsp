<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/module/common.jsp" %>
<!DOCTYPE html>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>
	<div id="toolbar">
		<form id="form" method="post" >
		<input type="hidden" name="accountId" value="${accountId }" /> 
			 <table class="form">
				
				<td>开始时间</td>
					<td><input class="easyui-datebox filter"
						name="startCreateTime" type="text" style="width: 100px"></td>
					<td>结束时间</td>
					<td><input class="easyui-datebox filter"
						name="endCreateTime" type="text" style="width: 100px"></td>				
				<td colspan="6">
				<a href="#" class="easyui-linkbutton"
					data-options="iconCls:'icon-search'" name="query" onclick="searchUser()">查询</a>
				</td> 
			</table>
		</form>
	</div>
	<table id="dgIntegral" class="easyui-datagrid"
		data-options="url:'${urlPath}userIntegral/integralDetail.do',
				  toolbar:'#toolbar',
				  queryParams: {accountId :'${accountId}'},
				  fit:true
				  ">
		<thead>
			<tr>
				<th data-options="field:'silverDetail',width:60,halign:'center'">积分</th>
				<th data-options="field:'operationType',width:130,halign:'center',formatter: UICommon.datagrid.formatter.generators.dict(DictMan.itemMap('integral.operationType'))">说明</th>
				<th data-options="field:'createTime',width:130,halign:'center'">记录时间</th>
			</tr>
		</thead>
	</table> 
	
<script >
 $("[name=query]").click(
		function() {
			var params = $("#toolbar #form").serializeObject();
			// 设置时间为当天
			params.startCreateTime = params.startCreateTime
					&& params.startCreateTime + " 00:00:00";
			params.endCreateTime = params.endCreateTime && params.endCreateTime
					+ " 23:59:59";
			//如果表格url为空,则给他重新定义个路径
			if ($("#dgIntegral").datagrid("options").url == null) {
				$("#dgIntegral").datagrid({
					url : CONFIG.baseUrl + "userIntegral/integralDetail.do",

					fit : true,
					queryParams : params
				});
			} else {
				$("#dgIntegral").datagrid("load", params);
			}
		}); 
 
</script>
</body>
</html>