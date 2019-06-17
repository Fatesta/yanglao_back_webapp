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
    <form id="setAvtiveZoneForm" method="post">
    	<input type="hidden" name="deviceUserId" value="${security.deviceUserId }">
	    <table class="form">
	    	<tr>
	    		<td><label for="title">标题</label></td>
	    		<td>
	    			<input class="easyui-textbox" name="title" data-options="required:true,validType:'length[1,50]'" value="${security.title == null?'活动区域':security.title}" style="width:300px">
	    		</td>
	    	</tr>
			<tr>
				<td>经度</td>
				<td><input name="longitude" class="easyui-numberbox" data-options="precision:12,readonly:true,value:${security.longitude }" style="width:120px"/></td>
			</tr>
			<tr>
				<td>纬度</td>
				<td><input name="latitude" class="easyui-numberbox" data-options="precision:12,readonly:true,value:${security.latitude }" style="width:120px"/></td>
			</tr>
	    	<tr>
	    		<td><label for="radius">范围</label></td>
	    		<td style="padding: 20px;">
	    		<input class="easyui-slider" name="radius" value="${security.radius}" style="width:300px;"
        			data-options="showTip:true,min:200,max:1500,step:100,tipFormatter: function(value){
        				return value + '米';
    				}"></td>
	    	</tr>
	    </table>
	</form>
</body>
</html>