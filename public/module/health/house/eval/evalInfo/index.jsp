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
		       <td colspan="10">
               <c:forEach var="func" items="${ROLE_FUNCS}" varStatus="st">
                   <a id="${func.code}" data-funcid="${func.id}" class="easyui-linkbutton" data-options="iconCls:'${func.icon}'">${func.funcName}</a>
               </c:forEach>
               </td>
		   </tr>
		   <tr>
	           <td>标题</td>
	           <td>
	               <input class="easyui-textbox" name="title" type="text" style="width:264px">
	           </td>
	           <td colspan="8">
	               <a id="query" class="easyui-linkbutton" data-options="iconCls:'icon-search'">查询</a>
	           </td>
			</tr>
		</table>
    </form>
</div>
<table id="dgEvalInfo" class="easyui-datagrid" toolbar="#tbr"
    data-options="url:'${urlPath}health/house/eval/evalInfo/page.do',
                  fit:true">
    <thead>
        <tr>
			<th data-options="field:'imgUrl', width:60, halign: 'center', align:'left', formatter: UICommon.datagrid.formatter.generators.image({width: 60, height: 50})">图片</th>
            <th data-options="field:'title', width:200, halign: 'center', align:'left'">标题</th>
            <th data-options="field:'content', width:500, halign: 'center', align:'left', formatter: UICommon.datagrid.formatter.generators.omit({dgId: 'dgEvalInfo', min: 40, field: 'content'})">简介</th>
            <th data-options="field:'state', width:80, halign: 'center', align:'center', formatter: formatters.state">状态</th>
            <th data-options="field:'createTime', width:130, halign: 'center', align:'left'">创建时间</th>
            <th data-options="field:'updateTime', width:130, halign: 'center', align:'left'">更新时间</th>
        	</tr>
    </thead>
</table>

<script src="${modulePath}health/house/eval/evalInfo/evalInfo.js"></script>

</body>
</html>