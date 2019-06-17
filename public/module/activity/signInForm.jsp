<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ include file="/module/common.jsp"%>
<!DOCTYPE html>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>
	<div id="toobar">
		<form id="form" method="post">
			<input name="activityId" value="${activityId}" type="hidden">
			
		</form>
	</div>
	<table id="dIntegral" class="easyui-datagrid"
		data-options="url:'${urlPath}activity/signInPage.do?activityId=${activityId}',
				  toolbar:'#toobar',				
				  fit:true
				  ">
		<thead>
			<tr>
				<th data-options="field:'aliasName',width:'13%',align:'center',halign:'center'">昵称</th>
				<th data-options="field:'telephone',width:'10%',align:'center',halign:'center'">联系电话</th>
				<th
					data-options="field:'signStatus',width:'14%',align:'center',halign:'center',formatter:formatters.signStatus">签到</th>
				<th data-options="field:'createTime',width:'12%',align:'center',halign:'center'">参与时间</th>
			</tr>
		</thead>
	</table>
	<script >
		var formatters = {
				signStatus:function(v){
					return {
						0 : '-',
						1 : '已签到'
					}[v];
				}
		}
	</script>
</body>
</html>