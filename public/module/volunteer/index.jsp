<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <%@ include file="/module/common.jsp" %>
</head>
<body>
<div id="tbrVolunteer">
    <form name="frmQuery">
        <input name="publisher" value="" type="hidden">
		<table class="form">
		   <tr>
               <td>发布者</td>
               <td id="selectPublisher" >
                   <input id="publisherName" class="easyui-textbox filter" type="text" readonly style="width: 100px;">
               </td>
               <c:if test="${curAdmin.roleId == 1 || curAdmin.roleId == 13 || curAdmin.roleId == 14 || curAdmin.roleId == 15}">
                   <td><label for="orgId">社区</label></td>
                   <td>
                       <input class="easyui-combobox" name="orgId" style="width:200px;"
                              data-options="required:true,
		                            valueField:'id',
		                            textField:'name',
		                            url:'${urlPath }org/communities.do',
		                            checkbox: true,
		                            loadFilter: function(arr) {
		                              arr.unshift({id: '', name: '全部'});
		                              return arr;
		                            },
		                            value: '${empty orgId ? '' : orgId}'" />
                   </td>
               </c:if>
               <td>任务状态</td>
               <td>
                   <input id="orderStatus" class="easyui-combobox filter" name="orderStatus" style="width: 100px;">
               </td>
               <td>发布时间</td>
               <td>
                   <input class="easyui-datebox filter" name="startCreateTime" type="text" style="width:100px;">
                   <span>~</span>
                   <input class="easyui-datebox filter" name="endCreateTime" type="text" style="width:100px;">
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
<table id="dgVolunteer" class="easyui-datagrid" toolbar="#tbrVolunteer"
    data-options="url:'${urlPath}volunteer/help/page.do',
                  fit:true">

    <thead>
        <tr>
            <th data-options="field:'createTime',width:130,align:'center'">发布时间</th>
            <th data-options="field:'profession', width:'120', halign: 'center', align:'left'">服务类型</th>
            <th data-options="field:'planDateAndServiceTime', width:'130', align: 'center', formatter: volunteer.formatters.planDateAndServiceTime">服务时间</th>
            <th data-options="field:'serviceDuration', width:'80', halign: 'center', align:'left', formatter: volunteer.formatters.serviceDuration">服务时长</th>
            <th data-options="field:'taskIntegral', width:'70', align: 'center'">公益积分</th>
            <th data-options="field:'publisher', width:'160', halign: 'center', align:'left', formatter: volunteer.formatters.publisher">发布者</th>
            <th data-options="field:'customer', width:'160', halign: 'center', align:'left', formatter: volunteer.formatters.customer">服务对象</th>
            <th data-options="field:'address', width:'180', halign: 'center', align:'left'">服务地址</th>
            <th data-options="field:'orderStatus', width:'100', halign: 'center', align:'center', formatter: volunteer.formatters.orderStatus">任务状态</th>
            <th data-options="field:'orgName', width:'100', halign: 'center', align:'left'">所属社区</th>
            <th data-options="field:'-',width:90,align:'center', formatter: volunteer.formatters.op">操作</th>
        	</tr>
    </thead>
</table>

<script src="${modulePath}user/select.js"></script>
<script src="${modulePath}volunteer/index.js?v=5"></script>
</body>
</html>