<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <%@ include file="/module/common.jsp" %>
</head>
<body>
    <div id="tbrBerthCheckinPayRecord">
        <form name="frmQuery">
            <table class="form">
               <tr>
                </tr>
            </table>
        </form>
    </div>
    <table id="dgBerthCheckinPayRecord" class="easyui-datagrid" toolbar="#tbrBerthCheckinPayRecord"
        data-options="
            url: '${urlPath}community/berth/payrecord/page.do',
            queryParams: {checkinId: '${checkinId}'}">
        <thead>
            <tr>
	            <th data-options="field:'type',width:130,align:'center', formatter: formatters.type">金额类别</th>
	            <th data-options="field:'money',width:130,align:'center'">金额</th>
	            <th data-options="field:'operatorUsername',width:130,align:'center'">操作账号</th>
	            <th data-options="field:'createTime',width:130,align:'center'">记录时间</th>
            </tr>
        </thead>
    </table>
	<script src="${modulePath}community/berth/checkinPayRecord.js?v=1.1"></script>
</body>
</html>