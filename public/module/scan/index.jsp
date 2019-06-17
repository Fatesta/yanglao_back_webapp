<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/module/common.jsp" %>
    <script src="${libPath}utils/require.js"></script>
    <script><jsp:include page="/lib/utils/require-config.js" /></script>
</head>
<body>
<div id="tbr">
    <form id="frmQuery">
		<table class="form">
		   <tr>
                <td>标题</td>
                <td>
                    <input class="easyui-textbox" name="title" type="text">
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
    data-options="url:'${urlPath}scan/page.do',
	    fit:true,
	    onLoadSuccess: onLoadSuccess">
    <thead>
        <tr>
            <th data-options="field:'title', width:'240', halign: 'center', align:'left'">标题</th>
            <th data-options="field:'type', width:'80', align:'center', formatter: formatters.type">类型</th>
            <th data-options="field:'resourceTitle', width:'360', halign: 'center', align:'left', formatter: formatters.resourceTitle">资源</th>
            <th data-options="field:'resourceId', width:'80', halign: 'center', align: 'left', formatter: formatters.resourceId">资源ID</th>
            <th data-options="field:'sendPoint', width:'60', align: 'center'">赠送积分</th>
            <th data-options="field:'status', width:'60', align: 'center', formatter: formatters.status">状态</th>
            <th data-options="field:'isvalid', width:'60', align: 'center', formatter: formatters.isvalid">是否可用</th>
            <th data-options="field:'publisher', width:'100', halign: 'center', align:'left'">发布用户</th>
            <th data-options="field:'createTime', width:'130', halign: 'center', align:'left'">创建时间</th>
            <th data-options="field:'updateTime', width:'130', halign: 'center', align:'left'">更新时间</th>
            <th data-options="field:'qrcode', width:'50', align: 'center', formatter: formatters.qrcode">二维码</th>
        	</tr>
    </thead>
</table>

<script src="${modulePath}scan/index.js?v=1.3"></script>
<script src="${modulePath}shop/pro/providerToProductSelect.js"></script>

</body>
</html>