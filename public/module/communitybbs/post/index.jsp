<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/module/common.jsp" %>
<script src="${libPath}utils/require.js"></script>
<script><%@ include file="/lib/utils/require-config.js" %></script>
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
    data-options="url:'${urlPath}communitybbs/post/page.do',
                  fit:true">
    <thead>
        <tr>
			<th data-options="field:'thumbnailUrl', width:100, halign: 'center', align:'left', formatter: formatters.thumbnailUrl">缩略图</th>
            <th data-options="field:'title', width:300, halign: 'center', align:'left'">标题</th>
            <th data-options="field:'status', width:60, align: 'center', formatter: formatters.status">状态</th>
            <th data-options="field:'realName', width:100, halign: 'center', align:'left'">发布管理员</th>
            <th data-options="field:'createTime', width:130, halign: 'center', align:'left'">创建时间</th>
            <th data-options="field:'updateTime', width:130, halign: 'center', align:'left'">更新时间</th>
            <th data-options="field:'isTop', width:50, align: 'center', formatter: UICommon.datagrid.formatter.generators.dict(DictMan.itemMap('yesnoempty'))">置顶</th>
            <th data-options="field:'topTime', width:130, halign: 'center', align:'left'">置顶时间</th>
        	</tr>
    </thead>
</table>

<script src="${modulePath}communitybbs/post/post.js?v=20190530"></script>

</body>
</html>