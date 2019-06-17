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
    data-options="url:'${urlPath}survey/userAnswer/detail/page.do',
                  queryParams: {surveyId: '${surveyId}', userId: '${userId}'},
                  loadFilter: loadFilter,
                  rownumbers: false,
                  fit:true">
    <thead>
        <tr>
            <th data-options="field:'orderno', width:'4%', halign: 'center', align:'center'">序号</th>
            <th data-options="field:'questionType', width:'4%', halign: 'center', align:'center', formatter: formatters.type">题型</th>
            <th data-options="field:'questionContent', width:'20%', halign: 'center', align:'left', formatter: UICommon.datagrid.formatter.generators.omit({min: 30, field: 'questionContent'})">问题</th>
            <th data-options="field:'text', width:'70%', halign: 'center', align:'left', formatter: UICommon.datagrid.formatter.generators.omit({min: 100, field: 'text'})">答案</th>
        	</tr>
    </thead>
</table>


<script src="${modulePath}survey/question/formatters.js"></script>
<script>
function loadFilter(data) {
    data.rows.forEach(function(row){
        row.text = row.text || row.options.join('&nbsp;&nbsp;、');
    });
    return data;
}
</script>
</body>
</html>