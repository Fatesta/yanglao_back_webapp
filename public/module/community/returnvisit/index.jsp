<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <%@ include file="/module/common.jsp" %>
    <style>
 .datagrid-tail-button{
display:block;
width:40px;
height:20px;
border:1px solid #CCC;
background:#FFF;
    color: #404040;
}
    </style>
</head>
<body>
<c:if test="${userId ==null}">
<div id="tbrReturnvisit">
    <form name="frmQuery">
		<table class="form">	
		   <tr>
	   		<td>回访用户</td>
			<td>
				<input class="easyui-textbox filter" name="userName" type="text" style="width: 80px;">
			</td>
			<td>
				手机号码
			</td>
			<td>
				<input class="easyui-textbox filter" name="telephone" type="text" style="width: 100px;">
			</td>
          
           <td colspan="7">
               <a name="query" class="easyui-linkbutton" data-options="iconCls:'icon-search'">查询</a>
           </td>
	            <c:forEach var="func" items="${ROLE_FUNCS}">
					<td><a name="${func.code}" class="easyui-linkbutton" data-options="iconCls:'${func.icon}'">${func.funcName}</a></td>
	            </c:forEach>
			</tr>
		</table>
    </form>
</div>
</c:if>
<table id="dgReturnvisit" class="easyui-datagrid"
    data-options="
        url: '${urlPath}community/returnvisit/page.do',
        queryParams: {userId: '${userId}'}
    "
    toolbar="#tbrReturnvisit">
    <thead>
        <tr>
            <th data-options="field:'userName', width:'80', halign: 'center', align:'left'">回访用户</th>
            <th data-options="field:'telephone', width:'120', halign: 'center', align:'center'">联系电话</th>
            <th data-options="field:'contactname', width:'80', halign: 'center', align:'left'">紧急联系人</th>
            <th data-options="field:'contacttelephone', width:'120', halign: 'center', align:'left'">紧急联系人电话</th>
            <th data-options="field:'visitTime', width:'130', halign: 'center', align:'left'">回访时间</th>
            <th data-options="field:'subject', width:'200', halign: 'center', align:'left', formatter: returnvisit.formatters.subject">回访内容</th>
            <th data-options="field:'visitor', width:'80', halign: 'center', align:'left'">工作人员</th>
            <th data-options="field:'score', width:'100', halign: 'center', align:'center', formatter: returnvisit.formatters.score">星级评分</th>
            <th data-options="field:'_', width:'90', halign: 'center', align:'center', formatter: returnvisit.formatters.oper">操作</th>            
        	</tr>
    </thead>
</table>
<script src="${modulePath}community/returnvisit/returnvisit.js"></script>
</body>
</html>
