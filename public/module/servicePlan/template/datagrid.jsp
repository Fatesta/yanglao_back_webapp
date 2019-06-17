<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div id="tbrServicePlanTemplate">
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
                   <c:if test="${func.code != 'serviceplan.template.detail'}">
                   <td><a id="${func.code}" class="easyui-linkbutton" data-options="iconCls:'${func.icon}'">${func.funcName}</a></td>
                   </c:if>
               </c:forEach>
            </tr>
        </table>
    </form>
</div>
<table id="dgServicePlanTemplate" class="easyui-datagrid" toolbar="#tbrServicePlanTemplate"
    data-options="url:'${urlPath}servicePlan/template/page.do',
                  queryParams: {state: '${state}'},
                  onSelect: templateManager.onSelect,
                  onLoadSuccess: templateManager.onLoadSuccess,
                  fit:true">
    <thead>
        <tr>
            <th data-options="field:'title', width: 250, halign: 'center', align:'left'">标题</th>
            <th data-options="field:'startDate', width: 100, halign: 'center', align:'left', formatter: UICommon.datagrid.formatter.generators.substring(0, 10)">计划开始日期</th>
            <th data-options="field:'endDate', width: 100, halign: 'center', align:'left', formatter: UICommon.datagrid.formatter.generators.substring(0, 10)">计划结束日期</th>
            <th data-options="field:'totalDuration', width: 50, align: 'center'">总时长</th>
            <th data-options="field:'state', width: 50, halign: 'center', align:'left', formatter: templateManager.formatters.state">状态</th>
            <th data-options="field:'createTime', width: 130, halign: 'center', align:'left'">创建时间</th>
            </tr>
    </thead>
</table>
