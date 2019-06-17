<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/module/common.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<body>

<div id="gridToolbar">
<form id="searchForm">
	<table class="form">
		<tr>
			<td>咨询时间</td>
			<td>
				<input class="easyui-datebox filter" name="createTime" type="text">
			</td>
			<td>
				状态
			</td>
			<td>
				<select class="easyui-combobox filter" name="status" style="width: 100px;">
			        <option value="" selected="selected">全部</option>
			        <option value="1">等待开始</option>
			        <option value="2">正在咨询</option>
			        <option value="3">等待结束</option>
			        <option value="4">完成</option>
			    </select>
			</td>
			<td colspan="6">
				<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'"
			            onclick="searchA()">查询</a>
			</td>
		</tr>
	</table>
</form>
</div>
<table id="dgConsultation" class="easyui-datagrid"
	data-options="url:'${urlPath }health/inquiryRecords.do?userId=${medicalUser.userId}',
				  multiSort:true,
				  fit:true,
				  toolbar:'#gridToolbar'">
    <thead>
        <tr>
            <th data-options="field:'createTime',width:'10%',align:'left'">咨询时间</th>
            <th data-options="field:'doctorName',width:'10%',align:'left'">预约医生</th>
            <th data-options="field:'status',width:'10%',align:'left', formatter:formatStatus" >状态</th>
            <th data-options="field:'medicalResult',width:'30%',align:'left', formatter:formatMedicalResult">医生诊断意见</th>
        </tr>
    </thead>
</table>
<script src="${modulePath}health/consultation.manager.js"></script>
</body>
</html>