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
	               <c:if test="${func.code != 'manageCourse'}">
	               <td><a id="${func.code}" class="easyui-linkbutton" data-options="iconCls:'${func.icon}'">${func.funcName}</a></td>
	               </c:if>
	           </c:forEach>
			</tr>
		</table>
    </form>
</div>
<table id="dg" class="easyui-datagrid" toolbar="#tbr"
    data-options="url:'${urlPath}cardConsume/service/page.do',
                  fit:true">
    <thead>
        <tr>
            <th data-options="field:'serviceName', width:'15%', halign: 'center', align:'left'">服务名称</th>
            <th data-options="field:'serviceCode', width:'12%', halign: 'center', align:'left'">服务编码</th>
            <th data-options="field:'categoryName', width:'8%', halign: 'center', align:'left'">服务类别</th>
            <th data-options="field:'unit', width:'5%', halign: 'center', align:'left'">服务单位</th>
            <th data-options="field:'serviceDesc', width:'20%', halign: 'center', align:'left', formatter: UICommon.datagrid.formatter.generators.omit({min: 15, field: 'serviceDesc'})">服务介绍</th>
            <th data-options="field:'sort', width:'5%', halign: 'center', align:'left'">显示顺序</th>
            <th data-options="field:'-', width:'6%', halign: 'center', align:'left', formatter: formatters.op">操作</th>
        	</tr>
    </thead>
</table>

<script src="${modulePath}cardConsume/service/index.js"></script>

</body>
</html>