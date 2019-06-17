<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>

<div id="tbrPlan">
    <table class="form">
    <tr>
    <c:forEach var="func" items="${ROLE_FUNCS}">
    <td><a id="${func.code}" class="easyui-linkbutton" data-options="iconCls:'${func.icon}'">${func.funcName}</a></td>
    </c:forEach>
</tr>
</table>
</div>
<table id="dgPlan" class="easyui-datagrid" toolbar="#tbrPlan">
    <thead>
    <tr>
    <th data-options="field:'planDate', width: 90, align: 'center'">计划日期</th>
    <th data-options="field:'planTime', width: 70, align: 'center'">计划时间</th>
    <th data-options="field:'productName', width: 200, halign: 'center'">服务产品名称</th>
    <th data-options="field:'providerName', width: 200, halign: 'center'">产品所属店铺</th>
    <th data-options="field:'state', width: 80, align: 'center', formatter: formatters.status">状态</th>
    <th data-options="field:'createTime', width: 130, align: 'center'">计划创建时间</th>
    </tr>
    </thead>
</table>

