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
    <form id="housekeepingOrderForm" method="post">
    	<input type="hidden" name="id" value="${order.id }">
    	<input type="hidden" id="baiduLongitude" name="baiduLongitude" value="${order.baiduLongitude }">
    	<input type="hidden" id="baiduLatitude" name="baiduLatitude" value="${order.baiduLatitude }">
	    <table class="form">
	    	<tr>
	    		<td><label for="orderNo">订单号</label></td>
	    		<td><input class="easyui-textbox" name="orderNo" value="${order.orderNo}" data-options="required:true,validType:'length[1,50]'"></td>
	    		<td><label for="type">服务类型</label></td>
	    		<td>
	    			<input class="easyui-combobox" name="type" value='${order.type == null ? "1" : order.type}' 
	    				data-options="required:true,editable:false,valueField:'label',textField:'value',
								data:[{label:'1',value:'保姆'}]">
	    		</td>
	    	</tr>
	    	<tr>
	    		<td><label for="employerName">雇主名称</label></td>
	    		<td><input class="easyui-textbox" name="employerName" value="${order.employerName}" data-options="required:true,validType:'length[1,50]'"></td>
	    		<td><label for="employerTelphone">雇主电话</label></td>
	    		<td><input class="easyui-textbox" name="employerTelphone" value="${order.employerTelphone}" data-options="required:true,validType:'length[1,20]'"></td>
	    	</tr>
	    	<tr>
	    		<td><label for="startTime">开始时间</label></td>
	    		<td><input class="easyui-datetimebox" name="startTime" data-options="required:true" value="${order.startTime}"></td>
	    		<td><label for="endTime">结束时间</label></td>
	    		<td><input class="easyui-datetimebox" name="endTime" data-options="required:true" value="${order.endTime}"></td>
	    	</tr>
	    	<tr>
	    		<td><label for="reward">酬金</label></td>
	    		<td><input class="easyui-numberbox" name="reward" value="${order.reward}" data-options="required:true,min:0,precision:2"></td>
	    		<td><label for="address">自动匹配</label></td>
	    		<td><input type="checkbox" name="auto" checked="checked"></td>
	    	</tr>
	    	<tr>
	    		<td><label for="address">工作地址</label></td>
	    		<td colspan="3"><input class="easyui-textbox" id="address" name="address" value="${order.address}" data-options="required:true,readonly:true,validType:'length[1,100]'" style="width: 370px;"></td>
	    	</tr>
	    	<tr>
	    		<td><label for="reward">工作内容</label></td>
	    		<td colspan="3"><textarea name="remark" rows="3" cols="45" style="width: 370px;" class="easyui-validatebox" data-options="validType:'length[0,500]'">${order.remark}</textarea></td>
	    	</tr>
	    </table>
	</form>
	<script>
	var lng = $("#baiduLongitude").val();
	var lat = $("#baiduLatitude").val();
	// 创建地址解析器实例
	var geoc = new BMap.Geocoder();
	geoc.getLocation(new BMap.Point(lng, lat), function(rs){
		//rs.address
		$("#address").textbox("setValue", rs.address);
	});
	</script>
</body>
</html>