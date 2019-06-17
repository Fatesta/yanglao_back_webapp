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
<table id="dg" class="easyui-datagrid" toolbar="#tbr"
    data-options="url:'${urlPath}user/address/page.do',
                  queryParams: {userId: '${userId}'},
                  fit:true">
    <thead>
        <tr>
            <th data-options="field:'provAreaCity', width: 150, halign: 'center', align:'left', formatter: formatters.provAreaCity">省市区</th>
            <th data-options="field:'address', width: 300, halign: 'center', align:'left'">详细地址</th>
            <th data-options="field:'linkman', width: 100, halign: 'center', align:'left', formatter: formatters.linkman">收货人</th>
            <th data-options="field:'linkphone', width: 100, halign: 'center', align:'left'">手机</th>
            <th data-options="field:'flag', width: 60, align: 'center', formatter: formatters.flag">是否默认</th>
            <th data-options="field:'isvalid', width: 60, align: 'center', formatter: formatters.isvalid">是否启用</th>
            <th data-options="field:'createTime', width: 130, halign: 'center', align:'left'">创建时间</th>
            <th data-options="field:'updateTime', width: 130, halign: 'center', align:'left'">最后更新时间</th>
        	</tr>
    </thead>
</table>
<script>
var PAGE_CONFIG = {userId: '${userId}'};
</script>
<script src="${libPath}cityselect.js"></script>
<script src="${modulePath}user/address/index.js?v=1"></script>

</body>
</html>