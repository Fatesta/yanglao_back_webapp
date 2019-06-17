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
<!--                <td>服务ID</td> -->
<!--                <td> -->
<%--                    <input class="easyui-textbox filter" name="serviceId" value="${serviceId}" type="text" style="width: 110px;"> --%>
<!--                </td> -->
               <td>订单状态</td>
               <td>
                   <select class="easyui-combobox" id="status" name="status" style="width: 100px;"></select>
               </td>
	           <td>
	               <a id="query" class="easyui-linkbutton" data-options="iconCls:'icon-search'">查询</a>
	           </td>
	           <c:forEach var="func" items="${ROLE_FUNCS}">
	               <td><a id="${func.code}" class="easyui-linkbutton" data-options="iconCls:'${func.icon}'">${func.funcName}</a></td>
	           </c:forEach>
			</tr>
		</table>
    </form>
</div>
<table id="dg" class="easyui-datagrid" toolbar="#tbr"
    data-options="url:'${urlPath}volunteer/order/page.do',
                  queryParams: {serviceId: '${serviceId}'},
                  fit:true">
    <thead>
        <tr>
            <th data-options="field:'orderno', width:'150', halign: 'center', align:'left'">订单号</th>
            <th data-options="field:'status', width:'100', halign: 'center', align:'left', formatter: formatters.status">订单状态</th>
            <th data-options="field:'receiveUserName', width:'100', halign: 'center', align:'left'">接单用户</th>
            <th data-options="field:'remark', width:'100', halign: 'center', align:'left'">备注</th>
            <th data-options="field:'createTime', width:'130', halign: 'center', align:'left'">接单时间</th>
            <th data-options="field:'updateTime', width:'130', halign: 'center', align:'left'">更新时间</th>
        	</tr>
    </thead>
</table>

<script src="${modulePath}volunteer/order/index.js?v=1"></script>

</body>
</html>