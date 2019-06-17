<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <%@ include file="/module/common.jsp" %>
</head>
<body>
	<div id="tbrCommunityBerthType">
	    <form name="frmQuery">
			<table class="form">
			   <tr>
		            <c:forEach var="func" items="${ROLE_FUNCS}">
						<td><a name="${func.code}" class="easyui-linkbutton" data-options="iconCls:'${func.icon}'">${func.funcName}</a></td>
		            </c:forEach>
				</tr>
			</table>
	    </form>
	</div>
	<table id="dgCommunityBerthType" class="easyui-datagrid" toolbar="#tbrCommunityBerthType"
	   data-options="
	       url: '${urlPath}community/berth/berthType/page.do'">
	    <thead>
	        <tr>
	            <th data-options="field:'name', width:'150', halign: 'center', align:'left'">名称</th>
	            <th data-options="field:'monthPrice', width:'100', halign: 'center', align:'center'">每月价格</th>
	            <th data-options="field:'remark', width:'500', halign: 'center', align:'left', formatter: berthType.formatters.remark">说明</th>
	        </tr>
	    </thead>
	</table>
	<script src="${modulePath}community/berth/berthType/berthType.js?v=1"></script>
</body>
</html>