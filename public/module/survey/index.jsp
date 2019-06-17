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
		       <td colspan="8" class="form">
               <c:forEach var="func" items="${ROLE_FUNCS}" varStatus="st">
                   <a id="${func.code}" data-funcid="${func.id}" class="easyui-linkbutton" data-options="iconCls:'${func.icon}'">${func.funcName}</a>
               </c:forEach>
               </td>
		   </tr>
		   <tr>
	           <td>标题</td>
	           <td>
	               <input class="easyui-textbox" name="title" type="text">
	           </td>
	           <td>日期</td>
	           <td>
	               <input class="easyui-datebox filter" name="beginCreateTime" type="text">
	                            至
	               <input class="easyui-datebox filter" name="endCreateTime" type="text">
	           </td>
	           <td>
	               <a id="query" class="easyui-linkbutton" data-options="iconCls:'icon-search'">查询</a>
	           </td>
			</tr>
		</table>
    </form>
</div>
<table id="dg" class="easyui-datagrid" toolbar="#tbr"
    data-options="url:'${urlPath}survey/surveyInfo/page.do',
                  onSelect: onSelect,
                  fit:true">
    <thead>
        <tr>
            <th data-options="field:'title', width:'20%', halign: 'center', align:'left'">标题</th>
            <th data-options="field:'content', width:'11%', halign: 'center', align:'left', formatter: UICommon.datagrid.formatter.generators.omit({min: 15, field: 'content'})">内容描述</th>
            <th data-options="field:'submitNum', width:'6%', halign: 'center', align:'left'">提交答案人数</th>
            <th data-options="field:'state', width:'5%', halign: 'center', align:'center', formatter: formatters.state">状态</th>
            <th data-options="field:'creatorName', width:'7%', halign: 'center', align:'left'">创建者</th>
            <th data-options="field:'createTime', width:'10%', halign: 'center', align:'left'">创建时间</th>
            <th data-options="field:'updateTime', width:'10%', halign: 'center', align:'left'">最近更新时间</th>
        	</tr>
    </thead>
</table>

<script src="${modulePath}survey/index.js"></script>

</body>
</html>