<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/module/common.jsp" %>
</head>
<body class="easyui-layout">
	<div data-options="region:'center', title:'优惠券批次',split:true,collapsible:true" style="height:60%;display:none">
	   <%@ include file="datagrid.jsp" %>
    </div>
    
    <div data-options="region:'south', title:'发放和使用情况', split:true, collapsible:true" style="height:40%;display:none">
        <table id="dgCouponBatchUser" class="easyui-datagrid">
            <thead>
                <tr>
                    <th data-options="field:'batchId', width:80, align:'center'">批次</th>
                    <th data-options="field:'couponNumber', width:100, align:'center'">劵编号</th>
		            <th data-options="field:'username', width:100, halign:'center'">领取用户</th>
		            <th data-options="field:'createTime', width:130, align:'center'">领取时间</th>
                    <th data-options="field:'usingTime', width:130, align:'center'">使用时间</th>
		            <th data-options="field:'status', width:'5%', align:'center', formatter: formatters.couponUser.status">状态</th>
                </tr>
            </thead>
        </table>
    </div>
<script src="${modulePath}coupon/batch/formatters.js?v=1.1"></script>
<script src="${modulePath}coupon/batch/index.js?v=1.2"></script>
<script src="${modulePath}shop/pro/select.js?v=1.2"></script>
</body>
</html>