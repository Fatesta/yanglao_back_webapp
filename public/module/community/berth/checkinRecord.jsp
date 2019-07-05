<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <%@ include file="/module/common.jsp" %>
</head>
<body>
    <div id="tbrBerthCheckin">
        <form name="frmQuery">
            <table class="form">
               <tr>
                </tr>
            </table>
        </form>
    </div>
    <table id="dgBerthCheckin" class="easyui-datagrid" toolbar="#tbrBerthCheckin"
        data-options="
            url: '${urlPath}community/berth/checkinRecord/page.do',
            queryParams: {berthId: '${berthId}', resthomeId: '${resthome_id}'}">
        <thead>
            <tr>
                <th data-options="field:'id',width:60,align:'center'">ID</th>
	            <th data-options="field:'berthNo',width:160,halign:'center', formatter: berthCheckin.formatters.berthNo">入住床位号</th>
	            <th data-options="field:'userName',width:80,halign:'center'">入住人</th>
	            <th data-options="field:'userIdcard',width:140, halign:'center'">入住人身份证号</th>
	            <th data-options="field:'startTime',width:90,align:'center'">入住日期</th>
	            <th data-options="field:'endTime',width:90,align:'center', formatter: berthCheckin.formatters.endTime">退住日期</th>
	            <th data-options="field:'days',width:90,align:'center', formatter: berthCheckin.formatters.days">入住时长</th>
	            <th data-options="field:'deposit',width:80,align:'center'">已付押金</th>
	            <th data-options="field:'paidMoney',width:80,align:'center'">已付款</th>
	            <th data-options="field:'amount',width:100,align:'center', formatter: berthCheckin.formatters.amount">总费用</th>
	            <th data-options="field:'state',width:160,halign:'center', formatter: berthCheckin.formatters.state">状态</th>
	            <th data-options="field:'createTime',width:130,align:'center'">入住记录创建时间</th>
	            <th data-options="field:'op',width:70,align:'center', formatter: berthCheckin.formatters.op">操作</th>
            </tr>
        </thead>
    </table>
	<script src="${modulePath}community/berth/tool.js"></script>
	<script src="${modulePath}community/berth/checkinRecord.js?v=1.1"></script>
</body>
</html>