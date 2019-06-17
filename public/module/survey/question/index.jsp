<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/module/common.jsp" %>
</head>
<body class="easyui-layout">
    <div data-options="region:'center',split:true" style="height:60%;">
		<div id="tbrQuestion">
		    <form id="frmQuery">
				<table class="form">
				   <tr>
			           <td>内容</td>
			           <td>
			               <input class="easyui-textbox" name="content" type="text">
			           </td>
                       <td>题型</td>
		                <td>
		                    <input id="type" name="type" class="easyui-combobox"
		                      data-options="
		                          editable: false,
		                          data: [{v: '', t: '全部'},{v: '0', t: '问答'}, {v: 1, t: '单选'}, {v: 2, t: '多选'}],
		                          valueField: 'v',
		                          textField: 't'"
		                      style="width:100px;">
		                </td>
			           <td>
			               <a id="query" class="easyui-linkbutton" data-options="iconCls:'icon-search'">查询</a>
			           </td>
			           <c:forEach var="func" items="${ROLE_FUNCS}">
			               <c:if test="${func.code != 'manageQuestionOption'}">
			               <td><a id="${func.code}" class="easyui-linkbutton" data-options="iconCls:'${func.icon}'">${func.funcName}</a></td>
			               </c:if>
			           </c:forEach>
					</tr>
				</table>
		    </form>
		</div>
		<table id="dgQuestion" class="easyui-datagrid" toolbar="#tbrQuestion">
		    <thead>
		        <tr>
		            <th data-options="field:'orderno', width:'4%', halign: 'center', align:'center'">序号</th>
		            <th data-options="field:'content', width:'70%', halign: 'center', align:'left', formatter: UICommon.datagrid.formatter.generators.omit({dgId: 'dgQuestion', min: 80, field: 'content'})">内容</th>
		            <th data-options="field:'type', width:'4%', halign: 'center', align:'center', formatter: formatters.type">题型</th>
		        	</tr>
		    </thead>
		</table>
    </div>
    
    <div data-options="title:'选择题选项', region:'south',split:true,collapsible:true,collapsed:true" style="height:40%">
        <%@ include file="option/optionDatagrid.jsp" %>
    </div>
    
<script>
var PAGE_CONFIG = {surveyId: '${surveyId}'};
</script>
<script src="${modulePath}survey/question/formatters.js"></script>
<script src="${modulePath}survey/question/option/questionOption.js"></script>
<script src="${modulePath}survey/question/question.js"></script>
<script>
new QuestionOptionManager(questionManager);
questionManager.query();
</script>
</body>
</html>