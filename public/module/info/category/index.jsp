<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/module/common.jsp" %>
</head>
<body>
<div id="tbr">
    <form id="frmQuery">
		<table class="form">
		   <tr>
	           <c:forEach var="func" items="${ROLE_FUNCS}">
	               <td><a id="${func.code}" class="easyui-linkbutton" data-options="iconCls:'${func.icon}'">${func.funcName}</a></td>
	           </c:forEach>
			</tr>
		</table>
    </form>
</div>
<table id="dg" class="easyui-treegrid" toolbar="#tbr"
    data-options="url:'${urlPath}info/category/tree.do',
			      idField:'id',
			      treeField:'name',
                  fit:true">
    <thead>
        <tr>
            <th data-options="field:'name', width:'16%', halign: 'center', align:'left'">名称</th>
            <th data-options="field:'remark', width:'16%', halign: 'center', align:'left', formatter: UICommon.datagrid.formatter.generators.omit({field: 'remark'})">简介</th>
            <th data-options="field:'free', width:'4%', halign: 'center', align:'left', formatter: formatters.free">是否免费</th>
            <th data-options="field:'id', width:'10%', halign: 'center', align:'left'">ID</th>
            <th data-options="field:'sort', width:'6%',halign: 'center', align:'left'">序号</th>
        	</tr>
    </thead>
</table>

<script src="${modulePath}info/category/index.js"></script>

</body>
</html>